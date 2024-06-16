# Introduction 
📊 Exploring the Data Job Market! This project delves into Business & Data Analyst roles, highlighting 💰 top-paying jobs, 🔥 in-demand skills, and 📈 the intersection of high demand and high salary in data analytics.

🔍 Interested in SQL queries? Check them out here: [project_sql](/project_sql/)
# Background

The goal of this project was to explore and analyze the data analytics job market more effectively. I embarked on this project to identify top-paid and in-demand skills for both Business & Data Analysts. 

The datasets for this project comes from a comprehensive SQL course. It is rich with insights on job titles, salaries, locations, and essential skills of the year 2023.

The SQL queries I used aimed to answer these key questions:
- What are the top-paying data/business analyst jobs?
- What skills are required for these top-paying jobs?
- What skills are most in demand for data/business analysts?
- Which skills are associated with higher salaries?
- What are the most optimal skills to learn?
# Tools I Used 
For my in-depth exploration of the data analytics job market, I utilized several key tools:

- **SQL**: The backbone of my analysis, enabling me to query the database and uncover critical insights.
- **PostgreSQL**: My preferred database management system, ideal for managing job posting data.
- **Visual Studio Code**: My go-to for managing databases and executing SQL queries.
- **Git & GitHub**: Crucial for version control and sharing my SQL scripts and analyses, facilitating collaboration and project tracking.
# The Analysis 
Each query for this project aimed at investigating specific aspects of the data analytics job market. Here’s how I approached each question:

### 1. Top Paying Data Analyst Jobs

I filtered data/business analyst positions based on average yearly salary and location, prioritizing remote roles, to pinpoint the highest-paying opportunities in the field. This query underscores the lucrative prospects available.

``` sql
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
```
- Wide Salary Range: The top 10 paying data & business analyst roles span from $200,000 to $650,000, indicating significant salary potential in the field.

- Diverse Employers:Companies like Mantys, Meta, and AT&T are among those offering high salaries, showing a broad interest across different industries.

- Job Title Variety:There's a high diversity in job titles, from Data Analyst to Director of Analytics, reflecting varied roles and specializations within data analytics

![Top paying companies](https://github.com/KapadiaH/SQL_Data_Analysis/blob/main/Assets/q1a.png)
### 2. Skills for Top Paying Jobs

To discern the skills needed for top-paying jobs, I joined job postings with skills data, offering insights into the competencies highly valued by employers for high-compensation roles.

```sql
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
```

- SQL is leading with a bold count of 8.
- Python follows closely with a bold count of 7.
- Tableau is also highly sought after, with a bold count of 6.
- Other skills like R, Snowflake, Pandas, and Excel show varying degrees of demand.

![top skills](https://github.com/KapadiaH/SQL_Data_Analysis/blob/main/Assets/q2.png)

### 3. In-Demand Skills for Data Analysts

This query helped identify the most sought-after skills in job postings for data analysts, directing attention to areas with significant demand.

```sql
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
```


### 4. Skills Based on Salary
Exploring the average salaries associated with different skills revealed which skills are the highest paying.

```sql
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
```
Here are the trends summarized into three key points:

1. **Specialized Skills in High Demand**: Top-paying jobs require expertise in niche areas like version control (SVN), blockchain (Solidity), and big data technologies (Couchbase, Kafka, Cassandra).

2. **Machine Learning and AI Proficiency**: High salaries are associated with skills in machine learning and AI tools, including DataRobot, Keras, PyTorch, Hugging Face, and TensorFlow.

3. **DevOps, Cloud, and Automation**: Strong demand exists for skills in DevOps (Puppet, Terraform, Airflow), cloud technologies, and automation, highlighting the need for efficient and scalable IT operations.*/

### 5. Most Optimal Skills to Learn

By combining insights from demand and salary data, this query aimed to identify skills that are not only highly sought-after but also command high salaries, providing a strategic direction for skill development.

```sql
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
LIMIT 25
```
# What I Learned 

During this journey, I've significantly enhanced my SQL toolkit with advanced skills:

🧩 Complex Query Crafting: I've mastered advanced SQL techniques, expertly merging tables and using WITH clauses for sophisticated temporary table operations.

📊 Data Aggregation: I've become proficient with GROUP BY and effectively utilized aggregate functions like COUNT() and AVG() to summarize data.

💡 Analytical Expertise: I've sharpened my ability to solve real-world puzzles, transforming questions into actionable insights through SQL queries.
# Conclusions

This project has not only advanced my SQL skills but also offered valuable insights into the data analyst job market. The analysis findings serve as a roadmap for prioritizing skill development and job search strategies.  This exploration underscores the significance of ongoing learning and adapting to evolving trends in the field of data analytics.
