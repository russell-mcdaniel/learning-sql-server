namespace Learning.DataGenerator.Models
{
    public class Course
    {
        public Institution Institution { get; set; }

        public Department Department { get; set; }

        public Guid CourseKey { get; set; }

        public string DisplayName { get; set; }

        public short Level { get; set; }
    }
}
