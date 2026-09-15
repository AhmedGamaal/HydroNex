using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace HydroNex.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddCropManagementFields : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_Crops_FarmId",
                table: "Crops");

            migrationBuilder.AlterColumn<int>(
                name: "Status",
                table: "Crops",
                type: "int",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(30)",
                oldMaxLength: 30);

            migrationBuilder.AlterColumn<int>(
                name: "GrowthStage",
                table: "Crops",
                type: "int",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(30)",
                oldMaxLength: 30);

            migrationBuilder.AddColumn<string>(
                name: "BatchId",
                table: "Crops",
                type: "nvarchar(100)",
                maxLength: 100,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<int>(
                name: "CycleDuration",
                table: "Crops",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<string>(
                name: "Location",
                table: "Crops",
                type: "nvarchar(250)",
                maxLength: 250,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Notes",
                table: "Crops",
                type: "nvarchar(1000)",
                maxLength: 1000,
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Crops_FarmId_BatchId",
                table: "Crops",
                columns: new[] { "FarmId", "BatchId" },
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_Crops_FarmId_BatchId",
                table: "Crops");

            migrationBuilder.DropColumn(
                name: "BatchId",
                table: "Crops");

            migrationBuilder.DropColumn(
                name: "CycleDuration",
                table: "Crops");

            migrationBuilder.DropColumn(
                name: "Location",
                table: "Crops");

            migrationBuilder.DropColumn(
                name: "Notes",
                table: "Crops");

            migrationBuilder.AlterColumn<string>(
                name: "Status",
                table: "Crops",
                type: "nvarchar(30)",
                maxLength: 30,
                nullable: false,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AlterColumn<string>(
                name: "GrowthStage",
                table: "Crops",
                type: "nvarchar(30)",
                maxLength: 30,
                nullable: false,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.CreateIndex(
                name: "IX_Crops_FarmId",
                table: "Crops",
                column: "FarmId");
        }
    }
}
