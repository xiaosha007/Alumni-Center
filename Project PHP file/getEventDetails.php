<?php
    include 'check_connection.php';
     $input_ID = $_GET["eventID"];
     $user_ID = null;
     $upcoming = $_GET["upcoming"];
     
     if($_GET["userID"]!=null){
         $user_ID = $_GET["userID"];
         $sqlCommand = "SELECT * FROM Events WHERE UserID = '$user_ID'";
     }
     else if($input_ID=="all" && $upcoming == "true"){
         $sqlCommand = "SELECT * FROM Events WHERE Date>=CURRENT_DATE";
     }
     else if($input_ID=="all" && $upcoming == "false"){
         $sqlCommand = "SELECT * FROM Events";
     }
     else {
         $sqlCommand = "SELECT UserID, Title, Description, Venue, StartTime, EndTime, Date, Status FROM Events WHERE eventID=  '$input_ID' ;" ;
     }
     $data = $connection->query($sqlCommand);
     $result = array();
     if($data->num_rows >0){
         while($searchResult = $data->fetch_assoc()){
             $result[] = $searchResult;
         }
     }
     echo json_encode($result);
?>