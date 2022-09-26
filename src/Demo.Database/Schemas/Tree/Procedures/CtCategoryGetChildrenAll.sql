-- --------------------------------------------------------------------------------
-- Get all children of a category.
--
-- Design Notes
--
-- See Tree.CtCategoryGetAll.
-- --------------------------------------------------------------------------------
CREATE PROCEDURE [Tree].[CtCategoryGetChildrenAll]
	@CategoryId								int
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
		-- Provides all descendants of the specified node (see WHERE).
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
		hd.AncestorId = @CategoryId
	AND
		hd.AncestorId <> hd.DescendantId
	GROUP BY
		cd.Id,
		cd.Name
	ORDER BY
		[Path];
GO
