<?php
require_once('../connect.php');

$nature=$_GET['nature'];
$titre=$_GET['titre'];
$description=$_GET['description'];
$prix=$_GET['prix'];
$validite=$_GET['validite'];
$dateDebut=$_GET['dateDebut'];
$duree=$_GET['duree'];
$numTel=$_GET['numTel'];
$user_id=$_GET['user_id'];
$type_id=$_GET['type_id'];
$etat=$_GET['etat'];
$renttype=$_GET['renttype'];
$latitude=$_GET['latitude'];
$longitude=$_GET['longitude'];
$delegation_id=$_GET['delegation_id'];
$path=$_GET['path'];
$nbrImg=$_GET['nbrImg'];
$sql = "INSERT INTO annonce (nature, titre,description,prix,validite,dateDebut,duree,numTel,etat,renttype,lattitude,longitude,user_id,type_id,delegation_id,imagesdir,nbrimages)
VALUES ( '$nature','$titre','$description','$prix','$validite','$dateDebut','$duree','$numTel','$etat','$renttype','$latitude','$longitude','$user_id','$type_id','$delegation_id','$path','$nbrImg')";

if (mysqli_query($conn, $sql)) {
    echo "success";
} else {
    echo "Error: " . $sql . "<br>" . mysqli_error($conn);
}
?>