mongoose = require 'mongoose'
Schema = mongoose.Schema
config = require '../config'

AdminSchema = new Schema({
  username: {type: String}
  password: {type: String}
  create_at: {type: Date, default: Date.now }
})

mongoose.model('Admin', AdminSchema)