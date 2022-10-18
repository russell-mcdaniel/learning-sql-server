-- ================================================================================
-- Hierarchy: Closure Table
-- ================================================================================
USE Demo;
GO

-- --------------------------------------------------------------------------------
-- Get the path for a category.
-- --------------------------------------------------------------------------------

-- Products > Sporting Goods > Team > Basketball
EXEC Tree.CtCategoryGet @CategoryId = 130;
GO

-- --------------------------------------------------------------------------------
-- Get the path for all categories.
-- --------------------------------------------------------------------------------

EXEC Tree.CtCategoryGetAll;
GO

-- --------------------------------------------------------------------------------
-- Get the immediate children of a category.
-- --------------------------------------------------------------------------------

-- Products
EXEC Tree.CtCategoryGetChildrenImmediate @CategoryId = 157;
GO

-- Products > Household > Kitchen
EXEC Tree.CtCategoryGetChildrenImmediate @CategoryId = 111;
GO

-- --------------------------------------------------------------------------------
-- Get all children of a category.
-- --------------------------------------------------------------------------------

-- Products
EXEC Tree.CtCategoryGetChildrenAll @CategoryId = 157;
GO

-- Products > Household > Kitchen
EXEC Tree.CtCategoryGetChildrenAll @CategoryId = 111;
GO

-- --------------------------------------------------------------------------------
-- Get the parent of a category.
-- --------------------------------------------------------------------------------

-- Products > Sporting Goods > Individual > Tennis
EXEC Tree.CtCategoryGetParent @CategoryId = 167;
GO

-- --------------------------------------------------------------------------------
-- Insert a category.
-- --------------------------------------------------------------------------------

-- Products > Household > Bathroom > Fixtures
EXEC Tree.CtCategoryInsert @CategoryId = 237, @Name = N'Fixtures', @AncestorId = 103;
GO

-- --------------------------------------------------------------------------------
-- Move a category.
-- --------------------------------------------------------------------------------

-- This might not make sense, but it is only for demonstration purposes:
-- Products > Household > Bathroom --> Products > Sporting Goods
EXEC Tree.CtCategoryMove @CategoryId = 103, @AncestorId = 102;
GO

-- --------------------------------------------------------------------------------
-- Delete a category including children.
-- --------------------------------------------------------------------------------

-- Delete a leaf-level category.
-- Products > Household > Kitchen > Utensils
EXEC Tree.CtCategoryDeleteIncludingChildren @CategoryId = 137;
GO

-- Delete an intermediate-level category.
-- Products > Sporting Goods > Individual
EXEC Tree.CtCategoryDeleteIncludingChildren @CategoryId = 122;
GO

-- --------------------------------------------------------------------------------
-- Delete a category promoting children.
-- --------------------------------------------------------------------------------

-- Delete a leaf-level category.
-- Products > Household > Living Room > Decor
EXEC Tree.CtCategoryDeletePromotingChildren @CategoryId = 118;
GO

-- Delete an intermediate-level category.
-- Products > Household > Bedroom
EXEC Tree.CtCategoryDeletePromotingChildren @CategoryId = 107;
GO
