CREATE TABLE [Curriculum].[Program]
(
	[InstitutionKey]						uniqueidentifier		NOT NULL,
	[DepartmentKey]							uniqueidentifier		NOT NULL,
	[ProgramKey]							uniqueidentifier		NOT NULL,
	[DisplayName]							nvarchar(40)			NOT NULL,
	[ProgramType]							nvarchar(10)			NOT NULL
);
GO

ALTER TABLE [Curriculum].[Program]
	ADD CONSTRAINT [pk_Program]
	PRIMARY KEY CLUSTERED ([InstitutionKey], [DepartmentKey], [ProgramKey])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

-- Enforce unique program display names for each department.
ALTER TABLE [Curriculum].[Program]
	ADD CONSTRAINT [uk_Program_InstitutionKeyDepartmentKeyDisplayName]
	UNIQUE ([InstitutionKey], [DepartmentKey], [DisplayName])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

-- The foriegn key to the institution.
ALTER TABLE [Curriculum].[Program]
	ADD CONSTRAINT [fk_Program_InstitutionKey_Institution]
	FOREIGN KEY ([InstitutionKey])
	REFERENCES [Organization].[Institution] ([InstitutionKey]);
GO

-- The program type must be "Major" or "Minor".
ALTER TABLE [Curriculum].[Program]
	ADD CONSTRAINT [ck_Program_ProgramType]
	CHECK ([ProgramType]=N'Major' OR [ProgramType]=N'Minor');
GO
