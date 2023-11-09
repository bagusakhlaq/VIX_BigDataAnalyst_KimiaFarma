/* Membuat tabel dummy bernama soal_1 */
CREATE TABLE "soal_1" (
	"id"	INTEGER,
	"nama"	TEXT,
	"tanggal_lahir"	TEXT,
	"alamat"	TEXT,
	PRIMARY KEY("id")
);

/* Memasukan data dummy ke dalam tabel*/
INSERT INTO soal_1 (id, nama, tanggal_lahir, alamat)
VALUES
    (1, "Budi", "2000-01-01", "Mataram"),
    (2, "Andi", "2001-02-02", "Matraman"),
    (3, "Doni", "2002-03-03", "Makassar"),
    (4, "Eko", "2003-04-04", "Malang"),
    (5, "Feri", "2004-05-05", "Martapura"),
    (6, "Gita", "2005-06-06", "Matram"),
    (7, "Hanif", "2006-07-07", "Mataram"),
    (8, "Ira", "2007-08-08", "Medan"),
    (9, "Joko", "2008-09-09", "Mataram"),
    (10, "Kiki", "2009-10-10", "Martapura");

SELECT * FROM soal_1 WHERE SUBSTR(alamat, 1, 3) = 'Mat';
SELECT * FROM soal_1 WHERE alamat LIKE 'Mat%';