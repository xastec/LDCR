if instruct_16(90) == false then  --是否在队伍
	TalkEx("这貂儿真可爱。*咦？跑掉了……", 247, 1)  --对话
	Cls()  --清屏
	instruct_3(-2, -2,0,0,0,0,0,0,0,0,-2,-2,-2)  --修改场景事件
	instruct_3(66, 2,1,0,1069,0,0,7264,7264,7264,-2,-2,-2)  --修改场景事件
	do return end  --无条件结束事件

end
TalkEx("我的闪电貂！原来跑到这里*来了，总算找到了。", 90, 1)  --对话
Cls()  --清屏
instruct_3(-2, -2,0,0,0,0,0,0,0,0,-2,-2,-2)  --修改场景事件
instruct_35(90,0,113,800)  --设置人物武功
do return end
