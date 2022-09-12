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

        public DesignGuidelinesTests()
        {
            Configuration = new ConfigurationBuilder()
                .AddJsonFile("appsettings.json")
                .AddJsonFile("appsettings.Development.json", true)
                .Build();
        }

        /// <remarks>
        /// Checks only the prefix and table name. There is no determistic way to
        /// evaluate the column list segment of the name because the constraint
        /// definition is stored as code instead of discrete metadata.
        /// </remarks>
        [Test]
        public void CheckConstraintsAreNamedCorrectly()
        {
            using var connection = DbConnectionFactory.GetConnection(
                Configuration.GetConnectionString("LearningDatabase"));

            var tables = connection.Query(Query.CheckConstraintsAreNamedCorrectly);
            var tableCount = tables.Count();

            if (tableCount > 0)
            {
                TestContext.WriteLine("The following tables have incorrectly-named constraints:");

                foreach (var table in tables)
                {
                    TestContext.WriteLine($"* {table.schema_name}.{table.table_name} (expected: {table.name_expected} | actual: {table.name_actual})");
                }
            }

            Assert.That(tableCount, Is.Zero);
        }

        [Test]
        public void ForeignKeyConstraintsAreNamedCorrectly()
        {
            using var connection = DbConnectionFactory.GetConnection(
                Configuration.GetConnectionString("LearningDatabase"));

            var tables = connection.Query(Query.ForeignKeyConstraintsAreNamedCorrectly);
            var tableCount = tables.Count();

            if (tableCount > 0)
            {
                TestContext.WriteLine("The following tables have incorrectly-named constraints:");

                foreach (var table in tables)
                {
                    TestContext.WriteLine($"* {table.schema_name}.{table.table_name} (expected: {table.name_expected} | actual: {table.name_actual})");
                }
            }

            Assert.That(tableCount, Is.Zero);
        }

        [Test]
        public void ForeignKeyConstraintsHaveSupportingIndexes()
        {
            // The foreign key columns must be at the beginning of an index key and in the
            // same order with no other columns intermingled. Additional key columns may be
            // okay, but see the design notes on the StudentProgram table script. If there
            // are no notes there regarding indexing, the topic is resolved.

            // TODO: Resolve the indexing question and then design the query for this test.
            Assert.Inconclusive("This test is not implemented.");
        }

        /// <remarks>
        /// Evaluates explicitly defined indexes, not those from primary key or unique constraints.
        /// </remarks>
        [Test]
        public void IndexesAreNamedCorrectly()
        {
            using var connection = DbConnectionFactory.GetConnection(
                Configuration.GetConnectionString("LearningDatabase"));

            var tables = connection.Query(Query.IndexesAreNamedCorrectly);
            var tableCount = tables.Count();

            if (tableCount > 0)
            {
                TestContext.WriteLine("The following tables have incorrectly-named indexes:");

                foreach (var table in tables)
                {
                    TestContext.WriteLine($"* {table.schema_name}.{table.table_name} (expected: {table.name_expected} | actual: {table.name_actual})");
                }
            }

            Assert.That(tableCount, Is.Zero);
        }

        [Test]
        public void TablesHaveClusteredIndexes()
        {
            using var connection = DbConnectionFactory.GetConnection(
                Configuration.GetConnectionString("LearningDatabase"));

            var tables = connection.Query(Query.TablesHaveClusteredIndexes);
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

            var tables = connection.Query(Query.TablesHavePrimaryKeys);
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

            var tables = connection.Query(Query.PrimaryKeyConstraintsAreNamedCorrectly);
            var tableCount = tables.Count();

            if (tableCount > 0)
            {
                TestContext.WriteLine("The following tables have incorrectly-named constraints:");

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

            var tables = connection.Query(Query.UniqueConstraintsAreNamedCorrectly);
            var tableCount = tables.Count();

            if (tableCount > 0)
            {
                TestContext.WriteLine("The following tables have incorrectly-named constraints:");

                foreach (var table in tables)
                {
                    TestContext.WriteLine($"* {table.schema_name}.{table.table_name} (expected: {table.name_expected} | actual: {table.name_actual})");
                }
            }

            Assert.That(tableCount, Is.Zero);
        }

        // TODO: Replace the verbatim strings with raw strings when migrating to C# 11 (.NET 7).
        private static class Query
        {
            public static readonly string CheckConstraintsAreNamedCorrectly =
@"SELECT
	SCHEMA_NAME(t.schema_id)					AS schema_name,
	t.name										AS table_name,
	FORMATMESSAGE(N'ck_%s_*', t.name)			AS name_expected,
	c.name										AS name_actual
FROM
	sys.tables t
INNER JOIN
	sys.check_constraints c
ON
	c.parent_object_id = t.object_id
WHERE
	-- Use case-sensitive collation for comparison.
	c.name COLLATE Latin1_General_100_CS_AS_SC NOT LIKE FORMATMESSAGE(N'ck_%s_%%', t.name) COLLATE Latin1_General_100_CS_AS_SC
ORDER BY
	SCHEMA_NAME(t.schema_id),
	t.name,
	c.name;";

            public static readonly string ForeignKeyConstraintsAreNamedCorrectly =
@"WITH ConstraintName (parent_object_id, name_expected, name_actual)
AS
(
	SELECT
		fk.parent_object_id						AS parent_object_id,
		FORMATMESSAGE(N'fk_%s_%s_%s', OBJECT_NAME(fk.parent_object_id), STRING_AGG(COL_NAME(fkc.parent_object_id, fkc.parent_column_id), N'') WITHIN GROUP (ORDER BY fkc.constraint_column_id), OBJECT_NAME(fk.referenced_object_id))
												AS name_expected,
		fk.name									AS name_actual
	FROM
		sys.foreign_keys fk
	INNER JOIN
		sys.foreign_key_columns fkc
	ON
		fkc.parent_object_id = fk.parent_object_id
	AND
		fkc.constraint_object_id = fk.object_id
	INNER JOIN
		sys.columns c
	ON
		c.object_id = fkc.parent_object_id
	AND
		c.column_id = fkc.parent_column_id
	GROUP BY
		fk.parent_object_id,
		fk.referenced_object_id,
		fk.name
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
	-- Use case-sensitive collation for comparison.
	c.name_actual COLLATE Latin1_General_100_CS_AS_SC <> c.name_expected COLLATE Latin1_General_100_CS_AS_SC
ORDER BY
	SCHEMA_NAME(t.schema_id),
	t.name,
	c.name_actual;";

            public static readonly string IndexesAreNamedCorrectly =
@"WITH IndexName (parent_object_id, name_expected, name_actual)
AS
(
	SELECT
		i.object_id								AS parent_object_id,
		FORMATMESSAGE(N'ix_%s_%s', OBJECT_NAME(i.object_id), STRING_AGG(COL_NAME(ic.object_id, ic.column_id), N'') WITHIN GROUP (ORDER BY ic.key_ordinal))
												AS name_expected,
		i.name									AS name_actual
	FROM
		sys.indexes i
	INNER JOIN
		sys.index_columns ic
	ON
		ic.object_id = i.object_id
	AND
		ic.index_id = i.index_id
	WHERE
		-- Clustered and nonclustered rowstore indexes only for now.
		i.type in (1, 2)
	AND
		i.is_primary_key = 0
	AND
		i.is_unique_constraint = 0
	GROUP BY
		i.object_id,
		i.index_id,
		i.name
)
SELECT
	SCHEMA_NAME(t.schema_id)					AS schema_name,
	t.name										AS table_name,
	i.name_expected								AS name_expected,
	i.name_actual								AS name_actual
FROM
	sys.tables t
INNER JOIN
	IndexName i
ON
	i.parent_object_id = t.object_id
WHERE
	i.name_actual COLLATE Latin1_General_100_CS_AS_SC <> i.name_expected COLLATE Latin1_General_100_CS_AS_SC
ORDER BY
	SCHEMA_NAME(t.schema_id),
	t.name,
	i.name_actual;";

            public static readonly string PrimaryKeyConstraintsAreNamedCorrectly =
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
	-- Use case-sensitive collation for comparison.
	c.name COLLATE Latin1_General_100_CS_AS_SC <> N'pk_' + t.name COLLATE Latin1_General_100_CS_AS_SC
ORDER BY
	SCHEMA_NAME(t.schema_id),
	t.name;";

            public static readonly string TablesHaveClusteredIndexes =
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

            public static readonly string TablesHavePrimaryKeys =
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

            public static readonly string UniqueConstraintsAreNamedCorrectly =
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
	-- Use case-sensitive collation for comparison.
	c.name_actual COLLATE Latin1_General_100_CS_AS_SC <> c.name_expected COLLATE Latin1_General_100_CS_AS_SC
ORDER BY
	SCHEMA_NAME(t.schema_id),
	t.name,
	c.name_actual;";
        }
    }
}
