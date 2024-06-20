-- Membuat database
CREATE DATABASE IF NOT EXISTS rental_mobil;
USE rental_mobil;

-- Membuat tabel mobil
CREATE TABLE IF NOT EXISTS mobil (
    id_mobil VARCHAR(10) NOT NULL PRIMARY KEY,
    platno VARCHAR(10) NOT NULL,
    merk VARCHAR(30) NOT NULL,
    jenis VARCHAR(10) NOT NULL,
    harga_sewa_perhari INT NOT NULL
);

-- Membuat tabel pelanggan
CREATE TABLE IF NOT EXISTS pelanggan (
    id_pelanggan VARCHAR(10) NOT NULL PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    alamat VARCHAR(100) NOT NULL,
    nik VARCHAR(16) NOT NULL,
    no_telepon VARCHAR(12) NOT NULL,
    jenis_kelamin VARCHAR(1) NOT NULL
);

-- Membuat tabel peminjaman
CREATE TABLE IF NOT EXISTS peminjaman (
    id1 VARCHAR(10) NOT NULL PRIMARY KEY,
    id_mobil VARCHAR(10) NOT NULL,
    id_pelanggan VARCHAR(10) NOT NULL,
    tgl_pinjam DATE,
    tgl_rencana_kembali DATE,
    total_hari INT NOT NULL,
    total_bayar INT NOT NULL,
    tgl_kembali DATE,
    denda INT NOT NULL,
    FOREIGN KEY (id_mobil) REFERENCES mobil(id_mobil),
    FOREIGN KEY (id_pelanggan) REFERENCES pelanggan(id_pelanggan)
);

-- Mengisi tabel mobil
INSERT INTO mobil (id_mobil, platno, merk, jenis, harga_sewa_perhari) VALUES
('M001', 'S1234B', 'Honda Jazz', 'Matic', 200000),
('M002', 'L5434PP', 'Honda Brio', 'Matic', 150000),
('M003', 'A4279CC', 'Meserati J10', 'Manual', 400000),
('M004', 'D4234AA', 'Mustang Horse', 'Manual', 350000),
('M005', 'AB5244GH', 'Daihatsu Xenia', 'Matic', 100000);

-- Mengisi tabel pelanggan
INSERT INTO pelanggan (id_pelanggan, nama, alamat, nik, no_telepon, jenis_kelamin) VALUES
('P001', 'Tyo', 'Surabaya', '3432432423431234', '081231371', 'L'),
('P002', 'Tymo', 'Gresik', '2442342234527803', '081234551', 'L'),
('P003', 'Siti', 'Malang', '2345241357801234', '085131351', 'P'),
('P004', 'Mila', 'Sidoarjo', '1323420987567514', '082231321', 'P'),
('P005', 'Jamal', 'Pasuruan', '9892428980287643', '089232431', 'L');

-- Mengisi tabel peminjaman
INSERT INTO peminjaman (id1, id_mobil, id_pelanggan, tgl_pinjam, tgl_rencana_kembali, total_hari, total_bayar, tgl_kembali, denda) VALUES
('PM001', 'M003', 'P001', '2024-05-25', '2024-05-30', 5, 2000000, '2024-05-30', 0),
('PM002', 'M005', 'P005', '2024-05-22', '2024-05-28', 6, 600000, '2024-05-31', 0),
('PM003', 'M001', 'P003', '2024-05-24', '2024-05-27', 3, 600000, '2024-05-28', 0),
('PM004', 'M004', 'P002', '2024-05-23', '2024-05-27', 4, 1400000, '2024-05-26', 50000),
('PM005', 'M002', 'P004', '2024-05-23', '2024-05-26', 3, 450000, '2024-05-26', 0);



-- Soal 1
DELIMITER //
CREATE TRIGGER check_tgl_rencana_kembali 
BEFORE INSERT ON peminjaman
FOR EACH ROW
BEGIN
    IF NEW.tgl_rencana_kembali < NEW.tgl_pinjam THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tanggal rencana kembali tidak boleh lebih awal dari tanggal pinjam';
    END IF;
END//
DELIMITER ;

INSERT INTO peminjaman (id1, id_mobil, id_pelanggan, tgl_pinjam, tgl_rencana_kembali, total_hari, total_bayar, tgl_kembali, denda) VALUES
('PM006', 'M001', 'P001', '2024-05-30', '2024-04-30', 5, 1000000, '2024-06-03', 0);

DROP TRIGGER check_tgl_rencana_kembali ;
DELETE FROM peminjaman WHERE id1 = 'PM006';
SELECT * FROM peminjaman;


-- Soal 2
DELIMITER //
CREATE TRIGGER update_peminjaman 
BEFORE UPDATE ON peminjaman
FOR EACH ROW
BEGIN
    DECLARE v_harga_sewa_perhari INT;
    DECLARE v_total_hari INT;
    DECLARE v_denda INT;
    
    IF NEW.tgl_kembali IS NOT NULL THEN

        SELECT harga_sewa_perhari INTO v_harga_sewa_perhari 
        FROM mobil WHERE id_mobil = NEW.id_mobil;
        

        SET v_total_hari = DATEDIFF(NEW.tgl_kembali, NEW.tgl_pinjam);
        SET NEW.total_bayar = v_total_hari * v_harga_sewa_perhari;
        
        
        IF NEW.tgl_kembali > NEW.tgl_rencana_kembali THEN
            SET v_denda = DATEDIFF(NEW.tgl_kembali, NEW.tgl_rencana_kembali) * v_harga_sewa_perhari;
            SET NEW.denda = v_denda;
        ELSE
            SET NEW.denda = 0;
        END IF;
    END IF;
END//
DELIMITER ;
SELECT * FROM peminjaman;

UPDATE peminjaman SET tgl_kembali = '2024-05-31' WHERE id1 = 'PM001';

-- Soal 3
DELIMITER //
CREATE TRIGGER check_nik_length 
BEFORE INSERT ON pelanggan
FOR EACH ROW
BEGIN
    IF LENGTH(NEW.nik) != 16 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Panjang NIK harus 16 digit';
    END IF;
END//
DELIMITER ;


INSERT INTO pelanggan (id_pelanggan, nama, alamat, nik, no_telepon, jenis_kelamin) VALUES
('P006', 'Andi', 'Jakarta', '12345678901234', '0812345678', 'L');
DELETE FROM pelanggan WHERE id_pelanggan = 'P006';
SELECT * FROM pelanggan;


-- Soal 4
DELIMITER //
CREATE TRIGGER check_platno_first_char 
BEFORE INSERT ON mobil
FOR EACH ROW
BEGIN
    DECLARE first_char CHAR(1);
    DECLARE second_char CHAR(1);

    SET first_char = LEFT(NEW.platno, 1);
    SET second_char = SUBSTRING(NEW.platno, 2, 1);

    IF NOT (first_char BETWEEN 'A' AND 'Z' OR first_char BETWEEN 'a' AND 'z') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Karakter pertama pada Plat Nomor harus huruf';
    END IF;
    
    IF NOT (second_char BETWEEN 'A' AND 'Z' OR second_char BETWEEN 'a' AND 'z') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Karakter kedua pada Plat Nomor harus huruf';
    END IF;
END//
DELIMITER ;


INSERT INTO mobil (id_mobil, platno, merk, jenis, harga_sewa_perhari) VALUES
('M006', 'BB1122BB', 'Toyota Avanza', 'Matic', 200000);
DELETE FROM mobil WHERE id_mobil = 'M006';
SELECT * FROM mobil;



