<?php
	include 'check_connection.php';
	$image = $_POST["image"];
	$fileName = "./EventPoster/" . $_POST["fileName"];
	$realImage = base64_decode($image);
	//$sql = "UPDATE Users SET ProfilePic='".$image."' WHERE studentID=1171101805";
    file_put_contents($fileName,$realImage);
	
?>