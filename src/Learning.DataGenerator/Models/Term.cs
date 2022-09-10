namespace Learning.DataGenerator.Models
{
    public class Term
    {
        public Institution Institution { get; set; }

        public Guid TermKey { get; set; }

        public string AcademicYear { get; set; }

        public short CalendarYear { get; set; }

        public string SeasonName { get; set; }
    }
}
