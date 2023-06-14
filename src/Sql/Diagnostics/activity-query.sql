--
-- Display execution metrics for queries.
--
-- Design Notes
--
-- Queries are grouped by query hash. In general, this is desirable to see
-- the overall impact of the same queries, but it comes with some caveats.
--
-- The same statement can have multiple plans. Consider this when aggregating
-- metrics. Even though the queries are the same, this could group queries with
-- different performance characteristics and hide different performance profiles
-- of the same query depending on the circumstances.
-- 
-- The same statement can exist in different batches. This is rare, but it can
-- affect the result set in unexpected ways.
--
USE master;
GO

-- https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-exec-query-stats-transact-sql
WITH rm_exec_query_stats
AS
(
	SELECT
		MAX(qs.last_execution_time)														AS last_execution_time,
		SUM(qs.execution_count)															AS execution_count,

		MAX(qs.last_elapsed_time)														AS last_elapsed_time,
		MIN(qs.min_elapsed_time)														AS min_elapsed_time,
		MAX(qs.max_elapsed_time)														AS max_elapsed_time,
		SUM(qs.total_elapsed_time)														AS total_elapsed_time,

		MAX(qs.last_worker_time)														AS last_worker_time,
		MIN(qs.min_worker_time)															AS min_worker_time,
		MAX(qs.max_worker_time)															AS max_worker_time,
		SUM(qs.total_worker_time)														AS total_worker_time,

		MAX(qs.last_logical_reads)														AS last_logical_reads,
		MIN(qs.min_logical_reads)														AS min_logical_reads,
		MAX(qs.max_logical_reads)														AS max_logical_reads,
		SUM(qs.total_logical_reads)														AS total_logical_reads,

		MAX(qs.last_physical_reads)														AS last_physical_reads,
		MIN(qs.min_physical_reads)														AS min_physical_reads,
		MAX(qs.max_physical_reads)														AS max_physical_reads,
		SUM(qs.total_physical_reads)													AS total_physical_reads,

		MAX(qs.last_logical_writes)														AS last_logical_writes,
		MIN(qs.min_logical_writes)														AS min_logical_writes,
		MAX(qs.max_logical_writes)														AS max_logical_writes,
		SUM(qs.total_logical_writes)													AS total_logical_writes,

		MAX(qs.last_dop)																AS last_dop,
		MIN(qs.min_dop)																	AS min_dop,
		MAX(qs.max_dop)																	AS max_dop,
		SUM(qs.total_dop)																AS total_dop,

		MAX(qs.last_grant_kb)															AS last_grant_kb,
		MIN(qs.min_grant_kb)															AS min_grant_kb,
		MAX(qs.max_grant_kb)															AS max_grant_kb,
		SUM(qs.total_grant_kb)															AS total_grant_kb,

		MAX(qs.last_used_grant_kb)														AS last_used_grant_kb,
		MIN(qs.min_used_grant_kb)														AS min_used_grant_kb,
		MAX(qs.max_used_grant_kb)														AS max_used_grant_kb,
		SUM(qs.total_used_grant_kb)														AS total_used_grant_kb,

		MAX(qs.last_ideal_grant_kb)														AS last_ideal_grant_kb,
		MIN(qs.min_ideal_grant_kb)														AS min_ideal_grant_kb,
		MAX(qs.max_ideal_grant_kb)														AS max_ideal_grant_kb,
		SUM(qs.total_ideal_grant_kb)													AS total_ideal_grant_kb,

		qs.query_hash																	AS query_hash,
		COUNT(*)																		AS query_hash_count,
		-- Get arbitrary handles and SQL text from those that apply to a given query
		-- hash. They should be roughly equivalent for most practical purposes.
		MAX(qs.plan_handle)																AS plan_handle,
		MAX(qs.sql_handle)																AS sql_handle,
		MAX(SUBSTRING(
			st.text,
			qs.statement_start_offset / 2 + 1,
			(CASE qs.statement_end_offset WHEN -1 THEN DATALENGTH(st.text) ELSE qs.statement_end_offset END - qs.statement_start_offset) / 2 + 1))
																						AS sql_text
	FROM
		sys.dm_exec_query_stats qs
	CROSS APPLY
		sys.dm_exec_sql_text(qs.sql_handle) st
	GROUP BY
		qs.query_hash
)
SELECT
	qs.last_execution_time																AS ex_last_time,
	qs.execution_count																	AS ex_count,
	
	CAST(1.0 * qs.total_elapsed_time / qs.execution_count / 1000 AS decimal(13,1))		AS dur_avg,
	CAST(1.0 * qs.last_elapsed_time / 1000 AS decimal(10,1))							AS dur_last,
	CAST(1.0 * qs.min_elapsed_time / 1000 AS decimal(10,1))								AS dur_min,
	CAST(1.0 * qs.max_elapsed_time / 1000 AS decimal(10,1))								AS dur_max,
	CAST(1.0 * qs.total_elapsed_time / 1000 AS decimal(10,1))							AS dur_tot,
	
	CAST(1.0 * qs.total_worker_time / qs.execution_count / 1000 AS decimal(13,1))		AS cpu_avg,
	CAST(1.0 * qs.last_worker_time / 1000 AS decimal(10,1))								AS cpu_last,
	CAST(1.0 * qs.min_worker_time / 1000 AS decimal(10,1))								AS cpu_min,
	CAST(1.0 * qs.max_worker_time / 1000 AS decimal(10,1))								AS cpu_max,
	CAST(1.0 * qs.total_worker_time / 1000 AS decimal(10,1))							AS cpu_tot,
	
	CAST(1.0 * qs.total_logical_reads / qs.execution_count AS decimal(13,1))			AS lr_avg,
	qs.last_logical_reads																AS lr_last,
	qs.min_logical_reads																AS lr_min,
	qs.max_logical_reads																AS lr_max,
	qs.total_logical_reads																AS lr_tot,
	
	CAST(1.0 * qs.total_physical_reads / qs.execution_count AS decimal(13,1))			AS pr_avg,
	qs.last_physical_reads																AS pr_last,
	qs.min_physical_reads																AS pr_min,
	qs.max_physical_reads																AS pr_max,
	qs.total_physical_reads																AS pr_tot,
	
	CAST(1.0 * qs.total_logical_writes / qs.execution_count AS decimal(13,1))			AS lw_avg,
	qs.last_logical_writes																AS lw_last,
	qs.min_logical_writes																AS lw_min,
	qs.max_logical_writes																AS lw_max,
	qs.total_logical_writes																AS lw_tot,

	CAST(1.0 * qs.total_dop / qs.execution_count AS decimal(13,1))						AS dop_avg,
	qs.last_dop																			AS dop_last,
	qs.min_dop																			AS dop_min,
	qs.max_dop																			AS dop_max,
	qs.total_dop																		AS dop_tot,
	
	CAST(1.0 * qs.total_grant_kb / qs.execution_count AS decimal(13,1))					AS grt_avg,
	qs.last_grant_kb																	AS grt_last,
	qs.min_grant_kb																		AS grt_min,
	qs.max_grant_kb																		AS grt_max,
	qs.total_grant_kb																	AS grt_tot,
	
	CAST(1.0 * qs.total_used_grant_kb / qs.execution_count AS decimal(13,1))			AS ugrt_avg,
	qs.last_used_grant_kb																AS ugrt_last,
	qs.min_used_grant_kb																AS ugrt_min,
	qs.max_used_grant_kb																AS ugrt_max,
	qs.total_used_grant_kb																AS ugrt_tot,
	
	CAST(1.0 * qs.total_ideal_grant_kb / qs.execution_count AS decimal(13,1))			AS igrt_avg,
	qs.last_ideal_grant_kb																AS igrt_last,
	qs.min_ideal_grant_kb																AS igrt_min,
	qs.max_ideal_grant_kb																AS igrt_max,
	qs.total_ideal_grant_kb																AS igrt_tot,

	qs.query_hash																		AS query_hash,
	qs.query_hash_count																	AS qh_count,
