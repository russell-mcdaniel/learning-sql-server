-- ================================================================================
-- Hierarchy: Closure Table - Model
--
-- Also known as a Bridge Table (Ralph Kimball).
--
-- NOTE: The hierarchy models in this series prefix related object names with
--       a code that identifies the type so they can coexist in one database.
-- ================================================================================
USE master;
GO

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = N'SqlDemo')
CREATE DATABASE SqlDemo;
GO

USE SqlDemo;
GO

DROP TABLE IF EXISTS dbo.CtCategoryHierarchy;
GO

DROP TABLE IF EXISTS dbo.CtCategory;
GO

CREATE TABLE dbo.CtCategory
(
	Id							int					NOT NULL,
	Name						nvarchar(20)		NOT NULL
);
GO

ALTER TABLE dbo.CtCategory
	ADD CONSTRAINT pk_CtCategory
	PRIMARY KEY CLUSTERED (Id);
GO

CREATE TABLE dbo.CtCategoryHierarchy
(
	AncestorId					int					NOT NULL,
	DescendantId				int					NOT NULL,
	Depth						int					NOT NULL
);
GO

ALTER TABLE dbo.CtCategoryHierarchy
	ADD CONSTRAINT pk_CtCategoryHierarchy
	PRIMARY KEY CLUSTERED (AncestorId, DescendantId);
GO

ALTER TABLE dbo.CtCategoryHierarchy
	ADD CONSTRAINT fk_CtCategoryHierarchy_AncestorId_CtCategory
	FOREIGN KEY (AncestorId)
	REFERENCES dbo.CtCategory (Id);
GO

ALTER TABLE dbo.CtCategoryHierarchy
	ADD CONSTRAINT fk_CtCategoryHierarchy_DescendantId_CtCategory
	FOREIGN KEY (DescendantId)
	REFERENCES dbo.CtCategory (Id);
GO

CREATE NONCLUSTERED INDEX ix_CtCategoryHierarchy_AncestorId
	ON dbo.CtCategoryHierarchy (AncestorId);
GO

CREATE NONCLUSTERED INDEX ix_CtCategoryHierarchy_DescendantId
	ON dbo.CtCategoryHierarchy (DescendantId);
GO

CREATE OR ALTER PROCEDURE dbo.CtCategoryInsert
	@Id							int,
	@Name						nvarchar(20),
	@AncestorId					int
AS
	SET NOCOUNT ON;
	SET XACT_ABORT ON;

	BEGIN TRAN;

	-- Create category.
	INSERT INTO
		dbo.CtCategory (Id, Name)
	VALUES
		(@Id, @Name);

	-- Create self-reference and ancestors.
	INSERT INTO
		dbo.CtCategoryHierarchy (AncestorId, DescendantId, Depth)
	SELECT
		@Id						AS AncestorId,
		@Id						AS DescendantId,
		0						AS Depth

	UNION ALL

	SELECT
		h.AncestorId			AS AncestorId,
		@Id						AS DescendantId,
		h.Depth + 1				AS Depth
	FROM
		dbo.CtCategoryHierarchy h
	WHERE
		h.DescendantId = @AncestorId;

	COMMIT TRAN;
GO

-- --------------------------------------------------------------------------------
-- Create categories.
-- --------------------------------------------------------------------------------
EXEC dbo.CtCategoryInsert @Id = 57, @Name = N'Products', @AncestorId = 57;

EXEC dbo.CtCategoryInsert @Id = 41, @Name = N'Household', @AncestorId = 57;

EXEC dbo.CtCategoryInsert @Id = 3, @Name = N'Bathroom', @AncestorId = 41;
EXEC dbo.CtCategoryInsert @Id = 4, @Name = N'Accessories', @AncestorId = 3;
EXEC dbo.CtCategoryInsert @Id = 5, @Name = N'Cleaning', @AncestorId = 3;
EXEC dbo.CtCategoryInsert @Id = 6, @Name = N'Linens', @AncestorId = 3;

EXEC dbo.CtCategoryInsert @Id = 7, @Name = N'Bedroom', @AncestorId = 41;
EXEC dbo.CtCategoryInsert @Id = 10, @Name = N'Lighting', @AncestorId = 7;
EXEC dbo.CtCategoryInsert @Id = 9, @Name = N'Linens', @AncestorId = 7;
EXEC dbo.CtCategoryInsert @Id = 62, @Name = N'Furniture', @AncestorId = 7;

EXEC dbo.CtCategoryInsert @Id = 11, @Name = N'Kitchen', @AncestorId = 41;
EXEC dbo.CtCategoryInsert @Id = 12, @Name = N'Appliances', @AncestorId = 11;
EXEC dbo.CtCategoryInsert @Id = 13, @Name = N'Cookware', @AncestorId = 11;
EXEC dbo.CtCategoryInsert @Id = 43, @Name = N'Dishes', @AncestorId = 11;
EXEC dbo.CtCategoryInsert @Id = 15, @Name = N'Linens', @AncestorId = 11;
EXEC dbo.CtCategoryInsert @Id = 16, @Name = N'Utensils', @AncestorId = 11;

EXEC dbo.CtCategoryInsert @Id = 91, @Name = N'Living Room', @AncestorId = 41;
EXEC dbo.CtCategoryInsert @Id = 18, @Name = N'Decor', @AncestorId = 91;
EXEC dbo.CtCategoryInsert @Id = 19, @Name = N'Furniture', @AncestorId = 91;
EXEC dbo.CtCategoryInsert @Id = 20, @Name = N'Lighting', @AncestorId = 91;

EXEC dbo.CtCategoryInsert @Id = 2, @Name = N'Sporting Goods', @AncestorId = 57;

EXEC dbo.CtCategoryInsert @Id = 22, @Name = N'Individual', @AncestorId = 2;
EXEC dbo.CtCategoryInsert @Id = 23, @Name = N'Cycling', @AncestorId = 22;
EXEC dbo.CtCategoryInsert @Id = 24, @Name = N'Golf', @AncestorId = 22;
EXEC dbo.CtCategoryInsert @Id = 81, @Name = N'Running', @AncestorId = 22;
EXEC dbo.CtCategoryInsert @Id = 26, @Name = N'Swimming', @AncestorId = 22;
EXEC dbo.CtCategoryInsert @Id = 67, @Name = N'Tennis', @AncestorId = 22;

EXEC dbo.CtCategoryInsert @Id = 28, @Name = N'Team', @AncestorId = 2;
EXEC dbo.CtCategoryInsert @Id = 74, @Name = N'Baseball', @AncestorId = 28;
EXEC dbo.CtCategoryInsert @Id = 30, @Name = N'Basketball', @AncestorId = 28;
EXEC dbo.CtCategoryInsert @Id = 31, @Name = N'Football', @AncestorId = 28;
EXEC dbo.CtCategoryInsert @Id = 14, @Name = N'Hockey', @AncestorId = 28;
EXEC dbo.CtCategoryInsert @Id = 33, @Name = N'Soccer', @AncestorId = 28;
GO
