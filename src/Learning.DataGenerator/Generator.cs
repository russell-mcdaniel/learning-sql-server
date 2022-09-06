using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Learning.DataGenerator.Data;
using Learning.DataGenerator.Factories;
using Learning.DataGenerator.Models;
using Learning.DataGenerator.Generators;

namespace Learning.DataGenerator
{
    internal class Generator : IHostedService
    {
        private readonly IEntityRepository _repository;
        private readonly IHostApplicationLifetime _lifetime;
        private readonly ILogger<Generator> _logger;

        public Generator(
            IEntityRepository repository,
            IHostApplicationLifetime lifetime,
            ILogger<Generator> logger)
        {
            _repository = repository;
            _lifetime = lifetime;
            _logger = logger;
        }

        public Task StartAsync(CancellationToken stoppingToken)
        {
            _logger.LogInformation("Generator is starting...");

            _logger.LogInformation("Generator is started.");

            Generate();

            _lifetime.StopApplication();

            return Task.CompletedTask;
        }

        public Task StopAsync(CancellationToken stoppingToken)
        {
            _logger.LogInformation("Generator is stopping...");

            _logger.LogInformation("Generator is stopped.");

            return Task.CompletedTask;
        }

        private void Generate()
        {
            _logger.LogInformation("Data generation is starting...");

            var systems = GenerateTermSystems();
            var institutions = GenerateInstitutions(systems);

            _logger.LogInformation("Data generation is complete.");
        }

        private IList<Institution> GenerateInstitutions(IList<TermSystem> systems)
        {
            _logger.LogInformation("Institution generation is starting...");

            var institutions = InstitutionGenerator.Generate(systems);
            _repository.Insert(institutions);

            _logger.LogInformation("Institution generation is complete.");

            return institutions;
        }

        private IList<TermSystem> GenerateTermSystems()
        {
            _logger.LogInformation("Term system generation is starting...");

            var systems = TermSystemGenerator.Generate();
            _repository.Insert(systems);

            _logger.LogInformation("Term system generation is complete.");

            return systems;
        }
    }
}
