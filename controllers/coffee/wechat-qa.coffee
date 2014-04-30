myProcess = []
getQA = (message,openid)->
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
				return {}
		# if qa.evt?
			# qa.evt openid
			# qa = false
	else
		myProcess[openid] = searchQA key,_qa
		qa = _n = myProcess[openid]

	return qa

searchQA = (key,list)->
	for a in list
		return a if a.key is key
	return null
clearQA = (openid)->
	console.log "clear: #{openid}"
	delete myProcess[openid]
overQA = (openid)->
	console.log "记录抽奖ID: ",openid
	clearQA openid
	Inser_db_qauser openid
	Get_db_qauser()





# for question and answer

_nr = "\n\r"
_qa = [
	{
		name:"查看活动详情"
		key:"1"
		type:"news"
		backContent :"活动详情"
		title:"【看视频 答问题】赢取S5惊喜大奖"
		description: '参与《我爱三星视频秀》答题，即有机会获得丰厚大奖。'
		picurl:"http://samsung.4view.cn/img/samx-1.jpg"
		url: "http://mp.weixin.qq.com/s?__biz=MzA5MTUwMzMyNA==&mid=200198976&idx=1&sn=f0508d0792f15fc2c812fe77a04192b6&scene=1&from=singlemessage&isappinstalled=0#rd"
		evt:clearQA
	}
	{
		name:"开始答题"
		key:"2"
		type:"text"
		backContent :"节⽬中特别提到的Gear版特⾊应⽤是?#{_nr}A,搜狐视频Gear版 #{_nr}B,⾼德地图Gear版 #{_nr}C,S健康Gear版"
		next: [
			{
				name:"答案1"
				key:"C"
				type:"text"
				backContent: "很抱歉,本题回答错误。请根据本期《我爱三星视频秀》直播内容,重新作答。"
			}
			{
				name:"答案2"
				key:"B"
				type:"text"
				backContent: "很抱歉,本题回答错误。请根据本期《我爱三星视频秀》直播内容,重新作答。"
			}
			{
				name:"答案3"
				key:"A"
				type:"text"
				backContent: "⾦秀贤最喜欢的时尚刊物APP是什么?#{_nr}A、《宝宝俱乐部》 #{_nr}B、《新炫刊》#{_nr}C、《掌阅iReader》"
				next: [
					{
						name:"答案1"
						key:"A"
						type:"text"
						backContent: "很遗憾,回答错误。请再次作答。"
					}
					{
						name:"答案2"
						key:"C"
						type:"text"
						backContent: "很遗憾,回答错误。请再次作答。"
					}
					{
						name:"答案3"
						key:"B"
						type:"text"
						backContent: "节⽬中重点介绍了⼀个钱包类app,可以⽅便实现各类卡券的收纳与管理,是以下的哪个?#{_nr}A、《⽀付宝钱包》 #{_nr}B、《壹钱包》 #{_nr}C、《三星钱包》"
						next: [
							{
								name:"答案1"
								key:"A"
								type:"text"
								backContent: "哎呀,答错了。还有机会哦!"
							}
							{
								name:"答案2"
								key:"B"
								type:"text"
								backContent: "哎呀,答错了。还有机会哦!"
							}
							{
								name:"答案3"
								key:"C"
								type:"text"
								backContent: "恭喜你全部答对了,已经成功参与抽奖,敬请关注中奖通知."
								evt: overQA
							}
						]
					}
				]
			}
		]
	}
]