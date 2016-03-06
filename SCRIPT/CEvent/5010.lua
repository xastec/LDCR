--美佳初始对话
--OEVENTLUA[5008] = function()
        local picid = 329;
        local name = "寒霜霖";
	instruct_0();
        say("相公，由于您是时间之神，所以这个世界从某一个位面看是相对静止的。",picid,0,name);

        local title = "美佳的工作";
		local str = "分析 ：模拟战斗，分析他人的武学！"
						.."*其他 ：唠唠家常吧"
						.."*ESC键：和美佳说再见"
	local btn = {"分析","其他"};
	local num = #btn;
	local r = JYMsgBox(title,str,btn,num,nil,1);

    if r == 1 then
		say("我这里几场分析好的战斗，请看。",picid,0,name);
		say("准备好了么？我们去幻境观战吧。",picid,0,name);
		My_Enter_SubScene(114,26,30,-1);

        say("请先选择一个参战者。", picid, 0, name);
        local ID1 = Alungky_Name_List(0);
        say("这个参战者将和谁对战呢？", picid, 0, name);
        local ID2 = Alungky_Name_List(1);
        say("１梦幻模拟战即将开始－－－－Ｈ：".. JY.Person[ID1]["姓名"] .. "对决" .. JY.Person[ID2]["姓名"], picid, 0, name);
	    local win = WarMain(246)
	    if win == true then
	    	say("１优胜者－－－－".. JY.Person[ID1]["姓名"] , picid, 0, name);
	    else
	    	say("１优胜者－－－－".. JY.Person[ID2]["姓名"] , picid, 0, name);
        end
	    My_Enter_SubScene(107,6,56,-1);
	elseif r == 2 then
		Alungky_MM_XMJJ_Def(picid, name);
	end
--end