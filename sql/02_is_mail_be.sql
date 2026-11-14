
-- Greenweez | SQL User-Defined Functions Analytics
-- Task 1.1: Belgium Email Campaign Classification
-- Database: Google BigQuery (Standard SQL)
--
-- Identify email campaigns targeting Belgium.
-- Campaign names containing "nlbe" are classified as 1;
-- all other campaigns are classified as 0.

-- Step 1: Initial classification using CASE WHEN.

SELECT
    journey_id AS campaign_id,
    journey_name AS campaign_name,
    sent_nb AS emails_sent,
    CASE
        WHEN LOWER(journey_name) LIKE '%nlbe%' THEN 1
        ELSE 0
    END AS mail_be
FROM `project-c980fc5b-d2fc-410c-816.course17.gwz_mail_17`
ORDER BY sent_nb DESC;

-- Step 2: Create a persistent reusable SQL function.

CREATE OR REPLACE FUNCTION
    `project-c980fc5b-d2fc-410c-816.course17.is_mail_be`(
        journey_name STRING
    )
RETURNS INT64
AS (
    CASE
        WHEN LOWER(journey_name) LIKE '%nlbe%' THEN 1
        ELSE 0
    END
);

-- Step 3: Apply the function to email campaign records.

SELECT
    journey_id AS campaign_id,
    journey_name AS campaign_name,
    sent_nb AS emails_sent,
    `project-c980fc5b-d2fc-410c-816.course17.is_mail_be`(
        journey_name
    ) AS mail_be
FROM `project-c980fc5b-d2fc-410c-816.course17.gwz_mail_17`
ORDER BY sent_nb DESC;
