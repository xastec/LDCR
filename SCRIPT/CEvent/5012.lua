--���򰲳�ʼ�Ի�
--OEVENTLUA[5011] = function()
    local picid = 335;
    local name = "����";
	instruct_0();
    say("�����������ѵ����Ҫ����һ����Ѫħ��������������ʵս��û�������������㶮�ġ�",picid,0,name);

    local title = "����ķ���";
	local str = "���� �����մ̼��������������㣡"
						.."*���� ������ҳ���"
						.."*ESC����������˵�ټ�"
	local btn = {"����","����"};
	local num = #btn;
	local r = JYMsgBox(title,str,btn,num,nil,1);

    if r == 1 then
		say("������۾����ҽ�Ϊ���ſ������硣",picid,0,name);
		Alungky_tranfort_HJ();
		say("��ӭ�����ٺϻþ�����ѡ��ս���ɣ�",picid,0,name);
		local batID = 0;
		local title = "�þ�ս��";
		local str = "��ͨ ���������ɵ���Χ��"
						.."*���� ���������䵳��"
						.."*���� �����ַ�����"
		local btn = {"��ͨ","����","����"};
		local num = #btn;
		local trr = JYMsgBox(title,str,btn,num,nil,1);
        
        batID = trr;
		local isWon = Alungky_LianGong(batID);
        if isWon == true then
        	say("�ţ��������п�����ѽ��",picid,0,name);
        else
        	say("��ʧ���˰������ٽ�������",picid,0,name);
        end
		Alungky_tranfort_XMJJ_LiLian();
	elseif r == 2 then
		Alungky_MM_XMJJ_Def(picid, name);
	end
        
--end