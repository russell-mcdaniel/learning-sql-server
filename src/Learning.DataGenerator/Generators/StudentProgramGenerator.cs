using Bogus;
using Learning.DataGenerator.Models;

namespace Learning.DataGenerator.Generators
{
    internal static class StudentProgramGenerator
    {
        internal static IList<StudentProgram> Generate(IDictionary<string, (int, int)> studentProgramsToCreate, IList<Student> students, IList<ProgramLdb> programs)
        {
            var majorPrograms = (from p in programs where p.ProgramType == ProgramType.Major select p).ToList();
            var minorPrograms = (from p in programs where p.ProgramType == ProgramType.Minor select p).ToList();

            var f = new Faker();

            var studentPrograms = new List<StudentProgram>();

            foreach (var student in students)
            {
                var studentProgramType = f.PickRandom(new[] { StudentProgramDeclaration.MajorMajor, StudentProgramDeclaration.MajorMinor, StudentProgramDeclaration.MajorOnly });
                (var majorProgramsToSelect, var minorProgramsToSelect) = studentProgramsToCreate[studentProgramType];

                var selectedPrograms = new List<ProgramLdb>();

                // Select major(s).
                selectedPrograms.AddRange(
                    SelectPrograms(majorProgramsToSelect, majorPrograms));

                // Select minor(s).
                selectedPrograms.AddRange(
                    SelectPrograms(minorProgramsToSelect, minorPrograms));

                // Create student programs.
                studentPrograms.AddRange(
                    CreateStudentPrograms(student, selectedPrograms));
            }

            return studentPrograms;
        }

        private static IList<StudentProgram> CreateStudentPrograms(Student student, IList<ProgramLdb> programs)
        {
            var studentPrograms = new List<StudentProgram>();

            foreach (var program in programs)
            {
                var studentProgram = new StudentProgram
                {
                    Institution = student.Institution,
                    Student = student,
                    Department = program.Department,
                    Program = program
                };

                studentPrograms.Add(studentProgram);
            }

            return studentPrograms;
        }

        /// <summary>
        /// Selects a unique set of programs.
        /// </summary>
        private static IList<ProgramLdb> SelectPrograms(int programsToSelect, IList<ProgramLdb> programs)
        {
            var programSet = new HashSet<ProgramLdb>();
            var programsSelected = 0;

            var f = new Faker();

            while (programsSelected < programsToSelect)
            {
                var program = f.PickRandom(programs);

                if (programSet.Add(program))
                    programsSelected++;
            }

            return programSet.ToList();
        }
    }
}
