namespace Learning.DataGenerator.Models
{
    public class CourseOfferingEnrollment
    {
        public Institution Institution { get; set; }

        public CourseOffering CourseOffering { get; set; }

        public Student Student { get; set; }

        public byte? Score { get; set; }
    }
}
