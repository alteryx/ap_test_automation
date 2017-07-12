const util = require('util')
const express = require('express')
const app = express()
const expressWS = require('express-ws')(app)
const portNumber = 1234
const R = require('ramda')

const rally = require('rally')
const queryUtils = rally.util.query
const restApi = rally({
  apiKey: '_lWhBr01mSf2lAIPLdTtjaDoMmIv0QnUgaVOAN2cY',
  apiVersion: 'v2.0', // this is the default and may be omitted
  server: 'https://rally1.rallydev.com'
})

const queryStringBuilder = (message, kbState) => {
  let query = queryUtils.where('Project.Name', 'contains', message)
  query = query.and('c_KanbanStateAlteryxSuperSet', '=', kbState)
  return query.toQueryString()
}

const queryReadyToMerge = (message, apiEndpoint) => {
  console.log('Message: ', message)
  return restApi.query({
    type: apiEndpoint,
    start: 1,
    pageSize: 2,
    limit: 20,
    order: 'Rank',
    fetch: ['FormattedID', 'Defects', 'Owner', 'Project', 'Name', 'Changesets', 'Description', 'CreationDate', 'Workspace', 'PlanEstimate', 'TaskStatus', 'Blocked', 'Feature', 'Severity', 'c_DefectSource'],
    // query: queryUtils.where('Project.Name', 'contains', message)
    query: queryStringBuilder(message, 'Ready for Merge to ITB')
  })
}

const queryMergedToITB = (message, apiEndpoint) => {
  console.log('Message: ', message)
  return restApi.query({
    type: apiEndpoint,
    start: 1,
    pageSize: 2,
    limit: 20,
    order: 'Rank',
    fetch: ['FormattedID', 'Defects', 'Owner', 'Project', 'Name', 'Changesets', 'Description', 'CreationDate', 'Workspace', 'PlanEstimate', 'TaskStatus', 'Blocked', 'Feature', 'Severity', 'c_DefectSource'],
    query: queryStringBuilder(message, 'Merged to Integration')
  })
}

const queryDefectStatus = (message, apiEndpoint) => {
  console.log('Message: ', message)
  return restApi.query({
    type: apiEndpoint,
    start: 1,
    pageSize: 2,
    limit: 20,
    order: 'Rank',
    fetch: ['FormattedID', 'Defects', 'Owner', 'Project', 'Name', 'Changesets', 'Description', 'CreationDate', 'Workspace', 'PlanEstimate', 'TaskStatus', 'Blocked', 'Feature', 'Severity', 'c_DefectSource'],
    query: queryStringBuilder(message, 'Ready for Merge to ITB')
  })
}

// const queryFeatureStatus = (message, apiEndpoint) => {
//   console.log('Message: ', message)
//   return restApi.query({
//     type: apiEndpoint,
//     start: 1,
//     pageSize: 2,
//     limit: 20,
//     order: 'Rank',
//     fetch: ['FormattedID', 'Defects', 'Owner', 'Project', 'Name', 'Changesets', 'Description', 'CreationDate', 'Workspace', 'PlanEstimate', 'TaskStatus', 'Blocked', 'Feature', 'Severity', 'c_DefectSource'],
//     // query: queryUtils.where('Project.Name', 'contains', message)
//     query: queryStringBuilder(message, 'Ready for Merge to ITB')
//   })
// }

const updateMergedToITB = (result) => {
  return restApi.update({
    ref: result.object,
    data: {
      Name: 'Some update message'
    },
    fetch: ['Name']
  })
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
    if (message === 'All Teams') {
      message = 'Blue Group'
    }
    queryReadyToMerge(message, 'hierarchicalrequirement')
      .then((response) => response)
      .then((res) => {
        queryReadyToMerge(message, 'defect')
          .then((response) => {
            res.Results = res.Results.concat(response.Results)
            websocket.send(JSON.stringify(res))
            console.log('Success', util.inspect(res, {showHidden: false, depth: null}))
          })
          .catch(onError)
      })
      .catch(onError)
  })
})

app.ws('/qaportal/mergedtoitb', (websocket, request) => {
  console.log('A client connected!')

  websocket.on('message', (message) => {
    console.log(`A client sent a message: ${message}`)
    queryMergedToITB(message, 'hierarchicalrequirement')
      .then((response) => response)
      .then((res) => {
        queryMergedToITB(message, 'defect')
          .then((response) => {
            res.Results = res.Results.concat(response.Results)
            websocket.send(JSON.stringify(res))
          })
          .catch(onError)
      })
      .catch(onError)
  })
})

app.ws('/qaportal/defectstatus', (websocket, request) => {
  console.log('A client connected!')

  websocket.on('message', (message) => {
    console.log(`A client sent a message: ${message}`)

    queryDefectStatus(message, 'defect')
      .then((response) => {
        websocket.send(JSON.stringify(response))
      })
      .catch(onError)
  })
})

app.ws('/qaportal/featurestatus', (websocket, request) => {
  console.log('A client connected!')

  websocket.on('message', (message) => {
    console.log(`A client sent a message: ${message}`)
    queryReadyToMerge(message, 'hierarchicalrequirement')
      .then((response) => response)
      .then((res) => {
        queryReadyToMerge(message, 'defect')
          .then((response) => {
            res.Results = res.Results.concat(response.Results)
            websocket.send(JSON.stringify(res))
          })
          .catch(onError)
      })
      .catch(onError)
  })
})
