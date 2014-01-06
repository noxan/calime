mongoose = require 'mongoose'


PhotoSchema = new mongoose.Schema(
  created:
    type: Date
    default: Date.now
  filename:
    type: String
)

mongoose.model 'Photo', PhotoSchema
