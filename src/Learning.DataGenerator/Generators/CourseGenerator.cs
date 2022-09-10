using System.Globalization;
using Bogus;
using Bogus.Extensions;
using Learning.DataGenerator.Models;

namespace Learning.DataGenerator.Generators
{
    internal static class CourseGenerator
    {
        internal static IList<Course> Generate(int coursesToCreate, Department department)
        {
            var names = GenerateCourseNames(coursesToCreate);
            var nameIndex = 0;

            var courseFaker = new Faker<Course>()
                .StrictMode(true)
                .RuleFor(c => c.Institution, f => department.Institution)
                .RuleFor(c => c.Department, f => department)
                .RuleFor(c => c.CourseKey, f => Guid.NewGuid())
                .RuleFor(c => c.DisplayName, f => names[nameIndex++])
                .RuleFor(c => c.Level, f => f.Random.Short(100, 499));

            var courses = courseFaker.Generate(coursesToCreate);

            return courses;
        }

        /// <summary>
        /// Generates a unique set of course names.
        /// </summary>
        private static IList<string> GenerateCourseNames(int namesToCreate)
        {
            var nameSet = new HashSet<string>();
            var namesCreated = 0;

            var f = new Faker();

            while (namesCreated < namesToCreate)
            {
                var name = CultureInfo.CurrentCulture.TextInfo.ToTitleCase($"{f.Hacker.IngVerb()} {f.Hacker.Adjective()} {f.Hacker.Noun()}")
                    .ClampLength(max: 40);

                if (nameSet.Add(name))
                    namesCreated++;
            }

            return nameSet.ToList();
        }
    }
}
