--���ѳ�ʼ�Ի�
--OEVENTLUA[5008] = function()
        local picid = 329;
        local name = "��˪��";
	instruct_0();
        say("�๫����������ʱ��֮��������������ĳһ��λ�濴����Ծ�ֹ�ġ�",picid,0,name);

        local title = "���ѵĹ���";
		local str = "���� ��ģ��ս�����������˵���ѧ��"
						.."*���� ������ҳ���"
						.."*ESC����������˵�ټ�"
	local btn = {"����","����"};
	local num = #btn;
	local r = JYMsgBox(title,str,btn,num,nil,1);

    if r == 1 then
		say("�����Ｘ�������õ�ս�����뿴��",picid,0,name);
		say("׼������ô������ȥ�þ���ս�ɡ�",picid,0,name);
		My_Enter_SubScene(114,26,30,-1);

        say("����ѡ��һ����ս�ߡ�", picid, 0, name);
        local ID1 = Alungky_Name_List(0);
        say("�����ս�߽���˭��ս�أ�", picid, 0, name);
        local ID2 = Alungky_Name_List(1);
        say("���λ�ģ��ս������ʼ���������ȣ�".. JY.Person[ID1]["����"] .. "�Ծ�" .. JY.Person[ID2]["����"], picid, 0, name);
	    local win = WarMain(246)
	    if win == true then
	    	say("����ʤ�ߣ�������".. JY.Person[ID1]["����"] , picid, 0, name);
	    else
	    	say("����ʤ�ߣ�������".. JY.Person[ID2]["����"] , picid, 0, name);
        end
	    My_Enter_SubScene(107,6,56,-1);
	elseif r == 2 then
		Alungky_MM_XMJJ_Def(picid, name);
	end
--end