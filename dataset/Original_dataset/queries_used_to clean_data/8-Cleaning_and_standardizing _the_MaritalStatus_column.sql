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