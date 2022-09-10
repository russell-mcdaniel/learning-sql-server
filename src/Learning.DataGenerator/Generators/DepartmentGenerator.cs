using Bogus;
using Bogus.Extensions;
using Learning.DataGenerator.Models;

namespace Learning.DataGenerator.Generators
{
    internal static class DepartmentGenerator
    {
        internal static IList<Department> Generate(int departmentsToCreate, Institution institution)
        {
            var names = GenerateDepartmentNames(departmentsToCreate);
            var nameIndex = 0;

            var departmentFaker = new Faker<Department>()
                .StrictMode(true)
                .RuleFor(d => d.Institution, f => institution)
                .RuleFor(d => d.DepartmentKey, f => Guid.NewGuid())
                .RuleFor(d => d.DisplayName, f => names[nameIndex++]);

            var departments = departmentFaker.Generate(departmentsToCreate);

            return departments;
        }

        /// <summary>
        /// Generates a unique set of department names.
        /// </summary>
        private static IList<string> GenerateDepartmentNames(int namesToCreate)
        {
            var nameSet = new HashSet<string>();
            var namesCreated = 0;

            var f = new Faker();

            while (namesCreated < namesToCreate)
            {
                var name = $"Dept. of {f.Name.JobArea()}"
                    .ClampLength(max: 40);

                if (nameSet.Add(name))
                    namesCreated++;
            }

            return nameSet.ToList();
        }
    }
}
