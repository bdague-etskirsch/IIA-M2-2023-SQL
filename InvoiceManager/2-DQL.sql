USE InvoiceManager
GO

--Requête 1.A :
SELECT
	t0.DateDay
	,t0.DateMonth
	,t0.DateYear
	,t0.DateQuarter
	,t0.DateWeek
	,AVG(t1.TotalPrice) AS TotalAverage
	,SUM(t1.TotalPrice) AS TotalSum
FROM
	Invoice AS t0
INNER JOIN
	InvoiceLine AS t1 ON t0.Id = t1.InvoiceId
GROUP BY GROUPING SETS
(
	(t0.DateDay, t0.DateMonth, t0.DateYear, t0.DateQuarter, t0.DateWeek)
	,(t0.DateMonth, t0.DateYear)
	,(t0.DateYear)
	,(t0.DateQuarter, t0.DateYear)
	,(t0.DateWeek, t0.DateYear)
	,()
)


--Requête 1.B :

SELECT
	t0.DateDay
	,t0.DateMonth
	,t0.DateYear
	,t0.DateQuarter
	,t0.DateWeek
	,AVG(t1.TotalPrice) OVER (PARTITION BY t0.DateDay, t0.DateMonth, t0.DateYear, t0.DateQuarter, t0.DateWeek)	AS TotalAveragePerDay
	,AVG(t1.TotalPrice) OVER (PARTITION BY t0.DateMonth, t0.DateYear)											AS TotalAveragePerMonth
	,AVG(t1.TotalPrice) OVER (PARTITION BY t0.DateYear)															AS TotalAveragePerYear
	,AVG(t1.TotalPrice) OVER (PARTITION BY t0.DateQuarter, t0.DateYear)											AS TotalAveragePerQuarter
	,AVG(t1.TotalPrice) OVER (PARTITION BY t0.DateWeek, t0.DateYear)											AS TotalAveragePerWeek
	,AVG(t1.TotalPrice) OVER ()																					AS TotalAverage
	,SUM(t1.TotalPrice) OVER (PARTITION BY t0.DateDay, t0.DateMonth, t0.DateYear, t0.DateQuarter, t0.DateWeek)	AS TotalSumPerDay
	,SUM(t1.TotalPrice) OVER (PARTITION BY t0.DateMonth, t0.DateYear)											AS TotalSumPerMonth
	,SUM(t1.TotalPrice) OVER (PARTITION BY t0.DateYear)															AS TotalSumPerYear
	,SUM(t1.TotalPrice) OVER (PARTITION BY t0.DateQuarter, t0.DateYear)											AS TotalSumPerQuarter
	,SUM(t1.TotalPrice) OVER (PARTITION BY t0.DateWeek, t0.DateYear)											AS TotalSumPerWeek
	,SUM(t1.TotalPrice) OVER ()																					AS TotalSum
FROM
	Invoice AS t0
INNER JOIN
	InvoiceLine AS t1 ON t0.Id = t1.InvoiceId

--Requête 2 :

GO
DECLARE @StartDate DATE = DATEFROMPARTS(2018,6,1);
DECLARE @EndDate DATE = DATEFROMPARTS(2019,5,1);
SET @StartDate = DATEFROMPARTS(DATEPART(YEAR, @StartDate), DATEPART(MONTH, @StartDate), 1);
SET @EndDate = DATEFROMPARTS(DATEPART(YEAR, @EndDate), DATEPART(MONTH, @EndDate), 1);

DECLARE @MonthCount INT = DATEDIFF(MONTH, @StartDate, @EndDate) + 1;

SELECT DISTINCT
	t1.DateYear
	,t1.DateMonth
	,SUM(ISNULL(t2.TotalPrice, 0)) OVER (PARTITION BY t1.DateYear, t1.DateMonth) 			AS TotalSumMonth
	,AVG(ISNULL(t2.TotalPrice, 0)) OVER (PARTITION BY t1.DateYear, t1.DateMonth) 			AS TotalAverageMonth
	,SUM(ISNULL(t2.TotalPrice, 0)) OVER (ORDER BY t1.DateYear, t1.DateMonth) 	  			AS TotalSumCumulated
	,SUM(ISNULL(t2.TotalPrice, 0)) OVER (PARTITION BY t1.DateYear ORDER BY t1.DateMonth)	AS TotalSumCumulatedPerYear
FROM
(
	SELECT
		DATEPART(YEAR, DATEADD(MONTH, t0.Id,  @StartDate))		AS DateYear
		,DATEPART(MONTH, DATEADD(MONTH, t0.Id,  @StartDate))	AS DateMonth
	FROM
		Numbers AS t0
	WHERE
		t0.Id < @MonthCount
) AS t0
LEFT JOIN
	Invoice AS t1 ON t0.DateYear = t1.DateYear AND t0.DateMonth = t1.DateMonth
LEFT JOIN
	InvoiceLine AS t2 ON t1.Id = t2.InvoiceId
ORDER BY
	t1.DateYear
	,t1.DateMonth


--Requête 3 :

GO
DECLARE @Mode INT = 1 -- 1 mois / 2 année / 3 trimestre
DECLARE @StartDate DATE = DATEFROMPARTS(2018,6,1);
DECLARE @EndDate DATE = DATEFROMPARTS(2019,5,1);
SET @StartDate = DATEFROMPARTS(DATEPART(YEAR, @StartDate), DATEPART(MONTH, @StartDate), 1);
SET @EndDate = DATEFROMPARTS(DATEPART(YEAR, @EndDate), DATEPART(MONTH, @EndDate), 1);


