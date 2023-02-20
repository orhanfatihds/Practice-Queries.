-- Aggregations First Practice 
-- 1
SELECT SUM (poster_qty) AS totalposterpaper
       FROM orders;

-- 2
SELECT SUM (standard_qty) AS totalstandardpaper
       FROM orders;

-- 3
SELECT SUM (total_amt_usd) AS totalamountsales
       FROM orders;

-- 4
SELECT standard_amt_usd+gloss_amt_usd AS 
       totalamountspend
       FROM orders;
    
-- 5 
SELECT SUM(standard_amt_usd) /
       SUM (standard_qty) AS totalunitprice
       FROM orders;

-- MIN , MAX & AVERAGE PRACTICE 
-- 1 
SELECT MIN (occurred_at) 
       FROM orders;

-- 2
SELECT occurred_at 
      FROM orders 
      ORDER BY occurred_at 
      LIMIT 1 ;

-- 3
SELECT MIN(occurred_at) 
       FROM web_events;

-- 4
SELECT  occurred_at
        FROM web_events 
        ORDER BY occurred_at
        LIMIT 1;

-- 5
SELECT AVG (standard_qty) AS avgstandardqty,
       AVG (gloss_qty) AS avgglossqty,
       AVG(poster_qty)AS avgposterqty,
       AVG(standard_amt_usd)AS avgstandardusd,
       AVG(gloss_amt_usd)AS avgglossusd,
       AVG(poster_amt_usd)AS avgposterusd
       FROM orders;

-- SQL Aggregations Group By 
-- 1
SELECT a.name AS accountname, o.occurred_at AS orderdate
       FROM accounts a
       JOIN orders o 
       ON a.id = o.account_id
       ORDER BY orderdate
       LIMIT 1;

-- 2
SELECT SUM(o.total_amt_usd) AS totalamountsales, 
       a.name AS accountname
       FROM orders o 
       JOIN accounts a
       ON o.account_id = a.id
       GROUP BY  a.name;

-- 3
SELECT w.occurred_at AS date, w.channel AS channel,
       a.name AS accountname
       FROM web_events w
       JOIN accounts a 
       ON W.account_id = a.id
       ORDER BY w.occurred_at DESC 
       LIMIT 1;

-- 4 
SELECT w.channel AS channel, COUNT(channel)
       FROM web_events w
       GROUP BY w.channel;

-- 5 
SELECT a.primary_poc AS primarycontact
       FROM web_events w
       JOIN accounts a 
       ON W.account_id = a.id
       ORDER BY w.occurred_at 
       LIMIT 1;

-- 6
SELECT a.name AS accountname, MIN(total_amt_usd)
       AS smallestorder
       FROM accounts a 
       JOIN orders o
       ON a.id = o.account_id
       GROUP BY a.name

-- WITHOUT THE AMOUNTS THAT ARE 0 
SELECT a.name AS accountname, MIN(total_amt_usd)
       AS smallestorder
       FROM accounts a 
       JOIN orders o
       ON a.id = o.account_id
       WHERE total_amt_usd > 0
       GROUP BY a.name
       
-- 7
SELECT r.name AS regioname, COUNT(s.id) AS salesrep
       FROM sales_reps s
       JOIN region r 
       ON s.region_id = r.id 
       GROUP BY r.name;


-- SQL Aggregations Group By 
-- 1
SELECT a.name AS accountname, AVG(standard_qty)
       AS standardpaperavg, AVG(poster_qty) AS 
       posterpaperavg, AVG(gloss_qty) AS glosspaperavg
       FROM accounts a 
       JOIN orders o 
       ON a.id = o.account_id
       GROUP BY a.name;

-- 2
SELECT a.name AS accountname, AVG(standard_amt_usd)
       AS standardamtavg, AVG(poster_amt_usd) AS 
       posteramtavg, AVG(gloss_amt_usd) AS glossamtavg
       FROM accounts a 
       JOIN orders o 
       ON a.id = o.account_id
       GROUP BY a.name;

