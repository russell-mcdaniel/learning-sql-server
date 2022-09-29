using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Learning.DataGenerator.Data;
using Learning.DataGenerator.Core;

namespace Learning.DataGenerator.Generators
{
    public class Generator : IGenerator
    {
        private readonly GeneratorContext _context = new GeneratorContext();
        private readonly GeneratorOptions _options;
        private readonly IEntityRepository _repository;
        private readonly ILogger<Generator> _logger;

        public Generator(
            IOptions<GeneratorOptions> options,
            IEntityRepository repository,
            ILogger<Generator> logger)
        {
            _options = options.Value;
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

            GenerateInstitutions(_options.Institutions);
            GenerateCampuses(_options.Campuses);
            GenerateBuildings(_options.Buildings);
            GenerateClassrooms(_options.Classrooms);

            GenerateDepartments(_options.Departments);
            GeneratePrograms(_options.Programs);
            GenerateCourses(_options.Courses);
            GenerateProgramCourses(_options.ProgramCourses);
            GenerateProfessors(_options.Professors);

            GenerateStudents(_options.Students);
            GenerateStudentPrograms(_options.StudentPrograms);

            GenerateTerms(_options.Years);
            GenerateCourseOfferings(_options.CourseOfferings);
            GenerateCourseOfferingEnrollments(_options.CourseOfferingEnrollments);

            _logger.LogInformation("Generation is complete.");
        }

        private void GenerateBuildings(int buildingsToCreate)
        {
            _logger.LogInformation("Generating buildings...");

            foreach (var campus in _context.Campuses)
            {
                _logger.LogInformation("Generating buildings for {Campus}...", campus.DisplayName);

                var buildings = BuildingGenerator.Generate(buildingsToCreate, campus);
                _repository.Insert(buildings);
                _context.Buildings.AddRange(buildings);
            }

            _logger.LogInformation("Generated buildings.");
        }

        private void GenerateCampuses(int campusesToCreate)
        {
            _logger.LogInformation("Generating campuses...");

            foreach (var institution in _context.Institutions)
            {
                _logger.LogInformation("Generating campuses for {Institution}...", institution.DisplayName);

                var campuses = CampusGenerator.Generate(campusesToCreate, institution);
                _repository.Insert(campuses);
                _context.Campuses.AddRange(campuses);
            }

            _logger.LogInformation("Generated campuses.");
        }

        private void GenerateClassrooms(int classroomsToCreate)
        {
            _logger.LogInformation("Generating classrooms...");

            foreach (var building in _context.Buildings)
            {
                _logger.LogInformation("Generating classrooms for {Building}...", building.DisplayName);

                var classrooms = ClassroomGenerator.Generate(classroomsToCreate, building);
                _repository.Insert(classrooms);
                _context.Classrooms.AddRange(classrooms);
            }

            _logger.LogInformation("Generated classrooms.");
        }

        private void GenerateCourses(int coursesToCreate)
        {
            _logger.LogInformation("Generating courses...");

            foreach (var department in _context.Departments)
            {
                _logger.LogInformation("Generating courses for {Department}...", department.DisplayName);

                var courses = CourseGenerator.Generate(coursesToCreate, department);
                _repository.Insert(courses);
                _context.Courses.AddRange(courses);
            }

            _logger.LogInformation("Generated courses.");
        }

        private void GenerateCourseOfferings(int courseOfferingsToCreate)
        {
            _logger.LogInformation("Generating course offerings...");

            foreach (var department in _context.Departments)
            {
                _logger.LogInformation("Generating course offerings for {Department}...", department.DisplayName);

                var courses = (from c in _context.Courses where c.Department == department select c).ToList();
                var professors = (from p in _context.Professors where p.Department == department select p).ToList();
                var classrooms = (from r in _context.Classrooms where r.Institution == department.Institution select r).ToList();
                var terms = (from t in _context.Terms where t.Institution == department.Institution select t).ToList();

                var courseOfferings = CourseOfferingGenerator.Generate(courseOfferingsToCreate, courses, professors, classrooms, terms);
                _repository.Insert(courseOfferings);
                _context.CourseOfferings.AddRange(courseOfferings);
            }

            _logger.LogInformation("Generated course offerings.");
        }

