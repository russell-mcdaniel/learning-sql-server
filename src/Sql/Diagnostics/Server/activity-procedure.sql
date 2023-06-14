--
-- Return execution metrics for stored procedures.
--
USE master;
GO

-- https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-exec-procedure-stats-transact-sql
SELECT
	ps.last_execution_time																AS ex_last_time,
	ps.execution_count																	AS ex_count,

	CAST(1.0 * ps.total_elapsed_time / ps.execution_count / 1000 AS decimal(13,1))		AS dur_avg,
	CAST(1.0 * ps.last_elapsed_time / 1000 AS decimal(13,1))							AS dur_last,
	CAST(1.0 * ps.min_elapsed_time / 1000 AS decimal(13,1))								AS dur_min,
	CAST(1.0 * ps.max_elapsed_time / 1000 AS decimal(13,1))								AS dur_max,
	CAST(1.0 * ps.total_elapsed_time / 1000 AS decimal(13,1))							AS dur_tot,

	CAST(1.0 * ps.total_worker_time / ps.execution_count / 1000 AS decimal(13,1))		AS cpu_avg,
	CAST(1.0 * ps.last_worker_time / 1000 AS decimal(13,1))								AS cpu_last,
	CAST(1.0 * ps.min_worker_time / 1000 AS decimal(13,1))								AS cpu_min,
	CAST(1.0 * ps.max_worker_time / 1000 AS decimal(13,1))								AS cpu_max,
	CAST(1.0 * ps.total_worker_time / 1000 AS decimal(13,1))							AS cpu_tot,

	CAST(1.0 * ps.total_logical_reads / ps.execution_count AS decimal(13,1))			AS lr_avg,
	ps.last_logical_reads																AS lr_last,
	ps.min_logical_reads																AS lr_min,
	ps.max_logical_reads																AS lr_max,
	ps.total_logical_reads																AS lr_tot,

	CAST(1.0 * ps.total_physical_reads / ps.execution_count AS decimal(13,1))			AS pr_avg,
	ps.last_physical_reads																AS pr_last,
	ps.min_physical_reads																AS pr_min,
	ps.max_physical_reads																AS pr_max,
	ps.total_physical_reads																AS pr_tot,

	CAST(1.0 * ps.total_logical_writes / ps.execution_count AS decimal(13,1))			AS lw_avg,
	ps.last_logical_writes																AS lw_last,
	ps.min_logical_writes																AS lw_min,
	ps.max_logical_writes																AS lw_max,
	ps.total_logical_writes																AS lw_tot,

	OBJECT_NAME(ps.object_id, ps.database_id)			AS proc_name,
	CASE ps.database_id
		WHEN 32767 THEN N'resource'
		ELSE DB_NAME(ps.database_id)
	END													AS db_name,
	ps.plan_handle										AS plan_handle,
	ps.sql_handle										AS sql_handle,
	st.text												AS sql_text
FROM
	sys.dm_exec_procedure_stats ps
CROSS APPLY
	sys.dm_exec_sql_text(ps.sql_handle) st
ORDER BY
	ps.last_execution_time DESC;
GO
