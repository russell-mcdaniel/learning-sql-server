use {Database};
GO

select
	d.name						as database_name,
	object_name(p.object_id)	as object_name,
	l.resource_type,
	l.resource_subtype,
	l.request_mode,
	p.partition_id,
	p.object_id,
	p.index_id,
	p.partition_number,
	p.rows
--	l.*
from
	sys.dm_tran_locks l
inner join
	sys.databases d
on
	d.database_id = l.resource_database_id
left outer join
	sys.partitions p
on
	p.hobt_id = l.resource_associated_entity_id
order by
	l.resource_database_id;
GO
