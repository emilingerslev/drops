express = require 'express'
engines = require 'consolidate'

exports.startServer = (config, callback) ->

  port = process.env.PORT or config.server.port

  app = express()
  server = app.listen port, ->
    console.log "Express server listening on port %d in %s mode", server.address().port, app.settings.env  

  app.configure ->
    app.set 'port', port
    app.use express.favicon()
    app.use express.urlencoded()
    app.use express.json()
    app.use express.methodOverride()
    app.use express.compress()
    app.use express.static(config.watch.compiledDir)

  app.configure 'development', ->
    app.use express.errorHandler()

  app.get '/ClientBin/*', (req, res) ->
    

  app.get '*', (req, res) ->
    res.sendFile('ClientBin/PTS.Backend.Client.Shell.xap') 
    #res.sendFile('www/index.html') 


  callback(server)