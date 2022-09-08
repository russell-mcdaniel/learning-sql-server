using Bogus;
using Bogus.Extensions;
using Learning.DataGenerator.Models;

namespace Learning.DataGenerator.Generators
{
    internal static class InstitutionGenerator
    {
        internal static IList<Institution> Generate()
        {
            var toCreate = 2;

            var names = GenerateInstitutionNames(toCreate);
            var nameIndex = 0;

            var locations = GenerateLocationNames(toCreate);
            var locationIndex = 0;

            var institutionFaker = new Faker<Institution>()
                .StrictMode(true)
                .RuleFor(i => i.InstitutionKey, f => Guid.NewGuid())
                .RuleFor(i => i.DisplayName, f => names[nameIndex++])
                .RuleFor(i => i.LocationName, f => locations[locationIndex++]);

            var institutions = institutionFaker.Generate(toCreate);

            return institutions;
        }

        /// <summary>
        /// Generates a unique set of institution names.
        /// </summary>
        private static IList<string> GenerateInstitutionNames(int namesToCreate)
        {
            var nameSet = new HashSet<string>();
            var namesCreated = 0;

            var f = new Faker();

            while (namesCreated < namesToCreate)
            {
                var name = f.Company.CompanyName()
                    .ClampLength(max: 40);

                if (nameSet.Add(name))
                    namesCreated++;
            }

            return nameSet.ToList();
        }

        /// <summary>
        /// Generates a unique set of location names.
        /// </summary>
        private static IList<string> GenerateLocationNames(int namesToCreate)
        {
            var nameSet = new HashSet<string>();
            var namesCreate = 0;

            var f = new Faker();

            while (namesCreate < namesToCreate)
            {
                var name = $"{f.Address.City()}, {f.Address.StateAbbr()}"
                    .ClampLength(max: 40);

                if (nameSet.Add(name))
                    namesCreate++;
            }

            return nameSet.ToList();
        }
    }
}
