USE library;

-- soal 1
DELIMITER //
CREATE PROCEDURE soal_nomor1(INOUT tanggal DATE)
BEGIN
    SELECT p.kode_kembali, p.id_anggota, a.nama_anggota, p.kode_buku, b.judul_buku, p.id_petugas, pt.nama_petugas, p.tgl_pinjam, p.tgl_kembali, p.denda
    FROM pengembalian p
    JOIN anggota a ON p.id_anggota = a.id_anggota
    JOIN buku b ON p.kode_buku = b.kode_buku
    JOIN petugas pt ON p.id_petugas = pt.id_petugas
    WHERE p.tgl_kembali = tanggal;
END //
DELIMITER ;

SET @tanggal = '2024-04-09';
CALL soal_nomor1(@tanggal);
SELECT @tanggal;

-- soal 2
DELIMITER //
CREATE PROCEDURE soal_nomor2(INOUT statusPinjam VARCHAR(15))
BEGIN
    SELECT * FROM anggota WHERE status_pinjam = statusPinjam;
END //
DELIMITER ;

SET @statusPinjam = '1';
CALL soal_nomor2(@statusPinjam);
SELECT @statusPinjam; 


-- soal 3
DELIMITER //
CREATE PROCEDURE soal_nomor3(
    IN statusPinjam VARCHAR(15),
    OUT result TEXT
)
BEGIN
    DECLARE resultText TEXT DEFAULT '';
    SELECT GROUP_CONCAT(
        CONCAT_WS(', ', id_anggota, nama_anggota, angkatan_anggota, tempat_lahir_anggota, tanggal_lahir_anggota, no_telp, jenis_kelamin)
        SEPARATOR '; '
    ) INTO resultText
    FROM anggota
    WHERE status_pinjam = statusPinjam;
    SET result = resultText;
END //
DELIMITER ;

SET @statusPinjam = 1;
SET @result = '';
CALL soal_nomor3(@statusPinjam, @result);
SELECT @result;


-- soal 4 
DELIMITER //
CREATE PROCEDURE soal_nomor4(
    IN judulBuku VARCHAR(25),
    IN pengarangBuku VARCHAR(30),
    IN penerbitBuku VARCHAR(30),
    IN tahunBuku INT,
    IN jumlahBuku INT,
    IN statusBuku VARCHAR(10),
    IN klasifikasiBuku VARCHAR(20)
)
BEGIN
    INSERT INTO buku (judul_buku, pengarang_buku, penerbit_buku, tahun_buku, jumlah_buku, status_buku, klasifikasi_buku)
    VALUES (judulBuku, pengarangBuku, penerbitBuku, tahunBuku, jumlahBuku, statusBuku, klasifikasiBuku);

    SELECT 'Data buku telah berhasil ditambahkan' AS PesanKonfirmasi;
END //
DELIMITER ;

CALL soal_nomor4(
    'Sang Pemimpi', 
    'Andrea Hirata', 
    'Bentang Pustaka', 
    2006, 
    10, 
    'Tersedia', 
    'Fiksi'
);
select * from buku;

-- soal 5
DELIMITER //
CREATE PROCEDURE soal_nomor5(
    IN idAnggota INT
)
BEGIN
    DECLARE statusPinjam INT;
    SELECT status_pinjam INTO statusPinjam
    FROM anggota
    WHERE id_anggota = idAnggota;
    IF statusPinjam > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Anggota masih memiliki pinjaman, penghapusan dibatalkan';
    ELSE
        DELETE FROM anggota WHERE id_anggota = idAnggota;
        SELECT 'Data anggota telah berhasil dihapus' AS PesanKonfirmasi;
    END IF;
END //
DELIMITER ;

SET @idAnggota = 302;
CALL soal_nomor5(@idAnggota);

-- soal 6
-- right join
CREATE VIEW ViewRightJoin AS
SELECT a.id_anggota, a.nama_anggota, p.kode_peminjaman, p.tgl_pinjam, p.tgl_kembali
FROM anggota a
RIGHT JOIN peminjaman p ON a.id_anggota = p.id_anggota;

SELECT * FROM ViewRightJoin;

-- left join
CREATE VIEW ViewLeftJoin AS
SELECT p.kode_kembali, p.tgl_kembali, a.nama_anggota, b.judul_buku, pt.nama_petugas
FROM pengembalian p
LEFT JOIN anggota a ON p.id_anggota = a.id_anggota
LEFT JOIN buku b ON p.kode_buku = b.kode_buku
LEFT JOIN petugas pt ON p.id_petugas = pt.id_petugas;

SELECT * FROM ViewLeftJoin;

-- inner join
CREATE VIEW ViewInnerJoin AS
SELECT p.kode_peminjaman, p.tgl_pinjam, p.tgl_kembali, a.nama_anggota, b.judul_buku
FROM peminjaman p
INNER JOIN anggota a ON p.id_anggota = a.id_anggota
INNER JOIN buku b ON p.kode_buku = b.kode_buku;

SELECT * FROM ViewInnerJoin;

-- agregasi dan pengelompokan
CREATE VIEW ViewPengembalianSummary AS
SELECT a.nama_anggota, COUNT(p.kode_kembali) AS jumlah_pengembalian
FROM pengembalian p
INNER JOIN anggota a ON p.id_anggota = a.id_anggota
GROUP BY a.nama_anggota;

SELECT * FROM ViewPengembalianSummary;