TalkEx("阁下天资聪颖，我出一个对*联来考考阁下。“琴瑟琵琶*，八大王一般头面”，你能*对出下联吗？", 122, 0)  --对话
Cls()  --清屏
if instruct_60(-2,17,2800) == false then  --判断场景事件
	if instruct_5() == false then  --是否与之过招
		do return end  --无条件结束事件
		Cls()  --清屏

	end
	instruct_37(-1)  --增加品德
	if WarMain(182, 0) == false then  --战斗开始
		instruct_15()  --死亡
		Cls()  --清屏
		do return end  --无条件结束事件
		Cls()  --清屏

	end
	instruct_3(-2, -2,0,0,0,0,0,0,0,0,0,0,0)  --修改场景事件
	instruct_3(-2, 12,1,0,493,0,0,7096,7096,7096,-2,-2,-2)  --修改场景事件
	Cls()  --清屏
	instruct_13()  --场景变亮
	do return end  --无条件结束事件

end
TalkEx("这有何难，听我的。*“魑魅魍魉，四小鬼各自肚*肠”。", 0, 1)  --对话
Cls()  --清屏
TalkEx("阁下高才，佩服佩服。", 122, 0)  --对话
Cls()  --清屏
instruct_14()  --场景变黑
instruct_3(-2, -2,0,0,0,0,0,0,0,0,0,0,0)  --修改场景事件
instruct_3(-2, 12,1,0,493,0,0,7096,7096,7096,-2,-2,-2)  --修改场景事件
Cls()  --清屏
instruct_13()  --场景变亮
instruct_37(1)  --增加品德
Cls()  --清屏
do return end
