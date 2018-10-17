<?php
require_once('../connect.php');

$longitude=$_GET['longitude'];
$latitude=$_GET['latitude'];
$id=$_GET['id'];
    

$sql = "UPDATE  users SET longitude='$longitude',latitude='$latitude'   where id='$id'";

if (mysqli_query($conn, $sql)) {
    echo "success";
} else {
    echo "Error: " . $sql . "<br>" . mysqli_error($conn);
}

mysqli_close($conn);
?>