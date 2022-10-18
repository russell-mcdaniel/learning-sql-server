-- ================================================================================
-- Hierarchy: Adjacency List
-- ================================================================================
USE Demo;
GO

-- --------------------------------------------------------------------------------
-- Get the path for a category.
-- --------------------------------------------------------------------------------

-- Products > Sporting Goods > Team > Basketball
EXEC Tree.AlCategoryGet @CategoryId = 130;
GO

-- --------------------------------------------------------------------------------
-- Get the path for all categories.
-- --------------------------------------------------------------------------------

EXEC Tree.AlCategoryGetAll;
GO

-- --------------------------------------------------------------------------------
-- Get the immediate children of a category.
-- --------------------------------------------------------------------------------

-- Products
EXEC Tree.AlCategoryGetChildrenImmediate @CategoryId = 157;
GO

-- Products > Household > Kitchen
EXEC Tree.AlCategoryGetChildrenImmediate @CategoryId = 111;
GO

-- --------------------------------------------------------------------------------
-- Get all children of a category.
-- --------------------------------------------------------------------------------

-- Products
EXEC Tree.AlCategoryGetChildrenAll @CategoryId = 157;
GO

-- Products > Household > Kitchen
EXEC Tree.AlCategoryGetChildrenAll @CategoryId = 111;
GO

-- --------------------------------------------------------------------------------
-- Get the parent of a category.
-- --------------------------------------------------------------------------------

-- Products > Sporting Goods > Individual > Tennis
EXEC Tree.AlCategoryGetParent @CategoryId = 167;
GO

-- --------------------------------------------------------------------------------
-- Insert a category.
-- --------------------------------------------------------------------------------

-- Products > Household > Bathroom > Fixtures
EXEC Tree.AlCategoryInsert @CategoryId = 237, @Name = N'Fixtures', @ParentId = 103;
GO

-- --------------------------------------------------------------------------------
-- Move a category.
-- --------------------------------------------------------------------------------

-- This might not make sense, but it is only for demonstration purposes:
-- Products > Household > Bathroom --> Products > Sporting Goods
EXEC Tree.AlCategoryMove @CategoryId = 103, @ParentId = 102;
GO

-- --------------------------------------------------------------------------------
-- Delete a category including children.
-- --------------------------------------------------------------------------------

-- Delete a leaf-level category.
-- Products > Household > Kitchen > Utensils
EXEC Tree.AlCategoryDeleteIncludingChildren @CategoryId = 137;
GO

-- Delete an intermediate-level category.
-- Products > Sporting Goods > Individual
EXEC Tree.AlCategoryDeleteIncludingChildren @CategoryId = 122;
GO

-- --------------------------------------------------------------------------------
-- Delete a category promoting children.
-- --------------------------------------------------------------------------------

-- Delete a leaf-level category.
-- Products > Household > Living Room > Decor
EXEC Tree.AlCategoryDeletePromotingChildren @CategoryId = 118;
GO

-- Delete an intermediate-level category.
-- Products > Household > Bedroom
EXEC Tree.AlCategoryDeletePromotingChildren @CategoryId = 107;
GO
