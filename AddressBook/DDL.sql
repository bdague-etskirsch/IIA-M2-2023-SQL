--DDL : Data Definition Language
--CREATE, DROP, ALTER

USE [master]

GO
IF EXISTS (SELECT TOP(1) 1 FROM sys.databases AS t0 WHERE t0.name = 'AddressBook')
BEGIN
	--SINGLE_USER : On passe la base en mode mono-utilisateur (une seule session possible)
	--WITH ROLLBACK IMMEDIATE : Permet d'annuler les transactions incompl�tes en cours
	--le mode mono-utilisateur d�connecte automatiquement les autres sessions
	ALTER DATABASE [AddressBook] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
  DROP DATABASE [AddressBook]
END

GO
CREATE DATABASE [AddressBook]
ON PRIMARY --Fichier de donn�es
(
	NAME = AddressBook_dat --Nom logique du fichier
	,FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\AddressBook_dat.mdf' --Chemin physique
	,SIZE = 64MB --Taille initiale
	,FILEGROWTH = 64MB --Taille d'agrandissement lorsque la taille max est atteinte
	,MAXSIZE = UNLIMITED --Taille maximum
)
LOG ON --Fichier journal
(
	NAME = AddressBook_log
	,FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\AddressBook_log.ldf' --Chemin physique
	,SIZE = 512MB --Taille initiale
	,FILEGROWTH = 128MB --Taille d'agrandissement lorsque la taille max est atteinte
	,MAXSIZE = UNLIMITED --Taille maximum
)

GO
USE [AddressBook]

SELECT IIF('A' != N'A', 1, 0)

/*
-> Cha�nes ASCII (1 octet par caract�re)
	CHAR(n) :		Taille fixe, ajout du caract�re de bourage ' ' pour combler l'espace. n >= 1 && <= 8000
	VARCHAR(n) :	Taille variable, n>= 1 && <= 8000
	VARCHAR(MAX) :	Limit� � 2Go. A �viter pour des raisons de performance.

-> Cha�nes UNICODE (2 octets par caract�re donc n >= 1 && <= 4000)
	NCHAR(n)
	NVARCHAR(n)
	NVARCHAR(MAX)

-> Valeur num�riques exactes :
	TYNIINT :		Entier sur 1 octet
	SMALLINT :		Entier sur 2 octets
	INT :			Entier sur 4 octets
	BIGINT :		Entier sur 8 octets
	NUMERIC(p,s) :	Similaire � DECIMAL(p,s)
	DECIMAL(p,s) :	D�cimal � vigule fixe ( de 5 � 17 octets)
					p d�signe le nombre de chiffres total (entre 1 et 38, 18 par d�faut)
					s d�signe le nombre de d�cimales apr�s la virgule (entre 0 et p)
	SMALLMONEY :	D�cimal mon�taire sur 4 octets
	MONEY :			D�cimal mon�taire sur 8 octets

	<!> Utilisez DECIMAL au lieu de SMALLMONEY et MONEY

-> Valeur num�rique approximatives
	FLOAT :	Flotant de 4 � 8 octets
	REAL :	Flotant de 4 octets

	<!> provoques des erreurs d'arrondi dans les calculs (gestion sous forme de fraction).

-> Date et heure :
	DATE :				Date du 01/01/0001 au 31/12/9999 sur 3 octets
	DATETIME2(f) :		Date du 01/01/0001 au 31/12/9999 et heures (de 6 � 8 octets)
						f st le nombre de chiffres apr�s la seconde (de 0 � 7, 7 par d�faut)
	DATETIMEOFFSET :	Ajoute au DATETIME2(f) le fuseau horraire (10 octets)
	TIME(f) :			Heures sur 5 octets
						f st le nombre de chiffres apr�s la seconde (de 0 � 7, 7 par d�faut)

	<!> SMALLDATETIME et DATETIME non standardis� et commence au 01/01/1900

	<!> ROWVERSION anciennement TIMESTAMP n'a pas de signification temporelle pour SQL Server
		-> Utili� pour le v�rouillage optimiste

-> Cha�nes  binaires :
	BIT :				1 bit
	BINARY(n) :			donn�es binaires de longueur fixe; n >= 1 && <= 8000
	VARBINARY(n) :		donn�es binaires de longueur variable; n >= 1 && <= 8000
	VARBINARY(MAX) :	Limit� � 2 Go. A �viter pour des raisons de performance

-> Autre type de donn�es :
	HIERARCHYID :		Type syst�me de longueur variable (type CLR).
						Repr�sente une position dans une hi�rarchie.
	UNIQUEIDENTIFIER :	GUID sur 16 octets
	...

-> Types obsol�tes :
	TEXT, NTEXT et IMAGE

*/

