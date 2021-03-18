
<?php
	include 'check_connection.php';

	$userID = $_POST["userID"];
	$jobTitle = addslashes($_POST["jobTitle"]);
	$companyName = addslashes($_POST["companyName"]);
	$jobRequirements = addslashes($_POST["jobRequirements"]);
	$monthlySalary = $_POST["monthlySalary"];
	$datePosted = $_POST["datePosted"];
	$dateExpiry = $_POST["dateExpiry"];
	$image = $_POST["image"];
	
	
	$insertEvent = 1; 
	
	$sqlCommand = "INSERT INTO Job(UserID, JobTitle, CompanyName, JobRequirements, MonthlySalary, DatePosted, DateExpiry) VALUES('$userID','$jobTitle','$companyName','$jobRequirements','$monthlySalary','$datePosted','$dateExpiry')";
	
	
	if($connection->query($sqlCommand)===true){
	    $last_id = $connection->insert_id;
	    echo $last_id;
        $fileName = "./JobPoster/" . $last_id;
        $realImage = base64_decode($image);
        file_put_contents($fileName,$realImage);
	}
	else{
		$insertEvent = 0;
		echo $sqlCommand."<br>".$connection->error;
	}
	echo $insertEvent;
	
?>
