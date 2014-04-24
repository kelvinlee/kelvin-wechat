// Generated by CoffeeScript 1.6.3
var bindPiclist, editor, isload, loadPics, selectPic, selectPicL, whos;

editor = '';

$(document).ready(function() {
  return $('[name=submit]').click(function() {
    if ($('#title').val() === '') {
      return alert('请输入标题');
    }
    if ($('#pic').val() === '') {
      return alert('请选择配图');
    }
    if ($('#video').val() === '') {
      return alert('请选择视频');
    }
    if ($('#date').val() === '') {
      return alert('请选择时间');
    }
    return $.ajax({
      url: $("#artform").attr('action'),
      dataType: "json",
      type: "POST",
      data: $("#artform").serializeArray(),
      success: function(msg) {
        if (msg.resultcode === 200) {
          console.log(msg.reason);
          alert('添加成功,返回列表页.');
          return window.location.href = $('#goback').attr('href');
        } else {
          return alert(msg.reason);
        }
      }
    });
  });
});

whos = 'pic';

selectPic = function(who) {
  if (who == null) {
    who = 'pic';
  }
  $('#selectfiles').modal('show');
  whos = who;
  return loadPics();
};

isload = false;

loadPics = function() {
  if (isload) {
    return '';
  }
  return $.ajax({
    url: '/files/getfilelist',
    type: 'get',
    dataType: 'json',
    success: function(msg) {
      var i, _i, _len, _ref;
      console.log(msg);
      if (msg.data.length > 0) {
        _ref = msg.data;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          i = _ref[_i];
          if ((i.filetype === '.png') || (i.filetype === '.jpg') || (i.filetype === '.gif')) {
            $("#piclist").append('<div data-file="' + i.filename + '" data-size="' + i.size + '" data-type="' + i.filetype + '" title="' + i.filename + '" class="col-sm-2 fileselect" style="margin-bottom:10px;"><img width="100%" src="/uploads/' + i.filename + '"/><span style="line-height:22px;display:block;overflow:hidden;">' + i.filename + '</span></div>');
          }
          if (i.filetype === '.mp4') {
            $("#piclist").append('<div data-file="' + i.filename + '" data-size="' + i.size + '" data-type="' + i.filetype + '" title="' + i.filename + '" class="col-sm-2 fileselect" style="margin-bottom:10px;"><img width="100%" src="/public/images/logo.png"/><span style="line-height:22px;display:block;overflow:hidden;">' + i.filename + '</span></div>');
          }
          if (i.filetype !== '.mp4' && i.filetype !== '.png' && i.filetype !== '.jpg' && i.filetype !== '.gif') {
            $("#piclist").append('<div data-file="' + i.filename + '" data-size="' + i.size + '" data-type="' + i.filetype + '" title="' + i.filename + '" class="col-sm-2 fileselect" style="margin-bottom:10px;"><img width="100%" src="/public/images/logo.png"/><span style="line-height:22px;display:block;overflow:hidden;">' + i.filename + '</span></div>');
          }
        }
      }
      isload = true;
      return bindPiclist();
    }
  });
};

bindPiclist = function() {
  return $("#piclist div").click(function() {
    $("#piclist div").removeClass('on');
    return $(this).addClass('on');
  });
};

selectPicL = function() {
  var $file;
  $file = $("#piclist .on").data('file');
  $("#" + whos).val($file);
  if (whos === 'video') {
    $('#size').val($("#piclist .on").data('size'));
  }
  return $('#selectfiles').modal('hide');
};
