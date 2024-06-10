/*Soal 1*/
CREATE VIEW cari AS
SELECT 
        b.Kode_Kembali, 
        a.Nama_Anggota, 
        c.Judul_Buku, 
        d.Nama, 
        b.Tgl_Pinjam, 
        b.Tgl_Kembali, 
        b.Denda 
    FROM 
        pengembalaian b
    JOIN 
        anggota a ON b.IdAnggota = a.IdAnggota
    JOIN 
        buku c ON b.Kode_Buku = c.Kode_Buku
    JOIN 
        petugas d ON b.IdPetugas = d.IdPetugas;
        
DELIMITER //
CREATE PROCEDURE berdasarkanTanggal(
    IN TanggalInput DATE,
    OUT HasilCari TEXT	
)
BEGIN
    DECLARE dataa INT DEFAULT 0;

    SELECT COUNT(*) INTO dataa
    FROM cari
    WHERE Tgl_Kembali = TanggalInput;

    IF dataa > 0 THEN
       SELECT 
            GROUP_CONCAT(
                CONCAT(
                    Kode_Kembali, ' | ',
                    Nama_Anggota, ' | ',
                    Judul_Buku, ' | ',
                    Nama, ' | ',
                    Tgl_Pinjam, ' | ',
                    Tgl_Kembali, ' | ',
                    Denda
                ) SEPARATOR '\n'
            ) INTO HasilCari
        FROM cari
        WHERE Tgl_Kembali = TanggalInput;
    ELSE
        SET HasilCari = 'Tidak ada data';
    END IF;
END //
DELIMITER ;
CALL berdasarkanTanggal('2024-05-20', @HasilCari);
SELECT @HasilCari;

-- so'al 2
DELIMITER //
CREATE PROCEDURE berdasarkanStatus(
    IN StatusInput VARCHAR(255),
    OUT Hasil TEXT
)
BEGIN
    DECLARE dataaa INT DEFAULT 0;
    SELECT COUNT(*) INTO dataaa
    FROM anggota
    WHERE Status_Pinjam = StatusInput;
    IF dataaa > 0 THEN
        SELECT 
            GROUP_CONCAT(
                CONCAT(
                    IdAnggota, ' | ',
                    Nama_Anggota, ' | ',
                    Angkatan_Anggota, ' | ',
                    Tempat_Lahir_Anggota, ' | ',
                    Tanggal_Lahir_Anggota, ' | ',
                    No_Telp, ' | ',
                    Status_Pinjam
                ) SEPARATOR '\n'
            ) INTO Hasil
        FROM anggota
        WHERE Status_Pinjam = StatusInput;
    ELSE
        SET Hasil = 'Data Tidak Ada';
    END IF;
END //
DELIMITER ;
CALL berdasarkanStatus('Aktif', @Hasil);
SELECT @Hasil;

-- soal3
DELIMITER //
CREATE PROCEDURE berdasarkanStatusPinjam(
    OUT HasilCari TEXT
)   
BEGIN
    DECLARE dataa INT DEFAULT 0;
    SELECT COUNT(*) INTO dataa
    FROM anggota
    WHERE Status_Pinjam = 'Aktif';
    IF dataa > 0 THEN
        SELECT 
            GROUP_CONCAT(
                CONCAT(
                    IdAnggota, ' | ',
                    Nama_Anggota, ' | ',
                    Angkatan_Anggota, ' | ',
                    Tempat_Lahir_Anggota, ' | ',
                    Tanggal_Lahir_Anggota, ' | ',
                    No_Telp, ' | ',
                    Status_Pinjam
                ) SEPARATOR '\n'
            ) INTO HasilCari
        FROM anggota
        WHERE Status_Pinjam = 'Aktif';
    ELSE
        SET HasilCari = 'data tidak ada';
    END IF;
END //
DELIMITER ;
CALL berdasarkanStatusPinjam(@HasilCari);
SELECT @HasilCari;

-- soal 4
DELIMITER //
CREATE PROCEDURE input(
    IN KodeBuku VARCHAR(10),
    IN JudulBuku VARCHAR(25),
    IN PengarangBuku VARCHAR(30),
    IN PenerbitBuku VARCHAR(30),
    IN TahunBuku VARCHAR(10),
    IN JumlahBuku VARCHAR(5),
    IN StatusBuku VARCHAR(10),
    IN KlasifikasiBuku VARCHAR(20)
)
BEGIN
    INSERT INTO buku (
        Kode_Buku, 
        Judul_Buku, 
        Pengarang_Buku, 
        Penerbit_Buku, 
        Tahun_Buku, 
        Jumlah_Buku, 
        Status_Buku, 
        Klasifikasi_Buku
    ) 
    VALUES (
        KodeBuku, 
        JudulBuku, 
        PengarangBuku, 
        PenerbitBuku, 
        TahunBuku, 
        JumlahBuku, 
        StatusBuku, 
        KlasifikasiBuku
    );
    SELECT 'Data buku sudah berhasil ditambahkan' AS Notifikasi;
END //
DELIMITER ;
CALL input('B010', 'kembara-kembar nakal', 'Ros', 'sinar mandiri', '2021', '35', 'Tersedia', 'Humor');

-- soal 5
DELIMITER //
CREATE PROCEDURE deleteAnggota(
    IN id_anggota VARCHAR(10)
)
BEGIN
    DECLARE JumlahPinjam INT;

    SELECT COUNT(*) INTO JumlahPinjam
    FROM peminjaman 
    WHERE IdAnggota = id_anggota AND Tanggal_Kembali > CURDATE();

    IF JumlahPinjam > 0 THEN
        SELECT 'Tidak dapat menghapus anggota karena masih memiliki pinjaman yang belum dikembalikan' AS NotifikasiKesalahan;
    ELSE
        DELETE FROM anggota WHERE IdAnggota = id_anggota;
        SELECT 'Data anggota telah berhasil dihapus' AS NotifikasiBenar;
    END IF;
END //
DELIMITER ;
CALL deleteAnggota('A008');

-- soal 6
-- right join
CREATE VIEW petugasLayan AS
SELECT a.IdPetugas, a.Nama, COUNT(b.Idpetugas) AS banyakMelayani 
FROM petugas a RIGHT JOIN peminjaman b 
ON a.IdPetugas = b.IdPetugas
GROUP BY b.IdPetugas;

SELECT * FROM petugasLayan;

-- left join
CREATE VIEW petugasLayani AS
SELECT a.IdPetugas, a.Nama, COUNT(b.Idpetugas) AS banyakMelayani 
FROM petugas a LEFT JOIN peminjaman b 
ON a.IdPetugas = b.IdPetugas
GROUP BY b.IdPetugas;

SELECT * FROM petugasLayani;

-- inner join
CREATE VIEW petugasL AS
SELECT a.IdPetugas, a.Nama, COUNT(b.Idpetugas) AS banyakMelayani 
FROM petugas a INNER JOIN peminjaman b 
ON a.IdPetugas = b.IdPetugas
GROUP BY b.IdPetugas;

SELECT * FROM petugasL;

