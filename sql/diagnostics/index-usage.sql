USE Learning;
GO

SELECT
	OBJECT_SCHEMA_NAME(i.object_id)									AS schema_name,
	OBJECT_NAME(i.object_id)										AS table_name,
	i.name															AS index_name,
	ius.user_seeks													AS user_seeks,
	ius.user_scans													AS user_scans,
	ius.user_lookups												AS user_lookups,
	ius.user_updates												AS user_updates,
	ius.system_seeks												AS sys_seeks,
	ius.system_scans												AS sys_scans,
	ius.system_lookups												AS sys_lookups,
	ius.system_updates												AS sys_updates,
	ius.last_user_seek												AS user_seek_last,
	ius.last_user_scan												AS user_scan_last,
	ius.last_user_lookup											AS user_lookup_last,
	ius.last_user_update											AS user_update_last,
	ius.last_system_seek											AS sys_seek_last,
	ius.last_system_scan											AS sys_scan_last,
	ius.last_system_lookup											AS sys_lookup_last,
	ius.last_system_update											AS sys_update_last
FROM
	-- Use this join to restrict to indexes on user-created tables.
	sys.tables t
INNER JOIN
	sys.indexes i
ON
	i.object_id = t.object_id
LEFT OUTER JOIN
	sys.dm_db_index_usage_stats ius
ON
	ius.object_id = i.object_id
AND
	ius.index_id = i.index_id
ORDER BY
	OBJECT_SCHEMA_NAME(i.object_id),
	OBJECT_NAME(i.object_id),
	i.name;
GO
