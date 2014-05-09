// Generated by CoffeeScript 1.7.1

/*
--------------------------------------------
     Begin wechat.coffee
--------------------------------------------
 */
var BufferHelper, EventProxy, Get_db_qauser, Inser_db_img, Inser_db_qauser, Inser_db_text, Message, OneTwo, QAlist, Segment, Special, User, checkMessage, checkSignature, clearQA, config, crypto, formatMessage, fs, getAnswer, getMessage, getParse, getQA, go_img_process, go_process, go_subscribe, isEmpty, myProcess, mySpecial, op_Process_img, op_Process_list, overQA, path, qs, searchQA, segWord, tranStr, url, welcometext, xml2js, _nr, _qa, _randomBadAnswer, _special;

User = require('../proxy').User;

Message = require('../proxy').Message;

QAlist = require('../proxy').QAlist;

OneTwo = require('../proxy').OneTwo;

fs = require('fs');

path = require('path');

crypto = require('crypto');

xml2js = require('xml2js');

url = require('url');

qs = require('querystring');

BufferHelper = require('bufferhelper');

EventProxy = require('eventproxy');

config = require('../config').config;

Segment = require('segment').Segment;

segWord = new Segment();

segWord.use('URLTokenizer').use('WildcardTokenizer').use('PunctuationTokenizer').use('DictTokenizer').use('ChsNameTokenizer').use('EmailOptimizer').use('ChsNameOptimizer').use('DictOptimizer').use('DatetimeOptimizer').use('ForeignTokenizer').loadDict('dict.txt').loadDict('dict2.txt').loadDict(path.resolve("./dicts/carnames.txt")).loadDict('names.txt').loadDict('wildcard.txt', 'WILDCARD', true);

checkSignature = function(query, token) {
  var arr, nonce, shasum, signature, timestamp;
  signature = query.signature;
  timestamp = query.timestamp;
  nonce = query.nonce;
  shasum = crypto.createHash('sha1');
  arr = [token, timestamp, nonce].sort();
  shasum.update(arr.join(''));
  return shasum.digest('hex') === signature;
};

getParse = function(req) {
  var query;
  query = url.parse(req.url).query;
  return qs.parse(query);
};

isEmpty = function(thing) {
  return typeof thing === "object" && (thing !== null) && Object.keys(thing).length === 0;
};

getMessage = function(stream, callback) {
  var buf;
  buf = new BufferHelper();
  return buf.load(stream, function(err, buf) {
    var xml;
    if (err) {
      return callback(err);
    }
    xml = buf.toString('utf-8');
    return xml2js.parseString(xml, {
      trim: true
    }, callback);
  });
};

formatMessage = function(result) {
  var key, message, val;
  message = {};
  if (!result) {
    return false;
  }
  for (key in result.xml) {
    val = result.xml[key][0];
    message[key] = (isEmpty(val) ? '' : val).trim();
  }
  return message;
};

checkMessage = function(message, callback) {
  var img;
  switch (message.MsgType) {
    case 'text':
      console.log('文字信息');
      if (Special(message.Content, message.FromUserName)) {
        return getAnswer(message.Content, message.FromUserName, callback);
      }
      return getQA(message.Content, message.FromUserName, callback);
    case 'image':
      console.log('图片信息');
      img = {
        name: "返回收到图片信息.",
        key: "1",
        type: "text",
        backContent: "您好,已经收到您的图片,请等待审核."
      };
      callback(img);
      return img;
    case 'voice':
      console.log('声音信息');
      return null;
      return tranStr(message, go_process(message.Recognition, callback));
    case 'video':
      console.log('视频信息');
      return null;
    case 'location':
      console.log('地理信息');
      return null;
    case 'link':
      console.log('连接消息');
      return null;
    case 'event':
      if (message.Event === 'subscribe') {
        return go_subscribe(message, callback);
      }
      return null;
  }
  return null;
};

