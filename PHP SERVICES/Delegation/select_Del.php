<?php
require_once('../connect.php');


 $ville=$_GET['ville'];
$sql = "SELECT * FROM Delegation where idville = '$ville'";
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