using Microsoft.Extensions.Logging;
using Learning.DataGenerator.Data;
using Learning.DataGenerator.Models;
using Learning.DataGenerator.Core;

namespace Learning.DataGenerator.Generators
{
    public class Generator : IGenerator
    {
        private readonly GeneratorContext _context = new GeneratorContext();
        private readonly IEntityRepository _repository;
        private readonly ILogger<Generator> _logger;

        public Generator(
            IEntityRepository repository,
            ILogger<Generator> logger)
        {
            _repository = repository;
            _logger = logger;
        }

        /// <summary>
        /// Perform overall coordination for data generation.
        /// </summary>
        /// <remarks>
        /// Ensure data generation steps are not directly coupled. The input for one
        /// routine should not directly depend on the output of another. Otherwise,
        /// there will be various scoping and accessibility issues for non-trivial
        /// entities. Use the database or a cache to retrieve inputs.
        /// </remarks>
        public void Generate()
        {
            _logger.LogInformation("Generating...");

            GenerateInstitutions();
            GenerateCampuses();
            GenerateBuildings();
            GenerateClassrooms();

            GenerateDepartments();
            GeneratePrograms();
            GenerateCourses();
            GenerateProgramCourses();
            GenerateProfessors();

            GenerateStudents();
            //GenerateStudentPrograms();

            GenerateTerms();
            //GenerateCourseOfferings();
            //GenerateCourseOfferingEnrollments();

            _logger.LogInformation("Generation is complete.");
        }

        private void GenerateBuildings()
        {
            _logger.LogInformation("Generating buildings...");

            foreach (var campus in _context.Campuses)
            {
                _logger.LogInformation("Generating buildings for {Campus}...", campus.DisplayName);

                var buildings = BuildingGenerator.Generate(campus);
                _repository.Insert(buildings);
                _context.Buildings.AddRange(buildings);
            }

            _logger.LogInformation("Generated buildings.");
        }

        private void GenerateCampuses()
        {
            _logger.LogInformation("Generating campuses...");

            foreach (var institution in _context.Institutions)
            {
                _logger.LogInformation("Generating campuses for {Institution}...", institution.DisplayName);

                var campuses = CampusGenerator.Generate(institution);
                _repository.Insert(campuses);
                _context.Campuses.AddRange(campuses);
            }

            _logger.LogInformation("Generated campuses.");
        }

        private void GenerateClassrooms()
        {
            _logger.LogInformation("Generating classrooms...");

            foreach (var building in _context.Buildings)
            {
                _logger.LogInformation("Generating classrooms for {Building}...", building.DisplayName);

                var classrooms = ClassroomGenerator.Generate(building);
                _repository.Insert(classrooms);
                _context.Classrooms.AddRange(classrooms);
            }

            _logger.LogInformation("Generated classrooms.");
        }

        private void GenerateCourses()
        {
            _logger.LogInformation("Generating courses...");

            foreach (var department in _context.Departments)
            {
                _logger.LogInformation("Generating courses for {Department}...", department.DisplayName);

                var courses = CourseGenerator.Generate(department);
                _repository.Insert(courses);
                _context.Courses.AddRange(courses);
            }

            _logger.LogInformation("Generated courses.");
        }

        private void GenerateDepartments()
        {
            _logger.LogInformation("Generating departments...");

            foreach (var institution in _context.Institutions)
            {
                _logger.LogInformation("Generating departments for {Institution}...", institution.DisplayName);

                var departments = DepartmentGenerator.Generate(institution);
                _repository.Insert(departments);
                _context.Departments.AddRange(departments);
            }

            _logger.LogInformation("Generated departments.");
        }

        private void GenerateInstitutions()
        {
            _logger.LogInformation("Generating institutions...");

            var institutions = InstitutionGenerator.Generate();
            _repository.Insert(institutions);
            _context.Institutions.AddRange(institutions);

            _logger.LogInformation("Generated institutions.");
        }

        private void GenerateProfessors()
        {
            _logger.LogInformation("Generating professors...");

            foreach (var department in _context.Departments)
            {
                _logger.LogInformation("Generating professors for {Department}...", department.DisplayName);

                var professors = ProfessorGenerator.Generate(department);
                _repository.Insert(professors);
                _context.Professors.AddRange(professors);
            }

            _logger.LogInformation("Generated professors.");
        }

        private void GeneratePrograms()
        {
            _logger.LogInformation("Generating programs...");

            foreach (var department in _context.Departments)
            {
                _logger.LogInformation("Generating programs for {Department}...", department.DisplayName);

                var programs = ProgramGenerator.Generate(department);
                _repository.Insert(programs);
                _context.Programs.AddRange(programs);
            }

            _logger.LogInformation("Generated programs.");
        }

        private void GenerateProgramCourses()
        {
            _logger.LogInformation("Generating program-courses...");

            foreach (var department in _context.Departments)
            {
                _logger.LogInformation("Generating program-courses for {Department}...", department.DisplayName);

                var programs = (from p in _context.Programs where p.Department == department select p).ToList<ProgramLdb>();
                var courses = (from c in _context.Courses where c.Department == department select c).ToList<Course>();

                var programCourses = ProgramCourseGenerator.Generate(programs, courses);
                _repository.Insert(programCourses);
                _context.ProgramCourses.AddRange(programCourses);
            }

            _logger.LogInformation("Generated program-courses.");
        }

        private void GenerateStudents()
        {
            _logger.LogInformation("Generating students...");

            foreach (var institution in _context.Institutions)
            {
                _logger.LogInformation("Generating students for {Institution}...", institution.DisplayName);

                var students = StudentGenerator.Generate(institution);
                _repository.Insert(students);
                _context.Students.AddRange(students);
            }

            _logger.LogInformation("Generated students.");
        }

        private void GenerateTerms()
        {
            _logger.LogInformation("Generating terms...");

            foreach (var institution in _context.Institutions)
            {
                _logger.LogInformation("Generating terms for {Institution}...", institution.DisplayName);

                var terms = TermGenerator.Generate(institution);
                _repository.Insert(terms);
                _context.Terms.AddRange(terms);
            }

            _logger.LogInformation("Generated terms.");
        }
    }
}
