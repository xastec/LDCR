--OEVENTLUA[8614] = function()  --邪线情殇剧情
	if instruct_16(92)==false then
	   TalkEx("想要闯这一关，请将你最心爱的女人带过来。如果",269,0);  
	   instruct_0(); 
	else  
	   TalkEx("这是最后一关了，为了不让自己后悔，请慎重！",269,0);  
	   instruct_0();
	   local title = "第三关：情殇";
	   local str = "过此门必须拿最心爱的女人的性命作为血祭，或放弃所有情欲，从此绝子绝孙。";
	   local btn = {"小鸡鸡",JY.Person[92]["姓名"]};
	   local num = #btn;
	   local pic = 269;
	   local r = JYMsgBox(title,str,btn,#btn,pic);

		if r==1 then
			local pid = 9999;				--定义一个临时的心魔人物数据
			JY.Person[pid] = {};
			for i=1, #PSX-8 do
				JY.Person[pid][PSX[i]] = JY.Person[0][PSX[i]];
			end
			
			JY.Person[pid]["生命最大值"] = math.modf(JY.Person[pid]["生命最大值"]/4);
			JY.Person[pid]["生命"] = JY.Person[pid]["生命最大值"];
			JY.Person[pid]["内力最大值"] = math.modf(JY.Person[pid]["内力最大值"]/2);
			JY.Person[pid]["内力"] = JY.Person[pid]["内力最大值"];
			JY.Person[pid]["医疗能力"] = 0
			JY.Person[pid]["攻击力"] = math.modf(JY.Person[pid]["攻击力"]/10);
			JY.Person[pid]["防御力"] = math.modf(JY.Person[pid]["防御力"]/10);
			JY.Person[pid]["轻功"] = math.modf(JY.Person[pid]["轻功"]/10);
			JY.Person[pid]["姓名"] = JY.Person[0]["姓名"];
		   instruct_37(1);       --道德+1
		   instruct_0();
		   TalkEx("一个女人都保护不了的话，那我做男人就没有意义了！对不起了，祖宗们！",0,1);  
		   instruct_0();
			  SetS(87,31,35,5,1)           --心魔战判定
			  if WarMain(20,1)==true then   --主角挑战心魔
				 instruct_0();
			  else
				 instruct_15(0);   
				 instruct_0();
				 return;
			  end
			  SetS(87,31,35,5,0)           --心魔战还原
			  			lib.FillColor(0, 0, CC.ScreenW, CC.ScreenH, C_RED, 128)
			ShowScreen()
			lib.Delay(80)
			lib.ShowSlow(15, 1)
			Cls()
			lib.ShowSlow(100, 0)
			JY.Person[0]["性别"] = 2
			SetS(86,15,15,5,1)
			local add, str = AddPersonAttrib(0, "攻击力", -10)
			DrawStrBoxWaitKey(JY.Person[0]["姓名"] .. str, C_ORANGE, CC.DefaultFont)
			add, str = AddPersonAttrib(0, "防御力", -20)
			DrawStrBoxWaitKey(JY.Person[0]["姓名"] .. str, C_ORANGE, CC.DefaultFont)
			Talk( "大哥。。你。。",92); 
			Talk("不。。 现在的我不是大哥，也不是大姐。。",0); 
			Talk("。。。" ,92);
		else
		   Talk("没有了命根子，那我还要女人干吗？但为君故，虽死无憾！",0); 	--主角战女主
		   SetS(87,31,35,5,2)
			if instruct_6(20,4,0,0) ==false then    --  6(6):战斗[74]是则跳转到:Label2
				instruct_15(0);   --  15(F):战斗失败，死亡
				instruct_0();   --  0(0)::空语句(清屏)
				do return; end
			end  
			SetS(87,31,35,5,0) --女主战还原
		   	lib.FillColor(0, 0, CC.ScreenW, CC.ScreenH, C_RED, 128)
			ShowScreen()
			lib.Delay(80)
			lib.ShowSlow(15, 1)
			Cls()
			lib.ShowSlow(100, 0)
		   Talk("啊！！！！！！！！",92);
         instruct_14(); 
         instruct_0(); 
         instruct_13();
		   instruct_37(-10);       
		   instruct_0();  
		   instruct_21(92);   
		   instruct_0();   
		end

		TalkEx("啊！！！！！！！！",0,1);  
		instruct_0(); 
		instruct_57();
		instruct_3(-2,2,1,1,0,0,0,7746,7746,7746,-2,-2,-2);   
		instruct_3(-2,3,0,0,0,0,0,7804,7804,7804,-2,-2,-2);   
		instruct_3(-2,4,1,0,0,0,0,7862,7862,7862,-2,-2,-2); 
	end
--end
