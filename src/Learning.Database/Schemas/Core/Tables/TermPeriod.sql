--
-- Design Notes
--
-- It is not clear how the ordinal helps with the current term system design
-- because academic years often cross calendar year boundaries. Review the
-- term system design further to detail is functionality.
--
CREATE TABLE [Core].[TermPeriod]
(
	[TermSystemKey]							uniqueidentifier		NOT NULL,
	[TermPeriodKey]							uniqueidentifier		NOT NULL,
	[DisplayName]							nvarchar(20)			NOT NULL,
	[Ordinal]								smallint				NOT NULL	-- The order of the period in an academic year.
);
GO

ALTER TABLE [Core].[TermPeriod]
	ADD CONSTRAINT [pk_TermPeriod]
	PRIMARY KEY CLUSTERED ([TermSystemKey], [TermPeriodKey])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

ALTER TABLE [Core].[TermPeriod]
	ADD CONSTRAINT [uk_TermPeriod_TermSystemKeyDisplayName]
	UNIQUE ([TermSystemKey], [DisplayName])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

ALTER TABLE [Core].[TermPeriod]
	ADD CONSTRAINT [uk_TermPeriod_TermSystemKeyOrdinal]
	UNIQUE ([TermSystemKey], [Ordinal])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

ALTER TABLE [Core].[TermPeriod]
	ADD CONSTRAINT [fk_TermPeriod_TermSystemKey_TermSystem]
	FOREIGN KEY ([TermSystemKey])
	REFERENCES [Core].[TermSystem] ([TermSystemKey]);
GO
