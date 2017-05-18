
var _ = require("lodash");
var db = require('../db');
var db_query = require('../db/query');
var utils = require('../utils');
var utils_db = require('../utils/db');

var log_query_strings = true;


exports.dropdowntest = function(req, res){
  var postgres = utils_db.connect(req);

  // grab table from parameters
  var table_name = req.params.table;

  res.render(
    'entities/actions/dropdown_test',
    {
      /*tables: tables,
      headers: headers,
      dbconfig: postgres.config,*/
      page_name: "test"
    }
  );
}


// this renders the READ page for a specific table in our cRud webapp.
exports.fkdropdown = function(req, res){
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

        console.log("[COLUMNS]:");
        console.log(cols);
        console.log("[ROWS (DATA)]:");
        console.log(rows)

        // start putting together select menu options
        var select_options = [];
        // loop through rows (one option per row)
        for (var row_i=0,row_l=rows.length;row_i<row_l;row_i++){
          var row = rows[row_i];
          if (!row.end_datetime){
            var nkvalues = [];
            var name_values = [];
            var select_option = {
              value: row.id
            };
            // loop through columns (find relevant cols and concat values)
            for (var col_i=0,col_l=cols.length;col_i<col_l;col_i++){
              var col = cols[col_i];
              var col_name = col.column_name;
              if (
                (col.create_param_index != null) &&
                (col.update_param_index == null) &&
                (col.props.dependency === false) &&
                (col.data_type === 'text')
              ) {
                var nkvalue = row[col_name];
                if (col_name === "name") {
                  name_values.push(nkvalue);
                } else if (nkvalue) {
                  nkvalues.push(col_name + "=" + nkvalue + "");
                }
              }
            }
            var nkvalues_str = nkvalues.join(", ");
            if (nkvalues_str) name_values.push(nkvalues_str);
            var name_values_str = name_values.join(": ");
            select_option.label = name_values_str;
            select_options.push(select_option);
          }
        }

        console.log(select_options);

        res.render(
          'entities/actions/fkdropdown_html',
          {
            select_options:select_options
          }
        );

    })
    .catch(error => {
      console.log("Error Selecting : %s ", error);
    })
  ;
};
