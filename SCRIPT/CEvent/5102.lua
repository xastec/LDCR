--�����ʼ�Ի�
--OEVENTLUA[5205] = function()
        local picid = 333;
        local name = "Ľ������";
        local myname = JY.Person[0]["����"];
	instruct_0();
	say("�˼������ƫƧ����ƫƧ�ġ��������������԰��Ĵ���Ҳ��",picid,0,name);
	local title = "Ľ��������С��";
	local str = "������Ϸ ������������ͻ��Ŷ"
						.."*��ʵ���飺ȥ�Ǹ���������һ��"
						.."*���� ������ҳ�����"
						.."*ESC����������˵�ټ�"
	local btn = {"������Ϸ","��ʵ����","����"};
	local num = #btn;
	local r = JYMsgBox(title,str,btn,num,nil,1);
    if r == 1 then
		say("����ô�ܾ��������еģ������ټ��һ��",0,1,myname );
		say("�㻹����˼˵���Ҳ��Ǿ�����һ����Ϸ����Ͱ��˼����������",picid,0,name);
		say("ֻ�Ǿ��ùֵֹģ�ûʲô",0,1,myname );
		say("��˵��������Ϸ�����ߣ������ֲ����ң��ο���Ȼ�������ҵ����֣���Ҳ��Ů��ѽ��",picid,0,name);
		say("����Ц�أ���ô������Ϸ��Ҳ���������ĸ�Ů������������",0,1,myname );
		say("˵�˼�˵��Ů���ߣ�����Ҳ��ôС��",picid,0,name);
		say("С�ź�ѽ��С�Ž�խ��ʪ��ô��",0,1,myname );
		say("�滵�滵���˼҆[�������ϣ���Ȼ�������ô��������",picid,0,name);
		say("���Ѿ���������ˣ��п��������ټ��һ�°������ߺ�������",picid,0,name);
	elseif r == 2 then
		local subname = Alungky_getSubName(name);
		say("��Ư����"..name.."������˵�����Ǹ�����Ϸ�ܳɹ���",0,1,myname );
		say("�����ĸ�����ȷһ��լ�и�Ů���Ȱ�",picid,0,name);
		say("��˵��Ҳ���Թ����о���ȷ����������Ҳ�ܳ�ʵ���������Ӷ����ݣ�����û���龵ͷ",0,1,myname );
		say("�㻹Ҫ���龵ͷ��������������ô����ã�Ů���㻹ˬ����ѽ",picid,0,name);
		say("��˵������Զ���ݲ����Σ�����Ѫħ��磬�������ҵĲر��⡣���Ѿ����ҵ��ˣ������Ǳ����Ƿ�����",0,1,myname );
		say("�����е�����ˣ�",picid,0,name);
		say("Ҳ�����������������ȥ�������ʵġ���Ҳ�Ҳ������ô�����ν��֮�⡣",0,1,myname );
		say("����Ϊ��Ҷ�������ô�пհ�������ܶ�ġ�Ҫ����Ѫħ�������ԣ��ҹ���Ҳ��������ô����ð���������",picid,0,name);
		say("����ֻ��ϧ���Ǹ���ϷҲ������һЩ�����ϵĻ�������ְ��ˣ�����������簡",0,1,myname );
		say("��˵������ܴ�����ôһ�����磬�ǻ����ͦ����˼",0,1,myname );
		say("������������������������˼��",picid,0,name);
		say("���Ǹ��Ų����������磬���Ǹ��������󹬣��������䣨ֻ����Ϸ�ﲻ��ʾ���ˣ�����������",0,1,myname );
		say("�㻹��˵�����Ǹ��籾�����ɲ�����ô�����أ������ѣ��п�ɬ���",picid,0,name);
		say("���˰��ˣ�����ô��Ҳֻ����Ϸ���ѣ������˿����������",0,1,myname );
		say("�����˵����һ����������أ�",picid,0,name);
		say("��������",0,1,myname );
		say("�����˵�����Ǹ�����Ψһ�������أ�",picid,0,name);
		say("������",0,1,myname );
		say("���а취�������磿��Ϳռ�֮����ϵ�ˣ����������س������ˣ�",0,1,myname );
		say("����ô�����ʣ�������簡������Ŀ�����ˣ�",picid,0,name);
		say("������",0,1,myname );
		say("���ǽ����������������񣬰����޽��������ʿ������ħ����ͬ�����������",picid,0,name);
		say("��˵��ǰ��ʱ����ô��Ҷ����е�����ǲ�������ȫΪ���Ұɣ�Ϊ����ȥ����",0,1,myname );
		say("�����������ˣ�������簡�ô������أ�ֻ��һʱ˵������������ҵ�С˵��Ϸ�Ѿ�ֲ�������ˣ�������Ҫ���˲���������硣",picid,0,name);
		say("�����Ҳ��Ҫ�Ը�����ˣ�������һ�а͸�ʲô�ģ��ұ������̿���������һ��С������Ҳ���ܰ���",0,1,myname );
		say("���᲻�ᣬ�����Ϸ��Ҳ�����ô���ˡ�Ӧ��ûʲô���⣬�����һ����һ��ȥ��������ʲô����ֱ�ӻ�����",picid,0,name);
		say("������ม���",0,1,myname );
		say("�����̫���ˣ�Ҫ��������Ȥ�����㻹�����������",picid,0,name);
		say("��˵����ǰ��������������",0,1,myname );
		say("��",picid,0,name);
		say("�ǲ���ʲô����Ҳû���ˣ���",0,1,myname );
		say("���Լ����Ű쿩��",picid,0,name);
		say("������˵�������һ��ȥ�԰�",0,1,myname );
		say("�������ң���������������һ��ȥ�����������Ұ�������Ҳ���������������",picid,0,name);
		say("�ǲ��У���һ���Ǳ�����������ô�졣",0,1,myname );
		say("�С���ֻ�Ƿ���Ү����������������������ǰ�һ����ֻ�����㣬��Ͼ����Ѿ�д�õľ籾��",picid,0,name);
		say("�ǲ�����������˵������ʲô���ݺ���һ��ȥ��",0,1,myname);
		say("Ѫħ�ػ�����ô����",picid,0,name);
		say("���������������������Ү��һ����Ů�������ڣ��Ҳ��������ҡ�",0,1,myname);
		say("�����ʲô�߼�����Ѫħ�ػ��񣬰��հ���ɯ���˵�˵�����������ҹ���������������Ϊ�㣬�ҵ���꽫����������档",picid,0,name);
		say("�ؼ�ʱ���һ���������������һ�£�������ʲô�ġ�",picid,0,name);
		say("�ۣ���������������"..subname.."��������ʲôʱ�������",0,1,myname);
		say("�κ�ʱ�����ħ����ע�������ڣ���׼�����ˣ�ֻҪ�򿪽������¼����Ϸ�����ܽ����Ǹ������ˡ�",picid,0,name);
		instruct_14()
        instruct_13()
        say("ι������Ҳ̫���˰ɣ���һ��ֻ���ȴ���Ϸ�����أ�",0,1,myname);
        say("������ر���Ϸ�����ֻ��Զ������ġ�",picid,0,name);
        say("Ŷ���ǻ�������ʱ���пվ�ȥ���Ժ���",0,1,myname);
        say("ף��Ŀ��ġ�",picid,0,name);
	elseif r == 3 then
		Alungky_MM_XMJJ_Def(picid, name);
	end




	
--end