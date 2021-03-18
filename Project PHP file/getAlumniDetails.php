<?php
    include 'check_connection.php';
     $input_ID = $_GET["studentID"];
     if($input_ID == "all"){
         $sqlCommand = "SELECT * FROM Alumni";
     }
     else{
         $sqlCommand = "SELECT Description,Address,MobileNum,Course,YearOfGraduation FROM Alumni WHERE UserID= '$input_ID';";
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