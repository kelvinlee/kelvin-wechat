// Generated by CoffeeScript 1.7.1
var ajaxpost, changeBox, _first;

_first = true;

$(document).ready(function() {
  console.log(code, _first);
  $(".model-list .item").click(function() {
    console.log(_first);
    if (_first) {
      _first = false;
      return ajaxpost($(this).index() + 1, this);
    }
  });
  return $(".submit").click(function() {
    return alert('提交成功');
  });
});

ajaxpost = function(nums, target) {
  console.log(nums);
  return $.ajax({
    url: '/lottery',
    dataType: "json",
    type: "POST",
    data: [
      {
        name: "code",
        value: code
      }, {
        name: "nums",
        value: nums
      }
    ],
    success: function(msg) {
      console.log(msg);
      if (msg.recode === 200) {
        return changeBox(target, msg.reason);
      } else if (msg.recode === 201) {
        return alert('您的资格码有问题,请您确定后重新参与.');
      } else if (msg.recode === 202) {
        return alert('您已经参与过抽奖,请刷新页面.');
      } else {
        return alert(msg.reason);
      }
    }
  });
};

changeBox = function(target, lottery) {
  var $e1, $e2;
  $e1 = $('.flip', target);
  $e2 = $('.fliped', target);
  $e1.removeClass('flip').addClass('fliped');
  $e2.removeClass('fliped').addClass('flip');
  if (lottery === 'cm') {
    console.log('车模');
    $("span", target).text('中奖啦');
    return setTimeout(function() {
      $("#bg").attr('src', "/img/bg2.jpg");
      $(".main").hide();
      return $(".cmpage").show();
    }, 2000);
  } else if (lottery === 'none') {
    return $("span", target).text('很遗憾');
  } else {
    $("span", target).text('中奖啦');
    return setTimeout(function() {
      $("#bg").attr('src', "/img/bg2.jpg");
      $(".main").hide();
      $(".otherpage").show();
      return $("#cardcode").text(lottery);
    }, 2000);
  }
};