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