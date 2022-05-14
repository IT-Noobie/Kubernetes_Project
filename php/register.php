<?php
include_once 'configInsertRole.php';
session_start();
# RECEIVE VALUES FROM LOGIN
$username = $_POST['username'];
$email = $_POST['email'];
$contra = password_hash($_POST['password'], PASSWORD_DEFAULT);

$_SESSION['username'] = $username;
$_SESSION['email'] = $email;
$_SESSION['contra'] = $contra;

if ( empty($username) || empty($email) || empty($contra)) {
    if(empty($username)){
        echo "El campo nombre es obligatorio";
    }
    if (empty($email)) {
        echo "El campo usuario es obligatorio";
    }
    if (empty($password)) {
        echo "El campo contraseña es obligatorio";
    }
} else {
    # INSERT VALUES INTO DATABASE
    $insertar = mysqli_query($conexion, "INSERT INTO User VALUES ('$username', '$email', '$contra')");
	header("Location: ../images.php");
	}
	
?>
