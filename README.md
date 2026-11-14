# Greenweez | SQL User-Defined Functions Analytics

**SQL Portfolio Project | Google BigQuery | Customer Segmentation, Email Marketing & Delivery Experience Analytics**

## Project Overview

This project demonstrates the development and application of reusable SQL User-Defined Functions (UDFs) in Google BigQuery, using Greenweez training datasets covering email marketing campaigns and customer delivery reviews.

The analysis focuses on transforming raw campaign identifiers, customer satisfaction ratings, and shipping information into structured, business-ready attributes.

By creating persistent SQL functions, the project establishes reusable classification logic that can support consistent reporting, customer experience analysis, campaign segmentation, and commercial decision-making.

### Business Objectives

- Identify email campaigns targeting customers in Belgium.
- Classify email marketing activities into meaningful campaign categories.
- Standardize customer satisfaction ratings using Net Promoter Score (NPS) categories.
- Extract delivery carrier and fulfillment mode information from descriptive shipment fields.
- Improve analytical consistency by replacing repeated conditional logic with reusable SQL functions.
- Prepare structured data for future marketing and logistics performance analysis.

## Technology & Analytical Methods

**Cloud Platform:** Google Cloud Platform  
**Data Warehouse:** Google BigQuery  
**SQL Dialect:** GoogleSQL (Standard SQL)  
**Development Environment:** BigQuery SQL Workspace  
**Version Control:** Git & GitHub

### SQL Techniques

- Persistent SQL User-Defined Functions
- `CREATE OR REPLACE FUNCTION`
- Conditional classification using `CASE WHEN`
- String matching with `LOWER()` and `LIKE`
- Integer and string return types
- NULL handling
- Column aliasing
- Data transformation and feature engineering
- Table creation using `CREATE TABLE AS SELECT`
- Dataset-level function management
- Reusable analytical logic

## Dataset Overview

The project uses two source datasets provided through the Greenweez SQL training environment.

| Dataset | Description | Analytical Focus |
|---|---|---|
| `gwz_mail_17` | Email marketing campaign records | Campaign targeting and segmentation |
| `gwz_nps_17` | Customer delivery review records | Customer satisfaction and delivery classification |

The datasets were copied from the training project into the `course17` dataset within a personal Google BigQuery project.

### Email Campaign Dataset

Relevant fields include:

| Field | Description |
|---|---|
| `journey_id` | Unique campaign journey identifier |
| `journey_name` | Campaign name containing targeting and campaign-type information |
| `sent_nb` | Number of emails sent |

### Customer Delivery Review Dataset

Relevant fields include:

| Field | Description |
|---|---|
| `date_date` | Review record date |
| `orders_id` | Order identifier |
| `transporter` | Delivery carrier and fulfillment mode |
| `global_note` | Customer satisfaction rating on a 0–10 scale |

The source data contains descriptive text fields that can be converted into structured analytical dimensions using SQL functions.

## Repository Structure

```text
greenweez-sql-udf-analytics/
│
├── README.md
│
└── sql/
    ├── 01_data_import.sql
    ├── 02_is_mail_be.sql
    ├── 03_mail_type.sql
    ├── 04_nps_scoring.sql
    └── 05_delivery_classification.sql
```

### SQL Analysis Workflow

| SQL File | Purpose |
|---|---|
| `01_data_import.sql` | Create the analysis dataset and import source tables |
| `02_is_mail_be.sql` | Identify email campaigns targeting Belgium |
| `03_mail_type.sql` | Classify email marketing campaigns |
| `04_nps_scoring.sql` | Convert customer ratings into NPS categories |
| `05_delivery_classification.sql` | Identify delivery carriers and fulfillment modes |

## Analysis 1 — Geographic Email Campaign Classification

**Business Question:** Which email marketing campaigns target customers in Belgium?

A reusable SQL function, `is_mail_be()`, identifies campaigns whose `journey_name` contains the keyword `nlbe`.

### Classification Logic

| Condition | Classification |
|---|---|
| Campaign name contains `nlbe` | `1` |
| Campaign name does not contain `nlbe` | `0` |

**Function:** `is_mail_be(journey_name STRING)`  
**Return Type:** `INT64`

The function uses case-insensitive string matching and returns a binary indicator for geographic campaign segmentation.

### Observed Examples

| Campaign Name | Belgium Indicator |
|---|---:|
| `210829_nlbe_rentreebio_nosto` | 1 |
| `210825_nlbe_feculents_sto` | 1 |
| `210830_nl_reconditionne` | 0 |
| `210706_nl_deuxieme` | 0 |

### Business Value

- Enables consistent identification of Belgium-targeted campaigns.
- Supports geographic segmentation of email marketing activity.
- Simplifies campaign reporting by replacing repeated text searches with a standardized function.
- Creates a reusable targeting attribute for future engagement and campaign performance analysis.

**Key Insight:** Campaign naming conventions can be transformed into structured geographic attributes without manually categorizing each campaign.

