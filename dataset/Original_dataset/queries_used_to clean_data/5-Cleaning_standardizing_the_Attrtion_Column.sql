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