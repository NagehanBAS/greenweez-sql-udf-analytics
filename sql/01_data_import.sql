
-- Greenweez | SQL User-Defined Functions Analytics
-- Task 1: Dataset Setup and Data Import
-- Database: Google BigQuery (Standard SQL)
--
-- Create the course17 dataset and import the email campaign
-- and delivery review datasets from the training project.

-- Step 1: Create the target dataset in the EU region.

CREATE SCHEMA IF NOT EXISTS
  `project-c980fc5b-d2fc-410c-816.course17`
OPTIONS(location = 'EU');

-- Step 2: Import email campaign data.

CREATE TABLE IF NOT EXISTS
  `project-c980fc5b-d2fc-410c-816.course17.gwz_mail_17`
AS
SELECT *
FROM `data-analytics-469406.course17.gwz_mail_17`;

-- Step 3: Import NPS and delivery review data.

CREATE TABLE IF NOT EXISTS
  `project-c980fc5b-d2fc-410c-816.course17.gwz_nps_17`
AS
SELECT *
FROM `data-analytics-469406.course17.gwz_nps_17`;

-- Step 4: Verify imported record counts.

SELECT COUNT(*) AS total_mail_records
FROM `project-c980fc5b-d2fc-410c-816.course17.gwz_mail_17`;

SELECT COUNT(*) AS total_nps_records
FROM `project-c980fc5b-d2fc-410c-816.course17.gwz_nps_17`;
