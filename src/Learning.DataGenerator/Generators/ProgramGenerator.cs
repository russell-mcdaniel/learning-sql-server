using System.Globalization;
using Bogus;
using Bogus.Extensions;
using Learning.DataGenerator.Models;

namespace Learning.DataGenerator.Generators
{
    internal static class ProgramGenerator
    {
        internal static IList<ProgramLdb> Generate(Department department)
        {
            var toCreate = 4;

            var names = GenerateProgramNames(toCreate);
            var nameIndex = 0;

            var programFaker = new Faker<ProgramLdb>()
                .StrictMode(true)
                .RuleFor(p => p.Institution, f => department.Institution)
                .RuleFor(p => p.Department, f => department)
                .RuleFor(p => p.ProgramKey, f => Guid.NewGuid())
                .RuleFor(p => p.DisplayName, f => names[nameIndex++])
                .RuleFor(p => p.ProgramType, f => f.PickRandom(new[] { "Major", "Minor" }).ClampLength(max: 10));

            var programs = programFaker.Generate(toCreate);

            return programs;
        }

        /// <summary>
        /// Generates a unique set of program names.
        /// </summary>
        private static IList<string> GenerateProgramNames(int namesToCreate)
        {
            var nameSet = new HashSet<string>();
            var namesCreated = 0;

            var f = new Faker();

            while (namesCreated < namesToCreate)
            {
                var suffix = f.PickRandom(new[] { "appreciation", "culture", "design", "development", "education", "engineering", "history", "language", "management", "mechanics", "science", "studies", "systems" });
                var name = CultureInfo.CurrentCulture.TextInfo.ToTitleCase($"{f.Random.Word()} {suffix}")
                    .ClampLength(max: 40);

                if (nameSet.Add(name))
                    namesCreated++;
            }

            return nameSet.ToList();
        }
    }
}
