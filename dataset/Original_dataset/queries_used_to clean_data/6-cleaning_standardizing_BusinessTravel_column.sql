/* Cleaning and standardizing the
 BusinessTravel column
*/
SELECT 
DISTINCT hr_attrition_messy_10000.BusinessTravel
FROM hr_attrition_messy_10000;

UPDATE	hr_attrition_messy_10000
SET BusinessTravel = CASE
		WHEN TRIM(UPPER(BusinessTravel)) IN ('T', 'TRAVEL_RARELY', 'TRAVEL RARELY')
        THEN 'Travel Rarely'
        WHEN TRIM(UPPER(BusinessTravel)) IN ('T', 'TRAVEL_FREQUENTLY', 'TRAVEL FREQUENTLY')
        THEN 'Travel Frequently'
        WHEN TRIM(UPPER(BusinessTravel)) IN ('N', 'NON-TRAVEL', 'NO TRAVEL')
        THEN 'No Travel'
        
        WHEN BusinessTravel IS NULL
			OR TRIM(BusinessTravel) IN ( 'NA ', 'N/A', 'UNKNOWN')
            OR TRIM(BusinessTravel) IN ( '?', ' ', '-') THEN 'Missing'
	END;