using Learning.DataGenerator.Models;

namespace Learning.DataGenerator.Data
{
    public interface IEntityRepository
    {
        void Insert(IEnumerable<Building> buildings);

        void Insert(IEnumerable<Campus> campuses);

        void Insert(IEnumerable<Classroom> classrooms);

        void Insert(IEnumerable<Department> departments);

        void Insert(IEnumerable<Institution> institutions);

        void Insert(IEnumerable<Professor> professors);
    }
}