## Analysis 2 — Email Campaign Type Classification

**Business Question:** How can different email marketing campaigns be categorized automatically?

A persistent SQL function, `mail_type()`, classifies campaigns according to keywords embedded within their names.

### Classification Rules

| Campaign Type | Matching Keywords |
|---|---|
| `newsletter` | `nl`, including `nlbe` |
| `abandoned_basket` | `panier_abandonne`, `abandoned_basket` |
| `back_in_stock` | `back_in_stock` |

**Function:** `mail_type(journey_name STRING)`  
**Return Type:** `STRING`

The function prioritizes specific behavioral campaign categories before general newsletter classification.

This is particularly important when campaign names contain multiple keywords.

### Observed Examples

| Campaign Name | Classification |
|---|---|
| `210830_nl_reconditionne` | newsletter |
| `crm_relance_panier_abandonne_h2_j1` | abandoned_basket |
| `crm_relance_back_in_stock` | back_in_stock |
| `nlbecrm_relance_back_in_stock` | back_in_stock |

The final example contains both geographic newsletter-related notation and a stock notification keyword. The function prioritizes the more specific campaign type.

Unmatched campaigns return `NULL`.

### Business Value

- Supports campaign-level reporting across different email marketing activities.
- Separates general newsletters from behavioral campaigns.
- Enables future comparisons of campaign reach and engagement.
- Reduces manual classification work and improves reporting consistency.

### Commercial Applications

The standardized campaign categories could support future analysis of:

- Email volume by campaign type
- Campaign performance by geographic segment
- Re-engagement campaigns
- Abandoned basket recovery
- Back-in-stock notifications
- Lifecycle marketing effectiveness

These are potential analytical extensions; the current project implements campaign classification rather than conversion or revenue attribution.

## Analysis 3 — Net Promoter Score Classification

**Business Question:** How can customer satisfaction ratings be converted into standardized categories for analysis?

The project implements the conventional NPS rating groups through a persistent SQL function.

### NPS Classification Logic

| Customer Rating | Customer Category | Function Output |
|---|---|---:|
| 0–6 | Detractor | -1 |
| 7–8 | Passive | 0 |
| 9–10 | Promoter | 1 |

**Function:** `nps(global_note INT64)`  
**Return Type:** `INT64`

The function converts numeric satisfaction ratings into standardized sentiment indicators.

### Observed Examples

| Original Rating | NPS Classification |
|---|---:|
| 4 | -1 |
| 6 | -1 |
| 8 | 0 |
| 9 | 1 |
| 10 | 1 |

NULL values and ratings outside the defined 0–10 range return `NULL`.

### Methodological Clarification

The function calculates a **row-level NPS classification**, not the aggregate NPS percentage.

The conventional overall NPS metric is calculated as:

**NPS = % Promoters − % Detractors**

The standardized values of -1, 0, and 1 can subsequently support aggregate calculations across valid customer ratings.

### Business Value

- Standardizes customer satisfaction classifications.
- Creates reusable attributes for customer experience reporting.
- Supports future comparisons of satisfaction levels across carriers and delivery modes.
- Enables structured analysis of positive, neutral, and negative customer feedback.

**Key Insight:** Reusable SQL functions provide consistent classification rules across customer experience analyses.

## Analysis 4 — Delivery Carrier Classification

**Business Question:** Which logistics company handled each delivery?

The `transporter_brand()` function extracts a standardized carrier name from the original shipment description.

### Carrier Classification

| Transporter Keyword | Carrier |
|---|---|
| `Chrono` | Chrono |
| `DPD` | DPD |

**Function:** `transporter_brand(transporter STRING)`  
**Return Type:** `STRING`

The function uses case-insensitive string matching to identify the carrier.

### Observed Examples

| Original Transporter | Carrier |
|---|---|
| Chrono Pickup | Chrono |
| Chrono Home | Chrono |
| DPD Pickup | DPD |
| DPD Home | DPD |

### Business Value

Carrier classification creates a standardized dimension for logistics reporting and provides a foundation for comparing customer satisfaction across delivery providers.

## Analysis 5 — Delivery Mode Classification

**Business Question:** Was the order delivered to a pickup point or directly to the customer?

The `delivery_mode()` function extracts fulfillment mode information from the same transporter field.

### Delivery Mode Classification

| Transporter Keyword | Delivery Mode |
|---|---|
| `Pickup` | Pickup |
| `Home` | Home |

**Function:** `delivery_mode(transporter STRING)`  
**Return Type:** `STRING`

### Observed Examples

| Original Transporter | Delivery Mode |
|---|---|
| Chrono Pickup | Pickup |
| Chrono Home | Home |
| DPD Pickup | Pickup |
| DPD Home | Home |

### Business Value

- Distinguishes pickup-point deliveries from home deliveries.
- Creates a reusable operational reporting dimension.
- Supports future analysis of customer satisfaction by fulfillment method.
- Enables logistics segmentation without repeated text-processing logic.

