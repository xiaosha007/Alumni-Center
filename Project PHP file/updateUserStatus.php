
<?php
	include 'check_connection.php';

	$status = $_POST["status"];
	$userID = $_POST["userID"];
	
	$editStatus = 1;
	
	if($status=="Denied"){
	    $sqlCommand = "DELETE FROM Alumni WHERE UserID = '$userID';";
	    if($connection->query($sqlCommand)===true){
		    $sqlCommand = "DELETE FROM Users WHERE UserID = '$userID';";
		    if($connection->query($sqlCommand)===true){
		        
		    }
		    else{
		        echo $sqlCommand."<br>".$connection->error;
		        $editStatus = 0;
		    }
		}
		else{
		    echo $sqlCommand."<br>".$connection->error;
		    $editStatus = 0;
		}
	}
	else{
	    $sqlCommand = "UPDATE Users SET UserType = '$status' WHERE UserID = '$userID'";
	    if($connection->query($sqlCommand)===true){
		
	    }
	    else{
		    echo $sqlCommand."<br>".$connection->error;
		    $editStatus = 0;
	    }
	}
	
	echo $editStatus;
	
?>
