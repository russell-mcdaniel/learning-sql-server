-- --------------------------------------------------------------------------------
-- Get the parent of a category.
-- --------------------------------------------------------------------------------
CREATE PROCEDURE [Tree].[CtCategoryGetParent]
	@CategoryId								int
AS
	SET NOCOUNT ON;

	SELECT
		p.Id								AS CategoryId,
		p.Name								AS CategoryName
	FROM
		Tree.CtCategoryHierarchy h
	INNER JOIN
		Tree.CtCategory p
	ON
		p.Id = h.AncestorId
	WHERE
		h.DescendantId = @CategoryId
	AND
		h.Depth = 1;
GO
