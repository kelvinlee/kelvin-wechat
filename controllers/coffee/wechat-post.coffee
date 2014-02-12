# 这个文件的作用
# 主要是发送给微信后台接口
# 获取token值,定期更新.
# 
https = require 'https'
url = require 'url'
querystring = require 'querystring'

access_token = {}

options_create_menu = 
	host : "https://api.weixin.qq.com/cgi-bin/menu/create?access_token="
	method: 'POST'

options_get_menu = 
	host : "https://api.weixin.qq.com/cgi-bin/menu/get?access_token="
	method: 'GET'

options_get_access_token = 
	host : "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=wx86b8da13792d7a54&secret=f93ec247a40c59eccbf4bc8b5ac5721c"
	method : 'GET'

post_data = 
	button:[
		{
			type:"click"
			name:"今日歌曲"
			key:"MUSIC"
		},
		{
			type:"click"
			name:"歌手简介"
			key:"SINGER"
		}
	]
checkToken = (callback)->
	if access_token.date && access_token.date > new Date().getTime()
		callback false
		return yes
	else
		getToken callback
		return false

getToken = (callback)->
	request = https.get options_get_access_token.host,(result)->
		console.log 'STATUS: '+result.statusCode
		console.log 'HEADERS: '+JSON.stringify result.headers
		result.setEncoding 'utf8'
		result.on 'data', (chunk)->
			console.log 'BODY: '+chunk
			obj = JSON.parse chunk
			if obj.access_token
				access_token = obj
				access_token.date = new Date().getTime()+obj.expires_in*1000
				callback false
			else
				callback 'There is no token'
	request.write '\n'
	request.end()

sendMenus = ->
	u = url.parse options_create_menu.host
	p = if u['port'] then u['port'] else 80
	op = 
		hostname: u['host']
		port: 443
		path: u['path']+access_token.access_token
		method: 'POST'
	console.log op,p
	request = https.request op, (res)->
		console.log "statusCode: ",res.statusCode
		console.log "headers: ",res.headers

		res.on 'data', (chunk)->
			obj = JSON.parse chunk
			console.log obj
	request.write JSON.stringify(post_data)+'\n'
	request.end()
checkMenus = -> 
	request = https.get options_get_menu.host+access_token.access_token, (res)->
		console.log "statusCode: ",res.statusCode
		console.log "headers: ",res.headers

		res.on 'data', (chunk)->
			obj = JSON.parse chunk
			console.log obj
	request.write '\n'
	request.end()
exports.gettoken = (req,res,next)->
	
	checkMenus()
	# res.send 'ok!'
	res.render 'wechat-ctrl'
exports.getmenu = (req,res,text)->
	console.log new Date().getTime(),access_token.date
	# res.send 'ok!!!'
	checkToken (err)->
		return false if err
		sendMenus()
		res.render 'wechat-ctrl'