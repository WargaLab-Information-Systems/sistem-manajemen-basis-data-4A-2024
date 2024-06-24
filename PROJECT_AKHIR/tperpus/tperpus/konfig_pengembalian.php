<?php
session_start();
include("koneksi.php");

// Pastikan pengguna telah login
if (!isset($_SESSION['status']) || $_SESSION['status'] !== "login successful") {
    header("Location: login.php");
    exit;
}

// Periksa apakah ada parameter id_buku yang diterima
if (isset($_POST['id_buku'])) {
    $id_buku = intval($_POST['id_buku']);
    $id_pengguna = isset($_SESSION['id_pengguna']) ? intval($_SESSION['id_pengguna']) : 0;

    // Ambil data peminjaman yang akan dihapus
    $sql_select_peminjaman = "SELECT * FROM peminjaman WHERE id_buku = ? AND id_pengguna = ?";
    $stmt_select_peminjaman = $koneksi->prepare($sql_select_peminjaman);
    if ($stmt_select_peminjaman === false) {
        die('Prepare failed: ' . htmlspecialchars($koneksi->error));
    }
    $stmt_select_peminjaman->bind_param("ii", $id_buku, $id_pengguna);
    $stmt_select_peminjaman->execute();
    $result_select_peminjaman = $stmt_select_peminjaman->get_result();
    $row_peminjaman = $result_select_peminjaman->fetch_assoc();
    $stmt_select_peminjaman->close();

    if ($row_peminjaman) {
        // Masukkan data pengembalian ke dalam tabel pengembalian
        $judul = $row_peminjaman['judul'];
        $tgl_pinjam = $row_peminjaman['tgl_pinjam'];
        $username = $_SESSION['username']; // Mengambil username dari session

        // Insert data pengembalian
        $tgl_kembali = date("Y-m-d");
        $sql_insert_pengembalian = "INSERT INTO pengembalian (id_pengguna, id_buku, username, judul, tgl_pinjam, tgl_kembali) VALUES (?, ?, ?, ?, ?, ?)";
        $stmt_insert_pengembalian = $koneksi->prepare($sql_insert_pengembalian);
        if ($stmt_insert_pengembalian === false) {
            die('Prepare failed: ' . htmlspecialchars($koneksi->error));
        }
        $stmt_insert_pengembalian->bind_param("iissss", $id_pengguna, $id_buku, $username, $judul, $tgl_pinjam, $tgl_kembali);
        if (!$stmt_insert_pengembalian->execute()) {
            die('Execute failed: ' . htmlspecialchars($stmt_insert_pengembalian->error));
        }
        $stmt_insert_pengembalian->close();

        // Hapus data dari tabel peminjaman
        $sql_delete_peminjaman = "DELETE FROM peminjaman WHERE id_buku = ? AND id_pengguna = ?";
        $stmt_delete_peminjaman = $koneksi->prepare($sql_delete_peminjaman);
        if ($stmt_delete_peminjaman === false) {
            die('Prepare failed: ' . htmlspecialchars($koneksi->error));
        }
        $stmt_delete_peminjaman->bind_param("ii", $id_buku, $id_pengguna);
        if (!$stmt_delete_peminjaman->execute()) {
            die('Execute failed: ' . htmlspecialchars($stmt_delete_peminjaman->error));
        }
        $stmt_delete_peminjaman->close();

        // Perbarui jumlah buku di tabel buku, jika tidak ada data peminjaman lagi dan ada data pengembalian
        $sql_update_buku = "UPDATE buku SET jumlah_buku = jumlah_buku + 1 WHERE id_buku = ?";
        $stmt_update_buku = $koneksi->prepare($sql_update_buku);
        if ($stmt_update_buku === false) {
            die('Prepare failed: ' . htmlspecialchars($koneksi->error));
        }
        $stmt_update_buku->bind_param("i", $id_buku);
        if (!$stmt_update_buku->execute()) {
            die('Execute failed: ' . htmlspecialchars($stmt_update_buku->error));
        }
        $stmt_update_buku->close();

        // Redirect ke halaman peminjaman
        header("Location: peminjaman.php");
        exit;
    } else {
        echo "Data peminjaman tidak ditemukan.";
    }
} else {
    echo "Invalid request.";
}
