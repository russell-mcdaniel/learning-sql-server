namespace Learning.DataGenerator.Models
{
    public class Professor
    {
        public Institution Institution { get; set; }

        public Department Department { get; set; }

        public Guid ProfessorKey { get; set; }

        public string DisplayName { get; set; }
    }
}
