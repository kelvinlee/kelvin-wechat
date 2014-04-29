
# 将文字内容插入到数据库
Inser_db_text = (db)->
	Message.saveText db.FromUserName,db.MsgType,db.Content,db.MsgId, (err)->
		console.log "text back:",err
# 将图片内容插入到数据库
Inser_db_img = (db)->
	Message.saveImg db.FromUserName,db.MsgType,db.PicUrl,db.MsgId,db.MediaId, (err)->
		console.log "text back:",err

# 题目均答对的用户存入数据库
Inser_db_qauser = (openid)->
	QAlist.saveNew openid, (err,obj)->
		console.log "录入成功"
Get_db_qauser = ()->
	QAlist.getall (err,list)->
		console.log "QA: ",err,list