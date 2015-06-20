should = require("chai").should()
expect = require("chai").expect
path   = require "path"
util   = require "util"
fs     = require "fs"
debug  = require("debug")("Depurar:" + path.basename(__filename, path.extname(__filename)))

captured = []
capture  = (args...) ->
  if args.length != 1
    throw new Error "console.log was called with less or more than 1 argument. that's not supported yet"

  for arg, i in args
    # Replace the duration with XX as this varies and makes things untestable
    args[i] = arg.replace /\d+ms/, "XXms"

  captured.push args[0]

describe "Depurar", ->
  @timeout 10000 # <-- This is the Mocha timeout, allowing tests to run longer

  describe "constructor", ->
    it "should respect configured namespace Foo:Bar", (done) ->
      captured    = []
      depurar     = require("../src/Depurar")("Foo:Bar")
      depurar.log = capture
      depurar "ohai"
      expect(captured[0]).to.match /mFoo:Bar /
      done()

    it "should figure out namespace if unconfigured", (done) ->
      captured    = []
      depurar     = require("../src/Depurar")()
      depurar.log = capture
      depurar "ohai"

      expect(captured[0]).to.match /mnode\-depurar:mocha\-depurar /
      done()

    it "should make color dependent on second part of namespace", (done) ->
      captured    = []

      depurar     = require("../src/Depurar")("Foo:Bar")
      depurar.log = capture
      depurar "ohai"

      depurar     = require("../src/Depurar")("What:Bar")
      depurar.log = capture
      depurar "ohai"

      depurar     = require("../src/Depurar")("Foo:BarBar")
      depurar.log = capture
      depurar "ohai"

      expect(captured[0]).to.match /95mFoo/
      expect(captured[1]).to.match /95mWhat/
      expect(captured[2]).to.match /93mFoo/
      done()

  describe "_getCallerPathFromTrace", ->
    it "should parse filename", (done) ->
      stackError = new Error
      Depurar    = require("../src/Depurar")
      filepath   = Depurar._getCallerPathFromTrace stackError
      exists     = fs.existsSync filepath
      expect(exists).to.equal true
      done()

  describe "_getColorFromNamespace", ->
    it "should get color index", (done) ->
      Depurar = require("../src/Depurar")
      color   = Depurar._getColorFromNamespace "Foo:Bar", [6, 5]
      expect(color).to.equal 6
      color   = Depurar._getColorFromNamespace "Foo:Bar", [6, 5, 4, 3]
      expect(color).to.equal 4
      color   = Depurar._getColorFromNamespace "Foo", [6, 5]
      expect(color).to.equal 5
      done()
