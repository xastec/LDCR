instruct_26(61,19,1,0,0)  --修改场景事件
instruct_26(61,18,1,0,0)  --修改场景事件
instruct_25(28,24,28,17)  --场景移动
Cls()  --清屏
TalkEx("侠客岛赏善罚恶使者，*前来拜见雪山派掌门！", 41, 0)  --对话
Cls()  --清屏
TalkEx("尊驾二位便是侠客岛的赏善*罚恶使者吗？", 43, 0)  --对话
Cls()  --清屏
TalkEx("正是。*不知那位是雪山派掌门人？**我们奉侠客岛岛主之命，手*持铜牌前来，邀请贵派掌门*赴敝岛相叙，喝碗腊八粥。", 42, 0)  --对话
Cls()  --清屏
instruct_25(28,17,28,24)  --场景移动
TalkEx("＜凭我过人的直觉，这侠客*岛上一定有天书的线索，  *不是有本书与\"侠\"字有  关*联吗？＞", 0, 1)  --对话
Cls()  --清屏
instruct_30(28,24,28,19)  --人物移动
TalkEx("二位使者，我可以去侠客岛*么？", 0, 1)  --对话
Cls()  --清屏
TalkEx("恐怕不行，侠客岛所邀请的*是各门派的掌门及对武学有*特殊见解的武林高手。", 42, 0)  --对话
Cls()  --清屏
TalkEx("白大侠，你的掌门之位可不*可以让给我？", 0, 1)  --对话
Cls()  --清屏
TalkEx("这位少侠，白某再次谢过你*的救命之恩。不过白某乃是*雪山派掌门，断无让与旁人*之理。", 43, 0)  --对话
Cls()  --清屏
TalkEx("这样吧，咱俩比试一场，看*看谁更有资格去。", 0, 1)  --对话
Cls()  --清屏
if WarMain(59, 0) == false then  --战斗开始
	instruct_15()  --死亡
	Cls()  --清屏
	do return end  --无条件结束事件

end
Cls()  --清屏
instruct_13()  --场景变亮
TalkEx("前辈 ，承让了！", 0, 1)  --对话
Cls()  --清屏
TalkEx("少侠武功高强，白某佩服，*看来我是无脸去喝这腊八粥*了。", 43, 0)  --对话
Cls()  --清屏
TalkEx("好！*这位兄弟，十二月初八，*请到侠客岛喝碗腊八粥。", 41, 0)  --对话
Cls()  --清屏
instruct_14()  --场景变黑
instruct_3(-2, 11,0,0,0,0,0,0,0,0,0,0,0)  --修改场景事件
instruct_3(-2, 10,0,0,0,0,0,0,0,0,0,0,0)  --修改场景事件
instruct_3(-2, 13,0,0,0,0,0,0,0,0,0,0,0)  --修改场景事件
instruct_3(-2, 12,0,0,0,0,0,0,0,0,0,0,0)  --修改场景事件
instruct_3(-2, 5,1,0,389,0,0,-2,-2,-2,-2,-2,-2)  --修改场景事件
instruct_3(-2, 9,1,0,387,0,0,-2,-2,-2,-2,-2,-2)  --修改场景事件
instruct_3(-2, 8,1,0,389,0,0,-2,-2,-2,-2,-2,-2)  --修改场景事件
instruct_3(-2, 7,1,0,389,0,0,-2,-2,-2,-2,-2,-2)  --修改场景事件
instruct_3(-2, 6,1,0,389,0,0,-2,-2,-2,-2,-2,-2)  --修改场景事件
instruct_3(94, 16,1,0,392,0,0,-2,-2,-2,-2,-2,-2)  --修改场景事件
Cls()  --清屏
instruct_13()  --场景变亮
instruct_2(198, 1)  --得到或失去物品
Cls()  --清屏
instruct_37(1)  --增加品德
do return end
