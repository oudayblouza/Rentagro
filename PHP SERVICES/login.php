<?php
require_once('connect.php');

$username=$_GET['username'];

$sql="select * from users where email='".$username."' ";
$result = $conn->query($sql);

$json = new SimpleXMLElement('<xml/>');
if ($result->num_rows > 0) {

    if($row = $result->fetch_assoc()) {

     echo $row['password'];

    }
	
}else{
	echo 'not found';
}

?>