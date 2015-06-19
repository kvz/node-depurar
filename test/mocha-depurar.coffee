should = require("chai").should()
util   = require "util"
expect = require("chai").expect

describe "Depurar", ->
  @timeout 10000 # <-- This is the Mocha timeout, allowing tests to run longer

  describe "constructor", ->
    it "should set last item", (done) ->
      debug = require("../src/Depurar")()
      debug "Hi"
