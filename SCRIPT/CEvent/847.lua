--��д���������¼����ĳ�������
--OEVENTLUA[847] = function()

	local x1 = CC.ScreenW/2 - 180 ;
	local y1 = 50;
	DrawStrBox(x1, y1+40, "װ������   ������",C_WHITE, CC.DefaultFont);
	local tids = {53,42,62,46,39,45,50,55,56,57};
	--local name = {"�йٱ�","�׺罣","���ļ�","�̲���¶��","������","���±���","��ħ��","��ɽ��","�����˵�","����"}
	local prices = {300,300,400,400,500,500,600,2000,2000,2000};
	
	local menu = {};
	for i=1, #tids do
		menu[i] = {string.format("%-12s %4d",JY.Thing[tids[i]]["����"],prices[i]), nil, 1};
	end
	
	local n = 3;
	
	menu[8][3] = 0;		--�����˵� Ĭ�ϲ���ʾ
	menu[9][3] = 0;		--��ɽ�� Ĭ�ϲ���ʾ
	menu[10][3] = 0;	--���� Ĭ�ϲ���ʾ
	if JY.Person[0]["�书1"] == 110 then			--ϴ��ɽ����
		menu[8][3] = 1
		n = n - 1
	elseif JY.Person[0]["�书1"] == 111 then		--ϴ���ϵ���
		menu[9][3] = 1
		n = n - 1
	elseif JY.Person[0]["�书1"] == 112 then		--ϴ��������
		menu[10][3] = 1
		n = n - 1
	end
	
	
	for i=1, #tids do			--�Ѿ����˵Ĳ���ʾ
		for j=1, CC.MyThingNum do
			if JY.Base["��Ʒ" .. j] == tids[i] then
				menu[i][3] = 0;
				n = n+1;
			end
		end
	end
	
	if n == #tids then
		DrawStrBoxWaitKey("�Բ��𣬶����Ѿ�������!", C_WHITE, 30)
	end
		
	local numItem = #menu;
	local r = ShowMenu(menu,numItem,0,x1,y1+80,0,0,1,1,CC.DefaultFont,C_ORANGE,C_WHITE);
	
	if r > 0 then
		if JY.GOLD >= prices[r] then
			instruct_2(tids[r],1)
			instruct_2(174, -prices[r]);
		else
    	DrawStrBoxWaitKey("�Բ��������������!", C_WHITE, 30)
    end
	end
--end