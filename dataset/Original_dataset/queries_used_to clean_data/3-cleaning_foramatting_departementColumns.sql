
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
