--选择宗师
if GetS(53, 0, 2, 5) == 3 then 
	if GetBookNum() >= 10  then
		say("耶，这阵法果然很给力");
		say("好了，这也是非一般人能领悟的。看你现在也基本熟练了，现在教你更高深的领域，听好了~~", 0, 5, "龙的传人");
		say("Ｇ２你是风儿，我是沙儿。。不好意思，放错碟了", 0, 5, "龙的传人");
		say("汗。。。。。。");
		say("能识别只是很皮毛的部分，关键还是在于预先的判断和准确的判断。算了，多说你也不明白，给你直接演示得了", 0, 5, "龙的传人");
		instruct_14();
		instruct_13();
		QZXS("数日后....");
		say("果然是很有门道，多谢了。再见");
		say("我擦，就这么走了", 0, 5, "龙的传人");
		
		JY.Person[JY.MY]["攻击力"] = JY.Person[JY.MY]["攻击力"] + 40
	  JY.Person[JY.MY]["防御力"] = JY.Person[JY.MY]["防御力"] + 40
	  JY.Person[JY.MY]["轻功"] = JY.Person[JY.MY]["轻功"] + 40
	  
	  DrawStrBoxWaitKey(string.format("%s攻防轻能力各提升40点",JY.Person[JY.MY]["姓名"]), C_ORANGE, CC.DefaultFont)
	  ShowScreen()
		
		--不需要打三张丰
	  SetS(53, 0, 4, 5,1)
	  SetS(53, 0, 5, 5,1)
	  SetS(80, 48, 36, 3, 100)
    instruct_3(80, 100, 0, 0, 0, 0, 2002, 0, 0, 0, 0, -2, -2)
    
    instruct_3(-2, -2, -2, 0, 8025, 0, 0, -2, -2, -2, -2, -2, -2)
		
	else
		say("历练去吧少年，回头你一定会来找我的。另外在系统菜单->系统攻略，里面有一些历练说明，找个时间看看吧", 0, 5, "龙的传人")
	end
end