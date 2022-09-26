CREATE TABLE [Tree].[AlCategory]
(
	[Id]									int						NOT NULL,
	[Name]									nvarchar(20)			NOT NULL,
	[ParentId]								int						NULL
);
GO

ALTER TABLE [Tree].[AlCategory]
	ADD CONSTRAINT [pk_AlCategory]
	PRIMARY KEY CLUSTERED ([Id]);
GO

ALTER TABLE [Tree].[AlCategory]
	ADD CONSTRAINT [fk_AlCategoryParentId_AlCategory]
	FOREIGN KEY ([ParentId])
	REFERENCES [Tree].[AlCategory] ([Id]);
GO

ALTER TABLE [Tree].[AlCategory]
	ADD CONSTRAINT [ck_AlCategory_IdParentId]
	CHECK ([Id]<>[ParentId]);
GO

CREATE NONCLUSTERED INDEX [ix_AlCategory_ParentId]
	ON [Tree].[AlCategory] ([ParentId])
	INCLUDE ([Name]);
GO
