var BufferHelper,EventProxy,Segment,checkMessage,checkSignature,config,crypto,formatMessage,fs,getMessage,getParse,go_process,isEmpty,myProcess,op_Process_list,path,qs,segWord,url,xml2js;op_Process_list=[{name:"welcome",key:"你好",type:"text",backContent:"你好,好奇的人,欢迎来的桥哥的新奇世界,如果你想自己逛逛就不要理我,如果想听我的介绍,就回复LOVE.",next:[{key:"LOVE",type:"text",backContent:"你真是个聪明的人,好奇的人,在桥哥的新奇世界里,主要是介绍各种新奇的事、人、物品.",next:[{key:"事",type:"text",backContent:"看看各种事吧."},{key:"人",type:"text",backContent:"看看各种人吧."},{key:"物品",type:"image",backContent:"看看物品吧."}]}]},{name:"抽奖",key:"抽奖",type:"text",backContent:"点开下面的连接参与抽奖:\n\r http://wechat.giccoo.com"}],myProcess=!1,go_process=function(e){var t,r,o,n,s,c;if(myProcess){if(myProcess.next)for(c=myProcess.next,o=0,s=c.length;s>o;o++)if(t=c[o],t.key===e){return myProcess=t,t.backContent;break}}else for(r=0,n=op_Process_list.length;n>r;r++)if(t=op_Process_list[r],t.key===e){return myProcess=t,t.backContent;break}return myProcess=!1},fs=require("fs"),path=require("path"),crypto=require("crypto"),xml2js=require("xml2js"),url=require("url"),qs=require("querystring"),BufferHelper=require("bufferhelper"),EventProxy=require("eventproxy"),config=require("../config").config,Segment=require("segment").Segment,segWord=new Segment,segWord.use("URLTokenizer").use("WildcardTokenizer").use("PunctuationTokenizer").use("DictTokenizer").use("ChsNameTokenizer").use("EmailOptimizer").use("ChsNameOptimizer").use("DictOptimizer").use("DatetimeOptimizer").use("ForeignTokenizer").loadDict("dict.txt").loadDict("dict2.txt").loadDict(path.resolve("./dicts/carnames.txt")).loadDict("names.txt").loadDict("wildcard.txt","WILDCARD",!0),checkSignature=function(e,t){var r,o,n,s,c;return s=e.signature,c=e.timestamp,o=e.nonce,n=crypto.createHash("sha1"),r=[t,c,o].sort(),n.update(r.join("")),n.digest("hex")===s},getParse=function(e){var t;return t=url.parse(e.url).query,qs.parse(t)},isEmpty=function(e){return"object"==typeof e&&null!==e&&0===Object.keys(e).length},getMessage=function(e,t){var r;return r=new BufferHelper,r.load(e,function(e,r){var o;return e?t(e):(o=r.toString("utf-8"),xml2js.parseString(o,{trim:!0},t))})},formatMessage=function(e){var t,r,o;if(r={},!e)return!1;for(t in e.xml)o=e.xml[t][0],r[t]=(isEmpty(o)?"":o).trim();return r},checkMessage=function(e){switch(console.log(e.MsgType),e.MsgType){case"text":return console.log("文字信息"),go_process(e.Content);case"image":return console.log("图片信息");case"voice":return console.log("声音信息"),go_process(e.Recognition);case"video":return console.log("视频信息");case"location":return console.log("地理信息");case"link":return console.log("连接消息");case"event":return console.log(e.Event)}},exports.index=function(e,t,r){var o,n;return o=getParse(e),n=checkSignature(o,config.wechat_token),getMessage(e,function(e,r){var s,c;return e&&console.log(e),(c=formatMessage(r))?(s=checkMessage(c),console.log(c),s?t.render("wechat-text",{toUser:c.FromUserName,fromUser:c.ToUserName,date:(new Date).getTime(),content:s}):t.render("wechat-text",{toUser:c.FromUserName,fromUser:c.ToUserName,date:(new Date).getTime(),content:""})):t.send(n?o.echostr:"what?")})},exports.word=function(e,t,r){var o;return o=segWord.doSegment("我叫李泓桥,我要预约试驾奥迪SQ5,我想三年之内买车."),o.sort(function(e,t){return t.p-e.p}),console.log(o),t.send("contents")};