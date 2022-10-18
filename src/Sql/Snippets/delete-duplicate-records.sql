--
-- Delete Duplicate Records
--
-- This script demonstrates how to delete duplicate records from a table that does
-- not have a unique ID without using a temporary table as part of the solution.
--
USE master;
GO

IF (OBJECT_ID(N'tempdb..#Person') IS NOT NULL)
DROP TABLE #Person;
GO

CREATE TABLE #Person
(
	PersonName					nvarchar(20)			NOT NULL
);
GO

INSERT INTO
	#Person (PersonName)
VALUES
	(N'Teddy'),
	(N'Dolores'),
	(N'Maeve'),
	(N'Ford'),
	(N'Bernard'),
	(N'Man in Black'),
	(N'Dolores'),
	(N'Bernard'),
	(N'Charlotte'),
	(N'William');
GO

SELECT * FROM #Person;
GO

WITH PersonNumber (PersonName, PersonNumber)
AS
(
	SELECT
		p.PersonName															AS PersonName,
		ROW_NUMBER() OVER (PARTITION BY p.PersonName ORDER BY p.PersonName)		AS PersonNumber
	from
		#Person p
)
DELETE
	pn
FROM
	PersonNumber pn
WHERE
	pn.PersonNumber > 1;
GO

SELECT * FROM #Person;
GO
