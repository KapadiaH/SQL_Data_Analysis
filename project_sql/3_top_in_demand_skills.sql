/*
Question: What are the most in-demand skills for data and business analyst 
-Join job postings to inner join table simillar to query 2 
- Identify the top in-demand skills for analyst 
-focus on all job postings 
-Why? Retrives the top 5 skils with the heighest demand in the job market, 
    providing insights into the most valuable skills for job seekers.
 */
-- Option 1 
WITH remote_job_skills AS(
    SELECT
        skill_id,
        COUNT(*) AS skills_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id =  skills_job_dim.job_id
    WHERE job_postings_fact.job_work_from_home= True AND 
        job_postings_fact.job_title_short IN ('Business Analyst','Data Analyst')
    GROUP BY skill_id   
)
SELECT
    remote_job_skills.*,
    skills_dim.skills
FROM remote_job_skills
INNER JOIN skills_dim ON remote_job_skills.skill_id = skills_dim.skill_id
ORDER BY skills_count DESC
LIMIT 5 

-- Option 2 

SELECT
skills,
COUNT(*) AS count_skills
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_postings_fact.job_title_short IN ( 'Business Analyst', 'Data Analyst')
GROUP BY skills
ORDER BY count_skills DESC
LIMIT 10
