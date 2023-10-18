--Data Query Language

--Retourner l'ensemble des villes avec le nom et le code postal
SELECT
	t0.Name		AS [Nom ville]
	,t0.ZipCode	AS [Code postal]
FROM 
	City AS t0

--Retourner l'ensemble des villes avec le nom et le code postal 
--limité aux 2 premier résultats : TOP(n)
SELECT TOP(2)
	t0.Name		AS [Nom ville]
	,t0.ZipCode	AS [Code postal]
FROM 
	City AS t0

--Retourner l'ensemble des noms des villes sans doublon : DISTINCT
SELECT DISTINCT
	t0.Name		AS [Nom ville]
FROM 
	City AS t0

SELECT
	t0.Name		AS [Nom ville]
FROM 
	City AS t0
GROUP BY
	t0.Name

--Retourner l'ensemble des noms des villes sans doublon ordonnés par nom
SELECT DISTINCT
	t0.Name		AS [Nom ville]
FROM 
	City AS t0
ORDER BY
	[Nom ville] ASC --ASC (par défaut) | DESC

--Avec ORDER BY, il est possible d'utiliser les alias de la projection.
--Ceci est lié à l'ordre d'exécution des mots clefs :
-- FROM -> JOIN -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY


--Sélectionner la ville avec l'identifiant 11
SELECT 
	t0.Name		AS [Nom ville]
FROM 
	City AS t0
WHERE
	t0.Identifier = 11

--Sélectionner les villes qui n'ont pas l'identifiant 11
SELECT 
	t0.Name		AS [Nom ville]
FROM 
	City AS t0
WHERE
	t0.Identifier <> 11
	--t0.Identifier != 11
	--NOT t0.Identifier = 11

--Sélectionner les villes qui ont un identifiant inférieur ou égale à 4
SELECT 
	t0.Name		AS [Nom ville]
FROM 
	City AS t0
WHERE
	t0.Identifier <= 4

--Sélectionner les contacts qui ont une date de naissance comprise
--entre 01/01/1990 et 31/12/1999
SELECT
	*
FROM
	Contact AS t0
WHERE 
	t0.Birthdate BETWEEN DATEFROMPARTS(1990,01,01) AND DATEFROMPARTS(1999,12,31)
	--t0.Birthdate BETWEEN '1990-01-01' AND '31/12/1999'
	--t0.Birthdate >= DATEFROMPARTS(1990,01,01) AND t0.Birthdate <= '31/12/1999'

--Sélectionner les contacts qui n'ont pas une date de naissance comprise
--entre 01/01/1990 et 31/12/1999
SELECT
	*
FROM
	Contact AS t0
WHERE 
	t0.Birthdate NOT BETWEEN DATEFROMPARTS(1990,01,01) AND DATEFROMPARTS(1999,12,31)
	--t0.Birthdate < DATEFROMPARTS(1990,01,01) OR t0.Birthdate > '31/12/1999'


--Sélectionner les villes qui...
--commencent par LAV
SELECT * FROM City AS t0 WHERE t0.Name LIKE 'LAV%'
SELECT * FROM City AS t0 WHERE CHARINDEX('LAV', t0.Name) = 1
SELECT * FROM City AS t0 WHERE LEFT(t0.Name, 3) = 'LAV'
--terminent par VAL
SELECT * FROM City AS t0 WHERE t0.Name LIKE '%VAL'
SELECT * FROM City AS t0 WHERE RIGHT(t0.Name, 3) = 'VAL'
--contiennent AVA
SELECT * FROM City AS t0 WHERE t0.Name LIKE '%AVA%'
--contiennent au moins 2 A
SELECT * FROM City AS t0 WHERE t0.Name LIKE '%A%A%'
--terminent par A suivi d'un unique caractère
SELECT * FROM City AS t0 WHERE t0.Name LIKE '%A_'
--commencent par un caractère compris entre a et l
SELECT * FROM City AS t0 WHERE t0.Name LIKE '[a-l]%'
--ne commencent pas par un caractère compris entre a et l
SELECT * FROM City AS t0 WHERE t0.Name NOT LIKE '[a-l]%'
SELECT * FROM City AS t0 WHERE t0.Name LIKE '[^a-l]%'


--Attention LIKE '%...' sont des requêtes qui n'utilisent pas les indexes

SELECT
	CAST(t0.Char AS INT)
