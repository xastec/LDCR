TalkEx("小子，你擅闯铁掌山，是何*用意？", 67, 0)  --对话
Cls()  --清屏
TalkEx("哦，我是来看看这里有没有*我要找的东西。", 0, 1)  --对话
Cls()  --清屏
TalkEx("你要找什么？", 67, 0)  --对话
Cls()  --清屏
TalkEx("十四天书", 0, 0)  --对话
Cls()  --清屏
TalkEx("呵呵呵，你小子想做武林盟*主啊，也不撒泡尿照照自己*，你像吗？别说铁掌山没有*天书，就是有，你也拿不去*啊。", 67, 0)  --对话
Cls()  --清屏
if instruct_5() == false then  --是否与之过招
	TalkEx("这裘千仞武功不凡，我还是*不要惹他了。", 0, 1)  --对话
	Cls()  --清屏
	do return end  --无条件结束事件

end
TalkEx("士可杀，不可辱，我今日就*要领教铁掌水上飘的手段！", 245, 1)  --对话
Cls()  --清屏
if WarMain(71, 0) == false then  --战斗开始
	instruct_15()  --死亡
	Cls()  --清屏
	do return end  --无条件结束事件

end
Cls()  --清屏
instruct_13()  --场景变亮
TalkEx("怎么样，我像不像武林盟主*啊？", 0, 1)  --对话
Cls()  --清屏
TalkEx("…………", 67, 0)  --对话
Cls()  --清屏
instruct_3(-2, -2,1,0,470,0,0,-2,-2,-2,-2,-2,-2)  --修改场景事件
do return end
