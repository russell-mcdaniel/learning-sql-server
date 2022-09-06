using Bogus;
using Learning.Database.DataGenerator.Models;

namespace Learning.Database.DataGenerator.Generators
{
    internal static class InstitutionGenerator
    {
        internal static IList<Institution> Generate(IList<TermSystem> systems)
        {
            var institutionsToCreate = 10;

            var names = GenerateInstitutionNames(institutionsToCreate);
            var locations = GenerateLocationNames(institutionsToCreate);

            var institutionIndex = 0;
            var locationIndex = 0;

            var institutionFaker = new Faker<Institution>()
                .StrictMode(true)
                .RuleFor(i => i.InstitutionKey, f => Guid.NewGuid())
                .RuleFor(i => i.DisplayName, f => names[institutionIndex++])
                .RuleFor(i => i.LocationName, f => locations[locationIndex++])
                .RuleFor(i => i.TermSystem, f => f.PickRandom(systems));

            var institutions = institutionFaker.Generate(institutionsToCreate);

            return institutions;
        }

        /// <summary>
        /// Generates a unique set of institution names.
        /// </summary>
        /// <param name="namesToCreate"></param>
        /// <returns></returns>
        private static IList<string> GenerateInstitutionNames(int namesToCreate)
        {
            var nameSet = new HashSet<string>();
            var namesCreated = 0;

            var f = new Faker();

            while (namesCreated < namesToCreate)
            {
                var name = f.Company.CompanyName();

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
                var name = $"{f.Address.City()}, {f.Address.StateAbbr()}";

                if (nameSet.Add(name))
                    namesCreate++;
            }

            return nameSet.ToList();
        }
    }
}
