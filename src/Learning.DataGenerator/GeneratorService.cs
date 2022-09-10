using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Learning.DataGenerator.Generators;

namespace Learning.DataGenerator
{
    internal class GeneratorService : IHostedService
    {
        private readonly IGenerator _generator;
        private readonly IHostApplicationLifetime _lifetime;
        private readonly ILogger<GeneratorService> _logger;

        public GeneratorService(
            IGenerator generator,
            IHostApplicationLifetime lifetime,
            ILogger<GeneratorService> logger)
        {
            _generator = generator;
            _lifetime = lifetime;
            _logger = logger;
        }

        public Task StartAsync(CancellationToken stoppingToken)
        {
            _logger.LogInformation("Generator is starting...");

            _logger.LogInformation("Generator is started.");

            _generator.Generate();

            _lifetime.StopApplication();

            return Task.CompletedTask;
        }

        public Task StopAsync(CancellationToken stoppingToken)
        {
            _logger.LogInformation("Generator is stopping...");

            _logger.LogInformation("Generator is stopped.");

            return Task.CompletedTask;
        }
    }
}
