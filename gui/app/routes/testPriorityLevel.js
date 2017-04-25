
/*
 * GET users listing.
 */

//////////////////////////////////////////////////
//// TABLE NAME //////////////////////////////////
//var table_name = 'test_priority_level';
var table_name = 'bug_management_system_type';
///////////////////////////////////////////////////


function camelize(str) {
  return str
    .replace(/_/g, ' ')
    .replace(
      /(?:^\w|[A-Z]|\b\w)/g,
      function(letter, index) {
        return index == 0 ? letter.toLowerCase() : letter.toUpperCase();
      }
    )
    .replace(/\s+/g, '')
    .replace(/^./, function (match){
        return match.toUpperCase()
    })
  ;
}

var postgres = require('../db');
var table_camel_name = camelize(table_name);

// define query strings
var get_data_query_string =
  'SELECT * FROM '+ postgres.schema + '.' + table_name
;
var get_columns_query_string =
  'SELECT column_name ' +
  'FROM information_schema.columns' +
  'WHERE ' +
    'table_schema = ' + postgres.schema + ' and ' +
    'table_name = ' + table_name + ' ' +
  'ORDER by ordinal_position;'
;
var save_data_query_string =
  //"SELECT " + postgres.schema + ".create" + table_camel_name + "([[data]])"
  "SELECT " + postgres.schema + ".create" + table_camel_name + "([[data]])"
; // example: SELECT ta.createTestPriorityLevel([[data]]) -- [[data]] to be replaced in code
var delete_data_query_string =
  "SELECT " + postgres.schema + ".delete" + table_camel_name + "(${id})"
; // example: SELECT ta.deleteTestPriorityLevel([[id]]) -- [[id]] to be replaced in code


exports.list = function(req, res){
  var query = postgres.db.any(get_data_query_string,[true])
    .then(function(rows) {
      res.render(
          'entities/' + table_camel_name + '/read',
          {
            page_title:table_name,
            data:rows
          }
      );
    })
    .catch(function(err){
      console.log("Error Selecting : %s ",err );
    })
    ;
   //console.log(query.sql);
};

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


exports.add = function(req, res){
  res.render(
    'entities/'+table_camel_name+'/create',
    {page_title:table_name}
  );
};



exports.save = function(req,res){
  var input = JSON.parse(JSON.stringify(req.body));
  var data = {
      name    : input.name
  };
  var query = postgres.db.any(
    save_data_query_string
      .replace('[[data]]',"'" + data.name + "'") //TODO: data.name needs to be generalized to ALL fields (not just name!)
  )
    .then(() => {
      res.redirect('/' + table_camel_name);
    })
    .catch(err => {
      console.log("Error inserting : %s ",err );
      res.redirect('/' + table_camel_name);
    });
 // console.log(query.sql); get raw query
};

exports.delete = function(req,res){
  var id = req.params.id;
  var deletion_query_with_id = postgres.pgp.as.format(
    delete_data_query_string,
    {id: id}
  );
  console.log(deletion_query_with_id);

  var query = postgres.db.any(
    deletion_query_with_id
      //.replace('[[id]]',id)
  )
    .then(() => {
      res.redirect('/' + table_camel_name);
    })
    .catch(err => {
      console.log("Error deleting : %s ", err );
      res.redirect('/' + table_camel_name);
    });
};
