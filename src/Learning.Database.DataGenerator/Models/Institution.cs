namespace Learning.Database.DataGenerator.Models
{
    public class Institution
    {
        public Guid InstitutionKey { get; set; }

        public string DisplayName { get; set; }

        public string LocationName { get; set; }

        public TermSystem TermSystem { get; set; }
    }
}
