using Bogus;
using Bogus.Extensions;
using Learning.DataGenerator.Models;

namespace Learning.DataGenerator.Generators
{
    internal static class BuildingGenerator
    {
        internal static IList<Building> Generate(int buildingsToCreate, Campus campus)
        {
            var names = GenerateBuildingNames(buildingsToCreate);
            var nameIndex = 0;

            var buildingFaker = new Faker<Building>()
                .StrictMode(true)
                .RuleFor(b => b.Institution, f => campus.Institution)
                .RuleFor(b => b.Campus, f => campus)
                .RuleFor(b => b.BuildingKey, f => Guid.NewGuid())
                .RuleFor(b => b.DisplayName, f => names[nameIndex++]);

            var buildings = buildingFaker.Generate(buildingsToCreate);

            return buildings;
        }

        /// <summary>
        /// Generates a unique set of building names.
        /// </summary>
        private static IList<string> GenerateBuildingNames(int namesToCreate)
        {
            var nameSet = new HashSet<string>();
            var namesCreated = 0;

            var f = new Faker();

            while (namesCreated < namesToCreate)
            {
                var type = f.PickRandom(new[] { "Building", "Center", "Hall", "Pavilion", "Union" });
                var name = $"{f.Name.LastName()} {type}"
                    .ClampLength(max: 40);

                if (nameSet.Add(name))
                    namesCreated++;
            }

            return nameSet.ToList();
        }
    }
}
