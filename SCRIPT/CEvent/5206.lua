--红玉初始对话
--OEVENTLUA[5205] = function()
        local picid = 350;
        local name = "宇佐美绫月";
        local picid2 = 351;
        local name2 = "长尾枫";
        local myname = JY.Person[0]["姓名"];
	instruct_0();
        say("小吉，好久不见啦～",picid,0,name);
	local title = "望月泉在开小差";
	local str = "爱爱 ：二丕哟"
						.."*揉捏 ：咪咪好性感"
						.."*ESC键：专心练功吧"
	local btn = {"爱爱","揉捏"};
	local num = #btn;
	local r = JYMsgBox(title,str,btn,num,nil,1);
    if r == 1 then
		say("泉，来让我爽，让我爽",0,1,myname );
		say("嗯小吉，好的，你说怎么样就怎么样，哦对啦，先给你按摩～",picid,0,name);
		AlungkySaywithPic("哇很不错，好舒服哦，又大，又软，又有弹性", 0, 1, myname, "/CW_LY/1");
		AlungkySaywithPic("舒服不舒服……小吉", picid,0, name, "/CW_LY/2");
		AlungkySaywithPic("太爽了，好想射了！不行！我要射在里面的，快躺下，泉！", 0, 1, myname, "/CW_LY/2");
		AlungkySaywithPic("哦，那好吧～",picid,0, name, "/CW_LY/1");
		say("我可以加入嘛～",picid2,0,name2);
		say("可以啊，不过我们已经到直接射在里面的阶段了。",0,1,myname );
		say("好啊～（脱光衣服，用手摩擦自己的小穴希望她尽快湿润）",picid2,0,name2);
		AlungkySaywithPic("我们已经准备好了哟～", picid,0, name, "/CW_LY/3");
		AlungkySaywithPic("嘿嘿，选一个进吧！", picid2,0, name2, "/CW_LY/3");
		AlungkySaywithPic("我两个都要，哈哈",0,1,myname, "/CW_LY/3-1");
		for i = 1,10 do
			Alungky_show_pic("/CW_LY/3");
			Alungky_show_pic("/CW_LY/3-1");
		end
		AlungkySaywithPic("啊哈……啊哈……", picid,0, name, "/CW_LY/3-1");
		AlungkySaywithPic("尾尾你别急哈，我来咯!",0,1,myname, "/CW_LY/4");
		for i = 1,10 do
			Alungky_show_pic("/CW_LY/4-1");
			Alungky_show_pic("/CW_LY/4");
		end
		AlungkySaywithPic("太爽，太爽了！要射了",0,1,myname, "/CW_LY/4-1");
		AlungkySaywithPic("请射在我的体内～", picid,0, name, "/CW_LY/4-1");
		AlungkySaywithPic("我的体内请你随便射～", picid2,0, name2, "/CW_LY/4-1");
		instruct_14()
    	instruct_13()
    	Alungky_show_pic("/CW_LY/5");
    	AlungkySaywithPic("真舒服，我也搞不清楚你们谁被内射了哈哈！",0,1,myname, "/CW_LY/5");
    	AlungkySaywithPic("小吉，是我啦……小吉的爱液永远留在了我的体内……", picid,0, name, "/CW_LY/5");
    	say("谢谢啦！",0,1,myname );
    	say("不客气！（嘻嘻）",picid2,0,name2);
    	instruct_14()
    	instruct_13()
	elseif r == 2 then
		Alungky_MM_XMJJ_Def(picid, name);
	end
--end