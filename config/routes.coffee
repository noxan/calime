module.exports = (app) ->
  index = require '../app/controllers/index'
  app.get '/', index.render

  photos = require '../app/controllers/photos'
  app.get '/photos/upload/', photos.upload
  app.post '/photos/upload/', photos.uploadPost
