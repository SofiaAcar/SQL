-------------16.07.2021 DAwSQL LAb 1 ---------------

-- Soru 1: Write a query that returns the average prices according to brands and categories.
-- (TR) Marka ve kategorilere g�re ortalama fiyatlar� d�nd�ren bir sorgu yaz�n�z.

-- brand ve category tablolar�n� join yapam�yoruz. bu ikisini products tablosu �zerinden ba�layaca��z.

SELECT A.brand_name, B.category_name, AVG(C.list_price) AVG_PRICE
FROM production.brands A, production.categories B, production.products C
-- INNER JOIN yap�yorsan yukardaki s�ralama �nemli de�il ama LEFT/RIGHT JOIN yap�yorsan bu s�ralama �nemli.
WHERE A.brand_id = C.brand_id  --categories de brand id yok products ta var.
AND B.category_id = C.category_id -- burada da B.categories'i eklemi� oldum.
GROUP BY
		A.brand_name, B.category_name
ORDER BY
		3 DESC -- AVG_PRICE s�tununa g�re order yap
-- Trek marka bisikletin ilk 3 kategoride en pahal� marka oldu�unu sonra Electra geldi�ini g�r�yorum.

SELECT A.brand_name, B.category_name, AVG(C.list_price) AVG_PRICE
FROM production.brands A, production.categories B, production.products C
-- INNER JOIN yap�yorsan yukardaki s�ralama �nemli de�il ama LEFT/RIGHT JOIN yap�yorsan bu s�ralama �nemli.
WHERE A.brand_id = C.brand_id  --categories de brand id yok products ta var.
AND B.category_id = C.category_id -- burada da B.categories'i eklemi� oldum.
GROUP BY
		A.brand_name, B.category_name
ORDER BY
		1,2 DESC -- s�ralamaya g�re a�a��daki okuma de�i�iyor.


-- Soru 2: Write a query that returns the store which has the most sales quantitiy in 2016
-- (TR) 2016 y�l�nda en �ok sat�� adetine sahip ma�azay� d�nd�ren bir sorgu yaz�n�z.

SELECT TOP 20*
FROM sales.orders
-- orders tablosauna gitme nedenim store_id yi tespit etmek. di�er nedenim y�l� se�mek.

SELECT TOP 20*
FROM sales.order_items

-- Aggregate olarak SUM ile kullanaca��m. SUM de�erleri sayar. COUNT yapsayd�m sat�rlar� sayacakt�!!!
SELECT C.store_id, C.store_name, SUM(B.quantity) TOTAL_PRODUCT --sat�� miktar�n� bulmam i�in order itemslara g�re quantity i toplamam gerek
FROM sales.orders A, sales.order_items B, sales.stores C
--order tablosuyla order_items tablosunu neye g�re join yapaca��m? Order_id lere g�re..
WHERE A.order_id = B.order_id
AND A.store_id = C.store_id   -- bunu stores ile neyle birle�tirece�im ? store_id ile
GROUP BY
		C.store_id, C.store_name
-- 3 ma�aza var zaten. 3 ma�azaya g�re miktarlar geldi. �imdi 2016 y�l� kriterini girmeliyim

-- ana tablolarda filtreleme yapmak i�in HAVING de�il WHERE i kullanmam gerek.
SELECT C.store_id, C.store_name, SUM(B.quantity) TOTAL_PRODUCT --sat�� miktar�n� bulmam i�in order itemslara g�re quantity i toplamam gerek
FROM sales.orders A, sales.order_items B, sales.stores C
--order tablosuyla order_items tablosunu neye g�re join yapaca��m? Order_id lere g�re..
WHERE A.order_id = B.order_id
AND A.store_id = C.store_id   -- bunu stores ile neyle birle�tirece�im ? store_id ile
AND A.order_date BETWEEN '2016-01-01' AND '2016-12-31'
GROUP BY
		C.store_id, C.store_name

-- �imdi bunlardan en y�ksek olan� se�mem gerek.
-- bunun i�in ORDER BY ve select sat�r�nda TOP 1 yapaca��m
SELECT TOP 1 C.store_id, C.store_name, SUM(B.quantity) TOTAL_PRODUCT --sat�� miktar�n� bulmam i�in order itemslara g�re quantity i toplamam gerek
FROM sales.orders A, sales.order_items B, sales.stores C
WHERE A.order_id = B.order_id
AND A.store_id = C.store_id   -- bunu stores ile neyle birle�tirece�im ? store_id ile
AND A.order_date BETWEEN '2016-01-01' AND '2016-12-31'
GROUP BY
		C.store_id, C.store_name
