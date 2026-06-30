
<div align = "justify">

# 🎯 Introduction

Welcome to my HR Attrition Data Cleaning portfolio project! This project explores a raw, unformatted dataset of 10,000 human resource records to clean, format, and standardize employee information regarding demographics, operational roles, and historical company retention tracking.

The goal of this analysis is to demonstrate how advanced SQL workflows can transform raw, messy transactional records into production-grade database tables structured perfectly for executive business intelligence and predictive modeling.

---

# 📖 Background

Driven by a desire to practice advanced SQL querying and real-world database management, this portfolio project simulates the essential data cleaning operations required of a Data Analyst. The goal is to streamline complex, human-entered employee records into structured classifications—helping stakeholders easily filter tracking anomalies, identify clear demographic trends, and optimize retention strategy timelines.

The analysis is built on a comprehensive HR dataset featuring organizational features, employee identifications, role metrics, and key data points such as name logs, marital statuses, business travel categories, and department records.

---

# ❓ The Questions I Wanted to Answer Through My SQL Queries:

To successfully clean, validate, and prepare this dataset for downstream reporting, my cleaning pipeline addressed the following core operational objectives:

1. **Data Ingestion & Integrity:** How can we safely initialize our production environment and dynamically track operational updates across thousands of rows?

2. **Standardizing Categorical Structural Nuances:** How do we unify variable entries in data categories like `Gender`, `Department`,`EducationField`, `EmployeeName` where mixed cased characters and inconsistent shorthand are present?

3. **Programmatic Text Refinement:** What complex string manipulation functions can transform corrupted full-uppercase names into clean, standardized title-cased structures without any missing data elements?

4. **Handling Structural Empty Fields & Missing Values:** How do we programmatically detect and isolate dirty multi-variate data placeholders (e.g., `'?'`, `'-'`, `'NA'`, `'UNKNOWN'`) to guarantee high-integrity analytical rows?

5. **Enforcing Global Data Schema Controls:** How can we ensure categorical constants across legal filters (such as age verifications and monthly data entries) conform to corporate database integrity standards?


##  Cleaning and Standardizing Data for  better readability

1. 


```sql
/* FULL CLEANING DATA TO GET IT READY FOR ANALYSIS

 Our mission here is:
1- Create database ;
2- Create the table via uploading the DATA ;
3- Clean the data and standardize Data to get it ready for analysis.
*/
-- 1- Creeate DATABASE 
CREATE database Hr_Attrition;

--2- Create the table via uploading the DATA 

```

2. **Data Standardization: Resolving Categorical Anomalies in Gender**

This query cleanses and standardizes the highly inconsistent ⁠Gender⁠ column within the ⁠hr_attrition_messy_10000⁠ table. By utilizing defensive ⁠CASE⁠ logic combined with ⁠TRIM()⁠ and ⁠UPPER()⁠ functions, it unifies fragmented entry formats **(such as 'm', 'M', 'male', 'Male')** into explicit Male or Female categories. Additionally, it actively catches and groups corrupted or missing entries—including empty strings, **⁠NULL⁠ values, ⁠'NA'⁠, and ⁠'?'**⁠—into a standardized 'Missing' flag.

```sql
/* Data Standardization: Standardizing 
Categorical Anomalies in the Gender Feature*/

SELECT 
    EmployeeName,
    Gender AS original_gender, -- Temporary column so you can see what it used to be
    CASE 
        -- Trim spaces and convert to uppercase to catch 'm', 'M', 'male', 'Male'
        WHEN TRIM(UPPER(Gender)) IN ('M', 'MALE') THEN 'Male'
        
        -- Trim spaces and convert to uppercase to catch 'f', 'F', 'female', 'Female'
        WHEN TRIM(UPPER(Gender)) IN ('F', 'FEMALE') THEN 'Female'
        
        -- If it's empty spaces, NULL, or literally says 'NA'
        WHEN TRIM(Gender) = ''
        OR Gender IS NULL 
        OR TRIM(UPPER(Gender)) = 'NA'
        OR TRIM(Gender) = '?' THEN 'Missing'
        
        -- Fallback catch-all to see what we missed
        ELSE 'Unmapped Value'
    END AS cleaned_Gender
FROM 
    hr_attrition_messy_10000;

```

