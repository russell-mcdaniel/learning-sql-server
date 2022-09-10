using Learning.DataGenerator.Models;

namespace Learning.DataGenerator.Generators
{
    internal static class TermGenerator
    {
        internal static IList<Term> Generate(int academicYearsToCreate, Institution institution)
        {
            // The year refers to the beginning of an academic year, so it is the
            // fall term (semester) for the "{Year}-{Year + 1}" academic year.

            // The range is inclusive, so add one to get the correct starting year.
            var yearStart = DateTime.Now.Year - academicYearsToCreate + 1;
            var yearEnd = DateTime.Now.Year;

            var terms = new List<Term>();

            for (int year = yearStart; year <= yearEnd; year++)
            {
                var fall = new Term
                {
                    Institution = institution,
                    TermKey = Guid.NewGuid(),
                    AcademicYear = $"{year}-{year + 1}",
                    CalendarYear = (short)year,
                    SeasonName = "Fall"
                };

                terms.Add(fall);

                var spring = new Term
                {
                    Institution = institution,
                    TermKey = Guid.NewGuid(),
                    AcademicYear = $"{year}-{year + 1}",
                    CalendarYear = (short)(year + 1),
                    SeasonName = "Spring"
                };

                terms.Add(spring);
            }

            return terms;
        }
    }
}
