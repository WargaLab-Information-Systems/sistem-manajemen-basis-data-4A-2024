CREATE DATABASE modul7;
USE modul7

CREATE TABLE MOBIL (
    ID_MOBIL INT AUTO_INCREMENT PRIMARY KEY,
    PLATNO VARCHAR(15) NOT NULL,
    MERK VARCHAR(50) NOT NULL,
    JENIS VARCHAR(50) NOT NULL,
    HARGA_SEWA_PERHARI DECIMAL(10, 2) NOT NULL
);

CREATE TABLE PELANGGAN (
    ID_PELANGGAN INT AUTO_INCREMENT PRIMARY KEY,
    NAMA VARCHAR(100) NOT NULL,
    ALAMAT TEXT NOT NULL,
    NIK VARCHAR(20) NOT NULL,
    NO_TELEPON VARCHAR(15) NOT NULL,
    JENIS_KELAMIN ENUM('Laki-laki', 'Perempuan') NOT NULL
);

CREATE TABLE PEMINJAMAN (
    ID1 INT AUTO_INCREMENT PRIMARY KEY,
    ID_MOBIL INT NOT NULL,
    ID_PELANGGAN INT NOT NULL,
    TGL_PINJAM DATE NOT NULL,
    TGL_RENCANA_KEMBALI DATE NOT NULL,
    TOTAL_HARI INT NOT NULL,
    TOTAL_BAYAR DECIMAL(10, 2) NOT NULL,
    TGL_KEMBALI DATE,
    DENDA DECIMAL(10, 2),
    FOREIGN KEY (ID_MOBIL) REFERENCES MOBIL(ID_MOBIL),
    FOREIGN KEY (ID_PELANGGAN) REFERENCES PELANGGAN(ID_PELANGGAN)
);

INSERT INTO MOBIL (PLATNO, MERK, JENIS, HARGA_SEWA_PERHARI)
VALUES 
('B 1234 CD', 'Toyota', 'SUV', 500000),
('B 5678 EF', 'Honda', 'Sedan', 400000);

INSERT INTO PELANGGAN (NAMA, ALAMAT, NIK, NO_TELEPON, JENIS_KELAMIN)
VALUES 
('John Doe', 'Jl. Kebon Jeruk No. 1', '1234567890123456', '08123456789', 'Laki-laki'),
('Jane Doe', 'Jl. Kebon Anggrek No. 2', '1234567890123457', '08123456780', 'Perempuan');

INSERT INTO PEMINJAMAN (ID_MOBIL, ID_PELANGGAN, TGL_PINJAM, TGL_RENCANA_KEMBALI, TOTAL_HARI, TOTAL_BAYAR, TGL_KEMBALI, DENDA)
VALUES 
(1, 1, '2023-01-01', '2023-01-05', 4, 2000000, '2023-01-05', 0),
(2, 2, '2023-02-01', '2023-02-03', 2, 800000, '2023-02-04', 100000);

/Nomor 1/
SET sql_safe_updates = 0;

DELIMITER//
CREATE TRIGGER before_insert_peminjaman
BEFORE INSERT ON PEMINJAMAN
FOR EACH ROW
BEGIN
    IF NEW.TGL_RENCANA_KEMBALI < NEW.TGL_PINJAM THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tanggal rencana kembali tidak boleh lebih awal dari tanggal pinjam';
    END IF;
END//
DELIMITER//

INSERT INTO PEMINJAMAN ( ID_PELANGGAN, TGL_PINJAM, TGL_RENCANA_KEMBALI)
VALUES ( 1, '2024-06-05', '2024-06-01');

DELIMITER//
CREATE TRIGGER before_update_peminjaman
BEFORE UPDATE ON PEMINJAMAN
FOR EACH ROW
BEGIN
    IF NEW.TGL_RENCANA_KEMBALI < NEW.TGL_PINJAM THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tanggal rencana kembali tidak boleh lebih awal dari tanggal pinjam';
    END IF;
END//
DELIMITER ;

UPDATE PEMINJAMAN
SET TGL_RENCANA_KEMBALI = '2023-12-10'
WHERE ID1 = 2;
SELECT * FROM peminjaman;

/Nomor 2/
DELIMITER //

CREATE TRIGGER trg_update_tgl_kembali
BEFORE UPDATE ON PEMINJAMAN
FOR EACH ROW
BEGIN
    DECLARE v_harga_sewa_perhari DECIMAL(10, 2);

    -- Ambil harga sewa per hari dari tabel MOBIL
    SELECT HARGA_SEWA_PERHARI 
    INTO v_harga_sewa_perhari
    FROM MOBIL
    WHERE MOBIL.ID_MOBIL = NEW.ID_MOBIL;

    IF NEW.TGL_KEMBALI IS NOT NULL THEN
        SET NEW.TOTAL_BAYAR = DATEDIFF(NEW.TGL_KEMBALI, OLD.TGL_PINJAM) * v_harga_sewa_perhari;
        
        IF NEW.TGL_KEMBALI > OLD.TGL_RENCANA_KEMBALI THEN
            SET NEW.DENDA = DATEDIFF(NEW.TGL_KEMBALI, OLD.TGL_RENCANA_KEMBALI) * v_harga_sewa_perhari;
        ELSE
            SET NEW.DENDA = 0;
        END IF;
    END IF;
END //

DELIMITER ;

UPDATE PEMINJAMAN
SET TGL_KEMBALI = '2023-01-10'
WHERE ID1 = 1;
SELECT * FROM peminjaman;

/Nomor 3/
DELIMITER //

CREATE TRIGGER before_insert_pelanggan
BEFORE INSERT ON PELANGGAN
FOR EACH ROW
BEGIN
    IF CHAR_LENGTH(NEW.NIK) != 16 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Panjang NIK harus 16 karakter';
    END IF;
END//
DELIMITER;

-- Menjalankan perintah INSERT untuk memicu trigger
INSERT INTO PELANGGAN (NAMA, ALAMAT, NIK, NO_TELEPON, JENIS_KELAMIN)
VALUES ('suhu', 'Jauh', '1', '081234567890', 'Laki-laki');

DELIMITER//
CREATE TRIGGER before_update_pelanggan
BEFORE UPDATE ON PELANGGAN
FOR EACH ROW
BEGIN
    IF CHAR_LENGTH(NEW.NIK) != 16 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Panjang NIK harus 16 karakter';
    END IF;
END//
DELIMITER ;

UPDATE PELANGGAN
SET NIK = '1'
WHERE ID_PELANGGAN = 1

/Nomor 4/
DELIMITER //

CREATE TRIGGER before_insert_mobil
BEFORE INSERT ON MOBIL
FOR EACH ROW
BEGIN
    DECLARE first_char CHAR(1);

    SET first_char = LEFT(NEW.PLATNO, 1);

    IF NOT (first_char BETWEEN 'A' AND 'Z' OR first_char BETWEEN 'a' AND 'z') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Karakter pertama pada PLATNO harus huruf';
    END IF;
END//

DELIMITER ;

INSERT INTO MOBIL (PLATNO, MERK, JENIS, HARGA_SEWA_PERHARI)
VALUES 
('@ 8989 PL', 'Toyota', 'SUV', 500000);