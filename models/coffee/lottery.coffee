mongoose = require 'mongoose'
Schema = mongoose.Schema
config = require '../config'

LotterySchema = new Schema({
  randomcode: {type: String, index:true}
  lottery: {type: String, default: null}
  num: {type: Number, default: 0}
  create_at: {type: Date, default:Date.now }
})

mongoose.model('Lottery', LotterySchema)