express = require 'express'
helpers = require('view-helpers')
config = require './config'


module.exports = (app) ->
  app.set 'views', config.root + '/app/views/'
  app.set 'view engine', 'jade'

  app.set 'port', config.port

  app.use helpers(config.app.name)

  app.use express.urlencoded()
  app.use express.json()

  app.use app.router

  app.use express.static(config.root + '/public')
