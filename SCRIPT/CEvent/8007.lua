--ħ����ʼ�Ի�
--OEVENTLUA[8007] = function()
    local picid = 330;
    local isAlungky = 1;
	instruct_0();
	if isAlungky == 1 then
        say("��á�����˹����ʲô���԰�����ģ�",picid,0,"ħ��");
    end
	local title = "ħ���ķ���";
	local str = "��ս�����մ̼�����ս�������㣡"
						.."*������������������������˫���ǵ�����Ŷ��"
						.."*���񣺽��ܲ���ȫ���񣬻�����Ӧ������"
                                                .."*�ؼң����ͻ�Ѫħ��磬ֻ�������Լ���"
						.."*ESC������ħ��˵�ټ�"
	local btn = {"��ս","����","����","�ؼ�"};
	local num = #btn;
	local r = JYMsgBox(title,str,btn,num,nil,1);

        if r == 1 then
		Fight();
	elseif r == 2 then
		LianGong();
	elseif r == 3 then
		DYRW();
	elseif r == 4 then
		if isAlungky == 1 then
			say("���ţ��пվͻؼҿ����ɡ�",picid,0,"ħ��");
			Alungky_tranfort_XMJJ();
		else
			say("�㲻������˹���ˣ����޷����㴫��ȥ�ǣ������������Ա�ĵط���",picid,0,"ħ��");	
			My_ChuangSong_List();
		end
	end
--end