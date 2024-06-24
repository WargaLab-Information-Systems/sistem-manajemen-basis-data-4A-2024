<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title img src="gambar/image.png">Login</title>
    <!-- link css  -->
    <link rel="stylesheet" href="tampil/login.css" />

    <!-- icons  -->
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.4/css/all.css" integrity="sha384-DyZ88mC6Up2uqS4h/KRgHuoeGwBcD4Ng9SiP4dIRy0EXTlnuz47vAwmeGwVChigm" crossorigin="anonymous" />
</head>

<body>
    <div class="flex-r container">
        <div class="flex-r login-wrapper">
            <div class="login-text">
                <div class="logo">
                    <span>SELAMAT DATANG DI PERPUSTAKAAN</span>
                </div>
                <h1>Sign In</h1>
                <p>Budakayan Membaca Sejak Dini!</p>
                <p>Mulai Membaca!</p>

                <form class="flex-c" action="konfig_login.php" method="POST">
                    <div class="input-box">
                        <span class="label">Username</span>
                        <div class="flex-r input">
                            <input type="text" placeholder="Username" name="username" required />
                        </div>
                    </div>

                    <!-- Email -->
                    <div class="input-box">
                        <span class="label">Email</span>
                        <div class="flex-r input">
                            <input type="email" name="email" placeholder="E-Mail" required />
                            <i class="fas fa-at"></i>
                        </div>
                    </div>
                    <!-- Sandi -->
                    <div class="input-box">
                        <span class="label">Password</span>
                        <div class="flex-r input">
                            <input name="pass" placeholder="Password" type="password" required />
                            <i class="fas fa-lock"></i>
                        </div>
                    </div>

                    <input class="btn" type="submit" value="Log In To Menu" name="Proses" />

                    <span class="extra-line">
                        <span>Belum Memiliki Akun ?</span>
                        <a href="register.php">Sign Up</a>
                    </span>
                </form>
            </div>
        </div>
    </div>
</body>

</html>