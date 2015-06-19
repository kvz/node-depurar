path    = require "path"
util    = require "util"
CRC32   = require "crc-32"
debug   = require("debug")("Depurar:" + path.basename(__filename, path.extname(__filename)))
appRoot = require "app-root-path"

class Depurar
  constructor: (namespace) ->
    if "#{namespace}".indexOf(":") == -1
      stackError = new Error
      filepath   = Depurar._getCallerPathFromTrace(stackError)
      basename   = path.basename filepath, path.extname(filepath)
      parentDir  = path.basename appRoot

      if namespace
        namespace = "#{namespace}:#{basename}"
      else
        namespace = "#{parentDir}:#{basename}"


    colors = [6, 2, 3, 4, 5, 1]
    secondPart = namespace.split(":")[1]
    crc        = CRC32.str secondPart

    dbg       = require("debug")(namespace)
    dbg.color = colors[crc % colors.length]

    return dbg


  @_getCallerPathFromTrace: (stackError) ->
    caller   = stackError.stack.split('\n')[2].trim()
    matches  = caller.match /\(([^\:]+)\:/
    filepath = matches[1]
    return filepath

module.exports = Depurar