3. This query addresses data quality issues within the ⁠Department⁠ column by standardizing inconsistent naming conventions, abbreviations, and missing or corrupted values. The dataset contained multiple variations for identical departments (e.g., shorthand abbreviations or varying case formats), as well as placeholder strings for missing values.
```sql

/*Data Standardization: 
 Standardizing Categorical Anomalies in the Department Feature*/

SELECT 
	DISTINCT hr_attrition_messy_10000.Department
FROM hr_attrition_messy_10000;
    

SELECT 
	hr_attrition_messy_10000.Department  AS Original_dep,
	CASE 
		WHEN trim(UPPER(Department)) IN ('H', 'HR', 'HUMAN RESOURCES') THEN 'Human Resources'
		WHEN trim(UPPER(Department)) IN ('R', 'RESEARCH & DEVELOPMENT', 'R&D','RESEARCH AND DEVELOPMENT' ) THEN 'Research and Development'
		WHEN trim(UPPER(Department)) IN ('S', 'SALES') THEN 'Sales'
		
		WHEN Department IS NULL
			OR  trim(UPPER(Department)) IN ('NA ', 'N/A', 'UNKNOWN')
			OR  trim(Department) IN  ('?', '', '-')THEN 'Missing'
	END AS cleaned_dep
FROM 
    hr_attrition_messy_10000;
    
    
 --UPDATE COLUMN
 
UPDATE hr_attrition_messy_10000
SET  hr_attrition_messy_10000.Department = 
    CASE 
		WHEN trim(UPPER(Department)) IN ('H', 'HR', 'HUMAN RESOURCES') THEN 'Human Resources'
		WHEN trim(UPPER(Department)) IN ('R', 'RESEARCH & DEVELOPMENT', 'R&D','RESEARCH AND DEVELOPMENT' ) THEN 'Research and Development'
		WHEN trim(UPPER(Department)) IN ('S', 'SALES') THEN 'Sales'
		
		WHEN Department IS NULL
			OR  trim(UPPER(Department)) IN ('NA ', 'N/A', 'UNKNOWN')
			OR  trim(Department) IN  ('?', '', '-')THEN 'Missing'
	END;
```


4. This query resolves data formatting inconsistencies within the ⁠EmployeeName⁠ feature. In the raw dataset, employee names were stored using chaotic casing formats (e.g., completely uppercase names like **⁠'JOHN SMITH'⁠ or entirely lowercase entries)**, which negatively impacts readability and reporting aesthetics.
Since SQL dialects like MySQL or standard PostgreSQL do not always feature a native, built-in ⁠INITCAP()⁠ function for proper title casing, this script dynamically reconstructs the strings using a combination of foundational string manipulation functions **(⁠CONCAT()⁠, ⁠UPPER()⁠, ⁠LOWER()⁠, ⁠SUBSTRING()⁠, and ⁠LOCATE()⁠)**.
The logic parses and reformats the full name by identifying the space character separating the first and last name:
 First Name Formatting: Isolates the first character using**⁠SUBSTRING(..., 1, 1)**⁠ and converts it to uppercase via **⁠UPPER()**⁠, while extracting the remaining letters up to the space character and converting them to lowercase using ⁠LOWER()⁠.
 Space Injection: Appends a clean single space (⁠' '⁠) between the parsed name components.
 Last Name Formatting: Uses **⁠LOCATE(' ', employeeName)**⁠ to dynamically find the starting position of the surname, isolates its first character to uppercase it, and maps the rest of the string to lowercase.
