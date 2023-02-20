Try using LIMIT yourself below by writing a query that displays all the data in the occurred_at, account_id, and channel columns of the web_events table, 
and limits the output to only the first 15 rows.

-- Query
SELECT occurred_at, account_id, channel 
FROM web_events 
LIMIT 15;

-- ORDER BY PRACTICE
-- 1
SELECT id, occurred_at, total_amt_usd
FROM orders
ORDER BY occurred_at 
LIMIT 10;

-- 2
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC 
LIMIT 5; 

-- 3
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd 
LIMIT 20;

-- MULTIPLE ORDER BY 
-- 1
SELECT id, account_id, total_amt_usd 
FROM orders
ORDER BY account_id, total_amt_usd DESC;

-- 2
SELECT id, account_id, total_amt_usd 
FROM orders 
ORDER BY total_amt_usd DESC, account_id

-- 3
-- In the first query, we firstly sort it by 
-- account_id's lowest to highest paid order
-- In the second query, we sort it by 
-- lowest to highest payed order amount and then account

-- WHERE PRACTICE
-- 1
SELECT * 
FROM orders 
WHERE gloss_amt_usd >= 1000
LIMIT 5;

-- 2
SELECT * 
FROM orders 
WHERE total_amt_usd < 500
LIMIT 10;

-- WHERE (NON-NUMERIC DATA)

SELECT name, website, primary_poc 
FROM accounts  
WHERE name = 'Exxon Mobil';

-- ARITHMETIC OPERATIONS (DERIVED COLUMNS)
-- 1
SELECT standard_amt_usd/standard_qty AS unit_price,
id, account_id
FROM orders
LIMIT 10;

-- 2 THIS SOLUTION DOESNT WORK BECAUSE OF THE DATA
SELECT  id,account_id, poster_amt_usd/(standard_amt_usd+gloss_amt_usd+poster_amt_usd)
        *100 AS post_perc_order
        FROM orders
        LIMIT 10;
-- 3 SOLUTION IS SOLVED BY ADDING WHERE
SELECT  id,account_id, poster_amt_usd/(standard_amt_usd+gloss_amt_usd+poster_amt_usd)
        *100 AS post_perc_order
        FROM orders
        WHERE poster_amt_usd>0;
        
-- LIKE OPERATOR 
-- 1
SELECT * 
FROM accounts 
WHERE name LIKE 'C%';

-- 2
SELECT * 
FROM accounts 
WHERE name LIKE '%one%';

-- 3
SELECT * 
FROM accounts 
WHERE name LIKE '%s';

-- IN Operator 
-- 1
SELECT name, primary_poc, sales_rep_id
FROM accounts 
WHERE name IN ('Walmart', 'Target', 'Nordstrom');

-- 2
SELECT * 
FROM web_events
WHERE channel IN ('organic', 'adwords');

-- NOT Operator
-- 1
SELECT  name, primary_poc, sales_rep_id
FROM accounts
WHERE name NOT IN ('Walmart', 'Target', 'Nordstrom');

-- 2
SELECT * 
FROM web_events 
WHERE channel NOT IN ('organic', 'adwords');

-- 3
SELECT * 
FROM accounts 
WHERE name NOT LIKE ('C%');

-- 4
SELECT * 
FROM accounts 
WHERE name NOT LIKE ('%one%');

-- 5
SELECT * 
FROM accounts 
WHERE name NOT LIKE ('%s');

-- AND and BETWEEN 
-- 1
SELECT * 
FROM orders 
WHERE standard_qty > 1000 AND poster_qty = 0 
      AND gloss_qty = 0;

-- 2
SELECT * 
FROM accounts 
WHERE name NOT LIKE 'C%' AND name LIKE '%s';

-- 3
SELECT occurred_at, gloss_qty
FROM orders 
WHERE gloss_qty BETWEEN 24 AND 29;
-- Yes the BETWEEN operator does include the starting 
-- and the ending point

-- 4
-- First Solution
SELECT * 
FROM web_events 
WHERE channel IN ('organic', 'adwords')
      AND occurred_at BETWEEN '2016-01-01' AND '2017-01-01'
      ORDER BY occurred_at DESC;

-- Second Solution
SELECT * 
FROM web_events 
WHERE (channel = 'organic' OR channel = 'adwords')
      AND occurred_at BETWEEN '2016-01-01' AND '2017-01-01'
      ORDER BY occurred_at DESC;
-- It is important to use paranthesis to not mix up the 
-- conditions 

-- OR Operator
-- 1
SELECT id 
FROM orders
WHERE gloss_qty > 4000 OR poster_qty > 4000;

-- 2
SELECT * 
FROM orders 
WHERE standard_qty = 0 AND
(gloss_qty > 1000 OR poster_qty > 1000);

-- 3
SELECT name
FROM accounts
WHERE (name LIKE ('C%') OR name LIKE ('W%')) 
      AND (primary_poc LIKE ('%ana%') OR primary_poc LIKE ('%Ana%') 
           AND primary_poc NOT LIKE ('%eana%'));