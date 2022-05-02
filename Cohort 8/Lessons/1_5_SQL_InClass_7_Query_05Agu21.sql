-----------------SQL INCLASS SESSION-7 05 AGU 21 ------------------------------

---------------------------WINDOS FUNCTION----------------------------------------

--GROUP BY--> distinct kullanm�yoruz, distinct'i zaten kendi i�inde yap�yor
--WF--> optioanal olarak yapabiliyoruz.

--GROUP BY -->  aggregate mutlaka gerekli, 
--WF--> aggregate optional

--GROUP BY --> Ordering invalid
--WF--> ordering valid

--GROUP BY --> performans� d���k
--WF --> performansl�



-- SYNTAX

SELECT {columns}
FUNCTION OVER (PARTITION BY...ORDER BY...WINDOW FRAME)
FROM table1

select *,
AVG(time) OVER(
				PARTITION BY id ORDER BY date
				ROWS BETWEEN 1 PRECEDING AND CURRENT ROW
				) as avg_time
FROM time_of_sales


 
-- UNBOUNDED PRECEDING --> �NCEK� SATIRLARIN HEPS�NE BAK (kendi partition i�inde)
-- UNBOUNDED FOLLOWING--> SONRAK� SATIRLARIN HEPS�NE BAK (kendi partition i�inde)

-- N PRECEDING --> BEL�RT�LEN N DE�ER�NE KADAR �NCES�NE G�D�P BAK
-- M FOLLOWING --> BEL�RT�LEN M DE�ER�NE KADAR SONRASINA BAK


-------------------------------------------------------------------------------
-- SORU 1: �r�nlerin stock say�lar�n� bulunuz

SELECT product_id, SUM(quantity)
FROM production.stocks
GROUP BY product_id


SELECT product_id
FROM production.stocks
GROUP BY product_id
ORDER BY 1

-- window function ile yazal�m
SELECT SUM(quantity) OVER (PARTITION BY product_id)
FROM production.stocks
-- YEN� B�R S�TUN OLARAK sonu� geldi ama tek s�tun oldu�u i�in anlamak zor. yan�na di�er s�tunlar� da getirelim

SELECT *, SUM(quantity) OVER (PARTITION BY product_id)
FROM production.stocks

--sadece product_id s�tunu i�imizi g�r�r
SELECT product_id, SUM(quantity) OVER (PARTITION BY product_id)
FROM production.stocks

-- Distint atarak product�_id leri teke d���r�r�m
SELECT DISTINCT product_id, SUM(quantity) OVER (PARTITION BY product_id)
FROM production.stocks


-- SORU 2: Markalara g�re ortalama bisiklet fiyatlar�n� hem GROUP BY hem de WINDOW Function ile hesaplay�n�z

-- GROUP BY ile :
SELECT brand_id, AVG(list_price) avg_price
FROM production.products
GROUP BY brand_id

-- window function ile:
SELECT brand_id, AVG(list_price) OVER (PARTITION BY brand_id) avg_price
FROM production.products


-----------------------------1. ANALYTIC AGGREGATE FUNCTIONS -----------------------------------------------------------------

--MIN()  --MAX()   --AVG()  --SUM()  -- COUNT()




--SORU 1: T�m bisikletler aras�nda en ucuz bisikletin fiyat�

-- Minimum list_price istiyor. herhangi bir gruplamaya yani PARTITION a gerek yok!
SELECT DISTINCT MIN (list_price) OVER ()
FROM production.products



--SORU 2: Her bir kategorideki en ucuz bisikletin fiyat�?

-- kategoriye g�re gruplama yapmak zorunday�m yani PARTITION gerekli
SELECT DISTINCT category_id, MIN (list_price) OVER (PARTITION BY category_id)
FROM production.products



--SORU 3: product tablosunda toplam ka� farkl� bisiklet var?

SELECT DISTINCT COUNT (product_id) OVER () NUM_OF_BIKE
FROM production.products
-- sadece product_id leri unique olarak sayd�rd�m. PARTITION (gruplamaya gerek yok)
-- product tablosunda 321 adet farkl� bisiklet oldu�unu g�rd�m.



--SORU 4: Order_items tablosunda ka� farkl� bisiklet var?
SELECT DISTINCT COUNT(product_id) OVER() order_num_of_bike
FROM sales.order_items
-- �r�n say�s� : 4722

-- Bu hata verir!!
SELECT COUNT(DISTINCT product_id) OVER() order_num_of_bike
FROM sales.order_items
-- COUNT WINDOW fonksiyonunda yukardaki gibi i�inde DISTINC'e izin vermiyor! Onun yerine,

