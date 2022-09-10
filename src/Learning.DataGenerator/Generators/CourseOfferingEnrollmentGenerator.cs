using Bogus;
using Learning.DataGenerator.Models;
using System.Security.Cryptography;

namespace Learning.DataGenerator.Generators
{
    internal class CourseOfferingEnrollmentGenerator
    {
        /// <summary>
        /// Generates course offering enrollments at the institution level.
        /// </summary>
        /// <param name="coesToCreate"></param>
        /// <param name="courseOfferings"></param>
        /// <param name="students"></param>
        /// <param name="terms"></param>
        /// <returns>The list of course offering enrollments for the institution.</returns>
        /// <remarks>
        /// Ideally the selection logic should:
        /// 
        /// 1. Ensure students enroll in all of their declared program courses.
        /// 2. Prevent students from enrolling in the same course more than once.
        /// 3. Ensure students enroll in consecutive terms.
        ///
        /// Currently it handles #2 and #3.
        /// 
        /// It is difficult to guarantee all of these because of the random
        /// nature of the source data.
        /// </remarks>
        internal static IList<CourseOfferingEnrollment> Generate(
            int coesToCreate,
            IList<CourseOffering> courseOfferings,
            IList<Student> students,
            IList<Term> terms)
        {
            const int TermsToEnroll = 8;

            var coes = new List<CourseOfferingEnrollment>();

            foreach (var student in students)
            {
                // Get a set of consecutive terms.
                var programTerms = GetProgramTerms(TermsToEnroll, terms);

                // Track the courses enrolled by the student to prevent duplicate enrollments.
                var enrolledCourses = new List<Course>();

                foreach (var term in programTerms)
                {
                    // Get the set of course offerings for the current term.
                    var termCourseOfferings = (from t in courseOfferings where t.Term == term select t).ToList();

                    for (var coesCreated = 0; coesCreated < coesToCreate; coesCreated++)
                    {
                        var courseOffering = GetCourseOffering(termCourseOfferings, enrolledCourses);
                        var coe = CreateCourseOfferingEnrollment(courseOffering, student);

                        coes.Add(coe);
                    }
                }
            }

            return coes;
        }

        internal static CourseOfferingEnrollment CreateCourseOfferingEnrollment(
            CourseOffering courseOffering,
            Student student)
        {
            var f = new Faker();

            // TODO: Create a realistic distribution for scores.
            var coe = new CourseOfferingEnrollment
            {
                Institution = courseOffering.Institution,
                CourseOffering = courseOffering,
                Student = student,
                Score = f.Random.Byte(50, 100)
            };

            return coe;
        }

        /// <summary>
        /// Gets a course offering ensuring that it is not one of the previously enrolled courses.
        /// </summary>
        /// <returns></returns>
        internal static CourseOffering GetCourseOffering(
            IList<CourseOffering> courseOfferings,
            IList<Course> enrolledCourses)
        {
            var f = new Faker();

            var courseOffering = f.PickRandom(courseOfferings);

            // TODO: Cap the number of attempts and throw an exception to prevent an infinite loop.
            while (enrolledCourses.Contains(courseOffering.Course))
                courseOffering = f.PickRandom(courseOfferings);

            enrolledCourses.Add(courseOffering.Course);

            return courseOffering;
        }

        internal static IList<Term> GetProgramTerms(int termsToEnroll, IList<Term> terms)
        {
            if (terms.Count < termsToEnroll)
                throw new ArgumentOutOfRangeException(nameof(terms), $"There must be at least {termsToEnroll} terms defined.");

            var f = new Faker();

            var startTermIndex = f.Random.Int(0, terms.Count - termsToEnroll);

            var sortedTerms = (from t in terms orderby t.AcademicYear, t.CalendarYear select t).ToList();
            var programTerms = sortedTerms.GetRange(startTermIndex, termsToEnroll);

            return programTerms;
        }
    }
}
