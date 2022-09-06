using System.Data;
using Microsoft.Data.SqlClient;

namespace Learning.Database.DataGenerator.Data
{
    public static class DbConnectionFactory
    {
        // TODO: Decide whether to use the options pattern or a directly configured connection string.
        public static IDbConnection GetConnection(DbConnectionOptions options)
        {
            var builder = new SqlConnectionStringBuilder()
            {
                DataSource = options.DataSource,
                InitialCatalog = options.InitialCatalog,
                UserID = options.UserID,
                Password = options.Password,
                PersistSecurityInfo = false,
                Encrypt = true,
                TrustServerCertificate = true,
                ApplicationName = "Learning Database Data Generator"
            };

            return new SqlConnection(builder.ConnectionString);
        }

        public static IDbConnection GetConnection(string connectionString)
        {
            return new SqlConnection(connectionString);
        }
    }
}