exports.index = function(req, res, next) {
  var allDone, backup, parse, to;
  parse = getParse(req);
  backup = req.query.code;
  to = checkSignature(parse, config.wechat_token);
  allDone = new EventProxy();
  allDone.all('backMsg', 'message', function(backMsg, message) {
    if (!message) {
      return res.send(to ? parse.echostr : "what?");
    }
    if (backMsg != null) {
      if (backMsg.type === "text") {
        if (backMsg.random != null) {
          backMsg.backContent = backMsg.random[Math.round(Math.random() * (backMsg.random.length - 1))];
        }
        res.render('wechat-text', {
          toUser: message.FromUserName,
          fromUser: message.ToUserName,
          date: new Date().getTime(),
          content: backMsg.backContent
        });
      }
      if (backMsg.type === 'news') {
        console.log("news run");
        res.render('wechat-news', {
          toUser: message.FromUserName,
          fromUser: message.ToUserName,
          date: new Date().getTime(),
          title: backMsg.title,
          description: backMsg.description,
          picurl: backMsg.picurl,
          url: backMsg.url
        });
      }
      if (backMsg.evt != null) {
        return backMsg.evt(message.FromUserName, backup);
      }
    } else {
      return res.render('wechat-text', {
        toUser: message.FromUserName,
        fromUser: message.ToUserName,
        date: new Date().getTime(),
        content: ""
      });
    }
  });
  return getMessage(req, function(err, result) {
    var message;
    if (err) {
      console.log(err);
    }
    if (!result) {
      return res.send(to ? parse.echostr : "what?");
    }
    message = formatMessage(result);
    allDone.emit('message', message);
    return checkMessage(message, function(back) {
      console.log("back To: ", back);
      return allDone.emit('backMsg', back);
    });
  });
};

exports.word = function(req, res, next) {
  var word;
  word = segWord.doSegment("我叫李泓桥,我要预约试驾奥迪SQ5,我想三年之内买车.");
  word.sort(function(a, b) {
    return b.p - a.p;
  });
  console.log(word);
  return res.send("contents");
};


/*
--------------------------------------------
     Begin wechat-process.coffee
--------------------------------------------
 */

_nr = "\n\r";

op_Process_list = [
  {
    name: "抽奖",
    key: "抽奖",
    type: "text",
    backContent: "您点不开下面的连接参与抽奖:" + _nr + " " + config.host_url + "/active/test/ 只是测试回复功能"
  }, {
    name: "查看抽奖结果",
    key: "查看抽奖结果",
    type: "text",
    backContent: "查看我的抽奖结果:" + _nr + " " + config.host_url + "/active-over/test"
  }
];

op_Process_img = [
  {
    name: "返回收到图片信息",
    key: "img",
    type: "text",
    backContent: "已经收到您的截图,请等待管理员审核内容,审核通过后会给您发送抽奖地址."
  }
];

go_img_process = function() {
  return op_Process_img[0];
};

myProcess = false;

go_process = function(msg) {
  var pro, _i, _j, _len, _len1, _ref;
  if (!myProcess) {
    for (_i = 0, _len = op_Process_list.length; _i < _len; _i++) {
      pro = op_Process_list[_i];
      if (pro.key === msg) {
        if (pro.next) {
          myProcess = pro;
          if (pro.event != null) {
            pro.event.call();
          }
        }
        return pro;
        break;
      }
    }
    myProcess = false;
  } else {
    if (myProcess.next) {
      _ref = myProcess.next;
      for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
        pro = _ref[_j];
        if (pro.key === msg) {
          myProcess = pro;
          if (pro.event != null) {
            pro.event.call();
          }
          return pro;
          break;
        }
      }
    }
    go_process(msg);
  }
  return myProcess = false;
};

tranStr = function(message, str, callback) {
  return callback(str);
};


/*
--------------------------------------------
     Begin wechat-subscribe.coffee
--------------------------------------------
 */

welcometext = {
  name: "welcome",
  key: "你好",
  type: "text",
  backContent: "感谢您关注【三星乐园】官方微信，还在向朋友们留言“流量耗尽，下月见”？2014年5月9日—2014年5月22日参与【看名车志，赢车模】活动，就能赢取70M数据流量充值~还有精美车模相赠，回复【1】查看“活动详情”，赶紧下载参与吧。"
};

go_subscribe = function(message, callback) {
  return callback(welcometext);
};


/*
--------------------------------------------
     Begin wechat-db-Operating.coffee
--------------------------------------------
 */

