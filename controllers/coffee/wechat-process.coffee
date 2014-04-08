op_Process_list = [
	{
		name:"welcome"
		key: "你好"
		type: "text"
		backContent : "你好,好奇的人,欢迎来的桥哥的新奇世界,如果你想自己逛逛就不要理我,如果想听我的介绍,就回复LOVE."
		next:[
			{
				key:"LOVE"
				type: "text"
				backContent: "你真是个聪明的人,好奇的人,在桥哥的新奇世界里,主要是介绍各种新奇的事、人、物品."
				next:[
					{
						key:"事"
						type: "text"
						backContent :"看看各种事吧."
					}
					{
						key:"人"
						type: "text"
						backContent:"看看各种人吧."
					}
					{
						key:"物品"
						type: "image"
						backContent:"看看物品吧."
					}
				]
			}
		]
	}
	{
		name:"抽奖"
		key: "抽奖"
		type: "link"
		backContent: "点开下面的连接参与抽奖:\n\r http://wechat.giccoo.com"
		url:"http://wechat.giccoo.com"
		title:"参与抽奖获得好礼"
		description:"活动时间2014-04-08~2014-04-17"
	}
]


myProcess = false
go_process = (msg)->
	if not myProcess
		for pro in op_Process_list
			if pro.key is msg
				myProcess = pro
				return {content:pro.backContent,type:pro.type}
				break
	else
		if myProcess.next
			for pro in myProcess.next
				if pro.key is msg
					myProcess = pro
					return {content:pro.backContent,type:pro.type}
					break
	return myProcess = false