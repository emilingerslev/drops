apps = require('./apps').list
child_process = require 'child_process'

module.exports =

  status: (socket) ->
    data = {}
    socket.emit 'status', apps: for name, x of apps
      name: name
      enabled: x.enabled
      content: x.content

  enable: (socket, appName) ->
    x = apps[appName]
    x.content = ''
    x.enabled = true
    x.cmd = cmd = child_process.spawn('node.exe', ["start.js"], cwd: x.directory)

    console.log('Spawned child pid: ' + cmd.pid)
    @status(socket)

    cmd.stdout.on 'data', (data) ->
      x.content = x.content + data
      socket.emit 'output', 
        content: x.content
        name: x.name
    cmd.stderr.on 'data', (data) ->
      x.content = x.content + "\nErr: " + data
      socket.emit 'output', 
        content: x.content
        name: x.name

  disable: (socket, appName) ->
    x = apps[appName]

    x.enabled = false

    x.cmd.kill()
    x.cmd = null
    
    @status(socket)