<?php
    include 'check_connection.php';
     $input_ID = $_GET["feedbackID"];
     if($input_ID=="all"){
         $sqlCommand = "SELECT * FROM Feedback WHERE feedbackID";
     }
     else{
         $sqlCommand = "SELECT * FROM Feedback WHERE feedbackID= ". $input_ID .";" ;
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