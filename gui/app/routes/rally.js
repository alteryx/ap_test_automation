const util = require('util')
const express = require('express')
const app = express()
const expressWS = require('express-ws')(app)
const portNumber = 1234

const rally = require('rally')
const queryUtils = rally.util.query
const restApi = rally({
  apiVersion: 'v2.0', // this is the default and may be omitted
  server: 'https://rally1.rallydev.com'
})

const queryEpicStories = (message) => {
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
    query: queryUtils.where('Name', 'contains', message)
  })
}

const onSuccess = result => {
  return util.inspect(result, { showHidden: false, depth: null })
  // console.log('Success', util.inspect(result, {showHidden: false, depth: null}))
}

const onError = error => {
  console.log('Failure!', error.message, error.errors)
}

app.listen(portNumber, () => {
  console.log(`Listening on port ${portNumber}`)
})
app.ws('/qaportal', (websocket, request) => {
  console.log('A client connected!')

  websocket.on('message', (message) => {
    console.log(`A client sent a message: ${message}`)
    queryEpicStories(message)
      .then((response) => {
        console.log('Success', util.inspect(response, { showHidden: false, depth: null }))
        websocket.send(JSON.stringify(response))
        // console.log(response.Changesets)
      })
      .catch(onError)

    // queryDefectStories(message)
    //   .then((response) => {
    //     defects = response
    //     websocket.send(JSON.stringify(response))
    //   })
    //   .then(() => {
    //     output = Object.assign({}, userStory, defects)
    //   })
    //   .then(() => console.log('Success', util.inspect(output, {showHidden: false, depth: null})))
    //  Object.assign({}, userStory, defects)
    // console.log('Success', util.inspect(output, {showHidden: false, depth: null}))
    // websocket.send('Hello, world!')
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
