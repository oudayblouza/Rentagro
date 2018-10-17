<?php
require_once('./connect.php');


$id=$_GET['id'];
$path = $_GET["path"];

delete_files($path);
/* 
 * php delete function that deals with directories recursively
 */
function delete_files($path) {
 echo("upload/$path");
    if(is_dir("upload/$path")){
        chmod("upload/$path",0777);
        $files = glob( "upload/$path".'*'); //GLOB_MARK adds a slash to directories returned
       
        foreach( $files as $file )
        {
            chmod($file,0777);
            unlink( $file ); 

         
        }
        rmdir( "upload/$path" );
    } elseif(is_file("upload/$path")) {
        unlink( "upload/$path" );  
    }
}



?>