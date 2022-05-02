use SampleSales;

-- a.Create above table (Actions) and insert values:

CREATE TABLE Actions (Visitor_ID INT,
                      Adv_Type VARCHAR(15),
					  Action VARCHAR(15)
					  );

INSERT INTO Actions (Visitor_ID, Adv_Type, Action)
             VALUES (1, 'A', 'Left'),
	                (2, 'A', 'Order'),
			        (3, 'B', 'Left'),
			        (4, 'A', 'Order'),
			        (5, 'A', 'Review'),
					(6, 'A', 'Left'),
					(7, 'B', 'Left'),
					(8, 'B', 'Order'),
					(9, 'B', 'Review'),
					(10, 'A','Review');

SELECT *
FROM Actions;

-- b.Retrieve count of total Actions and Orders for each Advertisement Type:

SELECT Adv_Type, COUNT(Adv_Type) Count_Num,
  SUM(CASE WHEN Action = 'Order' THEN 1 ELSE 0 END) AS Order_Num
FROM Actions
WHERE Adv_Type = 'A'
GROUP BY Adv_Type
UNION
SELECT Adv_Type, COUNT(Adv_Type) Count_Num, 
  SUM(CASE WHEN action = 'Order' THEN 1 ELSE 0 END) AS Order_Num
FROM Actions
WHERE Adv_Type = 'B'
GROUP BY Adv_Type;

/* c.Calculate Orders (Conversion) rates for each Advertisement Type 
by dividing by total count of actions casting as float by multiplying by 1.0. */

SELECT Adv_Type, ROUND(CAST(Order_Num AS FLOAT) / CAST(Count_Num AS FLOAT), 2) Conversion_Rate
FROM (
      SELECT Adv_Type, COUNT(Adv_Type) Count_Num,
			SUM(CASE WHEN Action = 'Order' THEN 1 ELSE 0 END) AS Order_Num
	  FROM Actions
	  WHERE Adv_Type = 'A'
	  GROUP BY Adv_Type
	  UNION
	  SELECT Adv_Type, COUNT(Adv_Type) Count_Num, 
	        SUM(CASE WHEN action = 'Order' THEN 1 ELSE 0 END) AS Order_Num
	  FROM Actions
	  WHERE Adv_Type = 'B'
	  GROUP BY Adv_Type
      )  new_table

--------------- ALTERNATIVE ANSWERS: ---------------

WITH T1 AS
		(
		SELECT Adv_Type, COUNT(Action) order_num
		FROM Conversion_Rate
		WHERE action = 'Order'
		GROUP BY Adv_Type
		),
     T2 AS
		(
		SELECT Adv_Type,COUNT(Action) num_of_action
		FROM Conversion_Rate
		GROUP BY Adv_Type
		)
SELECT T1.Adv_type, round((cast(T1.order_num AS FLOAT) / cast(T2.num_of_action AS FLOAT)),2)  AS Conversion_Rate
FROM T1,T2
WHERE T1.Adv_Type = T2.Adv_Type;


--------------------------------------------------------------------------

CREATE VIEW Total_info
    AS SELECT Adv_Type, COUNT(CASE WHEN Action = 'Order' then 1 ELSE NULL END) as "total_order", COUNT(Action) as "total_action"
    FROM  Actions											
    GROUP BY Adv_Type


SELECT Adv_Type, ROUND((CAST(total_order AS Float)/total_action), 2) as conversion_rate
FROM Total_info;


SELECT Adv_Type, ROUND((CAST(total_order AS Float)/total_action), 2) as conversion_rate
 FROM (SELECT Adv_Type,COUNT(CASE WHEN Action = 'Order' then 1 ELSE NULL END) as "total_order", COUNT(Action) as "total_action"
       FROM  Actions                     
       GROUP BY Adv_Type) as Total_info;

--------------------------------------------------------------------------

select Adv_Type, round(cast(Num_order as float)/ CAST() ) as Conversion_Rate
from (select Adv_Type, COUNT(Action_m) As Num_Action, (select COUNT(Action_m) FROM Actions WHERE Action_m = 'Order'  and  Adv_Type = 'A')  As Num_order
      from Actions
      where  Adv_Type = 'A'
      group by Adv_Type
      UNION
      select Adv_Type, COUNT(Action_m) As Num_Action, (select COUNT(Action_m) FROM Actions WHERE Action_m = 'Order' and  Adv_Type = 'B' )  As Num_order
      from Actions
      where  Adv_Type = 'B'
      group by Adv_Type) new_table

----------------------------------------------------------------------------

select Adv_Type, 100/(Num_Action/Num_Order)*0.01 as Conversion_Rate
from (select Adv_Type, COUNT(Action_m) As Num_Action, (select COUNT(Action_m) 
                                                        FROM Actions 
                                                        WHERE Action_m = 'Order'  and  Adv_Type = 'A')  As Num_order
    from Actions
    where  Adv_Type = 'A'
    group by Adv_Type
    UNION
    select Adv_Type, COUNT(Action_m) As Num_Action, (select COUNT(Action_m) 
                                                        FROM Actions 
                                                        WHERE Action_m = 'Order' and  Adv_Type = 'B' )  As Num_order
    from Actions
    where  Adv_Type = 'B'
    group by Adv_Type) new_table
-----------------------------------------------------------------

SELECT Adv_Type, ROUND(CAST(SUM(Action_V) AS REAL) / COUNT(Action), 2) AS Conversion_Rate
FROM (
SELECT Visitor_ID, Adv_Type, Action, 
CASE
WHEN Action = 'Order' THEN 1
ELSE 0
END AS Action_V
FROM actions) AS new
GROUP BY Adv_Type