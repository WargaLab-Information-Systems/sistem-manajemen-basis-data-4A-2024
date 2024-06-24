-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 13 Jun 2024 pada 20.47
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `tperpus`
--

DELIMITER $$
--
-- Prosedur
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `CountPinjamBukuByUsername` (IN `p_username` VARCHAR(200), OUT `p_count` INT)   BEGIN
    DECLARE jumlah_pinjam INT;

    SELECT COUNT(*) INTO jumlah_pinjam
    FROM peminjaman
    WHERE username = p_username;

    SET p_count = jumlah_pinjam;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetPeminjaman` (IN `p_username` VARCHAR(200))   BEGIN
    SELECT 
        p.id_peminjaman, pg.username,p.id_pengguna,p.id_buku,p.judul, p.tgl_pinjam,p.tgl_kembali,p.denda
    FROM 
        peminjaman p
    INNER JOIN pengguna pg ON p.id_pengguna = pg.id_pengguna
    WHERE 
        pg.username = p_username;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetPengembalianByUsername` (IN `p_username` VARCHAR(200))   BEGIN
    SELECT id_pengembalian, id_buku, id_pengguna, username, 
        judul, tgl_pinjam, tgl_kembali
    FROM pengembalian
    WHERE username = p_username;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetTotalDendaPenggunaByUsername` (IN `p_username` VARCHAR(200))   BEGIN
    DECLARE tot_denda INT DEFAULT 0;
    DECLARE nilai_denda INT;
    DECLARE i INT DEFAULT 0;
    DECLARE total_baris INT;

    -- Menghitung jumlah baris yang sesuai dengan username
    SELECT COUNT(*) INTO total_baris
    FROM peminjaman 
    WHERE username = p_username;

    WHILE i < total_baris DO
        SELECT denda INTO nilai_denda 
        FROM peminjaman 
        WHERE username = p_username 
        LIMIT i, 1;

        SET tot_denda = tot_denda + nilai_denda;
        SET i = i + 1;
    END WHILE;

    -- Menampilkan total denda
    SELECT tot_denda AS TotalDenda;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertBuku` (IN `p_judul` VARCHAR(200), IN `p_pengarang` VARCHAR(200), IN `p_penerbit` VARCHAR(200), IN `p_tahun_rilis` VARCHAR(200), IN `p_kategori` VARCHAR(200), IN `p_jumlah_buku` INT)   BEGIN
    DECLARE judulExists INT;

    -- Check if the book title already exists
    SELECT COUNT(*) INTO judulExists
    FROM buku
    WHERE judul = p_judul;

    IF judulExists > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Judul Buku Sudah Tersedia';
    ELSE
        INSERT INTO buku (judul, pengarang, penerbit, tahun_rilis, kategori, jumlah_buku) 
        VALUES (p_judul, p_pengarang, p_penerbit, p_tahun_rilis, p_kategori, p_jumlah_buku);
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertPengguna` (IN `p_username` VARCHAR(200), IN `p_email` VARCHAR(200), IN `p_pass` VARCHAR(200))   BEGIN
    DECLARE userExists INT;

    SELECT COUNT(*) INTO userExists
    FROM pengguna
    WHERE username = p_username;

    IF userExists > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Username Sudah Tersedia';
    ELSE
        INSERT INTO pengguna (username, email, pass) VALUES (p_username, p_email, p_pass);
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `buku`
--

CREATE TABLE `buku` (
  `id_buku` int(11) NOT NULL,
  `judul` varchar(200) NOT NULL,
  `pengarang` varchar(200) NOT NULL,
  `penerbit` varchar(200) NOT NULL,
  `tahun_rilis` varchar(200) NOT NULL,
  `kategori` varchar(200) NOT NULL,
  `jumlah_buku` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `buku`
--

INSERT INTO `buku` (`id_buku`, `judul`, `pengarang`, `penerbit`, `tahun_rilis`, `kategori`, `jumlah_buku`) VALUES
(2, 'Chernobyl12', 'asdf', 'adsf', '2024-06-21', 'adf', 21),
(4, 'Sempoa', 'Albert Einstein', 'Cahaya Asia', '2024-05-27', 'Ilmiah', 26),
(5, 'Antariksa', 'Jompi', 'Jakarta Terbit', '2024-05-01', 'Astronomi', 25),
(6, 'Chernobyl', 'Valery Legasov', 'Pripiyat', '2024-05-30', 'Tragedi Dan Ilmiah', 21),
(7, 'Pulang', 'Tereliye', 'Indo Cahaya', '2024-05-30', 'Aksi', 27);

--
-- Trigger `buku`
--
DELIMITER $$
CREATE TRIGGER `after_buku_delete` AFTER DELETE ON `buku` FOR EACH ROW BEGIN
    -- Masukkan data penghapusan ke dalam tabel log_data
    INSERT INTO log_data (id_buku, judul, pengarang, penerbit, tahun_rilis, kategori, jumlah_buku)
    VALUES (OLD.id_buku, OLD.judul, OLD.pengarang, OLD.penerbit, OLD.tahun_rilis, OLD.kategori, OLD.jumlah_buku);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `iniadmin`
--

CREATE TABLE `iniadmin` (
  `id_admin` int(11) NOT NULL,
  `username` varchar(200) NOT NULL,
  `email` varchar(200) NOT NULL,
  `pass` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `iniadmin`
--

INSERT INTO `iniadmin` (`id_admin`, `username`, `email`, `pass`) VALUES
(2, 'admin', 'admin@admin.com', 'admin');

-- --------------------------------------------------------

--
-- Struktur dari tabel `log_data`
--

CREATE TABLE `log_data` (
  `id_log` int(11) NOT NULL,
  `id_buku` int(11) NOT NULL,
  `judul` varchar(200) NOT NULL,
  `pengarang` varchar(200) NOT NULL,
  `penerbit` varchar(200) NOT NULL,
  `tahun_rilis` varchar(200) NOT NULL,
  `kategori` varchar(200) NOT NULL,
  `jumlah_buku` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `log_data`
--

INSERT INTO `log_data` (`id_log`, `id_buku`, `judul`, `pengarang`, `penerbit`, `tahun_rilis`, `kategori`, `jumlah_buku`) VALUES
(1, 3, 'Ade Nyebelin', 'Ade Asli Kudus', 'Judol 123', '2024-01-08', 'Extreme', 16),
(2, 1, 'PP', 'PP', 'PP', '2020-05-05', 'Aksi', 7),
(3, 9, 'PP', 'Rehan', 'Rehan', '2024-06-13', 'asd', 123),
(4, 8, 'PP', 'Rehan', 'Rehan', '2024-05-29', 'asd', 123);

-- --------------------------------------------------------

--
-- Struktur dari tabel `peminjaman`
--

CREATE TABLE `peminjaman` (
  `id_peminjaman` int(10) NOT NULL,
  `id_pengguna` int(10) NOT NULL,
  `id_buku` int(10) NOT NULL,
  `username` varchar(200) NOT NULL,
  `judul` varchar(200) NOT NULL,
  `tgl_pinjam` date NOT NULL,
  `tgl_kembali` date NOT NULL,
  `denda` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `peminjaman`
--

INSERT INTO `peminjaman` (`id_peminjaman`, `id_pengguna`, `id_buku`, `username`, `judul`, `tgl_pinjam`, `tgl_kembali`, `denda`) VALUES
(112, 1, 4, 'SS', 'Sempoa', '2024-06-03', '2024-06-20', 17000),
(113, 1, 7, 'SS', 'Pulang', '2024-06-01', '2024-06-20', 19000),
(124, 9, 7, 'Sigma', 'Pulang', '2024-06-13', '2024-06-21', 0),
(125, 9, 4, 'Sigma', 'Sempoa', '2024-06-13', '2024-06-20', 0),
(126, 9, 6, 'Sigma', 'Chernobyl', '2024-06-13', '2024-06-20', 0);

--
-- Trigger `peminjaman`
--
DELIMITER $$
CREATE TRIGGER `PinjamBuku` AFTER INSERT ON `peminjaman` FOR EACH ROW BEGIN
    UPDATE buku
    SET jumlah_buku = jumlah_buku - 1
    WHERE id_buku = NEW.id_buku;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_peminjaman` AFTER UPDATE ON `peminjaman` FOR EACH ROW BEGIN
    -- Jika ada data peminjaman yang diupdate, cek apakah telah ada data pengembalian
    DECLARE jumlah_pinjam INT;
    DECLARE jumlah_kembali INT;
    
    SELECT COUNT(*) INTO jumlah_pinjam
    FROM peminjaman
    WHERE id_buku = OLD.id_buku AND tgl_kembali IS NULL;
    
    SELECT COUNT(*) INTO jumlah_kembali
    FROM pengembalian
    WHERE id_buku = OLD.id_buku;
    
    IF jumlah_pinjam = 0 AND jumlah_kembali > 0 THEN
        UPDATE buku
        SET jumlah_buku = jumlah_buku + 1
        WHERE id_buku = OLD.id_buku;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `pengembalian`
