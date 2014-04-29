models = require '../models'
QAlist = models.QAlist

exports.checkhas = (openid, callback)->
  QAlist.findOne {openid:openid},null,{sort:{create_at:1}},callback 

exports.getall = (callback)->
	QAlist.find {}, callback

exports.saveNew = (openid,callback)->
	qa = new QAlist()
	qa.openid = openid
	qa.save callback

# exports.saveText = (openid, type, text, msgid, callback)->
#   text = new Message()
#   text.openid = openid
#   text.type = type
#   text.text = text
#   text.msgid = msgid
#   text.save callback