SELECT COUNT(DISTINCT product_id)
FROM sales.order_items
--307 product_id geldi. bunun �zerinden bir sayma i�lemi yaparsam

-- yukardaki query'i window fonksiyonunu kulland���m query'nin subquerysi yapaca��m.
SELECT DISTINCT COUNT(product_id) OVER() order_num_of_bike
FROM (
		SELECT DISTINCT product_id  -- buradan 307 row de�er gelecek
		FROM sales.order_items
	) A


-- SORU 4: her bir kategoride toplam ka� farkl� bisiklet var?

SELECT DISTINCT category_id, COUNT(product_id) OVER(PARTITION BY category_id)
FROM production.products
-- product_id zaten unique oldu�u i�in ayr�ca bir distinct e gerek kalmad�.


--SORU 5: Herbir kategorideki herbir  markada ka� farkl� bisikletin bulundu�u
SELECT DISTINCT category_id, brand_id, COUNT(product_id) OVER(PARTITION BY category_id, brand_id)
FROM production.products



--SORU 6 : WF ile tek select'te herbir kategoride ka� farkl� marka oldu�unu hesaplayabilir miyiz?

SELECT DISTINCT category_id, COUNT(brand_id) OVER (PARTITION BY category_id) 
FROM production.products
-- burada her bir kategorideki sat�r say�s�n� getiriyor. bunu istemiyoruz!!

SELECT DISTINCT category_id, COUNT(brand_id) OVER (PARTITION BY category_id) 
FROM 
(
SELECT DISTINCT category_id, brand_id  -- �NCE DISTINCT �LE BRAND_ID LER� GET�RD�M.
FROM production.products 
) A
-- g�r�ld��� gibi WF  ile tek bir SELECT sat�r� ile bu soru yap�lam�yor.

SELECT	category_id, count (DISTINCT brand_id)
FROM	production.products
GROUP BY category_id

--Sonu�: i�in i�inde DISTINCT varsa GROUP BY ile daha kolayca ��z�me ula��l�yor!!!




--------------------------- 2. ANALYTIC NAVIGATION FUNCTIONS ------------------------------------------------------------

-- FIRST_VALUE()  -- LAST_VALUE() -- LEAD() -- LAG()



-- SORU 1 : Order tablosuna a�a��daki gibi yeni bir s�tun ekleyiniz:
	-- Her bir personelin bir �nceki sat���n�n sipari� tarihini yazd�r�n�z (LAG Fonksiyonunu kullan�n�z)

SELECT *, 
LAG(order_date, 1) OVER (PARTITION BY staff_id ORDER BY order_date, order_id) prev_ord_date
-- HER B�R PERSONEL�N DED��� ���N PARTITION BY a staff_id koyuyoruz. (staff_id lere g�re grupluyoruz)
-- bir �nceki sipari� tarihini sordu�u i�in ORDER BY da order date'e (ve order_id'ye) g�re s�ralama yapt�rd�m
FROM sales.orders

-- LAG, current row'dan belirtilen arg�mandaki rakam kadar �nceki de�eri getiriyor..
-- query sonucu inceledi�inde LAG fonksiyonu, prev_ord_date s�tununda her sat�ra o sat�r�n bir �nceki sat�r�ndaki tarihi yazd���n� g�rebilirsin.
	--yani her sat�r bir �nceki order_date'i yazd�rm�� olduk

--staff_id'nin 2 den 3'e ge�ti�i 165. sat�ra dikkat et. o sat�rdan itibaren yeni bir pencere a�t� ve 
	-- LAG() fonksiyonunu o pencereye ayr�ca uygulad�. (165. sat�rda bir �nceki tarih olmad��� i�in NULL yazd�rd�.)




-- SORU 2: Order tablosuna a�a��daki gibi yeni bir s�tun ekleyiniz:
	--2. Herbir personelin bir sonraki sat���n�n sipari� tarihini yazd�r�n�z (LEAD fonksiyonunu kullan�n�z)

SELECT	*,
		LEAD(order_date, 1) OVER (PARTITION BY staff_id ORDER BY Order_date, order_id) next_ord_date
FROM	sales.orders

-- LEAD, current row'dan belirtilen arg�mandaki rakam kadar sonraki de�eri getiriyor
-- Niye iki s�tunu order by yapt�k? ��nk� ay�n ayn� g�n�nde birden fazla sipari� verilmi� olabilir.
	-- o y�zden tarihe ilave olarak bir de order_id ye g�re s�ralama yapt�rd�k

