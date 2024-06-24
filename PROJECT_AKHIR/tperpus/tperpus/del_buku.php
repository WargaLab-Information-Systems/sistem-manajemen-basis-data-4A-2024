<?php
session_start();

// Check if user is logged in
if (!isset($_SESSION['status']) || $_SESSION['status'] !== "login successful") {
    header("Location: login.php");
    exit;
}

// Include database connection
include("koneksi.php");

// Check if the book ID is set
if (isset($_GET['id_buku'])) {
    $id_buku = $_GET['id_buku'];

    // SQL query to delete book
    $sql = "DELETE FROM buku WHERE id_buku = $id_buku";

    if ($koneksi->query($sql) === TRUE) {
        // Redirect back to buku.php after successful deletion
        header("Location: buku.php");
        exit;
    } else {
        echo "Error deleting record: " . $koneksi->error;
    }
} else {
    echo "No book ID specified";
}
