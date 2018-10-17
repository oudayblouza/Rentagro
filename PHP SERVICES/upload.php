<?PHP

if(isset($_POST['image'])){
    $image = $_POST['image'];

    upload($_POST['image']);
    exit;
}
else{
    echo "image_not_in";
    exit;
}
function upload($image){
    $directory =$_GET['directory'];
    if(!is_dir("upload/$directory")){
        //Directory does not exist, so lets create it.
        mkdir("upload/$directory",0777,true);
        chmod("upload/$directory",0777);
    }
    $i=$_GET['i'];
    $upload_folder = "upload/$directory";
    $path = "$upload_folder/$i.jpeg";
    
    //Cannot use "== true"
    if(file_put_contents($path, base64_decode($image)) != false){
        echo "uploaded_success";
    }
    else{
        echo "uploaded_failed";
    }    
}

?>