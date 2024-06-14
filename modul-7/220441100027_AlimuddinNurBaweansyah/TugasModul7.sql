-- No 1
DELIMITER //
create trigger pengembalian before insert on peminjaman
FOR EACH ROW
BEGIN
IF (new.tgl_pinjam > new.tgl_rencana_kembali) THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Tanggal Rencana Kembali Tidak Lebih Awal dari Tanggal Pinjam!';
END IF;
END//
DELIMITER ;
INSERT INTO peminjaman (id, Id_Mobil, id_pelanggan, tgl_pinjam, tgl_rencana_kembali, total_hari, total_bayar, tgl_kembali, denda) VALUES
(12, 2, 4, '2023-05-18', '2023-05-15', 5, 1500000, '2023-05-15', 0);

select * from peminjaman;

-- NO 2
CREATE TABLE up_peminjaman(
Id_pinjam VARCHAR(20) NOT NULL PRIMARY KEY,
Total_hari INT,
Total_bayar INT,
Tgl_kembali DATE NOT NULL,
Denda INT NOT NULL
);
drop table up_peminjaman;

DELIMITER //
CREATE TRIGGER up_pengembalian AFTER INSERT ON up_peminjaman FOR EACH ROW
BEGIN
UPDATE peminjaman SET total_hari = new.total_hari, total_bayar = new.total_bayar,
tgl_kembali = new.tgl_kembali, denda = new.denda WHERE id = new.Id_pinjam;
END//
DELIMITER ;
drop trigger up_pengembalian;
INSERT INTO up_peminjaman VALUES ('3', 3, 1200000, "2023-05-20", 70000);

SELECT*FROM up_peminjaman;
INSERT INTO up_peminjaman VALUES ('7', 4, 1000000, "2023-06-18", 50000);
SELECT*FROM up_peminjaman;
SELECT*FROM peminjaman;

-- NO 3
DELIMITER //
CREATE TRIGGER cek_nik
BEFORE INSERT ON pelanggan
FOR EACH ROW
BEGIN
IF (LENGTH(new.nik) < 10 OR LENGTH(new.nik) > 10)
THEN SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = "Panjang NIK Harus Sesuai Aturan yang Berlaku!";
END IF;
END // 
DELIMITER ;

INSERT INTO pelanggan VALUES ('20', 'Narendra', 'Jombang', '342518807967228','084667876590', 'Laki-laki');
INSERT INTO pelanggan VALUES ('11', 'Hikmah Mufida MS', 'Bangkalan', '7657893728','084667876591', 'Perempuan');

select * from pelanggan;

-- NO 4
DELIMITER //
CREATE TRIGGER cek_platno BEFORE INSERT ON mobil FOR EACH ROW
BEGIN
IF (new.platno NOT REGEXP'^[a-zA-Z]' AND new.platno NOT REGEXP'^[a-zA-Z][a-zA-Z]')
THEN SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = "1/2 Karater Awal Plat Nomor Harus Huruf!";
END IF;
END//
DELIMITER ;

INSERT INTO mobil VALUES ('11', '1J 9999 KL', 'Suzuki', 'Ayla', 300000);
