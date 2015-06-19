should = require("chai").should()
expect = require("chai").expect
path   = require "path"
util   = require "util"
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
    it "Should respect configured namespace Foo:Bar", (done) ->
      captured    = []
      depurar     = require("../src/Depurar")("Foo:Bar")
      depurar.log = capture
      depurar "ohai"
      expect(captured[0]).to.match /mFoo:Bar /
      done()

    it "Should figure out namespace if unconfigured", (done) ->
      captured    = []
      depurar     = require("../src/Depurar")()
      depurar.log = capture
      depurar "ohai"

      expect(captured[0]).to.match /mnode\-depurar:mocha\-depurar /
      done()

    it "Should make color dependent on second part of namespace", (done) ->
      captured    = []

      depurar     = require("../src/Depurar")("Foo:Bar")
      depurar.log = capture
      depurar "ohai"

      depurar     = require("../src/Depurar")("What:Bar")
      depurar.log = capture
      depurar "ohai"

      depurar     = require("../src/Depurar")("Foo:What")
      depurar.log = capture
      depurar "ohai"

      expect(captured[0]).to.match /95mFoo/
      expect(captured[1]).to.match /95mFoo/
      expect(captured[2]).to.match /95mFoo/
      done()
