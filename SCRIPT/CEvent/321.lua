TalkEx("夏雪宜这个负心郎……", 176, 0)  --对话
Cls()  --清屏
TalkEx("你是谁？为什么说我爹爹的*坏话！", 91, 1)  --对话
Cls()  --清屏
TalkEx("你……你是温仪这个贱人的*孽种……", 176, 0)  --对话
Cls()  --清屏
TalkEx("你这老乞婆，居然敢骂我妈*妈，吃我一剑", 91, 1)  --对话
Cls()  --清屏
if WarMain(157, 0) == false then  --战斗开始
	instruct_15()  --死亡
	Cls()  --清屏
	do return end  --无条件结束事件

end
instruct_3(-2, -2,0,0,0,0,0,0,0,0,0,0,0)  --修改场景事件
Cls()  --清屏
instruct_13()  --场景变亮
TalkEx("雪宜……我来找你了……", 176, 0)  --对话
Cls()  --清屏
TalkEx("唉，其实她也蛮可怜的……", 244, 1)  --对话
Cls()  --清屏
instruct_3(95, 4,1,0,323,0,0,6818,6818,6818,-2,-2,-2)  --修改场景事件
instruct_3(95, 0,0,0,0,0,322,0,0,0,-2,-2,-2)  --修改场景事件
do return end
