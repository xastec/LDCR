--重写打铁匠的事件，改成卖东西
--OEVENTLUA[847] = function()

	local x1 = CC.ScreenW/2 - 180 ;
	local y1 = 50;
	DrawStrBox(x1, y1+40, "装备名称   需银两",C_WHITE, CC.DefaultFont);
	local tids = {53,42,62,46,39,45,50,55,56,57};
	--local name = {"判官笔","白虹剑","佛心甲","绿波香露刀","白龙剑","冷月宝刀","伏魔杵","神山剑","玄铁菜刀","犽月"}
	local prices = {300,300,400,400,500,500,600,2000,2000,2000};
	
	local menu = {};
	for i=1, #tids do
		menu[i] = {string.format("%-12s %4d",JY.Thing[tids[i]]["名称"],prices[i]), nil, 1};
	end
	
	local n = 3;
	
	menu[8][3] = 0;		--玄铁菜刀 默认不显示
	menu[9][3] = 0;		--神山剑 默认不显示
	menu[10][3] = 0;	--犽月 默认不显示
	if JY.Person[0]["武功1"] == 110 then			--洗神山剑法
		menu[8][3] = 1
		n = n - 1
	elseif JY.Person[0]["武功1"] == 111 then		--洗西瓜刀法
		menu[9][3] = 1
		n = n - 1
	elseif JY.Person[0]["武功1"] == 112 then		--洗犽月流空
		menu[10][3] = 1
		n = n - 1
	end
	
	
	for i=1, #tids do			--已经有了的不显示
		for j=1, CC.MyThingNum do
			if JY.Base["物品" .. j] == tids[i] then
				menu[i][3] = 0;
				n = n+1;
			end
		end
	end
	
	if n == #tids then
		DrawStrBoxWaitKey("对不起，东西已经卖完啦!", C_WHITE, 30)
	end
		
	local numItem = #menu;
	local r = ShowMenu(menu,numItem,0,x1,y1+80,0,0,1,1,CC.DefaultFont,C_ORANGE,C_WHITE);
	
	if r > 0 then
		if JY.GOLD >= prices[r] then
			instruct_2(tids[r],1)
			instruct_2(174, -prices[r]);
		else
    	DrawStrBoxWaitKey("对不起，你的银两不足!", C_WHITE, 30)
    end
	end
--end