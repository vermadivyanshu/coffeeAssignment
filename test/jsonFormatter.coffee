chai = require 'chai'
expect = chai.expect
assert = chai.assert
sinon = require 'sinon'
jsonFormatter = require '../jsonFormatter'

describe '#_parseUserInput', ->
  describe 'when user input is valid', ->
   it 'should return the parsed input', ->
    input = { hello: 'World' }
    inputObj =
        input: JSON.stringify(input)
    expect(jsonFormatter._parseUserInput(inputObj)).to.deep.equal(input)
  describe 'when user input is not valid', ->
    it 'should print the error on console and return null', ->
      input = 'Hey'
      inputObj = { input: input }
      spy = sinon.spy(console, 'log')
      output = jsonFormatter._parseUserInput(inputObj)
      assert(spy.calledWith("Type of input can not be string, blank, spaces or is not of proper format."))
      expect(output).to.equal(null)
      console.log.restore()

describe '#_validateUserInput', ->
  it 'should print the appropriate error message and return false when the input is not valid', ->
    spy = sinon.spy(console, 'log')
    output = jsonFormatter._validateUserInput(123)
    assert(spy.calledWith("Type of input can not be number."))
    expect(output).to.equal(false)
    console.log.restore()
  it 'should return true when the object is valid', ->
    input = { hello: 'world', books: [{book: {content: 'abc'}}]}
    expect(jsonFormatter._validateUserInput(input)).to.equal(true)

describe '#_checkAndFlattenArray', ->
  it 'should check and flatten the occurence of any arrays of objects', ->
    obj = { h: '1', books: [{book: {content: 'hello'}},{book: {content: 'hey'}}]}
    flatObj = {h: '1', books: [{content: 'hello'},{content: 'hey'}]}
    expect(jsonFormatter._checkAndFlattenArray(obj,'books')).to.deep.equal(flatObj)
  it 'should not do anything if the array of objects is correctly formatted', ->
    flatObj = {h: '1', books: [{content: 'hello'},{content: 'hey'}]}
    expect(jsonFormatter._checkAndFlattenArray(flatObj,'books')).to.deep.equal(flatObj)
  it 'should flatten any nested objects', ->
    obj = { h: '1', books: [{book: { authors:[{author:{name: 'ABC'}}]}}]}
    flatObj = { h: '1', books:[{ authors:[{ name: 'ABC' }] }] }
    expect(jsonFormatter._checkAndFlattenArray(obj,'books')).to.deep.equal(flatObj)

describe '#_recursiveFlattenObject', ->
  describe 'when input is an json object', ->
    it 'when flattening needs to be done on one level, it should flatten the object', ->
      obj = {h:2, pens:[{pen:{color: 'blue'}},{pen:{color: 'black'}}]}
      flatObj = {h:2, pens:[{color: 'blue'},{color: 'black'}]}
      expect(jsonFormatter._recursiveFlattenObject(obj)).to.deep.equal(flatObj)
    it 'in case of nested flattening, it should return the flattened object', ->
      obj = {hey: 'you', shapes:[{shape:{name: 'Triangle', colors:[{color:{name: 'blue'}},
      {color:{name:'black'}}]}}]}
      flatObj = {hey: 'you', shapes:[{name: 'Triangle',colors:[{name:'blue'},{name:'black'}]}]}
      expect(jsonFormatter._recursiveFlattenObject(obj)).to.deep.equal(flatObj)
  describe 'when input is an array of json objects', ->
    it 'should flatten all the json objects', ->
      obj = [{books:[{book:{authors:[{author:{name:'ABCD'}}]}}]},{hello: 'World'}]
      flatObj = [{books:[{authors:[{name:'ABCD'}]}]},{hello:'World'}]
      expect(jsonFormatter._recursiveFlattenObject(obj)).to.deep.equal(flatObj)
    
describe '#_processUserInput', ->
  describe 'when the input is not valid', ->
    it 'should display the error message on the console', ->
      input = false
      spy = sinon.spy(console, 'log')
      jsonFormatter._processUserInput(input)
      assert(spy.calledWith("Type of input can not be boolean."))
      console.log.restore()
  describe 'when the iput is valid', ->
    it 'should display the flattened json object on the console', ->
      spy = sinon.spy(console, 'log')
      input = 
        hello: 'World'
        roses: [{rose: {color: 'red'}},{rose: {color: 'black'}},{rose:{color: 'white'}}]
      flatObj = { hello: 'World', roses:[{color: 'red'},{color: 'black'},{color: 'white'}]}
      jsonFormatter._processUserInput(input)
      assert(spy.calledWith("\nOutput: #{JSON.stringify(flatObj)}"))
      
  