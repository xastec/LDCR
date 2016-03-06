--莉莉安初始对话
--OEVENTLUA[5011] = function()
    local picid = 335;
    local name = "莉莉安";
	instruct_0();
    say("在我这里接受训练需要消耗一定的血魔精华，不过和真实战斗没有两样，所以你懂的。",picid,0,name);

    local title = "莉莉的服务";
	local str = "练功 ：惊险刺激的练功，等着你！"
						.."*其他 ：唠唠家常吧"
						.."*ESC键：和莉莉说再见"
	local btn = {"练功","其他"};
	local num = #btn;
	local r = JYMsgBox(title,str,btn,num,nil,1);

    if r == 1 then
		say("请闭上眼睛，我将为你张开特殊结界。",picid,0,name);
		Alungky_tranfort_HJ();
		say("欢迎来到百合幻境，请选择战斗吧！",picid,0,name);
		local batID = 0;
		local title = "幻境战斗";
		local str = "普通 ：被各门派弟子围攻"
						.."*较难 ：成昆及其党羽"
						.."*困难 ：金轮法王等"
		local btn = {"普通","较难","困难"};
		local num = #btn;
		local trr = JYMsgBox(title,str,btn,num,nil,1);
        
        batID = trr;
		local isWon = Alungky_LianGong(batID);
        if isWon == true then
        	say("嗯！还不错，有空再来呀。",picid,0,name);
        else
        	say("唉失败了啊，请再接再厉。",picid,0,name);
        end
		Alungky_tranfort_XMJJ_LiLian();
	elseif r == 2 then
		Alungky_MM_XMJJ_Def(picid, name);
	end
        
--end