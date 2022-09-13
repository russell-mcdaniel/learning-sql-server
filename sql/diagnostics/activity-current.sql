USE master;
GO

-- https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-exec-connections-transact-sql
-- https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-exec-requests-transact-sql
-- https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-exec-sessions-transact-sql
SELECT
	s.session_id												AS session_id,
	r.start_time												AS start_time,
	r.total_elapsed_time										AS dur_tot,
	r.cpu_time													AS cpu_tot,
	r.logical_reads												AS lr_tot,
	r.reads														AS pr_tot,
	r.writes													AS lw_tot,
	r.open_transaction_count									AS open_tx,
	r.status													AS status,
	CASE r.database_id
		WHEN 32767 THEN N'resource'
		ELSE DB_NAME(r.database_id)
	END															AS db_name,
	SUBSTRING(
		st.text,
		r.statement_start_offset / 2 + 1,
		(CASE r.statement_end_offset WHEN -1 THEN DATALENGTH(st.text) ELSE r.statement_end_offset END - r.statement_start_offset) / 2 + 1)
																AS sql_text,
	s.program_name												AS program_name,
	r.query_hash,
	r.query_plan_hash,
	r.plan_handle
FROM
	sys.dm_exec_requests r
INNER JOIN
	sys.dm_exec_sessions s
ON
	s.session_id = r.session_id
INNER JOIN
	sys.dm_exec_connections c
ON
	c.session_id = r.session_id
CROSS APPLY
	sys.dm_exec_sql_text(r.sql_handle) st
WHERE
	s.session_id <> @@SPID
ORDER BY
	r.session_id;
GO
