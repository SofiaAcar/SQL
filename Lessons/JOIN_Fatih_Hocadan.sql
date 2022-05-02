use SampleSales

---////LESSON 2////---

------ INNER JOIN ------

-- List products wtih category names
-- Select product ID, product name, category ID and category name

SELECT TOP 10*
FROM product.product AS A
--SELECT TOP 10* (Sadece Ýncelemek Ýçin Yazdýk Sildik)
--FROM product.category AS B
INNER JOIN product.category AS B
ON A.category_id = B.category_id

SELECT product_name, B.category_id --Altýnda kýrmýzý çizgi hatayý gösteriyor.
FROM product.product AS A
--SELECT TOP 10*
--FROM product.category AS B
INNER JOIN product.category AS B
ON A.category_id = B.category_id

-- List employees of stores with their store information
-- Select employee name,last_name, store_name

SELECT TOP 10 A.first_name, A.last_name, B.store_name
FROM sale.staff AS A -- first name, last name sale.staff dan gelyor.
INNER JOIN sale.store AS B --store_name sale store dan geliyor.
ON A.store_id = B.store_id --PK.

--/////LESSON 3/////-- 

--------LEFT JOIN--------

-- Write a query that returns products that have never been ordered
-- Select product ID, product name, order ID
--(Use Left Join)

SELECT A.product_id, A.product_name, B.order_id
FROM product.product A
LEFT JOIN sale.order_item B ON A.product_id = B.product_id
WHERE B.order_id IS NULL



-- Report the stock of the products that product id greater than 310 in the stores.
-- Expected columns: product_id, product_name, store_id, quantity


SELECT A.product_id, A.product_name, B.store_id, B.quantity
FROM product.product A
LEFT JOIN product.stock B ON A.product_id = B.product_id
WHERE A.product_id > 310
ORDER BY store_id


--------RIGHT JOIN--------

-- Report (AGAIN WITH RIGHT JOIN) the stock status of the products that product id greater than 310 in the stores. 

SELECT A.product_id, A.product_name, B.store_id, B.quantity
FROM product.product A
RIGHT JOIN product.stock B ON A.product_id = B.product_id
WHERE A.product_id > 310
ORDER BY store_id


-- Expected columns : staff_id, first_name,last_name, all the information about orders

SELECT B.staff_id, B.first_name,B.last_name, A.*
FROM sale.orders A
RIGHT JOIN sale.staff B ON A.staff_id =B.staff_id
ORDER BY order_id


SELECT COUNT (DISTINCT A.staff_id)
FROM sale.staff A
INNER JOIN sale.orders B ON A.staff_id =B.staff_id

------FILTER OUTER JOIN----


-- Write a query that returns stock and order information together for all products. (TOP 20)
-- Expected Columns : product.id, store_id, quantity, list_price


SELECT TOP 20 B.product_id, B.store_id, B.quantity,A.product_id, A.order_id, A.list_price
FROM sale.order_item A
FULL OUTER JOIN product.stock B ON A.product_id = B.product_id
ORDER BY  B.product_id, A.product_id

-- THE END
