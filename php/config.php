<?php
//variables conexión
$databaseHost = '10.0.4.0';
$databaseUsername = 'insert_role';
$databasePassword = 'AdmiContra_1234';
$databaseName = 'crane';

//Conexión mysql
$conexion = mysqli_connect($databaseHost, $databaseUsername, $databasePassword, $databaseName);
//Comprovación conexión a la base de datos
if (!$conexion){
    echo 'Error en la conexión a la base de datos';
}
else{
    //echo'Conectado a la base de datos';
}
