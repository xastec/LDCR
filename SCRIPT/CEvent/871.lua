TalkEx("怎么样，怎么样，看我厉不*厉害？", 29, 0)  --对话
Cls()  --清屏
TalkEx("田大爷，你好强哦。", 224, 0)  --对话
Cls()  --清屏
TalkEx("是哦，田大爷，奴家好喜欢哦～～", 224, 0)  --对话
Cls()  --清屏
TalkEx("哈哈哈……咦？这位少侠，*想必是来向田某学习吧？哈*哈哈……", 29, 0)  --对话
Cls()  --清屏
TalkEx("这位兄台，那里的功夫真强*啊，请教尊姓大名？", 0, 1)  --对话
Cls()  --清屏
TalkEx("我就是江湖人称万里独行侠*的田伯光，哈哈哈……", 29, 0)  --对话
Cls()  --清屏
instruct_14()  --场景变黑
instruct_3(-2, 30,1,0,873,0,0,-2,-2,-2,-2,-2,-2)  --修改场景事件
instruct_3(-2, 31,0,0,0,0,0,5932,5932,5932,-2,-2,-2)  --修改场景事件
Cls()  --清屏
instruct_13()  --场景变亮
TalkEx("田伯光，我弟子彭人骐可是*你害死的？", 24, 0)  --对话
Cls()  --清屏
TalkEx("失敬失敬，原来是青城掌门*大家光临，这扬州丽春院从*此天下闻名，生意滔滔，再*也应接不暇了。有一个小子*是我杀的，剑法平庸，有些*像青城派的招数，至于是不*是叫什么骐，也没功夫去问*他。", 29, 0)  --对话
Cls()  --清屏
TalkEx("哼，你偿命来吧！", 24, 0)  --对话
Cls()  --清屏
TalkEx("这余老头假惺惺的，不是个*好东西。小兄弟，来帮我一*把怎么样？", 29, 0)  --对话
Cls()  --清屏
TalkEx("＜我是否该帮助田伯光呢？*＞", 0, 1)  --对话
Cls()  --清屏
if instruct_11() == false then  --是/否
	TalkEx("这个，小弟武艺低微，恐怕*……", 0, 1)  --对话
	Cls()  --清屏
	TalkEx("哼，孬种！***余观主，房中地方太小，施*展不开，咱们到院子里，大*战三百合，看看到底是谁厉*害！要是你赢了，这个千娇*百媚的小粉头玉宝儿就归你*，否则，她可是我的。", 29, 0)  --对话
	Cls()  --清屏
	instruct_14()  --场景变黑
	instruct_3(-2, 31,0,0,0,0,0,0,0,0,0,0,0)  --修改场景事件
	instruct_3(-2, 28,0,0,0,0,0,0,0,0,0,0,0)  --修改场景事件
	instruct_3(64, 0,1,0,872,0,0,5912,5924,5912,-2,-2,-2)  --修改场景事件
	Cls()  --清屏
	instruct_13()  --场景变亮
	do return end  --无条件结束事件

end
instruct_37(-3)  --增加品德
TalkEx("在下与田兄脾气相投，自当*共患难！", 0, 1)  --对话
Cls()  --清屏
TalkEx("哈哈哈，好样的，我们上！", 29, 0)  --对话
Cls()  --清屏
if WarMain(53, 0) == false then  --战斗开始
	instruct_15()  --死亡
	Cls()  --清屏
	do return end  --无条件结束事件
	Cls()  --清屏

end
instruct_3(-2, 31,0,0,0,0,0,0,0,0,0,0,0)  --修改场景事件
Cls()  --清屏
instruct_13()  --场景变亮
TalkEx("小兄弟，田某就喜欢结交你*这样的朋友，有什么需要我*帮忙的，尽管说！", 29, 0)  --对话
Cls()  --清屏
TalkEx("既然如此，我也就不和田大*哥客气了，小弟想请田大哥*帮我一同寻找十四天书……", 0, 1)  --对话
Cls()  --清屏
TalkEx("好，没问题。", 29, 0)  --对话
Cls()  --清屏
instruct_3(104, 56,1,0,953,0,0,7230,7230,7230,-2,-2,-2)  --修改场景事件
if instruct_20() == false then  --判断队伍是否已满
	instruct_3(-2, 28,0,0,0,0,0,0,0,0,0,0,0)  --修改场景事件
	instruct_10(29)  --加入队伍
	Cls()  --清屏
	do return end  --无条件结束事件

end
TalkEx("你的队伍已满，我就直接去*小村吧。", 29, 0)  --对话
Cls()  --清屏
instruct_3(-2, 28,0,0,0,0,0,0,0,0,0,0,0)  --修改场景事件
instruct_3(70, 26,1,0,117,0,0,5912,5924,5912,-2,-2,-2)  --修改场景事件
Cls()  --清屏
do return end