--GENELL�KLE LEAD VE LAG FONKS�YONLARI SIRALANMI� B�R L�STEYE UYGULANIR!!! O Y�ZDEN ORDER BY KULLANILMALIDIR!!




---------------------------------WINDOWS FRAME ----------------------------------------


SELECT category_id, product_id,
	COUNT (*) OVER () TOTAL_ROW  -- bunun bize toplam sat�r say�s�n� getirmesini bekliyoruz
FROM production.products


SELECT DISTINCT category_id,
	COUNT (*) OVER () TOTAL_ROW,
	COUNT(*) OVER (PARTITION BY category_id ORDER BY product_id) num_of_row
FROM production.products
-- son elde etti�imiz s�tunda category_id lerin sat�r say�s�n� k�m�latif olarak toplayarak getirdi.
	-- category_id :1 olan pencerenin sonuna bakt���m�zda o kategoriye ait ka� sat�r oldu�unu (59) anl�yoruz
	-- product_id ye g�re order by yapt���m�z i�in her bir categroy_id gruplamas� i�inde product_id leri s�ral�yor
		-- ve bu s�ralaman�n her sat�r�nda k�m�latif olarak toplama yap�yor.

-- ORDER BY yapmazsak:
SELECT DISTINCT category_id,
	COUNT (*) OVER () TOTAL_ROW,
	COUNT(*) OVER (PARTITION BY category_id) total_num_of_row,
	COUNT(*) OVER (PARTITION BY category_id ORDER BY product_id) num_of_row
FROM production.products
-- 2.COUNT'tan ORDER BY'� kald�r�nca product_id ye g�re order by � kald�rd���m�z i�in, 
	-- gruplanan categoru_id ye g�re COUNT(*) sonucunu yani toplam row say�s�n� her bir category_id sat�r�n�n yan�na yazd�rd�!


SELECT category_id,
COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) prev_with_current
from production.products

-- Gruplad���m�z category_id sat�rlar�n� bu sefer ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ile sayd�rd�k.
	-- Bulundu�u sat�rda o sat�rdan �nceki t�m sat�rlar� ve o sat�r� i�leme sokarak toplama yap�yor.
	-- dolay�s�yla bir �nceki query deki gibi k�m�latif bir toplama i�lemi yapm�� oluyor.



SELECT	category_id,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) current_with_following
from	production.products
ORDER BY	category_id, product_id
-- OVER i�lemi i�indeki order by --> window fonksiyonu uygularken dikkate alaca�� order by
-- Sondaki order by --> select i�lemi sonundaki sonucun order by �


SELECT	category_id,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) current_with_following
from	production.products
ORDER BY	category_id, product_id


SELECT	category_id,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) current_with_following
from	production.products
ORDER BY	category_id, product_id



SELECT	category_id,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 1  PRECEDING AND 1 FOLLOWING) current_with_following
from	production.products
ORDER BY	category_id, product_id
-- her sat�r i�in kendinden �nceki 1 sat�r� ve sonraki 1 sat�r� hesap ederek count i�lemi yap
	-- mesela 5. sat�r i�in; �nceki 1 sat�ra gitti, bu 4.sat�rd�r... sonra kendinden sonraki 1.sat�ra gitti, bu 6. sat�rd�r.
		-- bu iki sat�r (4. ve 6. sat�rlar) aras�nda 3 sat�r oldu�undan COUNT fonk. return olarak 3 getirdi.

SELECT	category_id,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 2 PRECEDING AND 3 FOLLOWING) current_with_following
from	production.products
ORDER BY	category_id, product_id
-- her sat�r i�in kendinden �nceki 2 sat�r� ve sonraki 3 sat�r� hesap ederek count i�lemi yap
	-- mesela 5. sat�r i�in; �nceki 2 sat�ra gitti, bu 3.sat�rd�r... sonra kendinden sonraki 3.sat�ra gitti, bu 8. sat�rd�r.
		-- bu iki sat�r (3. ve 8. sat�rlar) aras�nda 6 sat�r oldu�undan COUNT fonk. return olarak 6 getirdi.


-- SORU 1: T�m bisikletler aras�nda en ucuz bisikletin ad� (FIRST_VALUE fonksiyonunu kullan�n�z)

-- First_value i�ine arg�man olarak hangi s�tundaki ilk de�eri istiyorsam onu al�yorum
SELECT *, FIRST_VALUE(product_name) OVER (ORDER BY list_price) 
FROM production.products


-- SORU 2: yukardaki sonucun yan�na list price nas�l yazd�r�r�z?

SELECT DISTINCT FIRST_VALUE(product_name) OVER (ORDER BY list_price), min(list_price) OVER() 
FROM production.products


