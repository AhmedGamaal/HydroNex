using System.Text;
using System.Text.Json.Serialization;
using HydroNex.Api.Hubs;
using HydroNex.Api.Services;
using HydroNex.Application.Features.Telemetry;
using HydroNex.Domain.Entities;
using HydroNex.Infrastructure;
using HydroNex.Infrastructure.Persistence;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Identity;
using Microsoft.IdentityModel.Tokens;

var builder = WebApplication.CreateBuilder(args);

// Infrastructure - registers the DbContext, all feature services
// (IAuthService, IFarmService, ICropService, IDashboardService, etc.) and the
// AI HttpClients. Nothing needs re-registering here - see
// HydroNex.Infrastructure/DependencyInjection.cs for the full list.
builder.Services.AddInfrastructure(builder.Configuration);

// Identity
builder.Services
    .AddIdentity<ApplicationUser, IdentityRole>(options =>
    {
        options.User.RequireUniqueEmail = true;

        options.Password.RequiredLength = 6;
        options.Password.RequireNonAlphanumeric = false;
        options.Password.RequireUppercase = false;
        options.Password.RequireDigit = false;
    })
    .AddEntityFrameworkStores<ApplicationDbContext>()
    .AddDefaultTokenProviders();

// JWT
var jwtKey = builder.Configuration["Jwt:Key"]
    ?? throw new InvalidOperationException("JWT Key is not configured.");

var jwtIssuer = builder.Configuration["Jwt:Issuer"]
    ?? throw new InvalidOperationException("JWT Issuer is not configured.");

var jwtAudience = builder.Configuration["Jwt:Audience"]
    ?? throw new InvalidOperationException("JWT Audience is not configured.");

builder.Services
    .AddAuthentication(options =>
    {
        options.DefaultAuthenticateScheme =
            JwtBearerDefaults.AuthenticationScheme;

        options.DefaultChallengeScheme =
            JwtBearerDefaults.AuthenticationScheme;
    })
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,

            ValidIssuer = jwtIssuer,
            ValidAudience = jwtAudience,

            IssuerSigningKey = new SymmetricSecurityKey(
                Encoding.UTF8.GetBytes(jwtKey))
        };
    });

builder.Services.AddAuthorization();

// CORS - dev-only permissive policy. Not needed for the native Flutter mobile
// app (CORS is a browser thing), but keeps Flutter Web / browser-based REST
// clients from getting silently blocked during testing.
builder.Services.AddCors(options =>
    options.AddPolicy("Dev", policy =>
        policy.AllowAnyOrigin().AllowAnyHeader().AllowAnyMethod()));

// SignalR
builder.Services.AddSignalR();
builder.Services.AddScoped<ITelemetryHubPublisher, TelemetryHubPublisher>();

// Digital Twin Simulator has been removed - telemetry is now expected to
// come from an external source (e.g. a Python script) calling
// POST /api/telemetry directly, the same endpoint a real device would use.

// Controllers - enums (GrowthStage, SensorType, RiskLevel, AlertSeverity, etc.)
// now serialize as readable strings instead of raw integers.
builder.Services.AddControllers()
    .AddJsonOptions(options =>
        options.JsonSerializerOptions.Converters.Add(new JsonStringEnumConverter()));

// Swagger
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(options =>
{
    options.AddSecurityDefinition(
        "Bearer",
        new Microsoft.OpenApi.OpenApiSecurityScheme
        {
            Name = "Authorization",
            Type = Microsoft.OpenApi.SecuritySchemeType.Http,
            Scheme = "bearer",
            BearerFormat = "JWT",
            In = Microsoft.OpenApi.ParameterLocation.Header,
            Description = "Enter your JWT token."
        });

    options.AddSecurityRequirement(document =>
        new Microsoft.OpenApi.OpenApiSecurityRequirement
        {
            [new Microsoft.OpenApi.OpenApiSecuritySchemeReference("Bearer", document)] =
                new List<string>()
        });
});

var app = builder.Build();

// Swagger
app.UseSwagger();
app.UseSwaggerUI();

app.UseHttpsRedirection();
app.UseCors("Dev");

// Serves files saved by LocalFileStorageService (e.g. plant image uploads)
// back out from wwwroot - e.g. /uploads/plant-images/{file}. Created up front
// so ASP.NET Core doesn't warn about a missing WebRootPath at startup.
Directory.CreateDirectory(Path.Combine(app.Environment.ContentRootPath, "wwwroot"));
app.UseStaticFiles();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

// SignalR
app.MapHub<MonitoringHub>("/hubs/monitoring");

app.Run();
