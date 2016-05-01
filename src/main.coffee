###
main.coffee

Copyright (c) 2016 jakejaga

This software is released under the MIT License.
http://opensource.org/licenses/mit-license.php
###

load "unlambda.js"

importPackage java.io
importPackage java.lang

# properties
VERSION = "1.0.0"

getStdin = -> new BufferedReader new InputStreamReader(System['in'])

getLines = ->
  stdin = getStdin()
  res = []
  while (s = stdin.readLine())?
    res.push String(s)
  stdin.close()
  return res.join("\n")

getOption = (args)->
  opts = {}
  idx = 0
  while idx < args.length
    switch args[idx]
      when "-e", "--encode"
        opts["encode"] = args[++idx]
      when "-v", "--version"
        opts["version"] = "version #{VERSION}"
      else
        opts["error"] ?= "'#{args[idx]}': unrecognized option" if args[idx].match /^-.*/
        # script file
        opts["filename"] ?= args[idx]
    idx++
  return opts

main = (args)->
  opts = getOption(args)

  if opts["version"]
    print opts["version"]
    return

  if opts["error"]
    print opts["error"]
    return

  # default interpreter option
  opts["with-printing"] = true

  if opts["filename"]
    code = readFile(opts["filename"], opts["encode"] || "UTF-8")
    # get inputs if "@" function exists
    input = if "@" in code then getLines() else ""
  else
    stdin = getStdin()
    # input script
    System.out.print "> "
    code = String(stdin.readLine())
    # get inputs if "@" function exists
    input = if "@" in code then String(stdin.readLine()) else ""
    stdin.close()

  unlambda = new Unlambda(code)
  unlambda.print_option = true if opts["with-printing"]

  res = unlambda.run(input)

  print() if opts["with-printing"]
  print res if res.length && !opts["with-printing"]
main(@arguments)
