namespace Learning.DataGenerator.Models
{
    public class CourseOffering
    {
        public Institution Institution { get; set; }

        public Guid CourseOfferingKey { get; set; }

        public Department Department { get; set; }

        public Course Course { get; set; }

        public Professor Professor { get; set; }

        public Campus Campus { get; set; }

        public Building Building { get; set; }

        public Classroom Classroom { get; set; }

        public Term Term { get; set; }
    }
}
