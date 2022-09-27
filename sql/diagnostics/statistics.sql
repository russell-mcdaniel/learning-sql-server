-- ================================================================================
-- Display information about statistics.
--
-- The incremental statistics view is similar, but not exactly the
-- same. Deferring a query for it until it is needed.
--
-- DBCC SHOW_STATISTICS (N'Tree.CtCategory', N'ix_CtCategory_Name');
--
-- References:
-- * https://learn.microsoft.com/en-us/sql/relational-databases/statistics/statistics
-- * https://learn.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-stats-transact-sql
-- * https://learn.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-stats-columns-transact-sql
-- * https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-db-stats-properties-transact-sql
-- * https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-db-incremental-stats-properties-transact-sql
-- * https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-db-stats-histogram-transact-sql
-- ================================================================================
USE Demo;
GO

-- Display statistics columns.
SELECT
--	s.object_id								AS object_id,
	OBJECT_SCHEMA_NAME(s.object_id)			AS schema_name,
	OBJECT_NAME(s.object_id)				AS table_name,
--	s.stats_id								AS stats_id,
	s.name									AS stats_name,
	c.name									AS col_name,
	sc.stats_column_id						AS col_ord
FROM
	sys.stats s
INNER JOIN
	sys.stats_columns sc
ON
	sc.object_id = s.object_id
AND
	sc.stats_id = s.stats_id
INNER JOIN
	sys.columns c
ON
	c.object_id = sc.object_id
AND
	c.column_id = sc.column_id
WHERE
	OBJECT_SCHEMA_NAME(s.object_id)	<> N'sys'
ORDER BY
	OBJECT_SCHEMA_NAME(s.object_id),
	OBJECT_NAME(s.object_id),
	s.name,
	sc.stats_column_id;
GO

-- Display statistics properties.
SELECT
--	s.object_id								AS object_id,
	OBJECT_SCHEMA_NAME(s.object_id)			AS schema_name,
	OBJECT_NAME(s.object_id)				AS table_name,
--	s.stats_id								AS stats_id,
	s.name									AS stats_name,
	s.stats_generation_method_desc			AS gen_method,
	s.auto_created							AS auto_created,
	s.auto_drop								AS auto_drop,
	s.is_incremental						AS is_inc,
	s.has_filter							AS has_filter,
	s.has_persisted_sample					AS has_pers_sample,
	p.persisted_sample_percent				AS pers_sample_pct,
	p.rows									AS rows,
	p.rows_sampled							AS rows_sampled,
	p.unfiltered_rows						AS unfiltered_rows,
	p.steps									AS steps,
	p.modification_counter					AS mod_counter,
	p.last_updated							AS last_updated
FROM
	sys.stats s
CROSS APPLY
	sys.dm_db_stats_properties(s.object_id, s.stats_id) p
WHERE
	OBJECT_SCHEMA_NAME(s.object_id)	<> N'sys'
ORDER BY
	OBJECT_SCHEMA_NAME(s.object_id),
	OBJECT_NAME(s.object_id),
	s.name;
GO

-- Display statistics histogram.
SELECT
--	s.object_id								AS object_id,
	OBJECT_SCHEMA_NAME(s.object_id)			AS schema_name,
	OBJECT_NAME(s.object_id)				AS table_name,
--	s.stats_id								AS stats_id,
	s.name									AS stats_name,
	h.step_number							AS step_number,
	h.range_high_key						AS range_high_key,
	h.range_rows							AS range_rows,
	h.equal_rows							AS equal_rows,
	h.distinct_range_rows					AS dst_rng_rows,
	h.average_range_rows					AS avg_rng_rows
FROM
	sys.stats s
CROSS APPLY
	sys.dm_db_stats_histogram(s.object_id, s.stats_id) h
WHERE
	s.object_id IN
	(
		OBJECT_ID(N'Tree.CtCategoryHierarchy')
	)
ORDER BY
	OBJECT_SCHEMA_NAME(s.object_id),
	OBJECT_NAME(s.object_id),
	s.name,
	h.step_number;
GO
