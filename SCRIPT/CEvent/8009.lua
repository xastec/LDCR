--ҩ¯��ҩ
--OEVENTLUA[8009] = function()
	local foodNum = 0;		--ʳ������
	for i = 1, CC.MyThingNum do
		if JY.Base["��Ʒ" .. i] == 210 then
			foodNum = JY.Base["��Ʒ����" .. i];
			break;
		elseif JY.Base["��Ʒ" .. i] < 0 then
			break;
		end
	end
	
	local food = {18,19,20,21};		--�������Ĳ�
	local drink = {22,23,24,25};		--�������ľ�
	local need = {5,10,15,20};			--��Ҫ��ʳ����������һ����
	
	local foodName = {};		--������
	for i=1, #food do
		foodName[i] = JY.Thing[food[i]]["����"];
	end
	
	local drinkName = {};		--������
	for i=1, #drink do
		drinkName[i] = JY.Thing[drink[i]]["����"];
	end
	
	
	local title = "����";
	local str = string.format("��ǰʳ��������Ϊ��%d*��������ˡ���ʼѡ�����Ĳ�*��������ơ���ʼѡ�����ľ�*���ʳ���������㣬���޷�����", foodNum);
	local btn = {"����","����","�ر�"};
	local num = #btn;
	local r = JYMsgBox(title,str,btn,num);

	Cls();
	if r == 1  then		--����
		local x1 = CC.ScreenW/2 - 180 ;
		local y1 = 50;
		DrawStrBox(x1, y1+40, "������   ��ʳ��  ʳ��������"..foodNum,C_WHITE, CC.DefaultFont);
		local menu = {}
		for i=1, #food do 
			menu[i] = {string.format("%-12s %4d",foodName[i],need[i]),nil,1};
		end
		
		local numItem = #menu;
		local size = CC.DefaultFont;
		local r = ShowMenu(menu,numItem,0,x1,y1+80,0,0,1,1,size,C_ORANGE,C_WHITE);
		
		if r > 0 then
			Cls();
			
			local n = InputNum("��������Ҫ�����ĸ���", 0, math.modf(foodNum/need[r]), 1);
			if n ~= nil and n > 0 then
			
			  if n * need[r] <= foodNum then
						instruct_2(food[r],n);
						instruct_2(210,-n * need[r]);
					else
						DrawStrBoxWaitKey("�Բ������������ʳ�ĳ�����ʳ������!", C_WHITE, CC.DefaultFont)
			  end
			end
		end
	elseif r == 2  then		--����
		local x1 = CC.ScreenW/2 - 180 ;
		local y1 = 50;
		DrawStrBox(x1, y1+40, "������   ��ʳ��  ʳ��������"..foodNum,C_WHITE, CC.DefaultFont);
		local menu = {}
		for i=1, #drink do 
			menu[i] = {drinkName[i].."    "..need[i].."           ",nil,1};
		end
		
		local numItem = #menu;
		local size = CC.DefaultFont;
		local r = ShowMenu(menu,numItem,0,x1,y1+80,0,0,1,1,size,C_ORANGE,C_WHITE);
		
		if r > 0 then
			Cls();
			local n = InputNum("��������Ҫ�����ĸ���", 0, math.modf(foodNum/need[r]), 1);
			if n ~= nil and n > 0 then
			  if n * need[r] <= foodNum then
						instruct_2(drink[r],n);
						instruct_2(210,-n * need[r]);
					else
						DrawStrBoxWaitKey("�Բ������������ʳ�ĳ�����ʳ������!", C_WHITE, CC.DefaultFont)
			  end
			end
			  
		end
	end

--end