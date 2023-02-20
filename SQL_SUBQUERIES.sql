-- Your First Subquery
-- 1
 SELECT channel, AVG(countchannel)
 FROM (SELECT DATE_TRUNC('day', occurred_at), channel, 
              COUNT (channel) AS countchannel
      FROM web_events
      GROUP BY 1,2) AS sub 
  GROUP BY 1
  ORDER BY 2 DESC;

-- 2 
SELECT DATE_TRUNC('day', occurred_at), channel, 
        COUNT (channel) AS countchannel
      FROM web_events
      GROUP BY 1,2

-- 3 
SELECT AVG(standard_qty) AS avgstandardqty,
AVG (gloss_qty) as avgglossqty, AVG(poster_qty) AS avgposterqty
        FROM orders WHERE DATE_TRUNC('month', occurred_at) =
        (SELECT DATE_TRUNC('month', MIN(occurred_at))
        FROM orders) 

-- 4
SELECT  SUM(total_amt_usd) AS totalforthemonth
        FROM orders WHERE DATE_TRUNC('month', occurred_at) =
        (SELECT DATE_TRUNC('month', MIN(occurred_at))
        FROM orders) 
      
-- VIEWS 
-- 1 
CREATE VIEW v1 
AS view1 
SELECT s.id AS salesid, s.name AS salesname, r.name AS regioname
FROM sales_reps s 
JOIN region r 
ON s.region_id = r.id 
WHERE r.name = 'Northeast';

-- 2 
CREATE VIEW 
view2 AS 
SELECT r.name AS regioname, a.name AS accountname,
o.total_amt_usd/(o.total+0.01) AS unit_price 
FROM region r 
JOIN sales_reps s 
ON r.id = s.region_id
JOIN accounts a 
ON a.sales_rep_id = s.id 
JOIN orders o 
ON a.id = o.account_id

-- 3 
CREATE VIEW V3
AS
SELECT channel, AVG(events) AS average_events
FROM (SELECT DATE_TRUNC('day',occurred_at) AS day,
                channel, COUNT(*) as events
         FROM web_events 
         GROUP BY 1,2) sub
GROUP BY channel

-- Example Challenge 
-- 1  
SELECT t3.id, t3.name, t3.channel, t3.ct 
FROM(SELECT a.id, a.name,we.channel, COUNT(*) ct
     FROM accounts a
     JOIN web_events we 
     ON a.id = we.account_id
     GROUP BY a.id, a.name, we.channel) T3
JOIN (SELECT t1.id, t1.name, MAX(ct)max_chan
     FROM (SELECT a.id, a.name, we.channel, COUNT(*) ct
          FROM accounts a 
          JOIN web_events we
          ON a.id = we.account_id
          GROUP BY a.id, a.name, we.channel) t1 
     GROUP BY t1.id, t1.name)t2
ON t2.id = t3.id AND t2.max_chan = 3.ct
ORDER BY t3.id;
   
-- More Quiz on Subqueries 
-- 1
SELECT t3.salesname2, t3.totsales1, t3.regioname2
FROM
        (SELECT t1.regioname1, MAX(t1.totsales) as max
        FROM
	(SELECT s.name as salesname1, r.name as regioname1,SUM(total_amt_usd) as totsales
	FROM region r 
	JOIN sales_reps s 
	ON r.id = s.region_id 
	JOIN accounts a 
	ON s.id = a.sales_rep_id 
	JOIN orders o 
	ON a.id = o.account_id 
	GROUP BY 1,2
	ORDER BY 3 DESC) as t1
        GROUP BY 1)as t2
JOIN    (SELECT s.name as salesname2, r.name as regioname2,SUM(total_amt_usd) as totsales1
	FROM region r 
	JOIN sales_reps s 
	ON r.id = s.region_id 
	JOIN accounts a 
	ON s.id = a.sales_rep_id 
	JOIN orders o 
	ON a.id = o.account_id 
	GROUP BY 1,2
	ORDER BY 3 DESC) as t3
ON t3.regioname2 = t2.regioname1 AND t3.totsales1 = t2.max;

-- 2
SELECT r.name as regioname1 , COUNT(o.*) as numberoforders
FROM region r 
JOIN sales_reps s 
ON r.id = s.region_id
JOIN accounts a 
ON s.id = a.sales_rep_id
JOIN orders o 
ON a.id = o.account_id
GROUP BY 1
    HAVING SUM(o.total_amt_usd) =(
    SELECT MAX(t1.total_amt)
    FROM 
        (SELECT r.name as regioname, SUM(o.total_amt_usd) as total_amt 
        FROM region r 
        JOIN sales_reps s 
        ON r.id = s.region_id
        JOIN accounts a 
        ON s.id = a.sales_rep_id 
        JOIN orders o 
        ON a.id = o.account_id
        GROUP BY 1)as t1) ;

