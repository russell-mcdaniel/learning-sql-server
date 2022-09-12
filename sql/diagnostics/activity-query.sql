--
-- Design Notes
--
-- Queries can have multiple plans. Consider this when aggregating query metrics.
-- 
-- The same statement can exist in different batches. This is rare, but it can
-- affect the result set in unexpected ways.
--
USE master;
GO

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


-- ================================================================================
-- WORKBENCH
-- ================================================================================

/*
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
