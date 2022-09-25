-- --------------------------------------------------------------------------------
-- Get the path for a category.
--
-- Design Notes
--
-- Producing the AncestorId and Lineage values requires more complexity than with
-- the Adjacency List variation. It could be done recursively, but this reduces
-- some of the benefit of using a Closure Table. Even returning the name of the
-- target category requires an extra join that is not necessary for the path.
-- --------------------------------------------------------------------------------
CREATE PROCEDURE [Tree].[CtCategoryGet]
	@CategoryId								int
AS
	SET NOCOUNT ON;

	SELECT
		cd.Id								AS CategoryId,
		cd.Name								AS CategoryName,
		NULL								AS AncestorId,
		MAX(h.Depth)						AS Depth,
		NULL								AS Lineage,
		STRING_AGG(ca.Name, N' > ') WITHIN GROUP (ORDER BY h.Depth DESC)
											AS [Path]
	FROM
		Tree.CtCategory cd
	INNER JOIN
		Tree.CtCategoryHierarchy h
	ON
		h.DescendantId = cd.Id
	INNER JOIN
		Tree.CtCategory ca
	ON
		ca.Id = h.AncestorId
	WHERE
		cd.Id = @CategoryId
	GROUP BY
		cd.Id,
		cd.Name;
GO
