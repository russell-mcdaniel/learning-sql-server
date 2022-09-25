-- --------------------------------------------------------------------------------
-- Delete a category including children.
-- --------------------------------------------------------------------------------
CREATE PROCEDURE [Tree].[CtCategoryDeleteIncludingChildren]
	@CategoryId								int
AS
	SET NOCOUNT ON;
	SET XACT_ABORT ON;

	BEGIN TRAN;

	-- Create a list of the category and its descendants. This needs to tracked
	-- independently for deleting the descendant categories because there is no
	-- way to find them once the relationships are removed.
	DECLARE @CategoryDelete TABLE
	(
		Id									int					NOT NULL	PRIMARY KEY CLUSTERED
	);

	INSERT INTO
		@CategoryDelete (Id)
	SELECT
		h.DescendantId
	FROM
		Tree.CtCategoryHierarchy h
	WHERE
		h.AncestorId = @CategoryId;

	-- Delete the references to the category and its descendants.
	DELETE FROM
		h
	FROM
		Tree.CtCategoryHierarchy h
	INNER JOIN
		@CategoryDelete d
	ON
		d.Id = h.DescendantId;

	-- Delete the category and its descendants.
	DELETE
		c
	FROM
		Tree.CtCategory c
	INNER JOIN
		@CategoryDelete d
	ON
		d.Id = c.Id;

	COMMIT TRAN;
GO
