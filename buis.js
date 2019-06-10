
//
//Page buis is a home page it extens the login page 
function page_buis(page_buis_){
    //
    //The mutall pag inherites the login page in order to access
    //the login functionality
    page_login.call(this, page_buis_);
    //
    //After laoing the buis body, set the login status and so a partial database
    //synchronization 
    this.onload = function(){
        //
        //Get the login buttons
        var buttons = this.get_log_buttons();
        //
        //Get the login status from the server
        var status = this.log_status;
        //
        //Set the login credentials, if they are known
        if (status.is_login){
            this.username = status.username;
            this.password = status.password;
        }
        //
        //Set the log in/out buttons
        this.set_log_buttons(status.is_login, buttons, status.username);
        //
        //Do the synchronization
        //
        //Get the type of synchronization, partial or deep from th
        //querystring array
        var psync = typeof this.psync!=="undefined" && this.psync ? true: false;
        //
        //console.log(this);
        //console.log(psync);
        this.synchronize(psync);
    };
    
     //View the available databases; you must login to access the databases
    this.view_databases = function(){
        //
        //Check whether the user needs to login or not. 
        if (!this.user_has_logged_in()){
            //
            //He needs to log in
            //
            //Remember that this page inherits the login page.
            this.log(true);
        }
        // 
        //Wait for the user to complete the log in process
        this.wait(
            //
            //waiting for you to...
            "complete the log in to view the available databases",
            //
            //Define a test that succeeds when the user has logged in
            "user_has_logged_in",
            //
            //Open the databases window after the login
            function(){
                //
                //Open the list of databases window unconditionally, i.e., with
                //an empty query string. On finish update the visited databases 
                //in the windows local storage. Why? What for?
                this.open_window("page_databases.php", {}, function(page_databases){
                    //
                    //Save the dbname index
                    //
                    //Get the index name
                    var name = page_databases.index;
                    //
                    //Get the index value
                    var value = page_databases[name];
                    //
                    //Transfer the index to this page
                    this[name]=value;
                });
            }
        );
    };
    
    //Succeeds if the user has logged in
    this.user_has_logged_in = function(){
        //
        //A user has logged in if the username property is set
        if (typeof this.username==="undefined"){
            return  false;
        }
        //
        //Cannot get the or symbol on my laptop!!!!
        if (this.username===null){
            return  false;
        }
        //
        //Clear the wait message
        this.clear_error_msg();
        //
        return true;
    };

    //Synchronize databases registed in mutall_data with information schema on
    //the server; aditionally, serialize sql_edit for all the tables
    //
    //Serialization helps to keep server specific data to the server,
    //thus reducing the data traffic between it and the client.
    //This has 2 advantatages:-
    //1-It improves reponsiveness and hence the user experience
    //2-It simplifies the way the user requests for services, only
    //having to sepecify the minimimal data. This is useful when 
    //the users need to incorporate pages, derived via Buis, to 
    //their websites
    //3-Following on from 2, it helps to bookmark pages for 
    //revisiting later.
    //Partial synchronization is carried out whenever the buis page is opened
    //froma browesr
    this.synchronize = function(psync){
        //
        //Confirm the synchronization and continue if necessary -- if the 
        //synchronization is not partial.
        if (!psync){
            var yes = window.confirm(
               "Do you want to DELETE synchronization tables and re-synchronize mutall_data with the information_schema?"
            );
            if (!yes) return;
        }
        //
        //Use the ajax method to evoke x.synchronization() where x is an object
        //of class dbase_mutall_data. The method returns a (json derived) object 
        //with the following properties:-
        //a) status: to tell us if the process was successfull and if 
        //not what went wrong
        //(b) html: is a description of the error if the status was not ok
        //
        //Set the partial synchronization to the incoming value. Consider using 
        //formdata.append method
        var qstring = {
            psync:psync
        };
        //
        //Show synchronization in progress; do not wait
        this.show_error_msg("Synchronizing...", false);
        //
        //This call assumes, thus passing all her data to the server
        this.ajax("synchronize", qstring, "json", function(result){
            //
            switch (result.status){
                case "ok":
                    //
                    //Reooiro ok. Do not wait to the user to ok
                    this.show_error_msg("Synchronization successful", false);
                    break;
                case "error":
                    //
                    //Show the error from html property.
                    this.show_error_msg(result.html);
                    break
                default:
                   this.show_error_msg("Unknown ajax result status '"+result.status+"'"); 
            }
        }, "page_buis");
    };
    
    
}      

//Define the js version of a database page
function page_databases(page_databases_) {
    //
    page.call(this, page_databases_);
    //
    //View the tables of the current (selected) database; if none is selected 
    //then wait for the user to do so; then view the related tables.
    this.view_tables = function (){
        //
        //Wait for the user to select a database and only proceed on success
        this.wait(
            //
            //Show this error message to prompt the user to select a database
            "select a database", 
            //
            //This is the function to test if a bname has been selected on this 
            //page
            "dbname_is_selected",
            //
            //Open the tables window based the on current on database 
            //selection. If the table page is closed properly successful, 
            //we need to save save the tabl'e index to this page and to
            //the windows local storage
            function(){
                //
                //On;y the dbname component is required for opening a list
                //of tables
                var requirements = {
                    dbname: this.dbname
                };
                //
                //Open the tables page with dbase as the only parameter, then  
                //update the property 'tname' on finish
                this.open_window("page_database.php", requirements, function(page_database){
                    //
                    //Save the dbname index
                    //
                    //Get the index name
                    var name = page_database.index;
                    //
                    //Get the index value
                    var value = page_database[name];
                    //
                    //Do the saving to teh local windows storage
                    this[name]=value;
                });
            }
        );
    };

    
    //Returns true if a dbname is selected; otherwise its false.
    this.dbname_is_selected = function(){
        //
        //Get this pages index
        var index = this.index;
        //
        //Use the index name to define condition for a selected record 
        var selected = this[index]!=="undefined" && this[index]!==null;
        //
        return  selected ? true: false;
    };
}

//This class is the visual representation of a database. Its key characteristic
//is teh list of tables in the database
function page_database(page_database_){
    //
    //Initialize the page with no specific onload id for the tname
    //index
    page.call(this, page_database_);
    //
    //Set the table name; this function is called by page.view_records
    //to signal the end of a wait to select a table whose records we want
    //to view.
    this.set_table_name = function(){
        //
        //Try to get the current dom record; this fails quietly if 
        //none is selected
        var dr = this.try_current_dom_record();
        //
        //If a record selection is found, then set this page's table name 
        //and return true
        if (dr){
            //
            //Set this tname by transferring it from dom to this page
            this.tname = dr.view.getAttribute('id');
            //
            //Return the true status
            return true;
        }
        //
        //Otherwise return false, i.e., when no dom recrod is selected
        return false;
    };
    
    //Create a new record from the selected table
    this.create_record = function(){
        //
        //For next version, you may want to wait until the user selects a table
        //This is not necessary in page_table::create_record() version.
        if (typeof this.tname === "undefined"){
            alert('Please select a table');
            return;
        };
        //
        //Collect the parameters needed by page_record
        var qstring = {
            //
            //The table name as selected by the user. You get a runtime error
            //if you have not selected one. (And selecting one sets the tname 
            //propety
            tname: this.tname,
            //
            //The underlying database 
            dbname: this.dbname,
            //
            //Use the label layout. By default layou=false, mplying tabular
            //layout
            layout_type:'label'
        };
        //
        //Request the server to show the records with default styling.
        //Don't bother with the returned results.The php file is found
        //in the library
        this.open_window("../library/page_record.php", qstring);   
    };

}



 