Inser_db_text = function(db) {
  return Message.saveText(db.FromUserName, db.MsgType, db.Content, db.MsgId, function(err) {
    return console.log("text back:", err);
  });
};

Inser_db_img = function(db) {
  return Message.saveImg(db.FromUserName, db.MsgType, db.PicUrl, db.MsgId, db.MediaId, function(err) {
    return console.log("text back:", err);
  });
};

Inser_db_qauser = function(openid, backup) {
  return QAlist.checkhas(openid, function(err, obj) {
    if (obj != null) {
      return console.log("已经存在,无法录入");
    } else {
      return QAlist.saveNew(openid, backup, function(err, obj) {
        return console.log("录入成功");
      });
    }
  });
};

Get_db_qauser = function() {
  return QAlist.getall(function(err, list) {
    return console.log("QA: ", err, list);
  });
};


/*
--------------------------------------------
     Begin wechat-qa.coffee
--------------------------------------------
 */

myProcess = [];

getQA = function(message, openid, callback) {
  var key, qa, _n;
  key = message;
  console.log("user " + openid + " :", myProcess[openid]);
  if (myProcess[openid] != null) {
    qa = myProcess[openid];
    if (qa.next != null) {
      qa = myProcess[openid].next;
      qa = searchQA(key, qa);
      if (qa != null) {
        if (qa.next != null) {
          myProcess[openid] = qa;
        }
      } else {
        callback({});
      }
    }
  } else {
    myProcess[openid] = searchQA(key, _qa);
    qa = _n = myProcess[openid];
  }
  return callback(qa);
};

searchQA = function(key, list) {
  var a, _i, _len;
  for (_i = 0, _len = list.length; _i < _len; _i++) {
    a = list[_i];
    if (a.key === key) {
      return a;
    }
  }
  return null;
};

clearQA = function(openid) {
  console.log("clear: " + openid);
  return delete myProcess[openid];
};

overQA = function(openid, backup) {
  if (backup == null) {
    backup = "test";
  }
  console.log("记录抽奖ID: ", openid);
  clearQA(openid);
  return Inser_db_qauser(openid, backup);
};

_randomBadAnswer = ["本题回答错误。快去本期《我爱三星视频秀》直播仔细瞄一下内容,再来重新作答哦!视频链接: http://tv.sohu.com/samsung", "嘿嘿,你一定没有认真看视频,要仔细看才能知道答案哦!~视频链接: http://tv.sohu.com/samsung", "哎呀,答错了。只有三道题全对才能赢得S5哟! ~ 视频链接: http://tv.sohu.com/samsung"];

_nr = "\n";

_qa = [
  {
    name: "查看活动详情",
    key: "1",
    type: "news",
    backContent: "活动详情",
    title: "【看名车志，赢车模】100%中奖",
    description: '下载【新炫刊】参与“看名车志，赢车模”活动，赢取移动70M数据流量包或1:18精美汽车模型，100%中奖！',
    picurl: "https://mmbiz.qlogo.cn/mmbiz/icfeQvJeAJzM5ibtoBBE2SGwkpLUxZNAx8sNhcpF28ytlCRD1LXR1yibgaAmUxF5Ce0wmrpK8eP16A0sicC0MJTH9g/0",
    url: "http://mp.weixin.qq.com/s?__biz=MzA5MTUwMzMyNA==&mid=200220698&idx=1&sn=08b87ef8fada09289f48ade871e675df#rd",
    evt: clearQA
  }
];


/*
--------------------------------------------
     Begin wechat-special.coffee
--------------------------------------------
 */

mySpecial = [];

Special = function(text, id) {
  if (text === '我的奖品') {
    return true;
  } else if (mySpecial[id] === "phone") {
    return true;
  } else {
    return false;
  }
};

