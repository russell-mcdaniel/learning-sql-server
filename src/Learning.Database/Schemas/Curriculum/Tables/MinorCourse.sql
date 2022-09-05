CREATE TABLE [Curriculum].[MinorCourse]
(
	[InstitutionKey]						uniqueidentifier		NOT NULL,
	[MinorKey]								uniqueidentifier		NOT NULL,
	[DepartmentKey]							uniqueidentifier		NOT NULL,
	[CourseKey]								uniqueidentifier		NOT NULL
);
GO

-- The primary key supports finding courses by minor.
ALTER TABLE [Curriculum].[MinorCourse]
	ADD CONSTRAINT [pk_MinorCourse]
	PRIMARY KEY CLUSTERED ([InstitutionKey], [MinorKey], [DepartmentKey], [CourseKey])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

-- The alternate key supports finding minors by course.
ALTER TABLE [Curriculum].[MinorCourse]
	ADD CONSTRAINT [uk_MinorCourse_InstitutionKeyDepartmentKeyCourseKeyMinorKey]
	UNIQUE ([InstitutionKey], [DepartmentKey], [CourseKey], [MinorKey])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

-- The foreign key to the institution.
ALTER TABLE [Curriculum].[MinorCourse]
	ADD CONSTRAINT [fk_MinorCourse_InstitutionKey_Institution]
	FOREIGN KEY ([InstitutionKey])
	REFERENCES [Organization].[Institution] ([InstitutionKey]);
GO

-- The foreign key to the minor.
ALTER TABLE [Curriculum].[MinorCourse]
	ADD CONSTRAINT [fk_MinorCourse_InstitutionKeyMinorKey_Minor]
	FOREIGN KEY ([InstitutionKey], [MinorKey])
	REFERENCES [Curriculum].[Minor] ([InstitutionKey], [MinorKey]);
GO

-- The foreign key to the department.
ALTER TABLE [Curriculum].[MinorCourse]
	ADD CONSTRAINT [fk_MinorCourse_InstitutionKeyDepartmentKey_Department]
	FOREIGN KEY ([InstitutionKey], [DepartmentKey])
	REFERENCES [Organization].[Department] ([InstitutionKey], [DepartmentKey]);
GO

-- The foreign key to the course.
ALTER TABLE [Curriculum].[MinorCourse]
	ADD CONSTRAINT [fk_MinorCourse_InstitutionKeyDepartmentKeyCourseKey]
	FOREIGN KEY ([InstitutionKey], [DepartmentKey], [CourseKey])
	REFERENCES [Curriculum].[Course] ([InstitutionKey], [DepartmentKey], [CourseKey]);
GO

-- Supports the foreign key to the department.
CREATE NONCLUSTERED INDEX [ix_MinorCourse_InstitutionKeyDepartmentKey]
	ON [Curriculum].[MinorCourse] ([InstitutionKey], [DepartmentKey])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

-- Supports the foreign key to the course.
CREATE NONCLUSTERED INDEX [ix_MinorCourse_InstitutionKeyDepartmentKeyCourseKey]
	ON [Curriculum].[MinorCourse] ([InstitutionKey], [DepartmentKey], [CourseKey])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO
