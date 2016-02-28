if instruct_4(208) then  --是否使用物品
	instruct_3(-2, -2,1,0,0,0,0,3500,3500,3500,-2,-2,-2)  --修改场景事件
	Cls()  --清屏
	instruct_32(208,-1)  --得到或失去物品
	instruct_2(218, 1)  --得到或失去物品
	Cls()  --清屏
	do return end  --无条件结束事件

end
Cls()  --清屏
do return end
