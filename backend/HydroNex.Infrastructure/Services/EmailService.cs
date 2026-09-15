using HydroNex.Application.Common;
using HydroNex.Infrastructure.Settings;
using MailKit.Net.Smtp;
using MailKit.Security;
using Microsoft.Extensions.Options;
using MimeKit;

namespace HydroNex.Infrastructure.Services;

public class EmailService : IEmailService
{
    private readonly EmailSettings _settings;

    public EmailService(IOptions<EmailSettings> settings)
    {
        _settings = settings.Value;
    }

    public async Task SendAsync(
        string to,
        string subject,
        string body,
        CancellationToken cancellationToken = default)
    {
        var email = new MimeMessage();

        email.From.Add(
            new MailboxAddress(
                _settings.FromName,
                _settings.FromEmail));

        email.To.Add(MailboxAddress.Parse(to));
        email.Subject = subject;

        email.Body = new BodyBuilder
        {
            HtmlBody = body
        }.ToMessageBody();

        using var smtp = new SmtpClient();

        await smtp.ConnectAsync(
            _settings.Host,
            _settings.Port,
            SecureSocketOptions.StartTls,
            cancellationToken);

        await smtp.AuthenticateAsync(
            _settings.Username,
            _settings.Password,
            cancellationToken);

        await smtp.SendAsync(
            email,
            cancellationToken);

        await smtp.DisconnectAsync(
            true,
            cancellationToken);
    }
}