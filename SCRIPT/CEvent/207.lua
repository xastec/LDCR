if instruct_16(77) == false then  --是否在队伍
	TalkEx("小子，你既然能得到这鸳鸯*双刀，就一定见过我的女儿*，她在哪？", 189, 0)  --对话
	Cls()  --清屏
	if instruct_5() then  --是否与之过招
		instruct_37(-2)  --增加品德
		TalkEx("你女儿？恐怕早已是我的刀*下亡魂了！", 0, 1)  --对话
		Cls()  --清屏
		TalkEx("啊呀呸，你这恶贼，快还我*女儿命来！", 189, 0)  --对话
		Cls()  --清屏
		if WarMain(137, 0) == false then  --战斗开始
			instruct_15()  --死亡
			Cls()  --清屏
			do return end  --无条件结束事件

		end
		instruct_3(-2, -2,0,0,0,0,0,0,0,0,0,0,0)  --修改场景事件
		Cls()  --清屏
		instruct_13()  --场景变亮
		do return end  --无条件结束事件

	end
	do return end  --无条件结束事件

end
instruct_37(1)  --增加品德
TalkEx("爹——我终于找到鸳鸯双刀*了！女儿厉害吧！", 77, 1)  --对话
Cls()  --清屏
TalkEx("呵呵，这位少侠，我这女儿*一定给你添了不少麻烦吧？", 189, 0)  --对话
Cls()  --清屏
TalkEx("什么添麻烦，是我帮了他的*大忙才对！", 77, 1)  --对话
Cls()  --清屏
TalkEx("是是是，令爱天资聪颖，身*手不凡，的确帮了我不少忙*。", 248, 1)  --对话
Cls()  --清屏
TalkEx("哈哈哈，老夫真是羡慕你们*年轻人啊。我这里有一套刀*法，就作为给你们的贺礼吧*。哈哈哈……", 189, 0)  --对话
Cls()  --清屏
instruct_2(140, 1)  --得到或失去物品
Cls()  --清屏
instruct_14()  --场景变黑
instruct_3(-2, -2,0,0,0,0,0,0,0,0,0,0,0)  --修改场景事件
Cls()  --清屏
instruct_13()  --场景变亮
do return end
