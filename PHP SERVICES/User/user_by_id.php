<?php
require_once('../connect.php');

$id=$_GET['id'];

$sql="select * from users where id='$id' ";
$result = $conn->query($sql);

$json = new SimpleXMLElement('<xml/>');
if ($result->num_rows > 0) {

    while($row = $result->fetch_assoc()) {
        $mydata = $json->addChild('users');
        $mydata->addChild('id',$row['id']);
        $mydata->addChild('username',$row['username']);
        $mydata->addChild('email',$row['email']);
        $mydata->addChild('delegation_id',$row['delegation_id']);
    }
	
}else{
	echo 'not found';
}
echo( json_encode ($json));
?>