--OEVENTLUA[8614] = function()  --а���������
	if instruct_16(92)==false then
	   TalkEx("��Ҫ����һ�أ��뽫�����İ���Ů�˴����������",269,0);  
	   instruct_0(); 
	else  
	   TalkEx("�������һ���ˣ�Ϊ�˲����Լ���ڣ������أ�",269,0);  
	   instruct_0();
	   local title = "�����أ�����";
	   local str = "�����ű��������İ���Ů�˵�������ΪѪ��������������������Ӵ˾��Ӿ��";
	   local btn = {"С����",JY.Person[92]["����"]};
	   local num = #btn;
	   local pic = 269;
	   local r = JYMsgBox(title,str,btn,#btn,pic);

		if r==1 then
			local pid = 9999;				--����һ����ʱ����ħ��������
			JY.Person[pid] = {};
			for i=1, #PSX-8 do
				JY.Person[pid][PSX[i]] = JY.Person[0][PSX[i]];
			end
			
			JY.Person[pid]["�������ֵ"] = math.modf(JY.Person[pid]["�������ֵ"]/4);
			JY.Person[pid]["����"] = JY.Person[pid]["�������ֵ"];
			JY.Person[pid]["�������ֵ"] = math.modf(JY.Person[pid]["�������ֵ"]/2);
			JY.Person[pid]["����"] = JY.Person[pid]["�������ֵ"];
			JY.Person[pid]["ҽ������"] = 0
			JY.Person[pid]["������"] = math.modf(JY.Person[pid]["������"]/10);
			JY.Person[pid]["������"] = math.modf(JY.Person[pid]["������"]/10);
			JY.Person[pid]["�Ṧ"] = math.modf(JY.Person[pid]["�Ṧ"]/10);
			JY.Person[pid]["����"] = JY.Person[0]["����"];
		   instruct_37(1);       --����+1
		   instruct_0();
		   TalkEx("һ��Ů�˶��������˵Ļ������������˾�û�������ˣ��Բ����ˣ������ǣ�",0,1);  
		   instruct_0();
			  SetS(87,31,35,5,1)           --��ħս�ж�
			  if WarMain(20,1)==true then   --������ս��ħ
				 instruct_0();
			  else
				 instruct_15(0);   
				 instruct_0();
				 return;
			  end
			  SetS(87,31,35,5,0)           --��ħս��ԭ
			  			lib.FillColor(0, 0, CC.ScreenW, CC.ScreenH, C_RED, 128)
			ShowScreen()
			lib.Delay(80)
			lib.ShowSlow(15, 1)
			Cls()
			lib.ShowSlow(100, 0)
			JY.Person[0]["�Ա�"] = 2
			SetS(86,15,15,5,1)
			local add, str = AddPersonAttrib(0, "������", -10)
			DrawStrBoxWaitKey(JY.Person[0]["����"] .. str, C_ORANGE, CC.DefaultFont)
			add, str = AddPersonAttrib(0, "������", -20)
			DrawStrBoxWaitKey(JY.Person[0]["����"] .. str, C_ORANGE, CC.DefaultFont)
			Talk( "��硣���㡣��",92); 
			Talk("������ ���ڵ��Ҳ��Ǵ�磬Ҳ���Ǵ�㡣��",0); 
			Talk("������" ,92);
		else
		   Talk("û���������ӣ����һ�ҪŮ�˸��𣿵�Ϊ���ʣ������޺���",0); 	--����սŮ��
		   SetS(87,31,35,5,2)
			if instruct_6(20,4,0,0) ==false then    --  6(6):ս��[74]������ת��:Label2
				instruct_15(0);   --  15(F):ս��ʧ�ܣ�����
				instruct_0();   --  0(0)::�����(����)
				do return; end
			end  
			SetS(87,31,35,5,0) --Ů��ս��ԭ
		   	lib.FillColor(0, 0, CC.ScreenW, CC.ScreenH, C_RED, 128)
			ShowScreen()
			lib.Delay(80)
			lib.ShowSlow(15, 1)
			Cls()
			lib.ShowSlow(100, 0)
		   Talk("������������������",92);
         instruct_14(); 
         instruct_0(); 
         instruct_13();
		   instruct_37(-10);       
		   instruct_0();  
		   instruct_21(92);   
		   instruct_0();   
		end

		TalkEx("������������������",0,1);  
		instruct_0(); 
		instruct_57();
		instruct_3(-2,2,1,1,0,0,0,7746,7746,7746,-2,-2,-2);   
		instruct_3(-2,3,0,0,0,0,0,7804,7804,7804,-2,-2,-2);   
		instruct_3(-2,4,1,0,0,0,0,7862,7862,7862,-2,-2,-2); 
	end
--end
