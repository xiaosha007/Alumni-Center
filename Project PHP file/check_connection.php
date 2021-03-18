<?php
     $server = "localhost";
     $username = "u972162994_uped";
     $password = "Aforapple123";
     $dbName = "u972162994_uped";
    
     $connection = new mysqli($server,$username,$password,$dbName);
     if($connection->connect_error){
         die("Connection failed: " . $connection->connect_error);
     }
?>

