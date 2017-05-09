'use strict';


var default_db = "customer_crud_test" ;


function postgres(dbname){
  var promise = require('bluebird');
  var pgp_options = {
      promiseLib: promise // overriding the default (ES6 Promise);
  };
  var pgp = require('pg-promise')(pgp_options);


  var config = {
    user: 'postgres', //env var: PGUSER
    database: dbname, //env var: PGDATABASE
    password: 'postgres', //env var: PGPASSWORD
    host: '10.10.18.50', // Server hosting the postgres database
    port: 5432, //env var: PGPORT
    schema: "ta",
  };
  //var pool = new pg.Pool(config);
  var db = pgp(config);

  var postgres = {
    pgp: pgp,
    db: db,
    config: config
  };

  return postgres;
};

module.exports = {
  postgres: postgres(default_db),
  default_db: default_db
}
