<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="./style/style_login.css">
    <title>Bike & Ride</title>
</head>
    <?php 
    require 'nav.html'; // Hacemos que la cabecera/barra de navegación sea visible

    if(isset ($_GET["redirigido"])){
        echo "<p>Haga login para continuar</p>";
    }
    ?>
    <?php 
    if(isset($err) and $err == true){
        echo "<p class=error>Revise usuario y contraseña</p>";
    }
    ?>
    <body>
    <div class="login__form">
    <form action="<?php echo htmlspecialchars($_SERVER['PHP_SELF']); ?>" method="post">
        
        <label for="usuario">Usuario</label>
        <input value="<?php if(isset($usuario)) echo $usuario ?>" id="usuario" name="usuario" type="text">
        <label for="clave">Password</label>
        <input type="password" name="clave" id="clave">
        <br>
        <input type="submit">
        <br>
    </form>
    </div>
</body>
</html>