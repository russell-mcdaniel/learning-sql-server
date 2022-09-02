CREATE TABLE [Organization].[Professor]
(
	[InstitutionKey]						uniqueidentifier		NOT NULL,
	[DepartmentKey]							uniqueidentifier		NOT NULL,		-- It could be argued this should be an ordinary attribute.
	[ProfessorKey]							uniqueidentifier		NOT NULL,
	[DisplayName]							nvarchar(30)			NOT NULL
);
GO

ALTER TABLE [Organization].[Professor]
	ADD CONSTRAINT [pk_Professor]
	PRIMARY KEY CLUSTERED ([InstitutionKey], [DepartmentKey], [ProfessorKey])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

-- The name must be unique across the entire institution, not just the department. In the
-- real world, this is not a realistic constraint, but it is better for demo purposes.
ALTER TABLE [Organization].[Professor]
	ADD CONSTRAINT [uk_Professor_InstitutionKeyDepartmentKeyDisplayName]
	UNIQUE ([InstitutionKey], [DisplayName])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

ALTER TABLE [Organization].[Professor]
	ADD CONSTRAINT [fk_Professor_InstitutionKey_Institution]
	FOREIGN KEY ([InstitutionKey])
	REFERENCES [Organization].[Institution] ([InstitutionKey]);
GO

ALTER TABLE [Organization].[Professor]
	ADD CONSTRAINT [fk_Professor_InstitutionKeyDepartmentKey_Department]
	FOREIGN KEY ([InstitutionKey], [DepartmentKey])
	REFERENCES [Organization].[Department] ([InstitutionKey], [DepartmentKey]);
GO
