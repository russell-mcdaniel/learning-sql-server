using Learning.DataGenerator.Models;

namespace Learning.DataGenerator.Generators
{
    public class GeneratorOptions
    {
        /// <summary>
        /// Gets or sets the number of buildings per campus to generate.
        /// </summary>
        public int Buildings { get; set; }

        /// <summary>
        /// Gets or sets the number of campuses per institution to generate.
        /// </summary>
        public int Campuses { get; set; }

        /// <summary>
        /// Gets or sets the number of classrooms per building to generate.
        /// </summary>
        public int Classrooms { get; set; }

        /// <summary>
        /// Gets or sets the number of course offerings per professor per term to generate.
        /// </summary>
        public int CourseOfferings { get; set; }

        /// <summary>
        /// Gets or sets the number of course offering enrollments per student per term to generate.
        /// </summary>
        public int CourseOfferingEnrollments { get; set; }

        /// <summary>
        /// Gets or sets the number of courses per department to generate.
        /// </summary>
        public int Courses { get; set; }

        /// <summary>
        /// Gets or sets the number of departments per institution to generate.
        /// </summary>
        public int Departments { get; set; }

        /// <summary>
        /// Gets or sets the number of institutions to generate.
        /// </summary>
        public int Institutions { get; set; }

        /// <summary>
        /// Gets or sets the number of professors per department to generate.
        /// </summary>
        public int Professors { get; set; }

        /// <summary>
        /// Gets or sets the number of courses to assign per program type.
        /// </summary>
        public Dictionary<string, int> ProgramCourses { get; set; }

        /// <summary>
        /// Gets or sets the number of programs per department to generate.
        /// </summary>
        public int Programs { get; set; }

        /// <summary>
        /// Gets the number of program types per student to declare.
        /// </summary>
        public Dictionary<string, (int, int)> StudentPrograms { get; } = new Dictionary<string, (int, int)>
        {
            { StudentProgramDeclaration.MajorMajor, (2, 0) },
            { StudentProgramDeclaration.MajorMinor, (1, 1) },
            { StudentProgramDeclaration.MajorOnly, (1, 0) }
        };

        /// <summary>
        /// Gets or sets the number of students per institution to generate.
        /// </summary>
        public int Students { get; set; }

        /// <summary>
        /// Gets or sets the number of academic years of terms to generate.
        /// </summary>
        public int Years { get; set; }
    }
}
