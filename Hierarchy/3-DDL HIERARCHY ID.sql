USE [Hierarchy]
GO

ALTER TABLE [Hierarchy].[dbo].[Resource]
ADD
	[Node]			HIERARCHYID NULL
	,[ManagerNode]	HIERARCHYID NULL

GO
CREATE NONCLUSTERED INDEX [IX_Resource_Node] ON [Hierarchy].[dbo].[Resource]
(
	Node
)

CREATE NONCLUSTERED INDEX [IX_Resource_ManagerNode] ON [Hierarchy].[dbo].[Resource]
(
	ManagerNode
)


;WITH Resources AS
(
	SELECT
		t0.Identifier
		,CAST( '/' + CAST(t0.Identifier AS NVARCHAR(4000)) + '/' AS HIERARCHYID)	AS Node 
		,CAST(NULL AS HIERARCHYID)													AS ManagerNode
	FROM
		Resource AS t0
	WHERE
		t0.IdentifierManager IS NULL
	UNION ALL
	SELECT
		t1.Identifier		
		,CAST(t0.Node.ToString() + CAST(t1.Identifier AS NVARCHAR(4000)) + '/' AS HIERARCHYID)	AS Node 
		,t0.Node		AS ManagerNode
	FROM
		Resources AS t0 --Noeud parent
	INNER JOIN
		Resource AS t1 ON t1.IdentifierManager = t0.Identifier		--Noeud enfant
)
UPDATE
	[Resource]
SET
	Node = t0.Node
	,ManagerNode = t0.ManagerNode
FROM
	Resources AS t0
WHERE
	[Resource].Identifier = t0.Identifier


