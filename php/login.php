<?php
    include_once "config.php";
    // Input Variables
    $user = $_POST['user']
    $name = $_POST['name']
    $password = $_POST['password']

    if (empty($user) || empty($name) || empty($password)) {
        if(empty($user)){
            echo "<font color='red'>El campo usuario es obligatorio<font/><br/>"
        }
        if(empty($name)){
            echo "<font color='red'>El campo nombre es obligatorio<font/><br/>"
        }
        if(empty($password)){
            echo "<font color='red'>El campo nombre es obligatorio<font/><br/>"
        }
    }
?>