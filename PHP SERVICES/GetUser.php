<?php
require_once ('connect.php');

$username=$_GET['username'];

$req = "SELECT * FROM users WHERE username='".$username."'";
$result = $conn->query($req);
$json = new SimpleXMLElement('<xml/>');
if ($result->num_rows > 0) {
    // output data of each row
    while($row = $result->fetch_assoc()) {
      $mydata = $json->addChild('user');
      $mydata->addChild('nom',$row['nom']);
    $mydata->addChild('prenom',$row['prenom']);
    $mydata->addChild('numtel',$row['numtel']);
    $mydata->addChild('id',$row['id']);
    $mydata->addChild('username',$row['username']);
    $mydata->addChild('email',$row['email']);
    $mydata->addChild('email_canonical',$row['email_canonical']);
    $mydata->addChild('password',$row['password']);
    $mydata->addChild('roles',$row['roles']);
         }
} else {
    echo "0 results";
}

echo( json_encode ($json));
?>