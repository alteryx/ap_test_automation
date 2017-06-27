const util = require('util')
const express = require('express')
const app = express()
const expressWS = require('express-ws')(app)
const portNumber = 1234

const rally = require('rally')
const queryUtils = rally.util.query
const restApi = rally({
  apiKey: '_lWhBr01mSf2lAIPLdTtjaDoMmIv0QnUgaVOAN2cY',
  apiVersion: 'v2.0', // this is the default and may be omitted
  server: 'https://rally1.rallydev.com'
})

const queryStringBuilder = message => {
  let query = queryUtils.where('Project.Name', 'contains', message)
  query = query.and('c_KanbanStateAlteryxSuperSet', '=', 'Ready for Merge to ITB')
  return query.toQueryString()
}

const queryReadyToMerge = (message) => {
  console.log('Message: ', message)
  return restApi.query({
    type: 'hierarchicalrequirement',
    start: 1,
    pageSize: 2,
    limit: 3,
    order: 'Rank',
    fetch: ['FormattedID', 'Defects', 'Owner', 'Project', 'Name', 'Changesets', 'Description', 'CreationDate', 'Workspace', 'PlanEstimate', 'TaskStatus'],
    // query: queryUtils.where('Project.Name', 'contains', message)
    query: queryStringBuilder(message)
  })
}

const queryDefectStories = (message) => {
  return restApi.query({
    type: 'defect',
    start: 1,
    pageSize: 2,
    limit: 10,
    order: 'Rank',
    fetch: ['Project', 'Defect', 'Owner', 'Changeset', 'Description'],
    // fetch: ['FormattedID', 'Defect', 'Owner', 'Project', 'Name', 'Changeset', 'Description'],
    query: queryUtils.where(['Name', 'contains', message], ['c_KanbanStateAlteryxSuperSet', '=', 'Ready for Merge to ITB'])
  })
}

const onSuccess = result => {
  return util.inspect(result, {showHidden: false, depth: null})
// console.log('Success', util.inspect(result, {showHidden: false, depth: null}))
}

const onError = error => {
  console.log('Failure!', error.message, error.errors)
}

app.listen(portNumber, () => {
  console.log(`Listening on port ${portNumber}`)
})

app.ws('/qaportal/readytomerge', (websocket, request) => {
  console.log('A client connected!')

  websocket.on('message', (message) => {
    console.log(`A client sent a message: ${message}`)
    queryReadyToMerge(message)
      .then((response) => {
        console.log('Success', util.inspect(response, {showHidden: false, depth: null}))
        websocket.send(JSON.stringify(response))
      })
      .catch(onError)
  })
})

app.ws('/qaportal/mergedtoitb', (websocket, request) => {
  console.log('A client connected!')

  websocket.on('message', (message) => {
    console.log(`A client sent a message: ${message}`)
    queryReadyToMerge(message)
      .then((response) => {
        console.log('Success', util.inspect(response, {showHidden: false, depth: null}))
        websocket.send(JSON.stringify(response))
      })
      .catch(onError)
  })
})

// queryEpicStories()
//   .then(onSuccess)
//   .catch(onError)

// app.get('/', function (req, res) {
//   // res.send('Hello World!')
//   queryEpicStories()
//     .then((response) => {
//       res.send(response)
//     })
//     .catch(onError)
// })
// app.listen(8000, function () {
//   console.log('Example app listening on port 8000!')
// })
