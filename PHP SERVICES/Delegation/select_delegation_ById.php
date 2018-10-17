<?php
require_once('../connect.php');


$id=$_GET['id'];
$sql = "SELECT * FROM delegation where id='$id'";
$result = $conn->query($sql);
$json = new SimpleXMLElement('<xml/>');
if ($result->num_rows > 0) {
    // output data of each row
    while($row = $result->fetch_assoc()) {
      $mydata = $json->addChild('delegation');
        $mydata->addChild('id',$row['id']);
         $mydata->addChild('ville',$row['idville']);
        $mydata->addChild('nom',$row['nom']);

         }
} else {
    echo "0 results";
}
$conn->close();
	 echo( json_encode ($json));
?>