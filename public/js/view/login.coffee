colist = ['#fec500','#07b1b0','#d6e03e','#1284d4','#c81a23']
_ls = 0

$(document).ready ->
	$('[name=submit]').click ->
		$.ajax 
			url:$("#login").attr 'action'
			dataType:"json"
			type:"POST"
			data:$("#login").serializeArray()
			success:(msg)->
				if msg.recode == 200
					window.location.href = "/admin/homepage"
				else
					alert msg.reason
	$("[name=random]").click ->
		console.log ">>"
		$.ajax 
			url:$("#generateform").attr 'action'
			dataType:"json"
			type:"POST"
			data:$("#generateform").serializeArray()
			success:(msg)->
				if msg.recode == 200
					$ep = $("[name=generate]")
					$ep.html $ep.data('content')+msg.reason
					$("#randomnum").css 'color',colist[_ls]
					$("#randomnum").html msg.reason
					_ls++
					_ls = 0 if _ls >= colist.length
				else
					alert msg.reason