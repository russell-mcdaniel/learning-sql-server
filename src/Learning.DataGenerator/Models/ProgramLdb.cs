namespace Learning.DataGenerator.Models
{
    /// <summary>
    /// Represents an academic program (major, minor) offered by a department.
    /// </summary>
    /// <remarks>
    /// This class is named ProgramLdb to avoid a conflict with the Program class
    /// in the global namespace.
    /// </remarks>
    public class ProgramLdb
    {
        public Institution Institution { get; set; }

        public Department Department { get; set; }

        public Guid ProgramKey { get; set; }

        public string DisplayName { get; set; }

        public string ProgramType { get; set; }
    }
}
