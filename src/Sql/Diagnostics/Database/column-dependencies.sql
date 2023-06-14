--
-- Find Column Dependencies
-- https://stackoverflow.com/questions/11769172/find-column-dependency
--
use acvs_ny;
GO

DECLARE
	@SchemaName				sysname			= 'dbo',
	@TableName				sysname			= 'Company',
	@ColumnName				sysname			= 'CabDiscrepancyDays';

SELECT
	@SchemaName + '.' + @TableName											AS used_object,
    @ColumnName																AS used_column,
    referencing.referencing_schema_name + '.' + referencing_entity_name		AS usage_object,
    CASE so.type
        WHEN 'C' THEN 'CHECK constraint'
        WHEN 'D' THEN 'Default'
        WHEN 'F' THEN 'FOREIGN KEY'
        WHEN 'FN' THEN 'Scalar function' 
        WHEN 'IF' THEN 'In-lined table-function'
        WHEN 'K' THEN 'PRIMARY KEY'
        WHEN 'L' THEN 'Log'
        WHEN 'P' THEN 'Stored procedure'
        WHEN 'R' THEN 'Rule'
        WHEN 'RF' THEN 'Replication filter stored procedure'
        WHEN 'S' THEN 'System table'
        WHEN 'SP' THEN 'Security policy'
        WHEN 'TF' THEN 'Table function'
        WHEN 'TR' THEN 'Trigger'
        WHEN 'U' THEN 'User table' 
        WHEN 'V' THEN 'View' 
        WHEN 'X' THEN 'Extended stored procedure'
    END																		AS usage_object_type,
    so.[type]																AS usage_object_type_id
FROM
	sys.dm_sql_referencing_entities(@SchemaName + '.' + @TableName, 'object') referencing
INNER JOIN
	sys.objects so
ON
	so.object_id = referencing.referencing_id
WHERE
	EXISTS
	(
		SELECT
			*
		FROM
			sys.dm_sql_referenced_entities(referencing_schema_name + '.' + referencing_entity_name, 'object') referenced
		WHERE
			referenced_entity_name = @TableName
		AND
			(
				referenced.referenced_minor_name LIKE @ColumnName   
			OR
				(
					-- These conditions are included because referenced_minor_name is sometimes
					-- NULL. However, be aware that it can introduce false positives.
					referenced.referenced_minor_name IS NULL
				AND
					object_definition(object_id(referencing_schema_name + '.' + referencing_entity_name)) LIKE '%' + @ColumnName + '%'
				)
			)
	)
ORDER BY
    usage_object_type,
    usage_object;
GO
