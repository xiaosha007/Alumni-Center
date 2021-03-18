
<?php
	include 'check_connection.php';

	$userID = $_POST["userID"];
	$title = addslashes($_POST["title"]);
	$content =addslashes($_POST["content"]);
	$publishDate = $_POST["publishDate"];
	
	
	$insertAnnouncement = 1; 
	
	$sqlCommand = "INSERT INTO Announcement(UserID, Title, Content, PublishDate) VALUES('$userID','$title','$content','$publishDate')";
	if($connection->query($sqlCommand)===true){
	}
	else{
		$insertAnnouncement = 0;
		echo $sqlCommand."<br>".$connection->error;
	}
	
	echo $insertAnnouncement;
	
?>
