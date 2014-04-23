mongoose = require 'mongoose'
Schema = mongoose.Schema
config = require '../config'

UserSchema = new Schema({
  openid: {type: String, index: true},
  nickname: {type: String}
  sex : {type: Number}
  province: {type: String}
  city: {type:String}
  headimgurl: {type:String}
})


mongoose.model('User', UserSchema)