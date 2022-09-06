namespace Learning.DataGenerator.Models
{
    public class Building
    {
        public Institution Institution { get; set; }

        public Campus Campus { get; set; }

        public Guid BuildingKey { get; set; }

        public string DisplayName { get; set; }
    }
}
