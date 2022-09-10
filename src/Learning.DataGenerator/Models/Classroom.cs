namespace Learning.DataGenerator.Models
{
    public class Classroom
    {
        public Institution Institution { get; set; }

        public Campus Campus { get; set; }

        public Building Building { get; set; }

        public Guid ClassroomKey { get; set; }

        public string DisplayName { get; set; }
    }
}
