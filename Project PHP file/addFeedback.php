
<?php
	include 'check_connection.php';



	$userID = $_POST["userID"];
	$submitDate = $_POST["submitDate"];
	$content = addslashes($_POST["content"]);
	$title = addslashes($_POST["title"]);
	
	
	$insertFeedback = 1; 
	
	$sqlCommand = "INSERT INTO Feedback(UserID, Content, SubmitDate,Title) VALUES('$userID','$content','$submitDate','$title')";
	if($connection->query($sqlCommand)===true){
	}
	else{
		$insertFeedback = 0;
		echo $sqlCommand."<br>".$connection->error;
	}
	
	echo $insertFeedback;
	
?>
