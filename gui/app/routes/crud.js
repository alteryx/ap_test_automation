
///////////////////////////////////////////////////////////
// logic to execute SQL queries and render CRUD pages
///////////////////////////////////////////////////////////

var _ = require("lodash");
var db = require('../db');
var db_query = require('../db/query');
var utils = require('../utils');
var utils_db = require('../utils/db');
var utils_data = require('../utils/data');

// print sql queries to console
var log_query_strings = true;
var debug_logging = true;



// if no path entered (after base url), redirect to tables page-data
exports.defaultpath = function(req, res){
  res.redirect('./tables');
}

// query list of tables in schema and render page with links
exports.navtables = function(req, res){
  var postgres = utils_db.connect(req);

  // execute 'get tables' query (after generating query string)
  var query = postgres.db.any(
    db_query.getTablesQueryString(
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
  var postgres = utils_db.connect(req);

  // grab the table name from the request
  var table_name = req.params.table;

  // replace variable placeholders with actual values
  var query_string = db_query.getDataQueryString(
      schema = postgres.config.schema,
      table = table_name,
      debug = log_query_strings
  );

  // create query string to get an array of field info for the specified table
  var get_columns_query_string = db_query.getColumnsQueryString(
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
          obj.props = utils_data.columnNameProperties(obj.column_name);
          return obj;
        });

        utils.debugLogging(
          cols,
          debug_logging,
          "table list: cols"
        );

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


function deltaModeObj(id_mode){
  // adding a new item or editing an existing one?
  var delta = {"id_mode":id_mode};
  if (delta.id_mode === "new") {
    delta.edit_mode = "create";
    delta.id = null;
  } else {
    delta.edit_mode = "update";
    delta.id = delta.id_mode;
  }
  return delta;
}

// this renders the CREATE/UPDATE pages for a specific table in our Crud webapp.
exports.edit = function(req, res){
  var postgres = utils_db.connect(req);

  var table_name = req.params.table;

  // adding a new item or editing an existing one?
  var delta = deltaModeObj(req.params.id);

  utils.debugLogging(
    delta.id_mode,
    debug_logging,
    "edit: delta.id_mode"
  );

  // create query string to get an array of field info for the specified table
  // and then execute the query to save the data to the database
  var query = postgres.db.any(
    db_query.getColumnsQueryString(
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
        obj.props = utils_data.columnNameProperties(obj.column_name);
        return obj;
      })

      // determine which fields are natural keys - they are created, but
      // cannot be edited. so we can look at which fields have a
      // create_param_index value but not an update_param_index value
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

      utils.debugLogging(
        cols_to_add,
        debug_logging,
        "edit page: cols_to_add"
      );

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

      utils.debugLogging(
        reference_tables,
        debug_logging,
        "edit page: reference_tables"
      );


      res.render(
        'entities/actions/create',
        {
          page_name: table_name,
          table_name: table_name,
          fields: cols_to_add,
          dbconfig: postgres.config,
          delta:delta
        }
      );
    })
    .catch(err => {
      console.log("Error inserting : %s ",err );
      res.redirect('..');
    })
  ;
};


// this saves data after the user CREATES or UPDATES data on a specific table
// in our CrUd webapp. it then redirects the user back to the READ page for
// that table.
exports.save = function(req,res){
  var postgres = utils_db.connect(req);

  // grab the table name from the request
  var table_name = req.params.table;

  // adding a new item or editing an existing one?
  var delta = deltaModeObj(req.params.id);

  // grab the user-specified values from the request
  var input = JSON.parse(JSON.stringify(req.body));

  // convert the input data (json obj) into a comma-delimited string
  // for consumption by a postgres API function. for example: 'ABC',123,'etc'
  var data = utils.convertObjectToSQLFunctionInputString(input);

  // now that we have all the pieces, generate the query string to save the data
  var query_string = db_query.editDataQueryString(
    schema = postgres.config.schema,
    table = table_name,
    edit_mode = delta.edit_mode,
    data = data,
    debug = log_query_strings
  );

  // execute the query to save the data to the database
  var query = postgres.db.any(
    query_string
  )
    .then(() => {
      res.redirect('/crud/' + table_name);
    })
    .catch(err => {
      console.log("Error inserting : %s ",err );
      res.redirect('/crud/' + table_name);
    })
  ;
 // console.log(query.sql); get raw query
};

// this DELETES a row of data from the READ page in our cruD webapp.
exports.delete = function(req,res){
  var postgres = utils_db.connect(req);

  // grab the table name from the request and convert it to camel case
  var table_name = req.params.table;
  // also grab the id of the row to delete
  var id = req.params.id;

  // execute deletion query (after generating query string)
  var query = postgres.db.any(
    db_query.deleteDataQueryString(
      schema = postgres.config.schema,
      table = table_name,
      id = id,
      debug = log_query_strings
    )
  )
    .then(() => {
      res.redirect('/crud/' + table_name);
    })
    .catch(err => {
      console.log("Error deleting : %s ", err );
      res.redirect('/crud/' + table_name);
    })
  ;


};