-- SORU 3: Herbir kategorideki en ucuz bisikletin ad� (FIRST_VALUE fonksiyonunu kullan�n�z)

SELECT DISTINCT category_id, FIRST_VALUE (product_name) OVER (partition by category_id  ORDER BY list_price)
FROM production.products
-- her kategorinin en ucuzunu sordu�u i�in category_id yi partition ile gruplad�k. 



-- SORU 4: T�m bisikletler aras�nda en ucuz bisikletin ad� (LAST_VALUE fonksiyonunu kullan�n�z)

SELECT DISTINCT	
		FIRST_VALUE(product_name) OVER (ORDER BY list_price)
FROM production.products
-- tek sat�rl�k first_value de�erini g�rd�m

SELECT DISTINCT	
		FIRST_VALUE(product_name) OVER (ORDER BY list_price),
		LAST_VALUE(product_name) OVER (ORDER BY list_price desc)
FROM production.products
-- LAST_VALUE sat�r�n� da girince birden fazla sat�r getirdi!! 
-- LAST_VALUE'da FIRST_VALUE'dan farkl� olarak ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING girmem gerek.

SELECT	DISTINCT
		FIRST_VALUE(product_name) OVER ( ORDER BY list_price),
		LAST_VALUE(product_name) OVER (	ORDER BY list_price desc ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM	production.products





---------------------------3. ANALYTIC NUMBERING FUNCTIONS -------------------------------

--ROW_NUMBER() - RANK() - DENSE_RANK() - CUME_DIST() - PERCENT_RANK() - NTILE()



-- SORU 1 : Herbir kategori i�inde bisikletlerin fiyat s�ralamas�n� yap�n�z (artan fiyata g�re 1'den ba�lay�p birer birer artacak)

-- ROW_NUMBER ba�tan a�a��ya numara verir. S�ralanm�� bir liste �zerinden bir de�er se�ebilmem i�in kullan�yoruz
	-- list_price s�ralamas�nda 10 numaral� s�radaki �r�n� getir dedi�imde bu i�e yarar.
SELECT category_id, list_price,
	   ROW_NUMBER () OVER(PARTITION BY category_id ORDER BY list_price) AS ROW_NUM
FROM production.products
-- list price'� niye s�ralad�k, artan fiyata g�re 1 den ba�lay�p birer birer artacak dedi�i i�in..



-- SORU 2: Ayn� soruyu ayn� fiyatl� bisikletler ayn� s�ra numaras�n� alacak �ekilde yap�n�z 
	--(RANK fonksiyonunu kullan�n�z)

SELECT	category_id, list_price,
		ROW_NUMBER () OVER (PARTITION BY category_id ORDER BY list_price) ROW_NUM,
		RANK () OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM
FROM	production.products
-- AYNI rank'te olan ikinci de�erin ranknumaras�n� ilkinin numaras� ile de�i�tiriyor
	-- yani rank numras� �nceki ile ayn� oluyor ve sonraki gelen i�in numara bir atlayarak kendi numaras� ile s�ralan�yor.


-- SORU 3: Ayn� soruyu ayn� fiyatl� bisikletler ayn� s�ra numaras�n� alacak �ekilde yap�n�z 
	--(DENSE_RANK fonksiyonunu kullan�n�z)

SELECT	category_id, list_price,
		ROW_NUMBER () OVER (PARTITION BY category_id ORDER BY list_price) ROW_NUM,
		RANK () OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM,
		DENSE_RANK () OVER (PARTITION BY category_id ORDER BY list_price) DENSE_RANK_NUM
FROM	production.products
-- DENSE_RANK'te RANK'ten farkl� olarak; ayn� rank'te olanlara ayn� numaray� vermesine ra�men s�ra numaralar� atlam�yor.



--SORU 4: Herbir kategori i�inde bisikletlerin fiyatlar�na g�re bulunduklar� y�zdelik dilimleri yazd�r�n�z. 
	-- PERCENT_RANK fonksiyonunu kullan�n�z.

SELECT	category_id, list_price,
		ROW_NUMBER () OVER (PARTITION BY category_id ORDER BY list_price) ROW_NUM,
		RANK () OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM,
		DENSE_RANK () OVER (PARTITION BY category_id ORDER BY list_price) DENSE_RANK_NUM,
		ROUND (PERCENT_RANK () OVER (PARTITION BY category_id ORDER BY list_price) , 2 ) PERCENT_RNK
FROM	production.products
-- Bu fonksiyon da ORDER BY'a ba�l�!! Mutlaka ORDER BY kullan�lmal�!!!


--SORU 5: Ayn� soruyu CUM_DIST ile yap�n�z:

SELECT	category_id, list_price,
		ROW_NUMBER () OVER (PARTITION BY category_id ORDER BY list_price) ROW_NUM,
		RANK () OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM,
		DENSE_RANK () OVER (PARTITION BY category_id ORDER BY list_price) DENSE_RANK_NUM,
		ROUND (PERCENT_RANK () OVER (PARTITION BY category_id ORDER BY list_price) , 2 ) PERCENT_RNK,
		ROUND (CUME_DIST () OVER (PARTITION BY category_id ORDER BY list_price) , 2 ) CUM_DIST
FROM	production.products



----------------- CUME_DIST �LE PERCENT_RANK ARASINDAK� FARKLAR---------------------

-- CUME_DIST: 

	-- Bir grup i�indeki bir de�erin k�m�latif da��l�m�n� d�nd�r�r; 
	-- yani, ge�erli sat�rdaki de�erden k���k veya ona e�it partition de�erlerinin y�zdesidir. 
	-- Bu, partition'un s�ralamas�ndaki current row'dan �nceki veya e� olan SATIR SAYISINI, 
		-- partitiondaki TOPLAM SATIR SAYISINA B�LEREK temsil eder. 
		-- 0 ile 1 aras�nda de�i�en sonu�lar return eder ve partition'daki en b�y�k de�er 1 dir.

-- PERCENT_RANK:

-- En y�ksek de�er hari�, ge�erli sat�rdaki de�erden k���k partition de�erlerinin y�zdesini d�nd�r�r. 
	--Return de�erleri 0 ile 1 aras�ndad�r. 
	--Form�l� �udur: (rank - 1) / (rows - 1) burada rank, o sat�r�n rank'i; rows, partition sat�rlar�n�n say�s�d�r. 

-- ARALARINDAK� FARKI �U �EK�LDE �ZAH EDEB�L�R�Z:

	-- PERCENT_RANK, current score'dan (o row'dan) daha d���k de�erlerin y�zdesini d�nd�r�r. 
	-- K�m�latif da��l�m anlam�na gelen CUME_DIST ise current skorun actual position'unu d�nd�r�r. 

	-- Yani bir partition'da (yukardaki �rnekte category_id'leri gruplam��t�m) 100 score (de�er) varsa 
		--ve PERCENT_RANK 90 ise, bu score'un 90 score'dan y�ksek oldu�u anlam�na gelir. 
		-- CUME_DIST 90 ise, bu, score'un listedeki 90. oldu�u anlam�na gelir.

