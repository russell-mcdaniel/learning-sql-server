-- --------------------------------------------------------------------------------
-- Get the parent of a category.
-- --------------------------------------------------------------------------------
CREATE PROCEDURE [Tree].[AlCategoryGetParent]
	@CategoryId								int
AS
	SET NOCOUNT ON;

	SELECT
		p.Id								AS CategoryId,
		p.Name								AS CategoryName
	FROM
		Tree.AlCategory c
	INNER JOIN
		Tree.AlCategory p
	ON
		p.Id = c.ParentId
	WHERE
		c.Id = @CategoryId;
GO
