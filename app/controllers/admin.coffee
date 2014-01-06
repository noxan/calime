mongoose = require 'mongoose'
Photo = mongoose.model 'Photo'


exports.index = (req, res) ->
  res.render 'admin/index', {}

exports.photos = (req, res) ->
  Photo.find().sort('-created').exec (err, photos) ->
    if !err
      res.render 'admin/photos', {photos: JSON.stringify(photos)}
