CREATE TABLE [Curriculum].[Course]
(
	[InstitutionKey]						uniqueidentifier		NOT NULL,
	[DepartmentKey]							uniqueidentifier		NOT NULL,
	[CourseKey]								uniqueidentifier		NOT NULL,
	[DisplayName]							nvarchar(30)			NOT NULL,
	[Level]									smallint				NOT NULL
);
GO

ALTER TABLE [Curriculum].[Course]
	ADD CONSTRAINT [pk_Course]
	PRIMARY KEY CLUSTERED ([InstitutionKey], [DepartmentKey], [CourseKey])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

-- Enforce unique course display names for each department.
ALTER TABLE [Curriculum].[Course]
	ADD CONSTRAINT [uk_Course_InstitutionKeyDepartmentKeyDisplayName]
	UNIQUE ([InstitutionKey], [DepartmentKey], [DisplayName])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

-- The course level must be between 100 and 499.
ALTER TABLE [Curriculum].[Course]
	ADD CONSTRAINT [ck_Course_Level]
	CHECK ([Level]>(99) AND [Level]<(500));
GO

-- The foriegn key to the institution.
ALTER TABLE [Curriculum].[Course]
	ADD CONSTRAINT [fk_Course_InstitutionKey_Institution]
	FOREIGN KEY ([InstitutionKey])
	REFERENCES [Organization].[Institution] ([InstitutionKey]);
GO

-- The foriegn key to the department.
ALTER TABLE [Curriculum].[Course]
	ADD CONSTRAINT [fk_Course_InstitutionKeyDepartmentKey_Department]
	FOREIGN KEY ([InstitutionKey], [DepartmentKey])
	REFERENCES [Organization].[Department] ([InstitutionKey], [DepartmentKey]);
GO
