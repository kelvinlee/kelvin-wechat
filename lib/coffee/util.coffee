# xss = require 'xss'
validator = require('validator')
crypto = require 'crypto'

exports.format_date = (date, friendly)->
	year = date.getFullYear()
	month = date.getMonth() + 1
	day = date.getDate()
	hour = date.getHours()
	minute = date.getMinutes()
	second = date.getSeconds()
	if friendly
		now = new Date()
		mseconds = -(date.getTime() - now.getTime())
		time_std = [ 1000, 60 * 1000, 60 * 60 * 1000, 24 * 60 * 60 * 1000 ]
		if mseconds < time_std[3]
			return Math.floor(mseconds / time_std[0]).toString() + ' 秒前' if mseconds > 0 && mseconds < time_std[1]
			return Math.floor(mseconds / time_std[1]).toString() + ' 分钟前' if mseconds > time_std[1] && mseconds < time_std[2]
			return Math.floor(mseconds / time_std[2]).toString() + ' 小时前' if mseconds > time_std[2]

	month = (if month<10 then '0' else '') + month;
	day = (if day<10 then '0' else '') + day;
	hour = (if hour<10 then '0' else '') + hour
	minute = (if minute<10 then '0' else '') + minute
	second = (if second<10 then '0' else '') + second
	thisYear = new Date().getFullYear()
	year = (thisYear is year) ? '' : (year + '-')
	year + month + '-' + day + ' ' + hour + ':' + minute
# 
# Escape the given string of `html`.
# 
# @param {String} html
# @return {String}
# @api private
# 
exports.escape = (html)->
	codeSpan = /(^|[^\\])(`+)([^\r]*?[^`])\2(?!`)/gm;
	codeBlock = /(?:\n\n|^)((?:(?:[ ]{4}|\t).*\n+)+)(\n*[ ]{0,3}[^ \t\n]|(?=~0))/g;
	spans = [];
	blocks = [];
	text = String(html).replace(/\r\n/g, '\n').replace('/\r/g', '\n')
	text = '\n\n' + text + '\n\n'
	text = text.replace codeSpan,(code)->
		spans.push code
		'span'
	text += '~0'
	text.replace codeBlock,(whole, code, nextChar)->
		blocks.push code
		'\n\tblock' + nextChar
		.replace(/&(?!\w+;)/g, '&amp;')
		.replace(/</g, '&lt;')
		.replace(/>/g, '&gt;')
		.replace(/"/g, '&quot;')
		.replace /`span`/g, ->
			spans.shift()
		.replace /\n\tblock/g, ->
			blocks.shift() 
		.replace(/~0$/, '')
		.replace(/^\n\n/, '')
		.replace(/\n\n$/, '')


# 
# 过滤XSS攻击代码
# 
# @param {string} html
# @return {string}
# 
# exports.xss = (html)->
#   xss html
#
# 去空和过滤
#
# @param {string}
# @return {string}
#
exports.strim = (str)-> 
	return validator.trim(str)
#
# 接口基本格式
#
# @param none
# @return json
#
exports.recode = ->
	{recode:200,reason:'success'}
#
# 接口基本格式
#
# @param {obj/string/number}
# @return string
#
exports.str = (str)->
	str+""
#
# 查看是否为空
#
# @param {string}
# @return {bool}
#
empty = (str)->
	return yes if typeof str is 'undefined'
	return yes if str is ''
	return yes if str.length<=0
	return no
exports.empty = empty
#
# MD5加密
#
# @param {string}
# @return {string}
#
md5 = (str)->
	md5sum = crypto.createHash 'md5'
	md5sum.update str
	str = md5sum.digest 'hex'
	return str
exports.md5 = md5
#
# 加密字符串
#
# @param {string}
# @return {string}
#
encrypt = (str, secret)->
	cipher = crypto.createCipher 'aes192', secret
	enc = cipher.update str, 'utf8', 'hex'
	enc += cipher.final 'hex'
	return enc
exports.encrypt = encrypt

#
# 解密字符串
#
# @param {string}
# @return {string}
#
decrypt = (str, secret)->
	decipher = crypto.createDecipher 'aes192', secret
	dec = decipher.update str, 'hex', 'utf8'
	dec += decipher.final 'utf8'
	return dec
exports.decrypt = decrypt

#
# 解密字符串
#
# @param {string}
# @return {string}
#
exports.gen_session = (user, res)->
  auth_token = encrypt user._id + '\t' + user.name + '\t' + user.pass + '\t' + user.email, config.session_secret
  #cookie 有效期30天
  day = 1000 * 60 * 60 * 24 * 30
  res.cookie config.auth_cookie_name, auth_token, {path: '/', maxAge: day} 

#
# 获取头像地址
#
# @param {string},{string}
# @return {string}
#
avatar = (email, size = 48)->
	default_avatar = "http://f.giccoo.com/img/user.jpg"
	email = email+""
	url = "http://www.gravatar.com/avatar/"+md5(email.toLowerCase())+"?d="+default_avatar+"&s="+size
	return url
exports.avatar = avatar