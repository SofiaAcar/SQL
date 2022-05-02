
-- Create above table (transactions) and insert values

use SampleSales;

CREATE TABLE Transactions (
             Sender_ID INT, 
			 Receiver_ID INT, 
			 Amount INT, 
			 Transaction_Date DATE NOT NULL
			               );

INSERT INTO Transactions (Sender_ID, Receiver_ID, Amount, Transaction_Date)
                 VALUES (55, 22, 500, '20210518'),
						(11, 33, 350, '20210519'),
						(22, 11, 650, '20210519'),
						(22, 33, 900, '20210520'),
						(33, 11, 500, '20210521'),
						(33, 22, 750, '20210521'),
						(11, 44, 300, '20210522')
                             

-- Sum amounts for each sender (debits) and receiver (credits),

SELECT Sender_ID, SUM(Amount) AS Sender_Sum
FROM Transactions
GROUP BY Sender_ID;

SELECT Receiver_ID, SUM(Amount) AS Receiver_Sum
FROM Transactions
GROUP BY Receiver_ID;

-- Full (outer) join debits and credits tables on account id, taking net change as difference between credits and debits, coercing nulls to zeros with coalesce()

SELECT coalesce(S.Sender_ID, R.Receiver_ID) AS Account_ID, (coalesce(R.Receiver_Sum,0) - coalesce(S.Sender_Sum,0)) AS Net_Change
FROM (SELECT Sender_ID, SUM(Amount) AS Sender_Sum
      FROM Transactions
      GROUP BY Sender_ID) AS S
FULL OUTER JOIN (SELECT Receiver_ID, SUM(Amount) AS Receiver_Sum
                 FROM Transactions
                 GROUP BY Receiver_ID) AS R
ON S.Sender_ID = R.Receiver_ID
ORDER BY Net_Change DESC;

/* coalesce(S.Sender_ID, R.Receiver_ID): 
      Sender_ID de NULL görürsen, 
      Receiver_ID deki ayný satýrdaki deðerle doldur.
   
   (coalesce(R.Receiver_Sum,0) - coalesce(S.Sender_Sum,0)): 
      Receiver_ID de NULL var ise onu yerine 0 yaz. 
      Sender_ID de NULL var ise onun yerine 0 yaz.
      (Çýkarma iþleminin sonucunu etkilemesin diye 0 yazdýrdýk)
      Bulduðun deðerleri birbirinden çýkar.
*/


-- Tablo oluþturma satýrlarýn tek tek çalýþtýrýlmasý ile de yapýlabilir: 
/*
INSERT INTO Transactions (Sender_ID  , Receiver_ID,  Amount, Transaction_Date)VALUES('55', '22', '500', '18-05-2021');
INSERT INTO Transactions (Sender_ID  , Receiver_ID,  Amount, Transaction_Date)VALUES('11',	'33',	'350',	'19-05-2021');
INSERT INTO Transactions (Sender_ID  , Receiver_ID,  Amount, Transaction_Date)VALUES('22',	'11',	'650',	'19-05-2021');
INSERT INTO Transactions (Sender_ID  , Receiver_ID,  Amount, Transaction_Date)VALUES('22',	'33',	'900',	'20-05-2021');
INSERT INTO Transactions (Sender_ID  , Receiver_ID,  Amount, Transaction_Date)VALUES('33',	'11',	'500',	'21-05-2021');
INSERT INTO Transactions (Sender_ID  , Receiver_ID,  Amount, Transaction_Date)VALUES('33',	'22',	'750',	'21-05-2021');
INSERT INTO Transactions (Sender_ID  , Receiver_ID,  Amount, Transaction_Date)VALUES('11',	'44',	'300',	'22-05-2021');
*/


/* Tek sütuna veri girme:
INSERT INTO assignment1 (Sender_id)
VALUES (11), (22), (22), (23) 
*/