TalkEx("行走江湖，最重要的就是使*自己保持在正道之上。", 68, 0)  --对话
Cls()  --清屏
if instruct_28(0,99,999) == false then  --判断品德是否在范围之内
	do return end  --无条件结束事件
	Cls()  --清屏

end
instruct_14()  --场景变黑
instruct_3(-2, 27,1,0,0,0,0,7102,7102,7102,-2,-2,-2)  --修改场景事件
Cls()  --清屏
instruct_13()  --场景变亮
instruct_30(38,25,39,25)  --人物移动
instruct_30(39,25,39,22)  --人物移动
TalkEx("晚辈参见重阳真人", 0, 1)  --对话
Cls()  --清屏
TalkEx("不必多礼。少侠武功卓绝，*更难得的是行走江湖始终保*持在正道之上，不愧为当今*武林第一人，这部九阴真经*，只有少侠才真正有资格成*为它的主人。", 129, 0)  --对话
Cls()  --清屏
TalkEx("多谢重阳真人。", 0, 1)  --对话
Cls()  --清屏
instruct_2(84, 1)  --得到或失去物品
Cls()  --清屏
instruct_3(-2, 27,0,0,0,0,0,0,0,0,-2,-2,-2)  --修改场景事件
instruct_3(-2, 0,1,0,497,0,0,-2,-2,-2,-2,-2,-2)  --修改场景事件
Cls()  --清屏
do return end
