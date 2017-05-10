
///////////////////////////////////////////////////////////
// logic to execute SQL queries and render CRUD pages
///////////////////////////////////////////////////////////

var _ = require("lodash");
var db = require('../db');
var taquery = require('../db/query');
var utils = require('../utils');

// print sql queries to console
var log_query_strings = true;

// DEVNOTE:
// I created these two functions (dbname, connect) so that we could allow
// a dynamic database pointer. For example, the URL would be able to take the
// database name as a parameter (eg, /db/:db/tables == /tables, where the latter
// would use a default database specified somewhere in code). While this would
// be useful for development purposes (eg, another team could work with one
// database, while I develop on another). But the problem was that this required
// creating a new database connection with each page load, which would not scale
// well. So I kept the logical infrastructure, but removed the dynamic aspect
// from it.
// (start) database connection setup
  function dbname(req,default_db){
    if (req.params.db) var dbname = req.params.db;
    else var dbname = default_db;
    return dbname;
  }

  function connect(req){
  //  var database = dbname(req,db.default_db);
  //  return db.postgres(database);
    return db.postgres;
  }
// (end) database connection setup

// if no path entered (after base url), redirect to tables page-data
exports.defaultpath = function(req, res){
  res.redirect('./tables');
}

// query list of tables in schema and render page with links
exports.navtables = function(req, res){
  var postgres = connect(req);

  // execute 'get tables' query (after generating query string)
  var query = postgres.db.any(
    taquery.getTablesQueryString(
      schema = postgres.config.schema,
      debug = log_query_strings
    )
  )
    .then(tables => {
      var headers = utils.getObjKeys(tables[0],["table_name"]);
      res.render(
        'entities/actions/tables',
        {
          tables: tables,
          headers: headers,
          dbconfig: postgres.config,
          page_name: "Table list"
        }
      );
    })
    .catch(err => {
      console.log("Error inserting : %s ",err );
    })
  ;
}


// this renders the READ page for a specific table in our cRud webapp.
exports.list = function(req, res){
  var postgres = connect(req);

  // grab the table name from the request
  var table_name = req.params.table;

  // replace variable placeholders with actual values
  var query_string = taquery.getDataQueryString(
      schema = postgres.config.schema,
      table = table_name,
      debug = log_query_strings
  );

  // create query string to get an array of field info for the specified table
  var get_columns_query_string = taquery.getColumnsQueryString(
    schema = postgres.config.schema,
    table = table_name,
    debug = log_query_strings
  );

  postgres.db.tx(t => {
      return t.batch([
          t.any(get_columns_query_string),
          t.any(query_string)
      ]);
  })
    .then(data => {
        var cols = data[0];
        var rows = data[1];
        //console.log(cols);

        // if create/end datetime columns exist, then sort data by them
        if (cols.filter(function(e){
          return e.column_name == 'end_datetime'
        }).length > 0) {
          if (cols.filter(function(e){
            return e.column_name == 'create_datetime'
          }).length > 0) {
            rows.sort(utils.dynamicSort("end_datetime", "create_datetime"));
          }
        }

        // does create function exist?
        var create_enabled = false;
        if (cols.filter(function(e){
          return e.create_param_index != null
        }).length > 0) {
          create_enabled = true;
        }

        // does update function exist?
        var update_enabled = false;
        if (cols.filter(function(e){
          return e.update_param_index != null
        }).length > 0) {
          update_enabled = true;
        }

        // does delete function exist?
        var delete_enabled = false;
        if (cols.filter(function(e){
          return e.delete_param_index != null
        }).length > 0) {
          delete_enabled = true;
        }

        // apply field properties based on column name
        // (eg, inferring dependencies, etc)
        cols.map(function(e){
          var obj = e;
          obj.props = utils.columnNameProperties(obj.column_name);
          return obj;
        })

        console.log(cols);

        res.render(
            'entities/actions/read',
            {
              page_name: table_name,
              table_name: table_name,
              data: rows,
              fields: cols,
              create_enabled: create_enabled,
              update_enabled: update_enabled,
              delete_enabled: delete_enabled,
              dbconfig: postgres.config
            }
        );
    })
    .catch(error => {
      console.log("Error Selecting : %s ", error);
    })
  ;
};

// this renders the UPDATE page for a specific table in our crUd webapp.
// [not yet in place]
exports.edit = function(req, res){
    var id = req.params.id;
    req.getConnection(function(err,connection){
        var query = connection.query('SELECT * FROM customer WHERE id = ?',[id],function(err,rows)
        {
            if(err)
                console.log("Error Selecting : %s ",err );
            res.render('edit_customer',{page_title:"Edit Customers - Node.js",data:rows});
         });
    });
};


