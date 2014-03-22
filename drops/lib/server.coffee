q = require('q')
express = require 'express'
socketio = require 'socket.io'
commands = require './commands'
apps = require './apps'
walls = require './walls'

io = null
app = null
server = null

exports.start = (options) ->
  {port} = options 

  app = express()
  server = app.listen port, ->
    console.log "Express server listening on port %d in %s mode", server.address().port, app.settings.env

  io = socketio.listen(server, 'log level': 1)
  app.configure ->
    app.set 'port', port
    app.use express.favicon()
    app.use express.urlencoded()
    app.use express.json()
    app.use express.methodOverride()
    app.use express.compress()
    app.use app.router

  io.sockets.on 'connection', (socket) ->
    apps.on 'status', (data) ->
      socket.emit 'status', data 

    apps.on 'appstatus', (data) ->
      socket.emit 'status:' + data.name, data 

    walls.on 'wall-update', (data) ->
      socket.emit 'wall-update', data 

    apps.status()
    walls.status()

    socket.on 'enable', (data) ->
      apps.startApp data.appName

    socket.on 'disable', (data) ->
      apps.stopApp data.appName 

  app.configure 'development', ->
    app.use express.errorHandler()

    #app.get '/', routes.index(config)
