-- 15.07.2021 DawSQL Sessinon 2    (###########  GEN�� A�IKLAMALI  ##############)

------------------ CROSS JOIN
-- Write a query that returns the table to be used to add products that are in the Products table 
-- but not in the stocks table to the stocks table with quantity = 0. 
-- (Do not forget to add products to all stores.)
-- Expected columns: store_id, product_id, quantity
-- (TR) �r�nler tablosundaki �r�nleri eklemek i�in kullan�lacak tabloyu d�nd�ren bir sorgu yaz�n
-- ancak stok tablosunda de�il, miktar = 0 olan stok tablosuna
-- T�m ma�azalara �r�n eklemeyi unutmay�n

SELECT B.store_id, A.product_id, A.product_name, 0 quantity -- quantity ad�nda s�tun olu�turup i�ine 0 giriyor. ��nk� stokta olmayan �r�nlerin id leri ile cross join yapaca��z.
FROM production.products AS A
CROSS JOIN sales.stores AS B
-- b�yle yaparsak production.products tablosundaki t�m product_id leri kullanm�� oluruz. 
-- ama bizden stokta olmayan product'lar� ma�azalarla cross join yapmam�z� istiyor.
-- yani sto�u 0 olan hangi �r�nler hangi ma�azada bunu g�rmek istiyoruz!!

-- �imdi product_id'si prodcution.stocks tablosunda olmayan �r�nleri se�erek bu i�lemi yapal�m.
SELECT B.store_id, A.product_id, A.product_name, 0 quantity -- quantity ad�nda s�tun olu�turup i�ine 0 giriyor. ��nk� stokta olmayan �r�nlerin id leri ile cross join yapaca��z.
FROM production.products AS A
CROSS JOIN sales.stores AS B
WHERE A.product_id NOT IN (SELECT product_id FROM production.stocks) -- product_id'si stoklarda olmayan �r�nlerin product_id'lerini se�.
ORDER BY A.product_id, B.store_id                                    -- ve b�ylece products tablosunu stores ile cross join ederken stokta olmayan bu product_id leri kullan.
-- CROSS JOIN EDECE��M�Z BU �K� TABLO ARASINDA ORTAK S�TUN OLMADI�INA D�KKAT ETT�N M�!!!





------------------------ CROSS JOIN------------------------

-- Soru1: Hangi markada hangi kategoride ka�ar �r�n oldu�u bilgisine ihtiya� duyuluyor
-- �r�n say�s� hesaplamadan sadece marka * kategori ihtimallerinin hepsini i�eren bir tablo olu�turun
-- ��kan sonucu daha kolay yorumlamak i�in brand_id ve category_id alanlar�na g�re s�ralay�n.

-- ka� farkl� kategori * marka kombinasyonu yapabilirim bunu istiyor. bu t�r durumlarda CROSS JOIN kullan�yoruz.
-- yani benden A tablosundaki her (g�zlemi) sat�r� B tablosundaki her bir sat�rla e�le�tirmemi bekliyor

SELECT *
FROM production.brands
-- 9 marka oldu�unu g�rd�m

SELECT *
FROM production.categories
-- 7 kategori var.

-- kartezyen �arp�m yaparak her brand i�in 7 kategoriyi e�le�tirecek. 9 x 7 = 63 sat�r sonu� ��kacak.

SELECT *
FROM production.brands
CROSS JOIN production.categories
order by
brand_id, category_id -- buraya sadece A.brand_id yazsak da category_id'lerini de kendi i�inde s�ral�yor.
-- iki tablodan yaln�zca brands tablosunda brand_id oldu�undan production.brands.brand_id olarak uzun yazmaya gerek yok!


----- SELF JOIN------
-- ayn� INNER JOIN gibidir. ayn� tabloyu tekrar kendisi ile join ederek kendi i�erisinde bilgiye ula�maya �al���yoruz.


-- Soru2: Write a query that returns the staff with their managers.
-- Expected columns: staff first name, staff last name, manager name
--(TR) Personeli y�neticileriyle birlikte d�nd�ren bir sorgu yaz�n.

--hem staff'ler hem manager'ler ayn� sales.staffs tablosu i�indeler. 
   --bu tablo kendi kendine ili�ki i�erisinde. bu tabloda iki tane s�tun birbiri ile ayn� bilgiyi ta��yor.
    -- burda staff_id ile manager_id birbiri ile ili�ki i�inde. her staff'in bir manageri var ve bu manager ayn� zamanda bir staff..
     -- mesela staff_id si 2 olan Mireya'n�n manager_id'si 1.,  yani staff_id'si 1 olan ki�i Mireya'n�n manageri

--ayn� tabloyu kendisi ile join edece�im.
SELECT *
FROM sales.staffs

SELECT *
FROM sales.staffs AS A 
JOIN sales.staffs AS B
ON A.manager_id = B.staff_id --A tablosundan gelecek manager (manager_id), B tablsundaki staff olacak!

-- JOIN'i FROM-WHERE ile de yapabiliyoruz!! From'da tablolar� virg�lle ay�r�p ON sat�r�ndaki e�le�meyi WHERE ile yapabiliyoruz.
SELECT A.first_name AS Staff_Name, A.last_name AS Staff_Last, B.first_name AS Manager
FROM sales.staffs A, sales.staffs B
WHERE  A.manager_id = B.staff_id





------------------------ GROUPBY / HAVING ---------------

-- SQL'in kendi i�indeki i�lem s�ras�:
   -- FROM		: hangi tablolara gitmem gerekiyor?
   -- WHERE		: o tablolardan hangi verileri �ekmem gerekiyor?
   -- GROUP BY	: bu bilgileri ne �ekilde gruplayay�m?
   -- SELECT	: neleri getireyim ve hangi aggragate i�lemine tabi tutay�m.
   -- HAVING	: yukardaki sorgu sonucu ��kan tablo �zerinden nas�l bir filtreleme yapay�m
				 -- (mesela list_price>1000) 
				 -- gruplama yapt���m�z ayn� sorgu i�inde bir filtreleme yapmak istiyorsak HAVING kullanaca��z
				 -- HAVING kullanmadan; 
				 -- HAVING'ten yukar�s�n� al�p ba�ka bir SELECT sorgusunda WHERE �art� ile de bu filtrelemeyi yapabiliriz.
   -- ORDER BY	: ��kan sonucu hangi s�ralama ile getireyim?


-- bu kod sadece �zerinde a��klama yapmak i�in yaz�ld�, �al��t�rmay�n�z.
SELECT dept_name, AVG(salary) AS avg_salary -- gruplad���m�z sat�rlar�n kar��s�na ortalama salary bilgilerini koy.
FROM department
GROUP BY dept_name   -- dept_name'in sat�rlar�n� kendi i�inde grupla (unique de�erlerini al)
HAVING avg_salary > 50000; --groupby ve aggregation sonucu ortaya ��kan tabloya s�n�rlama getir.

---D�KKAT! HAVING �LE SADECE AGGREGATE ETT���M�Z S�TUNA KO�UL VEREB�L�R�Z! 





--GROUPING OPERATION SORU 1: 
--Write a query that checks if any product id is repeated in more than one row in the products table.
--(TR) �r�nler tablosunda herhangi bir �r�n kimli�inin birden fazla sat�rda tekrarlan�p tekrarlanmad���n� kontrol eden bir sorgu yaz�n

SELECT product_name, COUNT(product_name)
FROM production.products
GROUP BY product_name
HAVING COUNT(product_name) > 1; ----HAVING�DE KULLANDI�IN S�TUN, AGGREGATE TE KULLANDI�IN S�TUN �SM�YLE AYNI OLMALI!!. 
-- yukardaki ��z�m product isimlerinin tekrar edip etmedi�ini verdi. 
-- oysa bizden istenen product_id lerden tekrar eden ar m�? yani product_id ler �zerinden i�lem yapmal�y�z!

-- hocan�n ��z�m�:
-- �nce products lar� g�relim.
SELECT TOP 20* 
FROM production.products

SELECT product_id, COUNT(*) AS CNT_PRODUCT   
-- count(*) t�m rowlar� say demek. tablomuzda row'lar product_id lerden olu�tu�u i�in burada count(product_id) de ayn� i�i g�r�r.
FROM production.products					   
GROUP BY product_id 
-- b�t�n product_id lerin product tablosunda birer kere ge�ti�ini g�rd�m.


SELECT product_id, COUNT(*) AS CNT_PRODUCT 
FROM production.products
GROUP BY product_id		
HAVING COUNT(*) > 1  --sat�r( product_id) say�s� 1'den fazla olan sonu�lar� getir.            
--HAVING�DE KULLANDI�IN S�TUN, AGGREGATE TE KULLANDI�IN S�TUN �SM�YLE AYNI OLMALI!! 

-- product_name e g�re yapal�m:
SELECT product_name, COUNT(*) AS CNT_PRODUCT  -- count(*) t�m rowlar� say demek. Burda count(product_id) de ayn� i�i g�r�r.
FROM production.products
GROUP BY product_name 
HAVING COUNT (*) > 1
--29 sat�r sonu� ��kt�. demek ki ayn� product_name'den 1'den fazla olan 29 adet var.

-- a�a��daki gibi de kullanabiliriz.
SELECT product_name, COUNT(product_id) AS CNT_PRODUCT 
FROM production.products
GROUP BY product_name		
HAVING COUNT (product_id) > 1  --SQLite HAVING'te takma ad kullanmana izin veriyor ancak SQL Server izin vermiyor!
		
-- B�R SAYMA ��LEM�, B�R GRUPLANDIRMA B�R AGGREGATE ��LEM� YAPIYORSAN �S�MLE DE��L ID �LE YAP.
-- ID'LER HER ZAMAN B�RER DEFA GE�ER, �S�MLER TEKRAR EDEB�L�R (�R:B�R KA� PRODUCT'A AYNI �S�M VER�LM�� OLAB�L�R)!

