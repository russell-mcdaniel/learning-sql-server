--
-- Design Notes
--
-- For the initial design, the display name is required to be unique to
-- support differentiating students. This is not realistic and will run
-- into the limits of the name generator as more students are added.
--
-- Implement a student ID for uniqueness and permit duplicate names.
--
CREATE TABLE [Enrollment].[Student]
(
	[InstitutionKey]						uniqueidentifier		NOT NULL,
	[StudentKey]							uniqueidentifier		NOT NULL,
	[DisplayName]							nvarchar(40)			NOT NULL
);
GO

ALTER TABLE [Enrollment].[Student]
	ADD CONSTRAINT [pk_Student]
	PRIMARY KEY CLUSTERED ([InstitutionKey], [StudentKey])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

-- Enforce unique student display names for each institution.
ALTER TABLE [Enrollment].[Student]
	ADD CONSTRAINT [uk_Student_InstitutionKeyDisplayName]
	UNIQUE ([InstitutionKey], [DisplayName])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO
