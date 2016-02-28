TalkEx("你准备好了吗？", 129, 0)  --对话
Cls()  --清屏
if instruct_5() == false then  --是否与之过招
	do return end  --无条件结束事件
	Cls()  --清屏

end
if WarMain(177, 1) == false then  --战斗开始
	Cls()  --清屏
	instruct_13()  --场景变亮
	TalkEx("看来少侠还需努力一番才是*！", 129, 0)  --对话
	Cls()  --清屏
	do return end  --无条件结束事件

end
Cls()  --清屏
instruct_13()  --场景变亮
TalkEx("好，好，少侠武功盖世，这*本书理应归少侠所有。", 129, 0)  --对话
Cls()  --清屏
instruct_2(148, 1)  --得到或失去物品
Cls()  --清屏
TalkEx("咱们有缘再见！", 129, 0)  --对话
Cls()  --清屏
instruct_3(-2, -2,0,0,0,0,0,0,0,0,-2,-2,-2)  --修改场景事件
instruct_3(-2, 0,1,0,499,0,0,-2,-2,-2,-2,-2,-2)  --修改场景事件
Cls()  --清屏
do return end
