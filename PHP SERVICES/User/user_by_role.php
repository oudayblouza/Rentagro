<?php
require_once('../connect.php');

$role=$_GET['role'];

$sql="select * from users where roles='$role' ";
$result = $conn->query($sql);

$json = new SimpleXMLElement('<xml/>');
if ($result->num_rows > 0) {

    while($row = $result->fetch_assoc()) {
        $mydata = $json->addChild('users');
        $mydata->addChild('id',$row['id']);
        $mydata->addChild('username',$row['username']);
        $mydata->addChild('email',$row['email']);  
        $mydata->addChild('delegation_id',$row['delegation_id']);
        $mydata->addChild('prenom',$row['prenom']);
        $mydata->addChild('longitude',$row['longitude']);
        $mydata->addChild('latitude',$row['latitude']);
        $mydata->addChild('numtel',$row['numtel']);
        $mydata->addChild('rate',$row['rate']);
        $mydata->addChild('voters',$row['voters']);
    }
	
}else{
	echo 'not found';
}
echo( json_encode ($json));
?>