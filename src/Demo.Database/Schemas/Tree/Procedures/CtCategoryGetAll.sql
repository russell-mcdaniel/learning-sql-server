-- --------------------------------------------------------------------------------
-- Get the path for all categories.
--
-- References:
-- http://karwin.blogspot.com/2010/03/rendering-trees-with-closure-tables.html
-- https://www.red-gate.com/simple-talk/databases/sql-server/t-sql-programming-sql-server/sql-server-closure-tables/
-- --------------------------------------------------------------------------------
CREATE PROCEDURE [Tree].[CtCategoryGetAll]
AS
	SET NOCOUNT ON;

SELECT
	-- This would use the XML PATH trick before the STRING_AGG function was available.
	STRING_AGG(c.Name, N' > ') WITHIN GROUP (ORDER BY a.Depth DESC)
										AS [Path]
FROM
	-- Provides all descendants of the root node except itself (see WHERE).
	Tree.CtCategoryHierarchy d
INNER JOIN
	-- Provides all ancestors of each descendant including itself (to be the leaf of each path).
	Tree.CtCategoryHierarchy a
ON
	a.DescendantId = d.DescendantId
INNER JOIN
	-- Provides the name of each ancestor node.
	Tree.CtCategory c
ON
	c.Id = a.AncestorId
WHERE
	-- The root node.
	d.AncestorId = (SELECT Id FROM Tree.CtCategory WHERE Name = 'Products')
AND
	d.DescendantId <> d.AncestorId
GROUP BY
	d.DescendantId
ORDER BY
	[Path];
GO

/*
-- How to use XML PATH when STRING_AGG is not available (omits root).
SELECT 
	STUFF(
		(
			SELECT
				' > ' + c.Name
			FROM
				Tree.CtCategoryHierarchy down
  			INNER JOIN
				Tree.CtCategoryHierarchy up
			ON
				up.DescendantId = down.DescendantId
  			INNER JOIN
				Tree.CtCategory c
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
	Tree.CtCategoryHierarchy d
WHERE
	d.AncestorId = (SELECT Id FROM Tree.CtCategory WHERE Name = 'Products')
AND
	d.DescendantId <> d.AncestorId
ORDER BY
	[Path];
GO
*/
