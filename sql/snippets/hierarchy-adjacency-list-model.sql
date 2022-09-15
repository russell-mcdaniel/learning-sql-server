-- ================================================================================
-- Hierarchy: Adjacency List - Model
-- ================================================================================
USE master;
GO

IF EXISTS (SELECT * FROM sys.databases WHERE name = N'HierarchyDemo')
BEGIN
	ALTER DATABASE HierarchyDemo
		SET SINGLE_USER
		WITH ROLLBACK IMMEDIATE;

	DROP DATABASE HierarchyDemo;
END;
GO

CREATE DATABASE HierarchyDemo;
GO

USE HierarchyDemo;
GO

CREATE TABLE dbo.Category
(
	Id							int					NOT NULL,
	ParentId					int					NULL,
	Name						nvarchar(20)		NOT NULL
);
GO

ALTER TABLE dbo.Category
	ADD CONSTRAINT pk_Category
	PRIMARY KEY CLUSTERED (Id);
GO

ALTER TABLE dbo.Category
	ADD CONSTRAINT fk_CategoryParentId_Category
	FOREIGN KEY (ParentId)
	REFERENCES dbo.Category (Id);
GO

CREATE NONCLUSTERED INDEX ix_Category_ParentId
	ON dbo.Category (ParentId);
GO

-- Randomization is incorporated into the ID values to demonstrate that
-- the behavior of the queries does not depend on the order of the keys.
INSERT INTO
	dbo.Category (Id, ParentId, Name)
VALUES
	-- Root
	(57, NULL, N'Products'),

	-- Household
	(41,   57, N'Household'),

	( 3,   41, N'Bathroom'),
	( 4,    3, N'Accessories'),
	( 5,    3, N'Cleaning'),
	( 6,    3, N'Linens'),

	( 7,   41, N'Bedroom'),
	(62,    7, N'Furniture'),
	( 9,    7, N'Linens'),
	(10,    7, N'Lighting'),

	(11,   41, N'Kitchen'),
	(12,   11, N'Appliances'),
	(13,   11, N'Cookware'),
	(43,   11, N'Dishes'),
	(15,   11, N'Linens'),
	(16,   11, N'Utensils'),

	(91,   41, N'Living Room'),
	(18,   91, N'Decor'),
	(19,   91, N'Furniture'),
	(20,   91, N'Lighting'),

	-- Sporting Goods
	( 2,   57, N'Sporting Goods'),

	(22,    2, N'Individual'),
	(23,   22, N'Cycling'),
	(24,   22, N'Golf'),
	(81,   22, N'Running'),
	(26,   22, N'Swimming'),
	(67,   22, N'Tennis'),

	(28,    2, N'Team'),
	(74,   28, N'Baseball'),
	(30,   28, N'Basketball'),
	(31,   28, N'Football'),
	(14,   28, N'Hockey'),
	(33,   28, N'Soccer');
GO
