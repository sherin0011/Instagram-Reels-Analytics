# Instagram Reels Analytics Dashboard

## Project Overview

This project analyzes Instagram Reels data using SQL, MySQL, and Power BI.

The goal of this project is to identify popular reel topics, analyze hashtag usage, and create an interactive dashboard for content insights.

---

## Tools Used

- MySQL
- MySQL Workbench
- SQL
- Power BI
- GitHub

---

## Dataset

The dataset contains Instagram Reels information including:

- Reel ID
- Hashtags
- Lemmatized Tags
- Number of Tags
- Topic
- Encoded Topic

Total Records: **3,263 Reels**

---

## Database Structure

### Tables Used

### users
Stores user information.

### categories
Stores content categories.

### content
Stores saved content details.

### content_categories
Maps content to categories with confidence scores.

### reels
Stores Instagram reels dataset.

---

## SQL Concepts Used

- SELECT
- WHERE
- ORDER BY
- GROUP BY
- HAVING
- Aggregate Functions
- JOINs
- Views
- Data Import using LOAD DATA INFILE

---

## Business Questions Answered

### 1. Which topics have the highest number of reels?

```sql
SELECT topic,
       COUNT(*) AS total_reels
FROM reels
GROUP BY topic
ORDER BY total_reels DESC;
```

### 2. Which topics use the most hashtags on average?

```sql
SELECT topic,
       AVG(number_of_tags) AS avg_tags
FROM reels
GROUP BY topic
ORDER BY avg_tags DESC;
```

### 3. What are the Top 5 Reel Topics?

```sql
SELECT topic,
       COUNT(*) AS total_reels
FROM reels
GROUP BY topic
ORDER BY total_reels DESC
LIMIT 5;
```

### 4. Which topics have fewer than 100 reels?

```sql
SELECT topic,
       COUNT(*) AS reels_count
FROM reels
GROUP BY topic
HAVING COUNT(*) < 100;
```

### 5. Find reels related to Fitness

```sql
SELECT *
FROM reels
WHERE hashtags LIKE '%fitness%';
```

---

## View Created

```sql
CREATE VIEW reel_category_summary AS
SELECT topic,
       COUNT(*) AS total_reels,
       AVG(number_of_tags) AS avg_tags
FROM reels
GROUP BY topic;
```

---

## Power BI Dashboard Features

The dashboard includes:

- Reels by Topic (Bar Chart)
- Average Hashtags KPI
- Total Reels KPI
- Topic Distribution (Pie Chart)
- Average Hashtags by Topic
- Topic Filter (Slicer)

---

## Dashboard Preview

![Dashboard](dashboard.jpg)

---

## Key Insights

- Fitness and Education are among the most common reel topics.
- Average hashtags used per reel is approximately 7.54.
- Total reels analyzed: 3,263.
- Different topics show varying hashtag usage patterns.

---

## Project Structure

Instagram-Reels-Analytics/

├── README.md

├── smart_content_organizer.sql

├── Instagram_Reels_Analytics.pbix

├── dashboard.jpg

---

## What I Learned

Through this project, I learned:

- Database design using MySQL
- SQL querying and data analysis
- Data aggregation and reporting
- Creating views
- Building Power BI dashboards
- Publishing projects on GitHub

---

## Future Improvements

- Add CTEs
- Add Window Functions
- Add RANK() Functions
- Add Stored Procedures
- Create advanced Power BI KPIs
- Add trend analysis dashboards

---

## Author

**Sherin Ebadhi H**

B.Tech Computer Science & Engineering

Aspiring Data Analyst

GitHub:
https://github.com/sherin0011
