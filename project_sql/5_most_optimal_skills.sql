/*
Answer: What are the most optimal skills to learn(aka it's in high demand and a high-paying skill)?
- Identify the skills in high demand and associated with high average salaries for Analysts roles 
- Concentrates on remote postitions with specified salaries 
-Why? Targets skills that offer job security(high demand) and financial benefits (high salaries),
offering strategic insights for career development in data analytics
*/
WITH skills_demand AS(
    SELECT
    skills_dim.skill_id,
    skills,
    COUNT(*) AS count_skills
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE job_postings_fact.job_title_short IN ( 'Business Analyst', 'Data Analyst') AND 
    salary_year_avg IS NOT NULL
    GROUP BY skills_dim.skill_id
    
),avg_salary AS(
    SELECT
    skills_dim.skill_id,
    skills,
    ROUND(AVG(salary_year_avg),0) AS avg_salary_year
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE job_postings_fact.job_title_short IN ( 'Business Analyst', 'Data Analyst') AND
    job_postings_fact.salary_year_avg IS NOT NULL
    GROUP BY skills_dim.skill_id
    
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    count_skills,
    avg_salary_year

FROM skills_demand
INNER JOIN avg_salary ON skills_demand.skill_id = avg_salary.skill_id
WHERE count_skills >10 
ORDER BY avg_salary_year DESC,count_skills DESC
