/* FULL CLEANING DATA TO GET IT READY FOR ANALYSIS

 Our mission here is:
1- Create database ;
2- Create the table via uploading the DATA ;
3- Clean the data and standardize Data to get it ready for analysis.
*/
-- 1- Creeate DATABASE 
CREATE database Hr_Attrition;


-- III -  Attrition coloumn 

-- A- ADD NEW COLUMN "ATTRITON_Y_N"

ALTER TABLE hr_attrition_messy_10000
ADD COLUMN  Attrition_Y_N INT;

SELECT *
FROM hr_attrition_messy_10000;

-- B- UPDATING THE COLUMN AND TURN TO A NUMERICAL VALUE 'YES = 1 ' , 'NO = 0 '

SET SQL_SAFE_UPDATES = 0;

UPDATE hr_attrition_messy_10000
SET Attrition_Y_N = CASE
	WHEN hr_attrition_messy_10000.Attrition = 'YES' THEN 1
    WHEN hr_attrition_messy_10000.Attrition = 'No' THEN 0
    END;
    
 


    
    
