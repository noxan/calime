fs = require 'fs'
express = require 'express'
mongoose = require 'mongoose'
config = require './config/config'


db = mongoose.connect(config.db)

models_path = __dirname + "/app/models"
walk = (path) ->
  fs.readdirSync(path).forEach (file) ->
    newPath = path + "/" + file
    stat = fs.statSync(newPath)
    if stat.isFile()
      require newPath  if /(.*)\.(js$|coffee$)/.test(file)
    else walk newPath  if stat.isDirectory()


walk models_path


app = express()

require('./config/express')(app)

require('./config/routes')(app)

app.listen app.get('port')
console.log "Server started on port " + app.get('port')