// this renders the CREATE page for a specific table in our Crud webapp.
exports.add = function(req, res){
  var postgres = connect(req);

  var table_name = req.params.table;

  // create query string to get an array of field info for the specified table
  // and then execute the query to save the data to the database
  var query = postgres.db.any(
    taquery.getColumnsQueryString(
      schema = postgres.config.schema,
      table = table_name,
      debug = log_query_strings
    )
  )
    .then(cols => {
      // filter out columns that do not have create_param_index
      // (this is the input parameter of the api function to add a new record)
      var cols_to_add = cols.filter(function(e){
        return e.create_param_index != null
      });

      // sort by the create function input parameter order
      // this is important because the fields will be submitted
      // to the create function in that order!
      cols_to_add.sort(utils.dynamicSort("create_param_index"));

      // apply field properties based on column name
      // (eg, inferring dependencies, etc)
      cols_to_add.map(function(e){
        var obj = e;
        obj.props = utils.columnNameProperties(obj.column_name);
        return obj;
      })

      // determine which fields are natural keys - they are created, but
      // cannot be edited. so we can look at which fields have a
      // create_param_index but not an update_param_index value
      // (and not a foreign key)
      for (var i=0,l=cols_to_add.length;i<l;i++){
        var col = cols_to_add[i];
        if (
          cols_to_add[i].create_param_index &&
          !cols_to_add[i].update_param_index &&
          !cols_to_add[i].props.dependency
        ) {
          cols_to_add[i].natural_key = true;
        } else {
          cols_to_add[i].natural_key = false;
        }
      }



      console.log(cols_to_add);

      // compile list of reference tables
      var reference_tables = [];
      for (var i=0,l=cols_to_add.length;i<l;i++){
        if (cols_to_add[i].props.dependency){
          var reference_table = cols_to_add[i].props.dependent_table;
          if (reference_tables.indexOf(reference_table) === -1) {
            reference_tables.push(reference_table);
          }
        }
      }

      console.log(reference_tables);

      console.log("-------------");
      var test_query = `
        with
          t1 as (
            select *, row_number() over (order by id) as rn
            from ta.alteryx_type
          ),
          t2 as (
            select *, row_number() over (order by id) as rn
            from ta.source_control_server
          )
        select t1.*, t2.*
        from t1 full outer join t2 on t1.rn = t2.rn
        `
      ;
      //var test_query = "select * FROM information_schema.columns WHERE table_schema = 'ta' order by table_name, ordinal_position";
      console.log(test_query);
      var test_execution = postgres.db.any(test_query)
        .then(data => {
          console.log(data[0]);
        })
        .catch(err => {
          console.log(err);
        })
      ;
      console.log("-------------");


      res.render(
        'entities/actions/create',
        {
          page_name: table_name,
          table_name: table_name,
          fields: cols_to_add,
          dbconfig: postgres.config
        }
      );
    })
    .catch(err => {
      console.log("Error inserting : %s ",err );
      res.redirect('..');
    })
  ;
};

// return object containing
exports.renderDropdownRecord = function(table_name){

}



// this saves data after the user CREATES or UPDATES data on a specific table
// in our CrUd webapp. it then redirects the user back to the READ page for
// that table.
exports.save = function(req,res){
  var postgres = connect(req);

  // grab the table name from the request
  var table_name = req.params.table;

  // grab the user-specified values from the request
  var input = JSON.parse(JSON.stringify(req.body));

  // convert the input data (json obj) into a comma-delimited string
  // for consumption by a postgres API function. for example: 'ABC',123,'etc'
  var data = utils.convertObjectToSQLFunctionInputString(input);

  // now that we have all the pieces, generate the query string to save the data
  var query_string = taquery.saveDataQueryString(
    schema = postgres.config.schema,
    table = table_name,
    data = data,
    debug = log_query_strings
  );

  // execute the query to save the data to the database
  var query = postgres.db.any(
    query_string
  )
    .then(() => {
      res.redirect('..');
    })
    .catch(err => {
      console.log("Error inserting : %s ",err );
      //res.redirect('/crud/' + table_name);
    })
  ;
 // console.log(query.sql); get raw query
};

// this DELETES a row of data from the READ page in our cruD webapp.
exports.delete = function(req,res){
  var postgres = connect(req);

  // grab the table name from the request and convert it to camel case
  var table_name = req.params.table;
  // also grab the id of the row to delete
  var id = req.params.id;

  // execute deletion query (after generating query string)
  var query = postgres.db.any(
    taquery.deleteDataQueryString(
      schema = postgres.config.schema,
      table = table_name,
      id = id,
      debug = log_query_strings
    )
  )
    .then(() => {
      res.redirect('../..');
    })
    .catch(err => {
      console.log("Error deleting : %s ", err );
      res.redirect('../..');
    })
  ;


};
