# 数据库
Admin = require('../proxy').Admin
Lottery = require('../proxy').Lottery


# 基础类库
fs = require 'fs'
path = require 'path'
url = require 'url'
Ut = require('../lib/util')

EventProxy = require 'eventproxy'
config = require('../config').config



exports.before = (req,res,next)->
	# check 管理员是否登录
	# console.log req.session.is_admin,req.cookies.user
	if req.session.is_admin && req.cookies.user
		res.locals.avatar = Ut.avatar req.session.email,26
		res.locals.username = req.session.username
		res.locals.userid = req.session.userid
		next()
	# else if req.cookies.user
	else
		res.redirect '/sign/in'
	no
randomStr = ['giccoo','samsung','kelvin','galaxy s5','bob','testforsamsung']
exports.randomCode = (req,res,next)->

	re = Ut.recode()
	randomCode = 'sx'
	randomCode += randomStr[Math.round(Math.random()*5)]
	randomCode += Math.round Math.random()*(10)
	randomCode += new Date().getTime()
	randomCode = Ut.md5 randomCode
	console.log randomCode
	Lottery.create randomCode,(err,obj)->
		# console.log err,obj
		re.reason = obj.randomcode
		res.send re

exports.homepage = (req,res,next)->
	# 
	res.render 'admin/homepage',{sharecontent:config.sharecontent}

exports.question = (req,res,next)->
	
	res.render 'admin/question'


exports.signin = (req,res,next)->
	# 
	res.render 'admin/admin-login'
exports.signpost = (req,res,next)->
	name = Ut.strim req.body.username
	passwd = Ut.strim req.body.password
	re = Ut.recode()
	if Ut.empty passwd
		re.reason = 'empty password'
		re.recode = 201
	if Ut.empty name
		re.reason = 'empty username'
		re.recode = 201
	# Admin.saveNew name,passwd, (err,obj)->
	# 	console.log err,obj
	# res.send re
	# return no
	if re.recode is 200
		Admin.getUserLogin name,passwd, (err,obj)->
			if err
				console.log err
				re.reason = 'empty username'
				re.recode = 201
			else
				# console.log obj
				if obj?
					user = Ut.encrypt obj._id+'\t'+obj.name,'giccoo'
					day = 1000 * 60 * 60 * 24 * 7
					res.cookie 'user',user ,{expires: new Date Date.now()+60*60*24*7,maxAge: day}
					req.session.is_admin = true
				else
					re.reason = 'none'
					re.recode = 201
			res.send re
		return no
	else
		res.send re
	
