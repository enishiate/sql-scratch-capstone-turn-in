--Columns available in quiz data
SELECT *
FROM survey
LIMIT 10;


--Drop-off from question to question
SELECT question, COUNT(*) AS 'completed_answers'
FROM survey
	GROUP BY question;


--Example data in the quiz, home_try_on, and purchase tables
SELECT *
FROM quiz
LIMIT 5;

SELECT *
FROM home_try_on
LIMIT 5;

SELECT *
FROM purchase
LIMIT 5;

--Funnel usage
WITH funnels AS (
  SELECT quiz.user_id,
    CASE
      WHEN home_try_on.user_id IS NOT NULL THEN 'True'
      ELSE 'False'
    END AS is_home_try_on,
    ROUND(home_try_on.number_of_pairs, 0) AS 'number_of_pairs',
    CASE
      WHEN purchase.user_id IS NOT NULL THEN 'True'
      ELSE 'False'
    END AS is_purchase
  FROM quiz
  LEFT JOIN home_try_on
    ON quiz.user_id = home_try_on.user_id
  LEFT JOIN purchase
    ON home_try_on.user_id = purchase.user_id
  GROUP BY quiz.user_id
)

--Total conversions
SELECT COUNT(*) AS 'total_users',
	SUM (
  	CASE
    	WHEN is_home_try_on = 'True' THEN 1
    	ELSE 0
    END) AS 'tried_on',
  SUM (
  	CASE
    	WHEN is_purchase = 'True' THEN 1
    	ELSE 0
  	END) as 'purchased'
FROM funnels;

-- Funnel analysis of 3 pairs vs 5 pairs
WITH funnels AS (
  SELECT quiz.user_id,
    CASE
      WHEN home_try_on.user_id IS NOT NULL THEN 'True'
      ELSE 'False'
    END AS is_home_try_on,
    ROUND(home_try_on.number_of_pairs, 0) AS 'number_of_pairs',
    CASE
      WHEN purchase.user_id IS NOT NULL THEN 'True'
      ELSE 'False'
    END AS is_purchase
  FROM quiz
  LEFT JOIN home_try_on
    ON quiz.user_id = home_try_on.user_id
  LEFT JOIN purchase
    ON home_try_on.user_id = purchase.user_id
  GROUP BY quiz.user_id
)SELECT SUM(
    CASE
      WHEN (number_of_pairs = 3) THEN 1
      ELSE 0
    END) AS '3_pairs_try_on',
    SUM(
      CASE
        WHEN (number_of_pairs = 3
             AND is_purchase = 'True') THEN 1
        ELSE 0
      END) AS '3_pairs_purchase',
    SUM(
      CASE
        WHEN (number_of_pairs = 5) THEN 1
        ELSE 0
      END) AS '5_pairs_try_on',
		SUM(
      CASE
        WHEN (number_of_pairs = 5
             AND is_purchase = 'True') THEN 1
        ELSE 0
      END) AS '5_pairs_purchase'
FROM funnels;

--Purchases by style
SELECT style,
	COUNT(*) AS 'Total',
	SUM(
    CASE
      WHEN price = '50' THEN 1
      ELSE 0
    END) AS '$50',
  SUM(
    CASE
      WHEN price = '95' THEN 1
      ELSE 0
    END) AS '$95',
	SUM(
		CASE
      WHEN price = '150' THEN 1
      ELSE 0
    END) AS '$150'
FROM purchase
GROUP BY style;

--Breakdown of models sold by gender
SELECT model_name, 
	COUNT(*) AS 'Total pairs',
	SUM(
    CASE
    	WHEN style LIKE 'Women%' THEN 1
    	ELSE 0
    END) AS Womens,
	SUM(
    CASE
    	WHEN style NOT LIKE 'Women%' THEN 1
    	ELSE 0
    END) AS Mens
FROM purchase
GROUP BY model_name;

--Breakdown of colours sold by gender
SELECT color,
	COUNT(*) AS 'Total pairs',
	SUM(
    CASE
    	WHEN style LIKE 'Women%' THEN 1
    	ELSE 0
    END) AS Womens,
	SUM(
    CASE
    	WHEN style NOT LIKE 'Women%' THEN 1
    	ELSE 0
    END) AS Mens
FROM purchase
GROUP BY color;

--Survey Results: Question 1
SELECT response AS 'Question 1 Responses', COUNT(*) AS 'Count'
FROM survey
	WHERE question LIKE "1.%"
GROUP BY response;

--Survey Results: Question 2
SELECT response AS 'Question 2 Responses', COUNT(*) AS 'Count'
FROM survey
	WHERE question LIKE "2.%"
GROUP BY response;

--Survey Results: Question 3
SELECT response AS 'Question 3 Responses', COUNT(*) AS 'Count'
FROM survey
	WHERE question LIKE "3.%"
GROUP BY response;

--Survey Results: Question 4
SELECT response AS 'Question 4 Responses', COUNT(*) AS 'Count'
FROM survey
	WHERE question LIKE "4.%"
GROUP BY response;

--Survey Results: Question 5
SELECT response AS 'Question 5 Responses', COUNT(*) AS 'Count'
FROM survey
	WHERE question LIKE "5.%"
GROUP BY response;