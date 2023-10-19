USE [master];

GO 

IF EXISTS (SELECT 1 FROM sys.Databases WHERE name = 'Hierarchy')
BEGIN

	USE [Master];

	ALTER DATABASE [Hierarchy] SET
		SINGLE_USER WITH ROLLBACK IMMEDIATE;

	DROP DATABASE [Hierarchy];

END

GO
CREATE DATABASE [Hierarchy]

GO
USE [Hierarchy]


GO
CREATE TABLE [Hierarchy].[dbo].[Resource]
(
	[Identifier]			BIGINT			NOT NULL IDENTITY
	,[IdentifierManager]	BIGINT			NULL
	,[Code]					NVARCHAR(200)	NOT NULL
	,[Age]					BIGINT			NOT NULL
)

GO
ALTER TABLE [Hierarchy].[dbo].[Resource]
ADD CONSTRAINT [PK_Resource_Identifier] 
	PRIMARY KEY ([Identifier])

GO
ALTER TABLE [Hierarchy].[dbo].[Resource]
	ADD CONSTRAINT [FK_Resource_Resource_IdentifierManager_Identifier]
	FOREIGN KEY ([IdentifierManager])
	REFERENCES [Hierarchy].[dbo].[Resource] (Identifier)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION

GO
CREATE NONCLUSTERED INDEX IX_Resource_IdentifierManager ON Resource
(
	IdentifierManager
)


GO
SET IDENTITY_INSERT [Hierarchy].[dbo].[Resource] ON

GO
INSERT INTO [Hierarchy].[dbo].[Resource]
(
	Identifier
	,IdentifierManager
	,Code
	,Age
)
VALUES
(	1,	NULL,	'AAA',	48)
,(	2,	NULL,	'AAB',	38)
,(	3,	1,		'BBA',	25)
,(	4,	1,		'BBB',	27)
,(	5,	1,		'BBC',	35)
,(	6,	1,		'BBD',	32)
,(	7,	1,		'BBE',	28)
,(	8,	2,		'BBF',	25)
,(	9,	2,		'BBG',	27)
,(	10,	2,		'BBH',	35)
,(	11,	4,		'CCA',	25)
,(	12,	5,		'CCB',	33)
,(	13,	5,		'CCC',	22)
,(	14,	6,		'CCD',	32)
,(	15,	6,		'CCE',	21)
,(	16,	6,		'CCF',	35)
,(	17,	7,		'CCG',	44)
,(	18,	7,		'CCH',	36)
,(	19,	7,		'CCI',	55)
,(	20,	7,		'CCJ',	32)

GO
SET IDENTITY_INSERT [Hierarchy].[dbo].[Resource] OFF

GO


