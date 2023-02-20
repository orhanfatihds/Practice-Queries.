-- WINDOW FUNCTIONS 
-- OVER
-- 1
SELECT standard_amt_usd,
       SUM(standard_amt_usd) OVER (ORDER BY occurred_at) AS running_total
FROM orders

-- 2
SELECT SUM(standard_amt_usd) OVER (PARTITION BY DATE_TRUNC('year',occurred_at)ORDER BY occurred_at),
       DATE_TRUNC ('year',occurred_at) as year1, 
       standard_amt_usd
       FROM orders 

SELECT standard_amt_usd
DATE_TRUNC('year', occurred_at) as year,
SUM(standard_amt_usd) OVER (PARTITION BY DATE_TRUNC('year', occurred_at) ORDER BY occurred_at) AS running_total
FROM orders

-- example 
SELECT id,
       account_id,
       standard_qty,
       DATE_TRUNC AS month,
       DENSE_RANK() OVER (PARTITION BY account_id ORDER BY NULL) AS dense_rank,
       SUM(standard_qty) OVER (PARTITION BY account_id ORDER BY) AS sum_standard_qty,
       COUNT(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC) AS count_standard_qty,
       AVG(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC) AS avg_standard_qty,
       MIN(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC) AS min_standard_qty,
       MAX(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC) AS max_standard_qty
FROM orders

-- 3 (ranking)
SELECT id, account_id, total,
       DENSE_RANK() OVER (PARTITION BY account_id ORDER BY total DESC)
       FROM orders

-- ALIAS IN WINDOW FUNCTIONS 
-- 1
SELECT id,
       account_id,
       DATE_TRUNC('year',occurred_at) AS year,
       DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS dense_rank,
       total_amt_usd,
       SUM(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS sum_total_amt_usd,
       COUNT(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS count_total_amt_usd,
       AVG(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS avg_total_amt_usd,
       MIN(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS min_total_amt_usd,
       MAX(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS max_total_amt_usd
FROM orders

-- NOW THE ALIASED QUERY
SELECT id,
       account_id,
       DATE_TRUNC('year',occurred_at) AS year,
       DENSE_RANK() OVER account_year_window AS dense_rank,
       total_amt_usd,
       SUM(total_amt_usd) OVER account_year_window AS sum_total_amt_usd,
       COUNT(total_amt_usd) OVER account_year_window AS count_total_amt_usd,
       AVG(total_amt_usd) OVER account_year_window AS avg_total_amt_usd,
       MIN(total_amt_usd) OVER account_year_window AS min_total_amt_usd,
       MAX(total_amt_usd) OVER account_year_window AS max_total_amt_usd
       FROM orders 
       WINDOW account_year_window AS (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at))

-- LAG/LEAD 
-- 1
SELECT occurred_at,
       total,
       LEAD(total) OVER (ORDER BY occurred_at) lead1,
       LEAD(total) OVER (ORDER BY occurred_at) - total AS lead_difference
FROM (
SELECT total_amt_usd,occurred_at,
       SUM(total_amt_usd) AS total
  FROM orders 
 GROUP BY 1,2
 ) sub

--  Percentiles 
-- 1 
SELECT account_id,
       standard_qty,
       occurred_at,
       NTILE(4) OVER (PARTITION BY account_id ORDER BY total_amt_usd) AS standard_quartile
       FROM orders 
-- 2
SELECT account_id,
       gloss_qty,
       occurred_at,
       NTILE(4) OVER (PARTITION BY account_id ORDER BY total_amt_usd) AS standard_quartile
       FROM orders 

-- 3
SELECT account_id,
       standard_qty,
       occurred_at,
       NTILE(4) OVER (PARTITION BY account_id ORDER BY total_amt_usd) AS standard_quartile
       FROM orders 