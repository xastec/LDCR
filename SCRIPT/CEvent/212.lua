if instruct_29(0,100,999) == false then  --判断攻击力是否在范围之内
	TalkEx("这柄剑实在太重了，根本拿*不动……", 244, 1)  --对话
	Cls()  --清屏
	do return end  --无条件结束事件

end
TalkEx("看我的！", 0, 1)  --对话
Cls()  --清屏
instruct_14()  --场景变黑
instruct_3(-2, -2,0,0,0,0,0,0,0,0,0,0,0)  --修改场景事件
instruct_3(-2, 11,1,0,213,0,0,-2,-2,-2,-2,-2,-2)  --修改场景事件
Cls()  --清屏
instruct_13()  --场景变亮
TalkEx("哈哈，终于让我拿起来了！", 247, 1)  --对话
Cls()  --清屏
instruct_2(36, 1)  --得到或失去物品
Cls()  --清屏
do return end
