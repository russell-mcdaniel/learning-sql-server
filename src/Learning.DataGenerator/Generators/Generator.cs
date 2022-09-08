using Microsoft.Extensions.Logging;
using Learning.DataGenerator.Data;
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
            _logger.LogInformation("Generation is starting...");

            var institutions = GenerateInstitutions();

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
                    var programs = GeneratePrograms(department);
                    var courses = GenerateCourses(department);
                    var programCourses = GenerateProgramCourses(programs, courses);

                    var professors = GenerateProfessors(department);
                }
            }

            _logger.LogInformation("Generation is complete.");
        }

        private IList<Building> GenerateBuildings(Campus campus)
        {
            _logger.LogInformation("Generation is starting for buildings for {Campus}...", campus.DisplayName);

            var buildings = BuildingGenerator.Generate(campus);
            _repository.Insert(buildings);

            _logger.LogInformation("Generation is complete for buildings.");

            return buildings;
        }

        private IList<Campus> GenerateCampuses(Institution institution)
        {
            _logger.LogInformation("Generation is starting for campuses for {Institution}...", institution.DisplayName);

            var campuses = CampusGenerator.Generate(institution);
            _repository.Insert(campuses);

            _logger.LogInformation("Generation is complete for campuses.");

            return campuses;
        }

        private IList<Classroom> GenerateClassrooms(Building building)
        {
            _logger.LogInformation("Generation is starting for classrooms for {Building}...", building.DisplayName);

            var classrooms = ClassroomGenerator.Generate(building);
            _repository.Insert(classrooms);

            _logger.LogInformation("Generation is complete for classrooms.");

            return classrooms;
        }

        private IList<Course> GenerateCourses(Department department)
        {
            _logger.LogInformation("Generation is starting for courses for {Department}...", department.DisplayName);

            var courses = CourseGenerator.Generate(department);
            _repository.Insert(courses);

            _logger.LogInformation("Generation is complete for courses.");

            return courses;
        }

        private IList<Department> GenerateDepartments(Institution institution)
        {
            _logger.LogInformation("Generation is starting for departments for {Institution}...", institution.DisplayName);

            var departments = DepartmentGenerator.Generate(institution);
            _repository.Insert(departments);

            _logger.LogInformation("Generation is complete for departments.");

            return departments;
        }

        private IList<Institution> GenerateInstitutions()
        {
            _logger.LogInformation("Generation is starting for institutions...");

            var institutions = InstitutionGenerator.Generate();
            _repository.Insert(institutions);

            _logger.LogInformation("Generation is complete for institutions.");

            return institutions;
        }

        private IList<Professor> GenerateProfessors(Department department)
        {
            _logger.LogInformation("Generation is starting for professors for {Department}...", department.DisplayName);

            var professors = ProfessorGenerator.Generate(department);
            _repository.Insert(professors);

            _logger.LogInformation("Generation is complete for professors.");

            return professors;
        }

        private IList<ProgramLdb> GeneratePrograms(Department department)
        {
            _logger.LogInformation("Generation is starting for programs for {Department}...", department.DisplayName);

            var programs = ProgramGenerator.Generate(department);
            _repository.Insert(programs);

            _logger.LogInformation("Generation is complete for programs.");

            return programs;
        }

        private IList<ProgramCourse> GenerateProgramCourses(IList<ProgramLdb> programs, IList<Course> courses)
        {
            _logger.LogInformation("Generation is starting for program-courses for {Department}...", programs[0].Department.DisplayName);

            var programCourses = ProgramCourseGenerator.Generate(programs, courses);
            _repository.Insert(programCourses);

            _logger.LogInformation("Generation is complete for program-courses.");

            return programCourses;
        }
    }
}
