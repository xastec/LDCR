if instruct_60(-2,25,2286) then  --判断场景事件
	TalkEx("嘿嘿，我叫何师我。", 207, 0)  --对话
	Cls()  --清屏
	TalkEx("咦，你手上拿的是什么？", 0, 1)  --对话
	Cls()  --清屏
	TalkEx("这个，是我讨饭用的……", 207, 0)  --对话
	Cls()  --清屏
	TalkEx("这，这明明是丐帮丢失的打狗棒……", 0, 1)  --对话
	Cls()  --清屏
	instruct_14()  --场景变黑
	instruct_3(-2, -2,1,0,0,0,0,7138,7138,7138,-2,-2,-2)  --修改场景事件
	Cls()  --清屏
	instruct_13()  --场景变亮
	TalkEx("哼，居然被你发现了，你待*怎样？", 84, 0)  --对话
	Cls()  --清屏
	if instruct_5() then  --是否与之过招
		TalkEx("大胆狂徒，还不将宝物归还*丐帮！", 245, 1)  --对话
		Cls()  --清屏
		TalkEx("小子，你找死。", 84, 0)  --对话
		Cls()  --清屏
		if WarMain(201, 0) == false then  --战斗开始
			instruct_15()  --死亡
			Cls()  --清屏
			do return end  --无条件结束事件
			Cls()  --清屏

		end
		instruct_3(-2, -2,0,0,0,0,0,0,0,0,0,0,0)  --修改场景事件
		instruct_3(51, 12,1,0,592,0,0,-2,-2,-2,-2,-2,-2)  --修改场景事件
		instruct_3(51, 13,1,0,592,0,0,-2,-2,-2,-2,-2,-2)  --修改场景事件
		Cls()  --清屏
		instruct_13()  --场景变亮
		instruct_2(49, 1)  --得到或失去物品
		Cls()  --清屏
		instruct_37(1)  --增加品德
		Cls()  --清屏
		do return end  --无条件结束事件

	end
	if instruct_9() then  --是否要求加入
		if instruct_28(0,30,999) == false then  --判断品德是否在范围之内
			instruct_37(-5)  --增加品德
			TalkEx("哈哈，原来阁下也看上了这*丐帮帮主之位。少侠在江湖*上早已英名远播，呵呵，在*下愿意跟随少侠。", 84, 0)  --对话
			Cls()  --清屏
			if instruct_20() == false then  --判断队伍是否已满
				instruct_14()  --场景变黑
				instruct_3(-2, -2,0,0,0,0,0,0,0,0,0,0,0)  --修改场景事件
				instruct_3(51, 25,0,0,0,0,594,0,0,0,-2,-2,-2)  --修改场景事件
				Cls()  --清屏
				instruct_13()  --场景变亮
				instruct_2(49, 1)  --得到或失去物品
				Cls()  --清屏
				instruct_10(84)  --加入队伍
				Cls()  --清屏
				do return end  --无条件结束事件

			end
			instruct_14()  --场景变黑
			instruct_3(-2, -2,0,0,0,0,0,0,0,0,0,0,0)  --修改场景事件
			instruct_3(70, 34,1,0,183,0,0,7016,7016,7016,-2,-2,-2)  --修改场景事件
			instruct_3(51, 25,0,0,0,0,594,0,0,0,-2,-2,-2)  --修改场景事件
			Cls()  --清屏
			instruct_13()  --场景变亮
			instruct_2(49, 1)  --得到或失去物品
			Cls()  --清屏
			do return end  --无条件结束事件

		end
		TalkEx("这个，道不同不相为谋。", 84, 0)  --对话
		instruct_3(-2, -2,1,0,590,0,0,-2,-2,-2,-2,-2,-2)  --修改场景事件
		Cls()  --清屏
		do return end  --无条件结束事件

	end
	TalkEx("这事与我无关，我才懒得理*。", 0, 1)  --对话
	instruct_3(-2, -2,1,0,590,0,0,-2,-2,-2,-2,-2,-2)  --修改场景事件
	Cls()  --清屏
	do return end  --无条件结束事件

end
TalkEx("嘿嘿嘿嘿……", 207, 0)  --对话
Cls()  --清屏
do return end
