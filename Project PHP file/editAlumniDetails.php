
<?php
	include 'check_connection.php';

	$description = addslashes($_POST["description"]);
	$mobileNum = addslashes($_POST["mobileNum"]);
	$address = addslashes($_POST["address"]);
	$course = addslashes($_POST["course"]);
	$yearOfGraduation = $_POST["yearOfGraduation"];
	$userID = $_POST["userID"];
	
	$editStatus = 1;
	
	 $result = array();
	$sqlCommand = "UPDATE Alumni SET Description='$description', MobileNum='$mobileNum', Address='$address',Course='$course',YearOfGraduation='$yearOfGraduation' WHERE UserID = '$userID'";
	if($connection->query($sqlCommand)===true){
		
	}
	else{
		echo $sqlCommand."<br>".$connection->error;
		$editStatus = 0;
	}
	echo $editStatus;
	
?>
