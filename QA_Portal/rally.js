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
    fetch: ['FormattedID', 'Defects', 'Owner', 'Project', 'Name', 'Changesets', 'Description', 'CreationDate', 'Workspace', 'PlanEstimate', 'TaskStatus', 'Blocked', 'Feature', 'Severity', 'c_DefectSource', 'c_TestingStatus', 'ObjectID', 'BlockedReason', 'Release', 'c_PriorityTier', 'c_ReleaseTrainBoardingStatus', 'PercentDoneByStoryCount', 'Theme', 'Predecessors', 'Successors', 'Parent', 'Children'],
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
    fetch: ['FormattedID', 'Defects', 'Owner', 'Project', 'Name', 'Changesets', 'Description', 'CreationDate', 'Workspace', 'PlanEstimate', 'TaskStatus', 'Blocked', 'Feature', 'Severity', 'c_DefectSource', 'c_TestingStatus', 'ObjectID', 'BlockedReason', 'Release', 'c_PriorityTier', 'c_ReleaseTrainBoardingStatus', 'PercentDoneByStoryCount'],
    query: queryStringBuilder(message, 'Merged to Integration')
  })
}

const queryITBDefects = (message, apiEndpoint) => {
  console.log('Message: ', message)
  return restApi.query({
    type: apiEndpoint,
    start: 1,
    pageSize: 2,
    limit: 20,
    order: 'Rank',
    fetch: ['FormattedID', 'Defects', 'Owner', 'Project', 'Name', 'Changesets', 'Description', 'CreationDate', 'Workspace', 'PlanEstimate', 'TaskStatus', 'Blocked', 'Feature', 'Severity', 'c_DefectSource', 'c_TestingStatus', 'ObjectID', 'BlockedReason', 'Release', 'c_PriorityTier', 'c_ReleaseTrainBoardingStatus', 'PercentDoneByStoryCount'],
    query: queryStringBuilder(message, 'Merged to Integration')
  })
}

const updateMergedToITB = (ref) => {
  return restApi.update({
    ref: ref,
    data: {
      c_KanbanStateAlteryxSuperSet: 'Merged to Integration'
    }
  })
}

const updateMergeToCRT = (ref) => {
  return restApi.update({
    ref,
    data: {
      c_KanbanStateAlteryxSuperSet: 'Ready for Merge to CRT'
    }
  })
}

const releaseStringBuilder = () => {
  let query = queryUtils.where('State', 'contains', 'Active')
  query = query.or('State', 'contains', 'Planning')
  query = query.and('Name', 'contains', 'PI')
  query = query.and('Name', 'contains', '|')
  return query.toQueryString()
}

const queryRelease = () => {
  return restApi.query({
    type: 'release',
    start: 1,
    pageSize: 2,
    limit: 100,
    // fetch: [],
    query: releaseStringBuilder()
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
    queryReadyToMerge(message, 'hierarchicalrequirement')
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

app.ws('/qaportal/mergedtoitb/update', (websocket, request) => {
  console.log('A client connected!')

  websocket.on('message', (message) => {
    console.log(`A client sent a message: ${message}`)
    let teamName = message.split('-')[0]
    let ref = message.split('-')[1]

    updateMergedToITB(ref)
      .then(() => {
        queryReadyToMerge(teamName, 'hierarchicalrequirement')
          .then((response) => response)
          .then((res) => {
            queryReadyToMerge(teamName, 'defect')
              .then((response) => {
                res.Results = res.Results.concat(response.Results)
                websocket.send(JSON.stringify(res))
              })
              .catch(onError)
          })
          .catch(onError)
      })
      .catch(onError)
  })
})

app.ws('/qaportal/mergetocrt/update', (websocket, request) => {
  console.log('A client connected!')

  websocket.on('message', (message) => {
    console.log(`A client sent a message: ${message}`)
    let teamName = message.split('-')[0]
    let ref = message.split('-')[1]

    updateMergeToCRT(ref)
      .then(() => {
        queryMergedToITB(teamName, 'hierarchicalrequirement')
          .then((response) => response)
          .then((res) => {
            queryMergedToITB(teamName, 'defect')
              .then((response) => {
                res.Results = res.Results.concat(response.Results)
                websocket.send(JSON.stringify(res))
              })
              .catch(onError)
          })
          .catch(onError)
      })
      .catch(onError)
  })
})

app.ws('/qaportal/itbdefects', (websocket, request) => {
  console.log('A client connected!')

  websocket.on('message', (message) => {
    console.log(`A client sent a message: ${message}`)

    queryITBDefects(message, 'defect')
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
            res.Results = res.Results.concat(response.Results).filter((result) => result.Feature !== null)
            websocket.send(JSON.stringify(res))
          })
          .catch(onError)
      })
      .catch(onError)
  })
})

app.ws('/qaportal/releases', (websocket, request) => {
  console.log('A client connected!')

  websocket.on('message', (message) => {
    console.log(`A client sent a message: ${message}`)
    queryRelease()
      .then((response) => {
        const getRefObjectName = R.prop('_refObjectName')
        const getUniqPIs = R.compose(R.uniq, R.map(getRefObjectName))
        let output = getUniqPIs(response.Results)
        websocket.send(JSON.stringify(output))
        console.log(output)
      })
      .catch(onError)
  })
})

module.exports = { queryReadyToMerge, queryMergedToITB, queryITBDefects, updateMergedToITB, updateMergeToCRT, app }