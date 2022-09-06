using Microsoft.Extensions.Logging;
using Learning.DataGenerator.Data;
using Learning.DataGenerator.Factories;
using Learning.DataGenerator.Models;

namespace Learning.DataGenerator.Generators
{
    public class Generator : IGenerator
    {
        private readonly IEntityRepository _repository;
        private readonly ILogger<Generator> _logger;

        public Generator(
            IEntityRepository repository,
            ILogger<Generator> logger)
        {
            _repository = repository;
            _logger = logger;
        }

        public void Generate()
        {
            _logger.LogInformation("Data generation is starting...");

            var systems = GenerateTermSystems();
            var institutions = GenerateInstitutions(systems);

            foreach (var institution in institutions)
            {
                var campuses = GenerateCampuses(institution);

                foreach (var campus in campuses)
                {
                    var buildings = GenerateBuildings(campus);
                }
            }

            _logger.LogInformation("Data generation is complete.");
        }

        private IList<Building> GenerateBuildings(Campus campus)
        {
            _logger.LogInformation($"Building generation is starting for {campus.DisplayName}...");

            var buildings = BuildingGenerator.Generate(campus);
            _repository.Insert(buildings);

            _logger.LogInformation("Building generation is complete.");

            return buildings;
        }

        private IList<Campus> GenerateCampuses(Institution institution)
        {
            _logger.LogInformation($"Campus generation is starting for {institution.DisplayName}...");

            var campuses = CampusGenerator.Generate(institution);
            _repository.Insert(campuses);

            _logger.LogInformation("Campus generation is complete.");

            return campuses;
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
