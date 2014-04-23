fs = require 'fs'
xml2js = require 'xml2js'
EventProxy = require 'eventproxy'
config = require('../config').config
Segment = require('segment').Segment

APPID = config.APPID
SECRET = config.SECRET
REDIRECT_URI = config.REDIRECT_URI
STATE = "ok"
# snsapi_base 只获取openid , snsapi_userinfo 获取用户信息
scope = "snsapi_base"
# scope = "snsapi_userinfo"
exports.index = (req,res,next)->
	code = req.body.code
	if code?
		res.render 'lottery'
	else
		res.redirect 'https://open.weixin.qq.com/connect/oauth2/authorize?appid='+APPID+'&redirect_uri='+REDIRECT_URI+'&response_type=code&scope='+scope+'&state='+STATE+'#wechat_redirect'

ACCESS_TOKEN_URL = "https://api.weixin.qq.com/sns/oauth2/access_token?appid="+APPID+"&secret="+SECRET+"&code={code}&grant_type=authorization_code"
exports.work = (req,res,next)->
	console.log req.query
	res.render 'lottery'