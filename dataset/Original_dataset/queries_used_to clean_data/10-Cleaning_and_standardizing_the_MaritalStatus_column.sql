
/* Cleaning and standardizing 
the MaritalStatus column
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