```sql

/* Converts messy, full UPPERCASE employee names into proper 
Title Case (e.g., "JOHN SMITH" becomes "John Smith")*/

 SELECT
	hr_attrition_messy_10000.EmployeeName AS ORI_NAME,
	CONCAT(
    -- Capitalize first letter of the first name + Loweercse the rest 
		UPPER(SUBSTRING(employeeName, 1,1)),
        LOWER(SUBSTRING(employeeName, 2, LOCATE(' ', employeeName) - 2)),
        ' ',
	-- Capitalize First letter of the second name + Loweercse the rest 
		UPPER(SUBSTRING(employeeName,  LOCATE(' ', employeeName) +1 , 1)),
        LOWER(SUBSTRING(employeeName, LOCATE(' ', employeeName) + 2))
        ) AS formatted_name
FROM 
	hr_attrition_messy_10000;

    
-- Updating the columns employeeName

UPDATE hr_attrition_messy_10000
SET hr_attrition_messy_10000.EmployeeName =
	CONCAT(
    -- Capitalize first letter of the first name + Loweercse the rest 
		UPPER(SUBSTRING(employeeName, 1,1)),
        LOWER(SUBSTRING(employeeName, 2, LOCATE(' ', employeeName) - 2)),
        ' ',
	-- Capitalize First letter of the second name + Loweercse the rest 
		UPPER(SUBSTRING(employeeName,  LOCATE(' ', employeeName) +1 , 1)),
        LOWER(SUBSTRING(employeeName, LOCATE(' ', employeeName) + 2))
        ); 


        -- Updating EmploypeeName column
UPDATE hr_attrition_messy_10000
SET hr_attrition_messy_10000.EmployeeName = 
trim(EmployeeName);

```
5. This query focuses on standardizing the key target metric, ⁠Attrition⁠, by resolving text variations, casing inconsistencies, and poorly handled missing data. Because attrition flags are critical for downstream reporting and predictive modeling, ensuring binary clarity **('Yes' vs. 'No')** along with explicit handling of invalid data is essential.
Using a ⁠CASE⁠ statement coupled with **⁠trim()⁠ and ⁠UPPER()**⁠ functions to strip trailing spaces and eliminate case sensitivity, the script groups messy values into three precise categories:
 No: Reconciles negative variations such as ⁠'N'⁠ and ⁠'NO'⁠ into a clean, uniform ⁠'No'⁠ flag.
 Yes: Reconciles positive variations such as ⁠'Y'⁠ and ⁠'YES'⁠ into a clean, uniform ⁠'Yes'⁠ flag.
 Missing: Captures corrupted strings, broken entries, or placeholders **(such as ⁠'NA '⁠, ⁠'N/A'⁠, ⁠'UNKNOWN'⁠)**, as well as special characters **(⁠'?'⁠, ⁠'-'⁠, or empty strings ⁠''⁠)**, and safely maps them to a uniform ⁠'Missing'⁠ label.
```sql

/* Cleaning and standardizing the Attrtion column
*/
SELECT 
DISTINCT hr_attrition_messy_10000.Attrition
FROM hr_attrition_messy_10000;

 
UPDATE hr_attrition_messy_10000
SET Attrition =
	CASE
		When trim(UPPER(Attrition)) IN ('N', 'NO') THEN 'No'
		When trim(UPPER(Attrition)) IN ('Y', 'YES') THEN 'Yes'
		When trim(UPPER(Attrition)) IN ('NA ', 'N/A', 'UNKNOWN')
			OR  trim(Attrition) IN  ('?', '', '-')  THEN 'Missing'
	END ;
    
    
SELECT *
FROM 
	hr_attrition_messy_10000;

```

