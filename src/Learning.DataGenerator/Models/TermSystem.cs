namespace Learning.DataGenerator.Models
{
    public class TermSystem
    {
        public Guid TermSystemKey { get; set; }

        public string DisplayName { get; set; }

        public List<TermPeriod> TermPeriods { get; } = new List<TermPeriod>();
    }
}
