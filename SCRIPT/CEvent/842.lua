instruct_14()  --场景变黑
instruct_13()  --场景变亮
instruct_25(25,42,31,36)  --场景移动
TalkEx("一个死丫头，还有个瘸铁匠*，嘿嘿，黄老邪果然尽捡些*脓包来做弟子，到世上丢人*现眼。", 161, 0)  --对话
Cls()  --清屏
TalkEx("请你莫说我恩师坏话。", 236, 0)  --对话
Cls()  --清屏
TalkEx("人家早不要你做弟子了，你*还恩师长、恩师短的，也不*怕人笑掉了牙齿。", 161, 0)  --对话
Cls()  --清屏
if instruct_16(78) then  --是否在队伍
	TalkEx("谁敢说我恩师？即使他不认*我们做徒弟，我们也永远认*他做恩师！", 78, 1)  --对话
	Cls()  --清屏

end
TalkEx("东邪黄药师，天下闻名，你*这道姑真是不知天高地厚！", 245, 1)  --对话
Cls()  --清屏
TalkEx("哼，又来个不知所谓的小子*，去死吧！", 161, 0)  --对话
Cls()  --清屏
if WarMain(52, 0) == false then  --战斗开始
	Cls()  --清屏
	instruct_15()  --死亡
	Cls()  --清屏
	do return end  --无条件结束事件
	Cls()  --清屏

end
instruct_19(30, 37)  --设置人物XY坐标
instruct_40(1)  --设置主角方向
instruct_3(-2, 3,0,0,0,0,0,0,0,0,0,0,0)  --修改场景事件
Cls()  --清屏
instruct_13()  --场景变亮
TalkEx("咦？她好像掉了一本书……*哈哈，这李莫愁临走了居然*还送我礼物，也不是传说中*的那么坏嘛。", 247, 1)  --对话
Cls()  --清屏
instruct_2(110, 1)  --得到或失去物品
Cls()  --清屏
instruct_3(-2, 2,0,0,0,0,846,0,0,0,-2,-2,-2)  --修改场景事件
do return end
