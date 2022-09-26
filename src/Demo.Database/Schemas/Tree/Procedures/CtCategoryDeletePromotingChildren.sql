-- --------------------------------------------------------------------------------
-- Delete a category promoting children.
-- --------------------------------------------------------------------------------
CREATE PROCEDURE [Tree].[CtCategoryDeletePromotingChildren]
	@CategoryId								int
AS
	SET NOCOUNT ON;
	SET XACT_ABORT ON;


	BEGIN TRAN;

	DECLARE @CategoryPromote TABLE
	(
		Id									int					NOT NULL	PRIMARY KEY CLUSTERED
	);

	-- Delete the descendant references to the category. Performing this step
	-- first prevents a harmless, but unnecessary update during the promotion
	-- step to the category relationship that is about to be deleted.
	DELETE FROM
		Tree.CtCategoryHierarchy
	WHERE
		DescendantId = @CategoryId;

	-- Promote the descendants of the category where its depth is greater than
	-- the depth of its relationship to the ancestor being deleted. Categories
	-- above that ancestor are not affected by the removal.
	UPDATE
		d
	SET
		d.Depth -= 1
	FROM
		Tree.CtCategoryHierarchy d
	INNER JOIN
		Tree.CtCategoryHierarchy a
	ON
		a.DescendantId = d.DescendantId
	WHERE
		a.AncestorId = @CategoryId
	AND
		d.Depth > a.Depth;

	-- Delete the ancestor references to the category.
	DELETE FROM
		Tree.CtCategoryHierarchy
	WHERE
		AncestorId = @CategoryId;

	-- Delete the category.
	DELETE FROM
		Tree.CtCategory
	WHERE
		Id = @CategoryId;

	COMMIT TRAN;
GO
