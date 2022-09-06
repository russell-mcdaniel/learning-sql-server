CREATE TABLE [Curriculum].[Minor]
(
	[InstitutionKey]						uniqueidentifier		NOT NULL,
	[MinorKey]								uniqueidentifier		NOT NULL,
	[DisplayName]							nvarchar(40)			NOT NULL
);
GO

ALTER TABLE [Curriculum].[Minor]
	ADD CONSTRAINT [pk_Minor]
	PRIMARY KEY CLUSTERED ([InstitutionKey], [MinorKey])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

-- Enforce unique minor display names for each institution.
ALTER TABLE [Curriculum].[Minor]
	ADD CONSTRAINT [uk_Minor_InstitutionKeyDisplayName]
	UNIQUE ([InstitutionKey], [DisplayName])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

-- The foriegn key to the institution.
ALTER TABLE [Curriculum].[Minor]
	ADD CONSTRAINT [fk_Minor_InstitutionKey_Institution]
	FOREIGN KEY ([InstitutionKey])
	REFERENCES [Organization].[Institution] ([InstitutionKey]);
GO
