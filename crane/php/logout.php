 <?php
	include_once "configDeleteRole.php";
	session_start();
	$username = $_SESSION['username'];
	$eliminar = mysqli_query($conexion, "DELETE FROM User WHERE username='$username'");
	unset($_SESSION["username"]);
?>