6. This query addresses categorical inconsistencies and structural noise within the ⁠BusinessTravel⁠ column. Business travel frequencies are highly valuable categorical metrics for analyzing employee burnout and attrition trends; therefore, removing abbreviations and correcting case anomalies is essential for clear segmentation.
The script runs a comprehensive **⁠CASE⁠ statement** utilizing **⁠TRIM()⁠ and ⁠UPPER()** functions to strip accidental spaces, override case variations, and collapse multiple text variants into structured, professional labels:
 Travel Rarely: Groups shorthand identifiers and inconsistent casings like **⁠'T'⁠, ⁠'TRAVEL_RARELY'⁠, and ⁠'TRAVEL RARELY'**⁠ into a standard ⁠'Travel Rarely'⁠ category.
 Travel Frequently: Consolodates variants like **⁠'T'⁠, ⁠'TRAVEL_FREQUNTLY'⁠, and ⁠'TRAVEL FREQUENTLY'⁠ into a uniform ⁠'Travel Frequently'⁠ label.**
 No Travel: Cleans up negative markers such as ** ⁠'N'⁠, ⁠'NON-TRAVEL'⁠, and ⁠'NO TRAVEL'⁠** to establish a definitive ⁠'No Travel'⁠ state.
 Missing: Standardizes structural gaps—including literal database ⁠NULL⁠ values, missing text placeholders **(⁠'NA'⁠, ⁠'N/A'⁠, ⁠'UNKNOWN'⁠)**, and corrupted characters **(⁠'?'⁠, ⁠''⁠, ⁠'-'⁠)**—by funneling them into a single ⁠'Missing'⁠ group.
```sql
/* Cleaning and standardizing the
 BusinessTravel column
*/
SELECT 
DISTINCT hr_attrition_messy_10000.BusinessTravel
FROM hr_attrition_messy_10000;

UPDATE	hr_attrition_messy_10000
SET BusinessTravel = CASE
		WHEN TRIM(UPPER(BusinessTravel)) IN ('T', 'TRAVEL_RARELY', 'TRAVEL RARELY')
        THEN 'Travel Rarely'
        WHEN TRIM(UPPER(BusinessTravel)) IN ('T', 'TRAVEL_FREQUENTLY', 'TRAVEL FREQUENTLY')
        THEN 'Travel Frequently'
        WHEN TRIM(UPPER(BusinessTravel)) IN ('N', 'NON-TRAVEL', 'NO TRAVEL')
        THEN 'No Travel'
        
        WHEN BusinessTravel IS NULL
			OR TRIM(BusinessTravel) IN ( 'NA ', 'N/A', 'UNKNOWN')
            OR TRIM(BusinessTravel) IN ( '?', ' ', '-') THEN 'Missing'
	END;
```

7. 
```sql

/* Cleaning and standardizing 
the EducationField column
*/
SELECT 
DISTINCT hr_attrition_messy_10000.EducationField
FROM hr_attrition_messy_10000;

UPDATE hr_attrition_messy_10000
SET hr_attrition_messy_10000.EducationField =
CASE
		WHEN TRIM(UPPER(EducationField)) IN ('H', 'HR','HUMAN RESOURCES')
        THEN 'Human Resources'
        WHEN TRIM(UPPER(EducationField)) IN ('M', 'MED', 'MEDICAL')
        THEN 'Medical'
        WHEN TRIM(UPPER(EducationField)) IN ('L', 'LIFE SCIENCES', 'LIFE SCIENCE')
        THEN 'Life Science'
        WHEN TRIM(UPPER(EducationField)) IN ('MKTG', 'MARKETING')
        THEN 'Marketing'
        WHEN TRIM(UPPER(EducationField)) IN ('O', 'OTHER')
        THEN 'Other'
        WHEN TRIM(UPPER(EducationField)) IN ('T', 'TECH DEGREE','TECHNICAL DEGREE')
        THEN 'Technical Degree'
        
        WHEN EducationField IS NULL
			OR TRIM(EducationField) IN ( 'NA ', 'N/A', 'UNKNOWN') 
            OR TRIM(EducationField) IN ( '?', ' ', '-') 
            THEN 'Missing'
	END;

```

