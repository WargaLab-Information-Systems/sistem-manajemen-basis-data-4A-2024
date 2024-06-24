<?php
// Mengakses config.php
include 'koneksi.php';

// Start the session
session_start();

$user = $_POST['username'];
$email = $_POST['email'];
$pass = $_POST['pass'];

// Initialize a flag to check if the login is successful
$login_successful = false;

// Check for admin
$stmt_admin = $koneksi->prepare("SELECT * FROM iniadmin WHERE username = ? AND pass = ? AND email = ?");
if ($stmt_admin) {
    $stmt_admin->bind_param("sss", $user, $pass, $email);
    $stmt_admin->execute();
    $result_admin = $stmt_admin->get_result();
    $cek_admin = $result_admin->num_rows;

    if ($cek_admin > 0) {
        $_SESSION['username'] = $user;
        $_SESSION['status'] = "login successful";
        $_SESSION['role'] = "admin"; // Set role to admin
        $login_successful = true;
        header("Location: admin.php"); // Redirect to admin dashboard
        exit; // Ensure no further code is executed
    }
    $stmt_admin->close();
} else {
    echo "Error: " . $koneksi->error;
}

// Check for regular user only if admin login was not successful
if (!$login_successful) {
    $stmt_user = $koneksi->prepare("SELECT id_pengguna, username FROM pengguna WHERE username = ? AND pass = ? AND email = ?");
    if ($stmt_user) {
        $stmt_user->bind_param("sss", $user, $pass, $email);
        $stmt_user->execute();
        $stmt_user->bind_result($id_pengguna, $username);
        $stmt_user->fetch();

        if ($id_pengguna) {
            $_SESSION['id_pengguna'] = $id_pengguna; // Set id_pengguna in session
            $_SESSION['username'] = $username;
            $_SESSION['status'] = "login successful";
            $_SESSION['role'] = "user"; // Set role to user
            $login_successful = true;
            header("Location: index.php");
            exit; // Ensure no further code is executed
        }
        $stmt_user->close();
    } else {
        echo "Error: " . $koneksi->error;
    }
}

// If login failed
if (!$login_successful) {
    echo "
        <script>
            alert('Login gagal');
            document.location.href = 'login.php';
        </script>
    ";
}

// Close the database connection
$koneksi->close();
