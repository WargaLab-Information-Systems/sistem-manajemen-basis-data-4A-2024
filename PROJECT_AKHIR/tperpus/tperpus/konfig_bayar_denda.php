<?php
session_start();
include("koneksi.php");

// Ensure user is logged in
if (!isset($_SESSION['status']) || $_SESSION['status'] !== "login successful") {
    header("Location: login.php");
    exit;
}

// Get the logged-in username
$username = isset($_SESSION['username']) ? $_SESSION['username'] : '';

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $id_peminjaman = intval($_POST['id_peminjaman']);
    $denda = floatval($_POST['denda']);

    if ($denda <= 0) {
        header("Location: peminjaman.php?message=No fine to pay.");
        exit;
    }

    // Update query to set denda to 0
    $sql = "UPDATE peminjaman
            SET denda = 0
            WHERE username = ? AND id_peminjaman = ?";
    $stmt = $koneksi->prepare($sql);
    if (!$stmt) {
        die("Error in SQL query: " . $koneksi->error);
    }

    $stmt->bind_param("si", $username, $id_peminjaman);
    if ($stmt->execute()) {
        $stmt->close();
        $koneksi->close();
        header("Location: peminjaman.php?message=Fine paid successfully.");
    } else {
        $stmt->close();
        $koneksi->close();
        header("Location: peminjaman.php?message=Error in paying fine.");
    }
}
