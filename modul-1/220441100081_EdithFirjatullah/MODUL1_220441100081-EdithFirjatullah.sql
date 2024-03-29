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
Primary key(Id_Penjualan),
Foreign Key (Id_Pelanggan) References tb_Pelanggan(Id_Pelanggan),
Foreign Key (Id_Barang) References Barang(Id_Barang));

CREATE TABLE Pembelian (
Id_Pembelian INT NOT NULL,
Id_Supplier INT NOT NULL,
Id_Barang INT NOT NULL,
Jumlah INT,
Tanggal DATE,
Primary key(Id_Pembelian),
Foreign Key (Id_Supplier) References tb_Supplier(Id_Supplier),
Foreign Key (Id_Barang) References Barang(Id_Barang));

CREATE TABLE KoreksiStok (
Id_Koreksi INT NOT NULL,
Id_Barang INT NOT NULL,
Jumlah INT,
Tanggal DATE,
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
(1, 'Raket Badminton Yonex Arcsaber 11', 10),
(2, 'Raket Badminton Victor Jetspeed S 12', 8),
(3, 'Raket Badminton Li-Ning Turbo Charging 70', 12),
(4, 'Raket Badminton Babolat Satelite Gravity 74', 6),
(5, 'Raket Badminton Carlton Kinesis X 90', 15),
(6, 'Raket Badminton Wilson Blade 98', 9),
(7, 'Raket Badminton Head Nano Power 900', 7),
(8, 'Raket Badminton Ashaway Phantom X-Shadow', 11),
(9, 'Raket Badminton Dunlop CX 200', 13),
(10, 'Raket Badminton Tecnifibre T-Fight 295', 10);

INSERT INTO Penjualan VALUES 
(401, 1010, 1, 1, '2020-05-10'),
(402, 107, 9, 2, '2021-04-08'),
(403, 102, 5, 1, '2022-09-12'),
(404, 109, 5, 1, '2019-06-28'),
(405, 104, 3, 2, '2023-01-15'),
(406, 101, 4, 1, '2021-09-19'),
(407, 105, 7, 1, '2024-02-07'),
(408, 108, 2, 2, '2020-11-26'),
(409, 106, 8, 1, '2021-03-13'),
(4010, 102, 10, 1,'2020-10-27');

INSERT INTO Pembelian VALUES 
(501, 201, 1, 1, '2020-05-10'),
(502, 207, 9, 2, '2021-04-08'),
(503, 202, 5, 1, '2022-09-12'),
(504, 209, 5, 1, '2019-06-28'),
(505, 204, 3, 2, '2023-01-15'),
(506, 201, 4, 1, '2021-09-19'),
(507, 205, 7, 1, '2024-02-07'),
(508, 208, 2, 2, '2020-11-26'),
(509, 206, 8, 1, '2021-03-13'),
(5010, 202, 10, 1,'2020-10-27');


-- -------------------- --
drop table tb_supplier;






