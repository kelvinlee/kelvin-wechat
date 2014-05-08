mySpecial = []

Special = (text,id)->
	if text is '我的奖品9988877'
		return true
	else if mySpecial[id] is "phone"
		return true
	else
		return false

getAnswer = (text,id,callback)->
	if mySpecial[id] is "phone"
		# 需要将用户回复的中奖信息储存起来.
		str = text
		return callback _special.onetwoerror[3] if text.split(",").length <= 2
		username = text.split(",")[0]
		mobile = text.split(",")[1]
		adr = text.replace username+",",""
		adr = adr.replace mobile+",",""

		# return callback _special.onetwoerror[0] if username?
		return callback _special.onetwoerror[1] if mobile.length isnt 11


		OneTwo.getLottery id,"samsung", (err,obj)->
			# callback _special.onetwo[4]
			console.log obj
			if obj 
				obj.username = username
				obj.mobile = mobile
				obj.adr = adr
				obj.talk = text
				obj.checked = true
				obj.save()
				callback _special.onetwo[4]
				# 清理内存.
				delete mySpecial[id]
			else
				callback _special.onetwo[1]
		
	else
		console.log "start read db",id
		# OneTwo.newAndSave id,"discounts", (err,obj)->
		# 	console.log "save: ",err,obj
		# return ''
		OneTwo.getLottery id,"samsung", (err,obj)->
			# console.log "callback: ",err,obj
			if obj
				# mySpecial[id] = "get"
				# callback _special.onetwo[1]
				if obj.lot is "phone"
					mySpecial[id] = "phone"
					bk = _special.onetwo[3] 
					console.log bk
					callback bk
				else if obj.lot is "discounts"
					bk = _special.onetwo[5]
					bk.backContent = bk.backContent.replace '#key',obj.username
					console.log bk
					obj.checked = true
					obj.talk = text
					obj.save()
					callback bk
				else
					bk = _special.onetwo[2]
					bk.backContent = bk.backContent.replace '#key',obj.lot
					console.log bk
					obj.checked = true
					obj.talk = text
					obj.save()
					callback bk
			else
				callback _special.onetwo[1]


_special =
	onetwo : [
		{
			name:"onetwo 活动将资料发送后回复."
			key:"1"
			type:"text"
			backContent :"您的资料,我们已经收到,会尽快与您联系."
		}
		{
			name:"很抱歉,您没有中奖,欢迎您继续参加我们的活动,下次活动可能您就中奖了."
			key:"2"
			type:"text"
			backContent:"很抱歉,您没有中奖,欢迎您继续参加我们的活动,下次活动可能您就中奖了."
		}
		{
			name:"充值卡"
			key:"2"
			type:"text"
			backContent:"恭喜您获得了70M移动上网流量卡,卡号: #key ,充值地址: http://samsung.view4.cn"
		}
		{
			name:"手机试用"
			key:"2"
			type:"text"
			backContent:"恭喜您获得S5 试用使用权,请您按照如下格式回复我们: 姓名,电话,发货地址 "
		}
		{
			name:"记录手机用户"
			key:"2"
			type:"text"
			backContent:"谢谢, 我们已经收到了您的信息,将会尽快与您联系."
		}
		{
			name:"获得打折卷"
			key:"2"
			type:"text"
			backContent:"恭喜您获得了三星商城S5打折卷 ,卡号: #key ,在三星商城: http://samsung.view4.cn ,购买S5打九折."
		}
	]
	onetwoerror: [
		{
			name:"onetwo error."
			key:"1"
			type:"text"
			backContent :"您的用户名填写错误,请重新输入."
		}
		{
			name:"onetwo error."
			key:"2"
			type:"text"
			backContent :"您的手机号填写错误,请重新输入."
		}
		{
			name:"onetwo error."
			key:"3"
			type:"text"
			backContent :"您的地址填写错误,请重新输入."
		}
		{
			name:"onetwo error."
			key:"4"
			type:"text"
			backContent :"您填写的信息不对,请按照格式: 姓名,电话,发货地址 重新发送."
		}
	]