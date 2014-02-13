op_Process_list = [
	{
		name:"welcome"
		key: "你好"
		backContent : "你好,好奇的人,欢迎来的桥哥的新奇世界,如果你想自己逛逛就不要理我,如果想听我的介绍,就回复LOVE."
		next:[
			{
				key:"LOVE"
				backContent: "你真是个聪明的人,好奇的人,在桥哥的新奇世界里,主要是介绍各种新奇的事、人、物品."
				next:[
					{
						key:"事"
						backContent :"看看各种事吧."
					}
					{
						key:"人"
						backContent:"看看各种人吧."
					}
					{
						key:"物品"
						backContent:"看看物品吧."
					}
				]
			}
		]
	}
]

myProcess = false
go_process = (msg)->
	if not myProcess
		for pro in op_Process_list
			if pro.key is msg
				myProcess = pro
				return pro.backContent
				break
	else
		if myProcess.next
			for pro in myProcess.next
				if pro.key is msg
					myProcess = pro
					return pro.backContent
					break
	return myProcess = false