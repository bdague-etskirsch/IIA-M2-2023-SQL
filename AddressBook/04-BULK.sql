CREATE TABLE #RowData
(
	[FirstName]		NVARCHAR(4000)	NULL
	,[LastName]		NVARCHAR(4000)	NULL
	,[BirthDate]	DATETIME2(7)	NULL
	,[EMail]		NVARCHAR(4000)	NULL
	,[Civility]		NVARCHAR(4000)	NULL
)

BULK INSERT
	#RowData
FROM
	'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\Data.csv'
WITH
(
	FIELDTERMINATOR = ';'
	,ROWTERMINATOR = '\n'
	,FIRSTROW = 2
	,CODEPAGE = 65001
)
GO

SELECT * FROM #RowData


ALTER TABLE #RowData ADD
	Identifier BIGINT IDENTITY(1,1) NOT NULL
	,IdentifierCivility BIGINT NULL
GO

UPDATE
	#RowData
SET
	IdentifierCivility = t0.IdentifierCivility
FROM
(
	SELECT
		t0.Identifier
		,t1.Identifier AS IdentifierCivility
	FROM
		#RowData AS t0
	LEFT JOIN
		Civility AS t1 ON t0.Civility = t1.Name
) AS t0
WHERE
	t0.Identifier = #RowData.Identifier

UPDATE
	Contact
SET
	FirstName = t0.FirstName
	,LastName = t0.LastName
	,BirthDate = t0.BirthDate
	,IdentifierCivility = t0.IdentifierCivility
FROM
(
	SELECT
		t1.Identifier
		,t0.FirstName
		,t0.LastName
		,t0.BirthDate
		,t0.IdentifierCivility
	FROM
		#RowData AS t0
	INNER JOIN
		Contact AS t1 ON t0.EMail = t1.EMail
) AS t0
WHERE
	Contact.Identifier = t0.Identifier


INSERT INTO
	dbo.Contact
(
	FirstName
	,LastName
	,BirthDate
	,EMail
	,IdentifierCivility
)
SELECT
	t0.FirstName
	,t0.LastName
	,t0.BirthDate
	,t0.EMail
	,t0.IdentifierCivility
FROM
	#RowData AS t0
LEFT JOIN
	Contact AS t1 ON t0.EMail = t1.EMail
WHERE
	t1.Identifier IS NULL

 SELECT * FROM Contact

DROP TABLE #RowData