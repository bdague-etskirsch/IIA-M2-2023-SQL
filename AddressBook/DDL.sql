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
CREATE TABLE [AddressBook].[dbo].[City] 
(
	--<COLUMN_NAME>	<TYPE>			[NULL|NOT NULL]	[IDENTITY]
	[Identifier]	BIGINT			NOT NULL		IDENTITY --IDENTITY => incr�ment automatique
	,[Name]			NVARCHAR(100)	NOT NULL
	,[ZipCode]		NVARCHAR(30)	NOT NULL
)
GO
CREATE TABLE [AddressBook].[dbo].[Civility] 
(
	[Identifier]	BIGINT			NOT NULL	IDENTITY
	,[ShortName]	NVARCHAR(5)		NOT NULL
	,[Name]			NVARCHAR(40)	NOT NULL
)

GO
CREATE TABLE [AddressBook].[dbo].[Contact] 
(
	[Identifier]			BIGINT			NOT NULL	IDENTITY
	,[IdentifierCivility]	BIGINT			NULL
	,[FirstName]			NVARCHAR(100)	NULL
	,[LastName]				NVARCHAR(100)	NOT NULL
	,[BirthDate]			DATE			NULL
	,[EMail]				NVARCHAR(100)	NULL
)

GO
CREATE TABLE [AddressBook].[dbo].[Address] 
(
	[Identifier]		BIGINT			NOT NULL	IDENTITY
	,[IdentifierCity]	BIGINT			NOT NULL
	,[StreetNumber]		NVARCHAR(10)	NULL
	,[RoadType]			NVARCHAR(50)	NOT NULL
	,[RoadName]			NVARCHAR(4000)	NULL
	,[Complement1]		NVARCHAR(2000)	NULL
	,[Complement2]		NVARCHAR(200)	NULL
	,[Latitude]			DECIMAL(7,5)	NULL
	,[Longitude]		DECIMAL(7,5)	NULL
)

GO
CREATE TABLE [AddressBook].[dbo].[AddressContact] 
(
	[Identifier]			BIGINT		NOT NULL	IDENTITY
	,[IdentifierAddress]	BIGINT		NOT NULL
	,[IdentifierContact]	BIGINT		NOT NULL
)



