
<?php
	include 'check_connection.php';

	$userID = $_POST["userID"];
	$title = addslashes($_POST["title"]);
	$description = addslashes($_POST["description"]);
	$venue = addslashes($_POST["venue"]);
	$startTime = $_POST["startTime"];
	$endTime = $_POST["endTime"];
	$date = $_POST["date"];
	$status = $_POST["status"];
	$image = $_POST["image"];
	
	
	$insertEvent = 1; 
	
	$sqlCommand = "INSERT INTO Events(UserID, Title, Description, Venue, StartTime, EndTime, Date, Status) VALUES('$userID','$title','$description','$venue','$startTime','$endTime','$date','$status')";
	
	
	if($connection->query($sqlCommand)===true){
	    $last_id = $connection->insert_id;
	    echo $last_id;
        $fileName = "./EventPoster/" . $last_id;
        $realImage = base64_decode($image);
        file_put_contents($fileName,$realImage);
	}
	else{
		$insertEvent = 0;
		echo $sqlCommand."<br>".$connection->error;
	}
	echo $insertEvent;
	
?>
