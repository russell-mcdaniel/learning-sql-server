using Bogus;
using Learning.DataGenerator.Models;

namespace Learning.DataGenerator.Generators
{
    internal static class CourseOfferingGenerator
    {
        /// <summary>
        /// Generates course offerings at the department level.
        /// </summary>
        /// <param name="courseOfferingsToCreate">The number of course offerings to create per professor per term.</param>
        /// <param name="courses">The list of courses offered by the department.</param>
        /// <param name="professors">The list of professors that work in the department.</param>
        /// <param name="classrooms">The list of classrooms for the institution.</param>
        /// <param name="terms">The list of academic year terms for the institution.</param>
        /// <returns>The list of course offerings for the department.</returns>
        /// <remarks>
        /// A course may be offered more than once in a term.
        ///
        /// A professor may teach the same course more than once in a term.
        /// </remarks>
        internal static IList<CourseOffering> Generate(int courseOfferingsToCreate, IList<Course> courses, IList<Professor> professors, IList<Classroom> classrooms, IList<Term> terms)
        {
            var courseOfferings = new List<CourseOffering>();

            var f = new Faker();

            foreach (var professor in professors)
            {
                foreach (var term in terms)
                {
                    for (var courseOfferingsCreated = 0; courseOfferingsCreated < courseOfferingsToCreate; courseOfferingsCreated++)
                    {
                        var course = f.PickRandom(courses);
                        var classroom = f.PickRandom(classrooms);

                        var courseOffering = new CourseOffering
                        {
                            Institution = course.Institution,
                            CourseOfferingKey = Guid.NewGuid(),
                            Department = course.Department,
                            Course = course,
                            Professor = professor,
                            Campus = classroom.Campus,
                            Building = classroom.Building,
                            Classroom = classroom,
                            Term = term
                        };

                        courseOfferings.Add(courseOffering);
                    }
                }
            }

            return courseOfferings;
        }
    }
}
