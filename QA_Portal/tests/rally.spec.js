const chai = require('chai')
const chaiHttp = require('chai-http')
const assert = require('assert')
const rally = require('../rally')

chai.use(chaiHttp)

describe('add', () => {
  it('should add 2 numbers together', () => {
    const add = (x, y) => x + y
    assert.equal(add(2, 2), 4)
  })

  it('should be curried', () => {
    const add = x => y => x + y
    const actual = add(1)(2)
    const expected = 3
    assert.equal(actual, expected)
  })
})

describe('should have a queryReadyToMerge function', () => {
  it('should exists', () => {
    const expected = 'function'
    const actual = typeof rally.queryReadyToMerge
    assert.equal(actual, expected)
  })
})

describe('should have a queryMergedToITB function', () => {
  it('should exists', () => {
    const expected = 'function'
    const actual = typeof rally.queryMergedToITB
    assert.equal(actual, expected)
  })
})

describe('should have a queryITBDefects function', () => {
  it('should exists', () => {
    const expected = 'function'
    const actual = typeof rally.queryITBDefects
    assert.equal(actual, expected)
  })
})

describe('should have a queryStringBuilder function', () => {
  it('should exists', () => {
    const expected = 'function'
    const actual = typeof rally.updateMergedToITB
    assert.equal(actual, expected)
  })
})

describe('should have a updateMergeToCRT function', () => {
  it('should exists', () => {
    const expected = 'function'
    const actual = typeof rally.queryStringBuilder
    assert.equal(actual, expected)
  })

  it('should output a string', () => {
    const expected = '((Project.Name contains "Integration Test Team") AND (c_KanbanStateAlteryxSuperSet = "In Progress"))'
    const actual = rally.queryStringBuilder('Integration Test Team', 'In Progress')
    assert.equal(actual, expected)
  })
})