-- 3
SELECT COUNT(*) AS channelnumber, s.name AS salesname,
       w.channel AS channelname
       FROM web_events w 
       JOIN accounts a 
       ON w.account_id = a.id
       JOIN sales_reps s 
       ON a.sales_rep_id = s.id 
       GROUP BY s.name , w.channel
       ORDER BY channelnumber DESC

-- 4
SELECT COUNT(*) AS channelnumber, r.name AS regioname,
       w.channel AS channelname
       FROM web_events w 
       JOIN accounts a 
       ON w.account_id = a.id
       JOIN sales_reps s 
       ON a.sales_rep_id = s.id
       JOIN region r 
       ON s.region_id = r.id 
       GROUP BY r.name , w.channel
       ORDER BY channelnumber DESC

-- DISTINCT 
SELECT a.name AS accountname , r.name AS 
       regioname 
       FROM accounts a 
       JOIN sales_reps s 
       ON a.sales_rep_id = s.id
       JOIN region r 
       ON s.region_id = r.id
       WHERE a.name = 'Apple'
              
SELECT  s.name AS 
       salesname, COUNT(*) numaccounts
       FROM accounts a 
       JOIN sales_reps s 
       ON a.sales_rep_id = s.id
       GROUP BY salesname
       ORDER BY numaccounts DESC

-- HAVING PRACTICE
-- 1
SELECT s.name AS salesrepname, COUNT(a.id) numberofaccounts
       FROM sales_reps s 
       JOIN accounts a 
       ON s.id = a.sales_rep_id 
       GROUP BY s.name
       HAVING COUNT(a.id) > 5

-- 2 
SELECT a.name AS acountname, COUNT(o.id) AS numberoforders
       FROM accounts a 
       JOIN orders o 
       ON a.id = o.account_id
       GROUP BY a.name
       HAVING COUNT (a.id)> 20

-- 3
SELECT a.name AS acountname, COUNT(o.id) AS numberoforders
       FROM accounts a 
       JOIN orders o 
       ON a.id = o.account_id
       GROUP BY a.name
       HAVING COUNT (a.id)> 20
       ORDER BY numberoforders DESC 
       LIMIT 1 

-- 4
SELECT a.name AS accountname, SUM(total_amt_usd) AS 
       totalusdamount
       FROM accounts a 
       JOIN orders o 
       ON a.id = o.account_id
       GROUP BY a.name
       HAVING SUM(total_amt_usd) > 30000

-- 5
SELECT a.name AS accountname, SUM(total_amt_usd) AS 
       totalusdamount
       FROM accounts a 
       JOIN orders o 
       ON a.id = o.account_id
       GROUP BY a.name
       HAVING SUM(total_amt_usd) < 1000

-- 6 
SELECT a.name AS accountname, SUM(total_amt_usd) AS 
       totalusdamount
       FROM accounts a 
       JOIN orders o 
       ON a.id = o.account_id
       GROUP BY a.name
       ORDER BY totalusdamount DESC
       LIMIT 1 

-- 7
SELECT a.name AS accountname, SUM(total_amt_usd) AS 
       totalusdamount
       FROM accounts a 
       JOIN orders o 
       ON a.id = o.account_id
       GROUP BY a.name
       ORDER BY totalusdamount 
       LIMIT 1 

-- 8 
SELECT a.name AS accountname, COUNT(channel)
       FROM accounts a 
       JOIN web_events w 
       ON a.id = w.account_id
       GROUP BY a.name , w.channel
       HAVING COUNT(channel) > 6 AND w.channel = 'facebook'

-- 9
SELECT a.name AS accountname, COUNT(channel) AS channel
       FROM accounts a 
       JOIN web_events w 
       ON a.id = w.account_id
       WHERE w.channel = 'facebook'
       GROUP BY a.name 
       ORDER BY channel DESC
       LIMIT 1;

-- 10
SELECT a.name AS accountname, COUNT(channel) AS channel,
       w.channel AS channelname
       FROM accounts a 
       JOIN web_events w 
       ON a.id = w.account_id
       GROUP BY a.name , w.channel
       HAVING COUNT(channel) > 6
       ORDER BY channel DESC
       LIMIT 1

