CREATE DATABASE SwalanYa;

USE swalanya;

-- Membuat Tabel --

CREATE TABLE tb_Pelanggan(
Id_pelanggan INT NOT NULL, 
nama_pelanggan VARCHAR (20) NOT NULL, 
alamat_pelanggan VARCHAR (30), 
nomorHp_pelanggan VARCHAR (10), 
Primary key(Id_pelanggan));

CREATE TABLE tb_Supplier(
Id_Supplier INT NOT NULL, 
nama_Supplier VARCHAR (20), 
alamat_Supplier VARCHAR (30), 
nomorHp_Supplier VARCHAR (10), 
Primary key(Id_Supplier));

CREATE TABLE Barang(
Id_Barang INT NOT NULL, 
Nama_Barang Varchar (30) NOT NULL, 
Stok INT, 
Primary Key (Id_Barang));


CREATE TABLE Tb_Retur (
Id_retur INT NOT NULL,
Id_Pelanggan INT NOT NULL,
Id_Barang INT NOT NULL,
Jumlah INT,
Tanggal DATE,
Primary key(Id_retur),
Foreign Key (Id_Pelanggan) References tb_Pelanggan(Id_Pelanggan),
Foreign Key (Id_Barang) References Barang(Id_Barang));

CREATE TABLE Penjualan (
Id_Penjualan INT NOT NULL,
Id_Pelanggan INT NOT NULL,
Id_Barang INT NOT NULL,
Jumlah INT,
Tanggal DATE,
total_harga INT(30) NOT NULL,
Primary key(Id_Penjualan),
Foreign Key (Id_Pelanggan) References tb_Pelanggan(Id_Pelanggan),
Foreign Key (Id_Barang) References Barang(Id_Barang));

CREATE TABLE Pembelian (
Id_Pembelian INT NOT NULL,
Id_Supplier INT NOT NULL,
Id_Barang INT NOT NULL,
Jumlah INT,
Tanggal DATE,
harga_beli INT(30) NOT NULL,
Primary key(Id_Pembelian),
Foreign Key (Id_Supplier) References tb_Supplier(Id_Supplier),
Foreign Key (Id_Barang) References Barang(Id_Barang));

CREATE TABLE KoreksiStok (
Id_Koreksi INT NOT NULL,
Id_Barang INT NOT NULL,
Jumlah INT (20) NOT NULL,
Tanggal DATE,
stok_masuk INT(20) NOT NULL,
stok_keluar INT(20) NOT NULL,
Primary key(Id_Koreksi),
Foreign Key (Id_Barang) References Barang(Id_Barang));


-- -------------------- --

INSERT INTO  tb_Pelanggan VALUES 
(101, "Alfred Wade", "Cedar Road", 5551234567),
(102, "Martin Fox", "Elm Street", 5559876543),
(103, "Jean Valdez", "Maple Avenue", 5552345678),
(104, "Lula McLaughlin", "Oak Lane", 5558765432),
(105, "Mattie Carpenter", "Pine Street", 5553456789),
(106, "Eula Peters", "Cedar Road", 5557654321),
(107, "Nannie Robbins", "Birch Boulevard", 5554567890),
(108, "Amanda Lindsey", "Oak Lane", 5556543210),
(109, "Frederick Berry", "Maple Avenue", 5555678901),
(1010, "Christine Hammond", "Elm Street", 5553210987);

INSERT INTO  tb_Supplier VALUES 
(201, "SportsWorld Enterprises", "Main Street", "5678901234"),
(202, "Peak Performance Gear", "Pine Road", "7890123456"),
(203, "Active Lifestyle Suppliers", "Pinecrest Drive", "3456789012"),
(204, "Victory Sports Equipment Co.", "Oak Avenue", "8901234567"),
(205, "Elite Athlete Supply", "Pine Street", "0123456789"),
(206, "Sportify Gear Inc.", "Willow Way", "2345678901"),
(207, "Athletic Excellence Suppliers", "Birch Boulevard", "4045554321"),
(208, "ProGear Provisions Ltd.", "Oakwood Drive", "8135553456"),
(209, "Champion Sports Distributors", "Maple Avenue", "9175552345"),
(2010, "PowerSport Solutions Unlimited", "Spruce Court", "6155558901");

