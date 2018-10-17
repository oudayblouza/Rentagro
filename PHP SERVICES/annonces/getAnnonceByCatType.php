<?php
require_once('../connect.php');

$category=$_GET['category'];
$nature=$_GET['nature'];

 
$req = "select a.id id,a.longitude longitude,a.lattitude lattitude, a.nature nature, a.etat etat, a.titre titre, a.description description, a.prix prix, a.validite validite, a.dateDebut dateDebut, a.duree duree, a.numTel numTel, a.user_id user_id, a.type_id type_id, a.imagesdir imagesdir, a.nbrimages nbrimages, a.delegation_id delegation_id,a.renttype renttype, t.id typeID, t.categorie_id cat FROM annonce a, type t WHERE a.type_id= t.id AND t.categorie_id='".$category."' AND etat = 1 AND a.nature='".$nature."'" ;
$result = $conn->query($req);
$json = new SimpleXMLElement('<xml/>');
if ($result->num_rows > 0) {
    // output data of each row
    while($row = $result->fetch_assoc()) {
      $mydata = $json->addChild('annonce');
        $mydata->addChild('id',$row['id']);
        $mydata->addChild('nature',$row['nature']);
        $mydata->addChild('etat',$row['etat']);
		$mydata->addChild('titre',$row['titre']);
		$mydata->addChild('description',$row['description']);
		$mydata->addChild('prix',$row['prix']);
		$mydata->addChild('validite',$row['validite']);
		$mydata->addChild('dateDebut',$row['dateDebut']);
        $mydata->addChild('duree',$row['duree']);
        $mydata->addChild('numTel',$row['numTel']);
        $mydata->addChild('user_id',$row['user_id']);
        $mydata->addChild('type_id',$row['type_id']);
        $mydata->addChild('imagesdir',$row['imagesdir']);
        $mydata->addChild('longitude',$row['longitude']);
        $mydata->addChild('lattitude',$row['lattitude']);
        $mydata->addChild('renttype',$row['renttype']);
        $mydata->addChild('nbrimages',$row['nbrimages']);
        $mydata->addChild('delegation_id',$row['delegation_id']);
         }
} else {
    echo "0 results";
}

echo( json_encode ($json));
?>