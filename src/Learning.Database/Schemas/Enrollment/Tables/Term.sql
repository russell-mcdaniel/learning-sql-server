--
-- Design Notes
--
-- This table does not strictly require a surrogate key, but one is provided
-- to help simplify references to a specific term.
--
CREATE TABLE [Enrollment].[Term]
(
	[TermKey]								uniqueidentifier		NOT NULL,
	[TermSystemKey]							uniqueidentifier		NOT NULL,
	[TermPeriodKey]							uniqueidentifier		NOT NULL,
	[Year]									smallint				NOT NULL
);
GO

ALTER TABLE [Enrollment].[Term]
	ADD CONSTRAINT [pk_Term]
	PRIMARY KEY CLUSTERED ([TermKey])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

ALTER TABLE [Enrollment].[Term]
	ADD CONSTRAINT [uk_Term_TermSystemKeyTermPeriodKeyYear]
	UNIQUE ([TermSystemKey], [TermPeriodKey], [Year])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

ALTER TABLE [Enrollment].[Term]
	ADD CONSTRAINT [fk_Term_TermSystemKey_TermSystem]
	FOREIGN KEY ([TermSystemKey])
	REFERENCES [Core].[TermSystem] ([TermSystemKey]);
GO

ALTER TABLE [Enrollment].[Term]
	ADD CONSTRAINT [fk_Term_TermSystemKeyTermPeriodKey_TermPeriod]
	FOREIGN KEY ([TermSystemKey], [TermPeriodKey])
	REFERENCES [Core].[TermPeriod] ([TermSystemKey], [TermPeriodKey]);
GO
