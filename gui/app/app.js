
/**
 * Module dependencies.
 */

var express = require('express');
var routes = require('./routes');
var http = require('http');
var path = require('path');

//load customers route
var customers = require('./routes/customers');
var testPriorityLevel = require('./routes/testPriorityLevel');
var crud = require('./routes/crud');
var api = require('./routes/api');
var app = express();

//var connection  = require('express-myconnection');
//var mysql = require('mysql');

//var pg = require('pg');


// all environments
app.set('port', process.env.PORT || 4300);
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');
//app.use(express.favicon());
app.use(express.logger('dev'));
app.use(express.json());
app.use(express.urlencoded());
app.use(express.methodOverride());

app.use(express.static(path.join(__dirname, 'public')));

// development only
if ('development' == app.get('env')) {
  app.use(express.errorHandler());
}

/*------------------------------------------
    connection peer, register as middleware
    type koneksi : single,pool and request
-------------------------------------------*/



/*
app.use(

    connection(mysql,{

        host: 'localhost',
        user: 'root',
        password : '',
        port : 3306, //port mysql
        database:'nodejs'

    },'pool') //or single

);
*/


//app.get('/', routes.index);
app.get('/customers', customers.list);
app.get('/customers/add', customers.add);
app.post('/customers/add', customers.save);

app.get('/testPriorityLevel', testPriorityLevel.list);
app.get('/testPriorityLevel/add', testPriorityLevel.add);
app.post('/testPriorityLevel/add', testPriorityLevel.save);
app.get('/testPriorityLevel/delete/:id', testPriorityLevel.delete);


app.get('/', crud.defaultpath);
app.get('/tables', crud.navtables);
app.get('/crud/:table', crud.list);
app.get('/crud/:table/add', crud.add);
app.post('/crud/:table/add', crud.save);
app.get('/crud/:table/delete/:id', crud.delete);

app.get('/api/dropdowntest', api.dropdowntest);
app.get('/api/:table/fkdropdown', api.fkdropdown);


/*app.get('/customers/delete/:id', customers.delete_customer);
app.get('/customers/edit/:id', customers.edit);
app.post('/customers/edit/:id',customers.save_edit);*/


app.use(app.router);

http.createServer(app).listen(app.get('port'), function(){
  console.log('Express server listening on port ' + app.get('port'));
});