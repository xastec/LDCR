if instruct_4(201) == false then  --是否使用物品
	Cls()  --清屏
	do return end  --无条件结束事件

end
instruct_37(1)  --增加品德
instruct_32(201,-1)  --得到或失去物品
TalkEx("杨兄，你快将这服下。", 0, 1)  --对话
Cls()  --清屏
TalkEx("这是什麽？", 58, 1)  --对话
Cls()  --清屏
TalkEx("这是生长在情花丛旁的断肠*草。**我曾听人说过，凡毒蛇出没*之处，七步之内必有解毒之*药，其他毒物，无不如此。*这是天地间万物相生相克的*至理。**这断肠草正好生长在情花树*旁，虽说此草具有剧毒，但*我反覆思量，此草以毒攻毒*正是情花的对头克星。***服这毒草自是冒极大险，但*反正已无药可救，咱们就死*马当活马医，试它一试。", 0, 1)  --对话
Cls()  --清屏
TalkEx("好，我便服这断肠草试试***……啊……", 58, 0)  --对话
Cls()  --清屏
TalkEx("杨兄，怎么样？", 0, 1)  --对话
Cls()  --清屏
instruct_14()  --场景变黑
instruct_3(-2, -2,1,0,0,0,0,6186,6186,6186,-2,-2,-2)  --修改场景事件
Cls()  --清屏
instruct_13()  --场景变亮
TalkEx("我杨某这条命是少侠你救回*来的。", 58, 0)  --对话
Cls()  --清屏
TalkEx("你身上的毒质当真都解了？*还好还好，我刚真捏了把冷*汗。", 0, 1)  --对话
Cls()  --清屏
TalkEx("这次真谢谢少侠的帮忙，*让杨某从鬼门关回来。", 58, 0)  --对话
Cls()  --清屏
TalkEx("不知杨兄今後有何打算？", 0, 1)  --对话
Cls()  --清屏
TalkEx("我要去寻找我的姑姑，咱们*后会有期。", 58, 0)  --对话
Cls()  --清屏
instruct_14()  --场景变黑
instruct_3(-2, -2,0,0,0,0,0,0,0,0,0,0,0)  --修改场景事件
instruct_26(19,24,0,0,1)  --修改场景事件
Cls()  --清屏
instruct_13()  --场景变亮
do return end
