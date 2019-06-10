<?php
//The mutall page is special in a number of ways
//1 It is the home page of the Mutall data company (from which all data services
//  offered by Mutall can be accessed
//2 Its PHP, Javascript and HTML implementstions are all contained in the
//  same file. This means 2 things:=
//  a)  The key components of an interative page can be easily demonstrated 
//      using Netbeans navigator panel
//  b)  The page_class and cannot be shared (via include); thats not a good
//      programming practice. There are 2 ways to solve this: 
//      i) pull out the php and js class implementations into standalone files 
//      ii) put the php and js versions into a common shared lirary, buis.php
//  To keep the number of files manageable, we have adopted the 2nd approach
//  to develop this project.    
//
//Start a sesssion and avail the Broad User Interactive System libray including the
//core mutall one
require_once "buis.php";

//
//Prepare to create an instance of this page
//
//Get teh querystring
$querystring = querystring::create(INPUT_GET);
//
//Create an instance of this page; ou can name the variable anyting you wish
//as long as you refer to the same in the execute function below.
$page_buis= new page_buis($querystring);
//
?>
<html>
    <head>
        <title>Buis</title>

        <!-- Style sheet shared by all mutall pages -->
        <link id="mutallcss" rel="stylesheet" type="text/css" href="../library/mutall.css"/>
        
        <meta name="viewport" content="width=device-width, initial-scale=0.9">

        <!-- Style sheet specific to this page -->
        <link id="page_buis_css" rel="stylesheet" type="text/css" href="page_buis.css"/>
    
        <script id='library' src="../library/library.js"></script>
       
        <!-- Script for referencing the prototypes for objects needed for 
        interacting with this page -->
        <script id='mutall' src="buis.js"></script>
        <!--
        <!--Script for defining the objects needed for interacting with this page-->
        <script id='js'>
             //
            //Create a js page_buis object. (Note how echoing a mutall object
            //produces a checked json string)
            var page_buis = new page_buis(<?php echo $page_buis; ?>);
        </script>

    </head>
    <!-- Initialize the page , starting with the login status -->    
    <body onload="page_buis.onload()">

        <!-- The header section -->
        <header>
            <div id="menus">
               <!-- View the available databases. The flexibility of mutall's 
               method comes into play when:-
               (a) we have to prompt the user to login if not yet
               (b) show list of accessible databases after successful login
               This would is the common (not very flexible) way of evoking the databases
               page:-
               <a id='view_databases' href='page_databases.php'>View Databases</a> 
               -->
               <input type="button" value="View Databases" id="view_databases" onclick='page_buis.view_databases()'>

               <!-- Registration -->
               <input type="button" value="Log In" id="login" onclick='page_buis.log(true)'/>
               <input type="button" value="Log Out" hidden='true' id="logout" onclick='page_buis.log(false)'/>

               <!-- Register the user -->
               <input type="button" value="Register New User" id="register" onclick='page_buis.register()'/>

               <!-- Synchronize Databases deeply, i.e, not partially-->
               <input type="button" value="Synchronize Databases" id="synchronize" onclick='page_buis.synchronize(false)'>

           </div>
            <!-- This tag is needed for reporting mutall errors. On clicking
            clear the error--> 
            <p id='error' onclick='this.innerHTML=""'/>
 
        </header>
        
        <!-- The articles section. -->
        <article>
            
            <records>
               
                <record id="seminars">
                    <caption_>
                        Seminar Series
                    </caption_>
                    <tagline>
                      <listitems> 
                       <li>The Anatomy of a Buis Page</li>
                       <li>The Buis Object Data Model</li>
                       <li>Navigating the Buis System</li>
                       <li>Extending Buis to Services</li>
                      </listitems> 

                    </tagline>
                </record>
                <record id="setup_buis">
                    <caption_>
                        -How to Setup BUIS
                    </caption_>
                    <tagline>
                        .Install On Server:-<br/>
                        ..Empty Copy of mutall_data Database<br/>
                        ..Buis Version 2.4<br/>
                        .Install On Client:-<br/>
                        ..Latest Mutall Studio<br/>
                        ..The Metadata Script
                        .Harvest Metadata from Server to mutall_data Database<br/>
                        .Serialize the Databases<br/>
                    </tagline>
                </record>
                
                <record id="bugs">
                    <caption_>
                        Our Bug Tracking Page
                    </caption_>
                    <tagline>
                       
                    </tagline>
                </record>           
            </records>    
        </article>

    </body>

</html>
    