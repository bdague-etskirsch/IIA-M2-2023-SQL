/***
	DML : Data Manipulation Language
***/

USE [AddressBook]
GO

DELETE FROM AddressContact
DELETE FROM Address
DELETE FROM Contact
DELETE FROM Civility
DELETE FROM City

--INSERT
GO

--Désactive l'auto incrément pour les colonnes IDENTITY d'une table
--Une seule table par session peut avoir la propriété IDENTITY_INSERT à ON
SET IDENTITY_INSERT [AddressBook].[dbo].[City] ON


INSERT INTO [AddressBook].[dbo].[City]
(
	Identifier
	,Name
	,Zipcode
	,IsActive
)
VALUES
	(	1,	N'PARIS',		N'75001',	1)
	,(	2,	N'PARIS',		N'75002',	1)
	,(	3,	N'PARIS',		N'75003',	1)
	,(	4,	N'PARIS',		N'75004',	1)
	,(	5,	N'PARIS',		N'75005',	1)
	,(	6,	N'PARIS',		N'75006',	1)
	,(	7,	N'PARIS',		N'75007',	1)
	,(	8,	N'PARIS',		N'75008',	1)
	,(	9,	N'PARIS',		N'75009',	1)
	,(	10,	N'PARIS',		N'75010',	1)
	,(	11,	N'LAVAL',		N'53000',	1)
	,(	12,	N'ANGERS',		N'49000',	1)
	,(	13,	N'ANGERS',		N'49100',	1)
	,(	14,	N'SEGRÉ',		N'49500',	1)
	,(	15,	N'NYOISEAU',	N'49500',	1);

--Pour réactiver l'auto incrément
SET IDENTITY_INSERT [AddressBook].[dbo].[City] OFF

GO
SET IDENTITY_INSERT [AddressBook].[dbo].[Civility] ON

INSERT INTO [AddressBook].[dbo].[Civility]
(
	[Identifier]
	,[ShortName]
	,[Name]
)
VALUES
	(1,		N'M.',		N'Monsieur')
	,(2,	N'Mme.',	N'Madame')
	,(3,	N'Autre',	N'Autre');


SET IDENTITY_INSERT [AddressBook].[dbo].[Civility] OFF


GO
SET IDENTITY_INSERT [AddressBook].[dbo].[Contact] ON

INSERT INTO [AddressBook].[dbo].[Contact]
(
	[Identifier]
	,[FirstName]
	,[LastName]
	,[BirthDate]
	,[EMail]
	,[IdentifierCivility]
)
VALUES
	(1,		N'Benjamin',	N'DAGUÉ',	DATEFROMPARTS(1987, 12, 24),	N'benjamin.dague@etskirsch.fr',		1)
	,(2,	N'Guillaume',	N'KIRSCH',	'01/03/1980',	N'guillaume.kirsch@etskirsch.fr',	1)
	,(3,	N'Jean',		N'DUPONT',	'05/06/1990',	NULL,								1)
	,(4,	N'Lucie',		N'DURAND',	'30/08/2000',	NULL,								2)
	,(5,	N'Grégory',		N'DURAND',	'07/07/1999',	NULL,								1)
	,(6,	N'Antoine',		N'TOTO',	'04/06/1985',	NULL,								1)
	,(7,	NULL,			N'TOTO',	'04/06/1995',	NULL,								NULL)
	,(8,	N'Camille',		N'TOTO',	'07/11/1997',	NULL,								2)
	,(9,	N'Paul',		N'DUPOND',	'24/03/1993',	NULL,								1)
	,(10,	N'Marion',		N'TUTU',	'24/03/1993',	NULL,								2)
	,(11,	N'Marc',		N'DUPOND',	'10/10/1985',	NULL,								1)
	,(12,	N'Marie',		N'DUPOND',	'10/10/1985',	NULL,								2)
	,(13,	N'Patrice',		N'LOULOU',	NULL,			NULL,								1)
	,(14,	N'Ludivine',	N'LOULOU',	NULL,			NULL,								2);

SET IDENTITY_INSERT [AddressBook].[dbo].[Contact] OFF

