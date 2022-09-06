using Learning.Database.DataGenerator.Models;

namespace Learning.Database.DataGenerator.Data
{
    public interface IEntityRepository
    {
        void Insert(IEnumerable<Institution> institutions);

        void Insert(IEnumerable<TermSystem> systems);
    }
}
