using Learning.DataGenerator.Models;

namespace Learning.DataGenerator.Data
{
    public interface IEntityRepository
    {
        void Insert(IEnumerable<Building> buildings);

        void Insert(IEnumerable<Campus> campuses);

        void Insert(IEnumerable<Classroom> classrooms);

        void Insert(IEnumerable<Course> courses);

        void Insert(IEnumerable<CourseOffering> courseOfferings);

        void Insert(IEnumerable<Department> departments);

        void Insert(IEnumerable<Institution> institutions);

        void Insert(IEnumerable<Professor> professors);

        void Insert(IEnumerable<ProgramCourse> programCourses);

        void Insert(IEnumerable<ProgramLdb> programs);

        void Insert(IEnumerable<Student> students);

        void Insert(IEnumerable<StudentProgram> studentPrograms);

        void Insert(IEnumerable<Term> terms);
    }
}
