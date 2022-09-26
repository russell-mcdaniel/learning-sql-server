PRINT N'Populating Tree.AlCategory...';
GO

-- Use a direct, destructive approach for simplicity.
DELETE FROM Tree.AlCategory;
GO

INSERT INTO
	Tree.AlCategory (Id, Name, ParentId)
VALUES
	-- Root
	(157, N'Products', NULL),

	-- Household
	(141, N'Household', 157),

	(103, N'Bathroom', 141),
	(194, N'Accessories', 103),
	(135, N'Cleaning', 103),
	(161, N'Linens', 103),

	(107, N'Bedroom', 141),
	(162, N'Furniture', 107),
	(110, N'Lighting', 107),
	(109, N'Linens', 107),

	(111, N'Kitchen', 141),
	(127, N'Appliances', 111),
	(113, N'Cookware', 111),
	(143, N'Dishes', 111),
	(115, N'Linens', 111),
	(137, N'Utensils', 111),

	(191, N'Living Room', 141),
	(118, N'Decor', 191),
	(184, N'Furniture', 191),
	(120, N'Lighting', 191),

	-- Sporting Goods
	(102, N'Sporting Goods', 157),

	(122, N'Individual', 102),
	(172, N'Cycling', 122),
	(124, N'Golf', 122),
	(181, N'Running', 122),
	(126, N'Swimming', 122),
	(167, N'Tennis', 122),

	(128, N'Team', 102),
	(174, N'Baseball', 128),
	(130, N'Basketball', 128),
	(148, N'Football', 128),
	(114, N'Hockey', 128),
	(133, N'Soccer', 128);
GO
