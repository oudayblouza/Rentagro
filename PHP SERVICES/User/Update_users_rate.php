<?php
require_once('../connect.php');

$id=$_GET['id'];
$rate=$_GET['rate'];

    

$sql = "UPDATE  users SET rate=rate + '$rate',voters=voters+1   where id='$id'";

if (mysqli_query($conn, $sql)) {
    echo "success";
} else {
    echo "Error: " . $sql . "<br>" . mysqli_error($conn);
}

mysqli_close($conn);
?>