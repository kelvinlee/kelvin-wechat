# ?id=${id} 用户id , 用作唯一值
# 
_nr = "\n\r"
op_Process_list = [
	{
		name:"抽奖"
		key: "抽奖"
		type: "text"
		backContent: "您点不开下面的连接参与抽奖:#{_nr} #{config.host_url}/active/test/ 只是测试回复功能" 
	}
	{
		name:"查看抽奖结果"
		key: "查看抽奖结果"
		type:"text"
		backContent: "查看我的抽奖结果:#{_nr} #{config.host_url}/active-over/test"
	}
]
op_Process_img = [
	{
		name: "返回收到图片信息"
		key: "img"
		type: "text"
		backContent: "已经收到您的截图,请等待管理员审核内容,审核通过后会给您发送抽奖地址."
	}
]


go_img_process = ()->
	return op_Process_img[0]

myProcess = false
go_process = (msg)->
	# 判断是否有下一级菜单
	if not myProcess
		for pro in op_Process_list
			if pro.key is msg
				if pro.next
					myProcess = pro
					pro.event.call() if pro.event?
				return pro
				break
		myProcess = false
	else
		# 判断下级菜单内容
		if myProcess.next
			for pro in myProcess.next
				if pro.key is msg
					myProcess = pro
					pro.event.call() if pro.event?
					return pro
					break
		# 没有的时候返回一级查看.
		go_process msg
	return myProcess = false

tranStr = (message,str,callback)->
	# str.replace '${id}',message.FromUserName
	callback str
