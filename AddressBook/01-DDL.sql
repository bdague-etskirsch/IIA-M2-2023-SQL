--DDL : Data Definition Language
--CREATE, DROP, ALTER

SET NOCOUNT ON

USE [master]

GO
IF EXISTS (SELECT TOP(1) 1 FROM sys.databases AS t0 WHERE t0.name = 'AddressBook')
BEGIN
  --SINGLE_USER : On passe la base en mode mono-utilisateur (une seule session possible)
  --WITH ROLLBACK IMMEDIATE : Permet d'annuler les transactions incomplètes en cours
  --le mode mono-utilisateur déconnecte automatiquement les autres sessions
  ALTER DATABASE [AddressBook] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
  DROP DATABASE [AddressBook]
END

GO
CREATE DATABASE [AddressBook]
ON PRIMARY --Fichier de données
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
-> Chaînes ASCII (1 octet par caractère)
  CHAR(n) :    Taille fixe, ajout du caractère de bourage ' ' pour combler l'espace. n >= 1 && <= 8000
  VARCHAR(n) :  Taille variable, n>= 1 && <= 8000
  VARCHAR(MAX) :  Limité à 2Go. A éviter pour des raisons de performance.

-> Chaînes UNICODE (2 octets par caractère donc n >= 1 && <= 4000)
  NCHAR(n)
  NVARCHAR(n)
  NVARCHAR(MAX)

-> Valeur numériques exactes :
  TYNIINT :    Entier sur 1 octet
  SMALLINT :    Entier sur 2 octets
  INT :      Entier sur 4 octets
  BIGINT :    Entier sur 8 octets
  NUMERIC(p,s) :  Similaire à DECIMAL(p,s)
  DECIMAL(p,s) :  Décimal à vigule fixe ( de 5 à 17 octets)
          p désigne le nombre de chiffres total (entre 1 et 38, 18 par défaut)
          s désigne le nombre de décimales après la virgule (entre 0 et p)
  SMALLMONEY :  Décimal monétaire sur 4 octets
  MONEY :      Décimal monétaire sur 8 octets

  <!> Utilisez DECIMAL au lieu de SMALLMONEY et MONEY

-> Valeur numérique approximatives
  FLOAT :  Flotant de 4 à 8 octets
  REAL :  Flotant de 4 octets

  <!> provoques des erreurs d'arrondi dans les calculs (gestion sous forme de fraction).

-> Date et heure :
  DATE :        Date du 01/01/0001 au 31/12/9999 sur 3 octets
  DATETIME2(f) :    Date du 01/01/0001 au 31/12/9999 et heures (de 6 à 8 octets)
            f st le nombre de chiffres après la seconde (de 0 à 7, 7 par défaut)
  DATETIMEOFFSET :  Ajoute au DATETIME2(f) le fuseau horraire (10 octets)
  TIME(f) :      Heures sur 5 octets
            f st le nombre de chiffres après la seconde (de 0 à 7, 7 par défaut)

  <!> SMALLDATETIME et DATETIME non standardisé et commence au 01/01/1900

  <!> ROWVERSION anciennement TIMESTAMP n'a pas de signification temporelle pour SQL Server
    -> Utilié pour le vérouillage optimiste

-> Chaînes  binaires :
  BIT :        1 bit
  BINARY(n) :      données binaires de longueur fixe; n >= 1 && <= 8000
  VARBINARY(n) :    données binaires de longueur variable; n >= 1 && <= 8000
  VARBINARY(MAX) :  Limité à 2 Go. A éviter pour des raisons de performance

-> Autre type de données :
  HIERARCHYID :    Type système de longueur variable (type CLR).
            Représente une position dans une hiérarchie.
  UNIQUEIDENTIFIER :  GUID sur 16 octets
  ...

-> Types obsolètes :
  TEXT, NTEXT et IMAGE

*/

