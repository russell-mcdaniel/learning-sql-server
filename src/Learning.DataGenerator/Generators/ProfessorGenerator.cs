using Bogus;
using Bogus.Extensions;
using Learning.DataGenerator.Models;

namespace Learning.DataGenerator.Generators
{
    internal static class ProfessorGenerator
    {
        internal static IList<Professor> Generate(int professorsToCreate, Department department)
        {
            var names = GenerateProfessorNames(professorsToCreate);
            var nameIndex = 0;

            var professorFaker = new Faker<Professor>()
                .StrictMode(true)
                .RuleFor(p => p.Institution, f => department.Institution)
                .RuleFor(p => p.Department, f => department)
                .RuleFor(p => p.ProfessorKey, f => Guid.NewGuid())
                .RuleFor(p => p.DisplayName, f => names[nameIndex++]);

            var professors = professorFaker.Generate(professorsToCreate);

            return professors;
        }

        /// <summary>
        /// Generates a unique set of professor names.
        /// </summary>
        private static IList<string> GenerateProfessorNames(int namesToCreate)
        {
            var nameSet = new HashSet<string>();
            var namesCreated = 0;

            var f = new Faker();

            while (namesCreated < namesToCreate)
            {
                var name = f.Name.FullName()
                    .ClampLength(max: 40);

                if (nameSet.Add(name))
                    namesCreated++;
            }

            return nameSet.ToList();
        }
    }
}
