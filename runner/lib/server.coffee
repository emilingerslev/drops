express = require 'express'
socketio = require 'socket.io'
commands = require './commands'

io = null
app = null
server = null

exports.start = (options) ->

  {port} = options 

  app = express()
  server = app.listen port, ->
    console.log "Express server listening on port %d in %s mode", server.address().port, app.settings.env

  io = socketio.listen(server)
  app.configure ->
    app.set 'port', port
    app.use express.favicon()
    app.use express.urlencoded()
    app.use express.json()
    app.use express.methodOverride()
    app.use express.compress()
    app.use app.router

  io.sockets.on 'connection', (socket) ->
    commands.status(socket)

    socket.on 'enable', (data) ->
      commands.enable socket, data.appName

    socket.on 'disable', (data) ->
      commands.disable socket, data.appName

  app.configure 'development', ->
    app.use express.errorHandler()

    #app.get '/', routes.index(config)