SELECT product_id, product_name, COUNT (*) CNT_PRODUCT
FROM production.products
GROUP BY product_name   --BU SATIRA D�KKAT!
HAVING COUNT (*) > 1
-- SELECT SATIRINDA YAZDI�IN S�TUNLARIN HEPS� GROUP BY'DA OLMASI GEREK�YOR! 
-- production_id GROUP BY SATIRINDA OLMADI�I ���N HATA VERD�!

--do�ru hali a�a��daki gibidir:
SELECT product_id, product_name, COUNT (*) CNT_PRODUCT
FROM production.products
GROUP BY product_name, product_id
HAVING COUNT (*) > 1





--GROUPING OPERATION SORU 2: 
-- Write a query that returns category ids with a maximum list price above 4000 or a minimum list price below 500
-- (TR) Maksimum liste fiyat� 4000'in �zerinde veya minimum liste fiyat� 500'�n alt�nda olan kategori kimliklerini d�nd�ren bir sorgu yaz�n

SELECT category_id, MIN(list_price) AS min_price, MAX(list_price) AS max_price -- gruplad���m�z �ey category_id oldu�u i�in SELECT'te onu getiriyoruz
FROM production.products
-- ana tablo i�inde herhangi bir k�s�tlamam var m� yani where i�lemi var m�? yok. O zaman devam ediyorum
-- ANA TABLO ���NDE HERHANG� B�R KISITLAMA YAPMACAKSAN "WHERE" SATIRI KULLANMAYACAKSIN DEMEKT�R.
GROUP BY
		category_id
