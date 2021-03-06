# **Data Analysis for B2B Retail : Customer Analytics Report**

![B2B](https://user-images.githubusercontent.com/101962147/161251728-ab3a116c-b800-4952-80b4-989c17331f33.png)

<br/>

xyz.com adalah perusahan rintisan B2B yang menjual berbagai produk tidak langsung kepada end user tetapi ke bisnis/perusahaan lainnya. Sebagai data-driven company, maka setiap pengambilan keputusan di xyz.com selalu berdasarkan data. Setiap quarter xyz.com akan mengadakan townhall dimana seluruh atau perwakilan divisi akan berkumpul untuk me-review performance perusahaan selama quarter terakhir. Pada project ini saya melakukan customer analitycs report dari xyz.com dengan menggunakan MySQL.

Dengan asumsi bahwa tahun yang sedang berjalan adalah tahun 2004, adapun hal yang akan direview adalah :

1. Bagaimana pertumbuhan penjualan saat ini?
2. Apakah jumlah customers xyz.com semakin bertambah ?
3. Dan seberapa banyak customers tersebut yang sudah melakukan transaksi?
4. Kategori produk apa saja yang paling banyak dibeli oleh customers?
5. Seberapa banyak customers yang tetap aktif bertransaksi?

<br/>

<hr>

## **Dataset Brief**

![Relational Database Diagram](https://user-images.githubusercontent.com/101962147/161251814-0c0e8f27-90b5-4c96-913c-31d0a173b944.png)

Tabel yang akan digunakan pada project kali ini adalah sebagai berikut :

**Tabel orders_1** : Berisi data terkait transaksi penjualan periode quarter 1 (Jan - Mar 2004)

```SQL
SELECT * FROM orders_1 LIMIT 5;
```

![Tabel orders_1](https://user-images.githubusercontent.com/101962147/161251853-57035468-7eae-46e6-90f7-add6d16c062f.png)

<br/>

**Tabel Orders_2** : Berisi data terkait transaksi penjualan periode quarter 2 (Apr - Jun 2004)

```SQL
SELECT * FROM orders_2 LIMIT 5;
```

![Tabel orders_2](https://user-images.githubusercontent.com/101962147/161251867-236f5119-f168-4463-a37d-3c49faa2a293.png)

<br/>

**Tabel Customer** : Berisi data profil customer yang mendaftar menjadi customer xyz.com

```SQL
SELECT * FROM Customer LIMIT 5;
```

![Tabel Customer](https://user-images.githubusercontent.com/101962147/161251881-cc09ec57-3931-4199-b1b7-59726cc287bd.png)

<br/>

<hr>


## **Data Processing**
### **1. Bagaimana pertumbuhan penjualan saat ini?**

a. Total Penjualan dan Revenue pada Quarter-1 (Jan, Feb, Mar) dan Quarter-2 (Apr,Mei,Jun)

```SQL 
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
```

Adapun output yang dihasilkan adalah sebagai berikut :

![Query Output 1Aa](https://user-images.githubusercontent.com/101962147/161251924-46c70def-ee36-47bc-8753-211325a6a87d.png)

![Query Output 1Ab](https://user-images.githubusercontent.com/101962147/161251955-cdf2f0ab-6a60-4437-9924-294216dd6e5d.png)

<br/>

b. Menghitung persentasi keseluruhan penjualan

```SQL
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
```

Adapun output yang dihasilkan adalah sebagai berikut :

![Query Output 1B](https://user-images.githubusercontent.com/101962147/161251976-04173b37-60ce-4bcd-92f3-36012a0fb9d1.png)

Untuk mengetahui pertumbuhan penjualan maka dapat dilakukan dengan menghitung persentase penjualan bulan lalu dengan jumlah penjualan sebelumnya dan selisih pendapatan bulan terakhir dengan pendapatan periode sebelumnya :

```
% Y (t) = jumlah (jumlah (t)) - jumlah (jumlah (t-1)) / jumlah (jumlah (t-1))
% X (t) = jumlah (harga (t)) - jumlah (harga (t-1)) / jumlah (harga (t-1))
```

Dengan menggunakan rumus di atas, maka :

```
%Growth Penjualan = (6717–8694)/8694 = -22%
%Growth Revenue = (607548320–799579310)/ 799579310 = -24%
```
Didapat % growth penjualan dan % growth revenue secara berturut-turut yaitu sebesar -22% dan -24%

<br/>

### **2. Apakah jumlah customers xyz.com semakin bertambah ?**

Penambahan jumlah customers dapat diukur dengan membandingkan total jumlah customers yang registrasi di periode saat ini dengan total jumlah customers yang registrasi diakhir periode sebelumnya.

```SQL
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
```

Adapun output yang dihasilkan adalah sebagai berikut :

![Query Output 2](https://user-images.githubusercontent.com/101962147/161252403-1373b705-933c-456b-9077-ae7581ad8d19.png)


<br/>

### **3. Dan seberapa banyak customers tersebut yang sudah melakukan transaksi?**

Problem ini merupakan kelanjutan dari problem sebelumnya yaitu dari sejumlah customer yang registrasi di periode quarter-1 dan quarter-2, berapa banyak yang sudah melakukan transaksi.

```SQL
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
```

Adapun output yang dihasilkan adalah sebagai berikut :

![Query Output 3](https://user-images.githubusercontent.com/101962147/161252422-87ec3bcc-3056-4211-a1eb-d30943ee9b70.png)


Untuk mengetahui persentase customer xyz.com yang sudah melakukan transaksi digunakan rumus sebagai berikut :

```
% Customer yang sudah melakukan transaksi = (Jumlah Customer yang bertransaksi di quarter 1 & quarter 2) * 100 / (Jumlah Customer pada quarter 1 & quarter 2)
```

Dengan menggunakan rumus di atas, maka :

```
% Customer yang sudah melakukan transaksi = (25 + 19) * 100 / (43 + 35) = 56.41 %
```

Didapat % costumer yang sudah melakukan transaksi yaitu sebesar 56.41 %

<Br/>

### **4. Kategori produk apa saja yang paling banyak dibeli oleh customers?**

Untuk mengetahui kategori produk yang paling banyak dibeli, maka dapat dilakukan dengan menghitung total order dan jumlah penjualan dari setiap kategori produk.

```SQL
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

```

Adapun output yang dihasilkan adalah sebagai berikut :

![Query Output 4](https://user-images.githubusercontent.com/101962147/161252438-0859a65b-5651-438f-b324-b939482f9a8b.png)

Dari data di atas didapat bahwa produk kategori S18 dan S24 berkontribusi sekitar 50% dari total order dan 60% dari total penjualan.

<br/>

### **5. Seberapa banyak customers yang tetap aktif bertransaksi?**

Mengetahui seberapa banyak customers yang tetap aktif menunjukkan apakah xyz.com tetap digemari oleh customers untuk memesan kebutuhan bisnis mereka. Hal ini juga dapat menjadi dasar bagi tim product dan business untuk pengembangan product dan business kedepannya. Untuk project ini, dihitung retention dengan query SQL sederhana.

```SQL
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
```

Adapun output yang dihasilkan adalah sebagai berikut :

![Query Output 5A](https://user-images.githubusercontent.com/101962147/161252461-2116d29d-22de-44d0-8925-55acc46daa14.png)

![Query Output 5B](https://user-images.githubusercontent.com/101962147/161252483-6371992f-e347-41d1-879e-55d6384d6d99.png)

Didapat bahwa dari 25 customers yang melakukan transaksi di quarter-1, hanya 24% customer saja yang tetap aktif melakukan transaksi kembali di quarter-2.

<br/>

<hr>

## **Conclusion**
Berdasarkan data yang telah kita peroleh melalui query SQL, Kita dapat menarik kesimpulan bahwa :

1. Performance xyz.com menurun signifikan di quarter ke-2, terlihat dari nilai penjualan dan revenue yang drop hingga 20% dan 24%, perolehan customer baru juga tidak terlalu baik, dan sedikit menurun dibandingkan quarter sebelumnya.
2. Ketertarikan customer baru untuk berbelanja di xyz.com masih kurang, hanya sekitar 56% saja yang sudah bertransaksi. Disarankan tim Produk untuk perlu mempelajari behaviour customer dan melakukan product improvement, sehingga conversion rate (register to transaction) dapat meningkat.
3. Produk kategori S18 dan S24 berkontribusi sekitar 50% dari total order dan 60% dari total penjualan, sehingga xyz.com sebaiknya fokus untuk pengembangan category S18 dan S24.
4. Retention rate customer xyz.com juga sangat rendah yaitu hanya 24%, artinya banyak customer yang sudah bertransaksi di quarter-1 tidak kembali melakukan order di quarter ke-2 (no repeat order).
5. xyz.com mengalami pertumbuhan negatif di quarter ke-2 dan perlu melakukan banyak improvement baik itu di sisi produk dan bisnis marketing, jika ingin mencapai target dan positif growth di quarter ke-3. Rendahnya retention rate dan conversion rate bisa menjadi diagnosa awal bahwa customer tidak tertarik/kurang puas/kecewa berbelanja di xyz.com.
