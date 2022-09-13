USE master;
GO

SELECT
	d.name						AS database_name,
	object_name(p.object_id)	AS object_name,
	l.resource_type,
	l.resource_subtype,
	l.request_mode,
	p.partition_id,
	p.object_id,
	p.index_id,
	p.partition_number,
	p.rows
--	l.*
FROM
	sys.dm_tran_locks l
INNER JOIN
	sys.databases d
ON
	d.database_id = l.resource_database_id
LEFT OUTER JOIN
	sys.partitions p
ON
	p.hobt_id = l.resource_associated_entity_id
ORDER BY
	l.resource_database_id;
GO
