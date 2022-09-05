CREATE TABLE [Organization].[Classroom]
(
	[InstitutionKey]						uniqueidentifier		NOT NULL,
	[CampusKey]								uniqueidentifier		NOT NULL,
	[BuildingKey]							uniqueidentifier		NOT NULL,
	[ClassroomKey]							uniqueidentifier		NOT NULL,
	[FloorNumber]							tinyint					NOT NULL,
	[RoomNumber]							smallint				NOT NULL,
	[DisplayName]							AS (CONVERT([nchar](8),((N'F'+right(N'00'+CONVERT([nvarchar](2),[FloorNumber]),(2)))+N'-R')+right(N'000'+CONVERT([nvarchar](3),[RoomNumber]),(3))))
												PERSISTED			NOT NULL	-- Example: "F02-R125"
);
GO

ALTER TABLE [Organization].[Classroom]
	ADD CONSTRAINT [pk_Classroom]
	PRIMARY KEY CLUSTERED ([InstitutionKey], [CampusKey], [BuildingKey], [ClassroomKey])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

-- Enforce unique floor number and room number combinations for each building.
ALTER TABLE [Organization].[Classroom]
	ADD CONSTRAINT [uk_Classroom_InstitutionKeyCampusKeyBuildingKeyFloorNumberRoomNumber]
	UNIQUE ([InstitutionKey], [CampusKey], [BuildingKey], [ClassroomKey], [FloorNumber], [RoomNumber])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

-- Enforce unique display names for each building. This should be inherent because the
-- value is derived from the floor number and room number, but this constraint ensures
-- data integrity in the event that the computed column expression has a bug.
ALTER TABLE [Organization].[Classroom]
	ADD CONSTRAINT [uk_Classroom_InstitutionKeyCampusKeyBuildingKeyDisplayName]
	UNIQUE ([InstitutionKey], [CampusKey], [BuildingKey], [ClassroomKey], [DisplayName])
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

-- The floor number must be between 1 and 99.
ALTER TABLE [Organization].[Classroom]
	ADD CONSTRAINT [ck_Classroom_FloorNumber]
	CHECK ([FloorNumber]>(0) AND [FloorNumber]<(100));
GO

-- The room number must be between 1 and 999.
ALTER TABLE [Organization].[Classroom]
	ADD CONSTRAINT [ck_Classroom_RoomNumber]
	CHECK ([RoomNumber]>(0) AND [RoomNumber]<(1000));
GO
