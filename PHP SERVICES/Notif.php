<?php
$url = "https://fcm.googleapis.com/fcm/send";

    /*$token = "dXrkTx5ZkGY:APA91bEgqvFn-bLCtdSeACmYXhZMFXRXwrn8QC2hXM94sicqcniMIfPfJgl2rPhAZq-dmqpEweAzoZ216-rIZC5RYBvK_DUen564FMUsKH0e4Quq91fuobaikyGJR4ocjpWzqQahNJ4l";*/
    $token = "/topics/news" ; 
    $serverKey = 'AAAAEbh2mRQ:APA91bH5nmE8Fj7UGz-XqmE30Yt5EhWjzsXfy40YjhkWWdj7NfwIW-25s5JXO8LzhOpJQTCQnAgMb1sQW8DUUlla2Wn2ledMoLkLOEtGpvw5M4HR_vRZcd43TNKBmsWgJOvQM41NS0fX';
    $title = $_GET['title'];
    $body = $_GET['body'];
    $notification = array('title' =>$title , 'text' => $body, 'sound' => 'default', 'badge' => '1');
    $arrayToSend = array('to' => $token, 'notification' => $notification,'priority'=>'high');
    $json = json_encode($arrayToSend);
    $headers = array();
    $headers[] = 'Content-Type: application/json';
    $headers[] = 'Authorization: key='. $serverKey;
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST,"POST");
    curl_setopt($ch, CURLOPT_POSTFIELDS, $json);
    curl_setopt($ch, CURLOPT_HTTPHEADER,$headers);
    //Send the request
    curl_exec($ch);
    $tab["result"] = "true" ; 
    $response = json_encode($tab) ; 
    //Close request
    if ($response === FALSE) {
    die('FCM Send Error: ' . curl_error($ch));
    }
    curl_close($ch);
    
    return $response;

?>