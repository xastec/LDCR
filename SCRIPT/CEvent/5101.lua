--��̶ħŮ��ʼ�Ի�
--OEVENTLUA[5101] = function()
        local picid = 343;
        local name = "��̶ħŮ";
	instruct_0();
        say("���ﻹ�����У���ϲ������Ǻǡ�",picid,0,name);

    local title = "��̶ħŮ�ķ���";
	local str = "�˼��̻� ������һ����ͨ������Ů��"
						.."*���� ������ҳ�����"
						.."*ESC������СħŮ˵�ټ�"
	local btn = {"�˼��̻�","����"};
	local num = #btn;
	local r = JYMsgBox(title,str,btn,num,nil,1);
	local myName = JY.Person[0]["����"];

    if r == 1 then
    	local subName = Alungky_getSubName(name);
		say("����΢˵��һ��ม���Щ��Ů�أ�������ǰһ�η�����������磬Ҳ����������������",picid,0,name);
		say("�������ٻ���������Ҫ����Ѫħ��������Ҫ���ڸ����Ǿ����Ϳ��ܡ�",picid,0,name);
		say("����" .. subName .. "�������Ǵ��͹���ֱ��ǿ�鲻�ͺ��ˣ�", 0, 1, myName)
		say("������ѡ����ͨ�˽����ͻᱻѪħ���ֽ����",picid,0,name);
		say("��ô�ֲ�����������İɡ�", 0, 1, myName)
		say("������佫�ᱻʩ�����м����ǲ������뿪������䣬��ʹ�Ѿ��������Ϳ��ܡ�",picid,0,name);
		say("Ŷ���ˣ����У�Ĭ������������ǿ��Ա����еģ��������Ҫ���ǵ������ǻ�ȥǰ����˵һ��Ŷ��",picid,0,name);
		say("ѡ��һ���ú����ܰɡ�",picid,0,name);
		--Alungky_human_act(1,"��٧�");
		ALungky_fk_rouhulist(name,picid);
	elseif r == 2 then
		Alungky_MM_XMJJ_Def(picid, name);
	end

--end