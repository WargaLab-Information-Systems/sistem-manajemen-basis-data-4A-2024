CREATE DATABASE rentalMobil;
USE rentalMobil;
CREATE TABLE mobil (
id_mobil VARCHAR (10) PRIMARY KEY,
platno VARCHAR (15),
merk VARCHAR (20),
jenis VARCHAR (20),
harga_sewa_perhari INT (10)
);
CREATE TABLE pelanggan (
id_pelanggan VARCHAR (10) PRIMARY KEY,
nama VARCHAR (25),
alamat VARCHAR (10),
nik INT(20),
no_telp INT(15),jenis_kelamin VARCHAR (10)
);
CREATE TABLE peminjaman (
id VARCHAR (10),
id_mobil VARCHAR (10),
id_pelanggan VARCHAR (10),
tgl_pinjam DATE,
tgl_rencana_kembali DATE,
total_hari INT (10),
total_bayar INT (10),
tgl_kembali DATE,
denda INT (10),
FOREIGN KEY (id_mobil) REFERENCES mobil(id_mobil),
FOREIGN KEY (id_pelanggan) REFERENCES pelanggan(id_pelanggan)
);
SELECT * FROM mobil
SELECT * FROM pelanggan
SELECT * FROM peminjaman
INSERT INTO mobil (id_mobil, platno, merk, jenis, harga_sewa_perhari)
VALUES
(1, 'AB 1234', 'Toyota Avanza', 'MPV', 500000),
(2, 'CD 5678', 'Honda Brio', 'Hatchback', 300000),
(3, 'EF 9012', 'Daihatsu Xenia', 'MPV', 400000),
(4, 'GH 3456', 'Suzuki Ertiga', 'MPV', 450000),
(5, 'IJ 7890', 'Mitsubishi Xpander', 'MPV', 550000);
INSERT INTO pelanggan (id_pelanggan, nama, alamat, nik, no_telp,
jenis_kelamin) VALUES
(1, 'Budi', 'Jl. Sudirman 12', '1234567890123456', '08123456789', 'Laki-laki'),
(2, 'Ani', 'Jl. Merdeka 23', '7654321098765432', '08523456789', 'Perempuan'),
(3, 'Cici', 'Jl. Nusantara 34', '3456789012345678', '08923456789', 'Perempuan');
INSERT INTO peminjaman (id, id_mobil, id_pelanggan,
tgl_pinjam, tgl_rencana_kembali, total_hari, total_bayar, tgl_kembali, denda)
VALUES
(1, 1, 1, '2024-06-01', '2024-06-03', 2, 1000000, '2024-06-03', 0),
(2, 2, 2, '2024-06-02', '2024-06-04', 2, 600000, '2024-06-04', 0),
(3, 3, 3, '2024-06-03', '2024-06-05', 2, 800000, NULL, 0),
(4, 4, 1, '2024-06-04', '2024-06-06', 2, 900000, NULL, 0),
(5, 5, 2, '2024-06-05', '2024-06-07', 2, 1100000, NULL, 0);
-- NO 1
DELIMITER //
CREATE TRIGGER cekTanggal BEFORE INSERT ON peminjaman
FOR EACH ROW
BEGIN
IF (new.tgl_pinjam > new.tgl_rencana_kembali) THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Tanggal rencana kembali lebih
awal dari tanggal pinjaman!!';
END IF;
END //
DELIMITER ;
INSERT INTO peminjaman VALUE (6, 3, 3, '2024-06-05', '2024-06-02', 2, 800000, NULL, 0);


-- NO 3
DELIMITER //

CREATE TRIGGER cekNik
BEFORE INSERT ON pelanggan
FOR EACH ROW
BEGIN
    IF (NEW.nik REGEXP '[a-zA-Z]') OR  NEW.nik REGEXP '^[0-9]+$' OR
    (LENGTH(NEW.nik) <> 16) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Panjang NIK harus sesuai dengan aturan yang berlaku dan hanya boleh berisi angka';
    END IF;
END//

DELIMITER ;

INSERT INTO pelanggan VALUES (7, 'Cici', 'Jl. Nusantara 34', '34567', '08923456789', 'Perempuan');


-- NO 4
DELIMITER //
CREATE TRIGGER validasiPlat BEFORE INSERT ON mobil 
FOR EACH ROW 
BEGIN 
IF (new.platno NOT REGEXP '[a-zA-Z] {2}') THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT ='setengah karakter awal nomor plat harus huruf!!';
END IF;
END//
DELIMITER//
INSERT INTO mobil VALUES (8, 'M1 7890', 'Mitsubishi Xpander', 'MPV', 550000);

drop trigger validasiPlat;

-- nomor 2

DELIMITER//

drop trigger trg_update_tgl_kembali;

update peminjaman set tgl_kembali = "2024-06-04" where id = 3;


DELIMITER //

CREATE TRIGGER trg_update
BEFORE UPDATE ON peminjaman
FOR EACH ROW
BEGIN

DECLARE harga DECIMAL(10,2);

    IF NEW.tgl_kembali IS NOT NULL THEN
    
	SELECT harga_sewa_perhari INTO harga
        FROM mobil join peminjaman on mobil.id_mobil = peminjaman.id_mobil WHERE id = OLD.id;
        
        SET NEW.total_bayar = DATEDIFF(NEW.tgl_kembali, OLD.tgl_pinjam) * harga;
        
        IF NEW.tgl_kembali > OLD.tgl_rencana_kembali THEN
            SET NEW.denda = DATEDIFF(NEW.tgl_kembali, OLD.tgl_rencana_kembali) * harga;
        ELSE
            SET NEW.denda = 0;
        END IF;
    END IF;
END//

DELIMITER ;
