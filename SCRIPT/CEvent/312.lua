TalkEx("小兄弟想要与老朽切磋武学*的奥妙吗？", 5, 0)  --对话
Cls()  --清屏
TalkEx("还望前辈指导。", 0, 1)  --对话
Cls()  --清屏
if WarMain(22, 0) == false then  --战斗开始
	Cls()  --清屏
	instruct_13()  --场景变亮
	if instruct_28(0,80,999) then --判断品德是否在范围之内
		if instruct_29(0,120,9999) then  --判断攻击力是否在范围之内
			TalkEx("小兄弟资质不错，这是我武*当派的内功心法，你就拿去*吧。", 5, 0)  --对话
			Cls()  --清屏
			instruct_2(76, 1)  --得到或失去物品
			Cls()  --清屏
			instruct_3(-2, -2,1,0,313,0,0,-2,-2,-2,-2,-2,-2)  --修改场景事件
			do return end  --无条件结束事件

		end
		Cls()  --清屏

	end
	TalkEx("小兄弟，看来你还需再下一*番努力才是。", 5, 0)  --对话
	Cls()  --清屏
	do return end  --无条件结束事件

end
TalkEx("少侠武功已到如此境界，*老朽也没什麽好教你的了。", 5, 0)  --对话
Cls()  --清屏
instruct_3(-2, -2,1,0,314,0,0,-2,-2,-2,-2,-2,-2)  --修改场景事件
do return end
