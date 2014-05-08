mongoose = require 'mongoose'
Schema = mongoose.Schema
config = require '../config'

OneTwoSchema = new Schema({
  openid: {type: String, index:true}
  lot: {type: String}
  username: {type: String}
  mobile: {type: String}
  adr: {type: String}
  talk: {type: String}
  checked: {type: Boolean , default: false }
  create_at: {type: Date, default:Date.now }
})

mongoose.model('OneTwo', OneTwoSchema)