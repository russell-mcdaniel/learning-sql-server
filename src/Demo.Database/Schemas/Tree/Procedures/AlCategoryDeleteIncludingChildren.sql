-- --------------------------------------------------------------------------------
-- Delete a category including children.
-- --------------------------------------------------------------------------------
CREATE PROCEDURE [Tree].[AlCategoryDeleteIncludingChildren]
	@CategoryId								int
AS
	SET NOCOUNT ON;

	WITH AlCategorySubtree (Id, ParentId)
	AS
	(
		SELECT
			c.Id							AS Id,
			c.ParentId						AS ParentId
		FROM
			Tree.AlCategory c
		WHERE
			c.Id = @CategoryId

		UNION ALL

		SELECT
			c.Id							AS Id,
			c.ParentId						AS ParentId
		FROM
			Tree.AlCategory c
		INNER JOIN
			AlCategorySubtree cs
		ON
			cs.Id = c.ParentId
	)
	-- Cannot delete directly from the CTE because it has a UNION.
	DELETE
		c
	FROM
		Tree.AlCategory c
	INNER JOIN
		AlCategorySubtree cs
	ON
		cs.Id = c.Id;
GO
