using Learning.DataGenerator.Models;

namespace Learning.DataGenerator.Data
{
    public interface IEntityRepository
    {
        void Insert(IEnumerable<Building> buildings);

        void Insert(IEnumerable<Campus> campuses);

        void Insert(IEnumerable<Institution> institutions);

        void Insert(IEnumerable<TermSystem> systems);
    }
}
