//A descendant is a special page of the page_record. It inherits 
//properties from the page_records; thst is why it shares the same js file as
//the page_records. 
//A descendant page has no phsical file equivalent
function page_descendant(input_){
    //
    //
    //Call the parent page_records (which is also defined in in this same file)
    page_records.call(this, input_);
    //
    //Let x be the querystring of the parent; I will ovrride it in the the
    //implementation of this version's querystring
    this.x = this.get_querystring;
    
    //Returns a query string for supporting CRUD operations on ercros of this 
    //page. This extends the page records version by adding a parent table name an dforeign key properties to the
    //parents querysring
    this.get_querystring = function(dom_record=null){//page_descendant
        //
        //Get the querystring of the parent page of records; x is the parent
        //query string before overring it.
        var qstring = this.x(dom_record);
        //
        //Add the parent table ame
        qstring.parent_tname = this.parent_tname;
        qstring.parent_primarykey = this.parent_primarykey;
        //
        //Return the richer query string
        return qstring;
    };    
    
}

//Representation of a login page class in JS. The justification of this page as 
//a standaone file is the fact that it is referenced in more than one place, e.g.,
//in page_login as well as in page_buis
function page_login(input_) {
    //        
    //Login data is laid out in a label format. Initialize the page system.
    page.call(this, input_);
    
    //Save the login data by copying it from the dom record to the js 
    //record (structure) and saving it in the windows object ready for the 
    //caller to pick it up from there
    this.ok = function(){
        //
        //Get the record tagname of this page's layout
        var rec_tagname= this.layout.record_tag_name;
        //
        //Get the dom record view using the correct tag name. (For tabular layout
        //the tag name is "tr"; for labels, it is "field")
        var dom_record_view = window.document.querySelector(rec_tagname);
        //
        //Create a dom record from this view and page; this process also 
        //transfers the values from the view to the record's values
        var $dom_record = new dom_record(dom_record_view, this);
        //
        //Compile the querystring from the dom_record values; it comprises of 
        //the user name and password
        var qstring = {
            username: $dom_record.values.username,
            password: $dom_record.values.password
        };
        //
        //Request the server to check the login credentials against registered
        //clients. If registerd, return the clientid; if report user not found
        this.ajax("check_login", qstring, "json", function(result){
            //
            //Pass on the populated record to the caller js function if login 
            //credentials were succesfully saved to the server
            if (result.status==="ok"){
                //
                //The login proceeded without any errors. Now investigate the 
                //result by looking at the extra data
                var user = result.extra;
                //
                if (user.found){
                    //
                    //Compile the data to retirn to the window
                    //
                    var data = {
                        username:qstring.username,
                        clientid:user.clientid
                    }
                    //Close this window properly; this means saving the compiled
                    //querystring data to the windows object first, then closing it. 
                    //That way, caller will have access to the data in the query 
                    //string. When the window is improperly closed, the querystring
                    //data is not saved, so that the caller cannot access it.
                    this.close_window(data);
                }
                //
                else{
                    this.show_error_msg("User is not found");
                }
            }
            //...otherwise show the error message. The page remains open
            else{
                this.show_error_msg(result);
            }
        });
      };
      
    //Logout simply destroys the session variables
    this.logout = function(){
        //
        //Request for logout function; no data needs to besent to the server to 
        //logout
        this.ajax("logout", {}, "json", function(result){
            //
              if (result.extra==="ok"){
                //
                //Close the window. This is the event that signals to the caller 
                //that we are done with login
                window.close();
            }
            //...otherwise show the error message
            else{
                this.show_error_msg(result);
            }
        });
    };
    
    //The login page needs no initialization
    this.onload = function(){};
    
    //Log into or out of the mutall database system and show the status on the 
    //appropriate buttons of this page. This allows access to all databases by
    //mutall_data staff
    this.log = function(is_login){
        //
        //Get the log in/out buttons
        var buttons = this.get_log_buttons();
        //
        //Do either login or logout
        if (is_login){
            this.login(buttons);
        }
        //
        else{
            this.logout(buttons);
        }

    };
    
    //Log into the mutall system to to prevent access to mutall databases
    //to unauthorised uers
    this.login = function(buttons){
        //
        //Define the dimension specs of the login window in pixels
        var specs = "top=100, left=100, height=400, width=600";
        //
        //Open the login page with no requirements. If the login was /successful,
        //we expect the data to be written to a session variable and an object 
        //with the login credentials is returned to allow us update the login 
        //status
        this.open_window("page_login.php", {}, function(login){
            //
            //
            //Show the login status
            this.set_log_buttons(true, buttons, login.username);
            //
            //Update this page's username and registration id, i.e, the primary
            //key value of the mutall_data clients's entry        .
            this.username = login.username;
            //
            //The userid is used for supporting transactions, e.g., the case of
            //showing interest on real estate
            this.clientid = login.clientid;
            
        },specs);
    };
   
   //Get the log in/out buttons on the current page
    this.get_log_buttons = function(){
        //
        //Get the login button; 
        var login = window.document.getElementById("login");
        //
        //It must be found!.
        if (login===null){
            alert("Log in button not found on page "+ this.name);
        }
        //
        //Get the logout button
        var logout = window.document.getElementById("logout");
        //
        //It must be found!.
        if (logout===null){
            alert("Log out button not found on page "+ this.name);
        }
        //
        //Define and set the buttons structure
        var buttons = {
            login: login,
            logout:logout
        };
        //
        //Return the buttons
        return buttons;
    };
    
    //Register a new user
    this.register = function(){
        //
        //Open the client registration window
        //
        //The file to open is in teh services folder, shich is a simbling
        //of the current one:-
        var filename = "../services/registration.php";
        //
        //The server needs the following info:-
        querystring = {
            //
            //The database to regfer to
            dbname:"mutallco_data",
            //
            //The table to open
            tname:"client",
            //
            //A criteria that retuens no data when teh page is viewed
            criteria:false
        };
        //
        //Now open the requested window and use the user data to log in
        //the the new user
        this.open_window(filename, querystring, function(user){
            //
            //Sow the username of teh logged in user
            alert(user.username);
        });
        
    };
    
    //Set the log in/out buttons, depending on the login status
    this.set_log_buttons = function(is_login, buttons, username){
      //
      ///Show the log in status
      if (is_login){
        //
        //Hide the login button
        buttons.login.setAttribute("hidden", true);
        //
        //Show the logout button with username
        buttons.logout.removeAttribute("hidden");
        //
        //Attach the user name to the logout butom
        buttons.logout.value = "Logout " + username;  
      }
      //
      //Show the log out status
      else{
         //Show the login button
        buttons.login.removeAttribute("hidden");
        //
        //Hide the logout button
        buttons.logout.setAttribute("hidden", true); 
      }
    };
    
    
    //Log out of a mutall system; this :-h
    //-destroys the session variables 
    //-resets the username and clientid properties of this page
    //-updates the login status
    this.logout = function(buttons){
        //
        //Request for logout function from the server; the querystring is empty
        this.ajax("logout", {}, "json", function(result){
            //
            //Save the record if login credentials are ok...
            if (result.status==="ok"){
                //
                //Clear the username and clietid properties
                this.username=null;
                this.clientid=null;
                //
                //Set the status
                this.set_log_buttons(false, buttons);
            }
            //
            //...otherwise show the error message
            else{
                this.show_error_msg(result);
            }
        });
    };
    
    
}

