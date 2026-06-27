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