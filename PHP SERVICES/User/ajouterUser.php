<?php
require_once('../connect.php');

$username=$_GET['username'];
$email=$_GET['email'];
$password=$_GET['password'];
$roles=$_GET['roles'];
$prenom=$_GET['prenom'];
$numtel=$_GET['numtel'];
$delegation_id=$_GET['delegation_id'];
$latitude=$_GET['latitude'];
$longitude=$_GET['longitude'];
$rate=$_GET['rate'];
$voters=$_GET['voters'];

$sql = "INSERT INTO users (username, username_canonical,email,email_canonical,enabled,password,roles,delegation_id,longitude,latitude,numtel,prenom,rate,voters)
VALUES ( '$username','$username','$email','$email','1','$password','$roles','$delegation_id','$longitude','$latitude','$numtel','$prenom','$rate','$voters')";

if (mysqli_query($conn, $sql)) {
    echo "success";
} else {
    echo "Error : " . $sql . "<br>" . mysqli_error($conn);
}
?>