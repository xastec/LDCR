TalkEx("魔教妖邪，来我峨嵋山有何*贵事．", 6, 0)  --对话
Cls()  --清屏
TalkEx("上回看你手中那把宝剑，*寒芒吞吐，电闪星飞，想必*就是传说中的”倚天剑”？*小侠我想向你借来用用．", 0, 1)  --对话
Cls()  --清屏
TalkEx("光明顶上被你侥幸获胜，*你现在还敢来我峨嵋撒野，*莫非真视我峨嵋无人．", 6, 0)  --对话
Cls()  --清屏
if instruct_5() == false then  --是否与之过招
	TalkEx("那里，那里．我只不过是来*劝师太，与明教间的事能和*就和．*自古以来冤家宜解不宜结．", 0, 1)  --对话
	Cls()  --清屏
	TalkEx("阁下未免管的太多了吧，*难道你真以为你是*”武林盟主”吗！", 6, 0)  --对话
	Cls()  --清屏
	do return end  --无条件结束事件

end
if WarMain(20, 0) == false then  --战斗开始
	instruct_15()  --死亡
	Cls()  --清屏
	do return end  --无条件结束事件
	Cls()  --清屏

end
Cls()  --清屏
instruct_13()  --场景变亮
TalkEx("宝剑还是应该配英雄，*怎样？师太，这”倚天剑”*可以让给我了吧．", 0, 1)  --对话
Cls()  --清屏
TalkEx("魔教妖孽，想从我灭绝手中*拿走倚天剑，等下辈子吧！", 6, 0)  --对话
Cls()  --清屏
instruct_27(2,5468,5496)  --显示人物动画
Cls()  --清屏
instruct_3(-2, -2,-2,-2,1063,-1,-1,5238,5238,5238,-2,-2,-2)  --修改场景事件
Cls()  --清屏
TalkEx("师父，师父！", 191, 0)  --对话
Cls()  --清屏
TalkEx("师太，师太！何苦如此呢？*若真不想给我，跟我说一声*就行了．唉！", 0, 1)  --对话
Cls()  --清屏
TalkEx("师父，师父！*可恶的魔教妖邪，*替我师父嚐命来．", 191, 0)  --对话
Cls()  --清屏
if WarMain(21, 0) == false then  --战斗开始
	instruct_15()  --死亡
	Cls()  --清屏
	do return end  --无条件结束事件
	Cls()  --清屏

end
Cls()  --清屏
instruct_13()  --场景变亮
instruct_3(-2, 4,1,0,1064,0,0,-2,-2,-2,-2,-2,-2)  --修改场景事件
instruct_3(-2, 10,1,0,1064,0,0,-2,-2,-2,-2,-2,-2)  --修改场景事件
instruct_3(-2, 9,1,0,1064,0,0,-2,-2,-2,-2,-2,-2)  --修改场景事件
instruct_3(-2, 8,1,0,1064,0,0,-2,-2,-2,-2,-2,-2)  --修改场景事件
instruct_3(-2, 7,1,0,1064,0,0,-2,-2,-2,-2,-2,-2)  --修改场景事件
instruct_3(-2, 6,1,0,1064,0,0,-2,-2,-2,-2,-2,-2)  --修改场景事件
instruct_3(-2, 5,1,0,1064,0,0,-2,-2,-2,-2,-2,-2)  --修改场景事件
instruct_3(-2, 3,1,0,1064,0,0,-2,-2,-2,-2,-2,-2)  --修改场景事件
Cls()  --清屏
instruct_37(-5)  --增加品德
Cls()  --清屏
do return end
