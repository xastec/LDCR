--OEVENTLUA[423] = function()	--中邪线雪山派事件
    instruct_14();   --  14(E):场景变黑
    instruct_3(-2,13,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [13]
    instruct_3(-2,12,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [12]
    instruct_13();   --  13(D):重新显示场景
    instruct_25(29,24,29,17);   --  25(19):场景移动29-24--29-17
    instruct_1(1620,0,1);   --  1(1):[AAA]说: 咦？怎么两个石破天？
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(1621,38,0);   --  1(1):[石破天]说: 老伯伯，你也来啦
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(1622,164,0);   --  1(1):[???]说: 你，你，你们俩……哈哈，*居然是两个长得一摸一样的*小子！怪不得我觉得这个狗*杂种怪怪的，原来是骗我，*看我怎么收拾你！
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(1623,38,0);   --  1(1):[石破天]说: 不可！
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(1624,164,0);   --  1(1):[???]说: 你说什么？你是不是求我不*要杀他？
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(1625,38,0);   --  1(1):[石破天]说: 我知道老伯伯为人最好了，*我想求老伯伯把这个人带在*身边，教他学好。
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_1(1628,164,0);   --  1(1):[???]说: 我……好，就这么定了，小*子，跟我走，我好好教教你*！
    instruct_0();   --  0(0)::空语句(清屏)
	if GetS(86,20,20,5) == 1 then
		instruct_19(29,24);   --  19(13):主角移动至F-D
		instruct_30(29,24,29,19);   --  30(1E):主角走动29-24--29-19
		Talk("等等，可否把这冒牌的石破天交给我？",0);
		Talk("不行，我谢烟客居然答应了要求，一定要做到。",164);
		Talk( "那只好得罪了。",0);
		if instruct_6(170,3,0,0) ==false then    --  6(6):战斗[170]是则跳转到:Label0
			instruct_15(0);   --  15(F):战斗失败，死亡
			do return; end
		end    --:Label0
		SetS(86,20,20,5,2)
		Talk("不要打架了，这位大哥是个好人，他治好了我的病。老伯伯，我改了我的要求，让这个人跟这位大哥走吧。",38);
		Talk("我谢烟客已经答应的要求怎么能随意改变?",164);
		Talk( "你本来要杀了这个人，他叫你不杀，你不就已经实现他的要求了吗？",0);
		Talk("小兄弟这话有道理，看来这里没我的事了。",164);
		Talk("把石中玉留下来！他把我们雪山派弄得一片混乱!!",43);
		if instruct_6(59,3,0,0) ==false then    --  6(6):战斗[59]是则跳转到:Label0
			instruct_15(0);   --  15(F):战斗失败，死亡
			do return; end
		end    --:Label0
		Talk("你就是石中玉？算了，我们还是赶快离开这里。",0);
		instruct_14();   --  14(E):场景变黑
		instruct_3(-2,9,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [10]
		instruct_3(-2,10,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [10]
		instruct_3(-2,18,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [19]
		instruct_3(-2,11,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [11]
		SetS(39,26,39,3,20)
		instruct_19(27,39);   --  19(13):主角移动至F-D
		instruct_40(2); 
		instruct_3(-2,20,0,0,0,0,0,9234,9234,9234,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [20]
		instruct_13();   --  13(D):重新显示场景
		Talk("多谢少侠救命之恩，不。。你到底有什么企图？",591);
		Talk("聪明，你的那赏善罚恶令可以给我吗？",0);
		Talk("＜侠客岛人人要闪都来不及，这个人却要去，难到侠客岛上有宝藏？＞可以，但我也有个条件，让我跟着你。",591);
		Talk("好吧。＜让你跟着也好过让你到处为非作歹。＞",0);
		if instruct_20(20,0) ==false then    --  20(14):队伍是否满？是则跳转到:Label2
			instruct_10(591);   --  10(A):加入人物[石中玉]
			instruct_3(104,94,1,0,3001,0,0,9232,9232,9232,-2,-2,-2);--Alungky 将石中玉加到钓鱼岛
			instruct_14();   --  14(E):场景变黑
			instruct_3(-2,20,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [1]
			instruct_0();   --  0(0)::空语句(清屏)
			instruct_13();   --  13(D):重新显示场景
		else
			instruct_1(12,591,0);   --  1(1):][石中玉说: 你的队伍已满，我就直接去小村吧。
			instruct_14();   --  14(E):场景变黑
			instruct_3(-2,20,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [20]
			instruct_3(70,47,1,0,8301,0,0,9234,9234,9234,-2,-2,-2);   --  3(3):修改事件定义:场景[小村]:场景事件编号 [47]
			instruct_0();   --  0(0)::空语句(清屏)
			instruct_13();   --  13(D):重新显示场景
		end    --:Label2
		instruct_2(198,1);	--  2(2):得到物品[赏善罚恶令][1]
		instruct_3(-2,0,0,0,0,0,8302,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [0]
		instruct_3(-2,1,0,0,0,0,8302,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [1]
		instruct_3(-2,2,0,0,0,0,8302,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [2]
		instruct_3(74,0,-2,0,-2,427,0,-2,-2,-2,-2,-2,-2);   --  3(3):修改事件定义:场景[侠客岛]:场景事件编号 [0]
	else
		instruct_0();   --  0(0)::空语句(清屏)
		instruct_14();   --  14(E):场景变黑
		instruct_3(-2,10,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [10]
		instruct_3(-2,19,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [19]
		instruct_3(-2,11,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [11]
		instruct_0();   --  0(0)::空语句(清屏)
		instruct_13();   --  13(D):重新显示场景
		instruct_1(1630,38,0);   --  1(1):[石破天]说: 白师父，我不是要有意抢你*的掌门的，你别生气。侠客*岛的两位使者大哥约我去喝*粥，还说有什么书可以看，*我要走了。
		instruct_0();   --  0(0)::空语句(清屏)
		instruct_1(1631,0,1);   --  1(1):[AAA]说: ＜侠客岛有书？我应该去侠*客岛看看，不知道哪里还能*弄到赏善罚恶令呢？＞
		instruct_0();   --  0(0)::空语句(清屏)
		instruct_14();   --  14(E):场景变黑
		instruct_3(-2,18,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:当前场景:场景事件编号 [18]
		instruct_3(94,9,0,0,0,0,0,0,0,0,0,0,0);   --  3(3):修改事件定义:场景[长乐帮]:场景事件编号 [9]
		instruct_3(94,2,1,0,425,0,0,7070,7070,7070,-2,-2,-2);   --  3(3):修改事件定义:场景[长乐帮]:场景事件编号 [2]
		instruct_25(29,24,29,24);   --  25(19):场景移动29-24--29-24
		instruct_0();   --  0(0)::空语句(清屏)
		instruct_13();   --  13(D):重新显示场景
	end
--end