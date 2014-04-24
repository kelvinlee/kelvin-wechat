# 数据库
Lottery = require('../proxy').Lottery
Lottery_x_list = require('../proxy').Lottery_x_list

# 基础类库
fs = require 'fs'
xml2js = require 'xml2js'
EventProxy = require 'eventproxy'
config = require('../config').config
Segment = require('segment').Segment
Ut = require('../lib/util')


APPID = config.APPID
SECRET = config.SECRET
REDIRECT_URI = config.REDIRECT_URI
STATE = "ok"
# snsapi_base 只获取openid , snsapi_userinfo 获取用户信息
scope = "snsapi_base"
# scope = "snsapi_userinfo"
ACCESS_TOKEN_URL = "https://api.weixin.qq.com/sns/oauth2/access_token?appid="+APPID+"&secret="+SECRET+"&code={code}&grant_type=authorization_code"

# 0423 翻牌抽奖流程

sumArr = (list)->
	r = 0
	for a in list
		r += parseInt a
	return r
getRandom = (min,max)->
	return Math.round(Math.random()*(max-min)+min)

fanpai = ()->
	lotlist = [30,70]
	$re = ''
	$proSum = sumArr lotlist
	for i in [0...lotlist.length]
		$randNum = getRandom 1,$proSum
		if $randNum <= lotlist[i]
			$re = i
			break
		else
			$proSum -= lotlist[i]
	return $re


exports.index = (req,res,next)->
	# code = req.body.code
	# if code?
	# 	res.render 'lottery'
	# else
	# 	res.redirect 'https://open.weixin.qq.com/connect/oauth2/authorize?appid='+APPID+'&redirect_uri='+REDIRECT_URI+'&response_type=code&scope='+scope+'&state='+STATE+'#wechat_redirect'

	code = req.query.code
	Lottery.getLotter code,(err,obj)->
		if obj? && obj.lottery?
			# 已经中奖了
			res.render 'lottery',{lots:true,code:code,lot:obj}
		else
			# 还没抽奖.
			res.render 'lottery',{lots:false,code:code,lot:{}}

	
exports.lotteryCode = (req,res,next)->
	# 抽奖逻辑: 
	# 首先查看是否已经抽奖过.
	# 然后获取随机奖品
	# 如果随机奖品中了有数量限制的奖品,查看数量是否已经够数了,如果已经没有空闲,返回很遗憾没有中奖.
	# 
	code = req.body.code
	num  = parseInt req.body.nums
	num = 3 if num > 3
	num = 1 if num < 1
	re = Ut.recode()
	Lottery.getLotter code,(err,obj)->
		if not obj?
			# code不存在.
			re.recode = 201
			re.reason = "nocode"
			res.send re
			return false
		if obj.lottery?
			# 已经中奖了
			re.recode = 202
			re.reason = "already have"
			res.send re
		else
			# 没有中奖
			lot = fanpai()
			if lot is 0
				Lottery.getLotterByLot 'cm',(err,list)->
					if list.length > 9
						# 奖品超标.
						obj.lottery = "none"
						obj.num =  num
						obj.save()
						re.reason = "none"
						res.send re
					else
						# 获得奖品.
						obj.lottery = "cm"
						obj.num =  num
						obj.save()
						re.reason = "cm"
						res.send re
			else
				console.log "card list"
				# 测试用,最后需要删除
				temp = Math.round Math.random()*(900000-100000)+100000
				obj.lottery = temp
				obj.num =  num
				obj.save()
				re.reason = temp
				res.send re
				return false
				Lottery_x_list.getList (err,card)->
					console.log err,card
					if card?
						# 存在充值卡
						obj.lottery = card.content
						obj.num =  num
						obj.save()
						re.reason = card.content
						res.send re
					else
						# 充值卡已经用光
						obj.lottery = "none"
						obj.num =  num
						obj.save()
						re.reason = "none"
						res.send re





exports.work = (req,res,next)->
	console.log req.query
	res.render 'lottery-work'