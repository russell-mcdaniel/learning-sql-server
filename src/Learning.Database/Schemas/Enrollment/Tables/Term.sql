--
-- Design Notes
--
-- Terms are modeled based on a semester-based academic year.
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
	[CalendarYear]							smallint				NOT NULL,
	[SeasonName]							nvarchar(20)			NOT NULL
);
GO

ALTER TABLE [Enrollment].[Term]
	ADD CONSTRAINT [pk_Term]
	PRIMARY KEY CLUSTERED ([InstitutionKey], [TermKey])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

ALTER TABLE [Enrollment].[Term]
	ADD CONSTRAINT [uk_Term_InstitutionKeyAcademicYearCalendarYear]
	UNIQUE ([InstitutionKey], [AcademicYear], [CalendarYear])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

-- The foreign key to the institution.
ALTER TABLE [Enrollment].[Term]
	ADD CONSTRAINT [fk_Term_InstitutionKey_Institution]
	FOREIGN KEY ([InstitutionKey])
	REFERENCES [Organization].[Institution] ([InstitutionKey])
GO

-- The term season name must be "Fall" or "Spring".
ALTER TABLE [Enrollment].[Term]
	ADD CONSTRAINT [ck_Term_SeasonName]
	CHECK ([SeasonName]=N'Fall' OR [SeasonName]=N'Spring');
GO
