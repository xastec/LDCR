--�����ʼ�Ի�
--OEVENTLUA[5205] = function()
        local picid = 350;
        local name = "���������";
        local picid2 = 351;
        local name2 = "��β��";
        local myname = JY.Person[0]["����"];
	instruct_0();
        say("С�����þò�������",picid,0,name);
	local title = "����Ȫ�ڿ�С��";
	local str = "���� ����اӴ"
						.."*���� ��������Ը�"
						.."*ESC����ר��������"
	local btn = {"����","����"};
	local num = #btn;
	local r = JYMsgBox(title,str,btn,num,nil,1);
    if r == 1 then
		say("Ȫ��������ˬ������ˬ",0,1,myname );
		say("��С�����õģ���˵��ô������ô����Ŷ�������ȸ��㰴Ħ��",picid,0,name);
		AlungkySaywithPic("�ۺܲ��������Ŷ���ִ��������е���", 0, 1, myname, "/CW_LY/1");
		AlungkySaywithPic("������������С��", picid,0, name, "/CW_LY/2");
		AlungkySaywithPic("̫ˬ�ˣ��������ˣ����У���Ҫ��������ģ������£�Ȫ��", 0, 1, myname, "/CW_LY/2");
		AlungkySaywithPic("Ŷ���Ǻðɡ�",picid,0, name, "/CW_LY/1");
		say("�ҿ��Լ����",picid2,0,name2);
		say("���԰������������Ѿ���ֱ����������Ľ׶��ˡ�",0,1,myname );
		say("�ð������ѹ��·�������Ħ���Լ���СѨϣ��������ʪ��",picid2,0,name2);
		AlungkySaywithPic("�����Ѿ�׼������Ӵ��", picid,0, name, "/CW_LY/3");
		AlungkySaywithPic("�ٺ٣�ѡһ�����ɣ�", picid2,0, name2, "/CW_LY/3");
		AlungkySaywithPic("��������Ҫ������",0,1,myname, "/CW_LY/3-1");
		for i = 1,10 do
			Alungky_show_pic("/CW_LY/3");
			Alungky_show_pic("/CW_LY/3-1");
		end
		AlungkySaywithPic("����������������", picid,0, name, "/CW_LY/3-1");
		AlungkySaywithPic("ββ��𼱹���������!",0,1,myname, "/CW_LY/4");
		for i = 1,10 do
			Alungky_show_pic("/CW_LY/4-1");
			Alungky_show_pic("/CW_LY/4");
		end
		AlungkySaywithPic("̫ˬ��̫ˬ�ˣ�Ҫ����",0,1,myname, "/CW_LY/4-1");
		AlungkySaywithPic("�������ҵ����ڡ�", picid,0, name, "/CW_LY/4-1");
		AlungkySaywithPic("�ҵ�������������䡫", picid2,0, name2, "/CW_LY/4-1");
		instruct_14()
    	instruct_13()
    	Alungky_show_pic("/CW_LY/5");
    	AlungkySaywithPic("���������Ҳ�㲻�������˭�������˹�����",0,1,myname, "/CW_LY/5");
    	AlungkySaywithPic("С��������������С���İ�Һ��Զ�������ҵ����ڡ���", picid,0, name, "/CW_LY/5");
    	say("лл����",0,1,myname );
    	say("����������������",picid2,0,name2);
    	instruct_14()
    	instruct_13()
	elseif r == 2 then
		Alungky_MM_XMJJ_Def(picid, name);
	end
--end