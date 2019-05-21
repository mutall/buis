<?php
//
//Resolve classes defined in the shared library
include_once "../library/library.php";
//
//Enable erreor reporting for all types; production version
//error_reporting(E_ALL);
//
//Activate error reoprtong in php.ini file; production version
//ini_set('display_error', '1');

//condition is a named equality expression that is used for expressing join 
//conditions. Equality is a binary expression using the equals operator
class condition extends expression {

    public $id;
    //
    //The expressions for which equality is sought
    private $x1;
    private $x2;

    //A condition has 3 basic components: a id for indexing the condition in a 
    //multi-condition join; 2 expressions for which equality is sought
    function __construct($id, $x1, $x2) {
        $this->id = $id;
        $this->x1 = $x1;
        $this->x2 = $x2;
        //
        //The sql string version of a (equality) condition expression required for
        //implementing a join
        $sqlstr = $this->x1 . "=" . $this->x2;
        //
        parent::__construct($sqlstr);
    }

}

//A compound field is a list that is a a mixture of basic and compound fields
//derived from some column
//
//This class models the Sql join. The general expression of a join is:-
//($hook $jointype JOIN $a on $a->$primaryfname = $h1 and $a->$primaryfname = $h2...)
//The $hook may be a simple database table sql or a sub-query or another join
//expression. The hi's are field values of the foreign key fields in the $hook
//expression
class join {

    //Type of the join -- left or inner
    public $join_type;
    //
    //The foreign key table of a join. The id if a join is derived from this 
    //table.
    public $fktable;
    //
    //The id of a join is formulated from the foreign key table that is
    //participating in the join
    public $id;
    //
    //The join conditions as a list of equality expressions
    public $conditions;
    //The relaional distance is used for sorting the joins before they are 
    //converted to strings.
    public $rdistance;

    //A join is a foreign key table expression accompanied by one or more join 
    //conditions expressed as equality expressions. More expressions may be 
    //added to the join to take care of multiple conditions. The join type may 
    //inner or left. The relaional distance is used for sortong the joins
    //before they are converted to strings.
    function __construct($join_type, $fktablexp, $condition, $rdistance) {
        //
        $this->join_type = $join_type;
        $this->fktable = $fktablexp;
        $this->rdistace = $rdistance;
        //
        //The id of a join is formulated from the foreign key table that is
        //participating in the join
        $this->id = $fktablexp->tname;
        //
        //Start a join conditions list using the given expression
        $this->conditions[$condition->id] = $condition;
    }

    //Convert the join to a string. It has the form:-
    //$join_type JOIN $fktablexp on $c1 AND $c2 AND $c3...
    //where $ci is the i'th sql condition expression, e.g., client.zone=zone.zone
    function __toString() {
        //
        //Map the join condition expressions to thier sql string equivalents
        $condition_strs = array_map(function($condition) {
            return (string) $condition;
        }, $this->conditions);
        //
        //And-separate the string conditions
        $condition_str = implode(" AND ", $condition_strs);
        //
        return " $this->join_type JOIN " . $this->fktable->value() . " ON " . $condition_str;
    }

    //Update the joins of the given sql using this one. This proceeds by either 
    //expanding the condition of an existing join, adding a completely 
    //new join, or reporting cyclic errors. If a new join is added, it will be
    //indexed by its foreign key table name.
    function update_sql($sql) {
        //
        //Test if this join's id is already participaing in the given Sql joins
        if (array_key_exists($this->id, $sql->joins)) {
            //
            //It is; test for cyclic loop
            //
            //Get the identified sql join
            $sqljoin = $sql->joins[$this->id];
            //
            //See if any of the conditions of this join exists in the sql joins.
            foreach ($this->conditions as $condition) {
                //
                //Check if this condition exists in the sql join
                if (array_key_exists($condition->id, $sqljoin->conditions)) {
                    //
                    //It does (exist). This is an endless loop. Report it
                    throw new Exception("Cyclic condition. This foreign key " . $condition->id . " is aready in the join " . $sqljoin);
                }
                //
                //Otherwise, add the condition of this join to the sql join
                {
                    $sqljoin->conditions[$condition->id] = $condition;
                }
            }
        }
        //
        //Otherwise, i.e., this join is not partcipating in the current sql joins
        //Add it, using its id as the index
        else {
            $sql->update_joins($this->id, $this);
        }
    }

}

