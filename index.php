<?php
//
//Buis version 2.4:-
//1 The issues of poor response associated mostly with a complex page. This is 
//  addressed by:-
//  1.1 Caching of sql_edit for each table in a serialized version
//  1.2 Creating edit and select views of each table?????
//2 Hamonising the PHP/Jaavasript interface to allow building of complex 
//  pages that will drive the mutall website  
//
//The Index is not a normal mutall page in the sense that the user does not 
//interact with it. It simply directs re-directs to the last available mutall 
//page if any; otherwise it re-calls the mutall page. It is the default page
//of the website
//
//Include the Core Mutall  library
require_once '../library/mutall.php';
//
//Create a mutall object with empty parameters.
$mutall = new mutall();
//
//Check if there is any page that was saved to a session variable. 
//(See save_to_session method for details). If there is then
//use it to get started; otherwise go to the mutall services page.
if (isset($_SESSION['querystring'])){
    //
    //Get the last page's complete querystring
    $qstring = $_SESSION['querystring'];
    //
    //Re-route to the requested file; thhis is not how it is done!!!
    //
    //Get the served file name
    //
    //Convert the querystring to s atandard string
    //
    //Compile the complete url
    //
    //Reoute to the url
    header("Location:$url");
    
}
else{
    //No previous sesson was found; show the Buis home page with partial 
    //synchronization.
    header("location:page_buis.php?psync=true");   
}
