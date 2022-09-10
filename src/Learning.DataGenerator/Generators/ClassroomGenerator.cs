using System.Text.RegularExpressions;
using Bogus;
using Learning.DataGenerator.Models;

namespace Learning.DataGenerator.Generators
{
    internal static class ClassroomGenerator
    {
        internal static IList<Classroom> Generate(int classroomsToCreate, Building building)
        {
            var names = GenerateClassroomNames(classroomsToCreate, building);
            var nameIndex = 0;

            var classroomFaker = new Faker<Classroom>()
                .StrictMode(true)
                .RuleFor(c => c.Institution, f => building.Institution)
                .RuleFor(c => c.Campus, f => building.Campus)
                .RuleFor(c => c.Building, f => building)
                .RuleFor(c => c.ClassroomKey, f => Guid.NewGuid())
                .RuleFor(c => c.DisplayName, f => names[nameIndex++]);

            var classrooms = classroomFaker.Generate(classroomsToCreate);

            return classrooms;
        }

        /// <summary>
        /// Generates a unique set of classroom names.
        /// </summary>
        /// <remarks>
        /// See Design Notes on Classroom table definition.
        /// </remarks>
        private static IList<string> GenerateClassroomNames(int namesToCreate, Building building)
        {
            // Remove all non-ASCII alphabet characters.
            var namePrefix = Regex.Replace(building.DisplayName, @"[^A-Za-z]", "")
                .Substring(0, 3)
                .ToUpper();

            var nameSet = new HashSet<string>();
            var namesCreated = 0;

            var f = new Faker();

            while (namesCreated < namesToCreate)
            {
                var quadrant = f.PickRandom(new[] { "A", "B", "C", "D" });
                var floorNumber = f.Random.Byte(1, 12).ToString("00");
                var roomNumber = (f.Random.Short(10, 99) * 10).ToString("000");

                var name = $"{namePrefix}-{quadrant}{floorNumber}-{roomNumber}";

                if (nameSet.Add(name))
                    namesCreated++;
            }

            return nameSet.ToList();
        }
    }
}
