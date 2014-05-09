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

_lotlist = ["card","cm"]
fanpai = ()->
	lotlist = [99999,1]
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
			# 没有中奖,开始抽奖
			lot = fanpai()
			# 如果是 1 就是车模
			# 先去仓库(Lottery_x_list)查找车模是不是还有,如果没有改送充值卡.
			# 如果充值卡也没有了,就没有中奖.
			# epall = new EventProxy()
			# if lot is 1
			# Lottery_x_list.create "TEST2","card", (err,obj)->
			# 	console.log "test list:",err,obj
			console.log "lot is :",_lotlist[lot]
			Lottery_x_list.getLottery _lotlist[lot], (err,lot_obj)->
				console.log err,lot_obj
				if lot_obj?
					obj.lottery = lot_obj.content
					obj.num = num
					obj.lot_at = new Date()
					obj.save()
					lot_obj.used = true
					lot_obj.usedby = code
					lot_obj.save()
					re.reason = lot_obj.content
					res.send re
				else
					Lottery_x_list.getLottery "card", (err,lot_obj2)->
						obj.lottery = lot_obj2.content
						obj.num = num
						obj.lot_at = new Date()
						obj.save()
						lot_obj2.used = true
						lot_obj2.usedby = code
						lot_obj2.save()
						re.reason = lot_obj2.content
						res.send re
						
						# obj.lottery = "none"
						# obj.num =  num
						# obj.lot_at = new Date()
						# obj.save()
						# re.reason = "none"
						# res.send re



exports.work = (req,res,next)->
	console.log req.query
	res.render 'lottery-work'