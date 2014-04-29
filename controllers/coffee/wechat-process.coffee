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
	{
		name:"答题回答问题"
		key:"开始答题"
		type: "text"
		backContent: "第一题:三星 galayxy S5 的后置摄像头是多少像素#{_nr} A. 500万#{_nr}B. 1000万#{_nr}C. 1500万"
		next: [
			{
				name:"答案1"
				key:"A"
				backContent:"答得不对哦,再试试其他的答案"
			}
			{
				name:"答案2"
				key:"B"
				backContent:"答得不对哦,再试试其他的答案"
			}
			{
				name:"答案3"
				key:"C"
				backContent:"恭喜答对了#{_nr}第二题:三星 galayxt S5 使用的是几核CPU?#{_nr}A. 双核#{_nr}B. 四核#{_nr}C. 八核"
				next: [
					{
						name:"答案1"
						key:"A"
						backContent:"再仔细想想看"
					}
					{
						name:"答案2"
						key:"B"
						backContent:"再仔细想想看"
					}
					{
						name:"答案1"
						key:"C"
						backContent:"哎呦,不错哦#{_nr}第三题:三星 galayxy S5 的新增特色功能是什么?#{_nr}A. 指纹识别#{_nr}B. 眼球阅读#{_nr}C. 电源节省"
						next: [
							{
								name:"答案1"
								key:"A"
								backContent:"干得漂亮,你已经答对了所有的题目,成功参与此次抽奖活动,敬请期待抽奖结果,也可以使用口令'查看抽奖结果',来查看自己的中奖情况"
								event: ->
							}
							{
								name:"答案2"
								key:"B"
								backContent:"只差一点就答对了."
							}
							{
								name:"答案3"
								key:"C"
								backContent:"只差一点就答对了."
							}
						]
					}
				]
			}
		]

	}
	{
		name:""
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

tranStr = (message,str)->
	str.replace '${id}',message.FromUserName
	return str
