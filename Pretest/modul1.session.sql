use latihanmodul1;

CREATE TABLE IF NOT EXISTS mahasiswa(
    id_mhs int(10)primary key not null auto_increment,
    nama_mhs varchar(12) not null,
    alamat varchar(30) not null,
    gol_ukt int(5) not null
);

alter TABLE mahasiswa add constraint fk_gol_ukt foreign key (gol_ukt) references ukt(gol_ukt);

CREATE TABLE IF NOT EXISTS ukt (
    gol_ukt int(3) primary key not null auto_increment,
    biaya varchar(12) not null
);

INSERT INTO ukt(biaya) values ("KIPK"), ("500k"), ("1,8jt"), ("3jt");

SELECT * FROM ukt;

INSERT INTO mahasiswa(nama_mhs, alamat, gol_ukt) values 
    ("Arif", "Mojokerto", 2),
    ("Yono", "Pati", 1);

CREATE VIEW vw_ukt AS SELECT 
    concat ("Gol", latihanmodul1.ukt.gol_ukt) as GOL,
    concat ("RP", latihanmodul1.ukt.biaya) as biaya FROM ukt;

SELECT * FROM ukt;
SELECT * FROM vw_ukt;

CREATE VIEW vw_mhs_ukt as SELECT m.id_mhs, m.nama_mhs, m.alamat, u.biaya
FROM mahasiswa m JOIN ukt u on m.gol_ukt = u.gol_ukt;

SELECT * FROM vw_mhs_ukt;