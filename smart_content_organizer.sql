-- ==========================================
-- DATABASE CREATION
-- ==========================================

CREATE DATABASE smart_content_organizer;
USE smart_content_organizer;

-- ==========================================
-- TABLES
-- ==========================================

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50),
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT
);

CREATE TABLE content (
    content_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    caption TEXT,
    hashtags TEXT,
    source_platform VARCHAR(30),
    date_saved TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE content_categories (
    content_id INT,
    category_id INT,
    confidence_score DECIMAL(5,4),
    PRIMARY KEY (content_id, category_id),
    FOREIGN KEY (content_id) REFERENCES content(content_id),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- ==========================================
-- SAMPLE DATA
-- ==========================================

INSERT INTO categories (category_name, description)
VALUES
('Workout', 'Fitness and exercise content'),
('Rain', 'Rain and nature related content'),
('Music', 'Songs and music videos'),
('Travel', 'Travel and tourism content'),
('Food', 'Food and cooking content'),
('Education', 'Learning and educational content'),
('Gaming', 'Gaming and esports content'),
('Career', 'Career and professional growth');

INSERT INTO users (username, email)
VALUES ('Sherin', 'sherin@example.com');

INSERT INTO content (
    user_id,
    caption,
    hashtags,
    source_platform
)
VALUES (
    1,
    'Morning workout in Kerala rain',
    '#workout #fitness #rain',
    'Instagram'
);

INSERT INTO content_categories
(content_id, category_id, confidence_score)
VALUES
(1, 1, 0.95),
(1, 2, 0.87);

-- ==========================================
-- RELATIONAL QUERY (JOIN)
-- ==========================================

SELECT
    c.content_id,
    c.caption,
    cat.category_name,
    cc.confidence_score
FROM content c
JOIN content_categories cc
    ON c.content_id = cc.content_id
JOIN categories cat
    ON cc.category_id = cat.category_id;

-- ==========================================
-- REELS TABLE
-- ==========================================

CREATE TABLE reels (
    reel_id INT AUTO_INCREMENT PRIMARY KEY,
    hashtags TEXT,
    lemmatized_tags TEXT,
    number_of_tags INT,
    topic VARCHAR(100),
    encoded_topic INT
);

SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'C:/Users/ebadh/Downloads/reels.csv'
INTO TABLE reels
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(hashtags, lemmatized_tags, number_of_tags, topic, encoded_topic);

-- ==========================================
-- BASIC ANALYSIS
-- ==========================================

SELECT COUNT(*) AS total_reels
FROM reels;

SELECT *
FROM reels
LIMIT 10;

SELECT
    topic,
    COUNT(*) AS total_reels
FROM reels
GROUP BY topic
ORDER BY total_reels DESC;

SELECT
    topic,
    AVG(number_of_tags) AS avg_tags
FROM reels
GROUP BY topic
ORDER BY avg_tags DESC;

SELECT
    topic,
    COUNT(*) AS total_reels
FROM reels
GROUP BY topic
ORDER BY total_reels DESC
LIMIT 5;

SELECT *
FROM reels
WHERE topic = 'Technology';

SELECT *
FROM reels
WHERE hashtags LIKE '%fitness%';

SELECT
    topic,
    COUNT(*) AS reels_count
FROM reels
GROUP BY topic
HAVING COUNT(*) < 100;

-- ==========================================
-- VIEW
-- ==========================================

CREATE VIEW reel_category_summary AS
SELECT
    topic,
    COUNT(*) AS total_reels,
    AVG(number_of_tags) AS avg_tags
FROM reels
GROUP BY topic;

SELECT *
FROM reel_category_summary;

-- ==========================================
-- SUBQUERY
-- ==========================================

SELECT *
FROM reels
WHERE number_of_tags >
(
    SELECT AVG(number_of_tags)
    FROM reels
);

-- ==========================================
-- CTE
-- ==========================================

WITH topic_stats AS
(
    SELECT
        topic,
        COUNT(*) AS total_reels
    FROM reels
    GROUP BY topic
)
SELECT *
FROM topic_stats
WHERE total_reels > 100;

-- ==========================================
-- WINDOW FUNCTION
-- ==========================================

SELECT
    topic,
    COUNT(*) AS total_reels,
    SUM(COUNT(*)) OVER() AS grand_total_reels
FROM reels
GROUP BY topic;

-- ==========================================
-- RANK
-- ==========================================

SELECT
    topic,
    COUNT(*) AS total_reels,
    RANK() OVER(
        ORDER BY COUNT(*) DESC
    ) AS topic_rank
FROM reels
GROUP BY topic;

-- ==========================================
-- ADVANCED ANALYSIS
-- ==========================================

SELECT
    topic,
    COUNT(*) AS total_reels,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER(),
        2
    ) AS percentage_share
FROM reels
GROUP BY topic
ORDER BY total_reels DESC;

WITH topic_ranking AS
(
    SELECT
        topic,
        COUNT(*) AS total_reels,
        RANK() OVER(
            ORDER BY COUNT(*) DESC
        ) AS rank_no
    FROM reels
    GROUP BY topic
)
SELECT *
FROM topic_ranking
WHERE rank_no <= 5;

WITH topic_counts AS
(
    SELECT
        topic,
        COUNT(*) AS total_reels
    FROM reels
    GROUP BY topic
)
SELECT *
FROM topic_counts
WHERE total_reels >
(
    SELECT AVG(total_reels)
    FROM topic_counts
);

SELECT
    topic,
    AVG(number_of_tags) AS avg_hashtags
FROM reels
GROUP BY topic
ORDER BY avg_hashtags DESC
LIMIT 5;

SELECT
    topic,
    COUNT(*) AS total_reels,
    DENSE_RANK() OVER(
        ORDER BY COUNT(*) DESC
    ) AS dense_rank_no
FROM reels
GROUP BY topic;

-- ==========================================
-- DATE FUNCTIONS
-- ==========================================

SELECT
    DATE(date_saved) AS save_date,
    COUNT(*) AS total_content
FROM content
GROUP BY DATE(date_saved);

SELECT
    MONTH(date_saved) AS month_number,
    COUNT(*) AS total_content
FROM content
GROUP BY MONTH(date_saved);

-- ==========================================
-- STORED PROCEDURE
-- ==========================================

DELIMITER //

CREATE PROCEDURE GetTopTopics(
    IN top_n INT
)
BEGIN

    SELECT
        topic,
        COUNT(*) AS total_reels
    FROM reels
    GROUP BY topic
    ORDER BY total_reels DESC
    LIMIT top_n;

END //

DELIMITER ;

CALL GetTopTopics(5);