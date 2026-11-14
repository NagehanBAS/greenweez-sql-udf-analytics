
-- Greenweez | SQL User-Defined Functions Analytics
-- Task 1.2: Email Campaign Type Classification
-- Database: Google BigQuery (Standard SQL)
--
-- Classify campaigns as newsletter, abandoned_basket,
-- or back_in_stock based on their journey names.
-- Check specific campaign types before newsletter
-- to avoid misclassifying "nlbe" CRM campaigns.

-- Step 1: Create the persistent classification function.

CREATE OR REPLACE FUNCTION
    `project-c980fc5b-d2fc-410c-816.course17.mail_type`(
        journey_name STRING
    )
RETURNS STRING
AS (
    CASE
        WHEN LOWER(journey_name) LIKE '%back_in_stock%'
            THEN 'back_in_stock'
        WHEN LOWER(journey_name) LIKE '%panier_abandonne%'
          OR LOWER(journey_name) LIKE '%abandoned_basket%'
            THEN 'abandoned_basket'
        WHEN LOWER(journey_name) LIKE '%nl%'
            THEN 'newsletter'
        ELSE NULL
    END
);

-- Step 2: Apply the function to all email campaigns.

SELECT
    *,
    `project-c980fc5b-d2fc-410c-816.course17.mail_type`(
        journey_name
    ) AS mail_type
FROM `project-c980fc5b-d2fc-410c-816.course17.gwz_mail_17`
ORDER BY sent_nb DESC;
