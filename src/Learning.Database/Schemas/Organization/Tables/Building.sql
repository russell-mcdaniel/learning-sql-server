CREATE TABLE [Organization].[Building]
(
	[InstitutionKey]						uniqueidentifier		NOT NULL,
	[CampusKey]								uniqueidentifier		NOT NULL,
	[BuildingKey]							uniqueidentifier		NOT NULL,
	[DisplayName]							nvarchar(30)			NOT NULL
);
GO

ALTER TABLE [Organization].[Building]
	ADD CONSTRAINT [pk_Building]
	PRIMARY KEY CLUSTERED ([InstitutionKey], [CampusKey], [BuildingKey])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

-- Enforce unique building display names for each campus.
ALTER TABLE [Organization].[Building]
	ADD CONSTRAINT [uk_Building_InstitutionKeyCampusKeyDisplayName]
	UNIQUE ([InstitutionKey], [CampusKey], [DisplayName])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

-- The foreign key to the institution.
ALTER TABLE [Organization].[Building]
	ADD CONSTRAINT [fk_Building_InstitutionKey_Institution]
	FOREIGN KEY ([InstitutionKey])
	REFERENCES [Organization].[Institution] ([InstitutionKey]);
GO

-- The foreign key to the campus.
ALTER TABLE [Organization].[Building]
	ADD CONSTRAINT [fk_Building_InstitutionKeyCampusKey_Campus]
	FOREIGN KEY ([InstitutionKey], [CampusKey])
	REFERENCES [Organization].[Campus] ([InstitutionKey], [CampusKey]);
GO