-- 3
SELECT COUNT(*)
FROM 
(SELECT a.name  
FROM accounts a 
JOIN orders o 
ON a.id = o.account_id 
GROUP BY 1
        HAVING SUM (o.total) > (SELECT total 
        FROM
        (SELECT a.name as accountname , SUM(standard_qty) as tot_standard, SUM(total) total
        FROM accounts a
        JOIN orders o 
        ON a.id = o.account_id
        GROUP BY 1
        ORDER BY 2 DESC 
        LIMIT 1) as t1)
        )t2;

-- 4 
SELECT a.name , w.channel, COUNT(*)
FROM accounts a 
JOIN web_events w 
ON a.id = w.account_id AND a.id = (SELECT id
        FROM(SELECT a.id , a.name , SUM(o.total_amt_usd) as tot_usd 
        FROM accounts a
        JOIN orders o 
        ON a.id = o.account_id
        GROUP BY 1,2 
        ORDER BY 3 DESC
        LIMIT 1)innertable)
GROUP BY 1,2
ORDER BY 3

-- 5 
SELECT AVG(t1.tot_spends)
FROM(SELECT a.id , a.name, SUM(o.total_amt_usd) tot_spends
FROM accounts a 
JOIN orders o 
ON a.id = o.account_id
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 10) 

-- 6
SELECT AVG(avg1)FROM
(SELECT o.account_id, AVG(o.total_amt_usd) avg1 
FROM orders o 
GROUP BY 1
HAVING AVG(o.total_amt_usd) > (SELECT AVG(o.total_amt_usd) avg_all
                                FROM orders o))t1 

-- WITH SUBQUERIES
-- 1
SELECT t1.channel, AVG(t1.count) AS avg, 
FROM 
(SELECT DATE_TRUNC('day',occurred_at) AS day, channel, COUNT(*) AS count
        FROM web_events 
        GROUP BY 1,2
        ORDER BY 3) AS t1
GROUP BY 2 
ORDER BY 1 DESC

with events AS (
        SELECT DATE_TRUNC('day',occurred_at) AS day, channel, COUNT(*) AS count
        FROM web_events 
        GROUP BY 1,2
        )
SELECT channel, AVG(count)
FROM events 
GROUP BY 1 
ORDER BY 2 DESC;

-- 2
WITH table1 AS (
        SELECT * 
        FROM web_events),

     table2 AS (
             SELECT * 
             FROM accounts)

SELECT * 
FROM table1 
JOIN table2 
ON  table1.account_id = table2.id;     

-- Converting SUBQUERIES TO WITH
-- Subquery 
SELECT t3.salesname2, t3.totsales1, t3.regioname2
FROM
        (SELECT t1.regioname1, MAX(t1.totsales) as max
        FROM
	(SELECT s.name as salesname1, r.name as regioname1,SUM(total_amt_usd) as totsales
	FROM region r 
	JOIN sales_reps s 
	ON r.id = s.region_id 
	JOIN accounts a 
	ON s.id = a.sales_rep_id 
	JOIN orders o 
	ON a.id = o.account_id 
	GROUP BY 1,2
	ORDER BY 3 DESC) as t1
        GROUP BY 1)as t2
JOIN    (SELECT s.name as salesname2, r.name as regioname2,SUM(total_amt_usd) as totsales1
	FROM region r 
	JOIN sales_reps s 
	ON r.id = s.region_id 
	JOIN accounts a 
	ON s.id = a.sales_rep_id 
	JOIN orders o 
	ON a.id = o.account_id 
	GROUP BY 1,2
	ORDER BY 3 DESC) as t3
ON t3.regioname2 = t2.regioname1 AND t3.totsales1 = t2.max;
-- WITH version
WITH totsumsales AS (
        SELECT s.name as salesname2, r.name as regioname2,SUM(total_amt_usd) as totsales1
	FROM region r 
	JOIN sales_reps s 
	ON r.id = s.region_id 
	JOIN accounts a 
	ON s.id = a.sales_rep_id 
	JOIN orders o 
	ON a.id = o.account_id 
	GROUP BY 1,2
	ORDER BY 3 DESC
),
maxtable AS 
(SELECT totsumsales.regioname2 AS regiones , MAX(totsumsales.totsales1) max
FROM totsumsales
GROUP BY 1)

SELECT totsumsales.salesname2, totsumsales.totsales1, totsumsales.regioname2
FROM totsumsales 
JOIN maxtable 
ON totsumsales.regioname2 = maxtable.regiones AND totsumsales.totsales1 =
                                                  maxtable.max

