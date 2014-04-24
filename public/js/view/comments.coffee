$(document).ready ->
	$("#datatable").dataTable
		"bLengthChange": false
		"aaSorting": [ [3,'desc'] ]
		"oLanguage":
			"sInfo": "从 _START_ 到 _END_ 条,共 _TOTAL_ 条" 
	$('.dataTables_filter input').addClass('form-control').attr 'placeholder','Search'
	$('.dataTables_length select').addClass 'form-control' 
	$('.pull-left:first').html '<a href="/comments/clear" class="btn btn-primary">已阅所有反馈</a>'