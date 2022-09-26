-- --------------------------------------------------------------------------------
-- Move a category.
-- --------------------------------------------------------------------------------
CREATE PROCEDURE [Tree].[AlCategoryMove]
	@CategoryId								int,
	@ParentId								int			-- New parent.
AS
	SET NOCOUNT ON;

	UPDATE
		Tree.AlCategory
	SET
		ParentId = @ParentId
	WHERE
		Id = @CategoryId;
GO
