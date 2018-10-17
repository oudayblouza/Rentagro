<?php
require_once('../connect.php');

$username=$_GET['username'];

$sql="select * from users where username='".$username."' ";
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