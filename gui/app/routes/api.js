
var _ = require("lodash");
var db = require('../db');
var db_query = require('../db/query');
var utils = require('../utils');
var utils_db = require('../utils/db');




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
