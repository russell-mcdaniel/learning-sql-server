-- --------------------------------------------------------------------------------
-- Get the path for all categories.
-- --------------------------------------------------------------------------------
CREATE PROCEDURE [Tree].[AlCategoryGetAll]
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
	ORDER BY
		cl.Lineage;
GO
