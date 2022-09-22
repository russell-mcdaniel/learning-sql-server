-- --------------------------------------------------------------------------------
-- Insert a category.
-- --------------------------------------------------------------------------------
CREATE PROCEDURE [Tree].[CtCategoryInsert]
	@CategoryId								int,
	@Name									nvarchar(20),
	@AncestorId								int
AS
	SET NOCOUNT ON;
	SET XACT_ABORT ON;

	BEGIN TRAN;

	-- Create category.
	INSERT INTO
		Tree.CtCategory (Id, Name)
	VALUES
		(@CategoryId, @Name);

	-- Create self-reference and ancestors.
	INSERT INTO
		Tree.CtCategoryHierarchy (AncestorId, DescendantId, Depth)
	SELECT
		@CategoryId				AS AncestorId,
		@CategoryId				AS DescendantId,
		0						AS Depth

	UNION ALL

	SELECT
		h.AncestorId			AS AncestorId,
		@CategoryId				AS DescendantId,
		h.Depth + 1				AS Depth
	FROM
		Tree.CtCategoryHierarchy h
	WHERE
		h.DescendantId = @AncestorId;

	COMMIT TRAN;
GO
