TalkEx("啊，原来是这样啊……", 0, 1)  --对话
Cls()  --清屏
instruct_2(79, 1)  --得到或失去物品
Cls()  --清屏
instruct_3(-2, -2,0,0,0,0,0,0,0,0,0,0,0)  --修改场景事件
if instruct_16(49) then  --是否在队伍
	instruct_33(49,101,0)  --学会武功
	Cls()  --清屏
	instruct_34(49,10)  --增加资质
	Cls()  --清屏

end
do return end
