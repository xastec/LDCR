--魔镜初始对话
--OEVENTLUA[5000] = function()
        local picid = 330;
	instruct_0();
        say("我可是你美丽，贤淑，温柔，聪慧的美女秘书哟～",picid,0,"魔镜");
	
	local title = "魔镜的服务";
	local str = "挑战：惊险刺激的挑战，等着你！"
						.."*练功：进入练功房，经验是双儿那的两倍哦。"
						.."*任务：接受并完全任务，会有相应奖励。"
                                                .."*小村：传送回小村，继续苍龙传奇。"
						.."*ESC键：和魔镜说再见"
	local btn = {"挑战","练功","任务","小村"};
	local num = #btn;
	local r = JYMsgBox(title,str,btn,num,nil,1);

        if r == 1 then
		say("你想挑战谁呀？结界里的姐妹我估计你一个都打不过，嘻嘻～",picid,0,"魔镜");
	elseif r == 2 then
		say("练功的话，建议去找莉莉姐，她那经验更多。",picid,0,"魔镜");
	elseif r == 3 then
		say("这里没有办法接任务，回小村再试试吧。",picid,0,"魔镜");
	elseif r == 4 then
		say("加油哦，继续去战斗吧！",picid,0,"魔镜");
		Alungky_tranfort_XC();
	end


--end