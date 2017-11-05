prompt = require "prompt"
pluralize = require "pluralize"

jsonFormatter =

  getAndProcessUserInput: ->
    prompt.start()
    prompt.get ['input'], (err, result) =>
      if err 
        console.log err 
      else 
        parsedInput = jsonFormatter._parseUserInput(result)
        jsonFormatter._processUserInput(parsedInput) unless parsedInput == null

  _parseUserInput: (inputObj)->
    input = null
    try input = JSON.parse(inputObj['input'])
    catch error
      if error.name == 'SyntaxError' then console.log("Type of input can not be string, blank, spaces or is not of proper format.") else console.log error
    input
  
  _validateUserInput: (input)->
    isValid = true
    unless "object" is typeof(input)
      console.log("Type of input can not be #{typeof(input)}.")
      isValid = false
    isValid

  _checkAndFlattenArray: (obj,root)->
    arr = obj[root]
    vals = []
    for item of arr
      if ("object" is typeof arr[item]) && !(arr[item] instanceof Array)
        objToFlat = arr[item]
        if arr[item][pluralize.singular(root)]
          objToFlat = arr[item][pluralize.singular(root)]
        vals.push jsonFormatter._recursiveFlattenObject(objToFlat)
    obj[root] = vals unless vals == []
    obj

  _recursiveFlattenObject: (obj)->
    unless obj instanceof Array
      for key,value of obj
        if value instanceof Array
          jsonFormatter._checkAndFlattenArray(obj,key)
        else if "object" is typeof(value)
          jsonFormatter._recursiveFlattenObject(value)
    else
      for item of obj
        jsonFormatter._recursiveFlattenObject(obj[item])
    obj

  _processUserInput: (input)->
    if jsonFormatter._validateUserInput(input)
      jsonFormatter._recursiveFlattenObject(input)
      console.log("\nOutput: #{JSON.stringify(input)}")

module.exports = jsonFormatter