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

-- Enforce unique student display names for each institution. In the real world,
-- this is not a realistic constraint, but it is better for demo purposes.
ALTER TABLE [Enrollment].[Student]
	ADD CONSTRAINT [uk_Student_InstitutionKeyDisplayName]
	UNIQUE ([InstitutionKey], [DisplayName])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO
