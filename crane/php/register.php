<?php
include_once 'configInsertRole.php';
session_start();

# RECEIVE VALUES FROM LOGIN
$username = $_POST['username'];
$username .= "_user";
$email = $_POST['email'];
$contra = $_POST['password'];
$contraHashed = password_hash($_POST['password'], PASSWORD_DEFAULT);

$_SESSION['username'] = $username;
$_SESSION['email'] = $email;

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
    $insertar = mysqli_query($conexion, "INSERT INTO User VALUES ('$username', '$email', '$contraHashed')");
    $sshConnection = ssh2_connect('IP_CONTROLPLANE', 22);
    if (ssh2_auth_password($sshConnection, 'zeus', 'zeus')) {
        #echo "authentication Successful\n";
		$command = 'bash /home/zeus/scripts/sshScript.sh zeus '.$username.' '.$password;
        $stream = ssh2_exec($sshConnection, $command);
        #echo "hecho";
        #header("Location: ../images.php");
    } else {
        die('Authentication Failed');
    }
       }
?>
