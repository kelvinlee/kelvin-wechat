models = require '../models'
Message = models.Message

exports.getmsg = (callback)->
  Message.find {},null,{sort:{create_at:1}},callback 


exports.saveText = (openid, type, text, msgid, callback)->
  text = new Message()
  text.openid = openid
  text.type = type
  text.text = text
  text.msgid = msgid
  text.save callback
exports.saveImg = (openid, type, picurl, msgid, mediaid, callback)->
  img = new Message()
  img.openid = openid
  img.type = type
  img.picurl = picurl
  img.msgid = msgid
  img.mediaid = mediaid
  img.save callback