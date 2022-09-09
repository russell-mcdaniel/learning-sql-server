namespace Learning.DataGenerator.Models
{
    public class Student
    {
        public Institution Institution { get; set; }

        public Guid StudentKey { get; set; }

        public string DisplayName { get; set; }
    }
}
