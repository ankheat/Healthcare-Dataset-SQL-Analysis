CREATE DATABASE healthcare;
USE healthcare;

SELECT * FROM healthcare;

-- Get an overview of the table structure

DESCRIBE healthcare;

-- Preview the first few rows

SELECT * FROM healthcare LIMIT 10;

-- Count the total number of rows

SELECT COUNT(*) AS total_rows FROM healthcare;

-- Check for Missing or Incomplete Data

SELECT 
    SUM(CASE WHEN `Name` IS NULL THEN 1 ELSE 0 END) AS missing_name,
    SUM(CASE WHEN `Age` IS NULL THEN 1 ELSE 0 END) AS missing_age,
    SUM(CASE WHEN `Gender` IS NULL THEN 1 ELSE 0 END) AS missing_gender,
    SUM(CASE WHEN `Blood Type` IS NULL THEN 1 ELSE 0 END) AS missing_blood_type,
    SUM(CASE WHEN `Medical Condition` IS NULL THEN 1 ELSE 0 END) AS missing_medical_condition,
    SUM(CASE WHEN `Date of Admission` IS NULL THEN 1 ELSE 0 END) AS missing_date_of_admission,
    SUM(CASE WHEN `Discharge Date` IS NULL THEN 1 ELSE 0 END) AS missing_discharge_date
FROM healthcare;

-- Summary of numerical columns

SELECT 
    MIN(`Age`) AS min_age, 
    MAX(`Age`) AS max_age, 
    AVG(`Age`) AS avg_age, 
    MIN(`Billing Amount`) AS min_billing_amount,
    MAX(`Billing Amount`) AS max_billing_amount,
    AVG(`Billing Amount`) AS avg_billing_amount
FROM healthcare;

-- Count unique values in categorical columns

SELECT 
    COUNT(DISTINCT `Blood Type`) AS unique_blood_types,
    COUNT(DISTINCT `Gender`) AS unique_genders,
    COUNT(DISTINCT `Admission Type`) AS unique_admission_types
FROM healthcare;

-- Gender distribution

SELECT `Gender`, COUNT(*) AS count
FROM healthcare
GROUP BY `Gender`;

-- Admission Type Distribution

SELECT `Admission Type`, COUNT(*) AS count
FROM healthcare
GROUP BY `Admission Type`;

-- Top Medical Conditions

SELECT `Medical Condition`, COUNT(*) AS count
FROM healthcare
GROUP BY `Medical Condition`
ORDER BY count DESC
LIMIT 10;

-- Average Billing Amount by Admission Type

SELECT `Admission Type`, AVG(`Billing Amount`) AS avg_billing
FROM healthcare
GROUP BY `Admission Type`
ORDER BY avg_billing DESC;

-- Average Age of Patients by Gender

SELECT `Gender`, AVG(`Age`) AS avg_age
FROM healthcare
GROUP BY `Gender`;

-- Common Insurance Providers

SELECT `Insurance Provider`, COUNT(*) AS patient_count
FROM healthcare
GROUP BY `Insurance Provider`
ORDER BY patient_count DESC
LIMIT 5;

-- Average Length of Stay by Admission Type

SELECT 
    `Admission Type`, 
    AVG(DATEDIFF(`Discharge Date`, `Date of Admission`)) AS avg_length_of_stay
FROM healthcare
WHERE `Discharge Date` IS NOT NULL
GROUP BY `Admission Type`
ORDER BY avg_length_of_stay DESC;

SET SQL_SAFE_UPDATES = 0;

UPDATE healthcare
SET 
    `Date of Admission` = STR_TO_DATE(`Date of Admission`, '%Y-%m-%d %H:%i:%s'),
    `Discharge Date` = STR_TO_DATE(`Discharge Date`, '%d-%m-%Y')
WHERE 
    LOCATE('-', `Date of Admission`) = 3 
    OR LOCATE('-', `Discharge Date`) = 3;
    
    ALTER TABLE healthcare
MODIFY COLUMN `Date of Admission` DATE,
MODIFY COLUMN `Discharge Date` DATE;

-- Doctors with the Highest Number of Patients

SELECT 
    `Doctor`, 
    COUNT(*) AS patient_count
FROM healthcare
GROUP BY `Doctor`
ORDER BY patient_count DESC
LIMIT 5;

-- Revenue Generated per Doctor

SELECT 
    `Doctor`, 
    ROUND(SUM(`Billing Amount`), 2) AS total_revenue,
    ROUND(AVG(`Billing Amount`), 2) AS avg_revenue_per_patient
FROM healthcare
GROUP BY `Doctor`
ORDER BY total_revenue DESC;

-- Most Common Medical Conditions by Age Group

SELECT 
    CASE 
        WHEN `Age` < 18 THEN 'Child'
        WHEN `Age` BETWEEN 18 AND 35 THEN 'Young Adult'
        WHEN `Age` BETWEEN 36 AND 60 THEN 'Adult'
        ELSE 'Senior'
    END AS age_group,
    `Medical Condition`,
    COUNT(*) AS condition_count
FROM healthcare
GROUP BY age_group, `Medical Condition`
ORDER BY age_group, condition_count DESC;

-- Gender-Wise Comparison of Billing Amounts

SELECT 
    `Gender`, 
    AVG(`Billing Amount`) AS avg_billing,
    MIN(`Billing Amount`) AS min_billing,
    MAX(`Billing Amount`) AS max_billing
FROM healthcare
GROUP BY `Gender`;

-- Hospital-Wise Revenue Analysis

SELECT 
    `Hospital`, 
    ROUND(SUM(`Billing Amount`), 2) AS total_revenue
FROM healthcare
GROUP BY `Hospital`
ORDER BY total_revenue DESC;

-- Patients with Multiple Admissions

SELECT 
    `Name`, 
    COUNT(*) AS admission_count
FROM healthcare
GROUP BY `Name`
HAVING admission_count > 1
ORDER BY admission_count DESC;

-- Utilization of Rooms

SELECT 
    `Room Number`, 
    COUNT(*) AS room_usage
FROM healthcare
GROUP BY `Room Number`
ORDER BY room_usage DESC;

-- Patients Admitted Without Insurance

SELECT COUNT(*) AS uninsured_patients
FROM healthcare
WHERE `Insurance Provider` IS NULL OR `Insurance Provider` = ''; 

-- Monthly Admission Trend

SELECT 
    MONTH(`Date of Admission`) AS admission_month,
    COUNT(*) AS total_admissions
FROM healthcare
GROUP BY admission_month
ORDER BY admission_month;

-- Patients Not Discharged

SELECT *
FROM healthcare
WHERE `Discharge Date` IS NULL;

-- Patients at High Billing Risk

SELECT *
FROM healthcare
WHERE `Billing Amount` > 10000
ORDER BY `Billing Amount` DESC;

-- Top 5 Insurance Providers by Revenue

SELECT 
    `Insurance Provider`, 
    ROUND(SUM(`Billing Amount`), 2) AS total_revenue
FROM healthcare
GROUP BY `Insurance Provider`
ORDER BY total_revenue DESC
LIMIT 5;

-- Average Billing Amount by Blood Type

SELECT 
    `Blood Type`, 
    Round(AVG(`Billing Amount`), 2) AS avg_billing
FROM healthcare
GROUP BY `Blood Type`
ORDER BY avg_billing DESC;

-- Patients Requiring Frequent Tests

SELECT 
    `Name`, 
    COUNT(`Test Results`) AS test_count
FROM healthcare
GROUP BY `Name`
HAVING test_count > 3
ORDER BY test_count DESC;

