$(document).ready ->
	$("#datatable").dataTable
		"bLengthChange": false
		"aaSorting": [ [3,'desc'] ]
		"oLanguage":
			"sInfo": "从 _START_ 到 _END_ 条,共 _TOTAL_ 条" 
	$('.dataTables_filter input').addClass('form-control').attr 'placeholder','Search'
	$('.dataTables_length select').addClass 'form-control'
	$('.pull-left:first').html '<a href="javascript:void(0)" onclick="showupload()" class="btn btn-primary">添加文件</a>'
	$('[name=upload]').click ->
		startupload()
	$('[name=addnew]').on "click",->
		copyform $ this
copyform = (o)->
	parent = o.parents 'form:first'
	parent = parent.clone()
	parent.find('.has-error').removeClass 'has-error'
	parent.find('.error').html ''
	parent.find('.fa-plus').removeClass('fa-plus').addClass 'fa-minus'
	parent.find('[name=addnew]').on 'click', ->
		parent.remove()
	# parent.find('[name=userfile]').attr 'id','fileToUpload'+Math.random()
	# parent.find('[name=userfile]').attr 'name',parent.find('[name=userfile]').attr 'id'
	$('[name=notethis]').before parent
k = 1
r = true
checkUpload = (su)->
	n = $('[name=upfiles]').length
	r = false if su is false
	console.log n,k
	if k>=n
		console.log r
		window.location.reload() if r
		return ;
	k++
startupload = ->
	$('[name=upfiles]').each (i)-> 
		console.log $(this).attr 'action'
		console.log $(this).find("[name=userfile]").attr 'id'
		$ep = $ this
		$.ajaxFileUpload
			url: $(this).attr 'action'
			secureuri:false
			fileElementId:$(this).find "[type=file]"
			dataType: 'json'
			data:{name:'logan', id:'id'}
			success: (data, status)->
				console.log data ,typeof data.error
				if typeof data.error != 'undefined'
					console.log 'error'
					checkUpload false
					$('.form-group',$ep).addClass 'has-error'
					$('.error',$ep).html data.error
					return 
				
				$('[name=addnew]',$ep).click() if i != 0
				checkUpload true

showupload = ->
	$('#uploadfile').modal 'show'