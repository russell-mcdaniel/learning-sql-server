using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Dapper;
using Learning.DataGenerator.Models;

namespace Learning.DataGenerator.Data
{
    public class EntityRepository : IEntityRepository
    {
        private readonly IConfiguration _config;
        private readonly ILogger<EntityRepository> _logger;

        public EntityRepository(
            IConfiguration config,
            ILogger<EntityRepository> logger)
        {
            _config = config;
            _logger = logger;
        }

        public void Insert(IEnumerable<Building> buildings)
        {
            using var connection = DbConnectionFactory.GetConnection(
                _config.GetConnectionString("LearningDatabase"));

            connection.Execute(
                "INSERT INTO Organization.Building (InstitutionKey, CampusKey, BuildingKey, DisplayName) VALUES (@InstitutionKey, @CampusKey, @BuildingKey, @DisplayName);",
                from b in buildings select new { b.Institution.InstitutionKey, b.Campus.CampusKey, b.BuildingKey, b.DisplayName });
        }

        public void Insert(IEnumerable<Campus> campuses)
        {
            using var connection = DbConnectionFactory.GetConnection(
                _config.GetConnectionString("LearningDatabase"));

            connection.Execute(
                "INSERT INTO Organization.Campus (InstitutionKey, CampusKey, DisplayName, LocationName) VALUES (@InstitutionKey, @CampusKey, @DisplayName, @LocationName);",
                from c in campuses select new { c.Institution.InstitutionKey, c.CampusKey, c.DisplayName, c.LocationName });
        }

        public void Insert(IEnumerable<Classroom> classrooms)
        {
            using var connection = DbConnectionFactory.GetConnection(
                _config.GetConnectionString("LearningDatabase"));

            connection.Execute(
                "INSERT INTO Organization.Classroom (InstitutionKey, CampusKey, BuildingKey, ClassroomKey, DisplayName) VALUES (@InstitutionKey, @CampusKey, @BuildingKey, @ClassroomKey, @DisplayName);",
                from c in classrooms select new { c.Institution.InstitutionKey, c.Campus.CampusKey, c.Building.BuildingKey, c.ClassroomKey, c.DisplayName });
        }

        public void Insert(IEnumerable<Course> courses)
        {
            using var connection = DbConnectionFactory.GetConnection(
                _config.GetConnectionString("LearningDatabase"));

            connection.Execute(
                "INSERT INTO Curriculum.Course (InstitutionKey, DepartmentKey, CourseKey, DisplayName, Level) VALUES (@InstitutionKey, @DepartmentKey, @CourseKey, @DisplayName, @Level);",
                from c in courses select new { c.Institution.InstitutionKey, c.Department.DepartmentKey, c.CourseKey, c.DisplayName, c.Level });
        }

        public void Insert(IEnumerable<CourseOffering> courseOfferings)
        {
            using var connection = DbConnectionFactory.GetConnection(
                _config.GetConnectionString("LearningDatabase"));

            connection.Execute(
                "INSERT INTO Enrollment.CourseOffering (InstitutionKey, CourseOfferingKey, DepartmentKey, CourseKey, ProfessorKey, CampusKey, BuildingKey, ClassroomKey, TermKey) VALUES (@InstitutionKey, @CourseOfferingKey, @DepartmentKey, @CourseKey, @ProfessorKey, @CampusKey, @BuildingKey, @ClassroomKey, @TermKey);",
                from co in courseOfferings select new { co.Institution.InstitutionKey, co.CourseOfferingKey, co.Department.DepartmentKey, co.Course.CourseKey, co.Professor.ProfessorKey, co.Campus.CampusKey, co.Building.BuildingKey, co.Classroom.ClassroomKey, co.Term.TermKey });
        }

        public void Insert(IEnumerable<CourseOfferingEnrollment> courseOfferingEnrollments)
        {
            using var connection = DbConnectionFactory.GetConnection(
                _config.GetConnectionString("LearningDatabase"));

            connection.Execute(
                "INSERT INTO Enrollment.CourseOfferingEnrollment (InstitutionKey, CourseOfferingKey, StudentKey, Score) VALUES (@InstitutionKey, @CourseOfferingKey, @StudentKey, @Score);",
                from coe in courseOfferingEnrollments select new { coe.Institution.InstitutionKey, coe.CourseOffering.CourseOfferingKey, coe.Student.StudentKey, coe.Score });
        }

