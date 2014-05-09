mongoose = require 'mongoose'
Schema = mongoose.Schema
config = require '../config'

Lottery_x_listSchema = new Schema({
  content: {type: String}
  used: {type: Boolean, default: false}
  usedby: {type: String}
  create_at: {type: Date, default:Date.now }
})

mongoose.model('Lottery_x_list', Lottery_x_listSchema)