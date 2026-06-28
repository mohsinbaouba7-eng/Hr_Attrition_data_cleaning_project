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