GO 
CREATE TABLE [AddressBook].[dbo].[City] --268 Octets par enregistrement  -> 84 octets
(
  --<COLUMN_NAME>  <TYPE>      [NULL|NOT NULL]  [IDENTITY]
  [Identifier]  INT      NOT NULL    IDENTITY --IDENTITY => incrément automatique  4 Octets
  ,[Name]      VARCHAR(50)  NOT NULL                                              --50 Octets 
  ,[ZipCode]    VARCHAR(30)  NOT NULL                                            -- 30 Octets
)
GO
CREATE TABLE [AddressBook].[dbo].[Civility] --98 Octets -> 49 Octets
(
  [Identifier]  INT      NOT NULL  IDENTITY  -- 4 Octets
  ,[ShortName]  VARCHAR(5)    NOT NULL          --5 Octets
  ,[Name]      VARCHAR(40)  NOT NULL            --40 Octets
)

GO
CREATE TABLE [AddressBook].[dbo].[Contact] --619 Octets -> 211 Octets
(
  [Identifier]      INT      NOT NULL  IDENTITY  --  4 Octets
  ,[IdentifierCivility]  INT      NULL            --  4 Octets
  ,[FirstName]      VARCHAR(50)  NULL              --50 Octets
  ,[LastName]        VARCHAR(50)  NOT NULL          --50 Octets
  ,[BirthDate]      DATE      NULL                  --  3 Octets
  ,[EMail]        VARCHAR(100)  NULL                --100 Octets
)

GO
CREATE TABLE [AddressBook].[dbo].[Address] --12546 Octets -> 678 Octets
(
  [Identifier]    INT      NOT NULL  IDENTITY      --   4 Octets
  ,[IdentifierCity]  INT      NOT NULL              --   4 Octets
  ,[StreetNumber]    VARCHAR(10)  NULL              --  10 Octets
  ,[RoadType]      VARCHAR(50)  NOT NULL            --  50 Octets
  ,[RoadName]      VARCHAR(200)  NULL              -- 200 Octets
  ,[Complement1]    VARCHAR(200)  NULL            -- 200 Octets
  ,[Complement2]    VARCHAR(200)  NULL            -- 200 Octets
  ,[Latitude]      DECIMAL(9,7)  NULL              --   5 Octets
  ,[Longitude]    DECIMAL(9,7)  NULL              --   5 Octets
)

GO
CREATE TABLE [AddressBook].[dbo].[AddressContact] --24 Octets -> 12 Octets
(
  [Identifier]      INT    NOT NULL  IDENTITY  --4 octets
  ,[IdentifierAddress]  INT    NOT NULL        --4 octets
  ,[IdentifierContact]  INT    NOT NULL        --4 octets
)

GO
ALTER TABLE [AddressBook].[dbo].[Address]
ADD
  --[Code] NVARCHAR(30) NULL --S'il existe des enregistrement, les nouveaux champs doivent être NULL
  --[Code] NVARCHAR(30) NOT NULL DEFAULT (N'0000')     
  [Code] VARCHAR(30) NOT NULL CONSTRAINT [DF_Address_Code] DEFAULT ('0000')

ALTER TABLE [AddressBook].[dbo].[City]
ADD
  [IsActive] BIT NOT NULL CONSTRAINT [DF_City_IsActive] DEFAULT (0)


GO
ALTER TABLE [AddressBook].[dbo].[Address] DROP CONSTRAINT [DF_Address_Code]


/*
Les contraintes ont pour but de programmer les règles de gestion au niveau des colonnes.
On peut les déclarer en même temps que la table (inline constraints).
Il est préférable de les déclarer séparément pur ne pas avoir à respecter un ordre de création des tables.

Chaque contrainte peut s'apliquer à une ou plusieurs colonnes (couple, triplets...)

  UNIQUE (UK) :    Impose une valeur distrinct pour chaque enregistrement. Les valeurs NULL sont autorisées.
  PRIMARY KEY (PK) :  Clé primaire de la table. Les valeurs ne peuvent être ni NULL ni identiques.
            Un index CLUSTURED est généré auomatiquement.
  FOREIGN KEY (FK) :  Clé étrangère, permet de maintenir l'intégrité référentielle.
            Attention, aucun index n'est généré automatiquement.
  DEFAULT (DF) :    Valeur par défaut.
  CHECK (CK) :    Impose un domaine de valeurs ou un condition entre colonnes
*/

