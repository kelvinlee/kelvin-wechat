// Generated by CoffeeScript 1.6.3
var go_process, myProcess, op_Process_list;

op_Process_list = [
  {
    name: "welcome",
    key: "你好",
    backContent: "你好,好奇的人,欢迎来的桥哥的新奇世界,如果你想自己逛逛就不要理我,如果想听我的介绍,就回复LOVE.",
    next: [
      {
        key: "LOVE",
        backContent: "你真是个聪明的人,好奇的人,在桥哥的新奇世界里,主要是介绍各种新奇的事、人、物品.",
        next: [
          {
            key: "事",
            backContent: "看看各种事吧."
          }, {
            key: "人",
            backContent: "看看各种人吧."
          }, {
            key: "物品",
            backContent: "看看物品吧."
          }
        ]
      }
    ]
  }
];

myProcess = false;

go_process = function(msg) {
  var pro, _i, _j, _len, _len1, _ref;
  if (!myProcess) {
    for (_i = 0, _len = op_Process_list.length; _i < _len; _i++) {
      pro = op_Process_list[_i];
      if (pro.key === msg) {
        myProcess = pro;
        return pro.backContent;
        break;
      }
    }
  } else {
    if (myProcess.next) {
      _ref = myProcess.next;
      for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
        pro = _ref[_j];
        if (pro.key === msg) {
          myProcess = pro;
          return pro.backContent;
          break;
        }
      }
    }
  }
  return myProcess = false;
};