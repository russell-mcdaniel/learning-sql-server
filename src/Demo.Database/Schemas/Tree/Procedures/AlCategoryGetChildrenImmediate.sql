-- --------------------------------------------------------------------------------
-- Get the immediate children of a category.
-- --------------------------------------------------------------------------------
CREATE PROCEDURE [Tree].[AlCategoryGetChildrenImmediate]
	@CategoryId								int
AS
	SET NOCOUNT ON;

	SELECT
		c.Id								AS CategoryId,
		c.Name								AS CategoryName
	FROM
		Tree.AlCategory c
	WHERE
		c.ParentId = @CategoryId
	ORDER BY
		c.Name;
GO
