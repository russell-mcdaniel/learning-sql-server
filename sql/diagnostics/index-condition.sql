USE Learning;
GO

SELECT
	OBJECT_SCHEMA_NAME(i.object_id)									AS schema_name,
	OBJECT_NAME(i.object_id)										AS table_name,
	i.name															AS index_name,
	ips.index_type_desc												AS index_type,
	ips.alloc_unit_type_desc										AS index_alloc_type,
	ips.index_depth													AS ix_depth,
	ips.index_level													AS ix_level,
	ips.partition_number											AS part_no,
	CAST(8192.0 * ips.page_count / 1048576 AS decimal(12,3))		AS ix_size_mb,
	ips.page_count													AS pg_count,
	ips.record_count												AS row_count,
	CAST(ips.avg_record_size_in_bytes AS decimal(9,1))				AS row_size_b,
	ips.fragment_count												AS frag_count,
	CAST(ips.avg_fragment_size_in_pages AS decimal(9,1))			AS frag_size_pg,
	CAST(ips.avg_fragmentation_in_percent AS decimal(3,1))			AS frag_pct,
	CAST(ips.avg_page_space_used_in_percent AS decimal(3,1))		AS pg_used_pct
FROM
	sys.indexes i
CROSS APPLY
	sys.dm_db_index_physical_stats(DB_ID(), i.object_id, i.index_id, 0, 'DETAILED') ips
--WHERE
--	i.object_id IN
--	(
--		OBJECT_ID(N'Enrollment.Student'),
--		OBJECT_ID(N'Organization.Professor')
--	)
ORDER BY
--	ips.avg_fragmentation_in_percent DESC,
--	ips.page_count DESC,
	OBJECT_SCHEMA_NAME(i.object_id),
	OBJECT_NAME(i.object_id),
	i.name,
	ips.index_level DESC;				-- 0 is leaf; highest value is root.
GO
