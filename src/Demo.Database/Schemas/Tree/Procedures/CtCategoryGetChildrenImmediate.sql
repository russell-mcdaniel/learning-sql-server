-- --------------------------------------------------------------------------------
-- Get the immediate children of a category.
-- --------------------------------------------------------------------------------
CREATE PROCEDURE [Tree].[CtCategoryGetChildrenImmediate]
	@CategoryId								int
AS
	SET NOCOUNT ON;

	SELECT
		c.Id								AS CategoryId,
		c.Name								AS CategoryName
	FROM
		Tree.CtCategory c
	INNER JOIN
		Tree.CtCategoryHierarchy h
	ON
		h.DescendantId = c.Id
	WHERE
		h.AncestorId = @CategoryId
	AND
		h.Depth = 1
	ORDER BY
		c.Name;
GO