-- DATE PRACTICE 
-- 1 
SELECT DATE_PART('year',o.occurred_at) AS year,
       SUM(total_amt_usd) AS totalamountsales
       FROM orders o 
       GROUP BY 1
       ORDER BY 2 DESC
-- 2 
SELECT DATE_PART('month', o.occurred_at) AS months,
       SUM(total_amt_usd) AS totalamountsales
       FROM orders o 
       GROUP BY 1
       ORDER BY 2 DESC
       
-- 3 
SELECT DATE_PART('month', o.occurred_at) AS months,
       COUNT(o.id) AS totalamountsales
       FROM orders o 
       GROUP BY 1
       ORDER BY 2 DESC
       LIMIT 1;

-- 4
SELECT DATE_TRUNC('month', o.occurred_at) AS month,
       SUM(gloss_amt_usd) AS glosspaperamt
       FROM orders o
       JOIN accounts a 
       ON o.account_id = a.id  
       WHERE a.name = 'Walmart'
       GROUP BY 1
       ORDER BY 2 DESC
       LIMIT 1 ;

-- CASE Clause
-- 1 
SELECT a.id, o.total_amt_usd, CASE WHEN total_amt_usd > 3000
       THEN 'Large' ELSE 
                     'Small' END AS level
       FROM orders o 
       JOIN accounts a 
       ON a.id = o.account_id
       GROUP BY 1, 2 
       ORDER BY total_amt_usd DESC
       
-- 2 
SELECT CASE WHEN total >= 2000 THEN 
       'At Least 2000' WHEN total >= 1000 AND total < 2000 
       THEN 'Between 1000 and 2000' ELSE 
                                    'Less Than 1000' END AS ordercat,
       COUNT(*) AS order_count
       FROM Orders
       GROUP BY 1 

-- 3
SELECT a.name AS companyname, CASE WHEN SUM(total_amt_usd)  > 200000 
       THEN 'Lifetime Value' WHEN SUM(total_amt_usd)  > 100000 AND  SUM(total_amt_usd) 
       < 200000 THEN 'Second Level' ELSE 'Lowest Level' END AS companylevel,
       SUM (o.total_amt_usd) AS totalvaluesales
       FROM accounts a
       JOIN orders o 
       ON a.id = o.account_id 
       GROUP BY 1
       ORDER by totalvaluesales DESC

-- 4
SELECT DATE_PART ('year',occurred_at)AS occurtime,a.name AS companyname, CASE WHEN SUM(total_amt_usd)  > 200000 
       THEN 'Lifetime Value' WHEN SUM(total_amt_usd)  > 100000 AND  SUM(total_amt_usd) 
       < 200000 THEN 'Second Level' ELSE 'Lowest Level' END AS companylevel,
       SUM (o.total_amt_usd) AS totalvaluesales
       FROM accounts a
       JOIN orders o 
       ON a.id = o.account_id 
       WHERE o.occurred_at BETWEEN '2015-12-31' AND '2017-12-31'
       GROUP BY 1,2
       ORDER by totalvaluesales DESC

-- 5
SELECT s.name AS salesrepname, CASE WHEN COUNT(total) > 200 THEN 'top'
       ELSE 'not' END AS performance, 
       COUNT(total) AS totalorders
       FROM sales_reps s
       JOIN accounts a 
       ON s.id = a.sales_rep_id
       JOIN orders o 
       ON a.id = o.account_id
       GROUP BY 1
       ORDER BY 3 DESC

-- 6 
SELECT s.name AS salesrepname, CASE WHEN COUNT(total) > 200 OR 
       SUM(total_amt_usd) > 750000 THEN 'top' WHEN COUNT(total) > 150
       OR SUM(total_amt_usd) > 500000 THEN 'middle' ELSE 'low'
        END AS performance, 
       COUNT(total) AS totalorders
       FROM sales_reps s
       JOIN accounts a 
       ON s.id = a.sales_rep_id
       JOIN orders o 
       ON a.id = o.account_id
       GROUP BY 1
       ORDER BY 3 DESC
