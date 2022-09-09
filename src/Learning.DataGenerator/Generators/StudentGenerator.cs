using Bogus;
using Bogus.Extensions;
using Learning.DataGenerator.Models;

namespace Learning.DataGenerator.Generators
{
    internal static class StudentGenerator
    {
        internal static IList<Student> Generate(Institution institution)
        {
            var toCreate = 9000;

            var names = GenerateStudentNames(toCreate);
            var nameIndex = 0;

            var studentFaker = new Faker<Student>()
                .StrictMode(true)
                .RuleFor(s => s.Institution, f => institution)
                .RuleFor(s => s.StudentKey, f => Guid.NewGuid())
                .RuleFor(s => s.DisplayName, f => names[nameIndex++]);

            var students = studentFaker.Generate(toCreate);

            return students;
        }

        /// <summary>
        /// Generates a unique set of student names.
        /// </summary>
        private static IList<string> GenerateStudentNames(int namesToCreate)
        {
            var nameSet = new HashSet<string>();
            var namesCreated = 0;

            var f = new Faker();

            while (namesCreated < namesToCreate)
            {
                var name = $"{f.Name.FullName()}"
                    .ClampLength(max: 40);

                if (nameSet.Add(name))
                    namesCreated++;
            }

            return nameSet.ToList();
        }
    }
}
