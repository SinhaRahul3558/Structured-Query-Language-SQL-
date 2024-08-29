select `Medical Condition` from databasename.healthcare_dataset;

select * from databasename.healthcare_dataset;


#1.Counting Total Record in Database

SELECT COUNT(*) from databasename.healthcare_dataset;		

#2. Finding maximum age of patient admitted.

select max(age) from databasename.healthcare_dataset;

#3.Finding Average age of hospitalized patients.

select avg(age) from databasename.healthcare_dataset;
select round(avg(age),0) from databasename.healthcare_dataset;

#4.Calculating Patients Hospitalized Age-wise from Maximum to Minimum

select age,count(age) from databasename.healthcare_dataset
group by Age
order by age desc;


select age,count(age) from databasename.healthcare_dataset
group by Age
order by age asc;

#5 Calculating Maximum Count of patients on basis of total patients hospitalized with respect to age.


select age,count(age) from databasename.healthcare_dataset
group by Age
order by count(age) desc;


select age,count(age) from databasename.healthcare_dataset
group by Age
order by count(age) asc;

#6. Ranking Age on the number of patients Hospitalized   


SELECT AGE, COUNT(AGE) As Total, dense_RANK() OVER(ORDER BY COUNT(AGE) DESC, age DESC) as Ranking_Admitted 
FROM databasename.healthcare_dataset 
GROUP BY age
HAVING Total > Avg(age);

#7. Finding Count of Medical Condition of patients and lisitng it by maximum no of patients.

SELECT `Medical Condition` as Total_Patients FROM databasename.healthcare_dataset 
GROUP BY `Medical Condition`;
;

SELECT `Medical Condition`, COUNT(`Medical Condition`) as Total_Patients 
FROM databasename.healthcare_dataset 
GROUP BY `Medical Condition`
ORDER BY Total_patients DESC;

# 8. Finding Rank & Maximum number of medicines recommended to patients based on Medical Condition pertaining to them. 

SELECT `Medical Condition`, Medication, COUNT(medication) as Total_Medications_to_Patients, RANK() OVER(PARTITION BY `Medical Condition` ORDER BY COUNT(medication) DESC) as "Rank_Medicine"
FROM databasename.healthcare_dataset
GROUP BY 1,2
ORDER BY 1; 

SELECT `Medical Condition`, Medication, COUNT(medication) as Total_Medications_to_Patients, RANK() OVER(PARTITION BY `Medical Condition` ORDER BY COUNT(medication) DESC) as "Rank_Medicine"
FROM databasename.healthcare_dataset
GROUP BY `Medical Condition`,Medication
ORDER BY `Medical Condition`; 

#9. Most preffered Insurance Provide  by Patients Hospatilized

select `Insurance Provider`,count(`Insurance Provider`) as Total_Patients FROM databasename.healthcare_dataset 
GROUP BY `Insurance Provider`
order by `Insurance Provider`;


select age, `Insurance Provider`,count(`Insurance Provider`) as Total_Patients FROM databasename.healthcare_dataset 
GROUP BY `Insurance Provider`,age
order by `Insurance Provider`;

#10. Finding out most preffered Hospital 

select * from databasename.healthcare_dataset;

select Hospital,count(Hospital) from databasename.healthcare_dataset
group by Hospital 
order by count(Hospital) desc ;

#11. Identifying Average Billing Amount by Medical Condition.

SELECT `Medical Condition`, ROUND(AVG(`Billing Amount`),0) AS Avg_Billing_Amount
FROM databasename.healthcare_dataset 
GROUP BY `Medical Condition`
order by Avg_Billing_Amount desc;

#12. Finding Billing Amount of patients admitted and number of days spent in respective hospital.

SELECT Name, Age, Gender, `Blood Type`, `Medical Condition`, `Date of Admission`, Doctor, Hospital, `Insurance Provider`, `Billing Amount`, `Room Number`, `Admission Type`, `Discharge Date`, Medication, `Test Results`
FROM databasename.healthcare_dataset;

SELECT `Medical Condition`, Name, Hospital, DATEDIFF(`Discharge Date`,`Date of Admission`) as Number_of_Days, 
SUM(ROUND(`Billing Amount`,0)) OVER(Partition by Hospital ORDER BY Hospital DESC) AS Total_Amount
FROM databasename.healthcare_dataset 
ORDER BY Total_Amount desc;

