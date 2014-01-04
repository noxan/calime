module.exports = (app) ->
  index = require '../app/controllers/index'
  app.get '/', index.render
