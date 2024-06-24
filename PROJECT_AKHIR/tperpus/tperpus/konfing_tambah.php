<?php
// Start the session
session_start();

// Include database connection
require_once "koneksi.php";

// Ensure user is logged in
if (!isset($_SESSION['status']) || $_SESSION['status'] !== "login successful") {
    header("Location: login.php");
    exit;
}

// Handle form submission
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Prepare and bind
    $stmt = $koneksi->prepare("CALL InsertBuku(?, ?, ?, ?, ?, ?)");
    if ($stmt === false) {
        die('Prepare() failed: ' . htmlspecialchars($koneksi->error));
    }

    // Use "sssssi" for binding parameters (five strings and one integer)
    $stmt->bind_param("sssssi", $judul, $pengarang, $penerbit, $tahun_rilis, $kategori, $jumlah_buku);

    // Set parameters and execute
    $judul = $_POST['judul'];
    $pengarang = $_POST['pengarang'];
    $penerbit = $_POST['penerbit'];
    $tahun_rilis = $_POST['tahun_rilis'];
    $kategori = $_POST['kategori'];
    $jumlah_buku = intval($_POST['jumlah_buku']);

    // Execute the statement
    if ($stmt->execute()) {
        $_SESSION['message'] = "New record created successfully";
    } else {
        // Check if the error is due to duplicate title
        if ($koneksi->errno == 1644) {
            $_SESSION['message'] = "Error: Judul Buku Sudah Tersedia";
        } else {
            $_SESSION['message'] = "Error: " . $stmt->error;
        }
    }

    // Close statement and database connection
    $stmt->close();
    $koneksi->close();

    // Redirect to the form page
    header("Location: buku.php");
    exit;
}
