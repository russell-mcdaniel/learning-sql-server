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
		Tree.AlCategory p
	INNER JOIN
		Tree.AlCategory c
	ON
		c.ParentId = p.Id
	WHERE
		c.Id = @CategoryId
	ORDER BY
		p.Name;
GO