HAVING
		MIN(list_price) < 500 OR MAX(list_price) > 4000
		--group by ve agg. neticesinde ��kan tabloyu bu conditionlara g�re filtreleyip getirdik.
		-- Dikkat! soruyu iyi okumal�s�n. soruda veya dedi�i i�in OR kulland�k




--GROUPING OPERATION SORU 3-- 
-- Find the average product prices of the brands. 
-- As a result of the query, the average prices should be displayed in descending order.
-- (TR) Markalar�n ortalama �r�n fiyatlar�n� bulun. Sorgu sonucunda ortalama fiyatlar azalan s�rada g�r�nt�lenmelidir.

-- Bir kere AVERAGE istedi�i i�in GROUP BY kullanmam gerekti�ini anl�yorum!
-- SORUDA AVERAGE VEYA TOPLAM G�B� AGGREGATE ��LEM� GEREKT�RECEK B�R �STEK VARSA HEMEN "GROUP BY" KULLANMAM GEREKT���N� ANLAMALIYIM.
SELECT brand_id, AVG(list_price) AS AVG_PRICE
FROM production.products
GROUP BY brand_id
ORDER BY AVG_PRICE DESC
-- brand_id lere g�re yapt���m�z i�in ayn� products tablosu yetti. 
-- fakat brand_name'lere g�re gruplamak istersek tablo birle�tirmeliyiz.

