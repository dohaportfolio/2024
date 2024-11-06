-- 1) Les personnes étudiées sont-elles couvertes par une assurance maladie ? 
-- KPI : % de personnes couvertes par une assurance maladie

SELECT 
    (COUNT(CASE WHEN AnyHealthCare = 1 THEN 1 END) * 100.0 / COUNT(*)) AS Percent_Covered
FROM Demographics;

-- 2) L'âge joue-t-il sur la perception que les personnes ont de leur propre santé mentale ? Si oui, dans quelle mesure ? 
-- KPI : Âge moyen pour chaque groupe de perception de la santé mentale

SELECT 
    MenHlth, AVG(Age) AS Avg_Age
FROM Demographics
GROUP BY MenHlth;

-- 3) Les femmes sont-elles en meilleure santé que les hommes ? 
-- KPI : Niveau de santé générale moyen en fonction du sexe

SELECT 
    Sex, AVG(GenHlth) AS Avg_General_Health
FROM Demographics
GROUP BY Sex;

-- 4) Les personnes qui font du sport sont-elles en meilleure santé ?

SELECT 
    PhysActivity, AVG(PhysHlth) AS Avg_Physical_Health_Issues
FROM BehavioralIndicators
JOIN Demographics ON BehavioralIndicators.ID = Demographics.ID
GROUP BY PhysActivity;

-- 5) Y a-t-il un lien entre le niveau de revenu d'une personne et sa tendance à fumer ? 
-- KPI : Taux de personnes ayant fumé plus de 100 cigarettes par tranche de revenu

SELECT 
    Income, 
    (COUNT(CASE WHEN Smoker = 1 THEN 1 END) * 100.0 / COUNT(*)) AS Percent_Smokers
FROM BehavioralIndicators
JOIN Demographics ON BehavioralIndicators.ID = Demographics.ID
GROUP BY Income;

-- 6) Existe-t-il une différence dans les difficultés à marcher selon les groupes d'âge et de sexe ? 
-- KPI : % de personnes ayant des difficultés à marcher en fonction de l'âge et du sexe

SELECT 
    Age, Sex, 
    (COUNT(CASE WHEN DiffWalk = 1 THEN 1 END) * 100.0 / COUNT(*)) AS Percent_With_DiffWalk
FROM BehavioralIndicators
JOIN Demographics ON BehavioralIndicators.ID = Demographics.ID
GROUP BY Age, Sex;

-- 7) Comment l'accès aux soins varie-t-il en fonction des niveaux de revenu ? 
-- KPI : % de personnes ayant rencontré des difficultés à payer une consultation chez le docteur par niveau de revenu

SELECT 
    Income, 
    (COUNT(CASE WHEN NoDocbcCost = 1 THEN 1 END) * 100.0 / COUNT(*)) AS Percent_No_Access_Due_To_Cost
FROM Demographics
GROUP BY Income;

-- 8) Les personnes avec un niveau d'instruction élevé consomment-elles plus de fruits et légumes ? 
-- KPI : % de personnes qui consomment plus d'un fruit/légume par jour par niveau d'instruction

SELECT 
    Education, 
    (AVG(Fruits) * 100) AS Percent_Fruits, 
    (AVG(Veggies) * 100) AS Percent_Veggies
FROM BehavioralIndicators
JOIN Demographics ON BehavioralIndicators.ID = Demographics.ID
GROUP BY Education;

-- 9) Les personnes ayant une pression artérielle élevée ont-elles un IMC élevé ? 
-- KPI : IMC moyen des personnes avec une pression artérielle élevée

SELECT 
    HighBP, AVG(BMI) AS Avg_BMI
FROM HealthIndicators
GROUP BY HighBP;

-- 10) Comment le taux de consommation excessive d’alcool varie-t-il en fonction de l'âge et du sexe ? 
-- KPI : Taux de consommation excessive d’alcool par âge et par sexe

SELECT 
    Age, Sex, 
    (COUNT(CASE WHEN HvyAlcohol = 1 THEN 1 END) * 100.0 / COUNT(*)) AS Percent_Heavy_Alcohol_Users
FROM BehavioralIndicators
JOIN Demographics ON BehavioralIndicators.ID = Demographics.ID
GROUP BY Age, Sex
ORDER BY Percent_Heavy_Alcohol_Users DESC;

-- 11) Comment se répartissent les cas de diabète selon l'âge et le sexe ? 
-- KPI : % de diabétiques par sexe et par catégorie d'âge

SELECT 
    Age, Sex, 
    (COUNT(CASE WHEN Diabetes_012 = 2 THEN 1 END) * 100.0 / COUNT(*)) AS Percent_Diabetic
FROM HealthIndicators
JOIN Demographics ON HealthIndicators.ID = Demographics.ID
GROUP BY Age, Sex;

-- 12) Y a-t-il une différence dans la prévalence du diabète entre les fumeurs et les non-fumeurs ? 
-- KPI : % de personnes diabétiques parmi les fumeurs et les non-fumeurs

SELECT 
    Smoker, 
    (COUNT(CASE WHEN Diabetes_012 = 2 THEN 1 END) * 100.0 / COUNT(*)) AS Percent_Diabetic
FROM BehavioralIndicators
JOIN HealthIndicators ON BehavioralIndicators.ID = HealthIndicators.ID
GROUP BY Smoker;

-- 13) Le diabète est-il souvent associé à des maladies cardiaques, et dans quelle proportion ? 
-- KPI : % de personnes atteintes de maladies cardiaques par niveau de diabète

SELECT 
    Diabetes_012, 
    (COUNT(CASE WHEN HeartDiseaseorAttack = 1 THEN 1 END) * 100.0 / COUNT(*)) AS Percent_With_HeartDisease
FROM HealthIndicators
GROUP BY Diabetes_012;

-- 14) Y a-t-il un lien entre le niveau de revenu et le taux de diabète ? 
-- KPI : % de personnes diabétiques par niveau de revenu

SELECT 
    Income, 
    (COUNT(CASE WHEN Diabetes_012 = 2 THEN 1 END) * 100.0 / COUNT(*)) AS Percent_Diabetic
FROM HealthIndicators
JOIN Demographics ON HealthIndicators.ID = Demographics.ID
GROUP BY Income;

-- 15) Comment le nombre de jours de mauvaise santé mentale varie-t-il entre les individus diabétiques et non-diabétiques ? 
-- KPI : Nombre de jours en mauvaise santé mentale par niveau de diabète

WITH MentalHealth_CTE AS (
    SELECT 
        Diabetes_012, AVG(MenHlth) AS Avg_Mental_Health_Days
    FROM HealthIndicators
    JOIN Demographics ON HealthIndicators.ID = Demographics.ID
    GROUP BY Diabetes_012
)
SELECT * FROM MentalHealth_CTE;
