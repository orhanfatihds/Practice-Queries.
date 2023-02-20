-- First Join Practice 
-- 1
SELECT accounts.*, orders.*
       FROM accounts
       JOIN orders 
       ON accounts.id = orders.account_id;

-- 2
SELECT orders.standard_qty, orders.gloss_qty,
       orders.poster_qty, accounts.website, 
       accounts.primary_poc
       FROM orders
       JOIN accounts 
       ON orders.account_id = accounts.id;

-- Question Mania Joins 
-- 1
SELECT a.primary_poc, w.occurred_at,
       w.channel, a.name
       FROM accounts a
       JOIN web_events w
       ON a.id = w.account_id
       WHERE a.name = 'Walmart';

-- 2
SELECT r.name regioname, s.name salesname, 
       a.name accountname 
       FROM region r
       JOIN sales_reps s
       ON r.id ion_id
       JOIN accounts a= s.reg
       ON s.id = a.sales_rep_id 
       ORDER BY a.name;

-- 3
SELECT r.name Regioname, a.name Accountname,
       o.total_amt_usd/(total+0.01) Unitprice
       FROM region r
       JOIN sales_reps s
       ON r.id = s.region_id
       JOIN accounts a 
       ON s.id = a.sales_rep_id
       JOIN orders o 
       ON a.id = o.account_id;

-- SQL Final Join Practices
-- 1
SELECT r.name AS regioname, s.name AS salesrepname,
       a.name AS accountname
       FROM region r
       JOIN sales_reps s 
       ON r.id = s.region_id
       JOIN accounts a 
       ON s.id = a.sales_rep_id
       WHERE r.name = 'Midwest'
       ORDER BY a.name;

-- 2
SELECT r.name AS regioname, s.name AS salesrepname,
       a.name AS accountname
       FROM region r
       JOIN sales_reps s 
       ON r.id = s.region_id
       JOIN accounts a 
       ON s.id = a.sales_rep_id
       WHERE s.name LIKE 'S%' 
       AND r.name = 'Midwest'
       ORDER BY a.name;

-- 3
SELECT r.name AS regioname, s.name AS salesrepname,
       a.name AS accountname
       FROM region r
       JOIN sales_reps s 
       ON r.id = s.region_id
       JOIN accounts a 
       ON s.id = a.sales_rep_id
       WHERE s.name LIKE 'K%' 
       AND r.name = 'Midwest'
       ORDER BY a.name;

-- 4
SELECT r.name AS regioname, a.name AS accountname,
       o.total_amt_usd/(total+0.01) AS unitprice
       FROM region r
       JOIN sales_reps s 
       ON r.id = s.region_id
       JOIN accounts a 
       ON s.id = a.sales_rep_id
       JOIN orders o
       ON a.id = o.account_id
       WHERE o.standard_qty > 100;

-- 5
SELECT r.name AS regioname, a.name AS accountname,
       o.total_amt_usd/(total+0.01) AS unitprice
       FROM region r
       JOIN sales_reps s 
       ON r.id = s.region_id
       JOIN accounts a 
       ON s.id = a.sales_rep_id
       JOIN orders o
       ON a.id = o.account_id
       WHERE o.standard_qty > 100 AND o.poster_qty > 50
       ORDER BY unitprice;

-- 6
SELECT r.name AS regioname, a.name AS accountname,
       o.total_amt_usd/(total+0.01) AS unitprice
       FROM region r
       JOIN sales_reps s 
       ON r.id = s.region_id
       JOIN accounts a 
       ON s.id = a.sales_rep_id
       JOIN orders o
       ON a.id = o.account_id
       WHERE o.standard_qty > 100 AND o.poster_qty > 50
       ORDER BY unitprice DESC;

-- 7
SELECT DISTINCT a.name AS accountname,
       w.channel AS channels
       FROM accounts a 
       JOIN web_events w 
       ON a.id = w.account_id
       WHERE a.id = 1001

-- 8 
SELECT o.occurred_at, a.name AS accountname,
       o.standard_qty+poster_qty+gloss_qty AS ordertotal,
       o.total_amt_usd
       FROM accounts a 
       JOIN orders o 
       ON a.id = o.account_id
       WHERE o.occurred_at BETWEEN '2015-01-01' AND '2016-01-01'
       ORDER BY o.occurred_at DESC;H