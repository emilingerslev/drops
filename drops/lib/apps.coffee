q = require 'q'
fs = require 'fs'
path = require 'path'
_ = require 'underscore'
child_process = require 'child_process'
watchr = require('watchr')

class Apps extends require('events').EventEmitter

  list: {}

  addWatcher: (appsDirectory) ->
    watchr.watch
      paths: [appsDirectory]
      listeners:
        log: (logLevel) ->
          # console.log('a log message occured:', arguments)
        error: (err) ->
          # console.log('an error occured:', err)
        watching: (err,watcherInstance,isWatching) ->
          if (err)
            # console.log("watching the path " + watcherInstance.path + " failed with error", err);
          else
            # console.log("watching the path " + watcherInstance.path + " completed");
        change: (changeType,filePath,fileCurrentStat,filePreviousStat) ->
          relative = filePath.replace(appsDirectory + '\\', '')
          appname = path.dirname(relative)
          app = @getApp appname
          if app
            if app.enabled
              @stopApp appname
              @startApp appname
            else
              console.log('App not started:', appname)
          else
            console.log('App not found:', appname)

        
      next: (err,watchers) -> 
        if (err)
          # console.log("watching everything failed with error", err)
        else
          # console.log('watching everything completed', watchers)
        # Close watchers after 60 seconds
        # setTimeout () ->
        #   console.log('Stop watching our paths')
        #   for watcher in watchers
        #     watchers[i].close()
        # , 60*1000

  initialize: (options) ->
    defered = q.defer()
    {appsDirectory} = options
    console.log "AppDirectory: #{appsDirectory}"
    fs.readdir appsDirectory, (err,files) =>
      files = _.select(files, (file) -> file.indexOf('.') is -1)
      do pop = =>

        if files.length is 0
          console.log "Apps found: #{(name for name,config of @list).join(', ')}"
          @addWatcher(appsDirectory, @)
          @emit('ready')
          for app,config of @list
            if config.data?.autoStart
              @startApp config.name
          defered.resolve()
        else
          appName = file = files.pop()
          appDir = path.join appsDirectory, file
          fs.readdir appDir, (err,childFiles) =>
            if childFiles.indexOf('drops.json') isnt -1 
              fs.readFile path.join(appDir,'drops.json'), encoding: 'UTF-8', (err, json) =>
                throw err if err                
                @list[appName] = 
                  name: appName
                  enabled: false
                  directory: appDir
                  content: ''
                  lines: 1000
                  data: JSON.parse(json)
                pop()
            else
              pop()
    defered.promise



  getApps: () ->
    for name, app of @list
      name: name
      enabled: app.enabled
      content: app.content
      id: app.cmd?.pid

  getApp: (appName) ->
    @list[appName]

  status: ->
    @emit 'status', apps: @getApps()

  stopApp: (appName) ->
    console.log "Stopping app: #{appName}"
    app = @getApp appName
    app.enabled = false
    return unless app.cmd
    app.cmd.kill()
    app.cmd = null
    @status()

  startApp: (appName) ->
    app = @getApp appName
    console.log "Starting app: #{appName}"
    app.cmd = cmd = child_process.spawn('node.exe', ["start.js"], cwd: app.directory)
    app.content = ''
    app.enabled = true

    cmd.on 'error', (err) =>
      console.log "App error'd: #{appName}"
      @stopApp(appName)

    cmd.on 'exit', (err) =>
      console.log "App exited: #{appName}" 
      if not app.cmd
        app.enabled = false
        @status()
      #@stopApp(appName)

    console.log('Spawned child pid: ' + cmd.pid)

    shorten = (content, lines) ->
      new RegExp("[^\\n]*(\\n[^\\n]*){0,#{lines-1}}$").exec(content)[0]

    cmd.stdout.on 'data', (data) =>
      app.content = shorten(app.content + data, app.lines)
      @emit 'appstatus', 
        content: app.content
        name: app.name
      # @emit 'status:' + appName, 
      #   content: app.content
      #   name: app.name
        
    cmd.stderr.on 'data', (data) =>
      app.content = shorten(app.content + "\nErr: " + data, app.lines)
      @emit 'appstatus', 
        content: app.content
        name: app.name
      # @emit 'status:' + appName, 
      #   content: app.content
      #   name: app.name

    @status()
      
module.exports = new Apps()