FROM
(
	SELECT '6' AS Char UNION ALL
	SELECT '.' AS Char --Attention, ISNUMERIC(..) retourne 1 pour '.' ou ','
) AS t0
WHERE
	ISNUMERIC(t0.Char) = 1 -- On ne consèrve que les numéros

	

--Nombre de code postaux différents
SELECT
	COUNT(DISTINCT t0.ZipCode)
FROM 
	City AS t0

SELECT
	COUNT(t0.ZipCode)
FROM 
(
	SELECT DISTINCT
		t0.ZipCode
	FROM 
		City AS t0
) AS t0


--Nombre de code postaux par nom de ville
SELECT
	t0.Name
	,COUNT(t0.ZipCode)
FROM 
	City AS t0
GROUP BY 
	t0.Name

SELECT DISTINCT
	t0.Name
	,COUNT(t0.ZipCode) OVER (PARTITION BY t0.Name)
FROM 
	City AS t0

--  SELECT
--    t0.Name
--    ,t2.Count
--    ,t0.Count 
--    ,t1.Count
--  FROM
--  (
--    SELECT t0.Name ,COUNT(t0.ZipCode) AS Count FROM  City AS t0 GROUP BY t0.Name
--  ) AS t0
--  INNER JOIN
--  (
--    SELECT LEFT(t0.Name, 1) AS FirstLetter ,COUNT(t0.ZipCode) AS Count FROM  City AS t0 GROUP BY t0.Name
--  ) AS t1 ON LEFT(t0.Name, 1) = t1.FirstLetter
--  CROSS JOIN
--  ( SELECT COUNT(t0.Identifier) AS Count FROM  City AS t0 ) AS t2

--SELECT DISTINCT
--	t0.Name
--	,COUNT(t0.ZipCode) OVER ()
--	,COUNT(t0.ZipCode) OVER (PARTITION BY t0.Name)
--	,COUNT(t0.ZipCode) OVER (PARTITION BY LEFT(t0.Name, 1))
--FROM 
--	City AS t0

--Nombre d'adresse par ville et par type de rue
SELECT
	t0.Name
	,t1.RoadType
	,COUNT(t1.Identifier)
FROM 
	City AS t0
INNER JOIN 
	Address AS t1 ON t0.Identifier = t1.IdentifierCity
GROUP BY 
	t0.Name
	,t1.RoadType

--Nombre d'adresse par rue (type de rue + nom de la rue + nom ville)
SELECT
	CONCAT(t1.RoadType, N' ', t1.RoadName, N' ', t0.Name) AS Road
	,COUNT(t1.Identifier)
FROM 
	City AS t0
INNER JOIN 
	Address AS t1 on t0.Identifier = t1.IdentifierCity
GROUP BY 
	t0.Name
	,t1.RoadType
	,t1.RoadName


SELECT
	t0.FullAddress
	,COUNT(t0.Identifier)
FROM
(
	SELECT
		t1.Identifier
		,CONCAT(t1.RoadType, N' ', t1.RoadName, N' ', t0.Name) AS FullAddress
	FROM 
		City AS t0
	INNER JOIN 
		Address AS t1 on t0.Identifier = t1.IdentifierCity
) AS t0
GROUP BY 
	t0.FullAddress

--Nombre d'adresse par rue (type de rue + nom de la rue + nom ville)
--En conservant les résultats qui ont au moins un nombre de 2
SELECT
	CONCAT(t1.RoadType, N' ', t1.RoadName, N' ', t0.Name) AS Road
	,COUNT(t1.Identifier)
FROM 
	City AS t0
INNER JOIN 
	Address AS t1 on t0.Identifier = t1.IdentifierCity
GROUP BY 
	t0.Name
	,t1.RoadType
	,t1.RoadName
HAVING --HAVING permet d'appliquer des conditions sur le résultat d'une agrégation
	COUNT(t0.Identifier) > 1

SELECT
	*
FROM
(
	SELECT
		CONCAT(t1.RoadType, N' ', t1.RoadName, N' ', t0.Name)	AS Road
		,COUNT(t1.Identifier)									AS TotalAddress
	FROM 
		City AS t0
	INNER JOIN 
		Address AS t1 on t0.Identifier = t1.IdentifierCity
	GROUP BY 
		t0.Name
		,t1.RoadType
		,t1.RoadName
) AS t0
WHERE
	t0.TotalAddress > 1

