-- ================================================================================
-- Hierarchy: Adjacency List - Queries
--
-- References
-- * https://stackoverflow.com/questions/23336520/getting-depth-first-traversal-insted-of-breadth-first-in-t-sql
-- * https://stackoverflow.com/questions/11636420/a-real-recursion-with-cte/11637387#11637387
-- * http://sqlanywhere.blogspot.com/2012/10/example-recursive-union-tree-traversal.html
-- ================================================================================
USE HierarchyDemo;
GO

--
-- Display all categories and their levels (breadth-first).
--
-- This performs a breadth-first traversal of the tree. This is not necessarily
-- the preferred order when presenting hierarchal data for human consumption.
--
WITH CategoryLevel (Id, Name, ParentId, Level)
AS
(
	SELECT
		c.Id							AS Id,
		c.Name							AS Name,
		c.ParentId						AS ParentId,
		1								AS Level
	FROM
		dbo.Category c
	WHERE
		c.ParentID IS NULL

	UNION ALL

	SELECT
		c.Id							AS Id,
		c.Name							AS Name,
		c.ParentId						AS ParentId,
		cl.Level + 1					AS Level
	FROM
		dbo.Category c
	INNER JOIN
		CategoryLevel cl
	ON
		cl.Id = c.ParentId
)
SELECT
	cl.Id								AS CategoryId,
	cl.Name								AS CategoryName,
	pc.Id								AS ParentId,
	pc.Name								AS ParentName,
	cl.Level							AS Level
FROM
	CategoryLevel cl
LEFT OUTER JOIN
	dbo.Category pc
ON
	pc.Id = cl.ParentId
ORDER BY
	cl.Level,
	cl.Name;
GO

--
-- Display all categories and their levels (depth-first).
--
-- This performs a depth-first traversal of the tree. This version keeps the
-- children grouped under their parents. Since there is nothing inherent to
-- the data to support this ordering, it must be constructed by the query.
--
WITH CategoryLevel (Id, Name, ParentId, Level, Lineage)
AS
(
	SELECT
		c.Id							AS Id,
		c.Name							AS Name,
		c.ParentId						AS ParentId,
		1								AS Level,
		RIGHT(N'00' + CAST(ROW_NUMBER() OVER (ORDER BY c.Name) AS varchar(MAX)), 3)
										AS Lineage
	FROM
		dbo.Category c
	WHERE
		c.ParentID IS NULL

	UNION ALL

	SELECT
		c.Id							AS Id,
		c.Name							AS Name,
		c.ParentId						AS ParentId,
		cl.Level + 1					AS Level,
		cl.Lineage + N'-' + RIGHT(N'00' + CAST(ROW_NUMBER() OVER (ORDER BY c.Name) AS varchar(MAX)), 3)
										AS Lineage
	FROM
		dbo.Category c
	INNER JOIN
		CategoryLevel cl
	ON
		cl.Id = c.ParentId
)
SELECT
	cl.Id								AS CategoryId,
	cl.Name								AS CategoryName,
	pc.Id								AS ParentId,
	pc.Name								AS ParentName,
	cl.Level							AS Level,
	cl.Lineage							AS Lineage
FROM
	CategoryLevel cl
LEFT OUTER JOIN
	dbo.Category pc
ON
	pc.Id = cl.ParentId
ORDER BY
	cl.Lineage;
GO

--
-- Display the children of a specific node.
--
SELECT
	c.Id								AS CategoryId,
	c.Name								AS CategoryName,
	c.ParentId							AS ParentId
FROM
	dbo.Category c
WHERE
	-- Products > Household > Kitchen
	c.ParentId = 11
ORDER BY
	c.Name;
GO

--
-- Display the parent of a specific node.
--
SELECT
	p.Id								AS CategoryId,
	p.Name								AS CategoryName,
	p.ParentId							AS ParentId
FROM
	dbo.Category p
INNER JOIN
	dbo.Category c
ON
	c.ParentId = p.Id
WHERE
	-- Products > Household > Kitchen
	c.Id = 11;
GO

--
-- Insert a new node.
--
INSERT INTO
	dbo.Category (Id, ParentId, Name)
VALUES
	-- Household > Bathroom > Fixtures
	(65, 3, N'Fixtures');
GO

--
-- Remove a node.
--
-- Requires reparenting any children before deleting the node.
--

-- Sporting Goods > Individual
DECLARE @CategoryId int = 22;

BEGIN TRAN;

-- Set the parent ID of the node's children to the node's parent ID.
UPDATE
	dbo.Category
SET
	ParentId = (SELECT ParentId FROM dbo.Category WHERE Id = @CategoryId)
WHERE
	ParentId = @CategoryId;

-- Delete the node.
DELETE FROM
	dbo.Category
WHERE
	Id = @CategoryId;

COMMIT TRAN;
GO