8. 
```sql

/* Cleaning and standardizing 
the MaritalStatus column
*/
SELECT 
DISTINCT hr_attrition_messy_10000.MaritalStatus
FROM hr_attrition_messy_10000;


UPDATE hr_attrition_messy_10000
SET MaritalStatus=
	CASE
		WHEN TRIM(UPPER(MaritalStatus)) IN ('D', 'DIVORCED','DIVORCD')
        THEN 'Divorced'
        WHEN TRIM(UPPER(MaritalStatus)) IN ('S', 'SINGLE')
        THEN 'Single'
        WHEN TRIM(UPPER(MaritalStatus)) IN ('M', 'MARIED', 'MARRIED')
        THEN 'Married'
        
        WHEN MaritalStatus IS NULL
			OR TRIM(MaritalStatus) IN ( 'NA ', 'N/A', 'UNKNOWN') 
            OR TRIM(MaritalStatus) IN ( '?', ' ', '-') 
            THEN 'Missing'
	END;
```


9. 
```sql
/* Cleaning and standardizing 
the Over 18 column
*/
SELECT 
DISTINCT hr_attrition_messy_10000.Over18
FROM hr_attrition_messy_10000;

UPDATE hr_attrition_messy_10000
	SET hr_attrition_messy_10000.Over18 =
CASE
	WHEN trim(Over18)= ' NULL'  THEN 'Yes'
END;

SELECT *
FROM hr_attrition_messy_10000;

```

10. 
```sql

/*"Standardizing mixed and ambiguous date formats into a unified SQL date structure 
using conditional regex pattern matching and logical validation.  "
*/
    
UPDATE hr_attrition_messy_10000
SET hr_attrition_messy_10000.HireDate =
	CASE 
        -- 1. Standard YYYY-MM-DD
        WHEN HireDate REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' 
            THEN STR_TO_DATE(HireDate, '%Y-%m-%d')
            
        -- 2. Text Format: 17-Aug-2015
        WHEN HireDate REGEXP '^[0-9]{2}-[A-Za-z]{3}-[0-9]{4}$'
            THEN STR_TO_DATE(HireDate, '%d-%b-%Y')
            
        --   3. Text Format: December 05, 2019
        WHEN HireDate REGEXP '^[A-Za-z]+ [0-9]{2}, [0-9]{4}$'
            THEN STR_TO_DATE(HireDate, '%M %d, %Y')

        -- 4. Explicit MM/DD/YYYY (Middle number is Day > 12)
        WHEN HireDate REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$' 
             AND CAST(SUBSTRING(HireDate, 4, 2) AS UNSIGNED) > 12
            THEN STR_TO_DATE(HireDate, '%m/%d/%Y')
            
        -- 5. Explicit DD/MM/YYYY (First number is Day > 12)
        WHEN HireDate REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$' 
             AND CAST(SUBSTRING(HireDate, 1, 2) AS UNSIGNED) > 12
            THEN STR_TO_DATE(HireDate, '%d/%m/%Y')
            
        -- 6. Fallback for ambiguous slash dates (e.g., 05/06/2017)
        WHEN HireDate REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'
            THEN STR_TO_DATE(HireDate, '%m/%d/%Y') 
            
        ELSE NULL 
    END;
```

```sql
 /* Cleaning and standardizing 
the MonthlyIncome column
*/
-- 1 - Removing $ sign ',' and '.' 
SELECT 
DISTINCT hr_attrition_messy_10000.MonthlyIncome
FROM hr_attrition_messy_10000;  

UPDATE hr_attrition_messy_10000
SET hr_attrition_messy_10000.MonthlyIncome =
REPLACE
	(REPLACE
		(SUBSTRING_INDEX(MonthlyIncome, '.',1),'$', ''), ',', '');
        
SELECT * 
FROM hr_attrition_messy_10000;
```




</div>