--ALTER TABLE [AddressBook].[dbo].[City]
--ADD CONSTRAINT [PK_City_Identifier]
--PRIMARY KEY ( [Identifier] )


/*
DECLARE @Query NVARCHAR(MAX) = 'SELECT ''COUCOU'' ';

EXEC sp_executesql @Query


DECLARE
  query_cursor 
CURSOR FOR 
  SELECT
    CONCAT
    (
      'ALTER TABLE [AddressBook].[dbo].['
      , t0.name
      , '] ADD CONSTRAINT [PK_'
      , t0.name
      , '_'
      , t1.name
      , '] PRIMARY KEY (['
      , t1.name
      ,'])'
    )
  FROM
    sys.tables AS t0
  INNER JOINw
    sys.columns AS t1 ON t0.object_id = t1.object_id AND t1.name = 'Identifier'


OPEN query_cursor

FETCH NEXT FROM
  query_cursor
INTO
  @Query

WHILE @@FETCH_STATUS = 0  
BEGIN 

  PRINT @Query
  --EXEC sp_executesql @Query

  FETCH NEXT FROM
    query_cursor
  INTO
    @Query

END

*/

DECLARE @Query NVARCHAR(MAX)

SELECT
  @Query = STRING_AGG(t0.Query, CHAR(10) + CHAR(13))
FROM
(
  SELECT
    CONCAT
    (
      'ALTER TABLE [AddressBook].[dbo].['
      , t0.name
      , '] ADD CONSTRAINT [PK_'
      , t0.name
      , '_'
      , t1.name
      , '] PRIMARY KEY (['
      , t1.name
      ,'])'
    ) AS Query
  FROM
    sys.tables AS t0
  INNER JOIN
    sys.columns AS t1 ON t0.object_id = t1.object_id AND t1.name = 'Identifier'
) AS t0

EXEC sp_executesql @Query


--Il existe plusieurs manières de concaténer, la différence ce situe dans la gestion des valeurs NULL.
SELECT
  'MaVariable' + NULL          --NULL l'emporte sur la valeur avec +
  ,'MaVariable' + ISNULL(NULL, '')
  ,CONCAT('MaVariable', NULL)

SELECT 
  'MaVariable'  -- ASCII
  ,N'MaVariable'  -- UNICODE

--FK
/*
Intégrité référentielle

Actions à mener sur UPDATE | DELETE sur la/les colonne(s) référencée(s)
CASCADE :    Répercute sur les enregistrements liés.
SET NULL :    Donne pour valeur NULL aux lignes de la clef étrangère qui pointent sur l'enregistrement affecté.
        Possible seulement si la/les colonne(s) FK accepte(ent) le marqueur NULL.
SET DEFAULT :  Applique la valeur par défaut aux lignes de la clef étrangère qui pointent sur l'enregistrement affecté.
        Possible seulement si la/les colonne(s) FK ont une contrainte DEFAULT.
NO ACTION :    Déclenche une erreur si l'enregistrement est référencé par la clef étrangère. (comportement par défaut)

*/

--TODO : Générer les 4 FK pour les colonnes suivantes
SELECT
  t1.name                             AS TableName
  ,t0.name                            AS ColumnName
  ,RIGHT(t0.name, LEN(t0.name) - 10)  AS SourceTableName
FROM
  sys.Columns AS t0
INNER JOIN
  sys.tables AS t1 ON t0.object_id = t1.object_id
WHERE
  t0.name LIKE 'Identifier_%'


SELECT
  @Query = STRING_AGG(t0.Query, CHAR(13))
