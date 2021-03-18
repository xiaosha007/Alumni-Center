<?php
    include 'check_connection.php';
     $input_ID = $_GET["studentID"];
     if($input_ID=="all"){
         $sqlCommand = "SELECT UserID,UserName,Email,Country,Birthday FROM Users";
     }
     else if($input_ID=="pending"){
         $sqlCommand = "SELECT UserID,UserName,Email,Country,Birthday FROM Users WHERE UserType='Pending';" ;
     }
     else{
         $sqlCommand = "SELECT UserID,UserName,Email,Country,Birthday FROM Users WHERE UserID= '$input_ID';" ;
     }
     $data = $connection->query($sqlCommand);
     $result = array();
     if($data->num_rows >0){
         while($searchResult = $data->fetch_assoc()){
             $result[] = $searchResult;
         }
     }
     else{
         echo $connection->error;
     }
     echo json_encode($result);
?>