--
-- Design Notes
--
-- It is not strictly necessary to provide a surrogate key, but it makes it
-- easier to reference specific instances of this entity from other entities.
--
-- Is the Term or the CourseOffering the primary? Which direction will
-- lookups go most frequently? Course by term? Term by course?
--
CREATE TABLE [Enrollment].[CourseOffering]
(
	[InstitutionKey]						uniqueidentifier		NOT NULL,
	[CourseOfferingKey]						uniqueidentifier		NOT NULL,
	[DepartmentKey]							uniqueidentifier		NOT NULL,
	[CourseKey]								uniqueidentifier		NOT NULL,
	[ProfessorKey]							uniqueidentifier		NOT NULL,
	[CampusKey]								uniqueidentifier		NOT NULL,
	[BuildingKey]							uniqueidentifier		NOT NULL,
	[ClassroomKey]							uniqueidentifier		NOT NULL,
	[TermKey]								uniqueidentifier		NOT NULL
);
GO

ALTER TABLE [Enrollment].[CourseOffering]
	ADD CONSTRAINT [pk_CourseOffering]
	PRIMARY KEY CLUSTERED ([InstitutionKey], [CourseOfferingKey])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

ALTER TABLE [Enrollment].[CourseOffering]
	ADD CONSTRAINT [uk_CourseOffering_InstitutionKeyDepartmentKeyCourseKeyTermKey]
	UNIQUE ([InstitutionKey], [DepartmentKey], [CourseKey], [TermKey])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

-- The foreign key to the institution.
ALTER TABLE [Enrollment].[CourseOffering]
	ADD CONSTRAINT [fk_CourseOffering_InstitutionKey_Institution]
	FOREIGN KEY ([InstitutionKey])
	REFERENCES [Organization].[Institution] ([InstitutionKey]);
GO

-- The foreign key to the department.
ALTER TABLE [Enrollment].[CourseOffering]
	ADD CONSTRAINT [fk_CourseOffering_InstitutionKeyDepartmentKey_Department]
	FOREIGN KEY ([InstitutionKey], [DepartmentKey])
	REFERENCES [Organization].[Department] ([InstitutionKey], [DepartmentKey]);
GO

-- The foreign key to the professor.
ALTER TABLE [Enrollment].[CourseOffering]
	ADD CONSTRAINT [fk_CourseOffering_InstitutionKeyDepartmentKeyProfessorKey_Professor]
	FOREIGN KEY ([InstitutionKey], [DepartmentKey], [ProfessorKey])
	REFERENCES [Organization].[Professor] ([InstitutionKey], [DepartmentKey], [ProfessorKey]);
GO

-- The foreign key to the course.
ALTER TABLE [Enrollment].[CourseOffering]
	ADD CONSTRAINT [fk_CourseOffering_InstitutionKeyDepartmentKeyCourseKey_Course]
	FOREIGN KEY ([InstitutionKey], [DepartmentKey], [CourseKey])
	REFERENCES [Curriculum].[Course] ([InstitutionKey], [DepartmentKey], [CourseKey]);
GO

-- The foreign key to the term.
ALTER TABLE [Enrollment].[CourseOffering]
	ADD CONSTRAINT [fk_CourseOffering_InstitutionKeyTermKey_Term]
	FOREIGN KEY ([InstitutionKey], [TermKey])
	REFERENCES [Enrollment].[Term] ([InstitutionKey], [TermKey]);
GO

-- Supports the foreign key to the department.
CREATE NONCLUSTERED INDEX [ix_CourseOffering_InstitutionKeyDepartmentKey]
	ON [Enrollment].[CourseOffering] ([InstitutionKey], [DepartmentKey])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

-- Supports the foreign key to the professor.
CREATE NONCLUSTERED INDEX [ix_CourseOffering_InstitutionKeyDepartmentKeyProfessorKey]
	ON [Enrollment].[CourseOffering] ([InstitutionKey], [DepartmentKey], [ProfessorKey])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

-- Supports the foreign key to the course.
CREATE NONCLUSTERED INDEX [ix_CourseOffering_InstitutionKeyDepartmentKeyCourseKey]
	ON [Enrollment].[CourseOffering] ([InstitutionKey], [DepartmentKey], [CourseKey])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

-- Supports the foreign key to the term.
CREATE NONCLUSTERED INDEX [ix_CourseOffering_InstitutionKeyTermKey]
	ON [Enrollment].[CourseOffering] ([InstitutionKey], [TermKey])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO
