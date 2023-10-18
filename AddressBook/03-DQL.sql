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

--Nombre d'adresse par ville et par type de rue

--Nombre d'adresse par rue (type de rue + nom de la rue + nom ville)

--Nombre d'adresse par rue (type de rue + nom de la rue + nom ville)
--En conservant les résultats qui ont au moins un nombre de 2

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