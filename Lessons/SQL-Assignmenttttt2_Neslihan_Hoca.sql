use SampleSales

-- 1. Conversion Rate
-- Below you see a table of the actions of customers visiting the website by clicking on two different types of advertisements given by an E-Commerce company.
-- Write a query to return the conversion rate for each Advertisement type.

-- a.    Create above table (Actions) and insert values,
CREATE TABLE Actions(
    Visitor_ID int,
    Adv_Type VARCHAR(15),
    Action_ VARCHAR(15)
    )
INSERT INTO Actions (Visitor_ID, Adv_Type, Action_ )
VALUES
(1,'A','Left'),
(2,'A','Order'),
(3,'B','Left'),
(4,'A','Order'),
(5,'A','Review'),
(6,'A','Left'),
(7,'B','Left'),
(8,'B','Order'),
(9,'B','Review'),
(10,'A','Review');
SELECT * FROM Actions



-- b.    Retrieve count of total Actions and Orders for each Advertisement Type,
 
SELECT  Adv_Type, COUNT(Action_) as num_action,
SUM(CASE When Action_ = 'Order' THEN 1 ELSE 0 END ) as num_order 
FROM Actions
WHERE Adv_Type = 'A'
GROUP BY Adv_Type

UNION

SELECT  Adv_Type, COUNT(Action_) as num_action,
SUM(CASE When Action_ = 'Order' THEN 1 ELSE 0 END ) as num_order 
FROM Actions
WHERE Adv_Type = 'B'
GROUP BY Adv_Type


-- c. Calculate Orders (Conversion) rates for each Advertisement Type by dividing by total count of actions casting as float by multiplying by 1.0.

SELECT Adv_Type, ROUND(CAST( num_order as float)/CAST (num_action as float), 2)  AS Conversion_Rate

FROM
    
(SELECT  Adv_Type, COUNT(Action_) as num_action,
SUM(CASE When Action_ = 'Order' THEN 1 ELSE 0 END ) as num_order 
FROM Actions
WHERE Adv_Type = 'A'
GROUP BY Adv_Type

UNION

SELECT  Adv_Type, COUNT(Action_) as num_action,
SUM(CASE When Action_ = 'Order' THEN 1 ELSE 0 END ) as num_order 
FROM Actions
WHERE Adv_Type = 'B'
GROUP BY Adv_Type
) new_table

