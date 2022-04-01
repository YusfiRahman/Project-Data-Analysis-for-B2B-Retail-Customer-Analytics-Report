##Tabel yang digunakan pada projek
SELECT * FROM orders_1 LIMIT 5;
SELECT * FROM orders_2 LIMIT 5;
SELECT * FROM customer LIMIT 5;

##1a. Total Penjualan dan Revenue pada quarter_1 (Jan,Feb,Mar) dan quarter_2 (Apr,Mei,Jun)
SELECT 
SUM(quantity) AS total_penjualan,
SUM(quantity * priceeach) AS revenue
FROM orders_1
WHERE
status = 'Shipped';

SELECT
SUM(quantity) AS total_penjualan,
SUM(quantity * priceeach) AS revenue
FROM orders_2
WHERE
status = 'Shipped';


##1b. Menghitung persentasi keseluruhan penjualan
SELECT
quarter,
SUM(quantity) AS total_penjualan,
SUM(quantity * priceeach) AS revenue
FROM 
(SELECT 
orderNumber,
quantity,
status,
priceeach,
'1' AS quarter
FROM orders_1
UNION
SELECT
orderNumber,
quantity,
status,
priceeach,
'2' AS quarter
FROM orders_2)
AS tabel_a
WHERE
status = 'Shipped'
GROUP BY quarter;


##2. Apakah jumlah customers xyz.com semakin bertambah
SELECT
QUARTER(createDate) AS quarter,
COUNT(DISTINCT customerID) AS total_customers
FROM
(SELECT
customerID, 
createDate
FROM customer)
AS tabel_b
WHERE createDate BETWEEN '2004-01-01' AND '2004-06-30'
GROUP BY quarter;


##3. Seberapa banyak customers tersebut yang sudah melakukan transaksi
SELECT
QUARTER(createDate) AS quarter,
COUNT(DISTINCT customerID) AS total_customers
FROM
(SELECT
 customerID,
 createDate
 FROM
 customer
 WHERE
 (createDate BETWEEN '2004-01-01' AND '2004-06-30')
 AND
 customerID IN (
	SELECT
	DISTINCT customerID
	FROM orders_1
	UNION
	SELECT
	DISTINCT customerID
	FROM orders_2) 
	)
	AS tabel_b
GROUP BY quarter;


##4. Kategori produk apa saja yang paling banyak diorder oleh customers di quarter_2
SELECT 
SUBSTR(productCode, 1, 3) AS categoryid,
COUNT(DISTINCT orderNumber) AS total_order,
SUM(quantity) AS total_penjualan
FROM (
SELECT
productCode,
orderNumber,
quantity,
status
FROM
orders_2)
AS tabel_c
WHERE status = 'Shipped'
GROUP BY categoryid
ORDER BY total_order DESC;


##5. Seberapa banyak customers yang tetap aktif bertransaksi setelah transaksi pertamanya
#Menghitung total unik customers yang transaksi di quarter_1
SELECT COUNT(DISTINCT customerID) as total_customers FROM orders_1;
#output = 25
SELECT
1 AS quarter,
ROUND(COUNT(DISTINCT customerID)*100/25,4) AS Q2
FROM orders_1
WHERE customerID IN
	(SELECT
	 DISTINCT customerID
	 FROM orders_2);