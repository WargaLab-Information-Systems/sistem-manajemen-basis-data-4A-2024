<?php

include("koneksi.php");

function submit($email, $username, $pass)
{
    global $koneksi;

    // Melakukan sanitasi input untuk mencegah SQL injection
    $email = mysqli_real_escape_string($koneksi, $email);
    $username = mysqli_real_escape_string($koneksi, $username);
    $pass = mysqli_real_escape_string($koneksi, $pass);

    // Menyiapkan statement untuk memanggil stored procedure
    $stmt = $koneksi->prepare("CALL InsertPengguna(?, ?, ?)");

    // Memeriksa apakah statement berhasil dipersiapkan
    if ($stmt === false) {
        die('Prepare failed: ' . htmlspecialchars($koneksi->error));
    }

    // Mengikat parameter
    $stmt->bind_param("sss", $username, $email, $pass);

    // Menjalankan stored procedure
    $result = $stmt->execute();

    // Memeriksa hasil eksekusi
    if ($result) {
        $stmt->close();
        return true;
    } else {
        // Memeriksa kode error untuk menentukan penyebab kegagalan
        if ($stmt->errno == 1644) { // 1644 adalah kode SQLSTATE '45000' untuk error yang di-signal dari stored procedure
            $stmt->close();
            return false;
        } else {
            die('Execute failed: ' . htmlspecialchars($stmt->error));
        }
    }
}

if (isset($_POST['Proses'])) {
    $email = $_POST['email'];
    $username = $_POST['username'];
    $pass = $_POST['pass'];

    if (submit($email, $username, $pass)) {
        // Redirect ke halaman login.php jika register berhasil
        echo "<script> alert('Register Berhasil');
                document.location.href='login.php';
                </script>";
        exit();
    } else {
        // Notifikasi register gagal
        echo "<script> alert('Username sudah digunakan');
                document.location.href='register.php';
                </script>";
    }
}

mysqli_close($koneksi);
