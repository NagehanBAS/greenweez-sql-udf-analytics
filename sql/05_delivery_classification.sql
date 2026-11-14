
-- Greenweez | SQL User-Defined Functions Analytics
-- Task 2.2: Delivery Carrier and Mode Classification
-- Database: Google BigQuery (Standard SQL)
--
-- Create reusable functions to extract:
-- 1. Delivery carrier: Chrono or DPD
-- 2. Delivery mode: Pickup or Home
--
-- Apply both functions alongside the previously created NPS
-- classification function to the delivery review dataset.

-- Step 1: Create the persistent carrier classification function.

CREATE OR REPLACE FUNCTION
    `project-c980fc5b-d2fc-410c-816.course17.transporter_brand`(
        transporter STRING
    )
RETURNS STRING
AS (
    CASE
        WHEN LOWER(transporter) LIKE '%chrono%' THEN 'Chrono'
        WHEN LOWER(transporter) LIKE '%dpd%' THEN 'DPD'
        ELSE NULL
    END
);

-- Step 2: Create the persistent delivery mode classification function.

CREATE OR REPLACE FUNCTION
    `project-c980fc5b-d2fc-410c-816.course17.delivery_mode`(
        transporter STRING
    )
RETURNS STRING
AS (
    CASE
        WHEN LOWER(transporter) LIKE '%pickup%' THEN 'Pickup'
        WHEN LOWER(transporter) LIKE '%home%' THEN 'Home'
        ELSE NULL
    END
);

-- Step 3: Apply the NPS, carrier, and delivery mode functions.

SELECT
    *,
    `project-c980fc5b-d2fc-410c-816.course17.nps`(
        global_note
    ) AS nps,
    `project-c980fc5b-d2fc-410c-816.course17.delivery_mode`(
        transporter
    ) AS delivery_mode,
    `project-c980fc5b-d2fc-410c-816.course17.transporter_brand`(
        transporter
    ) AS transporter_brand
FROM `project-c980fc5b-d2fc-410c-816.course17.gwz_nps_17`
ORDER BY date_date, orders_id;
