-- --------------------------------------------------------------------------------
-- Delete a category promoting children.
-- --------------------------------------------------------------------------------
CREATE PROCEDURE [Tree].[AlCategoryDeletePromotingChildren]
	@CategoryId								int
AS
	SET NOCOUNT ON;
	SET XACT_ABORT ON;

	BEGIN TRAN;

	-- Set the parent ID of the category's children to the category's parent ID.
	UPDATE
		Tree.AlCategory
	SET
		ParentId = (SELECT ParentId FROM Tree.AlCategory WHERE Id = @CategoryId)
	WHERE
		ParentId = @CategoryId;

	-- Delete the category.
	DELETE FROM
		Tree.AlCategory
	WHERE
		Id = @CategoryId;

	COMMIT TRAN;
GO
