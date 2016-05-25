path    = require "path"
util    = require "util"
CRC32   = require "crc-32"
Debug   = require("debug")
debug   = Debug "Depurar:" + path.basename(__filename, path.extname(__filename))
appRoot = require "app-root-path"

class Depurar
  constructor: (namespace) ->
    if "#{namespace}".indexOf(":") == -1
      stackError = new Error
      filepath   = Depurar._getCallerPathFromTrace(stackError)
      basename   = path.basename filepath, path.extname(filepath)
      parentDir  = path.basename appRoot.path

      if namespace
        namespace = "#{namespace}:#{basename}"
      else
        namespace = "#{parentDir}:#{basename}"

    color     = Depurar._getColorFromNamespace namespace
    dbg       = Debug namespace
    dbg.color = color

    return dbg

  @_getColorFromNamespace: (namespace, colors) ->
    colors             ?= [6, 2, 3, 4, 5, 1]
    [first, ..., last]  = namespace.split ":"
    absCrc              = Math.abs CRC32.str(last)
    colorIndex          = absCrc % colors.length
    color               = colors[colorIndex]
    return color

  @_getCallerPathFromTrace: (stackError) ->
    caller   = stackError.stack.split('\n')[2].trim()
    matches  = caller.match /\(([^\:]+)\:/
    filepath = matches[1]
    return filepath


module.exports = Depurar
