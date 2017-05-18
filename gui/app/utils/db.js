var _ = require("lodash");
var db = require('../db');

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


module.exports = {
  connect: connect
};
