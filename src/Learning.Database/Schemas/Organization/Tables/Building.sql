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
