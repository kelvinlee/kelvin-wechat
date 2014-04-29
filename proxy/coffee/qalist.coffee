models = require '../models'
QAlist = models.QAlist

exports.checkhas = (openid, callback)->
  QAlist.findOne {openid:openid},null,{sort:{create_at:1}},callback 


exports.saveNew = (name,passwd,callback)->
	QAlist = new QAlist()
	QAlist.openid = openid
	QAlist.save callback

# exports.saveText = (openid, type, text, msgid, callback)->
#   text = new Message()
#   text.openid = openid
#   text.type = type
#   text.text = text
#   text.msgid = msgid
#   text.save callback