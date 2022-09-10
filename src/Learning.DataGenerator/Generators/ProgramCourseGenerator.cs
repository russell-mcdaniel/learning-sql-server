using Bogus;
using Learning.DataGenerator.Models;

namespace Learning.DataGenerator.Generators
{
    internal static class ProgramCourseGenerator
    {
        internal static IList<ProgramCourse> Generate(IDictionary<string, int> programCoursesToCreate, IList<ProgramLdb> programs, IList<Course> courses)
        {
            var programCourses = new List<ProgramCourse>();

            foreach (var program in programs)
            {
                var coursesToAssign = programCoursesToCreate[program.ProgramType];
                var coursesAssigned = 0;

                if (coursesToAssign > courses.Count)
                    throw new Exception("The number of available courses must be greater than the number of courses to assign to a program.");

                var faker = new Faker();
                var coursesAssignedSet = new HashSet<Guid>();

                while (coursesAssigned < coursesToAssign)
                {
                    var course = faker.PickRandom(courses);

                    if (coursesAssignedSet.Add(course.CourseKey))
                    {
                        var programCourse = new ProgramCourse()
                        {
                            Institution = program.Institution,
                            Department = program.Department,
                            Program = program,
                            Course = course
                        };

                        programCourses.Add(programCourse);

                        coursesAssigned++;
                    }
                }
            }

            return programCourses;
        }
    }
}
