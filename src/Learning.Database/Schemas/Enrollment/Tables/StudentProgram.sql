--
-- Design Notes
--
-- Optimal index support for foreign keys is unclear. There is no index
-- for InstitutionKey, StudentKey because it is presumed that the primary
-- key beginning with those columns provides adequate support, albeit
-- no precise due to the subsequent columns.
--
-- If this is truly sufficient, then the dedicated index for the foreign
-- key to department could also be considered superfluous and instead
-- rely on the index for the foreign key to program which is a superset.
--
-- If it is not sufficient, then there should be a dedicated index for
-- the relationship to the student table (InstitutionKey, StudentKey).
--
-- This situation exists on other tables as well.
--
CREATE TABLE [Enrollment].[StudentProgram]
(
	[InstitutionKey]						uniqueidentifier		NOT NULL,
	[StudentKey]							uniqueidentifier		NOT NULL,
	[DepartmentKey]							uniqueidentifier		NOT NULL,
	[ProgramKey]							uniqueidentifier		NOT NULL
);
GO

ALTER TABLE [Enrollment].[StudentProgram]
	ADD CONSTRAINT [pk_StudentProgram]
	PRIMARY KEY CLUSTERED ([InstitutionKey], [StudentKey], [DepartmentKey], [ProgramKey])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

-- The foreign key to the institution.
ALTER TABLE [Enrollment].[StudentProgram]
	ADD CONSTRAINT [fk_StudentProgram_InstitutionKey_Institution]
	FOREIGN KEY ([InstitutionKey])
	REFERENCES [Organization].[Institution] ([InstitutionKey]);
GO

-- The foreign key to the student.
ALTER TABLE [Enrollment].[StudentProgram]
	ADD CONSTRAINT [fk_StudentProgram_InstitutionKeyStudentKey_Student]
	FOREIGN KEY ([InstitutionKey], [StudentKey])
	REFERENCES [Enrollment].[Student] ([InstitutionKey], [StudentKey]);
GO

-- The foreign key to the department.
ALTER TABLE [Enrollment].[StudentProgram]
	ADD CONSTRAINT [fk_StudentProgram_InstitutionKeyDepartmentKey_Department]
	FOREIGN KEY ([InstitutionKey], [DepartmentKey])
	REFERENCES [Organization].[Department] ([InstitutionKey], [DepartmentKey]);
GO

-- The foreign key to the program.
ALTER TABLE [Enrollment].[StudentProgram]
	ADD CONSTRAINT [fk_StudentProgram_InstitutionKeyDepartmentKeyProgramKey_Program]
	FOREIGN KEY ([InstitutionKey], [DepartmentKey], [ProgramKey])
	REFERENCES [Curriculum].[Program] ([InstitutionKey], [DepartmentKey], [ProgramKey]);
GO

-- Supports the foreign key to the department.
CREATE NONCLUSTERED INDEX [ix_StudentProgram_InstitutionKeyDepartmentKey]
	ON [Enrollment].[StudentProgram] ([InstitutionKey], [DepartmentKey])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

-- Supports the foreign key to the program.
CREATE NONCLUSTERED INDEX [ix_StudentProgram_InstitutionKeyDepartmentKeyProgramKey]
	ON [Enrollment].[StudentProgram] ([InstitutionKey], [DepartmentKey], [ProgramKey])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO
