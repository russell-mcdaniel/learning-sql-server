CREATE TABLE [Curriculum].[Major]
(
	[InstitutionKey]						uniqueidentifier		NOT NULL,
	[MajorKey]								uniqueidentifier		NOT NULL,
	[DisplayName]							nvarchar(40)			NOT NULL
);
GO

ALTER TABLE [Curriculum].[Major]
	ADD CONSTRAINT [pk_Major]
	PRIMARY KEY CLUSTERED ([InstitutionKey], [MajorKey])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

-- Enforce unique major display names for each institution.
ALTER TABLE [Curriculum].[Major]
	ADD CONSTRAINT [uk_Major_InstitutionKeyDisplayName]
	UNIQUE ([InstitutionKey], [DisplayName])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

-- The foriegn key to the institution.
ALTER TABLE [Curriculum].[Major]
	ADD CONSTRAINT [fk_Major_InstitutionKey_Institution]
	FOREIGN KEY ([InstitutionKey])
	REFERENCES [Organization].[Institution] ([InstitutionKey]);
GO
