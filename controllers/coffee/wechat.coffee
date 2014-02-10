# User = require('../proxy').User 
# Ut = require '../lib/util'
# check = require('validator').check 
crypto = require 'crypto'
xml2js = require 'xml2js'
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
	console.log req.body
	res.send checkSignature req.body,config.wechat_token