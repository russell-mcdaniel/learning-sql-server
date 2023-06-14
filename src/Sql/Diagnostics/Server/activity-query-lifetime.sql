--
-- Display execution metrics over query lifetime.
--
USE master;
GO

-- TODO: Group and aggregate by query hash.
-- https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-exec-query-stats-transact-sql
WITH rm_exec_query_stats
AS
(
	SELECT
		MAX(qs.last_execution_time)														AS last_execution_time,
		MIN(qs.creation_time)															AS creation_time,
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
	qs.last_execution_time																	AS ex_last_time,
	qs.creation_time																		AS ex_create_time,
	CAST(DATEDIFF(millisecond, qs.creation_time, SYSDATETIME()) / 1000.0 AS decimal(13,3))	AS ex_exist,
	qs.execution_count																		AS ex_count,
	CASE
		WHEN DATEDIFF(millisecond, qs.creation_time, SYSDATETIME()) > 0 THEN CAST(qs.execution_count / (DATEDIFF(millisecond, qs.creation_time, SYSDATETIME()) / 1000.0) AS decimal(10,1))
		ELSE CAST(qs.execution_count AS decimal(10,1))
	END 																					AS ex_per_sec,

	CAST(1.0 * qs.total_elapsed_time / qs.execution_count / 1000 AS decimal(13,1))			AS dur_avg,
	CAST(1.0 * qs.last_elapsed_time / 1000 AS decimal(10,1))								AS dur_last,
	CAST(1.0 * qs.min_elapsed_time / 1000 AS decimal(10,1))									AS dur_min,
	CAST(1.0 * qs.max_elapsed_time / 1000 AS decimal(10,1))									AS dur_max,
	CAST(1.0 * qs.total_elapsed_time / 1000 AS decimal(10,1))								AS dur_tot,

	qs.query_hash																			AS query_hash,
	qs.sql_text																				AS sql_text
FROM
	rm_exec_query_stats qs
ORDER BY
	qs.last_execution_time DESC;
GO
