myProcess = []
getQA = (message,openid,callback)->
	key = message
	console.log "user #{openid} :",myProcess[openid]
	if myProcess[openid]?
		qa = myProcess[openid]
		if qa.next?
			qa = myProcess[openid].next
			qa = searchQA key,qa
			if qa?
				myProcess[openid] = qa if qa.next?
			else
				callback {}
		# if qa.evt?
			# qa.evt openid
			# qa = false
	else
		myProcess[openid] = searchQA key,_qa
		qa = _n = myProcess[openid]

	callback qa

searchQA = (key,list)->
	for a in list
		return a if a.key is key
	return null
clearQA = (openid)->
	console.log "clear: #{openid}"
	delete myProcess[openid]
overQA = (openid,backup = "test")->
	console.log "记录抽奖ID: ",openid
	clearQA openid
	Inser_db_qauser openid,backup
	# Get_db_qauser()





# for question and answer

# _randomBadAnswer = ["本题回答错误。快去本期《我爱三星视频秀》直播仔细瞄一下内容,再来重新作答哦!视频链接: http://tv.sohu.com/samsung","嘿嘿,你一定没有认真看视频,要仔细看才能知道答案哦!~视频链接: http://tv.sohu.com/samsung","哎呀,答错了。只有三道题全对才能赢得S5哟! ~ 视频链接: http://tv.sohu.com/samsung"]

_nr = "\n"
_qa = [
	{
		name:"查看活动详情"
		key:"1"
		type:"news"
		backContent :"活动详情"
		title:"Samsung GALAXY K zoom 让每个瞬间都精彩"
		description: '参与活动赢取Samsung GALAXY K zoom，开启你的幸福之旅~'
		picurl:"https://mmbiz.qlogo.cn/mmbiz/icfeQvJeAJzNWR5PaQgtD89x9Drdb3oBEH7YOOcibiajvicowpicTgUjrlNzswycHMGPKjytQvc4icOqb3I627BnkWOQ/0"
		url: "http://weixinapp.nmtree.com/samsung/?from=singlemessage&isappinstalled=0"
		evt:clearQA
	}
	# {
	# 	name:"欢迎"
	# 	key:"1"
	# 	type:"text"
	# 	backContent:"敬请期待下次活动"
	# }
	# {
	# 	name:"查看活动详情"
	# 	key:"1"
	# 	type:"news"
	# 	backContent :"活动详情"
	# 	title:"【看名车志，赢车模】100%中奖"
	# 	description: '下载【新炫刊】参与“看名车志，赢车模”活动，赢取移动30元充值卡、移动70M流量包或1:18精美汽车模型，100%中奖！'
	# 	picurl:"https://mmbiz.qlogo.cn/mmbiz/icfeQvJeAJzM5ibtoBBE2SGwkpLUxZNAx8h8puh4WRxWa4xPWFKLgVp8vcAAF48cME3iaYIPqQCzKiapjCfb80P9Iw/0"
	# 	url: "http://mp.weixin.qq.com/s?__biz=MzA5MTUwMzMyNA==&mid=200220698&idx=1&sn=08b87ef8fada09289f48ade871e675df#rd"
	# 	evt:clearQA
	# }
	# {
	# 	name:"开始答题"
	# 	key:"2"
	# 	type:"text"
	# 	backContent :"节⽬中特别提到的Gear版特⾊应⽤是?#{_nr}A,搜狐视频Gear版 #{_nr}B,⾼德地图Gear版 #{_nr}C,S健康Gear版"
	# 	next: [
	# 		{
	# 			name:"答案1"
	# 			key:"C"
	# 			type:"text"
	# 			backContent: ""
	# 			random:_randomBadAnswer
	# 		}
	# 		{
	# 			name:"答案2"
	# 			key:"B"
	# 			type:"text"
	# 			backContent: "很抱歉,本题回答错误。请根据本期《我爱三星视频秀》直播内容,重新作答。"
	# 			random:_randomBadAnswer
	# 		}
	# 		{
	# 			name:"答案3"
	# 			key:"A"
	# 			type:"text"
	# 			backContent: "⾦秀贤最喜欢的时尚刊物APP是什么?#{_nr}A、宝宝俱乐部 #{_nr}B、新炫刊#{_nr}C、掌阅iReader"
	# 			next: [
	# 				{
	# 					name:"答案1"
	# 					key:"A"
	# 					type:"text"
	# 					backContent: "很遗憾,回答错误。请再次作答。"
	# 					random:_randomBadAnswer
	# 				}
	# 				{
	# 					name:"答案2"
	# 					key:"C"
	# 					type:"text"
	# 					backContent: "很遗憾,回答错误。请再次作答。"
	# 					random:_randomBadAnswer
	# 				}
	# 				{
	# 					name:"答案3"
	# 					key:"B"
	# 					type:"text"
	# 					backContent: "节⽬中重点介绍了⼀个钱包类app,可以⽅便实现各类卡券的收纳与管理,是以下的哪个?#{_nr}A、⽀付宝钱包 #{_nr}B、壹钱包 #{_nr}C、三星钱包"
	# 					next: [
	# 						{
	# 							name:"答案1"
	# 							key:"A"
	# 							type:"text"
	# 							backContent: "哎呀,答错了。还有机会哦!"
	# 							random:_randomBadAnswer
	# 						}
	# 						{
	# 							name:"答案2"
	# 							key:"B"
	# 							type:"text"
	# 							backContent: "哎呀,答错了。还有机会哦!"
	# 							random:_randomBadAnswer
	# 						}
	# 						{
	# 							name:"答案3"
	# 							key:"C"
	# 							type:"text"
	# 							backContent: "恭喜您全部答对了,已经成功参与抽奖,敬请关注中奖通知。"
	# 							evt: overQA
	# 						}
	# 					]
	# 				}
	# 			]
	# 		}
	# 	]
	# }
]