-- CUME_DIST tekrar eden de�erleri iki kere hesaba kat�yor. ama PERCENT_RANK bir kere kat�yor.



--6. Her bir kategorideki bisikletleri artan fiyata g�re 4 gruba ay�r�n. M�mk�nse her grupta ayn� say�da bisiklet olacak.
	--(NTILE fonksiyonunu kullan�n�z)

SELECT	category_id, list_price,
		ROW_NUMBER () OVER (PARTITION BY category_id ORDER BY list_price) ROW_NUM,
		RANK () OVER (PARTITION BY category_id ORDER BY list_price) RANK_NUM,
		DENSE_RANK () OVER (PARTITION BY category_id ORDER BY list_price) DENSE_RANK_NUM,
		ROUND (CUME_DIST () OVER (PARTITION BY category_id ORDER BY list_price) , 2 ) CUM_DIST,
		ROUND (PERCENT_RANK () OVER (PARTITION BY category_id ORDER BY list_price) , 2 ) PERCENT_RNK,
		NTILE(4) OVER (PARTITION BY category_id ORDER BY list_price) ntil
FROM	production.products

-- NTILE : bir partition i�indeki de�erleri belirledi�imiz paremetre say�s�na (burada 4) b�l�yor ve her b�l�me numara at�yor
	-- kategory_id ye g�re gruplad�k. list_price a g�re s�ralad�k.
	-- 59 de�er var. NTILE bunlar� 4'e b�l�yor (parametre olarak 4 girdi�imiz i�in)
	-- 15'er 15'er bunlara s�ra numaras� veriyor. ilk 15'e 1 diyor, sonraki 15'e 2 diyor.... son gruba da 4 diyor



	--�DEV OLARAK BIRAKILAN SORULAR:

--SORU 7: ma�azalar�n 2016 y�l�na ait haftal�k hareketli sipari� say�lar�n� hesaplay�n�z


--SORU 8: '2016-03-12' ve '2016-04-12' aras�nda sat�lan �r�n say�s�n�n 7 g�nl�k hareketli ortalamas�n� hesaplay�n.
