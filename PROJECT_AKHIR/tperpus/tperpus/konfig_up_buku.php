<?php
// Koneksi database
require_once "koneksi.php";

// Pastikan semua data yang diterima dari form sudah di-POST dan bersihkan dari karakter khusus
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['id_buku'])) {
    $id_buku = mysqli_real_escape_string($koneksi, $_POST['id_buku']);
    $judul = mysqli_real_escape_string($koneksi, $_POST['judul']);
    $pengarang = mysqli_real_escape_string($koneksi, $_POST['pengarang']);
    $penerbit = mysqli_real_escape_string($koneksi, $_POST['penerbit']);
    $tahun_rilis = mysqli_real_escape_string($koneksi, $_POST['tahun_rilis']);
    $kategori = mysqli_real_escape_string($koneksi, $_POST['kategori']);
    $jumlah_buku = intval($_POST['jumlah_buku']); // Convert to integer using intval

    // Prepare and bind
    $stmt = $koneksi->prepare("UPDATE buku SET judul=?, pengarang=?, penerbit=?, tahun_rilis=?, kategori=?, jumlah_buku=? WHERE id_buku=?");
    if ($stmt === false) {
        die('Prepare() failed: ' . htmlspecialchars($koneksi->error));
    }
    $stmt->bind_param("ssssssi", $judul, $pengarang, $penerbit, $tahun_rilis, $kategori, $jumlah_buku, $id_buku);

    // Execute the statement
    if ($stmt->execute()) {
        // Redirect ke halaman daftar buku setelah berhasil update
        header("Location: buku.php");
        exit;
    } else {
        echo "Update gagal: " . htmlspecialchars($stmt->error);
    }

    // Close the statement
    $stmt->close();
} else {
    // Jika akses tidak valid, tampilkan pesan error
    echo "Akses tidak valid.";
}

// Menutup koneksi
mysqli_close($koneksi);
