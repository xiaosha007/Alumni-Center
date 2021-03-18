<?php
    include 'check_connection.php';
     $input_ID = $_GET["announcementID"];
     
     if($input_ID=="all"){
         $sqlCommand = "SELECT * FROM Announcement ORDER BY PublishDate ASC;";
     }
     else{
         $sqlCommand = "SELECT * FROM Announcement WHERE announcementID= ". $input_ID .";" ;
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