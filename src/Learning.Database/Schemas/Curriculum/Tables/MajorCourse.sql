CREATE TABLE [Curriculum].[MajorCourse]
(
	[InstitutionKey]						uniqueidentifier		NOT NULL,
	[MajorKey]								uniqueidentifier		NOT NULL,
	[DepartmentKey]							uniqueidentifier		NOT NULL,
	[CourseKey]								uniqueidentifier		NOT NULL
);
GO

-- The primary key supports finding courses by major.
ALTER TABLE [Curriculum].[MajorCourse]
	ADD CONSTRAINT [pk_MajorCourse]
	PRIMARY KEY CLUSTERED ([InstitutionKey], [MajorKey], [DepartmentKey], [CourseKey])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

-- The alternate key supports finding majors by course.
ALTER TABLE [Curriculum].[MajorCourse]
	ADD CONSTRAINT [uk_MajorCourse_InstitutionKeyDepartmentKeyCourseKeyMajorKey]
	UNIQUE ([InstitutionKey], [DepartmentKey], [CourseKey], [MajorKey])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

-- The foreign key to the institution.
ALTER TABLE [Curriculum].[MajorCourse]
	ADD CONSTRAINT [fk_MajorCourse_InstitutionKey_Institution]
	FOREIGN KEY ([InstitutionKey])
	REFERENCES [Organization].[Institution] ([InstitutionKey]);
GO

-- The foreign key to the major.
ALTER TABLE [Curriculum].[MajorCourse]
	ADD CONSTRAINT [fk_MajorCourse_InstitutionKeyMajorKey_Major]
	FOREIGN KEY ([InstitutionKey], [MajorKey])
	REFERENCES [Curriculum].[Major] ([InstitutionKey], [MajorKey]);
GO

-- The foreign key to the department.
ALTER TABLE [Curriculum].[MajorCourse]
	ADD CONSTRAINT [fk_MajorCourse_InstitutionKeyDepartmentKey_Department]
	FOREIGN KEY ([InstitutionKey], [DepartmentKey])
	REFERENCES [Organization].[Department] ([InstitutionKey], [DepartmentKey]);
GO

-- The foreign key to the course.
ALTER TABLE [Curriculum].[MajorCourse]
	ADD CONSTRAINT [fk_MajorCourse_InstitutionKeyDepartmentKeyCourseKey]
	FOREIGN KEY ([InstitutionKey], [DepartmentKey], [CourseKey])
	REFERENCES [Curriculum].[Course] ([InstitutionKey], [DepartmentKey], [CourseKey]);
GO

-- Supports the foreign key to the department.
CREATE NONCLUSTERED INDEX [ix_MajorCourse_InstitutionKeyDepartmentKey]
	ON [Curriculum].[MajorCourse] ([InstitutionKey], [DepartmentKey])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

-- Supports the foreign key to the course.
CREATE NONCLUSTERED INDEX [ix_MajorCourse_InstitutionKeyDepartmentKeyCourseKey]
	ON [Curriculum].[MajorCourse] ([InstitutionKey], [DepartmentKey], [CourseKey])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO
