namespace Learning.DataGenerator.Models
{
    public class TermSystem
    {
        public Guid TermSystemKey { get; set; }

        public string DisplayName { get; set; }

        public IList<TermPeriod> TermPeriods { get; } = new List<TermPeriod>();
    }
}