GO 
CREATE TABLE [AddressBook].[dbo].[City] --268 Octets par enregistrement  -> 84 octets
(
	--<COLUMN_NAME>	<TYPE>			[NULL|NOT NULL]	[IDENTITY]
	[Identifier]	INT			NOT NULL		IDENTITY --IDENTITY => incr�ment automatique  4 Octets
	,[Name]			VARCHAR(50)	NOT NULL                                              --50 Octets 
	,[ZipCode]		VARCHAR(30)	NOT NULL                                            -- 30 Octets
)
GO
CREATE TABLE [AddressBook].[dbo].[Civility] --98 Octets -> 49 Octets
(
	[Identifier]	INT			NOT NULL	IDENTITY  -- 4 Octets
	,[ShortName]	VARCHAR(5)		NOT NULL          --5 Octets
	,[Name]			VARCHAR(40)	NOT NULL            --40 Octets
)

GO
CREATE TABLE [AddressBook].[dbo].[Contact] --619 Octets -> 211 Octets
(
	[Identifier]			INT			NOT NULL	IDENTITY  --  4 Octets
	,[IdentifierCivility]	INT			NULL            --  4 Octets
	,[FirstName]			VARCHAR(50)	NULL              --50 Octets
	,[LastName]				VARCHAR(50)	NOT NULL          --50 Octets
	,[BirthDate]			DATE			NULL                  --  3 Octets
	,[EMail]				VARCHAR(100)	NULL                --100 Octets
)

GO
CREATE TABLE [AddressBook].[dbo].[Address] --12546 Octets -> 678 Octets
(
	[Identifier]		INT			NOT NULL	IDENTITY      --   4 Octets
	,[IdentifierCity]	INT			NOT NULL              --   4 Octets
	,[StreetNumber]		VARCHAR(10)	NULL              --  10 Octets
	,[RoadType]			VARCHAR(50)	NOT NULL            --  50 Octets
	,[RoadName]			VARCHAR(200)	NULL              -- 200 Octets
	,[Complement1]		VARCHAR(200)	NULL            -- 200 Octets
	,[Complement2]		VARCHAR(200)	NULL            -- 200 Octets
	,[Latitude]			DECIMAL(9,7)	NULL              --   5 Octets
	,[Longitude]		DECIMAL(9,7)	NULL              --   5 Octets
)

GO
CREATE TABLE [AddressBook].[dbo].[AddressContact] --24 Octets -> 12 Octets
(
	[Identifier]			INT		NOT NULL	IDENTITY  --4 octets
	,[IdentifierAddress]	INT		NOT NULL        --4 octets
	,[IdentifierContact]	INT		NOT NULL        --4 octets
)

GO
ALTER TABLE [AddressBook].[dbo].[Address]
ADD
	--[Code] NVARCHAR(30) NULL --S'il existe des enregistrement, les nouveaux champs doivent �tre NULL
	--[Code] NVARCHAR(30) NOT NULL DEFAULT (N'0000')     
	[Code] VARCHAR(30) NOT NULL CONSTRAINT [DF_Address_Code] DEFAULT ('0000')

ALTER TABLE [AddressBook].[dbo].[City]
ADD
	[IsActive] BIT NOT NULL CONSTRAINT [DF_City_IsActive] DEFAULT (0)


GO
ALTER TABLE [AddressBook].[dbo].[Address] DROP CONSTRAINT [DF_Address_Code]


/*
Les contraintes ont pour but de programmer les r�gles de gestion au niveau des colonnes.
On peut les d�clarer en m�me temps que la table (inline constraints).
Il est pr�f�rable de les d�clarer s�par�ment pur ne pas avoir � respecter un ordre de cr�ation des tables.

Chaque contrainte peut s'apliquer � une ou plusieurs colonnes (couple, triplets...)

	UNIQUE (UK) :		Impose une valeur distrinct pour chaque enregistrement. Les valeurs NULL sont autoris�es.
	PRIMARY KEY (PK) :	Cl� primaire de la table. Les valeurs ne peuvent �tre ni NULL ni identiques.
						Un index CLUSTURED est g�n�r� auomatiquement.
	FOREIGN KEY (FK) :	Cl� �trang�re, permet de maintenir l'int�grit� r�f�rentielle.
						Attention, aucun index n'est g�n�r� automatiquement.
	DEFAULT (DF) :		Valeur par d�faut.
	CHECK (CK) :		Impose un domaine de valeurs ou un condition entre colonnes
*/

--ALTER TABLE [AddressBook].[dbo].[City]
--ADD CONSTRAINT [PK_City_Identifier]
--PRIMARY KEY ( [Identifier] )

DECLARE @Query NVARCHAR(MAX) = 'SELECT ''COUCOU'' ';

EXEC sp_executesql @Query

SELECT
  *
FROM
  sys.tables AS t0