mongoose = require 'mongoose'
Schema = mongoose.Schema
config = require '../config'

QAlistSchema = new Schema({
  openid: {type: String, index:true}
  lot: { type: String }
  name: {type: String , default: ""}
  mobile: {type: String, default: ""}
  backup: {type: String, default: "test"}
  create_at: {type: Date, default:Date.now }
})

mongoose.model('QAlist', QAlistSchema)