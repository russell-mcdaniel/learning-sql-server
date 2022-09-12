using Microsoft.Extensions.Configuration;
using Dapper;
using NUnit.Framework.Internal;
using Learning.Database.Tests.Data;

namespace Learning.Database.Tests
{
    [TestFixture]
    [FixtureLifeCycle(LifeCycle.SingleInstance)]
    public class DesignGuidelinesTests
    {
        private IConfigurationRoot Configuration { get; }

        // TODO: For SQL queries, replace the verbatim strings with raw strings when migrating to C# 11 (.NET 7).
        public DesignGuidelinesTests()
        {
            Configuration = new ConfigurationBuilder()
                .AddJsonFile("appsettings.json")
                .AddJsonFile("appsettings.Development.json", true)
                .Build();
        }

        [Test]
        public void TablesHaveClusteredIndexes()
        {
            using var connection = DbConnectionFactory.GetConnection(
                Configuration.GetConnectionString("LearningDatabase"));

            var sql =
@"SELECT
	SCHEMA_NAME(t.schema_id)					AS schema_name,
	t.name										AS table_name
FROM
	sys.tables t

EXCEPT

SELECT
	OBJECT_SCHEMA_NAME(i.object_id)				AS schema_name,
	OBJECT_NAME(i.object_id)					AS table_name
FROM
	sys.indexes i
INNER JOIN
	sys.objects o
ON
	o.object_id = i.object_id
WHERE
	i.index_id = 1

ORDER BY
	schema_name,
	table_name;";

            var tables = connection.Query(sql);
            var tableCount = tables.Count();

            if (tableCount > 0)
            {
                TestContext.WriteLine("The following tables do not have clustered indexes:");

                foreach (var table in tables)
                {
                    TestContext.WriteLine($"* {table.schema_name}.{table.table_name}");
                }
            }

            Assert.That(tableCount, Is.Zero);
        }

        [Test]
        public void TablesHavePrimaryKeys()
        {
            using var connection = DbConnectionFactory.GetConnection(
                Configuration.GetConnectionString("LearningDatabase"));

            var sql =
@"SELECT
    SCHEMA_NAME(t.schema_id)                    AS schema_name,
    t.name                                      AS table_name
FROM
    sys.tables t

EXCEPT

SELECT
    OBJECT_SCHEMA_NAME(c.parent_object_id)      AS schema_name,
    OBJECT_NAME(c.parent_object_id)             AS table_name
FROM
    sys.key_constraints c
WHERE
    c.type = N'PK'

ORDER BY
    schema_name,
    table_name;";

            var tables = connection.Query(sql);
            var tableCount = tables.Count();

            if (tableCount > 0)
            {
                TestContext.WriteLine("The following tables do not have primary keys:");

                foreach (var table in tables)
                {
                    TestContext.WriteLine($"* {table.schema_name}.{table.table_name}");
                }
            }

            Assert.That(tableCount, Is.Zero);
        }

        [Test]
        public void PrimaryKeyConstraintsAreNamedCorrectly()
        {
            using var connection = DbConnectionFactory.GetConnection(
                Configuration.GetConnectionString("LearningDatabase"));

            var sql =
@"SELECT
	SCHEMA_NAME(t.schema_id)					AS schema_name,
	t.name										AS table_name,
	N'pk_' + t.name								AS name_expected,
	c.name										AS name_actual
FROM
	sys.tables t
INNER JOIN
	sys.key_constraints c
ON
	c.parent_object_id = t.object_id
AND
	c.type = N'PK'
WHERE
	c.name <> N'pk_' + t.name
ORDER BY
	SCHEMA_NAME(t.schema_id),
	t.name;";

            var tables = connection.Query(sql);
            var tableCount = tables.Count();

            if (tableCount > 0)
            {
                TestContext.WriteLine("The following tables do not have correctly-named primary key constraints:");

                foreach (var table in tables)
                {
                    TestContext.WriteLine($"* {table.schema_name}.{table.table_name} (expected: {table.name_expected} | actual: {table.name_actual})");
                }
            }

            Assert.That(tableCount, Is.Zero);
        }

        [Test]
        public void UniqueConstraintsAreNamedCorrectly()
        {
            using var connection = DbConnectionFactory.GetConnection(
                Configuration.GetConnectionString("LearningDatabase"));

            var sql =
@"WITH ConstraintName (parent_object_id, name_expected, name_actual)
AS
(
	SELECT
		c.parent_object_id						AS parent_object_id,
		FORMATMESSAGE(N'uk_%s_%s', OBJECT_NAME(c.parent_object_id), STRING_AGG(COL_NAME(ic.object_id, ic.column_id), N'') WITHIN GROUP (ORDER BY ic.key_ordinal))
												AS name_expected,
		c.name									AS name_actual
	FROM
		sys.key_constraints c
	INNER JOIN
		sys.index_columns ic
	ON
		ic.object_id = c.parent_object_id
	AND
		ic.index_id = c.unique_index_id
	WHERE
		c.type = N'UQ'
	GROUP BY
		c.parent_object_id,
		c.name
)
SELECT
	SCHEMA_NAME(t.schema_id)					AS schema_name,
	t.name										AS table_name,
	c.name_expected								AS name_expected,
	c.name_actual								AS name_actual
FROM
	sys.tables t
INNER JOIN
	ConstraintName c
ON
	c.parent_object_id = t.object_id
WHERE
	c.name_actual <> c.name_expected
ORDER BY
	SCHEMA_NAME(t.schema_id),
	t.name,
	c.name_actual;";

            var tables = connection.Query(sql);
            var tableCount = tables.Count();

            if (tableCount > 0)
            {
                TestContext.WriteLine("The following tables do not have correctly-named unique constraints:");

                foreach (var table in tables)
                {
                    TestContext.WriteLine($"* {table.schema_name}.{table.table_name} (expected: {table.name_expected} | actual: {table.name_actual})");
                }
            }

            Assert.That(tableCount, Is.Zero);
        }

        // TODO: Outstanding tests to create:
        // * Foreign keys named incorrectly.
        // * Check constraints named incorrectly.
        //   Only a partial check is possible.There is no determistic way to evaluate the column
        //   list portion of the name because the constraint definition is stored as code instead
        //   of discrete metadata.
        // * Non-key indexes named incorrectly.
        // * Foreign keys without supporting indexes.
    }
}
