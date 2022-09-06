namespace Learning.DataGenerator.Models
{
    public class Campus
    {
        public Institution Institution { get; set; }

        public Guid CampusKey { get; set; }

        public string DisplayName { get; set; }

        public string LocationName { get; set; }
    }
}