--

CREATE TABLE `pengembalian` (
  `id_pengembalian` int(10) NOT NULL,
  `id_buku` int(10) NOT NULL,
  `id_pengguna` int(10) NOT NULL,
  `username` varchar(200) NOT NULL,
  `judul` varchar(200) NOT NULL,
  `tgl_pinjam` date NOT NULL,
  `tgl_kembali` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `pengembalian`
--

INSERT INTO `pengembalian` (`id_pengembalian`, `id_buku`, `id_pengguna`, `username`, `judul`, `tgl_pinjam`, `tgl_kembali`) VALUES
(95, 2, 9, 'Sigma', 'Chernobyl12', '2024-06-13', '2024-06-13'),
(96, 2, 9, 'Sigma', 'Chernobyl12', '2024-06-13', '2024-06-13'),
(97, 5, 9, 'Sigma', 'Antariksa', '2024-06-13', '2024-06-13'),
(98, 6, 1, 'SS', 'Chernobyl', '2024-06-13', '2024-06-13'),
(99, 2, 1, 'SS', 'Chernobyl12', '2024-06-13', '2024-06-13'),
(100, 6, 9, 'Sigma', 'Chernobyl', '2024-06-13', '2024-06-13'),
(101, 7, 9, 'Sigma', 'Pulang', '2024-06-02', '2024-06-13'),
(102, 4, 9, 'Sigma', 'Sempoa', '2024-06-01', '2024-06-13'),
(103, 2, 9, 'Sigma', 'Chernobyl12', '2024-06-13', '2024-06-13'),
(104, 2, 9, 'Sigma', 'Chernobyl12', '2024-06-01', '2024-06-13'),
(105, 5, 9, 'Sigma', 'Antariksa', '2024-06-13', '2024-06-13'),
(106, 4, 9, 'Sigma', 'Sempoa', '2024-06-03', '2024-06-13'),
(107, 2, 9, 'Sigma', 'Chernobyl12', '2024-06-13', '2024-06-13'),
(108, 4, 9, 'Sigma', 'Sempoa', '2024-06-13', '2024-06-13'),
(109, 6, 9, 'Sigma', 'Chernobyl', '2024-06-13', '2024-06-13'),
(110, 2, 9, 'Sigma', 'Chernobyl12', '2024-06-13', '2024-06-13');

-- --------------------------------------------------------

--
-- Struktur dari tabel `pengguna`
--

CREATE TABLE `pengguna` (
  `id_pengguna` int(11) NOT NULL,
  `username` varchar(200) NOT NULL,
  `email` varchar(200) NOT NULL,
  `pass` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `pengguna`
--

INSERT INTO `pengguna` (`id_pengguna`, `username`, `email`, `pass`) VALUES
(1, 'SS', 'AA@gmail.com', '123'),
(2, 'Tymo', 'prasetyosigma2@gmail.com', '123'),
(3, 'sigma09', 'sigma.top123@gmail.com', '123'),
(4, 'jj', 'jj@jj', '123'),
(5, 'Dibaca', 'DIbaca@Gmail.com', 'Baca'),
(6, 'Dibaca1', 'DIbaca1@Gmail.com', 'Baca'),
(7, 'Dibaca12', 'DIbaca1@12Gmail.com', 'Baca'),
(8, 'Dibaca123', 'DIbaca1@123Gmail.com', 'Baca'),
(9, 'Sigma', '123@a.com', '123'),
(10, 'Tono', '123@ab.com', '123'),
(11, 'Alim', 'Alim@123.com', '123'),
(12, '123', '123@a.com', '123');

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `total_pengguna`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `total_pengguna` (
`Jumlah_Anggota` bigint(21)
);

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `total_terpinjam`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `total_terpinjam` (
`total_pinjam` bigint(21)
);

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `vw_buku_pinjam`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `vw_buku_pinjam` (
`jumlah_pinjam` bigint(21)
);

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `vw_denda`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `vw_denda` (
`Jumlah_Denda` decimal(32,0)
);

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `vw_jumlah`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `vw_jumlah` (
`Jumlah_Buku` decimal(32,0)
);

-- --------------------------------------------------------

--
-- Struktur untuk view `total_pengguna`
--
DROP TABLE IF EXISTS `total_pengguna`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `total_pengguna`  AS SELECT count(`pengguna`.`username`) AS `Jumlah_Anggota` FROM `pengguna` ;

-- --------------------------------------------------------

--
-- Struktur untuk view `total_terpinjam`
--
DROP TABLE IF EXISTS `total_terpinjam`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `total_terpinjam`  AS SELECT count(`pengembalian`.`judul`) AS `total_pinjam` FROM `pengembalian` ;

-- --------------------------------------------------------

--
-- Struktur untuk view `vw_buku_pinjam`
--
DROP TABLE IF EXISTS `vw_buku_pinjam`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_buku_pinjam`  AS SELECT count(`peminjaman`.`judul`) AS `jumlah_pinjam` FROM `peminjaman` ;

-- --------------------------------------------------------

--
-- Struktur untuk view `vw_denda`
--
DROP TABLE IF EXISTS `vw_denda`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_denda`  AS SELECT sum(`peminjaman`.`denda`) AS `Jumlah_Denda` FROM `peminjaman` ;

-- --------------------------------------------------------

--
-- Struktur untuk view `vw_jumlah`
--
DROP TABLE IF EXISTS `vw_jumlah`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_jumlah`  AS SELECT sum(`buku`.`jumlah_buku`) AS `Jumlah_Buku` FROM `buku` ;

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `buku`
--
ALTER TABLE `buku`
  ADD PRIMARY KEY (`id_buku`);

--
-- Indeks untuk tabel `iniadmin`
--
ALTER TABLE `iniadmin`
  ADD PRIMARY KEY (`id_admin`);

--
-- Indeks untuk tabel `log_data`
--
ALTER TABLE `log_data`
  ADD PRIMARY KEY (`id_log`);

--
-- Indeks untuk tabel `peminjaman`
--
ALTER TABLE `peminjaman`
  ADD PRIMARY KEY (`id_peminjaman`),
  ADD KEY `id_pengguna` (`id_pengguna`),
  ADD KEY `id_buku` (`id_buku`);

--
-- Indeks untuk tabel `pengembalian`
--
ALTER TABLE `pengembalian`
  ADD PRIMARY KEY (`id_pengembalian`),
  ADD KEY `id_pengguna` (`id_pengguna`),
  ADD KEY `id_buku` (`id_buku`);

--
-- Indeks untuk tabel `pengguna`
--
ALTER TABLE `pengguna`
  ADD PRIMARY KEY (`id_pengguna`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `buku`
--
ALTER TABLE `buku`
  MODIFY `id_buku` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT untuk tabel `iniadmin`
--
ALTER TABLE `iniadmin`
  MODIFY `id_admin` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `log_data`
--
ALTER TABLE `log_data`
  MODIFY `id_log` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT untuk tabel `peminjaman`
--
ALTER TABLE `peminjaman`
  MODIFY `id_peminjaman` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=127;

--
-- AUTO_INCREMENT untuk tabel `pengembalian`
--
ALTER TABLE `pengembalian`
  MODIFY `id_pengembalian` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=111;

--
-- AUTO_INCREMENT untuk tabel `pengguna`
--
ALTER TABLE `pengguna`
  MODIFY `id_pengguna` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `peminjaman`
--
ALTER TABLE `peminjaman`
  ADD CONSTRAINT `peminjaman_ibfk_1` FOREIGN KEY (`id_pengguna`) REFERENCES `pengguna` (`id_pengguna`),
  ADD CONSTRAINT `peminjaman_ibfk_2` FOREIGN KEY (`id_buku`) REFERENCES `buku` (`id_buku`);

--
-- Ketidakleluasaan untuk tabel `pengembalian`
--
ALTER TABLE `pengembalian`
  ADD CONSTRAINT `pengembalian_ibfk_3` FOREIGN KEY (`id_pengguna`) REFERENCES `pengguna` (`id_pengguna`),
  ADD CONSTRAINT `pengembalian_ibfk_4` FOREIGN KEY (`id_buku`) REFERENCES `buku` (`id_buku`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