--brands tablosundan brand_name leri �ekip gruplayaca��z, kar��lar�na products tablosundan �ekti�imiz list_price'lar�n ortalamas�n� koyaca��z.
SELECT A.brand_name, AVG(B.list_price) AS AVG_PRICE
FROM production.brands A, production.products B  -- buradaki virg�l INNER JOIN ile ayn� i�i yap�yor! virg�lle beraber WHERE kullan�yoruz.
WHERE A.brand_id = B.brand_id
GROUP BY 
		A.brand_name
ORDER BY
		AVG_PRICE DESC -- ORDER BY 2 DESC olarak da yazabilirdik. Burada 2 --> SELECT sat�r�ndaki 2. veriyi temsil ediyor.

-- (virg�l + WHERE yerine--> INNER JOIN ile ��z�m)
SELECT A.brand_name, AVG(B.list_price) AS AVG_PRICE
FROM production.brands AS A
INNER JOIN production.products AS B
ON A.brand_id = B.brand_id
GROUP BY 
		A.brand_name
ORDER BY 
		AVG_PRICE DESC
-- ORDER BY 2 DESC olarak da yazabilirdik. Burada 2 --> SELECT sat�r�ndaki 2. veriyi temsil ediyor.




--GROUPING OPERATION SORU 4: 
-- Write a query that returns BRANDS with an average product price more than 1000
-- (TR) Ortalama �r�n fiyat� 1000'den fazla olan MARKALARI d�nd�ren bir sorgu yaz�n.

-- Virg�l + WHERE kullanarak ��z�m�:
SELECT A.brand_name, AVG(B.list_price) AS AVG_PRICE
FROM production.brands A, production.products B  
WHERE A.brand_id = B.brand_id
GROUP BY 
		A.brand_name
HAVING AVG(B.list_price) > 1000
ORDER BY
		2 DESC

-- INNER JOIN ile ��z�m�:
SELECT B.brand_name, AVG(list_price) as avg_price
FROM production.products as A
INNER JOIN production.brands as B
ON A.brand_id = B.brand_id
GROUP BY brand_name
HAVING AVG (list_price) > 1000
ORDER BY avg_price ASC;



