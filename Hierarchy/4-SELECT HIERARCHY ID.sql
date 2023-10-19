SELECT
	*
	,Node.ToString()
	,ManagerNode.ToString()
	,Node.GetLevel()
FROM
	Resource

SELECT
	parent.Identifier
	,AVG(enfant.Age)	AS MoyenneAge
FROM
	Resource AS parent
INNER JOIN
	Resource AS enfant ON enfant.Node.IsDescendantOf(parent.Node) = 1
GROUP BY
	parent.Identifier

-----------------------------------------------------------------------------------------
