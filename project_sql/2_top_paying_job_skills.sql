/*
Question: What skills are required for the top-paying (role) jobs?
- Use the top 10 highest-paying (role) jobs from query1 
- Add the specific skills required for these roles 
-why? It provides a detailed look at which high-paying jobs demand certin skills,
helping job seekers understand which skills to develop that align with top salaries
*/

-- NOTE: Results show only 6 because some jobs dont have skills listed 
--Option 1: CTE 

WITH top_paying_jobs AS (
    SELECT
        job_postings.job_id,
        job_postings.job_title,
        company_info.name,
        job_postings.salary_year_avg
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
    LIMIT 10
    )

SELECT 
    top_paying_jobs.*,
    skills_dim.skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY top_paying_jobs.salary_year_avg DESC


-- Option 2: Not using subquey/CTE 
SELECT
    job_postings.job_id,
    job_postings.job_title,
    company_info.name,
    job_postings.job_location,
    job_postings.job_schedule_type,
    job_postings.salary_year_avg,
    job_postings.job_posted_date,
    skill_name.skills
FROM 
    job_postings_fact AS job_postings
LEFT JOIN
    company_dim AS company_info ON job_postings.company_id = company_info.company_id
LEFT JOIN 
    skills_job_dim AS job_to_skillid ON job_postings.job_id = job_to_skillid.job_id
LEFT JOIN
    skills_dim AS skill_name ON job_to_skillid.skill_id = skill_name.skill_id
WHERE 
    job_title_short IN ('Business Analyst','Data Analyst') AND
    job_work_from_home = TRUE AND
    salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10;