--GROUPING OPERATION SORU 5: 
--Write a query that returns the net price paid by the customer for each order. (Don't neglect discounts and quantities)
--(TR) Her sipari� i�in m��terinin �dedi�i net fiyat� d�nd�ren bir sorgu yaz�n. (�ndirimleri ve miktarlar� ihmal etmeyin)

SELECT *, (quantity * list_price * (1-discount)) as net_price -- (list_price-list_price*discount) olarak da yaz�labilirdi.
FROM sales.order_items
-- bu query ile �nce her bir item i�in list_price ve indirim uygulanm�� net_price lar� g�r�yoruz.
-- baz� order'larda birden fazla �r�n sipari� verildi�ini g�r�yoruz. (�r: 1 no. lu order_id'nin 5 adet item_id'si var.)
-- O y�zden �r�nleri order_id olarak grupland�r�p her grup i�in toplama (SUM) yaparsak her order i�in �denen toplam item fiyat�n� buluruz.
	-- yani her order_id i�in TOPLAM net_price'� g�rm�� olaca��m. (zaten soru "for each order" �eklinde bitiyordu)

SELECT order_id, SUM(quantity * list_price * (1-discount)) as net_price
FROM sales.order_items
GROUP BY 
		order_id

-- ayn� soruyu customer'lar� esas alarak ��zersek :
	--order_items tablosunda customer bilgileri olmad���ndan sales_orders tablosunu birle�tirece�im.
SELECT B.customer_id, SUM(quantity * (list_price - (list_price*A.discount))) AS TOTAL_NET_PRICE
FROM sales.order_items A, sales.orders B
where A.order_id = B.order_id
group by B.customer_id





--------------------- GROUPING SETS -----------------

-- B�RDEN FAZLA GRUPLAMA KOMB�NASYONU YAPMAMA �MKAN SA�LIYOR. 
-- GROUP BY'dan fark� : GROUP BY sadece bir s�tunun verilerini grupluyordu. GROUPING SET ile ise birden fazla gruplama varyasyonu yapabiliyoruz

GROUP BY
GROUPING SETS 
(
(Product),
(Product, Size)
)
-- BURDA �K� SET HAL�NDE GRUPLUYOR. ��yle ki: Mesela Product s�tunu "jean", "tshirt" ve "jacket" unique verilerinden olu�sun.
	-- �nce gruplaman�n 1. setinin (Product) ilk verisini ("jean") al�p kar��l���n� birinci sat�ra yaz�yor, 
		-- sonra 2. setin (Product, Size grupland�rmas�n�n) ilk verilerini yani jean'in "size" gruplar�n�n kar��l�klar�n� s�rayla alt�na yaz�yor. 
		-- bu bitince tekrar 1. setin (Product) ikinci verisi olan "tshir"� al�p kar��l���ndaki de�eri alt�na yaz�yor.
		-- sonra 2. setin (Product, Size grupland�rmas�n�n) ikinci verilerini yani tshirt'�n "size" gruplar�n�n kar��l�klar�n� s�rayla yaz�yor 
		-- ve b�ylece product verileri bitene kadar devam ediyor.





-------------- CREATING SUMMARY TABLE INTO OUR EXISTING TABLE -----------

SELECT *
INTO NEW_TABLE     -- INTO SATIRINDAK� TABLO �SM� �LE YEN� B�R TABLO OLU�TURUYORUZ.
FROM SOURCE_TABLE  -- FROM'DAN SONRASI KAYNAK TABLOMUZ
WHERE ...
-- SELECT INTO kal�b� bize �unu sa�l�yor: 
	-- yeni bir tablo olu�turmak istedi�imde, di�er tablolardan ortaya ��kartt���m yeni de�erlerden olu�an tabloyu 
	-- h�zl� bir �ekilde yeni bir tabloya kopyalamay� sa�l�yor.

	-- ��MD� YEN� B�R TABLO OLU�TURALIM.

-- brands tablosundan brand_name, categories tablosundan category_name, products tablosundan model_year
	-- s�tunlar�n� se�iyorum, indirim uygulanm�� net fiyatlar� yuvarlayarak olu�turdu�um s�tunu da total_sales_price ismi vererek se�iyorum.
	-- bu s�tunlardan grupland�r�lm�� haliyle sales_summary ad�nda yeni bir tablo olu�turuyorum

SELECT C.brand_name as Brand, D.category_name as Category, B.model_year as Model_Year,
ROUND (SUM (A.quantity * A.list_price * (1 - A.discount)), 0) total_sales_price --gruplar�n toplam net sat�� fiyatlar�ndan olu�an s�tun.
-- SELECT sat�r�nda yeni olu�turaca��m tabloda bulunmas�n� istedi�im s�tunlar� yazd�ktan sonra
	-- bunlar� g�nderecec�im yeni tablonun ismini INTO sat�r�nda belirliyorum : sales.sales_summary tablosu..
INTO sales.sales_summary  -- s�tunlar�n� SELECT sat�r�nda belirledi�im yeni tablonun ismini burada belirliyorum.
FROM sales.order_items A, production.products B, production.brands C, production.categories D  --SELECT sat�r�nda se�ti�imiz s�tunlara ait tablolar.
WHERE A.product_id = B.product_id --A ile B tablolar�n� product_id ile birle�tirdik.
AND B.brand_id = C.brand_id  -- B ile C tablolar�n� brand_id ile birle�tirdik
AND B.category_id = D.category_id --B ile D'yi categroy_id ile birle�tirdik. hepsini birle�tirmi� olduk.
GROUP BY
C.brand_name, D.category_name, B.model_year  --group by sat�r�nda grupland�rd���m�z s�tunlar SELECT'te aynen olmal�!!

--!!!! D�KKAT.. DAHA �NCE BU KOD �ALI�TIRILDI�I VE sales_summary �SM�NDE TABLO OLU�TURULDU�U ���N TEKRAR �ALI�TIRIRSAN HATA ALIRSIN!

SELECT *
FROM sales.sales_summary
ORDER BY 1,2,3




----- BUNDAN SONRAK� SORULARDA BU TABLOYU KULLANACA�IM!


-- 1. Toplam sat�� miktar�n� hesaplay�n�z.
SELECT SUM(total_sales_price)
FROM sales.sales_summary

-- 2. Markalar�n toplam sat�� miktar�n� hesaplay�n�z.

SELECT Brand, SUM(total_sales_price)
FROM sales.sales_summary
GROUP BY 
		Brand

-- 3. Kategori baz�nda toplam sat�� miktar�n� hesaplay�n�z
SELECT Category, SUM(total_sales_price)
FROM sales.sales_summary
GROUP BY 
		Category

-- 4. Marka ve kategori k�r�l�mlar�ndaki toplam sales miktarlar�n� hesaplay�n�z
SELECT Brand, Category, SUM(total_sales_price)
FROM sales.sales_summary
GROUP BY 
		Brand, Category





---------------- �imdi bu i�lemleri GROUPING SETS y�ntemi ile yapal�m :---------

SELECT Brand, Category, SUM(total_sales_price) TOTAL_SALES_PRICE
FROM sales.sales_summary
GROUP BY
		GROUPING SETS(
						(Brand),
						(Category),
						(Brand, Category),
						()    -- bo� parantez grupland�rma olmayan durumlar� getirir. 
						)
ORDER BY
		1, 2

-- �ncelikle �unu s�yleyim; grouping sets sat�r�ndaki s�ralama �nemli de�il, burada setleri parantez i�inde g�stermek yeterli.
	-- SQL sonu� tablosunu, SELECT sat�r�ndaki s�ralamaya g�re olu�turuyor. bunu asla unutmayal�m.

-- !! Ayr�ca bu sat�rda hangi s�tunun �nce yaz�ld��� �nem arzediyor. 
	-- ��nk� ilk yaz�lan s�tunun elemanlar� tek tek s�ra ile ikinci s�tunun grupland�rmas�na tabi oluyor!

-- Gelelim sonu� tablosunun a��klamas�na:
-- Birinci sat�rda bo� parantezin sonucu sergilendi. 
	-- Bu sat�rda grupland�rma olmad���ndan kar��l���na t�m sat�rlar�n toplam� olan TOTAL_SALES_PRICE de�eri geldi.

-- 2. sat�rdan 8.sat�r dahil, yaln�zca Category'e g�re grupland�rd� ve category'nin (ikinci s�radaki s�tunun) tek ba��na grupland�rma i�i burada bitti. 
	-- Burada category'nin her grubunun toplam�n� TOTAL_SALES_PRICE s�tununa yazd�. Brand s�tunda kar��l��� olmad���ndan buralara komple NULL geldi.

-- 9. sat�rdan itibaren ��yle bir grupland�rma d�ng�s�n�n i�ledi�ini g�r�yoruz: 
	-- (Brand 1.eleman�) --> (Brand 1.eleman�, Category) --> (Brand 2.elaman�) --> (Brand 2.elaman�, Category) -->-->--> b�ylece devam ediyor.
	--  yani 9, 14, 17, 19, 21, 23, 25, 31 ve 35. sat�rlarda Brand'in tek ba��na gruplanm�� sat�rlar�d�r. 
	-- aralar�ndaki sat�rlar ise g�rece�iniz �zere (Brand, Category) ikili grupland�rmas�na aittir.
	-- Bu demektir ki �rne�in Elektra markas�n�n kategorilerinin s�raland��� 10-13 sat�rlar�ndaki value'lar�n toplam�, Elektra markas�n�n tek ba��na grupland��� 9.sat�rdaki value'ya e�ittir.

-- B�ylece GROUPING SETS de belirtti�imiz grupland�rma setlerini alt alta gelecek �ekilde return etmi� oluyor.

					----- Marie Curie hocama binlerce te�ekk�r -----




----------------- ROLLUP VE CUBE ile GRUPLAMA------------------

-- ROLLUP, en ayr�nt�l�dan genel toplama kadar ihtiya� duyulan herhangi bir toplama d�zeyinde alt toplamlar olu�turur.
-- CUBE, ROLLUP�a benzer ama tek bir ifadenin t�m olas� alt toplam kombinasyonlar�n� hesaplamas�n� sa�lar
 



-------------- ROLLUP GRUPLAMA-------------

--SYNTAX:
SELECT
		d1,
		d2,
		d3, 
		aggregate_function
FROM
		table_name
GROUP BY
		ROLLUP (d1,d2,d3);

	-- �nce t�m s�tunlar� al�p grupluyor, sonra sa�dan ba�layarak teker teker s�tun silerek her defas�nda yeniden bir gruplama yap�yor;
		-- �nce �� s�tuna g�re grupluyor, sonra sondakini at�p ilk 2 s�tuna g�re grupluyor,
		-- sonra sondakini yine at�p ilk s�tuna g�re grupluyor
		-- sonra hi� gruplam�yor.-- 

SELECT brand, category, SUM(total_sales_price)
FROM sales.sales_summary
GROUP BY
		ROLLUP (Brand, Category)
ORDER BY
		1,2;
-- sonu� tablosunu GROUPING SETS te oldu�u gibi ayn� mant�kla s�ral�yor. (brand-1) + (brand-1,category) + (brand-2) + (brand-2, category) + .....




------------------- CUBE GRUPLAMA----------------------
SELECT
		d1,
		d2,
		d3, 
		aggregate_function
FROM
		table_name
GROUP BY
		CUBE (d1,d2,d3);

--- �nce �nce �� s�tunu birden grupluyor.               (d1,d2,d3)
-- sonra kalanlar� 2'�er 2'�er 3 defa gruplama yap�yor. (d1,d2) + (d1,d3) + (d2,d3)
-- sonra kalanlar� teker teker grupluyor.               (d1) + (d2) + (d3)   
-- en son gruplam�yor.                                  ()

SELECT brand, category, SUM(total_sales_price)
FROM sales.sales_summary
GROUP BY
		CUBE (Brand, Category)
ORDER BY
		1,2;



------------------------ BU NOTEBOOK'TA GE�EN �NEML� NOTLAR-----------------------------------

-- SQL'�N KEND� ���NDEK� ��LEM SIRASI:
   -- FROM		: hangi tablolara gitmem gerekiyor?
   -- WHERE		: o tablolardan hangi verileri �ekmem gerekiyor?
   -- GROUP BY	: bu bilgileri ne �ekilde gruplayay�m?
   -- SELECT	: neleri getireyim ve hangi aggragate i�lemine tabi tutay�m.
   -- HAVING	: yukardaki sorgu sonucu ��kan tablo �zerinden nas�l bir filtreleme yapay�m
				 -- (mesela list_price>1000) 
				 -- gruplama yapt���m�z ayn� sorgu i�inde bir filtreleme yapmak istiyorsak HAVING kullanaca��z
				 -- HAVING kullanmadan; 
				 -- HAVING'ten yukar�s�n� al�p ba�ka bir SELECT sorgusunda WHERE �art� ile de bu filtrelemeyi yapabiliriz.
   -- ORDER BY	: ��kan sonucu hangi s�ralama ile getireyim?

-- ANA TABLO ���NDE HERHANG� B�R KISITLAMA YAPMACAKSAN "WHERE" SATIRI KULLANMAYACAKSIN DEMEKT�R.

-- ORDER BY, SELECT'TEN SONRA �ALI�IYOR DOLAYISIYLA SELECT'TE YAZDI�IM ALLIAS'I KABUL EDER.

-- CROSS JOIN EDECE��M�Z �K� TABLO ARASINDA ORTAK S�TUN OLMASI GEREKM�YOR.

-- �K� VER�N�N KOMB�NASYONDAN BAHSED�YORSAK CROSS JOIN KULLANIYORUZ.

-- CROSS JOIN A tablosundaki her (g�zlemi) sat�r� B tablosundaki her bir sat�rla e�le�tiriyor.

-- SELF JOIN: INNER JOIN G�B�D�R. AYNI TABLOYU TEKRAR KEND�S�YLE JOIN EDEREK KEND� ��ER�S�NDE B�R B�LG�YE ULA�MAYA �ALI�IYORUZ.

-- JOIN'i FROM-WHERE �LE DE YAPAB�L�YORUZ! BUNUN ���N B�RLE�T�RECE��M�Z TABLOLARI FROM SATIRINDA V�RG�LLE YAN YANA YAZIP, 
	-- ON SATIRINDAK� E�LE�MEY� WHERE SATIRINDA YAPIYORUZ.

-- SORUDA AVERAGE VEYA TOPLAM G�B� AGGREGATE ��LEM� GEREKT�RECEK B�R �STEK VARSA HEMEN "GROUP BY" KULLANMAM GEREKT���N� ANLAMALIYIM.

-- B�R SAYMA ��LEM�, B�R GRUPLANDIRMA B�R AGGREGATE ��LEM� YAPIYORSAN �S�MLE DE��L ID �LE YAP.
	-- ID'LER HER ZAMAN B�RER DEFA GE�ER, �S�MLER TEKRAR EDEB�L�R (�R:B�R KA� PRODUCT'A AYNI �S�M VER�LM�� OLAB�L�R)!