--	qs.plan_handle																		AS plan_handle,
--	qs.sql_handle																		AS sql_handle,
	qs.sql_text																			AS sql_text
FROM
	rm_exec_query_stats qs
ORDER BY
	qs.last_execution_time DESC;
GO

-- ================================================================================
-- WORKBENCH
-- ================================================================================

/*
-- Original base query.
SELECT
	qs.last_execution_time																AS ex_last_time,
	qs.execution_count																	AS ex_count,
	CAST(1.0 * qs.total_elapsed_time / qs.execution_count / 1000 AS decimal(13,1))		AS dur_avg,
	CAST(1.0 * qs.last_elapsed_time / 1000 AS decimal(10,1))							AS dur_last,
	CAST(1.0 * qs.max_elapsed_time / 1000 AS decimal(10,1))								AS dur_max,
	CAST(1.0 * qs.total_elapsed_time / 1000 AS decimal(10,1))							AS dur_tot,
	CAST(1.0 * qs.total_worker_time / qs.execution_count / 1000 AS decimal(13,1))		AS cpu_avg,
	CAST(1.0 * qs.last_worker_time / 1000 AS decimal(10,1))								AS cpu_last,
	CAST(1.0 * qs.max_worker_time / 1000 AS decimal(10,1))								AS cpu_max,
	CAST(1.0 * qs.total_worker_time / 1000 AS decimal(10,1))							AS cpu_tot,
	CAST(1.0 * qs.total_logical_reads / qs.execution_count AS decimal(13,1))			AS lr_avg,
	CAST(1.0 * qs.last_logical_reads AS decimal(10,1))									AS lr_last,
	CAST(1.0 * qs.max_logical_reads AS decimal(10,1))									AS lr_max,
	CAST(1.0 * qs.total_logical_reads AS decimal(10,1))									AS lr_tot,
	CAST(1.0 * qs.total_physical_reads / qs.execution_count AS decimal(13,1))			AS pr_avg,
	CAST(1.0 * qs.last_physical_reads AS decimal(10,1))									AS pr_last,
	CAST(1.0 * qs.max_physical_reads AS decimal(10,1))									AS pr_max,
	CAST(1.0 * qs.total_physical_reads AS decimal(10,1))								AS pr_tot,
	CAST(1.0 * qs.total_logical_writes / qs.execution_count AS decimal(13,1))			AS lw_avg,
	CAST(1.0 * qs.last_logical_writes AS decimal(10,1))									AS lw_last,
	CAST(1.0 * qs.max_logical_writes AS decimal(10,1))									AS lw_max,
	CAST(1.0 * qs.total_logical_writes AS decimal(10,1))								AS lw_tot,
	qs.last_dop,
	qs.min_dop,
	qs.max_dop,
	qs.total_dop,
	qs.last_grant_kb,
	qs.min_grant_kb,
	qs.max_grant_kb,
	qs.total_grant_kb,
	qs.last_used_grant_kb,
	qs.min_used_grant_kb,
	qs.max_used_grant_kb,
	qs.total_used_grant_kb,
	qs.last_ideal_grant_kb,
	qs.min_ideal_grant_kb,
	qs.max_ideal_grant_kb,
	qs.total_ideal_grant_kb,
	qs.query_hash																		AS query_hash,
	qs.query_plan_hash																	AS query_plan_hash,
	SUBSTRING(
		st.text,
		qs.statement_start_offset / 2 + 1,
		(CASE qs.statement_end_offset WHEN -1 THEN DATALENGTH(st.text) ELSE qs.statement_end_offset END - qs.statement_start_offset) / 2 + 1)
																						AS sql_text
FROM
	sys.dm_exec_query_stats qs
CROSS APPLY
	sys.dm_exec_sql_text(qs.sql_handle) st
ORDER BY
	qs.last_execution_time DESC;
GO

-- Queries with multiple plans.
select
	qs.query_hash		as query_hash,
	count(*)			as entries
from
	sys.dm_exec_query_stats qs
group by
	qs.query_hash
order by
	count(*) desc;
GO

-- Different plan handles, but same plan hash. Hmm?
select
	qs.*
from
	sys.dm_exec_query_stats qs
where
	qs.query_hash = 0x6532F65EF8A04034;
GO
*/
