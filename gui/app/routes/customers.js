
/*
 * GET users listing.
 */

var postgres = require('../db');
console.log(postgres);

exports.list = function(req, res){
  var query = postgres.db.query('SELECT * FROM '+ postgres.schema +'.customer',[true])
    .then(function(rows) {
      res.render('entities/customer/read',{page_title:"Customers - Node.js",data:rows});
    })
    .catch(function(err){
      console.log("Error Selecting : %s ",err );
    })
    ;
   //console.log(query.sql);
};



exports.add = function(req, res){
  res.render('entities/customer/create',{page_title:"Add Customers - Node.js"});
};


/*Save the customer*/
exports.save = function(req,res){
  var input = JSON.parse(JSON.stringify(req.body));
  var data = {
      name    : input.name,
      address : input.address,
      email   : input.email,
      phone   : input.phone
  };
  var query = postgres.db.none(
    "INSERT INTO " + postgres.schema + ".customer set ? ${this}",
    data
  )
    .then(() => {
      res.redirect('/customers');
    })
    .catch(err => {
      console.log("Error inserting : %s ",err );
      res.redirect('/customers');
    });
 // console.log(query.sql); get raw query
};
