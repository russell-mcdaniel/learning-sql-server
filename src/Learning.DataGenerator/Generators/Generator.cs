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

            #region Generation Parameters

            // TODO: Move to configuration.
            var institutionsToCreate = 1;
            var campusesToCreate = 2;               // Per institution.
            var buildingsToCreate = 5;              // Per campus.
            var classroomsToCreate = 10;            // Per building.
            var departmentsToCreate = 5;            // Per institution.
            var programsToCreate = 4;               // Per department.
            var coursesToCreate = 20;               // Per department.

            // Per program by program type.
            var programCoursesToCreate = new Dictionary<string, int>
            {
                { ProgramType.Major, 12 },
                { ProgramType.Minor, 4 }
            };

            var professorsToCreate = 10;            // Per department.
            var studentsToCreate = 9000;            // Per institution.

            // Per student.
            var studentProgramsToCreate = new Dictionary<string, (int, int)>
            {
                { StudentProgramDeclaration.MajorMajor, (2, 0) },
                { StudentProgramDeclaration.MajorMinor, (1, 1) },
                { StudentProgramDeclaration.MajorOnly, (1, 0) }
            };

            var academicYearsToCreate = 12;         // Per institution in years of terms.
            var courseOfferingsToCreate = 3;        // Per professor.

            #endregion

            GenerateInstitutions(institutionsToCreate);
            GenerateCampuses(campusesToCreate);
            GenerateBuildings(buildingsToCreate);
            GenerateClassrooms(classroomsToCreate);

            GenerateDepartments(departmentsToCreate);
            GeneratePrograms(programsToCreate);
            GenerateCourses(coursesToCreate);
            GenerateProgramCourses(programCoursesToCreate);
            GenerateProfessors(professorsToCreate);

            GenerateStudents(studentsToCreate);
            GenerateStudentPrograms(studentProgramsToCreate);

            GenerateTerms(academicYearsToCreate);
            GenerateCourseOfferings(courseOfferingsToCreate);
            //GenerateCourseOfferingEnrollments();

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
