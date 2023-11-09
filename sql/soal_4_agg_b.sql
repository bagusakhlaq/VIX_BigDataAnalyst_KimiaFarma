WITH
/* 
Terdapat beberapa detil data yang hilang di tabel penjualan setiap harinya
yang datanya tersedia di tabel penjualan_ds. Tabel penjualan_ds juga tidak
memuat data yang lengkap, maka dari itu perlu digabungkan kedua tabel ini
menggunakan UNION
*/ 
clean_penjualan AS (
	SELECT 
		id_invoice,
		tanggal,
		id_customer,
		id_barang,
		jumlah_barang
	FROM penjualan
	
	UNION
	
	SELECT
		id_invoice,
		tanggal,
		id_customer,
		id_barang,
		jumlah_barang
	FROM penjualan_ds
),
/*
Karena ada perbedaan kolom pada tabel barang dan barang_ds, maka perlu
dilakukan restrukturasi dengan JOIN kedua tabel
*/
clean_barang AS (
	SELECT
		b.kode_barang,
		b.nama_barang,
		b.kemasan,
		bds.harga,
		bds.brand
	FROM barang AS b
	LEFT JOIN barang_ds AS bds
	ON b.kode_barang = bds.kode_barang
),
/*
Karena integritas data yang buruk pada tabel penjualan, maka perlu dilakukan
JOIN data untuk penginputan data kembali menggunakan data pendukung lainnya
yang sudah dibenahi
*/
table_bases AS (
	SELECT
		p.id_invoice,
		p.tanggal,
		p.id_customer,
		c.nama AS nama_cabang,
		c.grup,
		p.id_barang,
		b.nama_barang,
		p.jumlah_barang,
		b.harga,
		(p.jumlah_barang * b.harga) AS total_harga,
		b.kemasan,
		b.brand,
		c.id_cabang_sales,
		c.cabang_sales,
		c.id_distributor
	FROM clean_penjualan AS p
	LEFT JOIN clean_barang AS b ON p.id_barang = b.kode_barang
	LEFT JOIN pelanggan_ds AS c ON p.id_customer = c.id_customer
),
table_agg_branch AS (
	SELECT
		nama_cabang,
		grup,
		id_cabang_sales,
		cabang_sales,
		id_distributor,
		SUM(total_harga) AS total_sales,
		ROUND(AVG(total_harga), 2) AS avg_sales,
		COUNT(DISTINCT id_invoice) AS total_order,
		COUNT(DISTINCT id_customer) AS total_pelanggan
	FROM table_bases
	GROUP BY 1,2,3,4,5
)

CREATE TABLE table_agg_cabang (
	nama_cabang TEXT,
	grup TEXT,
	id_cabang_sales TEXT,
	cabang_sales TEXT,
	id_distributor TEXT,
	total_sales INTEGER,
	avg_sales REAL,
	total_order INTEGER,
	total_pelanggan INTEGER
);

INSERT INTO table_agg_cabang
	SELECT * FROM table_agg_branch;