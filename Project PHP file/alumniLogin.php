<?php
    include 'check_connection.php';
     $input_ID = addslashes($_POST["studentID"]);
     $input_password = addslashes($_POST["password"]);
     $sqlCommand = "SELECT UserID,UserPassword,UserType FROM Users;";
     $data = $connection->query($sqlCommand);
     $result = array();
     $login_pass = 0;
     if($data->num_rows >0){
         while($searchResult = $data->fetch_assoc()){
             $result[] = $searchResult;
             if($searchResult["UserID"]==$input_ID && $searchResult["UserPassword"]==$input_password && $searchResult["UserType"]!="Pending"){
                 $login_pass = 1;
                 if($searchResult["UserType"] == "Admin"){
                     $login_pass = 2;
                 }
                 break;
             }
         }
     }
     echo $login_pass;
?>