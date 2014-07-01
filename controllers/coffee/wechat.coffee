# 为了方便,这里做个说明
# 这个文件是接收来自微信的请求
# 并不能主动发出
# 接收到消息后分析xml,并发送给中间键做分析,然后返回给微信.
# 

# 数据库
User = require('../proxy').User
Message = require('../proxy').Message
QAlist = require('../proxy').QAlist
OneTwo = require('../proxy').OneTwo


# 基本类库
fs = require 'fs'
path = require 'path'
crypto = require 'crypto'
xml2js = require 'xml2js'
url = require 'url'
qs = require 'querystring'
BufferHelper = require 'bufferhelper'
EventProxy = require 'eventproxy'
config = require('../config').config
Segment = require('segment').Segment

# 初始化分词
# 自定义分词文件路径
# fs.stat "./dicts/carnames.txt", (err,stat)->
# 	console.log err,stat,stat.isFIFO()
# console.log 
segWord = new Segment()
segWord.use('URLTokenizer')
.use('WildcardTokenizer')
.use('PunctuationTokenizer')
# // 中文单词识别
.use('DictTokenizer')
.use('ChsNameTokenizer')
# // 优化模块
.use('EmailOptimizer') 
.use('ChsNameOptimizer')
.use('DictOptimizer')
.use('DatetimeOptimizer') 
.use('ForeignTokenizer') 
# // 字典文件
.loadDict('dict.txt') 
.loadDict('dict2.txt')
.loadDict(path.resolve("./dicts/carnames.txt"))
.loadDict('names.txt')
.loadDict('wildcard.txt', 'WILDCARD', true)
#var md = require('showdown').Markdown



# 检查签名
checkSignature = (query, token)->
	signature = query.signature
	timestamp = query.timestamp
	nonce = query.nonce
	shasum = crypto.createHash 'sha1'
	arr = [token, timestamp, nonce].sort()
	shasum.update arr.join ''
	# console.log arr,arr.join ''
	shasum.digest('hex') is signature
getParse = (req)->
	query = url.parse(req.url).query
	qs.parse query
isEmpty = (thing)->
	typeof thing is "object" && (thing != null) && Object.keys(thing).length is 0
# 返回获取到的xml消息
getMessage = (stream, callback)->
	buf = new BufferHelper()
	buf.load stream, (err,buf)->
		return callback err if err
		xml = buf.toString 'utf-8'
		xml2js.parseString xml, {trim:true} , callback
formatMessage = (result)->
	message = {} 
	return false if not result
	for key of result.xml
		val = result.xml[key][0]
		message[key] = (if isEmpty val then '' else val).trim()
	message
# message信息分发. 这里应该是中间键的一个点.
# @codekit-append "wechat-process.coffee";
# @codekit-append "wechat-subscribe.coffee";
# @codekit-append "wechat-db-Operating.coffee";
# @codekit-append "wechat-qa.coffee";
# @codekit-append "wechat-special.coffee";
checkMessage = (message,callback)->
	# console.log message.MsgType
	switch message.MsgType
		when 'text'
			console.log '文字信息'
			# console.log '文字信息',message
			# Inser_db_text message
			# return getAnswer message.Content,message.FromUserName,callback if Special message.Content,message.FromUserName
			return getQA message.Content,message.FromUserName,callback
		when 'image'
			console.log '图片信息'
			# Inser_db_img message
			img = {
				name:"返回收到图片信息."
				key:"1"
				type:"text" 
				backContent: ""
			}
			callback img
			return img
			# return null
			# return tranStr message, go_img_process message.Content,callback
		when 'voice'
			# Recognition 开启语音识别,返回对应中文.
			console.log '声音信息'
			return null
			return tranStr message, go_process message.Recognition,callback
		when 'video'
			console.log '视频信息'
			return null
		when 'location'
			console.log '地理信息'
			return null
		when 'link'
			console.log '连接消息'
			return null

		when 'event'
			# subscribe 关注
			# unsubscribe 取消关注
			# CLICK 菜单点击
			# LOCATION 地利位置
			# console.log message.Event
			return go_subscribe message,callback if message.Event is 'subscribe'
			return null
	return null


# 信息接受位置 [first step]
# exports.index = getQA

exports.index = (req,res,next)->
	parse = getParse req
	backup = req.query.code
	# console.log req,req.body
	to = checkSignature parse,config.wechat_token
	# console.log to
	allDone = new EventProxy()
	allDone.all 'backMsg','message', (backMsg,message)->
		(return res.send if to then parse.echostr else "what?" ) if not message
		if backMsg?
			if backMsg.type is "text"
				backMsg.backContent = backMsg.random[Math.round(Math.random()*(backMsg.random.length-1))] if backMsg.random?
				res.render 'wechat-text',
					toUser:message.FromUserName
					fromUser:message.ToUserName
					date: new Date().getTime()
					content: backMsg.backContent

			if backMsg.type is 'news'
				console.log "news run"
				res.render 'wechat-news',
					toUser:message.FromUserName
					fromUser:message.ToUserName
					date: new Date().getTime()
					title:backMsg.title
					description:backMsg.description
					picurl:backMsg.picurl
					url:backMsg.url

			backMsg.evt message.FromUserName,backup if backMsg.evt?
		else
			res.render 'wechat-text',
				toUser:message.FromUserName
				fromUser:message.ToUserName
				date: new Date().getTime()
				content: ""

	getMessage req, (err,result)->
		console.log err if err
		# console.log result
		(return res.send if to then parse.echostr else "what?" ) if not result
		message = formatMessage result
		allDone.emit 'message', message
		# console.log "session:",user[message.FromUserName]

		checkMessage message, (back)->
			console.log "back To: ",back
			allDone.emit 'backMsg',back

		# console.log backMsg,backMsg.type,backMsg.backContent
		# console.log message.FromUserName,message.ToUserName
		

		# res.send if to then parse.echostr else "false"
exports.word = (req,res,next)->
	# 分词
	# console.log segWord.doSegment "我不想参加奥迪冰雪抽奖活动?"
	# word = segWord.doSegment "我想参与奥迪冰雪抽奖活动! http://www.baidu.com"
	word = segWord.doSegment "我叫李泓桥,我要预约试驾奥迪SQ5,我想三年之内买车."
	word.sort (a,b)->
		b.p-a.p
	console.log word
	res.send "contents"
	