/*
En une seule requête
	-> Identifiant de la ville
	-> Type de rue
	-> Total adresse regroupé par ville (Identifier) et par type de rue
	-> Total adresse régroupé par ville (Identifier)
	-> Total général

| CityIdentifier | RoadType | TotalCityRoadType | TotalCity | Total |
---------------------------------------------------------------------

*/

--V1
SELECT
	t0.IdentifierCity
	,t0.RoadType
	,t0.TotalCityRoadType
	,t1.TotalCity
	,(SELECT COUNT(*) FROM Address) AS Total
FROM
(
	SELECT
		t0.IdentifierCity
		,t0.RoadType
		,COUNT(*)		AS TotalCityRoadType
	FROM
		Address AS t0
	GROUP BY
		t0.IdentifierCity
		,t0.RoadType
) AS t0
INNER JOIN
(
	SELECT
		t0.IdentifierCity
		,COUNT(*)		AS TotalCity
	FROM
		Address AS t0
	GROUP BY
		t0.IdentifierCity
) AS t1 ON t0.IdentifierCity = t1.IdentifierCity

--V2
SELECT
	t0.IdentifierCity
	,t0.RoadType
	,t0.TotalCityRoadType
	,t1.TotalCity
	,t2.Total
FROM
(
	SELECT
		t0.IdentifierCity
		,t0.RoadType
		,COUNT(*)		AS TotalCityRoadType
	FROM
		Address AS t0
	GROUP BY
		t0.IdentifierCity
		,t0.RoadType
) AS t0
INNER JOIN
(
	SELECT
		t0.IdentifierCity
		,COUNT(*)		AS TotalCity
	FROM
		Address AS t0
	GROUP BY
		t0.IdentifierCity
) AS t1 ON t0.IdentifierCity = t1.IdentifierCity
CROSS JOIN
(
	SELECT
		COUNT(*) AS Total
	FROM 
		Address
) AS t2

--V3
SELECT DISTINCT
	t0.IdentifierCity
	,t0.RoadType
	,COUNT(*) OVER (PARTITION BY t0.IdentifierCity, t0.RoadType) 	AS TotalCityRoadType
	,COUNT(*) OVER (PARTITION BY t0.IdentifierCity) 				AS TotalCity
	,COUNT(*) OVER () 												AS Total
FROM
	Address AS t0

  
--CUBE : On fait toutes les combinaisons possibles de grouping
SELECT
	t0.IdentifierCity
	,t0.RoadType
	,COUNT(*)  AS Total
	,GROUPING(t0.IdentifierCity) --GROUPING Détermine si la colonne est aggrégée
	,GROUPING(t0.RoadType)
FROM
	Address AS t0
GROUP BY CUBE
(
	t0.IdentifierCity
	,t0.RoadType
)
--ROLLUP : Effectue l'ensemble des regroupement en supprimant le dernier à chaque fois. Par ex ROLLUP A,B,C donne les quatre groupes suivants : ABC, AB, A, ()
SELECT
	t0.IdentifierCity
	,t0.RoadType
	,COUNT(*)  AS Total
	,GROUPING(t0.IdentifierCity)
	,GROUPING(t0.RoadType)
FROM
	Address AS t0
GROUP BY ROLLUP
(
	t0.IdentifierCity
	,t0.RoadType
)
--GROUPING SET : Permet de définir l'ensemble des groupes à produire
SELECT
	t0.IdentifierCity
	,t0.RoadType
	,COUNT(*)  AS Total
	,GROUPING(t0.IdentifierCity)
	,GROUPING(t0.RoadType)
FROM
	Address AS t0
GROUP BY GROUPING SETS
(
	(t0.IdentifierCity)
	,(t0.RoadType)
	,(t0.StreetNumber)
	,(t0.IdentifierCity, t0.StreetNumber)
)

------------------------------------------------------------------------------------------------
/***Opérateurs ensemblistes***/

--INTERSECT : garde les éléments présents dans les deux ensembles
SELECT * FROM Contact AS t0 WHERE t0.FirstName LIKE N'B%'
INTERSECT
SELECT * FROM Contact AS t0 WHERE t0.LastName LIKE N'D%'

--UNION : union des deux ensembles et suppression des doublons
SELECT 'test'
UNION
SELECT 'toto'
UNION
SELECT 'test'

--UNION ALL : union des deux ensembles qui garde les doublons
SELECT 'test'
UNION ALL
SELECT 'toto'
UNION ALL
SELECT 'test'

