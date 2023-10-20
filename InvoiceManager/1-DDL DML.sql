USE [master]
GO

SET NOCOUNT ON

IF EXISTS (SELECT TOP(1) 1 FROM sys.databases WHERE Name = 'InvoiceManager')
BEGIN
	ALTER DATABASE [InvoiceManager] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
	DROP DATABASE [InvoiceManager]
END

CREATE DATABASE [InvoiceManager]

GO
USE [InvoiceManager]

PRINT 'Création du schéma.'

GO
CREATE TABLE Invoice
(
	[Id]	        INT     NOT NULL IDENTITY
	,[Date]         DATE	NOT NULL
	,[DateDay]      AS (CAST( DATEPART(DAY, [Date]) AS INT)) PERSISTED
	,[DateMonth]    AS (CAST( DATEPART(MONTH, [Date]) AS INT)) PERSISTED
	,[DateYear]     AS (CAST( DATEPART(YEAR, [Date]) AS INT)) PERSISTED
	,[DateQuarter]  AS (CAST( DATEPART(QUARTER, [Date]) AS INT)) PERSISTED
    ,[DateWeek]     AS (CAST( DATEPART(ISO_WEEK, [Date]) AS INT)) PERSISTED
	,CONSTRAINT [PK_Invoice] PRIMARY KEY ([Id])
)

GO
CREATE TABLE InvoiceLine
(
	[Id]	     INT    NOT NULL IDENTITY
	,[InvoiceId] INT	NOT NULL
	,[Price]		    DECIMAL(5,2)	NOT NULL
	,[Quantity]		    DECIMAL(5,2)	NOT NULL
	,[TotalPrice]		AS (CAST([Price] * [Quantity] AS DECIMAL(9,2))) PERSISTED
	,CONSTRAINT [PK_InvoiceLine] PRIMARY KEY ([Id])
    ,CONSTRAINT [FK_InvoiceLine_Invoice] FOREIGN KEY ([InvoiceId]) REFERENCES [dbo].[InvoiceLine] ([Id]),
)

GO
CREATE NONCLUSTERED INDEX [IX_InvoiceLine_InvoiceId] ON [dbo].[InvoiceLine]
(
    [InvoiceId] ASC
)
INCLUDE
(
    [TotalPrice]
);

GO
CREATE TABLE Numbers
(
	[Id] INT    NOT NULL
	,CONSTRAINT [PK_Numbers] PRIMARY KEY ([Id])
)

GO
PRINT 'Remplissage de Numbers'

INSERT INTO
    Numbers
SELECT 0 UNION ALL SELECT 1

DECLARE @i INT = 1

WHILE @i < 20
BEGIN

    INSERT INTO
        Numbers
    SELECT
        t0.Id + POWER(2, @i)
    FROM
        Numbers AS t0

    SET @i = @i + 1

END

GO
PRINT 'On calcul la date de début et la date de fin de la plage de date ainsi que le nombre de jours entre les deux dates.'

DECLARE @EndDate DATE = GETDATE();
DECLARE @StartDate DATE = DATEADD(MONTH, -72, @EndDate);
DECLARE @DayCount INT = DATEDIFF(DAY, @StartDate, @EndDate);


PRINT 'On génère 300000 lignes de facture avec une date aléatoire comprise entre @StartDate et @EndDate.'

INSERT INTO
    Invoice
SELECT
    DATEADD(DAY, t0.RandNumber, @StartDate)
FROM
(
    SELECT
        (ABS(CHECKSUM(NEWID())) % (@DayCount + 1)) AS RandNumber
    FROM
        Numbers AS t0
    WHERE
        t0.Id <= 300000
) AS t0


PRINT 'Pour chaque facture, on calcul le nombre de ligne à insérer (de 1 à 5 lignes).'

SELECT
    t0.Id
    ,t0.Date
    ,(ABS(CHECKSUM(NEWID())) % 5) + 1 AS LineCount
INTO
    #TempInvoices
FROM
    Invoice AS t0

PRINT 'On génère ensuite les lignes à l''aide d''une jointure sur Numbers.'

INSERT INTO
    InvoiceLine
SELECT
    t0.Id AS InvoiceId
    ,((ABS(CHECKSUM(NEWID())) % 1999) + 100) / 100.00 AS UnitPrice
    ,((ABS(CHECKSUM(NEWID())) % 4999) + 100) / 100.00 AS Quantity
FROM
    #TempInvoices AS t0
INNER JOIN
    Numbers AS t1 ON t1.Id <= t0.LineCount


DROP TABLE #TempInvoices