-- SELECT SATIRINDA YAZDI�IN S�TUNLARIN HEPS� GROUP BY'DA OLMASI GEREK�YOR!

-- HAVING �LE SADECE AGGREGATE ETT���M�Z S�TUNA KO�UL VEREB�L�R�Z! . 
	--HAVING�DE KULLANDI�IN S�TUN, AGGREGATE TE KULLANDI�IN S�TUNLA AYNI OLMALI.

-- SQLite HAVING SATIRINDA TAKMA AD KULLANMANA �Z�N VER�YOR ANCAK SQL Server �Z�N VERM�YOR!

-- ORDER BY SATIRINDAK� �LK PARAMETRE (�RNE��N) 2 �SE BU SELECT SATIRINDAK� 2. VER�YE G�RE SIRALA DEMEKT�R.
	-- ORNE��N: ORDER BY AVG_PRICE DESC -- YER�NE--  ORDER BY 2 DESC -- DE YAZAB�L�R�Z.

-- CREATING SUMMARY TABLE INTO OUR EXISTING TABLE 

SELECT *
INTO NEW_TABLE     -- INTO SATIRINDAK� TABLO �SM� �LE YEN� B�R TABLO OLU�TURUYORUZ.
FROM SOURCE_TABLE  -- FROM'DAN SONRASI KAYNAK TABLOMUZ
WHERE ...

