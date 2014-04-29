mongoose = require 'mongoose'
Schema = mongoose.Schema
config = require '../config'
ObjectId = Schema.ObjectId

BackSendSchema = new Schema
  openid: { type: ObjectId }
  create_at: {type: Date, default: new Date()}

mongoose.model 'BackSend', BackSendSchema