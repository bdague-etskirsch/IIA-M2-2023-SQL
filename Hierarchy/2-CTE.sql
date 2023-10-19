WITH Resources AS
(
	--on commence par sélectionner les noeuds racindes de l'arbre
	SELECT
		t0.Identifier
		,t0.Code
		,CAST(NULL AS NVARCHAR(4000))				AS CumulatedCode
		,CAST(t0.Identifier AS NVARCHAR(4000))+ '/'	AS CumulatedIdentifier
		,t0.IdentifierManager
		,t0.Age
	FROM
		Resource AS t0
	WHERE
		t0.IdentifierManager IS NULL
	
	UNION ALL
	
	SELECT
		t1.Identifier
		,t1.Code
		,CONCAT(t0.CumulatedCode + ' -> ', t0.Code)	AS CumulatedCode
		,CONCAT(t0.CumulatedIdentifier, CAST(t1.Identifier AS NVARCHAR(4000)), '/')	AS CumulatedIdentifier
		,t1.IdentifierManager
		,t1.Age
	FROM
		Resources AS t0
	INNER JOIN
		Resource AS t1 ON t1.IdentifierManager = t0.Identifier
)
SELECT
	t0.Identifier
	,t0.CumulatedIdentifier
	,AVG(t1.Age)
FROM
	Resources AS t0
INNER JOIN
	Resources AS t1 ON t1.CumulatedIdentifier LIKE t0.CumulatedIdentifier + '%' 
GROUP BY
	t0.Identifier
	,t0.CumulatedIdentifier
ORDER BY
	t0.CumulatedIdentifier


-----------------------------------------------------------------------------------------
