<?php
$databaseHost = '172.16.41.139';
$databaseUsername = 'deleteRole';
$databasePassword = 'ruiz';
$databaseName = 'crane';

//Conexión mysql
$conexion = mysqli_connect($databaseHost, $databaseUsername, $databasePassword, $databaseName);
//Comprovación conexión a la base de datos
if (!$conexion){
    echo 'Error en la conexión a la base de datos';
}
else{
    echo 'Conectado a la base de datos';
}
?>
