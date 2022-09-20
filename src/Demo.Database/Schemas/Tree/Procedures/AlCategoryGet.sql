-- --------------------------------------------------------------------------------
-- Get the path for a category.
--
-- Design Notes
--
-- This includes recursive logic to build the path. If only basic information
-- about the category were required, this could be a simple query by the ID.
-- --------------------------------------------------------------------------------
CREATE PROCEDURE [Tree].[AlCategoryGet]
	@CategoryId								int
AS
	SET NOCOUNT ON;

	WITH AlCategoryLevel (Id, Name, ParentId, Level, Lineage, Path)
	AS
	(
		SELECT
			c.Id							AS Id,
			c.Name							AS Name,
			c.ParentId						AS ParentId,
			1								AS Level,
			RIGHT(N'000' + CAST(ROW_NUMBER() OVER (ORDER BY c.Name) AS varchar(MAX)), 4)
											AS Lineage,
			CAST(c.Name AS nvarchar(MAX))	AS Path
		FROM
			Tree.AlCategory c
		WHERE
			c.ParentId IS NULL

		UNION ALL

		SELECT
			c.Id							AS Id,
			c.Name							AS Name,
			c.ParentId						AS ParentId,
			cl.Level + 1					AS Level,
			cl.Lineage + N'-' + RIGHT(N'000' + CAST(ROW_NUMBER() OVER (ORDER BY c.Name) AS varchar(MAX)), 4)
											AS Lineage,
			cl.Path + N' > ' + c.Name		AS Path
		FROM
			Tree.AlCategory c
		INNER JOIN
			AlCategoryLevel cl
		ON
			cl.Id = c.ParentId
	)
	SELECT
		cl.Id								AS CategoryId,
		cl.Name								AS CategoryName,
		cl.ParentId							AS ParentId,
		cl.Level							AS Level,
		cl.Lineage							AS Lineage,
		cl.Path								AS Path
	FROM
		AlCategoryLevel cl
	WHERE
		cl.Id = @CategoryId;
GO
