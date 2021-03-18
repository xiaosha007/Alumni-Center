<?php
	include 'check_connection.php';
	$image = $_POST["image"];
	$fileName = "./userProfilePic/" . $_POST["fileName"];
	$realImage = base64_decode($image);
    file_put_contents($fileName,$realImage);
	
?>