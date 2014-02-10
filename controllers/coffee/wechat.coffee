# User = require('../proxy').User 
# Ut = require '../lib/util'
# check = require('validator').check 
crypto = require 'crypto'
xml2js = require 'xml2js'
url = require 'url'
EventProxy = require 'eventproxy'
config = require('../config').config


#var md = require('showdown').Markdown

# 检查签名
checkSignature = (query, token)->
	signature = query.signature
	timestamp = query.timestamp
	nonce = query.nonce
	shasum = crypto.createHash 'sha1'
	arr = [token, timestamp, nonce].sort()
	shasum.update arr.join ''
	shasum.digest('hex') is signature

exports.index = (req,res,next)->
	console.log url.parse(req.url).query
	query = url.parse(req.url).query
	console.log query.a
	res.send checkSignature url.parse(req.url).query,config.wechat_token