--雪山杀老祖之后，狄云加入事件
--OEVENTLUA[8003] = function()
	
	if not instruct_9() then	--是否加入
		return;
	end
	
	Talk("狄兄弟，我们走吧。",0);		--[主角]：狄兄弟，我们走吧。
	if instruct_20() then		--是否满人
		Talk("您现在的队伍已经满人了。", 37);		--[狄云]：你现在的队伍已经满人了。
		return;
	end
	
	instruct_10(37);		--加入狄云
	Talk("我也想跟着狄大哥。",589);	--[水笙]：我也想跟着狄大哥。
	instruct_14();
	instruct_3(104, 93,1,0,3002,0,0,9224,9224,9224,-2,-2,-2);		--Alungky 水笙也去钓鱼岛
	instruct_3(-2,81,0,0,0,0,0,0,0,0,0,0,0);			--清除水笙贴图
	instruct_3(-2,80,0,0,0,0,0,0,0,0,0,0,0);			--清除狄云贴图
	
	instruct_3(70,80,1,0,8006,0,0,9220,9220,9220,0,0,0);		--水笙暂时没想到用法，先直接回小村
	instruct_13();
	
	
--end