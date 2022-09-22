-- ================================================================================
-- Hierarchy: Closure Table
-- ================================================================================
USE Demo;
GO

-- --------------------------------------------------------------------------------
-- Get the path for a category.
-- --------------------------------------------------------------------------------

-- Products > Sporting Goods > Team > Basketball
--EXEC Tree.CtCategoryGet @CategoryId = 130;
--GO

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
