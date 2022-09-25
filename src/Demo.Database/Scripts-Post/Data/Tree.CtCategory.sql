-- TODO: Rework approach for idempotency. This will break on upgrade deployment.
PRINT N'Populating Tree.CtCategory...';
GO

EXEC Tree.CtCategoryInsert @CategoryId = 157, @Name = N'Products', @AncestorId = 157;
GO

EXEC Tree.CtCategoryInsert @CategoryId = 141, @Name = N'Household', @AncestorId = 157;
GO

EXEC Tree.CtCategoryInsert @CategoryId = 103, @Name = N'Bathroom', @AncestorId = 141;
EXEC Tree.CtCategoryInsert @CategoryId = 194, @Name = N'Accessories', @AncestorId = 103;
EXEC Tree.CtCategoryInsert @CategoryId = 135, @Name = N'Cleaning', @AncestorId = 103;
EXEC Tree.CtCategoryInsert @CategoryId = 161, @Name = N'Linens', @AncestorId = 103;
GO

EXEC Tree.CtCategoryInsert @CategoryId = 107, @Name = N'Bedroom', @AncestorId = 141;
EXEC Tree.CtCategoryInsert @CategoryId = 162, @Name = N'Furniture', @AncestorId = 107;
EXEC Tree.CtCategoryInsert @CategoryId = 110, @Name = N'Lighting', @AncestorId = 107;
EXEC Tree.CtCategoryInsert @CategoryId = 109, @Name = N'Linens', @AncestorId = 107;
GO

EXEC Tree.CtCategoryInsert @CategoryId = 111, @Name = N'Kitchen', @AncestorId = 141;
EXEC Tree.CtCategoryInsert @CategoryId = 127, @Name = N'Appliances', @AncestorId = 111;
EXEC Tree.CtCategoryInsert @CategoryId = 113, @Name = N'Cookware', @AncestorId = 111;
EXEC Tree.CtCategoryInsert @CategoryId = 143, @Name = N'Dishes', @AncestorId = 111;
EXEC Tree.CtCategoryInsert @CategoryId = 115, @Name = N'Linens', @AncestorId = 111;
EXEC Tree.CtCategoryInsert @CategoryId = 137, @Name = N'Utensils', @AncestorId = 111;
GO

EXEC Tree.CtCategoryInsert @CategoryId = 191, @Name = N'Living Room', @AncestorId = 141;
EXEC Tree.CtCategoryInsert @CategoryId = 118, @Name = N'Decor', @AncestorId = 191;
EXEC Tree.CtCategoryInsert @CategoryId = 184, @Name = N'Furniture', @AncestorId = 191;
EXEC Tree.CtCategoryInsert @CategoryId = 120, @Name = N'Lighting', @AncestorId = 191;
GO

EXEC Tree.CtCategoryInsert @CategoryId = 102, @Name = N'Sporting Goods', @AncestorId = 157;
GO

EXEC Tree.CtCategoryInsert @CategoryId = 122, @Name = N'Individual', @AncestorId = 102;
EXEC Tree.CtCategoryInsert @CategoryId = 172, @Name = N'Cycling', @AncestorId = 122;
EXEC Tree.CtCategoryInsert @CategoryId = 124, @Name = N'Golf', @AncestorId = 122;
EXEC Tree.CtCategoryInsert @CategoryId = 181, @Name = N'Running', @AncestorId = 122;
EXEC Tree.CtCategoryInsert @CategoryId = 126, @Name = N'Swimming', @AncestorId = 122;
EXEC Tree.CtCategoryInsert @CategoryId = 167, @Name = N'Tennis', @AncestorId = 122;
GO

EXEC Tree.CtCategoryInsert @CategoryId = 128, @Name = N'Team', @AncestorId = 102;
EXEC Tree.CtCategoryInsert @CategoryId = 174, @Name = N'Baseball', @AncestorId = 128;
EXEC Tree.CtCategoryInsert @CategoryId = 130, @Name = N'Basketball', @AncestorId = 128;
EXEC Tree.CtCategoryInsert @CategoryId = 148, @Name = N'Football', @AncestorId = 128;
EXEC Tree.CtCategoryInsert @CategoryId = 114, @Name = N'Hockey', @AncestorId = 128;
EXEC Tree.CtCategoryInsert @CategoryId = 133, @Name = N'Soccer', @AncestorId = 128;
GO