FROM
(
  SELECT
    CONCAT(N'ALTER TABLE [AddressBook].[dbo].[', t0.TableName, N']
    ADD CONSTRAINT [FK_', t0.TableName, N'_', t0.SourceTableName, N'_', t0.ColumnName, N'_Identifier]
      FOREIGN KEY ([', t0.ColumnName, N'])
      REFERENCES [AddressBook].[dbo].[', t0.SourceTableName, N'] ([Identifier])
      ON DELETE NO ACTION
      ON UPDATE NO ACTION') AS Query
  FROM
  (
    SELECT
      t1.name                             AS TableName
      ,t0.name                            AS ColumnName
      ,RIGHT(t0.name, LEN(t0.name) - 10)  AS SourceTableName
    FROM
      sys.Columns AS t0
    INNER JOIN
      sys.tables AS t1 ON t0.object_id = t1.object_id
    WHERE
      t0.name LIKE N'Identifier_%'
  ) AS t0
) AS t0

PRINT @Query
EXEC sp_executesql @Query;


/*
Index (IX)

CLUSTER :		Index qui détermine l'ordre du stockage des lignes dans les pages de données.
				Il ne peut exister qu'un seul index CLUSTER par table.

NONCLUSTURED :	Créer des fichiers d'indexation trié sur une ou plusieurs colonnes.
				Les pages de l'index pointent sur les pages de données.

Index implicite :
	-> Lors de la création d'une contrainte PRIMARY KEY (index CLUSTER)
	-> Lors de la création d'une contrainte UNIQUE (index NONCLUSTERED)

	UNIQUE :					Interdit les doublons
	CLUSTERED|NONCLUSTERED :	Détermine le type d'index
	ASC | DESC :				Détermine l'ordre du tri de l'index (ASC par défaut)
	WHERE :						Applique une restriction sur les lignes à indexer
	INCLUDE :					Permet d'inclure des données non inexées de la table à indexer.
								Permet d'éviter une double lecture (index + page de données).
								Plus le nombre de colonne élevé, plus l'index est compliqué à maintenir.
	DROP_EXISTING :				Permet de regénérer l'index s'il existait déjà (par défaut OFF).

	1000 index maximum par table (1 CLUSTURED + 999 NONCLUSTURED)
	Il est déconseillé d'avoir trop d'indexes.
*/

GO
CREATE NONCLUSTERED INDEX IX_City_ZipCode ON [AddressBook].[dbo].[City]
(
	[ZipCode]
)

GO
CREATE NONCLUSTERED INDEX  IX_City_Name ON [AddressBook].[dbo].[City]
(
	[Name]
)
INCLUDE
(
	[ZipCode]
)


DECLARE @Query NVARCHAR(MAX)

SELECT
  @Query = STRING_AGG(t0.Query, CHAR(13))
FROM
(
  SELECT
    CONCAT(N'CREATE NONCLUSTERED INDEX [IX_', t0.TableName, N'_', t0.ColumnName ,N'] ON [AddressBook].[dbo].[', t0.TableName ,N'] 
    (
      [', t0.ColumnName, N']
    )') AS Query
  FROM
  (
    SELECT
      t1.name                             AS TableName
      ,t0.name                            AS ColumnName
      ,RIGHT(t0.name, LEN(t0.name) - 10)  AS SourceTableName
    FROM
      sys.Columns AS t0
    INNER JOIN
      sys.tables AS t1 ON t0.object_id = t1.object_id
    WHERE
      t0.name LIKE N'Identifier_%'
  ) AS t0
) AS t0

PRINT @Query
EXEC sp_executesql @Query;


GO



--SELECT (ABS(CHECKSUM(NewId())) % 10) + 1 AS RandomNumber
--UNION ALL
--SELECT (ABS(CHECKSUM(NewId())) % 10) + 1 AS RandomNumber
--UNION ALL
--SELECT (ABS(CHECKSUM(NewId())) % 10) + 1 AS RandomNumber
--UNION ALL
--SELECT (ABS(CHECKSUM(NewId())) % 10) + 1 AS RandomNumber
--UNION ALL
--SELECT (ABS(CHECKSUM(NewId())) % 10) + 1 AS RandomNumber


DECLARE @value INT = 0;
CREATE TABLE Number (
	Value INT NOT NULL PRIMARY KEY
)

WHILE @value < 4000
BEGIN

	INSERT INTO Number ( Value ) SELECT @value

	SET @value = @value + 1;
END

GO

SELECT Value FROM Number WHERE Value < 1200

--Active ou désactive les statistiques de temps ou d'entrée / sortie
--SET STATISTICS IO (ON | OFF)
--SET STATISTICS TIME (ON | OFF)


DECLARE @ItemCount INT = 5;
DECLARE @CurrentIndex INT = 0;

CREATE TABLE #TempTable (
  RandomNumber INT NOT NULL
)

WHILE @ItemCount > @CurrentIndex
BEGIN

  INSERT INTO #TempTable ( RandomNumber ) VALUES ( (ABS(CHECKSUM(NewId())) % 10) + 1 )
  SET @CurrentIndex = @CurrentIndex + 1

END

SELECT RandomNumber FROM #TempTable

DROP TABLE #TempTable

GO

DECLARE @ItemCount INT = 5;
--SELECT TOP(@ItemCount) (ABS(CHECKSUM(NewId())) % 10) + 1  AS RandomNumber FROM sys.Columns
SELECT Value FROM Number WHERE Value < 1200
SELECT TOP(1200) Value FROM Number


SELECT
  (ABS(CHECKSUM(NewId())) % 10) + 1  AS RandomNumber
FROM
(
  SELECT
    ROW_NUMBER() OVER (ORDER BY t0.name) AS RowNum
  FROM
    sys.columns AS t0
) AS t0
WHERE
  t0.RowNum <= @ItemCount


  

/*
TODO : Générer un jeu de résultat avec 1200 lignes aléatoires :

| Name  |
|-------|
| Jean  | < Prénom choisi aléatoirement parmis une liste de 25 prénom prédéfinie
| Alain |
| ...   |

*/

IF OBJECT_ID('tempdb..#FirstName') IS NOT NULL BEGIN DROP TABLE #FirstName END

SELECT
	Name
	,ROW_NUMBER() OVER (ORDER BY Name) AS Identifier
INTO
	#FirstName
FROM
(
	SELECT N'A' AS Name UNION ALL
	SELECT N'B' AS Name UNION ALL
	SELECT N'C' AS Name UNION ALL
	SELECT N'D' AS Name UNION ALL
	SELECT N'E' AS Name UNION ALL
	SELECT N'F' AS Name UNION ALL
	SELECT N'G' AS Name UNION ALL
	SELECT N'H' AS Name UNION ALL
	SELECT N'I' AS Name UNION ALL
	SELECT N'J' AS Name
) AS t0

IF OBJECT_ID('tempdb..#LastName') IS NOT NULL BEGIN DROP TABLE #LastName END

SELECT
	Name
	,ROW_NUMBER() OVER (ORDER BY Name) AS Identifier
INTO
	#LastName
FROM
(
	SELECT N'AA' AS Name UNION ALL
	SELECT N'BB' AS Name UNION ALL
	SELECT N'CC' AS Name UNION ALL
	SELECT N'DD' AS Name UNION ALL
	SELECT N'EE' AS Name UNION ALL
	SELECT N'FF' AS Name UNION ALL
	SELECT N'GG' AS Name UNION ALL
	SELECT N'HH' AS Name UNION ALL
	SELECT N'II' AS Name UNION ALL
	SELECT N'JJ' AS Name
) AS t0

DECLARE @MaxFirstName INT;
DECLARE @MaxLastName INT;

SELECT @MaxFirstName = COUNT(Identifier) FROM #FirstName
SELECT @MaxLastName = COUNT(Identifier) FROM #LastName


IF OBJECT_ID('tempdb..#TempId') IS NOT NULL BEGIN DROP TABLE #TempId END

  SELECT
    t0.Value
    ,(ABS(CHECKSUM(NEWID())) % (@MaxFirstName)) + 1 AS FirstNameId
    ,(ABS(CHECKSUM(NEWID())) % (@MaxLastName)) + 1  AS LastNameId
    ,ABS(CHECKSUM(NEWID())) % (DATEDIFF(DAY, DATEFROMPARTS(1920, 1, 1), CAST(GETDATE() AS DATE))) AS RandDate
  INTO
    #TempId
  FROM
    Number AS t0
  WHERE
    t0.Value < 100

SELECT
  t1.Name   AS FirstName
  ,t2.Name  AS LastName
  ,DATEADD(DAY, t0.RandDate, DATEFROMPARTS(1920, 1, 1)) AS BirthDate
FROM
  #TempId AS t0
INNER JOIN
  #FirstName AS t1 ON t0.FirstNameId = t1.Identifier
INNER JOIN
  #LastName AS t2 ON t0.LastNameId = t2.Identifier
  
