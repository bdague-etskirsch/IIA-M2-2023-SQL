# TP InvoiceManager

## DDL et DML
Dans un premier fichier, créer une base de données `InvoiceManager` capable de gérer :
- Des factures (Id et Date de facture)
- Des lignes de factures (Id, Id de facture, Prix unitaire et Quantité)

Générer ensuite 300000 factures sur les 72 derniers mois.

Générer des lignes pour toutes les factures :
- De 1 à 5 lignes par facture
- Quantité comprise entre 1.00 et 19.99
- Prix unitaire compris entre 1.00 et 49.99

## DQL

### Requête 1 :
- Calculer la moyenne des factures par jours
- Calculer la moyenne des factures par Mois/Année
- Calculer la moyenne des factures par Année
- Calculer la moyenne des factures par trimèstre/Année
- Calculer la moyenne des factures par semaine/Année
- Calculer la moyenne des factures total
- Calculer la somme des factures par jours
- Calculer la somme des factures par Mois/Année
- Calculer la somme des factures par Année
- Calculer la somme des factures par trimèstre/Année
- Calculer la somme des factures par semaine/Année
- Calculer la somme des factures total

#### 1.A : vous devez mettre les moyennes dans une colonne et les sommes dans une seconde colonne.

| DateDay | DateMonth | DateYear | DateQuarter | DateWeek | TotalAverage | TotalSum |
|---------|-----------|----------|-------------|----------|--------------|----------|
|       1 |         1 |     2020 |           1 |        1 |        XXX   |      XXX |
|    NULL |         1 |     2020 |        NULL |     NULL |        XXX   |      XXX |


#### 1.B : vous devez éclater les résultats dans différentes colonnes (une par calcul)

| DateDay | DateMonth | DateYear | DateQuarter | DateWeek | TotalAveragePerDay | TotalAveragePerYearMonth | ... |
|---------|-----------|----------|-------------|----------|--------------------|--------------------------|-----|
|       1 |         1 |     2020 |           1 |        1 |              XXX   |                      XXX | ... |



### Requête 2
A partir de deux dates, générer une ligne de résultat pour chaque mois/année entre les deux dates :
- Pour chaque ligne, donner la somme et la moyenne du mois
- Pour chaque ligne, donner la somme et la moyenne cumulée des factures du mois + des mois précédents
- Pour chaque ligne, donner la somme et la moyenne cumulée des factures du mois + des mois précédents, chaque année, le cumulé reprend à 0

Exemple : entre le 11/2017 et le 01/2018

| Année | Mois | Somme mois | Moyenne mois | Somme cumulée total | Somme cumulée annuel | 
|-------|------|------------|--------------|---------------------|----------------------|
| 2017  | 11   | 1000       | 200          | 1000                | 1000                 |
| 2017  | 12   | 2000       | 400          | 3000                | 3000                 |
| 2018  | 01   | 1500       | 150          | 4500                | 1500                 |

``` sql
GO
DECLARE @StartDate DATE = DATEFROMPARTS(2018,6,1)
DECLARE @EndDate DATE = DATEFROMPARTS(2019,5,31)

--TODO : Requête

```


### Requête 3
Identique à la précédente avec un paramètre Mode : 
- Mode = 1 : Mois
- Mode = 2 : Année 
- Mode = 3 : Trimestre

Exemple : entre le 11/2017 et le 01/2018 et mode = 1

 | Date       | Somme | Moyenne | Somme cumulée total | 
 -----------------------------------------------------|
 | 2017/11/01 | 1000  | 200     | 1000                |
 | 2017/12/01 | 2000  | 400     | 3000                |
 | 2018/01/01 | 1500  | 150     | 4500                |

  exemple : entre le 11/2016 et le 01/2018 et mode = 2

 | Date       | Somme | Moyenne | Somme cumulée total | 
 -----------------------------------------------------|
 | 2017/01/01 | 1000  | 200     | 1000                |
 | 2018/01/01 | 2000  | 400     | 3000                |

``` sql
GO
DECLARE @StartDate DATE = DATEFROMPARTS(2018,6,1)
DECLARE @EndDate DATE = DATEFROMPARTS(2019,5,31)
DECLARE @Mode INT -- 1 mois / 2 année / 3 trimestre

--TODO : Requête

```