//The SqlClause is constructed from parts that constiutes the clauses of 
//an sql statement. It has the following special features:-
// - It overrrides the initialize_sql_data to prevent the default version
// - It is typically used for formulating an sql by stringing together 
//components from other sql
class sql_clauses extends driver_sql {

    //The critical bits of an sql are the fields and joins; the joins require
    //a reference table, so that if they are empty, then the From clause
    //is formulated from it. The where is optional
    function __construct($dbase, $tname, $fields, $joins, $where = null) {
        //
        $this->fields = $fields;
        $this->joins = $joins;
        $this->tname = $tname;
        $this->where = $where;
        //
        //Initialize the root sql without a statement
        parent::__construct($dbase, null, $fields);
    }

    //You need to override the default data initializer -- otherwise the field
    //will be replaced with those of teh executed sql -- rather than the intedned
    //ones
    function initialize_sql_data() {
        
    }

//sql_clauses
}

//The sql_hint is an sql that comprises of only the identfication and criteria/friendly 
//raw fields of some reference table. It is used to derive the id and criteria fields
//of sql_selector (through concatenation) that is in turn used to extend the sql_edit 
class sql_hint extends driver_sql {

    //
    //The relational distance of this criteria sql is the number of foreign key 
    //fields between some reference table and that of this sql. It is used for
    //formulating inner joins so that neeare joins are done before later
    //ones.
    public $rdistance;

    //The reference table guides the construction of the sql columns and their
    //supporting joins
    function __construct($dbase, $tname, $rdistance) {
        //
        $this->tname = $tname;
        $this->rdistance = $rdistance;
        //
        //Initialize the parent sql
        parent::__construct($dbase);
    }

    //Initialialize both fields and joins of this criteria sql. The process is 
    //driven by criteria columns, i.e., the identification and friendly fields of 
    //the reference table.
    function initialize_sql_data() {//sql_hint
        //
        //Set the reference table from the table's name
        $this->reftable = $this->dbase->get_table($this->tname);
        //
        //Use the criteria columns of the reference table to initialize the sql 
        //data for this extension sql
        array_walk($this->reftable->hint_cols, function($col) {
            //
            $col->initialize_hint_sql($this);
        });
    }

}

//The sql_selector query is used to extend the table sql so that foreign keys can be 
//befriended. It has the following characateristics: 1) it can be (left) joined 
//to the reference table of the Edit sql, 2) It has 3 columns: the primary,
//the criteria and the id columns. To enable (1), therefore, the sql 
//must implement the table interface
class sql_selector extends driver_sql implements table {

    //
    //A selector query must be named, so that it can be used as a subquery
    //in the the more complex queries, eg., sql_edit
    public $name;

    //Use the shared implementations of some of the functions defined in the 
    //table interface
    use table_;

    //
    function __construct($dbase, $tname) {
        //
        $this->tname = $tname;
        //
        //A selector query must be named, so that it can be used as a subquery
        //in the more complex queries, e.g., sql_edit
        $this->name = $tname . "_ext";
        //
        //Initialize the parent sql
        parent::__construct($dbase);
    }

    //Initialize the required 3 fields -- primary, id and criteria -- of 
    //this sql as well as joins needed to support formulation of these fields
    //The expected string version of this sql should be look like:-
    //
    //select $primaryfield as primary, concat($hints) as criteria,  concat($ids) as id from
    //$joins
    //
    //The primary key column is used for supporting record updates, the id 
    //for hreferencing the records and the criteria for driving record selection 
    function initialize_sql_data() {//sql_selector
        //
        //Set the reference table from the table name
        $this->reftable = $this->dbase->get_table($this->tname);
        //
        //SET THE PRIMARY FIELDS
        //
        //Formulate the desired primary key field 
        $primaryfield = $this->reftable->primary_field;
        //
        //Add the primary field to this sql's fields
        $this->fields[driver_field::primary] = new driver_field(driver_field::primary, $primaryfield->xvalue);
        //
        //Get a) raw id and criteria fields and b) required joins from sql IdHint.
        //Assume the relational distance is 0
        $sqlHint = new sql_hint($this->dbase, $this->tname, 0);
        //
        //SET THE HINT FIELDS
        //
        //Concat all the fields of $sql to get a new expression
        $hintvalue = new expression_concat($sqlHint->fields);
        //
        //Create a basic field criteria named criteria
        $hintfield = new driver_field(driver_field::output, $hintvalue);
        //
        //Add the criteria to this sql's fields using the criteria index
        $this->fields[driver_field::output] = $hintfield;
        //
        //SET THE ID FIELDS
        //
        //Filter the id fields from the criteria cases
        $idfields = array_filter($sqlHint->fields, function($idfield) {
            return $idfield->field_is_id($this->dbase);
        });
        //
        //The xvalue expression of the id field is the concatenation of the id 
        //fields of the criteria sql
        $idvalue = new expression_concat($idfields);
        //
        //Create the id field for this sql
        $idfield = new driver_field(driver_field::id, $idvalue);
        //
        //Add it to the sql_selector using the id index
        $this->fields[driver_field::id] = $idfield;
        //
        //SET THE JOINS
        //
        //Set this sql's joins to those of $sqlHint
        $this->joins = $sqlHint->joins;
    }

}


//Define a php version of a database page. This classs enables interaction 
//with all MySql databases installed on the local host with the mutall_ name 
//prefix.
class page_databases extends page {

    //
    //The dbname is set when the user selects a database (as part of the user 
    //interaction) and not during construction of the page. On entry, this
    //shows us the currently selected database
    public $dbname;
    //
    //The database that is logged in (not necessarily the one selected).
    public $dbase;

    //The sql constructed uses administrator credentials (or any others)
    //that allows access to the information schema
    public function __construct(querystring $qstring) {
        //
        //Define the index of this page -- the field name that is used for 
        //constructing the id property of the sql record. The id property
        //is used for hreferencing purposes
        $this->index = "dbname";
        //
        //Unless otherwise specified, the default layout of a database page 
        //is a label
        $this->layout_type = #layout::label;
                //
        //Initialize the parent page
                parent::__construct($qstring);
    }

    //Define the driver sql for databases from first principles, i.e., using the
    //information schema
    function get_driver_using_informationschema() {
        //
        //Compile the mutall sql for retrieving databases
        //
        //Formulate a query statement for selecting all the mutall databases
        //on the local host server
        $stmt = "select "
                //
                //The schema name is used for indexing
                . " schema_name as " . $this->index
                //
                . " from schemata";
        //
        // Create a new database using the login credentials of an administrator
        //that gets primary data from teh information schems
        $information_schema = new dbase(page_login::username, page_login::password, "INFORMATION_SCHEMA");
        //
        //Create an sql object directly from query statement; this will is used
        //to drive the database initialzation process
        $driver = new driver_sql($information_schema, $stmt);
        //
        //Return the driver
        return $driver;
    }

    //Return all the entities of the databases on the server; we use the 
    //administrator's login credentials, so there is nothing to expect from 
    //the client
    function get_entities() {
        //
        //Clear the mutall_data 'serialization' table
        //
        //Open a mutall_data database using the login credentials of an administrator
        //and the mutall database. This means that anyone has unfettered access
        //to the databases. Access to the database contents needs to be controlled
        //after the databases are shown. You say which one you want to log in to.
        $mutall_data = new dbase(page_login::username, page_login::password, page_login::mutall_data);
        //
        //Get the mutall_data database connection
        $mutall_db = $mutall_data->conn;
        //
        //Delete all the records in in mutall_data.serialization
        if (!$mutall_db->query("delete from serialization")) {
            //
            throw new Exception($mutall_db->error);
        }
        //
        $stmt = "select entity, entity.name as tname, dbase.name as dbname"
                . " from entity inner join dbase on entity.dbase=dbase.dbase";
        //
        //
        //Execute the entiy selectioon
        $result = $mutall_db->query($stmt);
        //
        //Test the result
        if (!$result) {
            //
            throw new Exception($mutall_db->error);
        }
        //
        //Fetch all the entities in one go
        $entities = $result->fetchAll();
        //
        return $entities;
    }

    //Define the driver sql for databases using the responsivess optimized 
    //query stored in mutall_data as table 'database'
    function get_driver() {//page_databases
        //
        //Create a new database that uses the mutall database to access
        //the 'dbase' table
        $mutall_dbase = $this->get_mutall_dbase();
        //
        //This is the sql used to drive the databases display from mutall_data.
        //Remember that the index name for page_databases is dbname.
        $mutall_sql = new driver_sql($mutall_dbase, "select `name` as dbname from `dbase`");
        //
        return $mutall_sql;
    }

}

//The page_database class enables interaction between the user and all the tables 
//of a the current database
class page_database extends page {

    //
    public $dbase;
    //
    //The table name that is selected from a list of available entries. This is 
    //set when the user selects a record via some javascript interface
    public $tname;

    //
    //Use the available user login credentials to create a page that supports 
    //interaction with the given database.
    function __construct(querystring $qstring) {
        //
        //Define the index name, i.e., the name of the field in the following 
        //query that is used for supply data to be regarded as the id property 
        //of the dom records to be displayed in a javascript interface.
        $this->index = "tname";
        $this->layout_type = layout::label;
        //
        //Initialize the parent page with no default values. The page constructor
        //will use the querystring to compile the arguments it requires. By 
        //declaring it here, we make avaialbel the page-specific functionality
        //needed to construct this page. Set the default layout of a page of 
        //tables; the user can override this default via the querystring.
        parent::__construct($qstring);
    }

    //Define the required driver for this page from first principles; its 
    //an sql derived using the information schema
    function get_driver_using_informationschema() {
        //
        // Create a new database using the login credentials of an administrator
        $schema_dbase = new dbase(page_login::username, page_login::password, "INFORMATION_SCHEMA");
        //
        //Prepare to set this page's data property -- the one that dictates the
        //data to be displayed
        //
        //tnames: Query for retrieving system table (not view) names in the 
        //current database
        $tnames_sql = "select"
                //    
                //Substitute the table name with tname
                . " table_name as tname, "
                //
                //The dbname corresponds to the table schema    
                . " table_schema as dbname"
                //
                //The data comes from the information schems    
                . " from information_schema.tables"
                //
                //Only system tables are considered -- not views
                . " where table_type='base table'";
        //
        //descendants: Query for retrieving decsendants
        $descendants_sql = "select "
                //   
                //The parent table    
                . " referenced_table_name as tname,"
                //
                //The dbname matches the constrains schema    
                . " constraint_schema as dbname, "
                //
                //Concantenate the descendants with a comma; let them be members
                . " group_concat(table_name separator ', ') as members"
                //
                //Use the referential constraints table in the information schema    
                . " from information_schema.`REFERENTIAL_CONSTRAINTS`"
                //
                //Group by the table name and dbname
                . " group by constraint_schema, referenced_table_name";
        //    
        //final sql: Use left join to combine the table names and their 
        //descendants
        $stmt = "select "
                //
                . " tnames.tname as $this->index, descendants.members"
                //
                . " from ($tnames_sql) as tnames "
                //
                . " left join ($descendants_sql) as descendants"
                //
                . " on tnames.tname=descendants.tname "
                //
                . " and tnames.dbname = descendants.dbname"
                //
                . " where tnames.dbname = '$this->dbname'";
        //
        //The sql data needed for this page is of the direct statement type. This
        //property is needed for driving the database initialization part that
        //builds the serialized version of sql_edit to improve response
        $driver = new driver_sql($schema_dbase, $stmt);
        //
        //Returnnteh responsive sql as the driver
        return $driver;
    }

    //Define the required driver for this page that is optimized for 
    //responsiveness. It used the 'table' and 'database' tables of mutall_data
    function get_driver() {//page_database
        //
        //Create another database that uses the mutall data table to drive this
        //page in order to improve the responsiveness by not deriving sql edit 
        //from first principles
        $mutall_dbase = $this->get_mutall_dbase();
        //
        //Compile an sql that will be more responsive than the previous statement
        //(that works from first principles)
        $responsive_stmt = "select"
                //
                //Remember the index name of a page of tables is tname
                . " entity.`name` as tname, "
                //
                //Show the serialization status; if serialization was erroneeous
                //it will show here
                . " serialization.error as status"
                //
                //Join 'table' and 'database' tables. Consider renaming these to
                //dbase and entity to avoid teh reserved mysql keywords table
                //and database
                . " from (entity inner join dbase on entity.dbase = dbase.dbase)"
                . " left join serialization on serialization.entity=entity.entity"
                //
                //Only tables of the dbname should be returned
                . " where dbase.`name` = '$this->dbname'";

        //This is the sql used to drive the databases display from mutall_data.
        $responsive_sql = new driver_sql($mutall_dbase, $responsive_stmt);
        //
        //Returnnteh responsive sql as the driver
        return $responsive_sql;
    }

    //Serialize the requesteted entity and send back to the client the 
    //confirmation message
    function serialize_entity($entity = null, $tname = null, $counter = null) {//serialize_entity
        //
        //Bind the arguments
        $this->bind_arg('entity', $entity);
        $this->bind_arg('tname', $tname);
        $this->bind_arg('counter', $counter);
        //
        //Open the mutall_data database connection
        $mutall_db = $this->get_mutall_dbase()->conn;
        //
        //Prepare the statements for inserting the sql  records
        //
        //Compile the sql (for inserting a serialization) in terms of its parameters
        $sql = "insert into serialization(entity, sql_edit, sql_selector, error) values(?, ?, ?, ?)";
        //
        //Prepare the sql and verify that it is valid
        if (!($insert_serialization = $mutall_db->prepare($sql))) {

            throw new Exception($mutall_db->error);
        }
        //
        //Define the variables to be bound to the sql parameters
        //
        //Define the binary serialized version of a table's sql_edit with all
        //the table's fields in it. Compare this to the selector version below.
        $sql_edit = null;
        //
        //A selector query is a serialilized version of the sql_edit query with 
        //primary key field only.
        $sql_selector = null;
        //
        //Define a variable for holding error messages if serializing was 
        //not successful
        $error = null;
        //
        //Sql bind the variables to their matching parameters
        if (!$insert_serialization->bind_param("ssss", $entity, $sql_edit, $sql_selector, $error)) {
            //
            throw new Exception($insert_serialization->error);
        }
        //
        //Create a new user database based on the dbname and the user 
        //credentials. We expect this process to be initialed by the adminstrator
        //so, we use his credentials
        $dbase = new dbase(page_login::username, page_login::password, $this->dbname);
        //
        //Only mutall compliant tables are considered
        try {
            //
            //Select all the fields of a table and set the serialized version 
            //of the fully fielded sql_edit
            $sql_edit = serialize(new sql_edit($dbase, $tname, true));
            //
            //Set the serialized version of the partially fielded sql_edit
            //filt for record selection
            $sql_selector = serialize(new sql_edit($dbase, $tname, false));
        } catch (Exception $ex) {
            //
            //Set the error message
            $error = $ex->getMessage();
        } finally {
            //
            //Now execute the bounderd serialization
            $ok = $insert_serialization->execute();
            //
            //Report error if not ok
            if (!$ok) {
                //
                throw new Exception($insert_serialization->error);
            }
        }

        //
        //Compile the nofification message
        $notification = array("tname" => $tname, "dbname" => $this->dbname, "counter" => $counter);
        //
        //Return the notification
        return $notification;
    }

}

//A descendant page is a subpage of page_record in the descendants foreign key 
//section. It extends page_table by providing a parent table and its primary
//key field
class page_descendant extends page_table {

    //
    //Properties that extend page_records are:-
    public $parent_tname;
    public $parent_primarykey;

    //
    //Note how the constructor of a descedamt matches the standard practice
    //with the following features:-
    //  The first argument is the query string array, neded by all pages
    //  The next two arguments define a page of record
    //  The last two extends a page of records into a descendant
    //  All aguments after that have null defaults. That allows us to construct
    //  this page with the query string as the only required agument -- a very 
    //  important fact in ajax calls.
    function __construct(querystring $qstring, $parent_tname = null, $parent_primarykey = null) {
        //
        $qstring->bind_arg('parent_tname', $parent_tname, $this);
        $qstring->bind_arg('parent_primarykey', $parent_primarykey, $this);
        //
        //Call the parent page table constructor
        parent::__construct($qstring);
        //
        //Override the css expression for a descedant record.
        //
        //The dom page of a decendant page is the dom element whose id matches
        //the table name of this page. This function overrides the default one 
        //which associates a js page with teh artiles or entire document node. A js
        //page is a logical representation of the visual dom page
        $this->cssxp = "descendant[id='$this->tname']";
        //
        //Compile the correct variable for resolving methods menntioned in
        //this page
        $this->jsxp = "page_record.descendants.$this->tname";
    }

    //Override the get driver method of the parent page_records by limiting the
    //page_records list toprimary key of the parent record.
    function get_driver() {//page_descendant
        //
        //Get the parent driver; retain it but add the foreign key condition
        $driver = $this->get_sql_edit();
        //
        //Formulate the foreign key condition
        $condition = "`$this->tname`.`$this->parent_tname` = $this->parent_primarykey";
        //
        //Condition the driver statement. Note that this is a straight addition
        //of a condition
        $sql = "$driver->sql WHERE $condition";
        //
        //Formulate the descendant's driver; it is the same as the original
        //one but the statement has been conditioned. Do not derive a new driver -- 
        //otherwise the descendant will not be a true extension of a page of 
        //record and therefre will mot behave like one
        $driver->sql = $sql;
        //
        return $driver;
    }

    //
    //Returns a list comprising of the only primary key value of this page of
    //a descendant, i.e., [$fname=>$value], where $fname is basic foreign key 
    //field name of this descendant that matches that name of the parent table, 
    //and $value is the value of the parent primary key. For the purpose of
    //prefilling a (hidden) foreign key field, the output and input subfields 
    //are not really necessary
    function get_parent_primary_values() {//page_descendant
        //
        //Get the name of the parent table, i.e, the foreign key field name
        $tname = $this->parent_tname;
        //
        //Get the value of the primary key field
        $primarykey = $this->parent_primarykey;
        //
        //Get the BASIC foreign key field name of this record that matcjes tname
        //
        //Get the foreign key field. This page's driver is sql_edit
        $fkfield = $this->driver->fields[$tname];
        //
        //fkfield is comprises of 3 subfields, viz., primary, output and id. Its
        //the primary we want.
        $subfield = $fkfield->subfields->primary;
        //
        //The required BASIC field name is the name of the subfield. It is the
        //name by which values are indexed in a record
        $fname = $subfield->name;
        //
        //Compile the requested values stdClass object
        $values = new stdClass();
        $values->$fname = $primarykey;
        //
        //Return the field values
        return $values;
    }

    //
    //By default, foreign key columns are shown in all pages. However, in a 
    //descendant, it is hident if its name matches the parent table
    function hide_foreign_keyfield(column_foreign $field) {
        //
        return $field->name === $this->parent_tname ? true : false;
    }

    //Display a descendant page as part of a record page and return the name
    //of the descendant pluts its structure.
    function show_descendant() {
        //
        //Open a descendant member
        echo "<descendant";
        //
        //When clicked on, it becomes the current. Note how we access
        //the active descendant for the indexing tname!!
        echo " onclick='page_record.descendants.$this->tname.select_dom_descendant(this)'";
        //
        //When selected, the member property of the page is set to the 
        //member's table name (saved in the id attribute
        echo " id='$this->tname'";
        echo ">";
        //
        echo "<div class='descendant'>$this->tname</div>";
        //
        //Display the descendant page as a normal list of records that 
        //page_records would output
        $this->display_page();
        //
        //Close a descendant member
        echo "</descendant>";
        //
        //Compile the extra data needed to accompany the htmp generated by this
        //function
        $extra = array("tname" => $this->tname, "data" => $this);
        //
        //Returns the extra data
        return $extra;
    }

}

//page_buis enables interaction between the user and other services offer
//my mutall. It extends the login page so that users can login from there; it is 
//an example of a home page
class page_buis extends page_login {

    //
    //Structure for reporting the login status
    public $log_status;
    //
    //Shal we do a partial synchronization (true) or a deep one (false)
    public $psync;

    //
    //Note the way bind_arg works requires that the variable being bound to have
    //a default value of null;otherwise it will override the binding
    function __construct(querystring $qstring, $psync = null) {
        //
        //Bind the partial synchronization variable; in some cases, e.g., during
        //logout, we do not need to synchronize databases; so, the binding can
        //fail.
        $qstring->try_bind_arg('psync', $psync, $this, FILTER_VALIDATE_BOOLEAN);
        //
        //Initialiaze the inherited page. The page_records nknow how
        //to extract the data it requires (from the querystrng)to construct 
        //itsel. If that data is not provided, an exception to that effect is 
        //thrown
        parent::__construct($qstring);
        //
        //Set the log sttaus
        $this->log_status = $this->get_log_status();
    }

    //
    //Bt design, the login page has no driver; it displays what is provided as it
    //is
    function get_driver() {
        //
        return null;
    }

    //Retuens the login status of, i.e., if logged, to which 
    //databse; if  not, invite user to login
    function get_log_status() {
        //
        //Variable for receving the login credentials
        $login = null;
        //
        //Try to get the login credantials
        if ($this->try_login($login)) {
            //
            $status = array('is_login' => true, 'username' => $login['username']);
        }
        //We are not logged in
        else {
            $status = array('is_login' => false, 'username' => "");
        }
        //
        //Return the json encoded status
        return $status;
    }

    //Synchronize the databases in mutall data with those in the information 
    //schema and serialize the tables. By default, we do a partial synchronization. 
    //For a deep synchronization, the working tables are removed first.
    function synchronize() {
        //
        //Create a mutall data database; its the only one from which 
        //synchronization can be started
        $mutall_data = new dbase_mutall_data();
        //
        //If deep synchronization, clear the working databases first
        if (!$this->psync) {
            $mutall_data->clear_synchronization_tables();
        }
        //
        //...then do the synchronization
        $mutall_data->synchronize();
    }

}
