CREATE TABLE [Organization].[Institution]
(
	[InstitutionKey]						uniqueidentifier		NOT NULL,
	[DisplayName]							nvarchar(40)			NOT NULL,
	[LocationName]							nvarchar(40)			NOT NULL
);
GO

ALTER TABLE [Organization].[Institution]
	ADD CONSTRAINT [pk_Institution]
	PRIMARY KEY CLUSTERED ([InstitutionKey])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

-- Enforce unique institution display names.
ALTER TABLE [Organization].[Institution]
	ADD CONSTRAINT [uk_Institution_DisplayName]
	UNIQUE ([DisplayName])
	WITH (FILLFACTOR = 100)
	ON [PRIMARY];
GO
