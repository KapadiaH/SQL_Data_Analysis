/* Query 1 Task: What are the top-paying jobs/postings for my role?
    Selecteed role : Business Analyst, Data Analyst
    - Identify the 10 highest-paying (role=Business Analyst) that are available remotely.
    - Focuses on job postings with specified salaries( remove nulls).
    -Why? Highlight the top-paying opportunities for (role), offering insights into 
*/ 

SELECT
    job_postings.job_id,
    job_postings.job_title,
    company_info.name,
    job_postings.job_location,
    job_postings.job_schedule_type,
    job_postings.salary_year_avg,
    job_postings.job_posted_date
FROM 
    job_postings_fact AS job_postings
LEFT JOIN
    company_dim AS company_info
ON 
    job_postings.company_id = company_info.company_id
WHERE 
    job_title_short IN ('Business Analyst','Data Analyst') AND
    job_work_from_home = TRUE AND
    salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10;

