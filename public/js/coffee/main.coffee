
_first = true
$(document).ready ->
	console.log code,_first
	$(".model-list .item").click ->
		console.log _first
		if _first
			_first = false
			ajaxpost $(this).index()+1,this
	$(".submit").click ->
		alert '提交成功'

ajaxpost = (nums,target)->
	console.log nums
	$.ajax 
		url:'/lottery'
		dataType:"json"
		type:"POST"
		data:[{name:"code",value:code},{name:"nums",value:nums}]
		success:(msg)->
			console.log msg
			if msg.recode is 200
				changeBox target,msg.reason,msg.type
			else if msg.recode is 201
				alert '您的资格码有问题,请您确定后重新参与.'
			else if msg.recode is 202
				alert '您已经参与过抽奖,请刷新页面.'
			else
				alert msg.reason

changeBox = (target,lottery,type)->
	alert type
	$e1 = $('.flip',target)
	$e2 = $('.fliped',target)
	$e1.removeClass('flip').addClass 'fliped'
	$e2.removeClass('fliped').addClass 'flip'
	if type is 'cm'
		console.log '车模'
		$("span",target).text '中奖啦'
		setTimeout ->
			$("#bg").attr 'src',"/img/bg2.jpg"
			$(".main").hide()
			$(".cmpage").show()
		,2000
	else if type is 'none'
		$("span",target).text '很遗憾'
	else if type is 'card30'
		$("span",target).text '中奖啦'
		setTimeout ->
			$("#bg").attr 'src',"/img/bg2.jpg"
			$(".main").hide()
			$(".card30page").show()
			$("#cardcode30").text lottery
		,2000
	else
		$("span",target).text '中奖啦'
		setTimeout ->
			$("#bg").attr 'src',"/img/bg2.jpg"
			$(".main").hide()
			$(".otherpage").show()
			$("#cardcode").text lottery
		,2000

	

