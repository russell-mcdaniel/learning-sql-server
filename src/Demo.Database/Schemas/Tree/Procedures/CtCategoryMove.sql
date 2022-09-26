-- --------------------------------------------------------------------------------
-- Move a category.
-- --------------------------------------------------------------------------------
CREATE PROCEDURE [Tree].[CtCategoryMove]
	@CategoryId								int,
	@AncestorId								int			-- New ancestor.
AS
	SET NOCOUNT ON;
	SET XACT_ABORT ON;

	BEGIN TRAN;

	-- Disconnect the category from its ancestor. Delete paths that connect
	-- the category and its descendants to the ancestors of the category.
	DELETE FROM
		Tree.CtCategoryHierarchy
	WHERE
		-- Get the relationships to the category and its descendants.
		DescendantId IN (SELECT DescendantId FROM Tree.CtCategoryHierarchy WHERE AncestorId = @CategoryId)
	AND
		-- Exclude the relationships that originate from the category
		-- and its descendants to keep the subtree intact.
		AncestorId NOT IN (SELECT DescendantId FROM Tree.CtCategoryHierarchy WHERE AncestorId = @CategoryId);

	-- Connect the category and its subtree to its new ancestor. Create
	-- relationships for combinations of the ancestors of the new ancestor
	-- and descendants of the category subtree.
	INSERT INTO
		Tree.CtCategoryHierarchy (AncestorId, DescendantId, Depth)
	SELECT
		a.AncestorId						AS AncestorId,
		d.DescendantId						AS DescendantId,
		a.Depth + d.Depth + 1				AS Depth
	FROM
		Tree.CtCategoryHierarchy a
	CROSS JOIN
		Tree.CtCategoryHierarchy d
	WHERE
		d.AncestorId = @CategoryId
	AND
		a.DescendantId = @AncestorId;

	COMMIT TRAN;
GO
