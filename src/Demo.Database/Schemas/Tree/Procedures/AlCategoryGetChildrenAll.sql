-- --------------------------------------------------------------------------------
-- Get all children of a category.
--
-- Design Notes
--
-- Since there is nothing inherent to the data to provide natural hierarchal
-- ordering, it must be constructed by the query (see Lineage).
-- --------------------------------------------------------------------------------
CREATE PROCEDURE [Tree].[AlCategoryGetChildrenAll]
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
			c.Id = @CategoryId

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
		pc.Id								AS ParentId,
		pc.Name								AS ParentName,
		cl.Level							AS Level,
		cl.Lineage							AS Lineage,
		cl.Path								AS Path
	FROM
		AlCategoryLevel cl
	LEFT OUTER JOIN
		Tree.AlCategory pc
	ON
		pc.Id = cl.ParentId
	WHERE
		cl.Id <> @CategoryId
	ORDER BY
		cl.Lineage;
GO
