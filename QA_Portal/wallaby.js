module.exports = function (wallaby) {
  return {
    files: [
      'rally.js'
    ],

    tests: [
      'tests/rally.spec.js'
    ],
    
    env: {
      type: 'node'
    }
  // ...
  // for node.js tests you need to set env property as well
  // https://wallabyjs.com/docs/integration/node.html
  }
}
