USE Learning;
GO

SELECT
	rsi.*
FROM
	sys.query_store_runtime_stats_interval rsi
GO

SELECT
	rs.*
FROM
	sys.query_store_runtime_stats rs
GO
