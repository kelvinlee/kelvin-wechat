editor = ''
$(document).ready ->
	$('[name=submit]').click ->
		return alert '请输入标题' if $('#title').val() is ''
		return alert '请选择配图' if $('#pic').val() is ''
		return alert '请选择视频' if $('#video').val() is ''
		return alert '请选择时间' if $('#date').val() is ''
		$.ajax 
			url:$("#artform").attr 'action'
			dataType:"json"
			type:"POST"
			data:$("#artform").serializeArray()
			success:(msg)->
				if msg.resultcode == 200
					console.log msg.reason
					alert '添加成功,返回列表页.'
					window.location.href = $('#goback').attr 'href'
				else
					alert msg.reason
whos = 'pic'
selectPic = (who = 'pic')->
	$('#selectfiles').modal 'show'
	whos = who
	loadPics()
isload = false
loadPics = ->
	return '' if isload
	$.ajax
		url:'/files/getfilelist'
		type:'get'
		dataType:'json'
		success:(msg)->
			console.log msg
			if msg.data.length>0
				for i in msg.data
					$("#piclist").append '<div data-file="'+i.filename+'" data-size="'+i.size+'" data-type="'+i.filetype+'" title="'+i.filename+'" class="col-sm-2 fileselect" style="margin-bottom:10px;"><img width="100%" src="/uploads/'+i.filename+'"/><span style="line-height:22px;display:block;overflow:hidden;">'+i.filename+'</span></div>' if (i.filetype is '.png') or (i.filetype is '.jpg') or (i.filetype is '.gif')
					$("#piclist").append '<div data-file="'+i.filename+'" data-size="'+i.size+'" data-type="'+i.filetype+'" title="'+i.filename+'" class="col-sm-2 fileselect" style="margin-bottom:10px;"><img width="100%" src="/public/images/logo.png"/><span style="line-height:22px;display:block;overflow:hidden;">'+i.filename+'</span></div>' if i.filetype is '.mp4'
					$("#piclist").append '<div data-file="'+i.filename+'" data-size="'+i.size+'" data-type="'+i.filetype+'" title="'+i.filename+'" class="col-sm-2 fileselect" style="margin-bottom:10px;"><img width="100%" src="/public/images/logo.png"/><span style="line-height:22px;display:block;overflow:hidden;">'+i.filename+'</span></div>' if i.filetype != '.mp4' and i.filetype != '.png' and i.filetype != '.jpg' and i.filetype != '.gif'
			isload = true;
			bindPiclist()
bindPiclist = ->
	$("#piclist div").click ->
		$("#piclist div").removeClass 'on'
		$(this).addClass 'on'

selectPicL = ->
	$file = $("#piclist .on").data 'file'
	$("#"+whos).val $file
	$('#size').val $("#piclist .on").data 'size' if whos is 'video'
	$('#selectfiles').modal 'hide'