instruct_26(40,9,1,0,0)  --修改场景事件
instruct_26(40,10,1,0,0)  --修改场景事件
instruct_26(40,12,1,0,0)  --修改场景事件
instruct_30(28,24,28,19)  --人物移动
instruct_30(28,19,30,19)  --人物移动
instruct_37(1)  --增加品德
TalkEx("明教和六大派怎么样了？", 18, 0)  --对话
Cls()  --清屏
TalkEx("明教灭了，六大派也灭了四*个了。", 0, 1)  --对话
Cls()  --清屏
TalkEx("哈哈，我果然没看错人，小*子，你干的真不错。", 18, 0)  --对话
Cls()  --清屏
TalkEx("接下来还得需要你的帮忙啊*。我今天来，是想向你借一*样东西。", 0, 1)  --对话
Cls()  --清屏
TalkEx("什么？", 18, 0)  --对话
Cls()  --清屏
TalkEx("借你的项上人头一用。", 0, 1)  --对话
Cls()  --清屏
TalkEx("你，你说什么……我们不是*一伙的么？", 18, 0)  --对话
Cls()  --清屏
TalkEx("我只要天书，谁给我天书，*我就跟谁一伙，受死吧。", 245, 1)  --对话
Cls()  --清屏
if WarMain(13, 0) == false then  --战斗开始
	instruct_15()  --死亡
	Cls()  --清屏
	do return end  --无条件结束事件
	Cls()  --清屏

end
instruct_3(-2, 0,0,0,0,0,0,0,0,0,0,0,0)  --修改场景事件
instruct_3(-2, 4,0,0,0,0,0,0,0,0,0,0,0)  --修改场景事件
instruct_3(-2, 3,0,0,0,0,0,0,0,0,0,0,0)  --修改场景事件
instruct_3(-2, 2,0,0,0,0,0,0,0,0,0,0,0)  --修改场景事件
instruct_3(-2, 1,0,0,0,0,0,0,0,0,0,0,0)  --修改场景事件
Cls()  --清屏
instruct_13()  --场景变亮
instruct_2(219, 1)  --得到或失去物品
Cls()  --清屏
do return end
