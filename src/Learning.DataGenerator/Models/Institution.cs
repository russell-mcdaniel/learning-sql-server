namespace Learning.DataGenerator.Models
{
    public class Institution
    {
        public Guid InstitutionKey { get; set; }

        public string DisplayName { get; set; }

        public string LocationName { get; set; }

        public TermSystem TermSystem { get; set; }

        //public IList<Campus> Campuses { get; } = new List<Campus>();
    }
}
