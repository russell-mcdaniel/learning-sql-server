using Learning.DataGenerator.Models;

namespace Learning.DataGenerator.Generators
{
    /// <summary>
    /// Caches or retrieves entities needed for data generation.
    /// </summary>
    public class GeneratorContext
    {
        public IList<Building> Buildings { get; } = new List<Building>();

        public IList<Campus> Campuses { get; } = new List<Campus>();

        public IList<Course> Courses { get; } = new List<Course>();

        public IList<CourseOffering> CourseOfferings { get; } = new List<CourseOffering>();

        public IList<Classroom> Classrooms { get; } = new List<Classroom>();

        public IList<Department> Departments { get; } = new List<Department>();

        public IList<Institution> Institutions { get; } = new List<Institution>();

        public IList<Professor> Professors { get; } = new List<Professor>();

        public IList<ProgramLdb> Programs { get; } = new List<ProgramLdb>();

        public IList<ProgramCourse> ProgramCourses { get; } = new List<ProgramCourse>();

        public IList<Student> Students { get; } = new List<Student>();

        public IList<StudentProgram> StudentPrograms { get; } = new List<StudentProgram>();

        public IList<Term> Terms { get; } = new List<Term>();
    }
}
