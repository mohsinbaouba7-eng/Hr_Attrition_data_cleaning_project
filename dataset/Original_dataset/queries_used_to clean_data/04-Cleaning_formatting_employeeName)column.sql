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