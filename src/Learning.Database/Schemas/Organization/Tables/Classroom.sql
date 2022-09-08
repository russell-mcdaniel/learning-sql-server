--
-- Design Notes
--
-- The display name is derived from the building name, a random floor
-- quadrant letter, a random floor number, and a random room number.
--
-- Building Name:  SMI             First three characters of name.
-- Floor Number:   A|B|C|D 01-12   Quadrant letter plus 1-12.
-- Room Number:    100 - 990       10-99, but multiples of 10.
--
-- Example:        SMI-B12-870
--
CREATE TABLE [Organization].[Classroom]
(
	[InstitutionKey]						uniqueidentifier		NOT NULL,
	[CampusKey]								uniqueidentifier		NOT NULL,
	[BuildingKey]							uniqueidentifier		NOT NULL,
	[ClassroomKey]							uniqueidentifier		NOT NULL,
	[DisplayName]							nchar(11)				NOT NULL
);
GO

ALTER TABLE [Organization].[Classroom]
	ADD CONSTRAINT [pk_Classroom]
	PRIMARY KEY CLUSTERED ([InstitutionKey], [CampusKey], [BuildingKey], [ClassroomKey])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

-- Enforce unique classroom display names for each building.
ALTER TABLE [Organization].[Classroom]
	ADD CONSTRAINT [uk_Classroom_InstitutionKeyCampusKeyBuildingKeyDisplayName]
	UNIQUE ([InstitutionKey], [CampusKey], [BuildingKey], [DisplayName])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

-- The foreign key to the institution.
ALTER TABLE [Organization].[Classroom]
	ADD CONSTRAINT [fk_Classroom_InstitutionKey_Institution]
	FOREIGN KEY ([InstitutionKey])
	REFERENCES [Organization].[Institution] ([InstitutionKey]);
GO

-- The foreign key to the campus.
ALTER TABLE [Organization].[Classroom]
	ADD CONSTRAINT [fk_Classroom_InstitutionKeyCampusKey_Campus]
	FOREIGN KEY ([InstitutionKey], [CampusKey])
	REFERENCES [Organization].[Campus] ([InstitutionKey], [CampusKey]);
GO

-- The foreign key to the building.
ALTER TABLE [Organization].[Classroom]
	ADD CONSTRAINT [fk_Classroom_InstitutionKeyCampusKeyBuildingKey_Building]
	FOREIGN KEY ([InstitutionKey], [CampusKey], [BuildingKey])
	REFERENCES [Organization].[Building] ([InstitutionKey], [CampusKey], [BuildingKey]);
GO
