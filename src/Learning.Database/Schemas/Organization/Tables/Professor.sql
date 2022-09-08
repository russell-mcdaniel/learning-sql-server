--
-- Design Notes
--
-- The department-professor relationship is not considered identifying, but
-- the model includes DepartmentKey in the entity key because it anticipates
-- that listing professors by department will be a common case and it does
-- not hinder efficiently querying for professors by institution.
--
CREATE TABLE [Organization].[Professor]
(
	[InstitutionKey]						uniqueidentifier		NOT NULL,
	[DepartmentKey]							uniqueidentifier		NOT NULL,
	[ProfessorKey]							uniqueidentifier		NOT NULL,
	[DisplayName]							nvarchar(40)			NOT NULL
);
GO

ALTER TABLE [Organization].[Professor]
	ADD CONSTRAINT [pk_Professor]
	PRIMARY KEY CLUSTERED ([InstitutionKey], [DepartmentKey], [ProfessorKey])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

-- Enforce unique professor display names for each department.
ALTER TABLE [Organization].[Professor]
	ADD CONSTRAINT [uk_Professor_InstitutionKeyDepartmentKeyDisplayName]
	UNIQUE ([InstitutionKey], [DepartmentKey], [DisplayName])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

-- The foriegn key to the institution.
ALTER TABLE [Organization].[Professor]
	ADD CONSTRAINT [fk_Professor_InstitutionKey_Institution]
	FOREIGN KEY ([InstitutionKey])
	REFERENCES [Organization].[Institution] ([InstitutionKey]);
GO

-- The foriegn key to the department.
ALTER TABLE [Organization].[Professor]
	ADD CONSTRAINT [fk_Professor_InstitutionKeyDepartmentKey_Department]
	FOREIGN KEY ([InstitutionKey], [DepartmentKey])
	REFERENCES [Organization].[Department] ([InstitutionKey], [DepartmentKey]);
GO
