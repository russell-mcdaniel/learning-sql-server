CREATE TABLE [Organization].[Institution]
(
	[InstitutionKey]						uniqueidentifier		NOT NULL,
	[DisplayName]							nvarchar(30)			NOT NULL,
	[LocationName]							nvarchar(30)			NOT NULL,
	[TermSystemKey]							uniqueidentifier		NOT NULL
);
GO

ALTER TABLE [Organization].[Institution]
	ADD CONSTRAINT [pk_Institution]
	PRIMARY KEY CLUSTERED ([InstitutionKey])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO

ALTER TABLE [Organization].[Institution]
	ADD CONSTRAINT [uk_Institution_DisplayName]
	UNIQUE ([DisplayName])
	WITH (FILLFACTOR = 100)
	ON [PRIMARY];
GO

ALTER TABLE [Organization].[Institution]
	ADD CONSTRAINT [fk_Institution_TermSystemKey_TermSystem]
	FOREIGN KEY ([TermSystemKey])
	REFERENCES [Core].[TermSystem] ([TermSystemKey]);
GO

-- Supports foreign key.
CREATE NONCLUSTERED INDEX [ix_Institution_TermSystemKey]
	ON [Organization].[Institution] ([TermSystemKey])
	WITH (FILLFACTOR = 90)
	ON [PRIMARY];
GO
