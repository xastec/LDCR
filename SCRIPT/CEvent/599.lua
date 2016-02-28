TalkEx("老先生，怎麽一个人坐在这*下棋，这棋一个人下的起来*吗？", 0, 1)  --对话
Cls()  --清屏
TalkEx("小兄弟，难道你对我这\"珍*珑\"也有兴趣？", 115, 0)  --对话
Cls()  --清屏
TalkEx("\"珍珑\"？这盘局很难解吗？", 0, 1)  --对话
Cls()  --清屏
TalkEx("这个珍珑棋局乃先师所设。*先师当年穷三年之心血，这*才布成，深盼当世棋道中的*知心之士，予以破解。*老朽三十年来苦加钻研，皆*未能参解得透。*精通禅理之人，自知禅宗要*旨，在於\"顿悟\"。穷年累*月的苦功，未必能及具有宿*根慧心之人的一见即悟。*棋道也是一般，才气横溢的*八九岁小儿，棋枰上往往能*胜一流高手。虽然老朽参研*不透，但天下才士甚众，未*必都破解不得。*先师当年留下了这个心愿，*倘若有人破解开了，完了先*师这个心愿，先师虽已不在*人世，泉下有知，也必大感*欣慰。", 115, 0)  --对话
Cls()  --清屏
if instruct_16(49) == false then  --是否在队伍
	TalkEx("可惜晚辈棋力不佳，否则我*倒也想试一试。", 0, 1)  --对话
	Cls()  --清屏
	TalkEx("这棋原是极难，棋力不弱之*人，若解不开甚至有可能走*火入魔。公子不勉强自己，*也好。", 115, 0)  --对话
	Cls()  --清屏
	do return end  --无条件结束事件

end
TalkEx("晚辈棋力不佳，不过我玩玩*看好了。", 0, 1)  --对话
Cls()  --清屏
TalkEx("公子请。", 115, 0)  --对话
Cls()  --清屏
instruct_14()  --场景变黑
instruct_13()  --场景变亮
TalkEx("嗯。。。前去无路，後有追*兵，正也不是，邪也不是，*那可难也！。。。*＜咦，棋局上的白子黑子似*乎都化做了各派高手，东一*堆使剑，西一堆使拳，你围*住我，我围住你，互相纠缠*不清的厮杀。。。。。。。*我方白色的人马被黑色各派*高手给围住了，左冲右突，*始终杀不出重围。。。。＞**难道我天命已尽，一切枉费*心机了。我这样努力的找寻*\"十四天书\"，终究要化作*一场梦！*时也命也，夫复何言？*我不如死了算了。", 244, 1)  --对话
Cls()  --清屏
TalkEx("不可如此！*＜大哥似乎入魔障了，怎麽*办？*有了，我解不开这棋局，但*捣乱一番，让他心神一分，*便有救了。。。。。。。＞*我来解这棋局。*嗯！就下在这里好了。", 49, 1)  --对话
Cls()  --清屏
TalkEx("胡闹，胡闹，你自填一气，*自己杀死一块白棋，那有这*等的下法。", 115, 0)  --对话
Cls()  --清屏
TalkEx("咦！难道竟是这样？*前辈你看，白棋故意挤死了*一大块後，接下来就好下多*了。", 0, 1)  --对话
Cls()  --清屏
TalkEx("这。。这。。。*这\"珍珑\"竟然解了，原来*关键在於第一着的怪棋。*这局棋原本纠缠於得失胜败*之中，以至无可破解，小和*尚这一着不着意於生死，更*不着意於胜败，反而勘破了*生死，得到解脱。。。。。", 115, 0)  --对话
Cls()  --清屏
TalkEx("小僧棋艺低劣，胡乱下子，*志在救人。。", 49, 1)  --对话
Cls()  --清屏
TalkEx("贤弟误打误撞，反而收其效*果。", 247, 1)  --对话
Cls()  --清屏
TalkEx("神僧天赋英才，可喜可贺。*请入屋内。", 115, 0)  --对话
Cls()  --清屏
instruct_14()  --场景变黑
instruct_3(-2, 1,0,0,0,0,0,6486,6486,6486,-2,-2,-2)  --修改场景事件
instruct_3(-2, 2,0,0,0,0,0,6450,6450,6450,-2,-2,-2)  --修改场景事件
instruct_21(49)  --离开队伍
Cls()  --清屏
instruct_13()  --场景变亮
instruct_25(17,28,24,19)  --场景移动
instruct_44(1,6486,6520,2,6450,6484)  --结束动画
instruct_44(1,6486,6520,2,6450,6484)  --结束动画
instruct_44(1,6486,6520,2,6450,6484)  --结束动画
TalkEx("小和尚，你体内已没有半分*少林内力，而我七十年的逍*遥派内功也尽数传给了你，*你已经对我磕过了头，难道*就不肯叫我一声师父吗？", 116, 0)  --对话
Cls()  --清屏
TalkEx("师……师父……", 49, 1)  --对话
Cls()  --清屏
TalkEx("好。这是我逍遥派的掌门指*环，今日传给你，你要替我*杀了我们逍遥派的大仇人，*恶贼星宿老怪丁春秋！", 116, 0)  --对话
Cls()  --清屏
TalkEx("我听说那丁……丁施主……*是个恶人，但是武功高强，*小和尚本领低微，恐怕……", 49, 1)  --对话
Cls()  --清屏
TalkEx("你体内已有我七十年的内功*，难道还怕那丁春秋不成！*你的武功招式不行，这是我*们逍遥派的武功秘笈，你拿*去学学吧。另外，我还有两*个师妹……", 116, 0)  --对话
Cls()  --清屏
TalkEx("哦……*老前辈、老前辈，你怎么了*……", 49, 0)  --对话
Cls()  --清屏
instruct_25(24,19,17,28)  --场景移动
instruct_14()  --场景变黑
instruct_17(-2,1,22,24,1532)  --设置场景的值
instruct_17(-2,1,22,23,1534)  --设置场景的值
instruct_17(-2,1,23,24,0)  --设置场景的值
instruct_17(-2,1,24,24,1536)  --设置场景的值
instruct_17(-2,1,24,23,1538)  --设置场景的值
instruct_3(-2, 0,1,0,0,0,0,0,0,0,-2,-2,-2)  --修改场景事件
instruct_3(-2, 3,1,0,0,0,0,6342,6342,6342,-2,-2,-2)  --修改场景事件
instruct_3(-2, 2,1,0,0,0,0,6522,6522,6522,-2,-2,-2)  --修改场景事件
instruct_3(-2, 1,1,0,0,0,0,6524,6524,6524,-2,-2,-2)  --修改场景事件
Cls()  --清屏
instruct_13()  --场景变亮
TalkEx("奇怪，怎麽进去这麽久．．*我也进去看看好了．", 0, 1)  --对话
Cls()  --清屏
do return end
