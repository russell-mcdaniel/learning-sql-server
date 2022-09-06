CREATE TABLE [Organization].[Department]
(
	[InstitutionKey]						uniqueidentifier		NOT NULL,
	[DepartmentKey]							uniqueidentifier		NOT NULL,
	[DisplayName]							nvarchar(40)			NOT NULL
);
GO

ALTER TABLE [Organization].[Department]
	ADD CONSTRAINT [pk_Department]
	PRIMARY KEY CLUSTERED ([InstitutionKey], [DepartmentKey])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

-- Enforce unique department display names for each institution.
ALTER TABLE [Organization].[Department]
	ADD CONSTRAINT [uk_Department_InstitutionKeyDisplayName]
	UNIQUE ([InstitutionKey], [DisplayName])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

-- The foriegn key to the institution.
ALTER TABLE [Organization].[Department]
	ADD CONSTRAINT [fk_Department_InstitutionKey_Institution]
	FOREIGN KEY ([InstitutionKey])
	REFERENCES [Organization].[Institution] ([InstitutionKey]);
GO
