# User = require('../proxy').User 
# Ut = require '../lib/util'
# check = require('validator').check 
crypto = require 'crypto'
xml2js = require 'xml2js'
url = require 'url'
qs = require 'querystring'
BufferHelper = require 'bufferhelper'
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
	# console.log arr,arr.join ''
	shasum.digest('hex') is signature
getParse = (req)->
	query = url.parse(req.url).query
	qs.parse query
isEmpty = (thing)->
	typeof thing is "object" && (thing != null) && Object.keys(thing).length is 0
getMessage = (stream, callback)->
	buf = new BufferHelper()
	buf.load stream, (err,buf)->
		return callback err if err
		xml = buf.toString 'utf-8'
		xml2js.parseString xml, {trim:true} , callback
formatMessage = (result)->
	message = {}
	for key of result.xml
		val = result.xml[key][0]
		message[key] = (if isEmpty val then '' else val).trim()
	message

exports.index = (req,res,next)->
	parse = getParse req
	console.log req,req.body
	to = checkSignature parse,config.wechat_token
	# console.log to
	getMessage req, (err,result)->
		console.log err if err
		message = formatMessage result
		console.log message
	res.send if to then parse.echostr else "false"