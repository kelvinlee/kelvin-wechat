models = require '../models'
Admin = models.Admin

exports.getUserLogin = (name, passwd, callback)->
  Admin.findOne {username:name,password:passwd},null,{sort:{create_at:1}},callback 


exports.saveNew = (name,passwd,callback)->
	administrator = new Admin()
	administrator.username = name
	administrator.password = passwd
	administrator.save callback

# exports.saveText = (openid, type, text, msgid, callback)->
#   text = new Message()
#   text.openid = openid
#   text.type = type
#   text.text = text
#   text.msgid = msgid
#   text.save callback