        private void GenerateCourseOfferingEnrollments(int courseOfferingEnrollmentsToCreate)
        {
            _logger.LogInformation("Generating course offering enrollments...");

            foreach (var institution in _context.Institutions)
            {
                _logger.LogInformation("Generating course offering enrollments for {Institution}...", institution.DisplayName);

                var courseOfferings = (from c in _context.CourseOfferings where c.Institution == institution select c).ToList();
                var students = (from s in _context.Students where s.Institution == institution select s).ToList();
                var terms = (from t in _context.Terms where t.Institution == institution select t).ToList();

                var courseOfferingEnrollments = CourseOfferingEnrollmentGenerator.Generate(courseOfferingEnrollmentsToCreate, courseOfferings, students, terms);
                _repository.Insert(courseOfferingEnrollments);
            }

            _logger.LogInformation("Generated course offering enrollments.");
        }

        private void GenerateDepartments(int departmentsToCreate)
        {
            _logger.LogInformation("Generating departments...");

            foreach (var institution in _context.Institutions)
            {
                _logger.LogInformation("Generating departments for {Institution}...", institution.DisplayName);

                var departments = DepartmentGenerator.Generate(departmentsToCreate, institution);
                _repository.Insert(departments);
                _context.Departments.AddRange(departments);
            }

            _logger.LogInformation("Generated departments.");
        }

        private void GenerateInstitutions(int institutionsToCreate)
        {
            _logger.LogInformation("Generating institutions...");

            var institutions = InstitutionGenerator.Generate(institutionsToCreate);
            _repository.Insert(institutions);
            _context.Institutions.AddRange(institutions);

            _logger.LogInformation("Generated institutions.");
        }

        private void GenerateProfessors(int professorsToCreate)
        {
            _logger.LogInformation("Generating professors...");

            foreach (var department in _context.Departments)
            {
                _logger.LogInformation("Generating professors for {Department}...", department.DisplayName);

                var professors = ProfessorGenerator.Generate(professorsToCreate, department);
                _repository.Insert(professors);
                _context.Professors.AddRange(professors);
            }

            _logger.LogInformation("Generated professors.");
        }

        private void GeneratePrograms(int programsToCreate)
        {
            _logger.LogInformation("Generating programs...");

            foreach (var department in _context.Departments)
            {
                _logger.LogInformation("Generating programs for {Department}...", department.DisplayName);

                var programs = ProgramGenerator.Generate(programsToCreate, department);
                _repository.Insert(programs);
                _context.Programs.AddRange(programs);
            }

            _logger.LogInformation("Generated programs.");
        }

        private void GenerateProgramCourses(IDictionary<string, int> programCoursesToCreate)
        {
            _logger.LogInformation("Generating program courses...");

            foreach (var department in _context.Departments)
            {
                _logger.LogInformation("Generating program courses for {Department}...", department.DisplayName);

                var programs = (from p in _context.Programs where p.Department == department select p).ToList();
                var courses = (from c in _context.Courses where c.Department == department select c).ToList();

                var programCourses = ProgramCourseGenerator.Generate(programCoursesToCreate, programs, courses);
                _repository.Insert(programCourses);
                _context.ProgramCourses.AddRange(programCourses);
            }

            _logger.LogInformation("Generated program courses.");
        }

        private void GenerateStudents(int studentsToCreate)
        {
            _logger.LogInformation("Generating students...");

            foreach (var institution in _context.Institutions)
            {
                _logger.LogInformation("Generating students for {Institution}...", institution.DisplayName);

                var students = StudentGenerator.Generate(studentsToCreate, institution);
                _repository.Insert(students);
                _context.Students.AddRange(students);
            }

            _logger.LogInformation("Generated students.");
        }

        private void GenerateStudentPrograms(IDictionary<string, (int, int)> studentProgramsToCreate)
        {
            _logger.LogInformation("Generating student programs...");

            foreach (var institution in _context.Institutions)
            {
                _logger.LogInformation("Generating student programs for {Institution}...", institution.DisplayName);

                var students = (from s in _context.Students where s.Institution == institution select s).ToList();
                var programs = (from p in _context.Programs where p.Institution == institution select p).ToList();

                var studentPrograms = StudentProgramGenerator.Generate(studentProgramsToCreate, students, programs);
                _repository.Insert(studentPrograms);
                _context.StudentPrograms.AddRange(studentPrograms);
            }

            _logger.LogInformation("Generated student programs.");
        }

        private void GenerateTerms(int academicYearsToCreate)
        {
            _logger.LogInformation("Generating terms...");

            foreach (var institution in _context.Institutions)
            {
                _logger.LogInformation("Generating terms for {Institution}...", institution.DisplayName);

                var terms = TermGenerator.Generate(academicYearsToCreate, institution);
                _repository.Insert(terms);
                _context.Terms.AddRange(terms);
            }

            _logger.LogInformation("Generated terms.");
        }
    }
}
