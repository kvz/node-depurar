exec   = require("child_process").exec
fs     = require "fs"
util   = require "util"
debug  = require("debug")("tla:upgrade-modules")
async  = require "async"
_      = require "underscore"
Airbud = require "airbud"

class Upgrader
  constructor: (mixin) ->
    @tmpDir    = "/tmp"
    @filePath  = "#{@tmpDir}/np-module-upgrade.txt"
    @appRoot   = "#{__dirname}/.."
    @userAgent = "node version updater change log"
    @changelog = {}

    _.extend this, mixin

  run: () ->
    async.series [
      @storeProposals.bind(this)
      @checkProposals.bind(this)
      @showChangelogs.bind(this)
    ], (err, results) ->
      if err
        throw err

      debug "Done. "
      process.exit 0


  storeProposals: (cb) ->
    child = exec "#{@appRoot}/node_modules/.bin/npm-check-updates #{@appRoot} |grep 'can be updated' > #{@filePath}", (error, stdout, stderr) ->
      if error
        return cb error + ". " + stderr

      cb null, stdout

  checkProposals: (cb) ->
    q = async.queue @_readPackageJson.bind(this), 4

    fs.readFile @filePath, "utf-8", (err, buf) =>
      if err
        return cb err

      if buf.trim().length == 0
        return cb new Error "No upgrade proposals found. Consider doing a store first. "

      for line in buf.trim().split "\n"
        m = line.match /"([a-z0-9_]+)" can be updated from (\S+) to (\S+)/
        if !m
          continue

        module = m[1]
        from   = @_cleanVersion m[2]
        to     = @_cleanVersion m[3]

        item =
          module:module
          from  :from
          to    :to

        debug util.inspect
          item: item
        q.push item

      q.drain = cb

  showChangelogs: (cb) ->
    for module, props of @changelog
      console.log " --> #{module} from #{props.from} to #{props.to}"
      for commit in props.commits
        for line, i in commit.message.trim().split "\n"
          if i == 0
            str = "   - "
          else
            str = "     "

          str += line

        console.log str

      console.log "\n"
    cb()

  _readPackageJson: (item, cb) ->
    { module, to, from } = item
    fs.readFile "#{@appRoot}/node_modules/#{module}/package.json", "utf-8", (err, buf) =>
      if err
        debug err
        return cb err

      q = async.queue @_fetchGitHubCompare.bind(this), 1

      pkg = JSON.parse buf
      if pkg.repository.type == "git"
        repo = pkg.repository.url
        repo = repo.replace /^\w+:\/\//, ""
        repo = repo.replace /^(www\.)?github\.com/, ""
        repo = repo.replace /\.git$/, ""

        q.push
          module: module
          to    : to
          from  : from
          url   : "https://api.github.com/repos#{repo}/compare/v#{from}...v#{to}"

        q.push
          module: module
          to    : to
          from  : from
          url   : "https://api.github.com/repos#{repo}/compare/#{from}...#{to}"

      q.drain = ->
        cb()

  _fetchGitHubCompare: (item, cb) ->
    { url, module, to, from } = item
    cachePath = "#{@tmpDir}/np-module-#{module}-#{from}-#{to}.json"

    if fs.existsSync cachePath
      url = "file://#{cachePath}"

    opts =
      retries     : 0
      expectedKey : "commits"
      url         : url
      headers     :
        "user-agent": @userAgent

    # debug opts.url

    Airbud.json opts, (err, data, meta) =>
      if err
        debug "#{err}"
        return cb()

      fs.writeFileSync cachePath, JSON.stringify(data)

      commits = (commit.commit for commit in data.commits)
      @changelog[module] =
        from   : from
        to     : to
        commits: commits

      cb()

  _cleanVersion: (version) ->
    version = version.replace /[^\d\.]/g, ""
    return version

upgrader = new Upgrader

upgrader.run()
