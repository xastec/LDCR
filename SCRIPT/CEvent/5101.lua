--寒潭魔女初始对话
--OEVENTLUA[5101] = function()
        local picid = 343;
        local name = "寒潭魔女";
	instruct_0();
        say("这里还真清闲，我喜欢这里，呵呵。",picid,0,name);

    local title = "寒潭魔女的服务";
	local str = "人间烟火 ：享受一下普通人类美女吧"
						.."*其他 ：唠唠家常好了"
						.."*ESC键：和小魔女说再见"
	local btn = {"人间烟火","其他"};
	local num = #btn;
	local r = JYMsgBox(title,str,btn,num,nil,1);
	local myName = JY.Person[0]["姓名"];

    if r == 1 then
    	local subName = Alungky_getSubName(name);
		say("我稍微说明一下喔～这些美女呢，来自您前一次分身出生的世界，也就是人类世界啦。",picid,0,name);
		say("将她们召唤到这里需要消耗血魔精华，主要用于给她们净化和傀儡。",picid,0,name);
		say("可是" .. subName .. "，把她们传送过来直接强奸不就好了？", 0, 1, myName)
		say("您别无选择，普通人进来就会被血魔结界分解掉。",picid,0,name);
		say("这么恐怖？那我听你的吧。", 0, 1, myName)
		say("这个房间将会被施法，切忌她们不可以离开这个房间，即使已经被净化和傀儡。",picid,0,name);
		say("哦对了，还有，默认情况下她们是可以被受孕的，如果不想要，记得送她们回去前和我说一声哦～",picid,0,name);
		say("选择一个好好享受吧～",picid,0,name);
		--Alungky_human_act(1,"柳侑绮");
		ALungky_fk_rouhulist(name,picid);
	elseif r == 2 then
		Alungky_MM_XMJJ_Def(picid, name);
	end

--end