if instruct_4(211) == false then  --是否使用物品
	Cls()  --清屏
	do return end  --无条件结束事件

end
instruct_14()  --场景变黑
instruct_37(1)  --增加品德
instruct_32(211,-1)  --得到或失去物品
instruct_26(40,9,1,0,0)  --修改场景事件
instruct_26(40,10,1,0,0)  --修改场景事件
instruct_26(40,12,1,0,0)  --修改场景事件
instruct_3(-2, 101,0,0,0,0,0,5316,5316,5316,-2,-2,-2)  --修改场景事件
instruct_3(-2, 111,0,0,0,0,0,5324,5324,5324,-2,-2,-2)  --修改场景事件
instruct_3(73, 2,0,0,0,0,281,0,0,0,-2,-2,-2)  --修改场景事件
Cls()  --清屏
instruct_13()  --场景变亮
TalkEx("这，这就是我义父的头发。*他人呢？", 9, 0)  --对话
Cls()  --清屏
TalkEx("我到了冰火岛，只发现这撮*头发，却不见谢法王的人影*。", 0, 1)  --对话
Cls()  --清屏
TalkEx("我义父会到哪里去？会到哪*里去？一定是仇家把他害了*……", 9, 0)  --对话
Cls()  --清屏
TalkEx("我看不会，冰火岛地处偏远*，你要不告诉我，我也很难*找到。而且岛上并没有打斗*的痕迹，我看多半是谢法王*自己离开了。", 0, 1)  --对话
Cls()  --清屏
TalkEx("我义父双目失明，是不会一*个人走的。", 9, 0)  --对话
Cls()  --清屏
TalkEx("那说不定是一个值得他信任*的人带他走的。", 0, 1)  --对话
Cls()  --清屏
TalkEx("他在外面几乎全是仇家，哪*有什么朋友？他是本教的护*教狮王，要说朋友，也就是*我们几个。", 11, 0)  --对话
Cls()  --清屏
TalkEx("可是我们几个都在光明顶啊*。", 14, 0)  --对话
Cls()  --清屏
TalkEx("除非是紫杉老妹子。", 12, 0)  --对话
Cls()  --清屏
TalkEx("紫杉龙王？她在哪里？", 0, 1)  --对话
Cls()  --清屏
TalkEx("……她……早已不知去向…*…", 10, 0)  --对话
Cls()  --清屏
TalkEx("不行，我要去找我义父。杨*左使，外公，现在明教大事*已安排的差不多了，就请几*位留守光明顶，我要随这位*少侠去寻找义父。", 9, 0)  --对话
Cls()  --清屏
TalkEx("也好，不找回谢法王，教主*留在光明顶也不会安心。", 11, 0)  --对话
Cls()  --清屏
TalkEx("无忌，你去吧，这里就交给*我们了。", 12, 0)  --对话
Cls()  --清屏
TalkEx("……顺便……找一下紫杉龙*王……", 10, 0)  --对话
Cls()  --清屏
instruct_3(104, 46,1,0,948,0,0,7226,7226,7226,-2,-2,-2)  --修改场景事件
if instruct_20() == false then  --判断队伍是否已满
	Cls()  --清屏
	instruct_14()  --场景变黑
	instruct_3(-2, 101,0,0,0,0,0,0,0,0,-2,-2,-2)  --修改场景事件
	instruct_3(-2, 111,0,0,0,0,0,0,0,0,-2,-2,-2)  --修改场景事件
	instruct_3(-2, 109,0,0,0,0,0,0,0,0,-2,-2,-2)  --修改场景事件
	Cls()  --清屏
	instruct_13()  --场景变亮
	instruct_10(9)  --加入队伍
	do return end
end
TalkEx("你的队伍已满，我就直接去*小村吧。", 9, 0)  --对话
Cls()  --清屏
instruct_14()  --场景变黑
instruct_3(-2, 101,0,0,0,0,0,0,0,0,-2,-2,-2)  --修改场景事件
instruct_3(-2, 111,0,0,0,0,0,0,0,0,-2,-2,-2)  --修改场景事件
instruct_3(-2, 109,0,0,0,0,0,0,0,0,-2,-2,-2)  --修改场景事件
instruct_3(70, 17,1,0,107,0,0,5284,5284,5284,-2,-2,-2)  --修改场景事件
Cls()  --清屏
instruct_13()  --场景变亮
do return end
