
<?php
	include 'check_connection.php';
	$sqlCommand = "SELECT UserID,Email FROM Users;";
     $data = $connection->query($sqlCommand);

	$studentID = $_POST["studentID"];
	$userName = addslashes($_POST["userName"]);
	$password = addslashes($_POST["password"]);
	$email = addslashes($_POST["email"]);
	$country = addslashes($_POST["country"]);
	$userType = $_POST["userType"];
	$birthday = $_POST["birthday"];
	
	 $result = array();
     $register_pass = 1;
     if($data->num_rows >0){
         while($searchResult = $data->fetch_assoc()){
             $result[] = $searchResult;
             if($searchResult["UserID"]==$studentID || $searchResult["Email"]==$email){
                 $register_pass = 0;
                 break;
             }
         }
     }
	if($register_pass==1){
	    $sqlCommand = "INSERT INTO Users(UserID,UserName,UserPassword,Email,Country,UserType,Birthday) VALUES('" . $studentID . "','" . $userName . "','" .  $password . "','" . $email . "','" . $country . "','" . $userType . "','" . $birthday . "')";
	    if($connection->query($sqlCommand)===true){
	         $sqlCommand = "INSERT INTO Alumni(UserID,Description,MobileNum,Address,Course,YearOfGraduation) VALUES ('".$studentID."','default','default','default','default','2022')";
             if($connection->query($sqlCommand)===true){}
             else{
                echo $sqlCommand."<br>".$connection->error;
                }
        }
        else{
            echo $sqlCommand."<br>".$connection->error;
        }
	}
	echo $register_pass
	
?>
