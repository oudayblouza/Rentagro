<?php
require_once('../connect.php');



$sql = "SELECT * FROM categorie";
$result = $conn->query($sql);
$json = new SimpleXMLElement('<xml/>');
if ($result->num_rows > 0) {
    // output data of each row
    while($row = $result->fetch_assoc()) {
      $mydata = $json->addChild('categorie');
        $mydata->addChild('id',$row['id']);
        $mydata->addChild('nom',$row['nom']);
        $mydata->addChild('imageUrl',$row['imageUrl']);

         }
} else {
    echo "0 results";
}
$conn->close();
	 echo( json_encode ($json));
?>