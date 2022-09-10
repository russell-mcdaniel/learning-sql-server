namespace Learning.DataGenerator.Models
{
    public class Department
    {
        public Institution Institution { get; set; }

        public Guid DepartmentKey { get; set; }

        public string DisplayName { get; set; }
    }
}
