should  = require("chai").should()
expect  = require("chai").expect
path    = require "path"
util    = require "util"
fs      = require "fs"
Depurar = require "../src/Depurar"
debug   = require("debug")("Depurar:" + path.basename(__filename, path.extname(__filename)))

captured = ""
capture  = (args...) ->
  if args.length != 1
    throw new Error "console.log was called with less or more than 1 argument. that's not supported yet"

  for arg, i in args
    # Replace the duration with XX as this varies and makes things untestable
    args[i] = arg.replace /\d+ms/, "XXms"

  captured = args[0]

describe "Depurar", ->
  @timeout 10000 # <-- This is the Mocha timeout, allowing tests to run longer

  describe "constructor", ->
    it "should respect configured namespace Foo:Bar", (done) ->
      captured    = ""
      depurar     = Depurar "Foo:Bar"
      depurar.log = capture
      depurar "ohai"
      expect(captured).to.match /mFoo:Bar /
      done()

    it "should figure out namespace via stackstrace if left unconfigured", (done) ->
      captured    = ""
      depurar     = Depurar()
      depurar.log = capture
      depurar.useColors = false
      depurar "ohai"

      expect(captured).to.match /node\-depurar:mocha\-depurar ohai$/
      done()

    it "should make color dependent on second part of namespace", (done) ->
      captured          = ""
      depurar           = Depurar "Foo:Bar"
      depurar.log       = capture
      depurar.useColors = true
      depurar "ohai"
      expect(captured).to.match /35;1mFoo/

      captured          = ""
      depurar           = Depurar "What:Bar"
      depurar.log       = capture
      depurar.useColors = true
      depurar "ohai"
      expect(captured).to.match /35;1mWhat/

      captured          = ""
      depurar           = Depurar "Foo:BarBar"
      depurar.log       = capture
      depurar.useColors = true
      depurar "ohai"
      expect(captured).to.match /33;1mFoo/

      done()

  describe "_getCallerPathFromTrace", ->
    it "should parse filename", (done) ->
      stackError = new Error
      filepath   = Depurar._getCallerPathFromTrace stackError
      exists     = fs.existsSync filepath
      expect(exists).to.equal true
      done()

  describe "_getColorFromNamespace", ->
    it "should establish color index by name vs prevColor increment", (done) ->
      color   = Depurar._getColorFromNamespace "Foo:Bar", [6, 5]
      expect(color).to.equal 6
      color   = Depurar._getColorFromNamespace "Foo:Bar", [6, 5, 4, 3]
      expect(color).to.equal 4
      color   = Depurar._getColorFromNamespace "Foo", [6, 5]
      expect(color).to.equal 5
      done()

  describe "enabled", ->
    it "should dump objects by default", (done) ->
      tstObj =
        one:
          two:
            thee: "levels deep"

      captured          = ""
      depurar           = Depurar "Foo:Bar"
      depurar.log       = capture
      depurar.useColors = false
      depurar tstObj
      expect(captured).to.match /Foo:Bar { one: { two: { thee: 'levels deep' } } }$/
      done()
