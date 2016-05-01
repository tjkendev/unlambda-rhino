###
unlambda.coffee

Copyright (c) 2016 jakejaga

This software is released under the MIT License.
http://opensource.org/licenses/mit-license.php
###

# Exception for Unlambda
class UnlambdaSyntaxError extends Error
  constructor: (@message = null)->
    @name = 'UnlambdaSyntaxError'
class UnlambdaExit extends Error
  constructor: (@message = "", @value = null)->
    @name = 'UnlambdaExit'

# Unlambda Interpreter Class
class @Unlambda
  print_option: false

  constructor: (code)->
    @code = code
    build.call @

  put: (s, t)->
    System.out.print(s) if @print_option
    @stdout += s
    return t

  evalObj = (obj)-> obj()
  toObj = (v)-> (-> v)

  opeApply = (obj_f, obj_x)->
    f = evalObj(obj_f)
    if f == "delay"
      return (y)=> opeApply(obj_x, toObj(y))
    return f(evalObj(obj_x))

  rawApply = (f, x)=> opeApply(toObj(f), toObj(x))

  # create scanner
  getScanner = (s, t=false)->
    @s = s
    @t = t
    @i = 0
    return =>
      if @t && @s.length <= @i
        throw new UnlambdaSyntaxError(
          "invalid syntax: reach the end of program without exit"
        )
      return @s[@i++]

  # exit on Unlambda
  unlambdaExit = (x)->
    throw new UnlambdaExit("Unlambda exit", x)

  # call/cc
  callCC = (func)->
    callback = (x)=> cont(x)
    cont = new Continuation()
    if cont instanceof Continuation
      return func(callback)
    return cont

  # functions
  t = {
    '`': -> ((obj_f, obj_x)=> (=> opeApply(obj_f, obj_x)))(@next(), @next())
    's': -> (=> (x)=>(y)=>(z)=> rawApply(rawApply(x, z), rawApply(y, z)))
    'k': -> (=> (x)=>(y)=>x)
    'i': -> (=> (x)=>x)
    '.': -> ((c)=> (=> (a)=> @put(c, a)))(@sc())
    'r': -> (=> (a)=> @put("\n", a))
    'v': -> (=> (e)=> evalObj(@getFunc('v')))
    'd': -> (=> "delay")
    'c': -> (=> (f)=> callCC((cc)=> rawApply(f, cc)))

    # only in Unlambda version 2 and greater

    'e': -> (=> (x)=> unlambdaExit(x))
    '@': -> (=> (x)=> rawApply(x, evalObj(@getFunc(if (@chara = @si()) then 'i' else 'v'))))
    '?': -> ((c)=> (=> (x)=> rawApply(x, evalObj(@getFunc(if @chara then 'i' else 'v')))))(@sc())
    '|': -> (=> (x)=> rawApply(x, (a)=> if @chara then @put(@chara, a) else evalObj(@getFunc('v'))))

    # ignore characters

    '\n': -> @next()
    '\t': -> @next()
    ' ': -> @next()
  }

  getFunc: (c)-> t[c].call @

  next: ->
    c = @sc()
    if !(c of t)
      throw new UnlambdaSyntaxError("invalid syntax: '#{c}' is not Unlambda function")
    return @getFunc(c)

  # build
  build = ->
    @sc = getScanner(@code, true)

    @chara = null
    try
      @build_func = @next()
    catch e
      throw e unless e instanceof UnlambdaSyntaxError
      print e
      @build_func = (=> null)

  # run
  run: (stdin)->
    @si = getScanner(stdin)
    @stdout = ""
    try
      @result = @build_func()
    catch e
      unless e instanceof UnlambdaExit
        @stdout = ""
        throw e
      @result = e.value
    return @stdout
