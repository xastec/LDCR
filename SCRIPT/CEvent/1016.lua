if instruct_4(194) == false then  --是否使用物品
	Cls()  --清屏
	do return end  --无条件结束事件

end
instruct_32(194,-1)  --得到或失去物品
TalkEx("好一只翡翠杯！*得此美酒佳器，*人生更有何憾．*我祖千秋先乾为敬，*谢谢兄弟赠杯之情．", 88, 0)  --对话
Cls()  --清屏
instruct_37(1)  --增加品德
if instruct_9() == false then  --是否要求加入
	instruct_3(-2, -2,1,0,1017,0,0,-2,-2,-2,-2,-2,-2)  --修改场景事件
	Cls()  --清屏
	do return end  --无条件结束事件

end
TalkEx("先生既好这杯中之物，不如*与在下同游江湖，也好品尝*这天下美酒！", 0, 1)  --对话
Cls()  --清屏
TalkEx("哈哈哈，既然如此，恭敬不*如从命。", 88, 0)  --对话
Cls()  --清屏
instruct_3(104, 71,1,0,989,0,0,7020,7020,7020,-2,-2,-2)  --修改场景事件
if instruct_20() == false then  --判断队伍是否已满
	instruct_14()  --场景变黑
	instruct_3(-2, -2,0,0,0,0,0,0,0,0,0,0,0)  --修改场景事件
	Cls()  --清屏
	instruct_13()  --场景变亮
	instruct_10(88)  --加入队伍
	Cls()  --清屏
	do return end  --无条件结束事件

end
TalkEx("你的队伍已满，我就直接去*小村吧。", 88, 0)  --对话
Cls()  --清屏
instruct_14()  --场景变黑
instruct_3(70, 43,1,0,191,0,0,7020,7020,7020,-2,-2,-2)  --修改场景事件
Cls()  --清屏
instruct_13()  --场景变亮
do return end
