TalkEx("师父说我的五虎断门刀已练*到十成，威力巨大。可是我*从未和人交过手，不知道到*底是真是假。", 208, 0)  --对话
Cls()  --清屏
if instruct_5() == false then  --是否与之过招
	do return end  --无条件结束事件
	Cls()  --清屏

end
TalkEx("那我就来陪你练练吧。", 0, 1)  --对话
Cls()  --清屏
if WarMain(208, 0) == false then  --战斗开始
	Cls()  --清屏
	instruct_13()  --场景变亮
	TalkEx("哈哈哈，我的刀法果然厉害*，看来我将成为下一个金刀*无敌啦。", 208, 0)  --对话
	Cls()  --清屏
	instruct_3(-2, -2,1,0,765,0,0,-2,-2,-2,-2,-2,-2)  --修改场景事件
	do return end  --无条件结束事件

end
Cls()  --清屏
instruct_13()  --场景变亮
TalkEx("什么烂刀法，居然一点也不*管用，哼，给你吧，我不学*了！", 208, 0)  --对话
Cls()  --清屏
instruct_2(143, 1)  --得到或失去物品
Cls()  --清屏
instruct_3(-2, -2,0,0,0,0,0,0,0,0,0,0,0)  --修改场景事件
Cls()  --清屏
instruct_37(-1)  --增加品德
do return end
