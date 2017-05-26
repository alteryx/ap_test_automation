
/**
 * Module dependencies.
 */

var express = require('express');

// express 3->4 migration (middleware)s
var morgan = require('morgan');
var bodyParser = require('body-parser');
var methodOverride = require('method-override');
var errorhandler = require('errorhandler');

var routes = require('./routes');
var http = require('http');
var path = require('path');

var customers = require('./routes/customers');
var testPriorityLevel = require('./routes/testPriorityLevel');
var crud = require('./routes/crud');
var api = require('./routes/api');
var app = express();
var expressWS = require('express-ws')(app);
var rally = require('rally');
var util = require('util');
var queryUtils = rally.util.query
var restApi = rally({
  apiKey: '_lWhBr01mSf2lAIPLdTtjaDoMmIv0QnUgaVOAN2cY',
  apiVersion: 'v2.0', // this is the default and may be omitted
  server: 'https://rally1.rallydev.com'
});

var queryEpicStories = (message) => {
  console.log('Message: ', message)
  return restApi.query({
    type: 'hierarchicalrequirement',
    start: 1,
    pageSize: 2,
    limit: 10,
    order: 'Rank',
    // fetch: ['Project', 'FormattedID', 'Owner', 'Changeset', 'Description', 'Defects'],
    fetch: ['FormattedID', 'Defects', 'Owner', 'Project', 'Name', 'Changesets', 'Description'],
    query: queryUtils.where('Project.Name', 'contains', message)
  })
};



// all environments
app.set('port', process.env.PORT || 4300);
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');
//app.use(express.favicon());

/* (start) migration from express 3 to 4 */
  //app.use(express.logger('dev'));
  app.use(morgan('dev'));

  //app.use(express.json());
  app.use(bodyParser.json());

  //app.use(express.urlencoded());
  app.use(bodyParser.urlencoded({ extended: false }));

  //app.use(express.methodOverride());
  app.use(methodOverride());

  // development only
  //if ('development' == app.get('env')) {
  if (process.env.NODE_ENV === 'development') {
    //app.use(express.errorHandler());
    app.use(errorHandler());
  }
/* (end) migration from express 3 to 4 */


app.use(express.static(path.join(__dirname, 'public')));


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
app.get('/crud/:table/delete/:id', crud.delete);
app.get('/crud/:table/edit/:id', crud.edit);
app.post('/crud/:table/save/:id', crud.save);

/*
app.get('/crud/:table/add', crud.add);
app.post('/crud/:table/add', crud.save);
app.get('/crud/:table/edit/:id', crud.edit);
app.post('/crud/:table/edit/:id',crud.save_edit);
*/

//app.get('/api/dropdowntest', api.dropdowntest);
app.get('/api/:table/fk/:html', api.foreignkey);

app.ws('/qaportal', (websocket, request) => {
  console.log('A client connected!')

  websocket.on('message', (message) => {
    console.log(`A client sent a message: ${message}`)
    queryEpicStories(message)
      .then((response) => {
        console.log('Success', util.inspect(response, {showHidden: false, depth: null}))
        websocket.send(JSON.stringify(response))
      })
      .catch(onError)
  })
});

/*app.get('/customers/delete/:id', customers.delete_customer);
app.get('/customers/edit/:id', customers.edit);
app.post('/customers/edit/:id',customers.save_edit);*/


//app.use(app.router); // no longer needed (migration express 3->4)

http.createServer(app).listen(app.get('port'), function(){
  console.log('Express server listening on port ' + app.get('port'));
});