INSERT INTO  Barang VALUES 
(1, 'Raket Badminton Yonex Arcsaber 11', 10, 350000), 
(2, 'Raket Badminton Victor Jetspeed S 12', 8, 275000),
(3, 'Raket Badminton Li-Ning Turbo Charging 70', 12, 225000),
(4, 'Raket Badminton Babolat Satelite Gravity 74', 6, 100000),
(5, 'Raket Badminton Carlton Kinesis X 90', 15, 80000),
(6, 'Raket Badminton Wilson Blade 98', 9, 145000),
(7, 'Raket Badminton Head Nano Power 900', 7, 65000),
(8, 'Raket Badminton Ashaway Phantom X-Shadow', 11, 135000),
(9, 'Raket Badminton Dunlop CX 200', 13, 280000),
(10, 'Raket Badminton Tecnifibre T-Fight 295', 10, 315000);

INSERT INTO Tb_Retur VALUES 
(301, 107, 9, 1, '2020-04-15', "Rusak"),
(302, 101, 4, 1, '2021-09-25', "Tidak sesuai spesifikasi"),
(303, 102, 5, 1, '2022-09-19', "Bukan barang yang dipesan"),
(304, 109, 5, 1, '2019-07-02', "Rusak"),
(305, 104, 3, 1, '2023-01-16', "diretur karena belum terpasang senar"),
(306, 101, 4, 1, '2021-09-21', "Berat tidak sesuai"),
(307, 105, 7, 1, '2024-02-10', "Ketegangan senar tidak konsisten"),
(308, 108, 2, 1, '2020-11-30', "Rusak"),
(309, 106, 8, 1, '2021-03-15', "Shaft bengkok"),
(3010, 102, 10, 1,'2020-10-30',"Tegangan senar tidak tepat" );
 
INSERT INTO Penjualan VALUES 
(401, 1010, 1, 1, '2020-05-10', 315000),
(402, 107, 9, 2, '2021-04-08', 270000),
(403, 102, 5, 1, '2022-09-12', 80000),
(404, 109, 5, 1, '2019-06-28', 80000),
(405, 104, 3, 2, '2023-01-15', 450000),
(406, 101, 4, 1, '2021-09-19', 100000),
(407, 105, 7, 1, '2024-02-07', 65000),
(408, 108, 2, 2, '2020-11-26', 550000),
(409, 106, 8, 1, '2021-03-13', 135000),
(4010, 102, 10, 1,'2020-10-27', 315000);

INSERT INTO Pembelian VALUES
(501, 201, 1, 10, '2019-04-10', 2950000),
(502, 207, 7, 7, '2019-05-08', 350000),
(503, 202, 2, 8, '2019-09-12', 2000000),
(504, 209, 9, 13, '2019-12-28', 3250000),
(505, 204, 4, 6, '2019-01-15', 480000),
(506, 206, 6, 9, '2019-09-19', 1080000),
(507, 205, 5, 15, '2019-02-07', 1050000),
(508, 208, 8, 11, '2019-11-26', 1320000),
(509, 203, 3, 12, '2019-03-13', 2400000),
(5010, 2010, 10, 10,'2019-10-27', 2700000);

INSERT INTO koreksistok VALUES
(601, 1, 10, '2020-05-10', 1, 11),
(602, 9, 11, '2021-04-08', 2, 13),
(603, 5, 13, '2022-09-12', 2, 15),
(604, 6, 9, '2019-06-28', 0, 9),
(605, 3, 8, '2023-01-15', 2, 10),
(606, 4, 5, '2021-09-19', 1, 6),
(607, 7, 6, '2024-02-07', 1, 7),
(608, 2, 6, '2020-11-26', 2, 8),
(609, 8, 10, '2021-03-13', 1, 11),
(6010,10, 9,'2020-10-27', 1, 10);

-- -------------------- --

ALTER TABLE KoreksiStok
CHANGE COLUMN Tanggal Tanggal_input DATE;

-- -------------------- --
SELECT * FROM tb_pelanggan;
SELECT * FROM tb_supplier;
SELECT * FROM barang;
SELECT * FROM tb_retur;
SELECT * FROM penjualan;
SELECT * FROM pembelian;
SELECT * FROM koreksistok;

-- -------------------- --
drop DATABASE SwalanYa;