// Generated by CoffeeScript 1.7.1
var colist, _ls;

colist = ['#fec500', '#07b1b0', '#d6e03e', '#1284d4', '#c81a23'];

_ls = 0;

$(document).ready(function() {
  $('[name=submit]').click(function() {
    return $.ajax({
      url: $("#login").attr('action'),
      dataType: "json",
      type: "POST",
      data: $("#login").serializeArray(),
      success: function(msg) {
        if (msg.recode === 200) {
          return window.location.href = "/admin/homepage";
        } else {
          return alert(msg.reason);
        }
      }
    });
  });
  return $("[name=random]").click(function() {
    console.log(">>");
    return $.ajax({
      url: $("#generateform").attr('action'),
      dataType: "json",
      type: "POST",
      data: $("#generateform").serializeArray(),
      success: function(msg) {
        var $ep;
        if (msg.recode === 200) {
          $ep = $("[name=generate]");
          $ep.html($ep.data('content') + msg.reason);
          $("#randomnum").css('color', colist[_ls]);
          $("#randomnum").html(msg.reason);
          _ls++;
          if (_ls >= colist.length) {
            return _ls = 0;
          }
        } else {
          return alert(msg.reason);
        }
      }
    });
  });
});
