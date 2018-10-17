<?php
require_once('../connect.php');

$num=$_GET['num'];
$resp=$_GET['resp'];
$id=$_GET['id'];
    

$sql = "UPDATE  users SET numtel='$num',prenom='$resp'   where id='$id'";

if (mysqli_query($conn, $sql)) {
    echo "success";
} else {
    echo "Error: " . $sql . "<br>" . mysqli_error($conn);
}

mysqli_close($conn);
?>