GO
SET IDENTITY_INSERT [AddressBook].[dbo].[Address] ON
INSERT INTO [AddressBook].[dbo].[Address]
(
	[Identifier]
	,[Code]
	,[StreetNumber]
	,[RoadType]
	,[RoadName]
	,[IdentifierCity]
)
VALUES
	(1,		N'',	N'20',		N'RUE',			N'D''ARGENTREUIL',			1)
	,(2,	N'',	N'15',		N'RUE',			N'BACHAUMONT',				2)
	,(3,	N'',	N'2BIS',	N'RUE',			N'VIVIENNE',				2)
	,(4,	N'',	N'113',		N'BOULEVARD',	N'JEAN MOULIN',				12)
	,(5,	N'',	N'114',		N'BOULEVARD',	N'JEAN MOULIN',				12)
	,(6,	N'',	N'2',		N'AVENUE',		N'DES ACACIAS',				14)
	,(7,	N'',	N'7',		N'AVENUE',		N'DES ACACIAS',				14)
	,(8,	N'',	N'9',		N'AVENUE',		N'DU GÉNÉRAL D''ANDIGNÉ',	14)
	,(9,	N'',	N'52',		N'RUE',			N'GENEVIÈVE VERGER',		15)
	,(10,	N'',	N'30',		N'RUE',			N'GENEVIÈVE VERGER',		15)
	,(11,	N'',	N'10',		N'RUE',			N'DE PARIS',				11)
	,(12,	N'',	N'1',		N'AVENUE',		N'DE L''OPÉRA',				1)
	,(13,	N'',	N'2',		N'AVENUE',		N'DE L''OPÉRA',				1)
	,(14,	N'',	N'3',		N'AVENUE',		N'DE L''OPÉRA',				1);

SET IDENTITY_INSERT [AddressBook].[dbo].[Address] OFF

INSERT INTO City
(
	Name
	,ZipCode
)
VALUES
('RENNES', '35000')
,('ANGERS', '49000')

/*

Pour récupérer la dernière valeur IDENTITY générée :

IDENT_CURRENT :		Pour un table spécifiée, dans toutes les sessions et pour tous les scopes.
@@IDENTITY :		Pour toutes les tables, dans la session en cours et dans tous les scopes.
SCOPE_IDENTITY :	Pour toutes les tables, dans la session en cours dans le scope en cours.

*/

SELECT
	@@IDENTITY
	,SCOPE_IDENTITY()
	,IDENT_CURRENT('[AddressBook].[dbo].[City]')

GO
--CREATE TABLE

--SELECT .. INTO créé une table temp (dans la base TempDB) à partir d'un résultat de requête
--Les colonnes et les types de données de la table sont déduis à partir de la projection de la requête
--Ici, TOP(0) permet de ne copier aucun enregistrement dans la table temp (on fait une copie de la structure uniquement)
--SELECT TOP(0) * INTO #AddressContact FROM AddressContact

--Une table temp commence par #, elle est accessible uniquemenet dans la connexion en cours. Détruit à la fermeture de la connexion.
--Une table temp globale commence par ##, elle est accessible par l'ensemble des connexions. Détruit au redémarage du serveur.

CREATE TABLE #AddressContact
(
	[Identifier]			BIGINT		NOT NULL
	,[IdentifierAddress]	BIGINT		NOT NULL
	,[IdentifierContact]	BIGINT		NOT NULL
)


--Lors d'une opération d'INSERT ou d'UPDATE, il est possible de récupérer les identifiants, ou autres colonnes calculées avec OUTPUT INTO
INSERT INTO [AddressBook].[dbo].[AddressContact]
(
	[IdentifierAddress]
	,[IdentifierContact]
)
OUTPUT
	inserted.Identifier
	,inserted.IdentifierAddress
	,inserted.IdentifierContact
INTO
	#AddressContact
VALUES
	(1,		1)
	,(1,	2)	
	,(3,	3)
	,(3,	4)
	,(3,	5)
	,(4,	6)
	,(5,	7)
	,(6,	8)
	,(9,	9)
	,(10,	10)
	,(11,	11);
	
SELECT * FROM #AddressContact

DROP TABLE #AddressContact
GO


CREATE TABLE #TempTable (
	Identifier BIGINT
	,ZipCode NVARCHAR(10)
)


INSERT INTO City
(
	Name
	,ZipCode
)
OUTPUT
	inserted.Identifier
	,inserted.ZipCode
INTO
	#TempTable
VALUES
('CHÊNEHUTTE', '49350')
,('BORDEAUX', '33000')


SELECT * FROM #TempTable

DROP TABLE #TempTable

UPDATE
	[AddressBook].[dbo].[City]
SET
	[Name] = LOWER(Name)

UPDATE
	[AddressBook].[dbo].[City]
SET
	[Name] = UPPER(Name)
WHERE
	[Name] = 'PaRiS' --Case Insensitive : CF classement

	
--Il est possible de modifier le classement utilisée pour une requête.
--Par exemple, on utilise un classement non sensible aux accents (AI => Accent Insensitive)
SELECT * FROM Contact WHERE (LastName COLLATE Latin1_General_CS_AI) LIKE ('%E%' COLLATE Latin1_General_CS_AI) --éè


SELECT IIF('     ' = '', 1, 0)

SET STATISTICS TIME ON

--Sélectionner l'identifiant, le nom, le prénom et l'âge des contacts
