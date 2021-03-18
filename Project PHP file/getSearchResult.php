<?php
    include 'check_connection.php';
     $searchKey = addslashes($_GET["searchKey"]);
     
     $sqlCommand = "SELECT UserName,UserID FROM Users WHERE LOCATE('" . $searchKey . "',UserName)>0 AND UserType='Normal';";
     $data = $connection->query($sqlCommand);
     $result = array();
     if($data->num_rows >0){
         while($searchResult = $data->fetch_assoc()){
             $result[] = $searchResult;
         }
     }
     echo json_encode($result);
?>