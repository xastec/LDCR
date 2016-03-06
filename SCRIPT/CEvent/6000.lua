--OEVENTLUA[690] = function()
  local name = "丁铛"
  local picid = 238
  local notVirgin = GetS(112,41,41,5);  --避免重复触发
  local myName = JY.Person[0]["姓名"];
  local herName = JY.Person[92]["姓名"];
  local herPicId = 303;

  local condifini = GetD(60,19,2);
  if condifini > 0 then
    return
  end
  if notVirgin == 10 or CC.Alungky_WXNName ~= herName then
    return
  end

  say(name .. "，真性感啊，真想得到她。",0,1,myName);
  say("人家都已经走远了，你想追她呀？", herPicId, 0, herName);
  say("我就想来一发，射在她私密小穴的最深处～～",0,1,myName);
  say("不行了我受不了了，好妹妹帮帮我吧？",0,1,myName);
  say("怎么帮你啊？（假装不解）", herPicId, 0, herName);
  say("我知道你行的，你假扮她，让我来一发，快快快。",0,1,myName);
  say("真讨厌，把人家当肉壶……", herPicId, 0, herName);
  instruct_30(42,21,42,14);  
  say("你确定在这里？", herPicId, 0, herName);
  say("嗯嗯，就这里了，快脱裤子。",0,1,myName);
  say("（脱下裤子，靠在墙边，双腿左右交叉，诱惑无比）", herPicId, 0, herName);
  say(name .. "我来了，我要很猛，很快，很快占有你（受不了啦!）",0,1,myName);
  instruct_14()
  instruct_13()
  SetS(60,42,16,2,6376);
  say("啊！你们～（面对眼前的一切惊呆了）", picid, 0, name);
  say("对不起，我只是忘记了一个东西（连忙转身），我走了你们继续。", picid, 0, name);
  say("你不是退房了吗？进来也不敲门（假装恼火，怒吼）", herPicId, 0, herName);
  say("(瞬间捡起旁边的鞋子，砸向" .. name ..")", herPicId, 0, herName);
  say("砰！(正中脑门，晕倒在地)", picid, 0, name);
  AddPersonAttrib(92,"攻击力",20);
  AddPersonAttrib(92,"暗器技巧",30);
  DrawString(CC.ScreenW/2 - 9*CC.DefaultFont,CC.ScreenH/2,herName .. "攻击力＋２０，暗器技巧＋３０",C_GOLD,CC.DefaultFont);
  instruct_14()
  instruct_13()
  say("哥你看，她晕倒了耶～", herPicId, 0, herName);
  say("别说话，我快射了（冲刺中）",0,1,myName);
  say(name .. "她晕倒在你旁边！", herPicId, 0, herName);
  instruct_30(42,14,42,15);
  say("啊，我的" .. name .. "在哪里？（恍然大悟）",0,1,myName);
  say("不行，要射了，直接射在我的" .. name .. "里面",0,1,myName);
  say("（说话间，已快速将"..name .. "下体衣服扒光）", herPicId, 0, herName);
  local fuckid = "v2"
  AlungkySaywithPic("我性感的小美人竟然穿这种喔，不行了要爆发了（说罢抓起" .. name .. "的美腿）", 0, 1, myName, fuckid)
  AlungkySaywithPic("进入就疯狂抽插，一边射一边插，嗯嗯就这样..", 0, 1, myName, fuckid)
  AlungkySaywithPic("我的小宝贝，小" .. name .. "，我终于得到你啦～（用力插入，"..name.."初夜落红）", 0, 1, myName, fuckid)
  for i=1, 10 do
            Alungky_show_pic(fuckid .. "-1")
            Alungky_show_pic(fuckid .. "-2")
  end
  AlungkySaywithPic("好紧，好湿，好爽！我要全部射在里面，全部！！！", 0, 1, myName, fuckid .. "-1");
  AlungkySaywithPic("啊，嗯，啊，好痛（虽已昏迷，但下面动作很大，迷迷糊糊）", picid, 0, name,fuckid .. "-2");
  AlungkySaywithPic("啊……小"..name.."……我好爱你。（满满的射入蜜穴，都满铺出来）", 0, 1, myName, fuckid .. "-3");
  AlungkySaywithPic("嗯……啊！！（又晕了过去）", picid, 0, name, fuckid .. "-3");
  instruct_14()
  instruct_13()
  say("完事了就这样走人？", herPicId, 0, herName);
  say("对啊，这个要处理一下",0,1,myName);
  say("你看看你，人家第一次就这么暴力，我来吧，给我十分钟。", herPicId, 0, herName);
  instruct_14()
  SetS(60,42,16,2,0);
  instruct_13()
  say("走吧～让她好好睡一觉", herPicId, 0, herName);
  instruct_30(42,15,42,22);
  instruct_30(42,22,34,22);
  instruct_30(34,22,34,16);
  instruct_30(34,16,30,16);
  instruct_30(30,16,30,15);
  say("掌柜的，我二号房间那个朋友想再住两个时辰，给你钱。", herPicId, 0, herName);
  instruct_30(30,16,30,20);
  SetS(60,38,14,2,6376);
  instruct_25(30,20,38,14);
  say("头好痛，我怎么还在睡觉？好象有什么事情想不起来了（下面也好痛，难道大姨妈来了？）", picid, 0, name);
  say("啊！对了我想起来了……希望那对男女去救天哥了，我也该动身了。", picid, 0, name);
  instruct_14()
  SetS(60,38,14,2,0);
  instruct_13()
  instruct_25(38,14,30,20);
  SetS(112,41,41,5,10);
  instruct_3(60,31,0,0,0,0,0,0,0,0,0,-2,-2);
--end