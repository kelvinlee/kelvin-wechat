# User = require('../proxy').User 
# Ut = require '../lib/util'
# check = require('validator').check 
crypto = require 'crypto'
xml2js = require 'xml2js'
url = require 'url'
qs = require 'querystring'
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
	console.log arr,arr.join ''
	shasum.digest('hex') is signature
getParse = (req)->
	query = url.parse(req.url).query
	JSON.stringify qs.parse query

exports.index = (req,res,next)->
	console.log getParse req
	parse = getParse req
	to = checkSignature parse,config.wechat_token
	console.log to
	res.send to