//
//Page buis is a home page it extens the login page 
function page_buis(page_buis_){
    //
    //The mutall pag inherites the login page in order to access
    //the login functionality
    page_login.call(this, page_buis_);
    //
    this.onload = function(){
        //
        //Get the login buttons
        var buttons = this.get_log_buttons();
        //
        //Get the login status from teh server
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
        //Show synchronization in progress
        this.show_error_msg("Synchronizing...");
        //
        //This call assumes, thus passing all her data to the server
        this.ajax("synchronize", qstring, "json", function(result){
            //
            switch (result.status){
                case "ok":
                    //
                    //Reooiro ok
                    this.show_error_msg("Synchronization successful");
                    break;
                case "error":
                    //
                    //Show the error from html property
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

}

//The javascript "class" that models the functionality of a
//page of a single record. The input_ is non-object data passed
//on from the php environment and used to compile the page
function page_record(input_) {
    //
    //Set the db and table names from the input
    this.dbname=input_.dbname;
    this.tname = input_.tname;
    //
    //Call the parent page_table class
    page_table.call(this, input_);
    //
    //Let x be the page activation class, before it is modified. Why do we
    //need to override it? This does not look correct?? See the reason for
    //overriding below.
    var x = this.activate_class;

    //Override the activate class defined in the grand parent 
    //mutall so that this record_page can activate the descendants
    //This is important because, to be useful in the js environment, 
    //and noting that a descendant is constructed in the php environmet, 
    //we need to activate it. We aim to achieve this without 
    //modifying the base page class by overriding the activate 
    //class method
    this.activate_class=function(classname, input){//page_record
        //
        //The targeted class name to be treated specially is 
        //descendant. Put this activation code in its proper class!!!
        if (classname==="page_descendant"){
            return new page_descendant(input);
        }
        //
        //Call original version of the activate class
        var aclass = x.call(this, classname, input);
        //
        //Return the active result
        return aclass;
    };
    //
    //Activate the descendants
    this.descendants = this.activate(input_.descendants);
    
    //
    //Edit the current field of the current record of the current
    //descendant. Note the repetition of the word "current"
    this.edit_field = function(df=null){//page_record
        //
        //Get the current dom field
        if (df===null){
            df = this.get_current_dom_field();
        }
        //
        //Check if the dom field has the dom descendant ancestor
        var dom_descendant = df.closest("descendant");
        //
        //This is not a descendant; use the parent's edit field 
        //method
        if (dom_descendant===null){
            //
            //Invoke the receord_page parent's edit function 
            var p = new page();
            //
            //Call the normal page edit field using the context
            //of the record page
            p.edit_field.call(page_record, df);
        }
        //This is a descendant
        else{
            //Retrieve the table name
            var tname = dom_descendant.getAttribute("id");
            //
            //Use the globally available record page variable to 
            //access the required descendant
            var js_descendant = page_record.descendants[tname];
            //
            //Use this descendant to guide the editing
            js_descendant.edit_field(df);
        
        };
      
    };
    
    //Change a field on this page; the name id in reference input element
    this.page_change_field = function(ref){//page
        //
        var fname = ref.name;
        //
        var field = this.driver.fields[fname];
        //
        field.change_field(ref, this);
    };
    
    //Quality control the input values and save them to the database
    this.save_current_record = function () {//page_record
        //
        //Ccollect the values to save
        var values = this.collect_values();
        //
        //Do not continue if they fail the quality control check
        if (!this.qc(values))
            return;
        //
        //By default the input values should be inserted, rather than updated
        var update = typeof this.update==="undefined" ? false : this.update;
        //
        var qstring = {
            //
            //Identify the database and table name to save record to
            dbname: this.dbname,
            tname: this.tname,
            update:update,
            //  
            //Remember to json encode the name/value pairs
            values: JSON.stringify(values)
        };
        //
        //Add a primary key if this is an existing record
        if (typeof this.primarykey !== "undefined" && this.primarykey !== null) {
            qstring.primarykey = this.primarykey;
        }
        //
        //Use the ajax method to save the values
        this.ajax("save_values", qstring, "json", function (result) {
            //
            switch (result.status) {
                case "ok":
                    //
                    //Refresh the page
                    window.location.reload();
                    //
                    //Invite the user to perform furter actiions after after a 
                    //successful saving of a record.
                    this.after_save(values); 
                    break;
                case "error":
                    //
                    //Show the error from html property
                    this.show_error_msg(result.html);
                    break
                default:
                    this.show_error_msg("Unknown ajax result status '" + result.status + "'");
            }
        });

    };
    
    //What do do after a successful saving of a record. By default, we do
    //nothing
    this.after_save = function(values){
        //
    }
    //
    //Collect all the values to save
    this.collect_values = function(){
      
        var values={};
        //
        //Let 'fields' be all the fields of the current driver
        var fields = this.driver.fields;
        //
        //Loop through the fields structure
        for(var i in fields){
            //
            //This assignmment should be conditial on field value not being 
            //empty. Be careful what you mean by being empty baseuse zero
            //lenth string is not a ull
            if (fields[i].value!==null || fields[i].value!==''){
                values[i]=fields[i].value;
            }
        }
        //
        return values;
    };
    
    //The default quclity control (qc) check does nothing
    this.qc = function(values){
        return true;
    };
    
    //
    //Let x be the querystring of the parent; I will ovrride it in the the
    //implementation of this version's querystring
    this.old_get_querystring = this.get_querystring;
    
    //Returns a query string for supporting CRUD operations on this 
    //page. This extends the page records version by adding a primary key of
    //the table
    this.get_querystring = function(dom_record=null){//page_descendant
        //
        //Get the querystring of the parent page of records; x is the parent
        //query string before overring it.
        var qstring = this.old_get_querystring(dom_record);
        //
        //Add the primary key of this record
        qstring.primarykey = this.primarykey;
        //
        //Return the richer query string
        return qstring;
    };    
    

    //Override the default page initialize function by including code that 
    //populates the descendants of this page record with data
    this.onload = function(){//show_descendant
        //
        //Get the descendants node by searching from the entire document
        var des_node = window.document.querySelector("descendants");
        //
        //Step through every descendant and paint its page in this window
        for(var tname in this.descendants){
            //
            //Set the data required to show descendant
            var qstring = {
                //
                //Set the descendant's table name; it is the extra data 
                //required over and above that of this parent record
                tname:tname,
                //
                //Set the name of the underlying database; all teh following data
                //comes from this page_record
                dbname:this.dbname,
                //
                //Set the name of the parent table name
                parent_tname:this.tname,
                //
                //Set the primary key of the parent table
                parent_primarykey:this.primarykey
            };
            
            //
            //Create the descendant page and display it. Ajax is used because we
            //want 2 outputs, viz., (1) the html for dislaying the page and (2) 
            //the js data structure for enriching this page in order to support 
            //further interactions. Note how we override the current classname
            this.ajax("show_descendant", qstring, "json", function(result){
                //
                //Save the descendant data to its correct place. NOTE THAT THIS
                //IS AN ASYNCHRONOUS OPERATION, SO THE tname ABOVE MAY NOT BE 
                //NECESSARILY THE ONE WE WANT FOR THIS FUNCTION. Hence put it in
                //the result. Remember to activate it
                this.descendants[result.extra.tname] = this.activate(result.extra.data);
                //
                //Add the html to the children of descendants node
                //
                //Create a dummy element; you can call it anything bacsuse we 
                //will overwrite it using the outerHTML property below
                var a = window.document.createElement("descendant");
                //
                //Attach the page to the descendant node in preparation for 
                //changing ints out html (which you canot do if a has no parent)
                des_node.appendChild(a);
                //
                //Now set the outer html of the page to that of the incoming 
                //result; see previous comment on outerHTML
                a.outerHTML = result.html;
            }, "page_descendant");
        }
    };

    //
    //On clicking some field on this page, execute the requested method. This 
    //operation determines if the clicking was done on a parent record object 
    //or on one of her descendants. 
    this.onclick_field = function(method){
        //
        //Let page be the object for which we need to execute the method. By 
        //defaut, no page is selected
        var page=false;
        //
        //Get the current dom field by searching the entire document for the 
        //element with class field because by design, there should be only one 
        //such element in a page.
        var df = this.try_current_dom_field();
        //
        if (!df){
            //
            //There is no dom record found. It may be that 
            //- no record is actually selected
            //- a dependant is selectec but not any of its records; perhaps it 
            //  has none. Determine if it is the latter case.
           page = this.try_current_js_descendant();
        }
        else{
            //
            //Dermine if the selected dom record is a page record or one of her 
            //descendants
            //
            //Check if the dom field has a dom descendant ancestor
            var dom_descendant = df.closest("descendant");
            //
            if (dom_descendant===null){
                //
                //This is not a descendant, so we assume that the dom record is on 
                //this page that is associated with the global variable, page_rcord,
                //
                //Invoke the page_record' with the rwquested function 
                page = page_record;
            }
            //This is a descendant; perform the action on a descendant
            //page. Which one?
            else{
                page = this.try_current_js_descendant();
            }
        }
        //
        //If the page is valid, execute the requested method on teh correct 
        //object
        if (page){
            //
            page[method]();
        }
    };


    //Returns the current dom descendant of this page based on the "current" 
    //attribute. An alert is provided if there is no current selection
    this.get_current_dom_descendant = function (){
        //
        //Try to get the current dom descendant
        var dd = this.try_current_dom_descendant();
        //
        if (!dd){
            alert ("There is no current descendant selection");
            return false;
        }
        //
        //Return the dom descendant
        return dd;
    };

    //Returns the current dom descendant of this page based on the "current" 
    //attribute. No alert is provided if there is no current selection.
    this.try_current_dom_descendant = function (){
        //
        //Formulate the css selector for the current descendant
        var dselector = "[current='descendant']";
        //
        //Retrieve the current dom descendant, searching from the entire 
        //document.
        var dd = window.document.querySelector(dselector);
        //
        if (dd ===null)
        {
            return false;
        }
        //
        //Return the descendant
        return dd;
    };



    //Returns the current js descendant, alerting the user if there
    //is none. Related to this is the get current dom descendant
    //and the php page_descendant
    this.get_current_js_descendant = function (){
        //
        //Try to get the current js descendant
        var jd = this.try_current_js_descendant();
        //
        if (!jd){
            alert ("There is no current descendant selection");
            return false;
        }
        //
        //Return the dom descendant
        return jd;
    };

     //Returns the current js descendant of this page based on the "current" 
    //attribute. No alert is provided if there is no current selection.
    this.try_current_js_descendant = function (){
        //
        //Formulate the css selector for the current descendant
        var dd = this.try_current_dom_descendant();
        //
        if (!dd)
        {
            return false;
        }
        //
        //Retrieve the js decsendant from the dom version
        //
        //Get the descendant's table name
        var tname = dd.getAttribute('id');
        //
        //Rerieve the descendant indexd by the table name
        var jd = this.descendants[tname];
        //
        //Retur the js descendant
        return jd;
    };
    
    
}



 