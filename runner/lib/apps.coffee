fs = require 'fs'
path = require 'path'
_ = require 'underscore'

exports.list = {}

exports.initialize = (options, done) ->
  {appsDirectory} = options
  fs.readdir appsDirectory, (err,files) ->
    files = _.select(files, (file) -> file.indexOf('.') is -1)

    do pop = ->

      if files.length is 0
        done()
      else
        appName = file = files.pop()
        appDir = path.join appsDirectory, file
        fs.readdir appDir, (err,childFiles) ->
          if childFiles.indexOf('start.js') isnt -1 
            exports.list[appName] = 
              name: appName
              enabled: false
              directory: appDir
              content: ''
          pop()