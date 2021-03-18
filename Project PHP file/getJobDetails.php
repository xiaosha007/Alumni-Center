<?php
    include 'check_connection.php';
     $input_ID = $_GET["jobID"];
     if($input_ID=="all"){
         $sqlCommand = "SELECT * FROM Job";
     }
     else{
         $sqlCommand = "SELECT * FROM Job WHERE jobID= ". $input_ID .";" ;
     }
     $data = $connection->query($sqlCommand);
     if(!$data){
         echo $connection->error;
     }
     $result = array();
     if($data->num_rows >0){
         while($searchResult = $data->fetch_assoc()){
             $result[] = $searchResult;
         }
     }
     echo json_encode($result);
?>