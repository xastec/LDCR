instruct_14()  --场景变黑
instruct_37(1)  --增加品德
instruct_3(-2, -2,0,0,0,0,0,0,0,0,0,0,0)  --修改场景事件
instruct_13()  --场景变亮
instruct_30(42,26,38,26)  --人物移动
TalkEx("袁公子，你没事吧。", 0, 1)  --对话
Cls()  --清屏
TalkEx("还好，这五仙教的毒好厉害*！", 54, 0)  --对话
Cls()  --清屏
TalkEx("哼，我来会会他们！", 245, 1)  --对话
Cls()  --清屏
instruct_30(38,26,31,26)  --人物移动
TalkEx("快放了温姑娘！", 245, 1)  --对话
Cls()  --清屏
TalkEx("哪来的小子，长得倒挺帅啊*，咯咯，你来呀，你来呀…*…", 83, 0)  --对话
Cls()  --清屏
if WarMain(162, 0) == false then  --战斗开始
	instruct_15()  --死亡
	Cls()  --清屏
	do return end  --无条件结束事件

end
instruct_3(-2, 1,0,0,0,0,0,0,0,0,0,0,0)  --修改场景事件
instruct_3(-2, 9,0,0,0,0,0,0,0,0,0,0,0)  --修改场景事件
instruct_3(-2, 8,0,0,0,0,0,0,0,0,0,0,0)  --修改场景事件
instruct_3(-2, 7,0,0,0,0,0,0,0,0,0,0,0)  --修改场景事件
instruct_3(-2, 6,0,0,0,0,0,0,0,0,0,0,0)  --修改场景事件
instruct_3(-2, 5,0,0,0,0,0,0,0,0,0,0,0)  --修改场景事件
instruct_3(-2, 4,0,0,0,0,0,0,0,0,0,0,0)  --修改场景事件
instruct_3(-2, 3,0,0,0,0,0,0,0,0,0,0,0)  --修改场景事件
instruct_3(-2, 2,0,0,0,0,0,0,0,0,0,0,0)  --修改场景事件
instruct_3(-2, 12,0,0,0,0,0,0,0,0,0,0,0)  --修改场景事件
instruct_3(-2, 11,0,0,0,0,0,6818,6818,6818,-2,-2,-2)  --修改场景事件
instruct_3(-2, 10,0,0,0,0,0,7032,7032,7032,-2,-2,-2)  --修改场景事件
instruct_19(36, 26)  --设置人物XY坐标
instruct_40(2)  --设置主角方向
instruct_25(36,26,36,26)  --场景移动
Cls()  --清屏
instruct_13()  --场景变亮
TalkEx("袁大哥，谢谢你及时来救我*。", 91, 0)  --对话
Cls()  --清屏
TalkEx("喂，救你的还有我啊。", 246, 1)  --对话
Cls()  --清屏
TalkEx("哦，我知道，也多谢你给袁*大哥帮忙。", 91, 0)  --对话
Cls()  --清屏
TalkEx("＜同样是出手救人，差别咋*这么大呢？＞", 246, 1)  --对话
Cls()  --清屏
TalkEx("青青，他们为什么要抓你？", 54, 0)  --对话
Cls()  --清屏
TalkEx("他们说我爹爹这把金蛇剑是*从他们教里偷出来的，简直*岂有此理！", 91, 0)  --对话
Cls()  --清屏
TalkEx("夏前辈已然仙逝，从前的事*情恐怕再也弄不清了。青青*，只要你没事就好。", 54, 0)  --对话
Cls()  --清屏
TalkEx("那，我们接下来去哪里啊？", 91, 0)  --对话
Cls()  --清屏
TalkEx("华山聚会之期已近，我必须*尽快赶回华山，你随我同去*吧，拜见我恩师他老人家。", 54, 0)  --对话
Cls()  --清屏
TalkEx("好，以后你去哪儿，我就跟*你去哪儿。", 91, 0)  --对话
Cls()  --清屏
TalkEx("兄台，多谢你的相助。以后*有需要袁某的地方，尽管到*华山后山来找我。", 54, 0)  --对话
Cls()  --清屏
TalkEx("好，那咱们后会有期。", 0, 1)  --对话
Cls()  --清屏
instruct_14()  --场景变黑
instruct_3(-2, 10,0,0,0,0,0,0,0,0,0,0,0)  --修改场景事件
instruct_3(-2, 11,0,0,0,0,0,0,0,0,0,0,0)  --修改场景事件
instruct_3(80, 4,0,0,0,0,0,7064,7064,7064,-2,-2,-2)  --修改场景事件
instruct_3(80, 0,0,0,0,0,0,7066,7066,7066,-2,-2,-2)  --修改场景事件
instruct_3(80, 5,0,0,0,0,0,7068,7068,7068,-2,-2,-2)  --修改场景事件
instruct_3(80, 6,0,0,0,0,0,5364,5364,5364,-2,-2,-2)  --修改场景事件
instruct_3(80, 7,0,0,0,0,0,5404,5404,5404,-2,-2,-2)  --修改场景事件
instruct_3(80, 9,0,0,0,0,0,5404,5404,5404,-2,-2,-2)  --修改场景事件
instruct_3(80, 8,0,0,0,0,0,5178,5178,5178,-2,-2,-2)  --修改场景事件
instruct_3(80, 10,0,0,0,0,0,6818,6818,6818,-2,-2,-2)  --修改场景事件
instruct_3(80, 11,0,0,0,0,0,5436,5436,5436,-2,-2,-2)  --修改场景事件
instruct_3(80, 2,0,0,0,0,346,0,0,0,-2,-2,-2)  --修改场景事件
Cls()  --清屏
instruct_13()  --场景变亮
do return end
