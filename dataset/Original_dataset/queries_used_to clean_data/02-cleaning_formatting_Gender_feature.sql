
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


-- UPDATE COLUMN

SET SQL_SAFE_UPDATES = 0;

UPDATE hr_attrition_messy_10000
SET Gender = CASE 
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
    END;

SET SQL_SAFE_UPDATES = 1;