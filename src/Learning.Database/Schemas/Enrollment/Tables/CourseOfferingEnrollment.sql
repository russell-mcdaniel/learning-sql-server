CREATE TABLE [Enrollment].[CourseOfferingEnrollment]
(
	[InstitutionKey]						uniqueidentifier		NOT NULL,
	[CourseOfferingKey]						uniqueidentifier		NOT NULL,
	[StudentKey]							uniqueidentifier		NOT NULL,
	[Score]									tinyint					NULL
);
GO

ALTER TABLE [Enrollment].[CourseOfferingEnrollment]
	ADD CONSTRAINT [pk_CourseOfferingEnrollment]
	PRIMARY KEY CLUSTERED ([InstitutionKey], [CourseOfferingKey], [StudentKey])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

-- The foreign key to the institution.
ALTER TABLE [Enrollment].[CourseOfferingEnrollment]
	ADD CONSTRAINT [fk_CourseOfferingEnrollment_InstitutionKey_Institution]
	FOREIGN KEY ([InstitutionKey])
	REFERENCES [Organization].[Institution] ([InstitutionKey]);
GO

-- The foreign key to the course offering.
ALTER TABLE [Enrollment].[CourseOfferingEnrollment]
	ADD CONSTRAINT [fk_CourseOfferingEnrollment_InstitutionKeyCourseOfferingKey_CourseOffering]
	FOREIGN KEY ([InstitutionKey], [CourseOfferingKey])
	REFERENCES [Enrollment].[CourseOffering] ([InstitutionKey], [CourseOfferingKey]);
GO

-- The foreign key to the student.
ALTER TABLE [Enrollment].[CourseOfferingEnrollment]
	ADD CONSTRAINT [fk_CourseOfferingEnrollment_InstitutionKeyStudentKey_Student]
	FOREIGN KEY ([InstitutionKey], [StudentKey])
	REFERENCES [Enrollment].[Student] ([InstitutionKey], [StudentKey]);
GO

-- The score must be between 0 and 100.
ALTER TABLE [Enrollment].[CourseOfferingEnrollment]
	ADD CONSTRAINT [ck_CourseOfferingEnrollment_Score]
	CHECK ([Score]>=(0) AND [Score]<=(100));
GO

-- Supports the foreign key to the student.
CREATE NONCLUSTERED INDEX [ix_CourseOfferingEnrollment_InstitutionKeyStudentKey]
	ON [Enrollment].[CourseOfferingEnrollment] ([InstitutionKey], [StudentKey])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO
