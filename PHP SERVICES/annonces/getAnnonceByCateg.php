<?php
require_once ('../connect.php');

$id=$_GET['id'];

$req = "SELECT * FROM annonce ,type
WHERE  annonce.type_id =type.id AND type.categorie_id='$id'; ";
$result = $conn->query($req);
$json = new SimpleXMLElement('<xml/>');
if ($result->num_rows > 0) {
    // output data of each row
    while($row = $result->fetch_assoc()) {
      $mydata = $json->addChild('annonce');
        $mydata->addChild('id',$row['id']);
        $mydata->addChild('nature',$row['nature']);
		$mydata->addChild('titre',$row['titre']);
		$mydata->addChild('description',$row['description']);
		$mydata->addChild('prix',$row['prix']);
		$mydata->addChild('validite',$row['validite']);
		$mydata->addChild('dateDebut',$row['dateDebut']);
        $mydata->addChild('duree',$row['duree']);
        $mydata->addChild('numTel',$row['numTel']);
        $mydata->addChild('etat',$row['etat']);
        $mydata->addChild('renttype',$row['renttype']);
        $mydata->addChild('user_id',$row['user_id']);
        $mydata->addChild('type_id',$row['type_id']);
        $mydata->addChild('longitude',$row['longitude']);
        $mydata->addChild('latitude',$row['latitude']);
        $mydata->addChild('delegation_id',$row['delegation_id']);
        $mydata->addChild('path',$row['path']);
        $mydata->addChild('nbrImg',$row['nbrImg']);
         }
} else {
    echo "0 results";
}

echo( json_encode ($json));
?>