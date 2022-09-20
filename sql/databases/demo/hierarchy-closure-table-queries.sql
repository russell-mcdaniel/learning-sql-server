-- ================================================================================
-- Hierarchy: Closure Table - Queries
--
-- NOTE: The hierarchy models in this series prefix related object names with
--       a code that identifies the type so they can coexist in one database.
-- ================================================================================
USE SqlDemo;
GO

--
-- Display all categories as a tree. Renders the full path of each node and then
-- orders them by path to render the hierarchy in a natural order.
--
-- References:
-- http://karwin.blogspot.com/2010/03/rendering-trees-with-closure-tables.html
--
SELECT
	-- This would use the XML PATH trick before the STRING_AGG function was available.
	STRING_AGG(c.Name, N' > ') WITHIN GROUP (ORDER BY a.Depth DESC)
										AS [Path]
FROM
	-- Provides all descendants of the root node except itself (see WHERE).
	dbo.CtCategoryHierarchy d
INNER JOIN
	-- Provides all ancestors of each descendant including itself (to be the leaf of each path).
	dbo.CtCategoryHierarchy a
ON
	a.DescendantId = d.DescendantId
INNER JOIN
	-- Provides the name of each ancestor node.
	dbo.CtCategory c
ON
	c.Id = a.AncestorId
WHERE
	-- The root node.
	d.AncestorId = (SELECT Id FROM dbo.CtCategory WHERE Name = 'Products')
AND
	d.AncestorId <> d.DescendantId
GROUP BY
	d.DescendantId
ORDER BY
	[Path];
GO

--
-- Display all categories as a tree.
--
-- References:
-- https://www.red-gate.com/simple-talk/databases/sql-server/t-sql-programming-sql-server/sql-server-closure-tables/
--
SELECT 
	STUFF(
		(
			SELECT
				' > ' + c.Name
			FROM
				dbo.CtCategoryHierarchy down
  			INNER JOIN
				dbo.CtCategoryHierarchy up
			ON
				up.DescendantId = down.DescendantId
  			INNER JOIN
				dbo.CtCategory c
			ON
				c.Id = up.AncestorId
  			WHERE
				down.AncestorId = d.AncestorId
  			AND
				down.DescendantId = d.DescendantId
  			AND
				down.DescendantId <> down.AncestorId
			ORDER BY
				up.Depth DESC
			FOR XML PATH(''), TYPE
		).value('.', 'nvarchar(MAX)'), 1, 2, '') AS [Path]
FROM
	dbo.CtCategoryHierarchy d
WHERE
	d.AncestorId = (SELECT Id FROM dbo.CtCategory WHERE Name = 'Products')
AND
	d.DescendantId <> d.AncestorId
ORDER BY
	[Path];
GO

--
-- Get the immediate children of a node.
--
DECLARE @AncestorId int = 11;	-- Products > Household > Kitchen
--DECLARE @AncestorId int = 2;	-- Products > Sporting Goods

SELECT
	c.Id								AS CategoryId,
	c.Name								AS CategoryName
FROM
	dbo.CtCategory c
INNER JOIN
	dbo.CtCategoryHierarchy h
ON
	h.DescendantId = c.Id
WHERE
	h.AncestorId = @AncestorId
AND
	h.Depth = 1
ORDER BY
	c.Name;
GO
