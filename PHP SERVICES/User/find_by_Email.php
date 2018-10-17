<?php
require_once('../connect.php');

$email=$_GET['email'];

$sql="select * from users where email='".$email."' ";
$result = $conn->query($sql);

$json = new SimpleXMLElement('<xml/>');
if ($result->num_rows > 0) {

    if($row = $result->fetch_assoc()) {

     echo 'success';

    }
	
}else{
	echo 'not found';
}

?>