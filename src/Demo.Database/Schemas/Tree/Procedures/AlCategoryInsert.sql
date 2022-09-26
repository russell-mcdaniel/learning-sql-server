-- --------------------------------------------------------------------------------
-- Insert a category.
-- --------------------------------------------------------------------------------
CREATE PROCEDURE [Tree].[AlCategoryInsert]
	@CategoryId								int,
	@Name									nvarchar(20),
	@ParentId								int
AS
	SET NOCOUNT ON;

	INSERT INTO
		Tree.AlCategory (Id, Name, ParentId)
	VALUES
		(@CategoryId, @Name, @ParentId);
GO
