SELECT
    *
FROM 
    job_postings_fact
LIMIT 1000;

SELECT 
    job_posted_date,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST',
    job_posted_date::DATE AS date_column
FROM
    job_postings_fact
LIMIT 1000;

SELECT 
    job_title_short AS title,
    job_location AS location,
    job_posted_date As date
FROM
    job_postings_fact;

SELECT
    job_posted_date
FROM 
    job_postings_fact
LIMIT 1000;
    
SELECT
    COUNT(job_id) AS job_posted_count,
    EXTRACT(MONTH FROM job_posted_date) AS month,
    job_title_short
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY 
    month, 
    job_title_short
ORDER BY
    job_posted_count DESC
;

SELECT 
    AVG(salary_year_avg) AS avg_year_salary,
    AVG(salary_hour_avg) AS avg_hour_salary,
    job_schedule_type
FROM
    job_postings_fact
WHERE
    job_posted_date > '2023-06-01'
GROUP BY
    job_schedule_type;

SELECT 
    EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') AS month,
    COUNT(*) AS job_count,
    COUNT(job_posted_date) AS fresh
FROM
    job_postings_fact
WHERE
    EXTRACT(YEAR FROM job_posted_date) = 2023
GROUP BY month
ORDER BY month;

SELECT 
    *
FROM
    company_dim
LIMIT 100;

SELECT
    c.name AS company_name
FROM
    job_postings_fact AS j
JOIN company_dim AS c
    ON j.company_id = c.company_id
WHERE
    j.job_health_insurance = TRUE
    AND
    EXTRACT(YEAR FROM j.job_posted_date) = 2023
    AND
    EXTRACT(QUARTER FROM j.job_posted_date) = 2;

-- January Job Table
CREATE TABLE january_jobs AS 
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

-- February Job Table
CREATE TABLE february_jobs AS 
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

-- March Job Table
CREATE TABLE March_jobs AS 
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

SELECT 
    *
FROM
    march_jobs


SELECT     
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category,
    COUNT(job_id) AS number_of_jobs
FROM 
    job_postings_fact
WHERE
    job_title_short LIKE 'Data Analyst'
GROUP BY 
    location_category;

SELECT 
    job_id,
    salary_year_avg
FROM
    job_postings_fact
WHERE
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg asc
LIMIT
    1000;

SELECT
    job_title_short,
    salary_year_avg,
    CASE
        WHEN salary_year_avg <= 150000 THEN 'Low'
        WHEN salary_year_avg <= 500000 THEN 'Standard'
        ELSE'High'
    END AS salary_category
FROM
    job_postings_fact
WHERE 
    salary_year_avg IS NOT NULL
LIMIT
    1000;


-- Performing Subqueries on Some Datasets
SELECT *
    FROM
    (SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1) AS january_jobs;

-- Performing CTEs on Some Datasets
 WITH february_jobs AS 
    (SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2
    )

      SELECT *
    FROM february_jobs;


     WITH april_jobs AS 
    (SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 4
    )

    SELECT *
    FROM april_jobs;

-- using a join to resolve same problem from two tables
SELECT
    j.company_id,
    c.name AS company_name
FROM
    job_postings_fact AS j
INNER JOIN company_dim AS c
    ON j.company_id = c.company_id
WHERE
    j.job_no_degree_mention = TRUE;

-- using subqueries

SELECT 
    company_id,
    name AS company_name
FROM company_dim
WHERE company_id IN (
    SELECT 
        company_id
    FROM
        job_postings_fact
    WHERE
        job_no_degree_mention = TRUE
);

WITH company_job_count AS 
(
    SELECT 
        company_id,
        COUNT(*) AS count_all
    FROM
        job_postings_fact
    GROUP BY
        company_id
    ORDER BY
        count_all DESC
    LIMIT 
        1000
)

SELECT 
    name
FROM company_dim

SELECT
    c.name AS company_name,
    COUNT(*) AS total_jobs
FROM
    job_postings_fact AS j
INNER JOIN company_dim AS c
    ON j.company_id = c.company_id
WHERE
    c.name = 'FullStack Labs'
GROUP BY
    company_name
ORDER BY
    total_jobs DESC;

 