getAnswer = function(text, id, callback) {
  var adr, mobile, str, username;
  if (mySpecial[id] === "phone") {
    str = text;
    if (text.split(",").length <= 2) {
      return callback(_special.onetwoerror[3]);
    }
    username = text.split(",")[0];
    mobile = text.split(",")[1];
    adr = text.replace(username + ",", "");
    adr = adr.replace(mobile + ",", "");
    if (mobile.length !== 11) {
      return callback(_special.onetwoerror[1]);
    }
    return OneTwo.getLottery(id, "samsung", function(err, obj) {
      console.log(obj);
      if (obj && obj.checked === false) {
        obj.username = username;
        obj.mobile = mobile;
        obj.adr = adr;
        obj.talk = text;
        obj.checked = true;
        obj.create_at = new Date();
        obj.save();
        callback(_special.onetwo[4]);
        return delete mySpecial[id];
      } else if (obj && obj.checked === true) {
        return callback(_special.onetwo[6]);
      } else {
        return callback(_special.onetwo[1]);
      }
    });
  } else {
    console.log("start read db", id);
    return OneTwo.getLottery(id, "samsung", function(err, obj) {
      var backcontentlot, lstext;
      console.log("callback: ", err, obj);
      backcontentlot = {};
      if (obj) {
        if (obj.lot === "phone") {
          mySpecial[id] = "phone";
          backcontentlot = _special.onetwo[3];
          console.log(backcontentlot);
          return callback(backcontentlot);
        } else if (obj.lot === "discounts") {
          backcontentlot = {
            name: "获得打折卷",
            key: "2",
            type: "text",
            backContent: "恭喜您获得了三星商城S5打折卷 ,卡号: #key ,在三星商城购买S5打九折,快去抢购吧."
          };
          backcontentlot.backContent = backcontentlot.backContent.replace('#key', obj.username);
          console.log(backcontentlot);
          obj.checked = true;
          obj.create_at = new Date();
          obj.talk = text;
          obj.save();
          return callback(backcontentlot);
        } else {
          backcontentlot = {
            name: "充值卡",
            key: "2",
            type: "text",
            backContent: "恭喜您获得了70M移动上网流量卡,卡号: #key ,尽快充值哦,欢迎继续参加我们的活动."
          };
          lstext = "恭喜您获得了70M移动上网流量卡,卡号: #key ,尽快充值哦,欢迎继续参加我们的活动.".replace('#key', obj.lot);
          backcontentlot.backContent = lstext;
          obj.checked = true;
          obj.create_at = new Date();
          obj.talk = text;
          obj.save();
          return callback(backcontentlot);
        }
      } else {
        return callback(_special.onetwo[1]);
      }
    });
  }
};

_special = {
  onetwo: [
    {
      name: "onetwo 活动将资料发送后回复.",
      key: "1",
      type: "text",
      backContent: "您的资料,我们已经收到,会尽快与您联系."
    }, {
      name: "很抱歉,您没有中奖,欢迎您继续参加我们的活动,下次活动可能您就中奖了.",
      key: "2",
      type: "text",
      backContent: "很抱歉,您没有中奖,欢迎您继续参加我们的活动,下次活动可能您就中奖了."
    }, {
      name: "充值卡",
      key: "2",
      type: "text",
      backContent: "恭喜您获得了70M移动上网流量卡,卡号: #key ,尽快充值哦,欢迎继续参加我们的活动."
    }, {
      name: "手机试用",
      key: "2",
      type: "text",
      backContent: "恭喜您获得S5 试用使用权,请您按照如下格式回复我们: 姓名,电话,发货地址 "
    }, {
      name: "记录手机用户",
      key: "2",
      type: "text",
      backContent: "谢谢, 我们已经收到了您的信息,将会尽快与您联系."
    }, {
      name: "获得打折卷",
      key: "2",
      type: "text",
      backContent: "恭喜您获得了三星商城S5打折卷 ,卡号: #key ,在三星商城购买S5打九折,快去抢购吧."
    }, {
      name: "获取过用户信息",
      key: "2",
      type: "text",
      backContent: "您已经提交过资料,请等待我们的联系."
    }
  ],
  onetwoerror: [
    {
      name: "onetwo error.",
      key: "1",
      type: "text",
      backContent: "您的用户名填写错误,请重新输入."
    }, {
      name: "onetwo error.",
      key: "2",
      type: "text",
      backContent: "您的手机号填写错误,请重新输入."
    }, {
      name: "onetwo error.",
      key: "3",
      type: "text",
      backContent: "您的地址填写错误,请重新输入."
    }, {
      name: "onetwo error.",
      key: "4",
      type: "text",
      backContent: "您填写的信息不对,请按照格式: 姓名,电话,发货地址 重新发送."
    }
  ]
};
