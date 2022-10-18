-- ================================================================================
-- Display information about storage.
-- ================================================================================

-- Get file performance data.
SELECT
	f.database_id							AS db_id,
	DB_NAME(f.database_id)					AS db_name,
	f.name									AS file_name,
	f.type_desc								AS file_type,
	fs.size_on_disk_bytes					AS size_bytes,
	fs.sample_ms							AS elapsed_ms,		-- Time since the server started.
	fs.num_of_reads							AS reads,
	fs.num_of_bytes_read					AS read_bytes,
	fs.num_of_writes						AS writes,
	fs.num_of_bytes_written					AS writ_bytes,
	fs.io_stall_read_ms						AS io_stl_rd_ms,
	fs.io_stall_write_ms					AS io_stl_wr_ms,
	fs.io_stall								AS io_stl_tot_ms,
	fs.io_stall_queued_read_ms				AS io_stl_rd_rg_ms,	-- Due to Resource Governor.
	fs.io_stall_queued_write_ms				AS io_stl_wr_rg_ms	-- Due to Resource Governor.
FROM
	sys.master_files f
CROSS APPLY
	sys.dm_io_virtual_file_stats(f.database_id, f.file_id) fs
ORDER BY
	-- Place system databases at the bottom of the list.
	CASE WHEN f.database_id > 4 THEN 0 ELSE 1 END,
	DB_NAME(f.database_id),
	f.name;
GO
