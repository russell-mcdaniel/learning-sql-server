--
-- Return execution metrics for triggers.
--
USE master;
GO

-- https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-exec-trigger-stats-transact-sql
SELECT
	ts.last_execution_time																AS ex_last_time,
	ts.execution_count																	AS ex_count,

	CAST(1.0 * ts.total_elapsed_time / ts.execution_count / 1000 AS decimal(13,1))		AS dur_avg,
	CAST(1.0 * ts.last_elapsed_time / 1000 AS decimal(13,1))							AS dur_last,
	CAST(1.0 * ts.min_elapsed_time / 1000 AS decimal(13,1))								AS dur_min,
	CAST(1.0 * ts.max_elapsed_time / 1000 AS decimal(13,1))								AS dur_max,
	CAST(1.0 * ts.total_elapsed_time / 1000 AS decimal(13,1))							AS dur_tot,

	CAST(1.0 * ts.total_worker_time / ts.execution_count / 1000 AS decimal(13,1))		AS cpu_avg,
	CAST(1.0 * ts.last_worker_time / 1000 AS decimal(13,1))								AS cpu_last,
	CAST(1.0 * ts.min_worker_time / 1000 AS decimal(13,1))								AS cpu_min,
	CAST(1.0 * ts.max_worker_time / 1000 AS decimal(13,1))								AS cpu_max,
	CAST(1.0 * ts.total_worker_time / 1000 AS decimal(13,1))							AS cpu_tot,

	CAST(1.0 * ts.total_logical_reads / ts.execution_count AS decimal(13,1))			AS lr_avg,
	ts.last_logical_reads																AS lr_last,
	ts.min_logical_reads																AS lr_min,
	ts.max_logical_reads																AS lr_max,
	ts.total_logical_reads																AS lr_tot,

	CAST(1.0 * ts.total_physical_reads / ts.execution_count AS decimal(13,1))			AS pr_avg,
	ts.last_physical_reads																AS pr_last,
	ts.min_physical_reads																AS pr_min,
	ts.max_physical_reads																AS pr_max,
	ts.total_physical_reads																AS pr_tot,

	CAST(1.0 * ts.total_logical_writes / ts.execution_count AS decimal(13,1))			AS lw_avg,
	ts.last_logical_writes																AS lw_last,
	ts.min_logical_writes																AS lw_min,
	ts.max_logical_writes																AS lw_max,
	ts.total_logical_writes																AS lw_tot,

	OBJECT_NAME(ts.object_id, ts.database_id)											AS trigger_name,
	CASE ts.database_id
		WHEN 32767 THEN N'resource'
		ELSE DB_NAME(ts.database_id)
	END																					AS db_name,
	ts.plan_handle																		AS plan_handle,
	ts.sql_handle																		AS sql_handle,
	st.text																				AS sql_text
FROM
	sys.dm_exec_trigger_stats ts
CROSS APPLY
	sys.dm_exec_sql_text(ts.sql_handle) st
ORDER BY
	ts.last_execution_time DESC;
GO
