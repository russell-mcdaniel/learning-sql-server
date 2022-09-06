using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Dapper;
using Learning.Database.DataGenerator.Models;

namespace Learning.Database.DataGenerator.Data
{
    public class EntityRepository : IEntityRepository
    {
        private readonly IConfiguration _config;
        private readonly ILogger<EntityRepository> _logger;

        public EntityRepository(
            IConfiguration config,
            ILogger<EntityRepository> logger)
        {
            _config = config;
            _logger = logger;
        }

        public void Insert(IEnumerable<Institution> institutions)
        {
            using var connection = DbConnectionFactory.GetConnection(
                _config.GetConnectionString("LearningDatabase"));

            connection.Execute(
                "INSERT INTO Organization.Institution (InstitutionKey, DisplayName, LocationName, TermSystemKey) VALUES (@InstitutionKey, @DisplayName, @LocationName, @TermSystemKey);",
                from i in institutions select new { i.InstitutionKey, i.DisplayName, i.LocationName, i.TermSystem.TermSystemKey });
        }

        public void Insert(IEnumerable<TermSystem> systems)
        {
            using var connection = DbConnectionFactory.GetConnection(
                _config.GetConnectionString("LearningDatabase"));

            foreach (var system in systems)
            {
                connection.Execute(
                    "INSERT INTO Core.TermSystem (TermSystemKey, DisplayName) VALUES (@TermSystemKey, @DisplayName);",
                    new { system.TermSystemKey, system.DisplayName });

                connection.Execute(
                    "INSERT INTO Core.TermPeriod (TermSystemKey, TermPeriodKey, DisplayName, Ordinal) VALUES (@TermSystemKey, @TermPeriodKey, @DisplayName, @Ordinal);",
                    from tp in system.TermPeriods select new { system.TermSystemKey, tp.TermPeriodKey, tp.DisplayName, tp.Ordinal });
            }
        }
    }
}
