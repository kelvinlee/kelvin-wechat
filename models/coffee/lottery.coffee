mongoose = require 'mongoose'
Schema = mongoose.Schema
config = require '../config'

LotterySchema = new Schema({
  randomcode: {type: String, index:true}
  lot: {type: String}
  lottery: {type: String, default: null}
  username: {type: String}
  mobile:{type: String}
  adr: {type: String}
  num: {type: Number, default: 0}
  lot_at: {type: Date}
  read: {type: Boolean}
  create_at: {type: Date, default:Date.now }
})

mongoose.model('Lottery', LotterySchema)