        public void Insert(IEnumerable<Department> departments)
        {
            using var connection = DbConnectionFactory.GetConnection(
                _config.GetConnectionString("LearningDatabase"));

            connection.Execute(
                "INSERT INTO Organization.Department (InstitutionKey, DepartmentKey, DisplayName) VALUES (@InstitutionKey, @DepartmentKey, @DisplayName);",
                from d in departments select new { d.Institution.InstitutionKey, d.DepartmentKey, d.DisplayName });
        }

        public void Insert(IEnumerable<Institution> institutions)
        {
            using var connection = DbConnectionFactory.GetConnection(
                _config.GetConnectionString("LearningDatabase"));

            connection.Execute(
                "INSERT INTO Organization.Institution (InstitutionKey, DisplayName, LocationName) VALUES (@InstitutionKey, @DisplayName, @LocationName);",
                from i in institutions select new { i.InstitutionKey, i.DisplayName, i.LocationName });
        }

        public void Insert(IEnumerable<Professor> professors)
        {
            using var connection = DbConnectionFactory.GetConnection(
                _config.GetConnectionString("LearningDatabase"));

            connection.Execute(
                "INSERT INTO Organization.Professor (InstitutionKey, DepartmentKey, ProfessorKey, DisplayName) VALUES (@InstitutionKey, @DepartmentKey, @ProfessorKey, @DisplayName);",
                from p in professors select new { p.Institution.InstitutionKey, p.Department.DepartmentKey, p.ProfessorKey, p.DisplayName });
        }

        public void Insert(IEnumerable<ProgramCourse> programCourses)
        {
            using var connection = DbConnectionFactory.GetConnection(
                _config.GetConnectionString("LearningDatabase"));

            connection.Execute(
                "INSERT INTO Curriculum.ProgramCourse (InstitutionKey, DepartmentKey, ProgramKey, CourseKey) VALUES (@InstitutionKey, @DepartmentKey, @ProgramKey, @CourseKey);",
                from pc in programCourses select new { pc.Institution.InstitutionKey, pc.Department.DepartmentKey, pc.Program.ProgramKey, pc.Course.CourseKey });
        }

        public void Insert(IEnumerable<ProgramLdb> programs)
        {
            using var connection = DbConnectionFactory.GetConnection(
                _config.GetConnectionString("LearningDatabase"));

            connection.Execute(
                "INSERT INTO Curriculum.Program (InstitutionKey, DepartmentKey, ProgramKey, DisplayName, ProgramType) VALUES (@InstitutionKey, @DepartmentKey, @ProgramKey, @DisplayName, @ProgramType);",
                from p in programs select new { p.Institution.InstitutionKey, p.Department.DepartmentKey, p.ProgramKey, p.DisplayName, p.ProgramType });
        }

        public void Insert(IEnumerable<Student> students)
        {
            using var connection = DbConnectionFactory.GetConnection(
                _config.GetConnectionString("LearningDatabase"));

            connection.Execute(
                "INSERT INTO Enrollment.Student (InstitutionKey, StudentKey, DisplayName) VALUES (@InstitutionKey, @StudentKey, @DisplayName);",
                from s in students select new { s.Institution.InstitutionKey, s.StudentKey, s.DisplayName });
        }

        public void Insert(IEnumerable<StudentProgram> studentPrograms)
        {
            using var connection = DbConnectionFactory.GetConnection(
                _config.GetConnectionString("LearningDatabase"));

            connection.Execute(
                "INSERT INTO Enrollment.StudentProgram (InstitutionKey, StudentKey, DepartmentKey, ProgramKey) VALUES (@InstitutionKey, @StudentKey, @DepartmentKey, @ProgramKey);",
                from sp in studentPrograms select new { sp.Institution.InstitutionKey, sp.Student.StudentKey, sp.Department.DepartmentKey, sp.Program.ProgramKey });
        }

        public void Insert(IEnumerable<Term> terms)
        {
            using var connection = DbConnectionFactory.GetConnection(
                _config.GetConnectionString("LearningDatabase"));

            connection.Execute(
                "INSERT INTO Enrollment.Term (InstitutionKey, TermKey, AcademicYear, CalendarYear, SeasonName) VALUES (@InstitutionKey, @TermKey, @AcademicYear, @CalendarYear, @SeasonName);",
                from t in terms select new { t.Institution.InstitutionKey, t.TermKey, t.AcademicYear, t.CalendarYear, t.SeasonName });
        }
    }
}
