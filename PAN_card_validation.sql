--- PAN Number validation project using SQL ---

CREATE TABLE stg_pan_number_dataset
(
	pan_number	text
);

SELECT * FROM stg_pan_number_dataset;

--- Identify and handle missing data:
SELECT * FROM stg_pan_number_dataset WHERE pan_number IS NULL;

--- Check for duplicates:
SELECT pan_number, COUNT(pan_number) FROM stg_pan_number_dataset
GROUP BY pan_number
HAVING COUNT(pan_number) > 1;

--- Handle leading/trailing spaces:
SELECT * FROM stg_pan_number_dataset WHERE pan_number <> TRIM(pan_number);

--- Correct letter case:
SELECT * FROM stg_pan_number_dataset WHERE pan_number <> UPPER(pan_number);


--- Cleaned PAN Numbers:
SELECT DISTINCT UPPER(TRIM(pan_number)) as pan_number
FROM stg_pan_number_dataset 
WHERE pan_number IS NOT NULL
AND TRIM(pan_number) <> '';


--- Function to check adjacent characters are the same --- WUFAR0132H ==> WUFAR
CREATE OR REPLACE FUNCTION fn_check_adjacent_characters(p_str text)
RETURNS boolean
LANGUAGE plpgsql
as $$
BEGIN
	for i in 1..(length(p_str)-1)
	loop
		if SUBSTRING(p_str, i, 1) = SUBSTRING(p_str, i+1, 1)
		then 
			RETURN TRUE;	--- The characters are adjacent
		end if;
	end loop;
	RETURN FALSE;	--- None of the characters adjacent to each other were the same
END;
$$
--- So here the rule is:
	"
		- Condition TRUE -> exit function immediately with RETURN TRUE.	
		- Condition FALSE -> continue the loop, check next pair.	
		- All checked, no match -> finally RETURN FALSE.
	"

SELECT fn_check_adjacent_characters('WUFAR');


--- Function to check sequential characters are the same --- ABCDE
CREATE OR REPLACE FUNCTION fn_check_sequential_characters(p_str text)
RETURNS boolean
LANGUAGE plpgsql
as $$
BEGIN
	for i in 1..(length(p_str)-1)
	loop
		if ASCII(SUBSTRING(p_str, i+1, 1)) - ASCII(SUBSTRING(p_str, i, 1)) <> 1
		then 
			RETURN FALSE;	--- String doesnot form the sequence
		end if;
	end loop;
	RETURN TRUE;	--- The string is forming sequence
END;
$$

--- So here the rule is:
	"
		- Condition TRUE -> exit function immediately with RETURN FALSE.
		- Condition FALSE -> continue the loop, check next pair.
		- All checked, no sequence break -> finally RETURN TRUE.

	"

SELECT fn_check_sequential_characters('ABCXE');


--- Regular expression to validate pattern or structure of pan numbers ==> AAAAA1234Z
SELECT * 
FROM stg_pan_number_dataset
WHERE pan_number ~ '^[A-Z]{5}[0-9]{4}[A-Z]$';


--- Valid and Invalid PAN Number catagorizations:

CREATE OR REPLACE VIEW vw_valid_invalid_pans as
WITH cte_cleaned_pan as
		(SELECT DISTINCT UPPER(TRIM(pan_number)) as pan_number
		FROM stg_pan_number_dataset 
		WHERE pan_number IS NOT NULL
		AND TRIM(pan_number) <> ''),
	cte_valid_pans as 
		(SELECT * 
		FROM cte_cleaned_pan
		WHERE fn_check_adjacent_characters(pan_number) = FALSE
		AND fn_check_sequential_characters(SUBSTRING(pan_number, 1, 5)) = FALSE
		AND fn_check_sequential_characters(SUBSTRING(pan_number, 6, 4)) = FALSE
		AND pan_number ~ '^[A-Z]{5}[0-9]{4}[A-Z]$')
SELECT cln.pan_number,
CASE WHEN vld.pan_number is NOT NULL THEN 'Valid PAN' ELSE 'Invalid PAN' END as Status
FROM cte_cleaned_pan cln LEFT JOIN cte_valid_pans vld ON vld.pan_number = cln.pan_number;

SELECT * FROM vw_valid_invalid_pans;


--- Summary report
WITH cte as 
	(SELECT
		(SELECT COUNT(*) FROM stg_pan_number_dataset) as total_processed_records,
		COUNT(*) FILTER(WHERE status = 'Valid PAN') as total_valid_pans,
		COUNT(*) FILTER(WHERE status = 'Invalid PAN') as total_invalid_pans
	FROM vw_valid_invalid_pans)
SELECT 
	total_processed_records, 
	total_valid_pans, 
	total_invalid_pans, 
	total_processed_records - (total_valid_pans + total_invalid_pans ) as total_missing_pans
FROM cte;










