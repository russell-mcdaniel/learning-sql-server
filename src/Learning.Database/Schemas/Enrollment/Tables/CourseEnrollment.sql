--
-- Design Notes
--
-- Is it necessary to have foreign keys to all individual members of the compound key?
--
CREATE TABLE [Enrollment].[CourseEnrollment]
(
	[InstitutionKey]						uniqueidentifier		NOT NULL,
	[CourseOfferingKey]						uniqueidentifier		NOT NULL,
	[StudentKey]							uniqueidentifier		NOT NULL
);
GO

ALTER TABLE [Enrollment].[CourseEnrollment]
	ADD CONSTRAINT [pk_CourseEnrollment]
	PRIMARY KEY CLUSTERED ([InstitutionKey], [CourseOfferingKey], [StudentKey])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

-- The foreign key to the institution.
ALTER TABLE [Enrollment].[CourseEnrollment]
	ADD CONSTRAINT [fk_CourseEnrollment_InstitutionKey_Institution]
	FOREIGN KEY ([InstitutionKey])
	REFERENCES [Organization].[Institution] ([InstitutionKey]);
GO

-- The foreign key to the course offering.
ALTER TABLE [Enrollment].[CourseEnrollment]
	ADD CONSTRAINT [fk_CourseEnrollment_InstitutionKeyCourseOfferingKey_CourseOffering]
	FOREIGN KEY ([InstitutionKey], [CourseOfferingKey])
	REFERENCES [Enrollment].[CourseOffering] ([InstitutionKey], [CourseOfferingKey]);
GO

-- The foreign key to the student.
ALTER TABLE [Enrollment].[CourseEnrollment]
	ADD CONSTRAINT [fk_CourseEnrollment_InstitutionKeyStudentKey_Student]
	FOREIGN KEY ([InstitutionKey], [StudentKey])
	REFERENCES [Enrollment].[Student] ([InstitutionKey], [StudentKey]);
GO

-- Supports the foreign key to the student.
CREATE NONCLUSTERED INDEX [ix_CourseEnrollment_InstitutionKeyStudentKey]
	ON [Enrollment].[CourseEnrollment] ([InstitutionKey], [StudentKey])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO
