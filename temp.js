var array = [{'name': 'foo', 'value': '2'},
             {'name': 'foo', 'value': '2,8'},
             {'name': 'foo', 'value': '2,10,3'}
            ];

var parts = [];

for ( var i = 0; i < array.length; ++i )
  parts.push(encodeURIComponent(array[i].name) + '=' + 
             encodeURIComponent(array[i].value));

var url = parts.join('&');

console.log(url);




//Copy the data values from the current dom reord to a js version
        //
        //Get the data object that is driving this page; we assume that it is 
        //a writable object, i.e., a record an sql -- so it as fields. 
        var writable = this.driver;
        //
        //Create a new record based on the writable's fields and table
        //name. You will use it to request the server to save the data. The 
        //values argument of the record is left out; it will be filled in in the 
        //steps that ahead.
        var myrecord = new driver_record(writable.fields, writable.dbase, writable.tname, writable.reftable, writable.stmt);
      