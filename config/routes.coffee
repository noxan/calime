module.exports = (app) ->
  index = require '../app/controllers/index'
  app.get '/', index.render

  photos = require '../app/controllers/photos'
  app.get '/photos/', photos.all
  app.get '/photos/upload/', photos.upload
  app.post '/photos/upload/', photos.uploadPost

  admin = require '../app/controllers/admin'
  app.get '/admin/', admin.index
  app.get '/admin/photos/', admin.photos
