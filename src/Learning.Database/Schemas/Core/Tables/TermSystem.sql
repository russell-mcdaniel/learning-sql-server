--
-- Design Notes
--
-- The term system schema design is ambiguous with respect to academic years
-- since they often cross calendar year boundaries. Review this design.
--
CREATE TABLE [Core].[TermSystem]
(
	[TermSystemKey]							uniqueidentifier		NOT NULL,
	[DisplayName]							nvarchar(20)			NOT NULL
);
GO

ALTER TABLE [Core].[TermSystem]
	ADD CONSTRAINT [pk_TermSystem]
	PRIMARY KEY CLUSTERED ([TermSystemKey])
	WITH (FILLFACTOR = 100)
	ON [PRIMARY];
GO

ALTER TABLE [Core].[TermSystem]
	ADD CONSTRAINT [uk_TermSystem_DisplayName]
	UNIQUE ([DisplayName])
	WITH (FILLFACTOR = 100)
	ON [PRIMARY];
GO
