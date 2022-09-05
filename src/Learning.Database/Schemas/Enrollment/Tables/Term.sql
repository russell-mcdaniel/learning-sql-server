--
-- Design Notes
--
-- Providing terms in temporal order is not straightfoward in this design. See
-- the notes on TermSystem and TermPeriod and reconsider the design.
-- 
-- It is not strictly necessary to provide a surrogate key, but it makes it
-- easier to reference specific instances of this entity from other entities.
--
-- It is not clear if the PK on TermKey or the UK should be clustered until
-- the query patterns for this table are better understood. The design begins
-- with the clustering key on the UK since its keys have intrinsic meaning
-- and having them available in order may provide more value.
--
CREATE TABLE [Enrollment].[Term]
(
	[InstitutionKey]						uniqueidentifier		NOT NULL,
	[TermKey]								uniqueidentifier		NOT NULL,
	[AcademicYear]							char(9)					NOT NULL,	-- "YYYY-YYYY"
	[TermSystemKey]							uniqueidentifier		NOT NULL,
	[TermPeriodKey]							uniqueidentifier		NOT NULL,
	[CalendarYear]							smallint				NOT NULL
);
GO

ALTER TABLE [Enrollment].[Term]
	ADD CONSTRAINT [pk_Term]
	PRIMARY KEY ([InstitutionKey], [TermKey])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

ALTER TABLE [Enrollment].[Term]
	ADD CONSTRAINT [uk_Term_InstitutionKeyTermSystemKeyAcademicYearTermPeriodKey]
	UNIQUE CLUSTERED ([InstitutionKey], [TermSystemKey], [AcademicYear], [TermPeriodKey])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

-- The foreign key to the institution.
ALTER TABLE [Enrollment].[Term]
	ADD CONSTRAINT [fk_Term_InstitutionKey_Institution]
	FOREIGN KEY ([InstitutionKey])
	REFERENCES [Organization].[Institution] ([InstitutionKey])
GO

-- The foreign key to the term system.
ALTER TABLE [Enrollment].[Term]
	ADD CONSTRAINT [fk_Term_TermSystemKey_TermSystem]
	FOREIGN KEY ([TermSystemKey])
	REFERENCES [Core].[TermSystem] ([TermSystemKey]);
GO

-- The foreign key to the term period.
ALTER TABLE [Enrollment].[Term]
	ADD CONSTRAINT [fk_Term_TermSystemKeyTermPeriodKey_TermPeriod]
	FOREIGN KEY ([TermSystemKey], [TermPeriodKey])
	REFERENCES [Core].[TermPeriod] ([TermSystemKey], [TermPeriodKey]);
GO
