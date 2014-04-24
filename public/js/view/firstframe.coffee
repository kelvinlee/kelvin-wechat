$(document).ready ->
	$("#datatable").dataTable
		"bLengthChange": false
		"aaSorting": [ [4,'desc'] ]
		"oLanguage":
			"sInfo": "从 _START_ 到 _END_ 条,共 _TOTAL_ 条" 
	$('.dataTables_filter input').addClass('form-control').attr 'placeholder','Search'
	$('.dataTables_length select').addClass 'form-control' 
	$('.pull-left:first').html '<a href="/firstframe/add" class="btn btn-primary">添加开机画面</a>'