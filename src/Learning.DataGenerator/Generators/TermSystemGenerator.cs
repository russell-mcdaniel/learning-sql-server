using Learning.DataGenerator.Models;

namespace Learning.DataGenerator.Factories
{
    internal static class TermSystemGenerator
    {
        /// <summary>
        /// Generates the term systems.
        /// </summary>
        /// <remarks>
        /// The summer period is omitted for each system to reflect the enrollment pattern of a typical student.
        /// </remarks>
        internal static IList<TermSystem> Generate()
        {
            var quarterSystem = new TermSystem { TermSystemKey = Guid.NewGuid(), DisplayName = "Quarter" };
            quarterSystem.TermPeriods.Add(new TermPeriod { TermPeriodKey = Guid.NewGuid(), DisplayName = "Fall", Ordinal = 1 });
            quarterSystem.TermPeriods.Add(new TermPeriod { TermPeriodKey = Guid.NewGuid(), DisplayName = "Winter", Ordinal = 2 });
            quarterSystem.TermPeriods.Add(new TermPeriod { TermPeriodKey = Guid.NewGuid(), DisplayName = "Spring", Ordinal = 3 });

            var semesterSystem = new TermSystem { TermSystemKey = Guid.NewGuid(), DisplayName = "Semester" };
            semesterSystem.TermPeriods.Add(new TermPeriod { TermPeriodKey = Guid.NewGuid(), DisplayName = "Fall", Ordinal = 1 });
            semesterSystem.TermPeriods.Add(new TermPeriod { TermPeriodKey = Guid.NewGuid(), DisplayName = "Spring", Ordinal = 2 });

            return new List<TermSystem> { quarterSystem, semesterSystem };
        }
    }
}
