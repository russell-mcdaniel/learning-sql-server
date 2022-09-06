using Bogus;
using Bogus.Extensions;
using Learning.DataGenerator.Models;

namespace Learning.DataGenerator.Generators
{
    internal static class CampusGenerator
    {
        internal static IList<Campus> Generate(Institution institution)
        {
            var toCreate = 2;

            var names = GenerateCampusNames(toCreate);
            var nameIndex = 0;

            var locations = GenerateLocationNames(toCreate);
            var locationIndex = 0;

            var campusFaker = new Faker<Campus>()
                .StrictMode(true)
                .RuleFor(c => c.Institution, f => institution)
                .RuleFor(c => c.CampusKey, f => Guid.NewGuid())
                .RuleFor(c => c.DisplayName, f => names[nameIndex++])
                .RuleFor(c => c.LocationName, f => locations[locationIndex++]);

            var campuses = campusFaker.Generate(toCreate);

            return campuses;
        }

        /// <summary>
        /// Generates a unique set of campus names.
        /// </summary>
        /// <param name="namesToCreate"></param>
        /// <returns></returns>
        private static IList<string> GenerateCampusNames(int namesToCreate)
        {
            var nameSet = new HashSet<string>();
            var namesCreated = 0;

            var f = new Faker();

            while (namesCreated < namesToCreate)
            {
                var name = f.Address.StreetName()
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
