-- ================================================================================
-- PRE-DEPLOYMENT SCRIPTS BEGIN
-- ================================================================================

-- Explicitly configure compatibility level until SSDT supports SQL Server 2022.
ALTER DATABASE [$(DatabaseName)]
	SET COMPATIBILITY_LEVEL = 160;
GO

-- ================================================================================
-- PRE-DEPLOYMENT SCRIPTS END
-- ================================================================================
