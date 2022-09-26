-- --------------------------------------------------------------------------------
-- Get the path for all categories.
--
-- Design Notes
--
-- Producing the AncestorId and Lineage values requires more complexity than with
-- the Adjacency List variation. It could be done recursively, but this reduces
-- some of the benefit of using a Closure Table. Even returning the target
-- category name requires an extra join that is not necessary for the path.
-- --------------------------------------------------------------------------------
CREATE PROCEDURE [Tree].[CtCategoryGetAll]
AS
	SET NOCOUNT ON;

	SELECT
		cd.Id								AS CategoryId,
		cd.Name								AS CategoryName,
		NULL								AS AncestorId,
		MAX(ha.Depth)						AS Depth,
		NULL								AS Lineage,
		-- This would use the XML PATH trick before the STRING_AGG function was available.
		STRING_AGG(ca.Name, N' > ') WITHIN GROUP (ORDER BY ha.Depth DESC)
											AS [Path]
	FROM
		Tree.CtCategory cd
	INNER JOIN
		-- Provides all descendants of the root node (see WHERE).
		Tree.CtCategoryHierarchy hd
	ON
		hd.DescendantId = cd.Id
	INNER JOIN
		-- Provides all ancestors of each descendant including itself to build the path.
		Tree.CtCategoryHierarchy ha
	ON
		ha.DescendantId = hd.DescendantId
	INNER JOIN
		-- Provides the name of each ancestor node.
		Tree.CtCategory ca
	ON
		ca.Id = ha.AncestorId
	WHERE
		-- The root node.
		hd.AncestorId = (SELECT Id FROM Tree.CtCategory WHERE Name = 'Products')
	GROUP BY
		cd.Id,
		cd.Name
	ORDER BY
		[Path];
GO

/*
-- Path-only version that uses the XML PATH trick instead of STRING_AGG.
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
			ORDER BY
				up.Depth DESC
			FOR XML PATH(''), TYPE
		).value('.', 'nvarchar(MAX)'), 1, 2, '') AS [Path]
FROM
	Tree.CtCategoryHierarchy d
WHERE
	d.AncestorId = (SELECT Id FROM Tree.CtCategory WHERE Name = 'Products')
ORDER BY
	[Path];
*/
