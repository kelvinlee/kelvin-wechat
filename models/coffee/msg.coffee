mongoose = require 'mongoose'
Schema = mongoose.Schema
config = require '../config'
ObjectId = Schema.ObjectId

MsgSchema = new Schema
  openid: { type: String }
  type: {type: String, default: "text"}
 	
  text: {type: String, default: null}
  msgid: {type: Number, default: 0}
  picurl: {type:String, default: null}
  mediaid: {type: String, default: null}
  checked: {type: Boolean, default: null}
  create_at: {type: Date, default: new Date()}

mongoose.model 'Msg', MsgSchema