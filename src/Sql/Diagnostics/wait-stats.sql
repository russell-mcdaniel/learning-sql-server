USE master;
GO

-- Collect a snapshot of the statistics on each execution and output
-- the delta between the last collection and previous collection.
--
-- Other waits stats views:
-- * sys.dm_exec_session_wait_stats
-- * sys.query_store_wait_stats
SELECT
	ws.wait_type										AS wait_type,
	ws.waiting_tasks_count								AS waiting_tasks_count,
	CAST(CASE ws.waiting_tasks_count
		WHEN 0 THEN 1.0 * 0
		ELSE 1.0 * ws.wait_time_ms / ws.waiting_tasks_count
	END AS decimal(12,1))								AS avg_wait_time_ms,
	ws.wait_time_ms										AS wait_time_ms,
	ws.max_wait_time_ms									AS max_wait_time_ms,
	ws.signal_wait_time_ms								AS signal_wait_time_ms
FROM
	sys.dm_os_wait_stats ws
WHERE
	ws.waiting_tasks_count > 0
--AND
--	(
--		ws.wait_type IN
--		(
--			N'ASYNC_NETWORK_IO',
--			N'CXPACKET',
--			N'DTC',
--			N'SOS_SCHEDULER_YIELD',
--			N'WRITELOG'
--		)
--	OR
--		ws.wait_type LIKE N'LCK_M%'
--	OR
--		ws.wait_type LIKE N'PAGEIOLATCH%'
--	OR
--		ws.wait_type LIKE N'PAGELATCH%'
--	)
ORDER BY
	ws.wait_time_ms DESC,
--	avg_wait_time_ms DESC,
	ws.wait_type;
GO
