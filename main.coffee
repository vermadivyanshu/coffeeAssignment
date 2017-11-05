prompt = require("prompt")
pluralize = require("pluralize")

getAndProcessUserInput = ->
  prompt.start()
  prompt.get ['input'], (err, result) =>
    if err 
      console.log err 
    else 
      parsedInput = _parseUserInput(result)
      _processUserInput(parsedInput) unless parsedInput == null

_parseUserInput = (inputObj)->
  input = null
  try input = JSON.parse(inputObj['input'])
  catch error
    if error.name == 'SyntaxError' then console.log("Type of input can not be string, blank or spaces.") else console.log error
  input
  
_validateUserInput = (input)->
  isValid = true
  unless input?
    console.log("Input can't be blank")
    isValid = false
  unless "object" is typeof(input)
    console.log("Type of can not be #{typeof(input)}")
    isValid = false
  isValid

_checkAndFlatten = (obj,root,arr)->
  vals = []
  for item of arr
    if ("object" is typeof arr[item]) && !(arr[item] instanceof Array)
      vals.push _recursiveFlattenObject(arr[item][pluralize.singular(root)])
  obj[root] = vals unless vals == []
  obj

_recursiveFlattenObject = (obj)->
  for key,value of obj
    if value instanceof Array
      _checkAndFlatten(obj,key,value)
    else if "object" is typeof(value)
      _recursiveFlattenObject(value)
  obj

_processUserInput = (input)->
  if _validateUserInput(input)
    obj = _recursiveFlattenObject(input)
    console.log("\nOutput: #{JSON.stringify(obj)}")
  
getAndProcessUserInput()