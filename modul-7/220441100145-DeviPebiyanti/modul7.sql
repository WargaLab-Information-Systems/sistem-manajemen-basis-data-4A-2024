CREATE DATABASE Rental_Mobil;
USE Rental_Mobil;

CREATE TABLE mobil(
	id_mobil INT(10) PRIMARY KEY NOT NULL AUTO_INCREMENT,
	plat_no VARCHAR(20) NOT NULL,
	merk VARCHAR(20),
	jenis VARCHAR(30),
	harga_sewa_perhari INT(20)
);

INSERT INTO mobil(plat_no, merk, jenis, harga_sewa_perhari) VALUES 
	('L 5674 SD', 'Toyota Rush', 'SUV', 600000),
	('L 4377 WP', 'Toyota Rush', 'SUV', 600000),
	('L 2122 RF', 'Avanza', 'SUV', 500000),
	('W 6567 GG', 'Pajero Sport', 'SUV', 850000),
	('W 7889 GB', 'Pajero Sport', 'SUV', 850000),
	('S 9913 WW', 'Avanza', 'SUV', 500000),
	('S 9001 QE', 'Toyota Rush', 'SUV', 600000),
	('S 1365 BN', 'HR-V', 'SUV', 750000),
	('S 9976 LM', 'HR-V', 'SUV', 750000),
	('L 7791 GH', 'HR-V', 'SUV', 750000);

CREATE TABLE pelanggan(
	id_pelanggan INT(10) PRIMARY KEY NOT NULL AUTO_INCREMENT,
	nama VARCHAR(50) NOT NULL,
	alamat VARCHAR(50),
	nik VARCHAR(30),
	no_telp VARCHAR(20),
	jenis_kelamin VARCHAR(10)
);

INSERT INTO pelanggan(nama, alamat, nik, no_telp,jenis_kelamin) VALUES
	('Arifin', 'Lamongan', '3523175303040001', '083863833932', 'L'),
	('Syihab', 'Gresik', '3525643303040002', '083768986432', 'L'),
	('Fuad', 'Pamekasan', '3523175405040002', '083673213112', 'L'),
	('Diana', 'Mojokerto', '3523176403040001', '083990887123', 'P'),
	('Faisal', 'Gresik', '3523176903040002', '083665432786', 'L');

CREATE TABLE peminjaman(
	id_peminjaman INT(10) PRIMARY KEY NOT NULL,
	id_mobil INT(10) NOT NULL,
	id_pelanggan INT(10) NOT NULL,
	tgl_pinjam DATE,
	tgl_rencana_kembali DATE,
	total_hari INT(10),
	total_bayar INT(10),
	tgl_kembali DATE,
	denda INT(20),
	FOREIGN KEY (id_mobil) REFERENCES mobil(id_mobil),
	FOREIGN KEY (id_pelanggan) REFERENCES pelanggan(id_pelanggan)
);



////////////NOMOR 1//////////////

DELIMITER //

CREATE TRIGGER before_insert_peminjaman
BEFORE INSERT ON peminjaman
FOR EACH ROW
BEGIN
    IF NEW.tgl_rencana_kembali < NEW.tgl_pinjam THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tanggal rencana kembali tidak boleh lebih awal dari tanggal pinjam';
    END IF;
END //

DELIMITER ;

INSERT INTO peminjaman (
    id_peminjaman, id_mobil, id_pelanggan, tgl_pinjam, tgl_rencana_kembali, total_hari, total_bayar, tgl_kembali, denda
) VALUES (
    1, 1, 1, '2024-05-05', '2024-05-04', NULL, NULL, '2024-05-05', NULL
);


//////////NOMOR 2////////////////

DELIMITER //

CREATE TRIGGER hitung_bayar_denda_insert
BEFORE INSERT ON peminjaman
FOR EACH ROW
BEGIN
    DECLARE jumlahHari INT(50);
    DECLARE Telat INT(50);
    DECLARE tarifPerHari INT(50);
    DECLARE dendaPerHari INT DEFAULT 50;

    SELECT harga_sewa_perhari INTO tarifPerHari
    FROM mobil
    WHERE id_mobil = NEW.id_mobil;
    
    SET jumlahHari = DATEDIFF(NEW.tgl_kembali, NEW.tgl_pinjam);
    
    SET NEW.total_bayar = jumlahHari * tarifPerHari;
    
    IF NEW.tgl_kembali > NEW.tgl_rencana_kembali THEN
        SET Telat = DATEDIFF(NEW.tgl_kembali, NEW.tgl_rencana_kembali);
        SET NEW.denda = Telat * dendaPerHari;
    ELSE
        SET NEW.denda = 0;
    END IF;
    
    SET NEW.total_hari = jumlahHari;
END//

DELIMITER ;


DROP TRIGGER hitung_bayar_denda;

INSERT INTO peminjaman (
    id_peminjaman, id_mobil, id_pelanggan, tgl_pinjam, tgl_rencana_kembali, total_hari, total_bayar, tgl_kembali, denda
) VALUES (
    1, 1, 1, '2024-05-01', '2024-05-05', 0, 0, '2024-05-05', 0
);



//////////NOMOR 3/////////

DELIMITER //

CREATE TRIGGER cek_panjang_nik
BEFORE INSERT ON pelanggan
FOR EACH ROW
BEGIN
    DECLARE pesan VARCHAR(100);

    IF CHAR_LENGTH(NEW.nik) < 16 THEN
        SET pesan = CONCAT('Panjang NIK harus 16 karakter. Panjang NIK yang dimasukkan : ', CHAR_LENGTH(NEW.nik));
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = pesan;
    END IF;
END //

DELIMITER ;


INSERT INTO pelanggan (
    id_pelanggan, nama, alamat, nik, no_telp, jenis_kelamin
) VALUES (
    11, 'Rozikhin', 'Pamekasan', '35231756926492', '085765893214', 'L'
);

//////NOMOR 4/////////

DELIMITER //

CREATE TRIGGER insert_plat
BEFORE INSERT ON mobil
FOR EACH ROW
BEGIN
    DECLARE pesan VARCHAR(255);
   
    IF NOT (NEW.plat_no REGEXP '^[A-Za-z]') THEN
        SET pesan = 'Kolom plat_no harus dimulai dengan huruf.';
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = pesan;
    END IF;
END;
//

DELIMITER ;

INSERT INTO mobil (
    id_mobil, plat_no, merk, jenis, harga_sewa_perhari
) VALUES (
    1, '4567 FG', 'Avanza', 'SUV', '500000'
);

INSERT INTO mobil (
    id_mobil, plat_no, merk, jenis, harga_sewa_perhari
) VALUES (
    11, 'G 4567 FG', 'Avanza', 'SUV', '500000'
);