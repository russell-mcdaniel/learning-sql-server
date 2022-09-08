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

                    foreach (var building in buildings)
                    {
                        var classrooms = GenerateClassrooms(building);
                    }
                }

                var departments = GenerateDepartments(institution);

                foreach (var department in departments)
                {
                    var professors = GenerateProfessors(department);
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

        private IList<Classroom> GenerateClassrooms(Building building)
        {
            _logger.LogInformation($"Classroom generation is starting for {building.DisplayName}...");

            var classrooms = ClassroomGenerator.Generate(building);
            _repository.Insert(classrooms);

            _logger.LogInformation("Classroom generation is complete.");

            return classrooms;
        }

        private IList<Department> GenerateDepartments(Institution institution)
        {
            _logger.LogInformation($"Department generation is starting for {institution.DisplayName}...");

            var departments = DepartmentGenerator.Generate(institution);
            _repository.Insert(departments);

            _logger.LogInformation("Department generation is complete.");

            return departments;
        }

        private IList<Institution> GenerateInstitutions(IList<TermSystem> systems)
        {
            _logger.LogInformation("Institution generation is starting...");

            var institutions = InstitutionGenerator.Generate(systems);
            _repository.Insert(institutions);

            _logger.LogInformation("Institution generation is complete.");

            return institutions;
        }

        private IList<Professor> GenerateProfessors(Department department)
        {
            _logger.LogInformation($"Professor generation is starting for {department.DisplayName}...");

            var professors = ProfessorGenerator.Generate(department);
            _repository.Insert(professors);

            _logger.LogInformation("Professor generation is complete.");

            return professors;
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
