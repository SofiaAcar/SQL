use SampleSales;

CREATE TABLE Action_2 (
                      Visitor_ID INT,
					  Adv_Type VARCHAR (250),
					  Action VARCHAR (250),
					  );

INSERT INTO Action_2 (Visitor_ID, Adv_Type, Action)
             VALUES (1, 'A', 'Left'),
			        (2, 'A', 'Order'),
					(3, 'B', 'Left'),
					(4, 'A', 'Order'),
					(5, 'A', 'Review'),
					(6, 'A', 'Left'),
					(7, 'B', 'Left'),
					(8, 'B', 'Order'),
					(9, 'B', 'Review'),
					(10, 'A', 'Review');

SELECT Adv_Type, (A_count / B_count) Conversion_Rate
FROM Actions

			(SELECT Adv_Type, COUNT(Adv_Type)
			 FROM Actions
			 WHERE Adv_Type = 'A'
			 GROUP BY Adv_Type) --A_count

			(SELECT Adv_Type, COUNT(Adv_Type)
			 FROM Actions
			 WHERE Adv_Type = 'B'
			 GROUP BY Adv_Type) --B_count
  


SELECT Adv_Type, COUNT(Adv_Type) C
FROM Actions
GROUP BY Adv_Type

SELECT *
FROM Actions

SELECT Adv_Type, (SUM(Action_V)  / COUNT(Action_)) AS Conversion_Rate
FROM (
SELECT Visitor_ID, Adv_Type, Action_, 
CASE
WHEN Action_ = 'Order' THEN 1
ELSE 0
END AS Action_V
FROM actions) AS new
GROUP BY Adv_Type

SELECT Adv_Type, ROUND(CAST(SUM(Action_V) AS REAL) / COUNT(Action_), 2) AS Conversion_Rate
FROM (
SELECT Visitor_ID, Adv_Type, Action_, 
CASE
WHEN Action_ = 'Order' THEN 1
ELSE 0
END AS Action_V
FROM actions) AS new
GROUP BY Adv_Type