--EXCEPT : Supprime les éléments de l'ensemble A qui sont dans l'ensemble B
SELECT * FROM Contact AS t0 WHERE t0.LastName LIKE N'D%' --A
EXCEPT
SELECT * FROM Contact AS t0 WHERE t0.FirstName LIKE N'B%' --B

--CROSS JOIN : Produit cartésien entre deux ensembles
SELECT
	*
FROM
	Address AS t0
CROSS JOIN
	City AS t1

--Ancienne norme SQL :
SELECT * FROM Address AS t0, City AS t1

SELECT 
	CASE
		WHEN t1.Type = 1 THEN t0.Amount
		WHEN t1.Type = 2 THEN t0.Amount * 0.2
		WHEN t1.Type = 3 THEN t0.Amount * 1.2
	END
	,t1.Type
FROM
(
	SELECT 500 AS Amount
) AS t0
CROSS JOIN
(
	SELECT 1 AS Type
	UNION ALL
	SELECT 2 AS Type
	UNION ALL
	SELECT 3 AS Type
) AS t1

--Jointures
--Equijointure
SELECT * FROM Address CROSS JOIN City
SELECT 
	* 
FROM 
	Address AS t0
INNER JOIN
	City AS t1 ON t0.IdentifierCity = t1.Identifier

	
--Ancienne norme SQL :
SELECT * FROM Address AS t0, City AS t1 WHERE t0.IdentifierCity = t1.Identifier


--Jointures externes
--LEFT JOIN et RIGHT JOIN

--On récupère tous les enregistrements de A avec les enregistrements de B si il y a une association.
--On ne récupère pas les enregistrements de B si il ne sont pas associés à au moins un enregistrement de A.
--SELECT * FROM A LEFT JOIN B ON A.IdentifierB = B.Identifier

--On récupère tous les enregistrements de B avec les enregistrements de A si il y a une association.
--On ne récupère pas les enregistrements de A si il ne sont pas associés à au moins un enregistrement de B.
--SELECT * FROM A RIGHT JOIN B ON A.IdentifierB = B.Identifier

--Sélectionner les villes avec les adresses + les villes sans adresse (on prend tous les champs)
SELECT
	*
FROM
	City AS t0
LEFT JOIN
	Address AS t1 ON t0.Identifier = t1.IdentifierCity

SELECT
	*
FROM
	Address AS t0
RIGHT JOIN
	City AS t1 ON t1.Identifier = t0.IdentifierCity

--Uniquement les villes sans adresse :
SELECT
	*
FROM
	City AS t0
LEFT JOIN
	Address AS t1 ON t0.Identifier = t1.IdentifierCity
WHERE
	t1.Identifier IS NULL


--FULL OUTER JOIN = LEFT JOIN + RIGHT JOIN
--Pour récupérer à la fois les enregistrements correspondants et sans correspondances entre deux ensembles.
SELECT
	*
FROM
	Contact AS t0
FULL OUTER JOIN
	Civility AS t1 ON t0.IdentifierCivility = t1.Identifier

SELECT
	*
FROM
	Contact AS t0
FULL OUTER JOIN
	Civility AS t1 ON t0.IdentifierCivility = t1.Identifier
WHERE
	t0.Identifier IS NULL
	OR
	t1.Identifier IS NULL


GO
/*
Pour la projection des exo 1 à 4 : Contact.FullName et Civility.ShortName
1 : Pour chaque persone, afficher la civilité associée, garder également les personnes sans civiltié
*/

/*
2 : Afficher les personnes sans civilité
*/

/*
3 : Pour chaque civilité, afficher les personnes associées, garder les civilités sans personne
*/



/*
4 : Afficher les cvivilité sans personne
*/

/*
5 : Pour chaque code postal, afficher le nombre de contact
	5.A : les codes postaux sans contact doivent être affichés
	*/

	/*
	5.B : les codes postaux sans contact sont à ignorer
	*/

/*
6 : Afficher la moyenne d'âge (en valeur décimal) par code postal
    Afficher NULL si pas de contact
	Si une personne n'a pas d'âge, il ne faut pas en tenir compte
*/
	
/*
7 : Afficher la moyenne d'âge (en valeur décimal)
		-> Par adresse (Street number + RoadType + RoadName + CityName)
		-> Par ville et code postal
		-> Par code postal
		-> La moyenne d'âge globale
*/