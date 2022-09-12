using System.Data;
using Microsoft.Data.SqlClient;

namespace Learning.Database.Tests.Data
{
    public static class DbConnectionFactory
    {
        public static IDbConnection GetConnection(string connectionString)
        {
            return new SqlConnection(connectionString);
        }
    }
}
