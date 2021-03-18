
<?php
	include 'check_connection.php';

	$eventID = $_POST["eventID"];
	$eventStatus = $_POST["eventStatus"];
	
	$editStatus = 1;
	
	$sqlCommand = "UPDATE Events SET Status = '$eventStatus' WHERE EventID = '$eventID'";
	if($connection->query($sqlCommand)===true){
		
	}
	else{
		echo $sqlCommand."<br>".$connection->error;
		$editStatus = 0;
	}
	echo $editStatus;
	
?>
