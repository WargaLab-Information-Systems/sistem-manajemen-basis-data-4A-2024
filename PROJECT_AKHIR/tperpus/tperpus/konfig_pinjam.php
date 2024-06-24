<?php
session_start();
include("koneksi.php");

// Ensure the user is logged in
if (!isset($_SESSION['status']) || $_SESSION['status'] !== "login successful") {
    header("Location: login.php");
    exit;
}

if (isset($_GET['id_buku'])) {
    $id_buku = intval($_GET['id_buku']);
    $id_pengguna = isset($_SESSION['id_pengguna']) ? intval($_SESSION['id_pengguna']) : 0;

    // Check if the user exists in the pengguna table
    $sql = "SELECT username FROM pengguna WHERE id_pengguna = ?";
    $stmt = $koneksi->prepare($sql);
    if ($stmt === false) {
        die('Prepare failed: ' . htmlspecialchars($koneksi->error));
    }
    $stmt->bind_param("i", $id_pengguna);
    $stmt->execute();
    $stmt->bind_result($username);
    $stmt->fetch();
    $stmt->close();

    if ($username) {
        // Check if the user has already borrowed this book
        $sql = "SELECT COUNT(*) FROM peminjaman WHERE id_pengguna = ? AND id_buku = ?";
        $stmt = $koneksi->prepare($sql);
        if ($stmt === false) {
            die('Prepare failed: ' . htmlspecialchars($koneksi->error));
        }
        $stmt->bind_param("ii", $id_pengguna, $id_buku);
        $stmt->execute();
        $stmt->bind_result($count);
        $stmt->fetch();
        $stmt->close();

        if ($count > 0) {
            echo "<script>
            alert('Anda sudah meminjam buku ini.');
            document.location.href = 'bukuser.php';
            </script>
            ";
            exit;
        }

        // Get the book details
        $sql = "SELECT judul, jumlah_buku FROM buku WHERE id_buku = ?";
        $stmt = $koneksi->prepare($sql);
        if ($stmt === false) {
            die('Prepare failed: ' . htmlspecialchars($koneksi->error));
        }
        $stmt->bind_param("i", $id_buku);
        $stmt->execute();
        $stmt->bind_result($judul, $jumlah_buku);
        $stmt->fetch();
        $stmt->close();

        if ($jumlah_buku > 0) {
            // Calculate the borrowing dates
            $tgl_pinjam = date("Y-m-d");
            $tgl_kembali = date("Y-m-d", strtotime("+7 days", strtotime($tgl_pinjam)));

            // Insert into peminjaman table
            $sql = "INSERT INTO peminjaman (id_pengguna, id_buku, username, judul, tgl_pinjam, tgl_kembali) VALUES (?, ?, ?, ?, ?, ?)";
            $stmt = $koneksi->prepare($sql);
            if ($stmt === false) {
                die('Prepare failed: ' . htmlspecialchars($koneksi->error));
            }
            $stmt->bind_param("iissss", $id_pengguna, $id_buku, $username, $judul, $tgl_pinjam, $tgl_kembali);
            if (!$stmt->execute()) {
                die('Execute failed: ' . htmlspecialchars($stmt->error));
            }
            $stmt->close();

            // Redirect to a success page or the previous page
            header("Location: peminjaman.php");
            exit;
        } else {
            echo "<script>
            alert('Stok Buku Habis');
            document.location.href = 'bukuser.php';
            </script>
            ";
        }
    } else {
        echo "User not found.";
    }
} else {
    echo "Invalid request.";
}

// Close database connection
$koneksi->close();
