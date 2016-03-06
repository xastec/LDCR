--魔镜初始对话
--OEVENTLUA[8007] = function()
    local picid = 330;
    local isAlungky = 1;
	instruct_0();
	if isAlungky == 1 then
        say("你好～亚修斯，有什么可以帮助你的？",picid,0,"魔镜");
    end
	local title = "魔镜的服务";
	local str = "挑战：惊险刺激的挑战，等着你！"
						.."*练功：进入练功房，经验是双儿那的两倍哦。"
						.."*任务：接受并完全任务，会有相应奖励。"
                                                .."*回家：传送回血魔结界，只能是您自己。"
						.."*ESC键：和魔镜说再见"
	local btn = {"挑战","练功","任务","回家"};
	local num = #btn;
	local r = JYMsgBox(title,str,btn,num,nil,1);

        if r == 1 then
		Fight();
	elseif r == 2 then
		LianGong();
	elseif r == 3 then
		DYRW();
	elseif r == 4 then
		if isAlungky == 1 then
			say("嗯嗯，有空就回家看看吧。",picid,0,"魔镜");
			Alungky_tranfort_XMJJ();
		else
			say("你不是亚修斯大人，我无法帮你传送去那，不过可以试试别的地方。",picid,0,"魔镜");	
			My_ChuangSong_List();
		end
	end
--end