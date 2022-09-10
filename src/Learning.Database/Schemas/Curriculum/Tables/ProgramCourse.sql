CREATE TABLE [Curriculum].[ProgramCourse]
(
	[InstitutionKey]						uniqueidentifier		NOT NULL,
	[DepartmentKey]							uniqueidentifier		NOT NULL,
	[ProgramKey]							uniqueidentifier		NOT NULL,
	[CourseKey]								uniqueidentifier		NOT NULL
);
GO

-- The primary key supports finding courses by program.
ALTER TABLE [Curriculum].[ProgramCourse]
	ADD CONSTRAINT [pk_ProgramCourse]
	PRIMARY KEY CLUSTERED ([InstitutionKey], [DepartmentKey], [ProgramKey], [CourseKey])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

-- The alternate key supports finding programs by course.
ALTER TABLE [Curriculum].[ProgramCourse]
	ADD CONSTRAINT [uk_ProgramCourse_InstitutionKeyDepartmentKeyCourseKeyProgramKey]
	UNIQUE ([InstitutionKey], [DepartmentKey], [CourseKey], [ProgramKey])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

-- The foreign key to the institution.
ALTER TABLE [Curriculum].[ProgramCourse]
	ADD CONSTRAINT [fk_ProgramCourse_InstitutionKey_Institution]
	FOREIGN KEY ([InstitutionKey])
	REFERENCES [Organization].[Institution] ([InstitutionKey]);
GO

-- The foreign key to the department.
ALTER TABLE [Curriculum].[ProgramCourse]
	ADD CONSTRAINT [fk_ProgramCourse_InstitutionKeyDepartmentKey_Department]
	FOREIGN KEY ([InstitutionKey], [DepartmentKey])
	REFERENCES [Organization].[Department] ([InstitutionKey], [DepartmentKey]);
GO

-- The foreign key to the program.
ALTER TABLE [Curriculum].[ProgramCourse]
	ADD CONSTRAINT [fk_ProgramCourse_InstitutionKeyDepartmentKeyProgramKey_Program]
	FOREIGN KEY ([InstitutionKey], [DepartmentKey], [ProgramKey])
	REFERENCES [Curriculum].[Program] ([InstitutionKey], [DepartmentKey], [ProgramKey]);
GO

-- The foreign key to the course.
ALTER TABLE [Curriculum].[ProgramCourse]
	ADD CONSTRAINT [fk_ProgramCourse_InstitutionKeyDepartmentKeyCourseKey_Course]
	FOREIGN KEY ([InstitutionKey], [DepartmentKey], [CourseKey])
	REFERENCES [Curriculum].[Course] ([InstitutionKey], [DepartmentKey], [CourseKey]);
GO

-- Supports the foreign key to the course.
CREATE NONCLUSTERED INDEX [ix_ProgramCourse_InstitutionKeyDepartmentKeyCourseKey]
	ON [Curriculum].[ProgramCourse] ([InstitutionKey], [DepartmentKey], [CourseKey])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO
