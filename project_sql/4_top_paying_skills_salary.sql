/*
Answer: What are the top skills based on salary?
-Look at the average salary associated with each skil for Data/Business Analyst positions 
- Focuses on roles with specified salaries, regardless of location 
-Why? It reveals how different skills impact salary levels of Analyst and 
helps identify the most financially rewarding skills to acquire or improve
*/ 




SELECT
skills,
ROUND(AVG(salary_year_avg),0) AS avg_salary_year
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_postings_fact.job_title_short IN ( 'Business Analyst', 'Data Analyst') AND
job_postings_fact.salary_year_avg IS NOT NULL
GROUP BY skills
ORDER BY 
    avg_salary_year DESC
LIMIT 25

/*
Here are the trends summarized into three key points:

1. **Specialized Skills in High Demand**: Top-paying jobs require expertise in niche areas like version control (SVN), blockchain (Solidity), and big data technologies (Couchbase, Kafka, Cassandra).

2. **Machine Learning and AI Proficiency**: High salaries are associated with skills in machine learning and AI tools, including DataRobot, Keras, PyTorch, Hugging Face, and TensorFlow.

3. **DevOps, Cloud, and Automation**: Strong demand exists for skills in DevOps (Puppet, Terraform, Airflow), cloud technologies, and automation, highlighting the need for efficient and scalable IT operations.*/