ORDER BY 
		TOTAL_PRODUCT DESC
	
	-- y�l s�n�rlamas�n� LIKE ile nas�l yapar�m
SELECT TOP 1 C.store_id, C.store_name, SUM(B.quantity) TOTAL_PRODUCT --sat�� miktar�n� bulmam i�in order itemslara g�re quantity i toplamam gerek
FROM sales.orders A, sales.order_items B, sales.stores C
WHERE A.order_id = B.order_id
AND A.store_id = C.store_id   -- bunu stores ile neyle birle�tirece�im ? store_id ile
AND A.order_date LIKE '%16%'
GROUP BY
		C.store_id, C.store_name
ORDER BY 
		TOTAL_PRODUCT DESC

-- Soru 3: --Write a query that returns state(s) where �Trek Remedy 9.8 - 2017� product  is not ordered
-- bu �r�nden sipari� verilmeyen STATE leri getir.

-- hangi state te bu �r�nden ka� tane sipari� verilmi�. benim �nce bunu bulmam gerekiyor
-- dolay�s�yla hi� sipari� verilmeyen state te bu de�er 0 g�z�kecek.
-- state bilgisi --> customers tablosunda
-- product isimleri --> products tablosunda
-- bu iki tablo birbirien orders veya order_items tablosuyla ba�lan�yor!
SELECT *
FROM sales.customers 

SELECT C.order_id, C.customer_id, A.product_id, product_name
FROM production.products A, sales.order_items B, sales.orders C
-- orders ile product tablosunu join yapam�yorum. bunun i�in order_items tablosundan ge�mem gerekiyor
WHERE A. product_id = B.product_id
AND B.order_id = C.order_id
AND A.product_name = 'Trek Remedy 9.8 - 2017'
-- costumer bilgilerine ula�t�m

-- �imdi bu �r�nlerin hangi statelerde sat�ld���na ula�mal�y�m. bunun i�in D tablosundan state i getirece�im
SELECT C.order_id, C.customer_id, A.product_id, product_name, D.state
FROM production.products A, sales.order_items B, sales.orders C, sales.customers D
-- orders ile product tablosunu join yapam�yorum. bunun i�in order_items tablosundan ge�mem gerekiyor
WHERE A. product_id = B.product_id
AND B.order_id = C.order_id
AND C.customer_id = D.customer_id
AND A.product_name = 'Trek Remedy 9.8 - 2017'
-- �imdi stateleri de getirttim. 14 state te bu �r�n sat�ld���n� g�rebiliyorum. 
-- ama hangi state de hi� sat�lmam��?


-- �imdi yukardaki kodda olu�turdu�um tabloyu parantezlerin i�ine alarak yeni bir SELECT-FROM'da kullan�yorum.
-- ve bu tabloyu sales.customers tablosu ile RIGHT JOIN yap�p sales.customers tablosundaki state s�tununa g�re gruplayaca��m.
SELECT E.state, COUNT(product_id) CNT_PRODUCT 
-- state'e g�re GROUP BY yap�p aggregate olarak 47 no.lu product idlerin sat�rlar�n� sayacak COUNT kodunu kulland�m.
-- b�ylece state isimlerinin kar��s�nda bu �r�n�n sat�lma miktarlar�n� getirttim. �imdi tablom 3 sat�ra indi.
-- 1. sat�r bu �r�nden hi� sat�lmayan state.
FROM
(
SELECT C.order_id, C.customer_id, A.product_id, product_name
FROM production.products A, sales.order_items B, sales.orders C
WHERE A. product_id = B.product_id
AND B.order_id = C.order_id
AND A.product_name = 'Trek Remedy 9.8 - 2017'
) D
RIGHT JOIN sales.customers E 
ON D.customer_id = E.customer_id
GROUP BY
		E.state

-- fakat ben sat�lmayan state i g�rmek istiyorum. bunun i�in HAVING kullanaca��m.
SELECT E.state, COUNT(product_id) CNT_PRODUCT 
FROM
(
SELECT C.order_id, C.customer_id, A.product_id, product_name
FROM production.products A, 
	sales.order_items B, 
	sales.orders C
WHERE A. product_id = B.product_id
AND B.order_id = C.order_id
AND A.product_name = 'Trek Remedy 9.8 - 2017'
) D
RIGHT JOIN sales.customers E --
ON D.customer_id = E.customer_id
GROUP BY
		E.state
HAVING COUNT(product_id) = 0




----------TABLO CREATE ETMEK-------
CREATE TABLE TABLE_NAME
(
ELAM INT
LEAK INT
EL�M INT
CURRE_DATE DATE
)
INSERT INTO TABLE_NAME ()
VALUES ()

