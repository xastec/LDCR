--ħ����ʼ�Ի�
--OEVENTLUA[5000] = function()
        local picid = 330;
	instruct_0();
        say("�ҿ��������������磬���ᣬ�ϻ۵���Ů����Ӵ��",picid,0,"ħ��");
	
	local title = "ħ���ķ���";
	local str = "��ս�����մ̼�����ս�������㣡"
						.."*������������������������˫���ǵ�����Ŷ��"
						.."*���񣺽��ܲ���ȫ���񣬻�����Ӧ������"
                                                .."*С�壺���ͻ�С�壬�����������档"
						.."*ESC������ħ��˵�ټ�"
	local btn = {"��ս","����","����","С��"};
	local num = #btn;
	local r = JYMsgBox(title,str,btn,num,nil,1);

        if r == 1 then
		say("������ս˭ѽ�������Ľ����ҹ�����һ�����򲻹���������",picid,0,"ħ��");
	elseif r == 2 then
		say("�����Ļ�������ȥ������㣬���Ǿ�����ࡣ",picid,0,"ħ��");
	elseif r == 3 then
		say("����û�а취�����񣬻�С�������԰ɡ�",picid,0,"ħ��");
	elseif r == 4 then
		say("����Ŷ������ȥս���ɣ�",picid,0,"ħ��");
		Alungky_tranfort_XC();
	end


--end