-- 2
-- Subquery
SELECT r.name as regioname1 , COUNT(o.*) as numberoforders
FROM region r 
JOIN sales_reps s 
ON r.id = s.region_id
JOIN accounts a 
ON s.id = a.sales_rep_id
JOIN orders o 
ON a.id = o.account_id
GROUP BY 1
    HAVING SUM(o.total_amt_usd) =(
    SELECT MAX(t1.total_amt)
    FROM 
        (SELECT r.name as regioname, SUM(o.total_amt_usd) as total_amt 
        FROM region r 
        JOIN sales_reps s 
        ON r.id = s.region_id
        JOIN accounts a 
        ON s.id = a.sales_rep_id 
        JOIN orders o 
        ON a.id = o.account_id
        GROUP BY 1)as t1) ;

-- WITH version 
WITH regtotsales AS (SELECT r.name as regioname, SUM(o.total_amt_usd) as total_amt 
        FROM region r 
        JOIN sales_reps s 
        ON r.id = s.region_id
        JOIN accounts a 
        ON s.id = a.sales_rep_id 
        JOIN orders o 
        ON a.id = o.account_id
        GROUP BY 1), 

max AS (SELECT MAX(total_amt)
        FROM regtotsales)

SELECT r.name, COUNT(o.*)
FROM region r 
JOIN sales_reps s 
ON r.id = s.region_id
JOIN accounts a 
ON s.id = a.sales_rep_id
JOIN orders o 
ON a.id = o.account_id
GROUP BY 1
HAVING SUM(o.total_amt_usd) = (SELECT * FROM max)

-- 3
-- Subquery
SELECT COUNT(*)
FROM 
(SELECT a.name  
FROM accounts a 
JOIN orders o 
ON a.id = o.account_id 
GROUP BY 1
        HAVING SUM (o.total) > (SELECT total 
        FROM
        (SELECT a.name as accountname , SUM(standard_qty) as tot_standard, SUM(total) total
        FROM accounts a
        JOIN orders o 
        ON a.id = o.account_id
        GROUP BY 1
        ORDER BY 2 DESC 
        LIMIT 1) as t1)
        )t2;

-- With Conversion 
WITH moststandardacc AS (
        SELECT a.name, SUM(o.standard_qty) standardsum, SUM(o.total) totalsum
        FROM accounts a 
        JOIN orders o
        ON a.id = o.account_id
        GROUP BY 1
        ORDER BY 2 DESC 
        LIMIT 1), 
        accountsmorethan AS (
                 SELECT a.name
                FROM accounts a 
                JOIN orders o
                ON a.id = o.account_id
                GROUP BY 1
                HAVING SUM (o.total) > (SELECT totalsum FROM moststandardacc))

SELECT COUNT(*) 
FROM accountsmorethan;

-- 4
-- Subquery
SELECT a.name , w.channel, COUNT(*)
FROM accounts a 
JOIN web_events w 
ON a.id = w.account_id AND a.id = (SELECT id
        FROM(SELECT a.id , a.name , SUM(o.total_amt_usd) as tot_usd 
        FROM accounts a
        JOIN orders o 
        ON a.id = o.account_id
        GROUP BY 1,2 
        ORDER BY 3 DESC
        LIMIT 1)innertable)
GROUP BY 1,2
ORDER BY 3

-- With Conversion 
-- Look at the work pc and you will find it htere 

-- SQL Data Cleaning 
-- Quiz CONCAT, LEFT, RIGHT , SUBSTR
-- 1
SELECT CONCAT (sales_rep_id,'_',r.name) AS EMP_ID_REGION, s.name  
FROM sales_reps s 
JOIN region r 
ON s.region_id = r.id  
JOIN accounts a 
ON s.id = a.sales_rep_id

-- 2
SELECT name, CONCAT (lat,',',long) AS coordinate,
CONCAT (LEFT(primary_poc, 1),RIGHT (primary_poc,1),'@',SUBSTR(website,5))  EMAIL
FROM accounts;
               
SELECT CONCAT(account_id_,'_',channel,'_',)

-- 3
WITH count AS (
        SELECT account_id,COUNT(*) AS no, channel
        FROM web_events 
        GROUP BY 1,3
        ORDER BY 2 DESC
)
SELECT CONCAT(count.account_id,'_',count.channel,'_',count.no)
FROM count

-- CAST QUIZZES 
SELECT CONCAT(SUBSTR(date,7,4),'/', LEFT(date,2),'/',SUBSTR(date,4,2)) AS date
FROM sf_crime_data;
        

        


      


