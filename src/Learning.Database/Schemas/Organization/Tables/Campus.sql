CREATE TABLE [Organization].[Campus]
(
	[InstitutionKey]						uniqueidentifier		NOT NULL,
	[CampusKey]								uniqueidentifier		NOT NULL,
	[DisplayName]							nvarchar(40)			NOT NULL,
	[LocationName]							nvarchar(40)			NOT NULL
);
GO

ALTER TABLE [Organization].[Campus]
	ADD CONSTRAINT [pk_Campus]
	PRIMARY KEY CLUSTERED ([InstitutionKey], [CampusKey])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

-- Enforce unique campus display names for each institution.
ALTER TABLE [Organization].[Campus]
	ADD CONSTRAINT [uk_Campus_InstitutionKeyDisplayName]
	UNIQUE ([InstitutionKey], [DisplayName])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

-- The foreign key to the institution.
ALTER TABLE [Organization].[Campus]
	ADD CONSTRAINT [fk_Campus_InstitutionKey_Institution]
	FOREIGN KEY ([InstitutionKey])
	REFERENCES [Organization].[Institution] ([InstitutionKey]);
GO
