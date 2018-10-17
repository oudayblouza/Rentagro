<?php
require_once('../connect.php');

$pass=$_GET['pass'];

$id=$_GET['id'];
    

$sql = "UPDATE  users SET password='$pass' where id='$id'";

if (mysqli_query($conn, $sql)) {
    echo "success";
} else {
    echo "Error: " . $sql . "<br>" . mysqli_error($conn);
}

mysqli_close($conn);
?>