#13.Finding Total number of days sepnt by patient in an hospital for given medical condition

SELECT Name, 'Medical Condition', ROUND(`Billing Amount`,0) as Billing_Amount, Hospital, DATEDIFF(`Discharge Date`, `Date of Admission`) as Total_Hospitalized_days
FROM databasename.healthcare_dataset;

#14. Finding Hospitals which were successful in discharging patients after having test results as 'Normal' with count of days taken to get results to Normal

SELECT `Medical Condition`, Hospital, DATEDIFF(`Discharge Date`,`Date of Admission`) as Total_Hospitalized_days,`Test Results`
FROM databasename.healthcare_dataset 
WHERE `Test Results` LIKE 'Normal'
ORDER BY `Medical Condition`, Hospital;

#15. Calculate number of blood types of patients which lies betwwen age 20 to 45

select AGE,`Blood Type`,count(`Blood Type`) as count_blood_type from
databasename.healthcare_dataset 
where age between 20 and 45
group by 1,2
order by age;

#16.Find how many of patient are Universal Blood Donor and Universal Blood reciever


SELECT Name, Age, Gender, `Blood Type`, `Medical Condition`, `Date of Admission`, Doctor, Hospital, `Insurance Provider`, `Billing Amount`, `Room Number`, `Admission Type`, `Discharge Date`, Medication, `Test Results`
FROM databasename.healthcare_dataset;

SELECT 
    SUM(CASE WHEN `Blood Type`= 'O-' THEN 1 ELSE 0 END) AS UniversalDonors,
    SUM(CASE WHEN `Blood Type`= 'AB+' THEN 1 ELSE 0 END) AS UniversalReceivers
FROM databasename.healthcare_dataset ;

SELECT DISTINCT (SELECT Count(`Blood Type`) FROM databasename.healthcare_dataset  WHERE `Blood Type` IN ('O-')) AS Universal_Blood_Donor, 
(SELECT Count(`Blood Type`) FROM databasename.healthcare_dataset  WHERE `Blood Type` IN ('AB+')) as Universal_Blood_reciever
from databasename.healthcare_dataset ;

SELECT 'Universal Donors' AS `Blood Type`, COUNT(`Blood Type`) AS Count
FROM databasename.healthcare_dataset 
WHERE `Blood Type` = 'O-'
UNION
SELECT 'Universal Receivers' AS `Blood Type`, COUNT(`Blood Type`) AS Count
FROM databasename.healthcare_dataset 
WHERE `Blood Type` = 'AB+';

#17. Provide a list of hospitals along with the count of patients admitted in the year 2024 AND 2025?

SELECT DISTINCT Hospital, Count(*) as Total_Admitted
FROM databasename.healthcare_dataset 
WHERE YEAR(`Date of Admission`) IN (2024, 2025)
GROUP BY 1
ORDER by Total_Admitted DESC;

#18.Find the average, minimum and maximum billing amount for each insurance provider?

select  `Insurance Provider`,round(avg(`Billing Amount`),0),round( min(`Billing Amount`),0),round( max(`Billing Amount`),0) from databasename.healthcare_dataset
group by `Insurance Provider` ;


#19.Create a new column that categorizes patients as high, medium, or low risk based on their medical condition.

SELECT Name, Age, Gender, `Blood Type`, `Medical Condition`, `Date of Admission`, Doctor, Hospital, `Insurance Provider`, `Billing Amount`, `Room Number`, `Admission Type`, `Discharge Date`, Medication, `Test Results`
FROM databasename.healthcare_dataset;

SELECT Name, `Medical Condition`,`Test Results`,
CASE 
		WHEN `Test Results`= 'Inconclusive' THEN 'Need More Checks / CANNOT be Discharged'
        WHEN `Test Results` = 'Normal' THEN 'Can take discharge, But need to follow Prescribed medications timely' 
        WHEN `Test Results` =  'Abnormal' THEN 'Needs more attention and more tests'
        END AS 'Status', Hospital, Doctor
FROM databasename.healthcare_dataset ;

SELECT Name, `Medical Condition`,`Test Results`,
CASE 
		WHEN `Test Results`= 'Inconclusive' THEN 'high'
        WHEN `Test Results` = 'Normal' THEN 'low' 
        WHEN `Test Results` =  'Abnormal' THEN 'medium'
        END AS 'Status', Hospital, Doctor
FROM databasename.healthcare_dataset ;