## Integrated Customer Experience Dataset

The final SQL query applies three persistent functions to the delivery review dataset:

- `nps()` — Customer satisfaction classification
- `delivery_mode()` — Fulfillment method
- `transporter_brand()` — Delivery provider

### Example Output

| Transporter | Global Note | NPS | Delivery Mode | Transporter Brand |
|---|---:|---:|---|---|
| Chrono Pickup | 10 | 1 | Pickup | Chrono |
| DPD Home | 8 | 0 | Home | DPD |
| Chrono Home | 9 | 1 | Home | Chrono |
| DPD Pickup | 6 | -1 | Pickup | DPD |

These examples illustrate observed combinations in the training dataset rather than a statistical summary of the entire dataset.

The final query preserves the original source columns and adds standardized analytical attributes.

### Analytical Opportunities

The integrated dataset creates a foundation for examining:

- NPS differences between delivery carriers
- Satisfaction across pickup and home delivery
- Distribution of promoters, passives, and detractors
- Customer experience trends over time
- Operational segments requiring further investigation

The current project implements the required data transformations. It does not establish causal relationships between delivery methods and customer satisfaction.

## Key Business Insights

### 1. Campaign Naming Conventions Enable Automated Segmentation

The email campaign dataset contains meaningful information embedded in journey names.

Reusable SQL functions convert this information into explicit geographic and campaign-type dimensions.

### 2. Specific Classification Rules Prevent Mislabeling

Some campaign names contain overlapping keywords.

Prioritizing behavioral campaign types before newsletters helps preserve the intended classification.

### 3. Customer Satisfaction Can Be Standardized Across Records

Converting raw customer ratings into NPS categories enables a consistent foundation for customer experience analysis.

### 4. Delivery Information Can Be Separated into Independent Dimensions

The original transporter field contains both carrier identity and fulfillment mode.

Extracting these dimensions independently improves the structure and analytical usability of the dataset.

### 5. Persistent Functions Improve Analytical Reusability

Storing classification logic in BigQuery allows multiple queries to reference the same definitions without rewriting complex conditional expressions.

This supports maintainability, consistency, and future analytical development.

## Business Recommendations

**Marketing Analytics**

Use standardized campaign categories and geographic indicators to support more granular campaign performance reporting.

**Customer Experience**

Incorporate NPS classifications into recurring customer satisfaction monitoring and investigate patterns across operational segments.

**Logistics Analytics**

Use delivery provider and fulfillment mode dimensions to build comparative customer experience reports.

**Data Governance**

Maintain documented classification rules and validate them periodically as new campaign naming conventions and transporter labels appear.

**Reporting & Automation**

Reuse persistent SQL functions in downstream reporting workflows to reduce duplicated logic and improve consistency.

## Methodology & Limitations

The project focuses on SQL function development and feature engineering using training datasets.

Important considerations include:

- The analysis is based on available training records and their existing naming conventions.
- Email campaign classifications rely on keyword matching.
- Belgium targeting is identified by the `nlbe` naming convention rather than independently verified recipient geography.
- Overlapping email campaign keywords require explicit classification priority.
- Campaigns without matching keywords can return `NULL`.
- NPS classifications are row-level indicators, not overall NPS percentage calculations.
- Missing or invalid satisfaction ratings are not assigned a valid NPS category.
- Carrier and delivery mode classification depends on recognizable text patterns.
- Carrier performance comparisons require additional statistical aggregation and contextual analysis.
- No campaign revenue, conversion uplift, or carrier performance improvement is attributed to the transformations performed in this project.

These limitations help distinguish the implemented SQL transformations from potential future business analyses.

## How to Run

### Prerequisites

- Access to Google BigQuery
- Permission to create tables and persistent SQL functions
- Access to the referenced Greenweez training datasets
- A target dataset in the appropriate BigQuery region

### Execution Order

1. Run `sql/01_data_import.sql` to create the analysis dataset and copy the source tables.
2. Run `sql/02_is_mail_be.sql` to create the Belgium campaign classification function.
3. Run `sql/03_mail_type.sql` to create the campaign-type classification function.
4. Run `sql/04_nps_scoring.sql` to create the NPS classification function.
5. Run `sql/05_delivery_classification.sql` to create the delivery carrier and fulfillment mode functions and apply all three NPS-related functions.

### Configuration

The SQL scripts reference the original BigQuery project and dataset identifiers used during development.

For execution in another environment, update the project IDs and dataset references to match the target configuration.

All five persistent functions are stored in the BigQuery `course17` dataset and can be reused in subsequent analytical queries.

## Skills Demonstrated

- Google BigQuery SQL development
- Persistent SQL User-Defined Functions
- Marketing data transformation and segmentation
- Customer satisfaction and NPS classification
- Logistics data standardization
- String manipulation and conditional logic
- Reusable business logic development
- Data preparation for downstream reporting
- Business-oriented analytical thinking
- Technical documentation and version control

## Author

**Nagehan Bas**