-- SELECT INTO kal�b� bize �unu sa�l�yor: 
	-- yeni bir tablo olu�turmak istedi�imde, di�er tablolardan ortaya ��kartt���m yeni de�erlerden olu�an tabloyu 
	-- h�zl� bir �ekilde yeni bir tabloya kopyalamay� sa�l�yor.

-- GROUPING SETS :

-- B�RDEN FAZLA GRUPLAMA KOMB�NASYONU YAPMAMA �MKAN SA�LIYOR. 
	-- GROUP BY'dan fark� : GROUP BY sadece bir s�tunun verilerini grupluyordu. 
	-- GROUPING SET ile ise birden fazla gruplama varyasyonu yapabiliyoruz

-- GROUPING SETS SATIRINDAK� SIRALAMA �NEML� DE��L, BURADA SETLER� PARANTEZ ���NDE G�STERMEK YETERL�.
	-- SQL, SONU� TABLOSUNU "SELECT" SATIRINDAK� SIRALAMAYA G�RE OLU�TURUYOR. 
	-- BU Y�ZDEN BU SATIRA HANG� S�TUNUN �NCE YAZILDI�I �NEM ARZ ED�YOR. 
	-- ��NK� �LK YAZILAN S�TUNUN ELEMANLARI RESULT TABLOSUNDA TEK TEK SIRA �LE �K�NC� S�TUNUN GRUPLANDIRMASINA TAB� OLUYOR!

-- ROLLUP GRUPLAMA:
	-- �nce t�m s�tunlar� al�p grupluyor, sonra sa�dan ba�layarak teker teker s�tun silerek her defas�nda yeniden bir gruplama yap�yor;
	-- �nce �� s�tuna g�re grupluyor, sonra sondakini at�p ilk 2 s�tuna g�re grupluyor,
	-- sonra sondakini yine at�p ilk s�tuna g�re grupluyor
	-- sonra hi� gruplam�yor.

-- CUBE GRUPLAMA:
	-- �nce �nce �� s�tunu birden grupluyor.                (d1,d2,d3)
	-- sonra kalanlar� 2'�er 2'�er 3 defa gruplama yap�yor. (d1,d2) + (d1,d3) + (d2,d3)
	-- sonra kalanlar� teker teker grupluyor.               (d1) + (d2) + (d3)   
	-- en son gruplam�yor.                                  ()
