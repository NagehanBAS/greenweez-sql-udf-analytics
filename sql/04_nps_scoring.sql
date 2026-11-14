
-- Greenweez | SQL User-Defined Functions Analytics
-- Task 2.1: Net Promoter Score (NPS) Classification
-- Database: Google BigQuery (Standard SQL)
--
-- Classify delivery review scores:
-- 0–6: Detractor (-1)
-- 7–8: Passive (0)
-- 9–10: Promoter (1)
-- NULL or out-of-range values remain NULL.

-- Step 1: Initial classification using CASE WHEN.

SELECT
    date_date,
    orders_id,
    transporter,
    global_note,
    CASE
        WHEN global_note BETWEEN 0 AND 6 THEN -1
        WHEN global_note BETWEEN 7 AND 8 THEN 0
        WHEN global_note BETWEEN 9 AND 10 THEN 1
        ELSE NULL
    END AS nps
FROM `project-c980fc5b-d2fc-410c-816.course17.gwz_nps_17`
ORDER BY date_date, orders_id;

-- Step 2: Create the persistent NPS function.

CREATE OR REPLACE FUNCTION
    `project-c980fc5b-d2fc-410c-816.course17.nps`(
        global_note INT64
    )
RETURNS INT64
AS (
    CASE
        WHEN global_note BETWEEN 0 AND 6 THEN -1
        WHEN global_note BETWEEN 7 AND 8 THEN 0
        WHEN global_note BETWEEN 9 AND 10 THEN 1
        ELSE NULL
    END
);

-- Step 3: Apply the function to all delivery reviews.

SELECT
    *,
    `project-c980fc5b-d2fc-410c-816.course17.nps`(
        global_note
    ) AS nps
FROM `project-c980fc5b-d2fc-410c-816.course17.gwz_nps_17`
ORDER BY date_date, orders_id;
