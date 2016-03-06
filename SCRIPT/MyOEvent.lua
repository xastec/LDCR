--Alungky 黑白合训练处
function Alungky_LianGong(idx)
  local battleID = 245;
  if idx == 1 then
  	battleID = 210
  elseif idx == 2 then
  	battleID = 13
  end 
  return instruct_6(battleID, 8, 0, 1)
end

--传送地址列表
function My_ChuangSong_List()
	local menu = {};
	local aviSceneNum = 107;
	for i=0, aviSceneNum-1 do
		menu[i+1] = {i..JY.Scene[i]["名称"], nil, 1};
		if JY.Scene[i]["进入条件"] ~= 0 or  i == 84 or i == 83  or i == 82 or  i == 13 then
			menu[i+1][3] = 0;
		end
	end
	
	local r = ShowMenu2(menu,aviSceneNum,4,12,-1,(CC.ScreenH-12*(CC.DefaultFont+CC.RowPixel))/2+20,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE, "请选择传送地址");
	
	if r == 0 then
		return 0;
	end
	
	if r > 0 then	
		
		local sid = r-1;
		
		if JY.Scene[sid]["进入条件"] == 0 and sid ~= 84 and sid ~= 83  and sid ~= 82 and  sid ~= 13 then
				My_Enter_SubScene(sid,-1,-1,-1);
			else
				say("您目前现在不能进入此场景", 232, 1, "百事通");
				return 1;
			end

	end
	
	return 1;

end

function ALungky_show_bigImg(hid, str)
    Cls()
	lib.LoadPNG(98, hid*2, CC.ScreenW/2, CC.ScreenH/2, 0)
	ShowScreen()
	lib.Delay(300)
	Cls()
     for i = 12, 24 do
        NewDrawString(-1, -1, str, C_GOLD, 30 + i)
        ShowScreen()
        if i == 24 then
          Cls()
          NewDrawString(-1, -1, str, C_GOLD, 30 + i)
          ShowScreen()
          lib.Delay(400)
        else
          lib.Delay(20)
        end
     end
end
--选择肉壶
function ALungky_fk_rouhulist(name, idx)
	local menu = {};
	local fkNum = 13;

	for i=0, fkNum-1 do
		menu[i+1] = {i..CCX.RH_Name[i+1][1], nil, 1};
	end
	
	local r = ShowMenu2(menu,fkNum,4,12,-1,(CC.ScreenH-12*(CC.DefaultFont+CC.RowPixel))/2+20,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE, "请选择您想要的肉壶");
	
	if r == 0 then
		return 0;
	end
	
	if r > 0 then
		say("原来想要"..CCX.RH_Name[r][1].."来服侍你呀……请稍等，我马上把她传送过来哦～",idx,0,name);
		Alungky_human_act(CCX.RH_Name[r][2],r,CCX.RH_Name[r][1],CCX.RH_FStr[r]);

	end
	
	return 1;

end

function Alungky_Name_List(side)
	local menu = {};
	local NameNum = JY.PersonNum;
	local tres = 500;
	local k = 0;
	for i=0, NameNum-1 do
		if JY.Person[i]["生命最大值"] > tres then
			menu[k+1] = {i..JY.Person[i]["姓名"], nil, 1};
			k = k+1;
		end
	end
	
	local r = ShowMenu2(menu,k,4,12,-1,(CC.ScreenH-12*(CC.DefaultFont+CC.RowPixel))/2+20,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE, "请选择人物");
	
	if r == 0 then
		return 0;
	end

	local rpos = 0;
	if r > 0 then	
		
		local sid = r-1;
		k = 0;
		for j=0, NameNum-1 do
			if JY.Person[j]["生命最大值"] > tres then
				k = k+1;
			end

			if k == r then
				rpos = j;
				break;
			end;
		end
		if side == 0 then
			SetS(112,CC.CSPosX2,CC.CSPosY2,5,rpos);
	    else
	    	SetS(112,CC.CSPosX3,CC.CSPosY3,5,rpos);
	    end
	end
	
	return rpos;

end
function Alungky_getSubName(name)
	local len = string.len(name);
	if len >= 6 then
	   return string.sub(name,len-3);
	end
    return name;
end
--传送到血魔结界
function Alungky_tranfort_XMJJ()
	local XMJJ_ID = 107;
	My_Enter_SubScene(XMJJ_ID,8,32,-1);
end

function Alungky_tranfort_XMJJ_LiLian()
	local XMJJ_ID = 107;
	My_Enter_SubScene(XMJJ_ID,29,11,-1);
end

--传送到小村
function Alungky_tranfort_XC()
	local XC_ID = 70;
	My_Enter_SubScene(XC_ID,27,27,-1);
end

--传送到幻境
function Alungky_tranfort_HJ()
	local XC_ID = 113;
	My_Enter_SubScene(XC_ID,27,30,-1);
end

function Alungky_show_pic(name)
	lib.LoadPicture(CONFIG.PicturePath .. name .. ".png",-1,-1);
	ShowScreen();
	lib.Delay(300)
end

function Alungky_show_pic2(dir,name,dey)
	lib.LoadPicture(CONFIG.PicturePath .."/" .. dir .. "/" ..name .. ".png",-1,-1);
	ShowScreen();
	lib.Delay(dey)
end

function AlungkySaywithPNG(s,texID,flag,name)          --个人新对话
	local picw=CC.PortraitPicWidth;       --最大头像图片宽高
	local pich=CC.PortraitPicHeight;
	local talkxnum=18;         --对话一行字数
	local talkynum=3;          --对话行数
	local dx=2 * CC.Scale;
	local dy=2 * CC.Scale;
	local nbx=96 * CC.Scale;   --姓名框宽度
	local nby=27 * CC.Scale;   --姓名框高度
	local boxpicw=picw+10 * CC.Scale;
	local boxpich=pich+10 * CC.Scale;
	local boxtalkw=talkxnum*CC.DefaultFont+10;
	local boxtalkh=boxpich-nby;

	name=name or "未命名"
    local talkBorder = (boxtalkh - talkynum * CC.DefaultFont) / (talkynum+1);

	--显示头像和对话的坐标
    local xy={ [0]={headx=dx,heady=dy,
	                talkx=dx+boxpicw+2,talky=dy+nby,
					namex=dx+boxpicw+2,namey=dy,
					showhead=1},--左上
                   {headx=CC.ScreenW-1-dx-boxpicw,heady=CC.ScreenH-dy-boxpich,
				    talkx=CC.ScreenW-1-dx-boxpicw-boxtalkw-2,talky= CC.ScreenH-dy-boxpich+nby,
					namex=CC.ScreenW-1-dx-boxpicw-nbx,namey=CC.ScreenH-dy-boxpich,
					showhead=1},--右下
                   {headx=dx,heady=dy,
				   talkx=dx+boxpicw-43 * CC.Scale,talky=dy+nby,
					namex=dx+boxpicw+2,namey=dy,
				   showhead=0},--上中
                   {headx=CC.ScreenW-1-dx-boxpicw,heady=CC.ScreenH-dy-boxpich,
				   talkx=CC.ScreenW-1-dx-boxpicw-boxtalkw-2,talky= CC.ScreenH-dy-boxpich+nby,
					namex=CC.ScreenW-1-dx-boxpicw-nbx,namey=CC.ScreenH-dy-boxpich,
					showhead=1},
                   {headx=CC.ScreenW-1-dx-boxpicw,heady=dy,
				    talkx=CC.ScreenW-1-dx-boxpicw-boxtalkw-2,talky=dy+nby,
					namex=CC.ScreenW-1-dx-boxpicw-nbx,namey=dy,
					showhead=1},--右上
                   {headx=dx,heady=CC.ScreenH-dy-boxpich,
				   talkx=dx+boxpicw+2,talky=CC.ScreenH-dy-boxpich+nby,
					namex=dx+boxpicw+2,namey=CC.ScreenH-dy-boxpich,
				   showhead=1}, --左下
			}

    if flag<0 or flag>5 then
        flag=0;
    end
	local headid = 0;

  if xy[flag].showhead == 0 then
    headid = -1
  end


    if CONFIG.KeyRepeat==0 then
	     lib.EnableKeyRepeat(0,CONFIG.KeyRepeatInterval);
	end
    lib.GetKey();

	local function readstr(str)
		local T1={"０","１","２","３","４","５","６","７","８","９"}
		local T2={{"Ｒ",C_RED},{"Ｇ",C_GOLD},{"Ｂ",C_BLACK},{"Ｗ",C_WHITE},{"Ｏ",C_ORANGE}}
		local T3={{"Ｈ",CC.FontNameSong},{"Ｓ",CC.FontNameHei},{"Ｆ",CC.FontName}}
		--美观起见，针对不同字体同一行显示，需要微调ｙ坐标，以及字号
		--以默认的字体为标准，启体需下移，细黑需上移
		for i=0,9 do
			if T1[i+1]==str then return 1,i*50 end
		end
		for i=1,5 do
			if T2[i][1]==str then return 2,T2[i][2] end
		end
		for i=1,3 do
			if T3[i][1]==str then return 3,T3[i][2] end
		end
		return 0
	end

	local function mydelay(t)
		if t<=0 then return end
		lib.ShowSurface(0)
		lib.Delay(t)
	end

	local page, cy, cx = 0, 0, 0
  local color, t, font = C_WHITE, 0, CC.FontName
  while string.len(s) >= 1 do
    if page == 0 then
      Cls()
      if headid >= 0 then
        DrawBox(xy[flag].headx, xy[flag].heady, xy[flag].headx + boxpicw, xy[flag].heady + boxpich, C_WHITE)
        DrawBox(xy[flag].namex, xy[flag].namey, xy[flag].namex + nbx, xy[flag].namey + nby, C_WHITE)
        MyDrawString(xy[flag].namex, xy[flag].namex + nbx, xy[flag].namey + 1, name, C_ORANGE, 21 * CC.Scale)
		local w, h = lib.GetPNGXY(1, headid*2)
        local x = (picw - w) / 2
        local y = (pich - h) / 2
		lib.LoadPicture(CONFIG.PicturePath .. "/".."human/".. texID .. ".png",xy[flag].headx + 5 + x,xy[flag].heady + 5 + y);
      end
      DrawBox(xy[flag].talkx, xy[flag].talky, xy[flag].talkx + boxtalkw, xy[flag].talky + boxtalkh, C_WHITE)
      page = 1
    end
		local str
		str=string.sub(s,1,1)
		if str=='*' then
			str='Ｈ'
			s=string.sub(s,2,-1)
		else
			if string.byte(s,1,1) > 127 then		--判断单双字符
				str=string.sub(s,1,2)
				s=string.sub(s,3,-1)
			else
				str=string.sub(s,1,1)
				s=string.sub(s,2,-1)
			end
		end
		--开始控制逻辑
		if str=="Ｈ" then
			cx=0
			cy=cy+1
			if cy==3 then
				cy=0
				page=0
			end
		elseif str=="Ｐ" then
			cx=0
			cy=0
			page=0
		elseif str=="ｐ" then
			ShowScreen();
			WaitKey();
			lib.Delay(100)
		elseif str=="Ｎ" then
			s=JY.Person[pid]["姓名"]..s
		elseif str=="ｎ" then
			s=JY.Person[0]["姓名"]..s
		else
			local kz1,kz2=readstr(str)
			if kz1==1 then
				t=kz2
			elseif kz1==2 then
				color=kz2
			elseif kz1==3 then
				font=kz2
			else
				lib.DrawStr(xy[flag].talkx+CC.DefaultFont*cx+5,
							xy[flag].talky+(CC.DefaultFont+talkBorder)*cy+talkBorder-8,
							str,color,CC.DefaultFont,font,0,0, 255)
				mydelay(t)
				cx=cx+string.len(str)/2
				if cx==talkxnum then
					cx=0
					cy=cy+1
					if cy==talkynum then
						cy=0
						page=0
					end
				end
			end
		end
		--如果换页，则显示，等待按键
		if page==0 or string.len(s)<1 then
			ShowScreen();
			WaitKey();
			lib.Delay(100)
		end

	end


    if CONFIG.KeyRepeat==0 then
	     lib.EnableKeyRepeat(CONFIG.KeyRepeatDelay,CONFIG.KeyRepeatInterval);
	end

	Cls();
end

function AlungkySaywithPic(s,pid,flag,name,fid)          --个人新对话
	local picw=CC.PortraitPicWidth;       --最大头像图片宽高
	local pich=CC.PortraitPicHeight;
	local talkxnum=18;         --对话一行字数
	local talkynum=3;          --对话行数
	local dx=2 * CC.Scale;
	local dy=2 * CC.Scale;
	local nbx=96 * CC.Scale;   --姓名框宽度
	local nby=27 * CC.Scale;   --姓名框高度
	local boxpicw=picw+10 * CC.Scale;
	local boxpich=pich+10 * CC.Scale;
	local boxtalkw=talkxnum*CC.DefaultFont+10;
	local boxtalkh=boxpich-nby;

	pid=pid or 0
	if flag==nil then
		if pid==0 then
			flag=1
		else
			flag=0
		end
	end
	local headid = pid
	if (headid == 0 or headid == nil) and (name == nil or name == JY.Person[0]["姓名"]) then
		headid = (280 + GetS(4, 5, 5, 5))
	end

	name=name or JY.Person[pid]["姓名"]
    local talkBorder = (boxtalkh - talkynum * CC.DefaultFont) / (talkynum+1);

	--显示头像和对话的坐标
    local xy={ [0]={headx=dx,heady=dy,
	                talkx=dx+boxpicw+2,talky=dy+nby,
					namex=dx+boxpicw+2,namey=dy,
					showhead=1},--左上
                   {headx=CC.ScreenW-1-dx-boxpicw,heady=CC.ScreenH-dy-boxpich,
				    talkx=CC.ScreenW-1-dx-boxpicw-boxtalkw-2,talky= CC.ScreenH-dy-boxpich+nby,
					namex=CC.ScreenW-1-dx-boxpicw-nbx,namey=CC.ScreenH-dy-boxpich,
					showhead=1},--右下
                   {headx=dx,heady=dy,
				   talkx=dx+boxpicw-43 * CC.Scale,talky=dy+nby,
					namex=dx+boxpicw+2,namey=dy,
				   showhead=0},--上中
                   {headx=CC.ScreenW-1-dx-boxpicw,heady=CC.ScreenH-dy-boxpich,
				   talkx=CC.ScreenW-1-dx-boxpicw-boxtalkw-2,talky= CC.ScreenH-dy-boxpich+nby,
					namex=CC.ScreenW-1-dx-boxpicw-nbx,namey=CC.ScreenH-dy-boxpich,
					showhead=1},
                   {headx=CC.ScreenW-1-dx-boxpicw,heady=dy,
				    talkx=CC.ScreenW-1-dx-boxpicw-boxtalkw-2,talky=dy+nby,
					namex=CC.ScreenW-1-dx-boxpicw-nbx,namey=dy,
					showhead=1},--右上
                   {headx=dx,heady=CC.ScreenH-dy-boxpich,
				   talkx=dx+boxpicw+2,talky=CC.ScreenH-dy-boxpich+nby,
					namex=dx+boxpicw+2,namey=CC.ScreenH-dy-boxpich,
				   showhead=1}, --左下
			}

    if flag<0 or flag>5 then
        flag=0;
    end
	
  if xy[flag].showhead == 0 then
    headid = -1
  end


    if CONFIG.KeyRepeat==0 then
	     lib.EnableKeyRepeat(0,CONFIG.KeyRepeatInterval);
	end
    lib.GetKey();

	local function readstr(str)
		local T1={"０","１","２","３","４","５","６","７","８","９"}
		local T2={{"Ｒ",C_RED},{"Ｇ",C_GOLD},{"Ｂ",C_BLACK},{"Ｗ",C_WHITE},{"Ｏ",C_ORANGE}}
		local T3={{"Ｈ",CC.FontNameSong},{"Ｓ",CC.FontNameHei},{"Ｆ",CC.FontName}}
		--美观起见，针对不同字体同一行显示，需要微调ｙ坐标，以及字号
		--以默认的字体为标准，启体需下移，细黑需上移
		for i=0,9 do
			if T1[i+1]==str then return 1,i*50 end
		end
		for i=1,5 do
			if T2[i][1]==str then return 2,T2[i][2] end
		end
		for i=1,3 do
			if T3[i][1]==str then return 3,T3[i][2] end
		end
		return 0
	end

	local function mydelay(t)
		if t<=0 then return end
		lib.ShowSurface(0)
		lib.Delay(t)
	end

	local page, cy, cx = 0, 0, 0
  local color, t, font = C_WHITE, 0, CC.FontName
  while string.len(s) >= 1 do
    if page == 0 then
      Cls()
      if headid >= 0 then
        DrawBox(xy[flag].headx, xy[flag].heady, xy[flag].headx + boxpicw, xy[flag].heady + boxpich, C_WHITE)
        DrawBox(xy[flag].namex, xy[flag].namey, xy[flag].namex + nbx, xy[flag].namey + nby, C_WHITE)
        MyDrawString(xy[flag].namex, xy[flag].namex + nbx, xy[flag].namey + 1, name, C_ORANGE, 21 * CC.Scale)
        --local w, h = lib.PicGetXY(1, headid * 2)
		local w, h = lib.GetPNGXY(1, headid*2)
        local x = (picw - w) / 2
        local y = (pich - h) / 2
        --lib.PicLoadCache(1, headid * 2, xy[flag].headx + 5 + x, xy[flag].heady + 5 + y, 1)
		
		lib.LoadPNG(1, headid*2, xy[flag].headx + 5 + x, xy[flag].heady + 5 + y, 1)
		lib.LoadPicture(CONFIG.PicturePath .. fid .. ".png",-1,-1);
      end
      DrawBox(xy[flag].talkx, xy[flag].talky, xy[flag].talkx + boxtalkw, xy[flag].talky + boxtalkh, C_WHITE)
      page = 1
    end
		local str
		str=string.sub(s,1,1)
		if str=='*' then
			str='Ｈ'
			s=string.sub(s,2,-1)
		else
			if string.byte(s,1,1) > 127 then		--判断单双字符
				str=string.sub(s,1,2)
				s=string.sub(s,3,-1)
			else
				str=string.sub(s,1,1)
				s=string.sub(s,2,-1)
			end
		end
		--开始控制逻辑
		if str=="Ｈ" then
			cx=0
			cy=cy+1
			if cy==3 then
				cy=0
				page=0
			end
		elseif str=="Ｐ" then
			cx=0
			cy=0
			page=0
		elseif str=="ｐ" then
			ShowScreen();
			WaitKey();
			lib.Delay(100)
		elseif str=="Ｎ" then
			s=JY.Person[pid]["姓名"]..s
		elseif str=="ｎ" then
			s=JY.Person[0]["姓名"]..s
		else
			local kz1,kz2=readstr(str)
			if kz1==1 then
				t=kz2
			elseif kz1==2 then
				color=kz2
			elseif kz1==3 then
				font=kz2
			else
				lib.DrawStr(xy[flag].talkx+CC.DefaultFont*cx+5,
							xy[flag].talky+(CC.DefaultFont+talkBorder)*cy+talkBorder-8,
							str,color,CC.DefaultFont,font,0,0, 255)
				mydelay(t)
				cx=cx+string.len(str)/2
				if cx==talkxnum then
					cx=0
					cy=cy+1
					if cy==talkynum then
						cy=0
						page=0
					end
				end
			end
		end
		--如果换页，则显示，等待按键
		if page==0 or string.len(s)<1 then
			ShowScreen();
			WaitKey();
			lib.Delay(100)
		end

	end


    if CONFIG.KeyRepeat==0 then
	     lib.EnableKeyRepeat(CONFIG.KeyRepeatDelay,CONFIG.KeyRepeatInterval);
	end

	Cls();
end

function Alungky_MM_XMJJ_Def(picid, name)
  local ftype = math.random(11)
  local fst, snd, trd, fth, mth;
  local fuckid;
  local myName = JY.Person[0]["姓名"];
  if ftype == 1 then
  	fst = "早上好～";
  	snd = "现在啊？哦!";
  	trd = "（迅速脱光衣服，贴着地趴下，翘起圆实光滑，丰满，富有弹性的臀部）";
  	fth = "舒服吗？我伺候的还不错吧～";
  	mth = "我直接上了喔。。";
  	fuckid = 3;
  elseif ftype == 2 then
  	fst = "这里的空气真新鲜呀!";
  	snd = "来，来这里。";
  	trd = "（就近躺下，脱下裤子，岔开双腿，粉嫩小穴娇艳欲滴）";
  	fth = "开心么？你开心我就高兴啦～";
  	mth = "你真美，我要进攻咯";
  	fuckid = 4;
  elseif ftype == 3 then
  	fst = "江湖奔波，请多注意身体。";
  	snd = "就知道你想干那个。";
  	trd = "（脱下上衣，露出丰满，富有弹性的胸部，正面扶在附近的墙壁上，翘起臀部）";
  	fth = "怎么样，爽不爽？我的功夫还行吧？";
  	mth = "我已经完全等不及了！";
  	fuckid = 2;
  elseif ftype == 4 then
  	fst = "姐妹们都很团结友爱呢。";
  	snd = "啊？在这里？";
  	trd = "（脱下裤子，闭上双眼，就地趴下，翘起圆实光滑，丰满，富有弹性的臀部）";
  	fth = "精疲力竭了吧，舒服吗？";
  	mth = "直接...直接射, 太性感了。(使用隐形术看得更清楚）";
  	fuckid = 1;
  elseif ftype == 5 then
  	fst = "还有什么事吗？";
  	snd = "又想念温柔乡了？";
  	trd = "（找了附近舒适的地方躺下，露出雪白的大腿，并解开胸衣..）";
  	fth = "休息得好么？我刚才的表现可以打几分呢。";
  	mth = "亲爱的，我们好好缠绵一下吧。";
  	fuckid = 6;
  elseif ftype == 6 then
  	fst = "嗯哼？";
  	snd = "是不是想我啦？";
  	trd = "这次让我在上面好不好？（迅速脱光衣服，婀娜妖娆的身材一览无遗）";
  	fth = "快乐吗？是不是感觉上了天堂";
  	mth = "来来来，屁股蠕动起来。";
  	fuckid = 5;
  elseif ftype == 7 then
  	fst = "美雪大人又给大家买了些新衣服呢～";
  	snd = "想不想看我穿女佣服？";
  	trd = "我知道你想从后面操我，我的主人。（脱下裤子，就近趴在台子上，翘起美臀）";
  	fth = "舒服吗？是不是很舒服？";
  	mth = "你穿这个好正点，好正点！！！";
  	fuckid = 7;
  elseif ftype == 8 then
  	fst = "结界内，真是气候温和呢。";
  	snd = "你是不是想念我的温柔呀？";
  	trd = "这次你放松躺好，一切有我带你感受极乐好不好？（脱光衣服，娇媚的身段，美丽的脸庞展现眼前)";
  	fth = "是不是又爽，又轻松呢？";
  	mth = "正可谓轻松而舒适……动起来吧小美人";
  	fuckid = 8;
  elseif ftype == 9 then
  	fst = "这里的生活真的蛮充实的。";
  	snd = "这次你是不是想换一个花样？";
  	trd = "前些天大家一起挑选的军装，不错吧（解开上衣，脱下裤子，性感而美丽）";
  	fth = "感觉还不错吧？";
  	mth = "穿这个好诱惑！受不了了，我直接进入啦！（嘿）";
  	fuckid = 9;
  elseif ftype == 10 then
  	fst = "结界里真的是要什么有什么。";
  	snd = "清纯的学生妹你一定喜欢～";
  	trd = "学生装加黑丝不错吧？（脱下裤子，就近趴在较矮的台子上）";
  	fth = "果真强奸呀，多呆一会儿不肯哟……（轻微嘻笑）";
  	mth = "果然知心啊，哈哈，那就让我来强奸清纯，快枪来也～";
  	fuckid = 10;
  elseif ftype == 11 then
  	fst = "大家的技艺都有进展了呢。";
  	snd = "我知道你又想干坏事啦！";
  	trd = "听说这一件是结界制服？（脱光衣服将制服绑在腰间）";
  	fth = "还真是有点略微暴力呢，不过大家都习惯啦，呵呵。";
  	mth = "别管什么结界制服了，来来来，我们直入正题。";
  	fuckid = 11;
  end

  local r = JYMsgBox("想做什么", fst,  {"爱爱", "离开"}, 2, picid)
  
  --ooxx 控制逻辑
  if r == 1 then
  	say(snd, picid, 0, name)
  	say(trd, picid, 0, name)
  	--AlungkyShowPic(1)
  	AlungkySaywithPic(mth, 0, 1, myName, fuckid)
  	AlungkySaywithPic("啊..嗯..好深！好里面！", picid, 0, name, fuckid .. "-1")

    for i=1, 10 do
  		if fuckid >= 6 then
  			Alungky_show_pic(fuckid .. "-1")
  			Alungky_show_pic(fuckid .. "-2")
  		else
  			Alungky_show_pic(fuckid)
  			Alungky_show_pic(fuckid .. "-1")
  	end
  	end

    instruct_14()
    instruct_13()
    if fuckid >= 6 then
  		AlungkySaywithPic("啊，射在里面了，全部都射进了我的体内..", picid, 0, name, fuckid .. "-3")
  	else
  		AlungkySaywithPic("啊，射在里面了，全部都射进了我的体内..", picid, 0, name, fuckid .. "-2")
  	end
  	lib.Delay(500)
  	instruct_14()
    instruct_12()
    instruct_13()
    say(fth, picid, 0, name)
    local subName = Alungky_getSubName(name);
    say("我很满足，" .. subName .. "，我亲爱的小宝贝，有你这样的美人永远相伴，真好！", 0, 1, myName)
    instruct_0()
  end
end

function Alungky_humanfk(texID,headid,name)
	local fckSpeed = 50;
    local fckStart = CCX.RH_ACT[texID][1];
    local fckEnd = CCX.RH_ACT[texID][2];
    local fckNum = fckEnd - fckStart - 1;
    if fckNum > 49 then 
    	fckSpeed = 40
    end

    if fckNum > 100 then
    	fckSpeed = 30
    end
	while true do
		local tmpname;
  		for i = fckStart, fckEnd do
  			tmpname = i;
  			if i < 1000 then
  				tmpname = "0"..tmpname;
  				if i < 100 then
  					tmpname = "0"..tmpname;
  					if i<10 then
  						tmpname = "0"..tmpname;
  					end
  				end
  			end
  	    	Alungky_show_pic2("PK"..texID,tmpname,fckSpeed);
  		end
  		local tt;
  		for i = 1, fckNum do
  			tt = fckEnd-i;
  			tmpname = tt
  			if tt < 1000 then
  				tmpname = "0"..tmpname;
  				if tt < 100 then
  					tmpname = "0"..tmpname;
  					if tt<10 then
  						tmpname = "0"..tmpname;
  					end
  				end
  			end
  	    	Alungky_show_pic2("PK"..texID,tmpname,fckSpeed);
  		end
  		local keypress = lib.GetKey();
  		if keypress==VK_RIGHT then
  			fckSpeed = fckSpeed - 10;
        end
        if keypress==VK_LEFT then
        	AlungkySaywithPNG("啊嗯～啊嗯～主人的肉棒填满了小穴……",headid,0,name);
        end 
  		if fckSpeed < 10 then
  			AlungkySaywithPic("射了，射了，绝对中出！", 0, 1, myName, "PK"..texID.."/"..tmpname);
  			instruct_14()
  			instruct_13()
  			AlungkySaywithPic("啊，好爽，好爽！", 0, 1, myName, "PK"..texID.."/"..tmpname);
  			AlungkySaywithPNG("我和我的主人融合了，我要怀上主人的宝宝了！",headid,0,name);
  			instruct_14()
  			instruct_13()
  			break;
  		elseif fckSpeed < 20 then
  			AlungkySaywithPNG("请射在里面！请让我怀孕！我好爱你，主人～",headid,0,name);
  			fckSpeed = fckSpeed - 10;
  		end
	end
end

function Alungky_human_act(actid,headid, name, specstr)
	AlungkySaywithPNG("啊我的主人，请让我怀孕～请让我帮你生孩子",headid,0,name);
	say("被傀儡了就这样么……不过，我喜欢哈哈。", 0, 1, myName);
	AlungkySaywithPNG(specstr,headid,0,name);
	say("快来吧我的小美人～让我直接无套内射！", 0, 1, myName);
	AlungkySaywithPNG("请来～请随意～",headid,0,name);
	Alungky_humanfk(actid,headid,name);
end

--加强版传送地址菜单
function My_ChuangSong_Ex()     
	local title = "百事通传送功能";
	local str = "这是一个很方便的马车传送系统";
	local btn = {"列表选择", "输入代码","放弃"};
	local num = #btn;
	local aviSceneNum = 107;
	local r = JYMsgBox(title,str,btn,num,232,1);
	if r == 1 then
		return My_ChuangSong_List();
	elseif r == 2 then
		Cls();
		local sid = InputNum("请输入场景代码",0,aviSceneNum,1);
		if sid ~= nil then	
			
			if JY.Scene[sid]["进入条件"] == 0 and sid ~= 84 and sid ~= 83  and sid ~= 82 and  sid ~= 13 then
				My_Enter_SubScene(sid,-1,-1,-1);
			else
				say("您目前现在不能进入此场景", 232, 1, "百事通");
				return 1;
			end

		end
	end
end

--挑战四神
function Fight()
	say("四神可不是这么好惹的，你可得小心了", 232, 1, "百事通");
	SetS(86, 1, 9, 5, 1);
	
	for i=1, 10 do
		if GetS(86, 2, i, 5) == 0 then
			SetS(86, 2, i, 5, 2);
		end
	end
	
	local menu = {
		{"张三丰和乔峰",nil,GetS(86, 2, 1, 5)-1},
		{"张三丰和东方不败",nil,GetS(86, 2, 2, 5)-1},
		{"张三丰和扫地神僧",nil,GetS(86, 2, 3, 5)-1},
		{"乔峰和东方不败",nil,GetS(86, 2, 4, 5)-1},
		{"乔峰和扫地神僧",nil,GetS(86, 2, 5, 5)-1},
		{"东方不败和扫地神僧",nil,GetS(86, 2, 6, 5)-1},
		{"张三丰、东方不败和扫地神僧",nil,GetS(86, 2, 7, 5)-1},
		{"张三丰、乔峰和扫地神僧",nil,GetS(86, 2, 8, 5)-1},
		{"张三丰、乔峰和东方不败",nil,GetS(86, 2, 9, 5)-1},
		{"乔峰、东方不败和扫地神僧",nil,GetS(86, 2, 10, 5)-1},
	};
	
	local size = CC.DefaultFont;
	
	local x1 = (CC.ScreenW-13*size)/2 ;
	local y1 = (CC.ScreenH - #menu*(size + CC.RowPixel))/2 - size;
	DrawStrBox(x1, y1, "请选择挑战对象",C_WHITE, size);
	
	local numItem =  #menu;
	
	local r = ShowMenu(menu,numItem,0,x1,y1+2*size,0,0,1,1,size,C_ORANGE,C_WHITE);
	if r > 0 then
		Cls();
		SetS(86, 2, r, 5, 3);
		if WarMain(226) then
			SetS(86, 2, r, 5, 1);
			say("少侠好身手啊。", 232, 1, "百事通");
			QZXS("全体队友实战增加三十点");
			for i=1, 6 do
				for j=1, #TeamP do
					if JY.Base["队伍"..i] == TeamP[j] then
						SetS(5, j, 6, 5, GetS(5, j, 6, 5)+30);
						break;
					end
				end
			end
			QZXS("主角武学常识提高10点");
			AddPersonAttrib(0, "武学常识", 10);
		else
			SetS(86, 2, r, 5, 2);
			say("很可惜，先提高你的能力再来吧", 232, 1, "百事通");	
		end
	end
	
	SetS(86, 1, 9, 5, 0);
end

--进练功房
function LianGong()
	JY.Person[445]["等级"] = 30 * 100
  JY.Person[446]["等级"] = JY.Person[445]["等级"]
  JY.Person[445]["头像代号"] = math.random(190)
  JY.Person[446]["头像代号"] = math.random(190)
  JY.Person[445]["生命最大值"] = 10
  JY.Person[446]["生命最大值"] = 10
  JY.Person[445]["生命"] = JY.Person[445]["生命最大值"]
  JY.Person[446]["生命"] = JY.Person[446]["生命最大值"]
  instruct_6(226, 8, 0, 1)
  JY.Person[445]["等级"] = 10
  JY.Person[446]["等级"] = 10
  JY.Person[445]["头像代号"] = 208
  JY.Person[446]["头像代号"] = 208
	return 1;
end

--装备说明
function ZBInstruce()
	local flag = false
	Cls();
	repeat
		local x1 = CC.ScreenW/4 ;
		local y1 = CC.ScreenH/4;
		DrawStrBox(x1, y1, "请选择需要查看的装备",C_WHITE, CC.DefaultFont);
		local menu = {
			{"真武剑",nil,1},
			{"白马",nil,1},
			{"玄铁剑",nil,1},
			{"倚天剑",nil,1},
			{"屠龙刀",nil,1},
			{"软蝟甲",nil,1}
		};
		
		local numItem = #menu;
		local size = CC.DefaultFont;
		local r = ShowMenu(menu,numItem,0,x1+size*3,y1+size*2,0,0,1,1,size,C_ORANGE,C_WHITE);
		if r == 0 then
			flag = true;
		elseif r == 1 then
			say("真武剑，使用太极剑法必连击", 232, 1, "百事通");
		elseif r == 2 then
			say("白马，额外提高五点集气速度", 232, 1, "百事通");	
		elseif r == 3 then
			say("玄铁剑，配合玄铁剑法必暴击，配合其它剑法提高暴击率", 232, 1, "百事通");	
		elseif r == 4 then
			say("倚天剑，攻击必流血，并且一定机率封穴", 232, 1, "百事通");	
		elseif r == 5 then
			say("屠龙刀，使用等级为极的刀法提高百分之四十暴击率，暴击的情况下有百分之五十机率大幅度杀集气，并且造成流血。杀集气量与武功威力有关", 232, 1, "百事通");	
		elseif r == 6 then
			say("软蝟甲，受到拳系武功攻击时反射一定的伤害，受到非拳系武功攻击时减少伤害", 232, 1, "百事通");	
		end
	until flag
end

--brolycjw: 队友挑战
function DYRW()
	Cls();
	local x1 = CC.ScreenW/4 ;
	local y1 = CC.ScreenH/4;
	DrawStrBox(x1, y1, "请选择挑战队友",C_WHITE, CC.DefaultFont);
	local menu = {}
	local id,tid = 0;
		for i = 1, CC.TeamNum do
			menu[i] = {"", nil, 0}
			id = JY.Base["队伍" .. i]		
				if id > 0 then
				menu[i][3] = 1
				menu[i][1] = JY.Person[id]["姓名"]
			end
		end
	local numItem = #menu;
	local size = CC.DefaultFont;
	local r = ShowMenu(menu,numItem,0,x1,y1+CC.DefaultFont,0,0,1,1,size,C_ORANGE,C_WHITE);
	if r > 0 then
		id = JY.Base["队伍" .. r]
		SetS(86,15,1,5,id)
		for t=1, CC.MyTeamNum do
			if id == TeamP[t] then
				tid = t
				break;
			end
		end
		Cls();
		DrawStrBox(x1, y1, "请选择挑战难度",C_WHITE, CC.DefaultFont);
		menu = {
			{"初级",nil,GetS(86,16,tid,5)-1},
			{"中级",nil,GetS(86,17,tid,5)-1},
			{"高级",nil,GetS(86,18,tid,5)-1},
			{"神级",nil,GetS(86,19,tid,5)-1},
		};
		numItem = #menu;
		local rr = ShowMenu(menu,numItem,0,x1,y1+40,0,0,1,1,size,C_ORANGE,C_WHITE);
		if rr > 0 then
			SetS(86,15,2,5,rr)
			if WarMain(79) then
				SetS(86, 15+rr, tid, 5, 1);
				SetS(86, 16+rr, tid, 5, 2);
				say("真是好身手啊。", 232, 1, "百事通");
				QZXS(string.format("%s 实战增加%s点",JY.Person[id]["姓名"],rr*50));
				QZXS(string.format("%s 攻防轻增加%s点",JY.Person[id]["姓名"],rr*5));
				SetS(5, tid, 6, 5, GetS(5, tid, 6, 5)+rr*50);
				AddPersonAttrib(id, "攻击力", rr*5);
				AddPersonAttrib(id, "防御力", rr*5);
				AddPersonAttrib(id, "轻功", rr*5);
			else
				SetS(86, 15+rr, tid, 5, 2);
				say("很可惜，先提高你的能力再来吧", 232, 1, "百事通");	
			end
		end	
	end
	SetS(86,15,1,5,0)
	SetS(86,15,2,5,0)
end

--武功特效说明
function WuGongIntruce()
	local menu = {};
	
	for i = 1, JY.WugongNum-1 do
		menu[i] = {i..JY.Wugong[i]["名称"], nil, 0}
	end
	
	--拥有的秘籍
	for i = 1, CC.MyThingNum do
    if JY.Base["物品" .. i] > -1 and JY.Base["物品数量" .. i] > 0 then
    	local wg = JY.Thing[JY.Base["物品" .. i]]["练出武功"];
    	if wg > 0 then
    		menu[wg][3] = 1;
    	end
    else
    	break;
    end
  end
  
  --学会的武功
  for i=1, CC.TeamNum do
  	if JY.Base["队伍"..i] >= 0 then
  		for j=1, 10 do
  			if JY.Person[JY.Base["队伍"..i]]["武功"..j] > 0 then
  				menu[JY.Person[JY.Base["队伍"..i]]["武功"..j]][3] = 1;
  			else
  				break;
  			end
  		end
  	else
  		break;
  	end
  end
	
	local r = -1;
	while true do
		Cls();
		
		r = ShowMenu2(menu,JY.WugongNum-1,4,12,10,(CC.ScreenH-12*(CC.DefaultFont+CC.RowPixel))/2+20,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE, "请选择查看的武功", r);
		--local r = ShowMenu(menu,n,15,CC.ScreenW/4,20,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE);
		
		if r > 0 and r < JY.WugongNum then	
			InstruceWuGong(r);
		else
			break;
		end
	end
	
end

--显示武功或内功特效
function InstruceWuGong(id)
	
	if id < 0 or id >= JY.WugongNum then
		QZXS("武功未知错误，无法查看");
		return;
	end
	
	local filename = string.format("%s%d.txt", CONFIG.WuGongPath,id)
	if existFile(filename) == false then
		QZXS("此武功未包含任何说明，请自行琢磨");
		return;
	end
	
	DrawTxt(filename);
	
end

function TSInstruce()
	local filemenu = {};
	local n = 0;
	for i=1, math.huge do
		if existFile(string.format("%s%d.txt",CONFIG.HelpPath, i)) then
			filemenu[i] = string.format("%s%d.txt",CONFIG.HelpPath, i);
			n = n + 1;
		else
			break;
		end
	end
	
	local menu = {}
	local maxlen = 0;
	for i=1, n do
		local file = io.open(filemenu[i],"r")
		local str = file:read("*l")
		
		if str == nil then
			str = " ";
		end
		
		if #str > maxlen then
			maxlen = #str;
		end
		
		menu[i] = {i..str, nil, 1};
		
		file:close()
	end
	
	local size = CC.DefaultFont;
	
	while true do
		Cls();
		--local r = ShowMenu(menu,n,10,x1,y1,0,0,1,1,size,C_ORANGE,C_WHITE);
		local r = ShowMenu2(menu,#menu,2,12,20,(CC.ScreenH-12*(size+CC.RowPixel))/2+20,0,0,1,1,size,C_ORANGE,C_WHITE);
		if r > 0 then
			InstruceTS(r);
		else
			break;
		end
	end
end

--显示武功或内功特效
function InstruceTS(id)
		
	local filename = string.format("%s%d.txt", CONFIG.HelpPath,id)
	if existFile(filename) == false then
		QZXS("未找到相关的攻略文件");
		return;
	end
	
	DrawTxt(filename);
	
end

function DrawTxt(filename)
	Cls();
	
	--读取文件说明
	local file = io.open(filename,"r")
	local str = file:read("*a")
	file:close()
	
	local size = CC.DefaultFont;
	local color = C_WHITE;
	
	local linenum = 50;		--显示长度
	local maxlen = 14;
	local w = linenum*size/2 + size;
	local h = maxlen*(size+CC.RowPixel) + 2*CC.RowPixel;
	
	local bx = (CC.ScreenW-w)/2;
	local by = (CC.ScreenH-h)/2;
	DrawBox(bx,by,bx+w,by+h,C_WHITE);		--底边框
	local x = bx + CC.RowPixel;
	local y = by + CC.RowPixel;
	
	local surid = lib.SaveSur(0, 0, CC.ScreenW, CC.ScreenH)
	
	local strcolor = AnalyString(str)
	local l = 0
	local row = 0;


	for i,v in pairs(strcolor) do
		while 1 do
			if v[1] == nil then
				break;
			end
			local index = string.find(v[1], "\n")
			
			if l+#v[1] < linenum and index == nil then		--如果未到换行，没有找到换行
				DrawString(x + l*size/2, y + row*(size+CC.RowPixel), v[1], v[2] or color, size);
				l = l + #v[1]

				if i == #strcolor then
					--显示文字	ALungky:j 改成 j+1解决了末尾文字有时候无法显示的问题。
					for j=0, l do
						lib.SetClip(x,y,x+(j+1)*size/2,y+size+row*(size+CC.RowPixel));
						ShowScreen(1);
					end
					lib.SetClip(0,0,0,0);
				end
				break;
			else	--如果达到换行
				local tmp, pos1, pos2;
				if index == nil then
					pos1 = linenum-l;
					pos2 = pos1+1;
				else
					pos1 = index-1;
					pos2 = pos1+2;
					
					if pos1 > linenum-l then
						index = nil;
						pos1 = linenum-l;
						pos2 = pos1+1;
					end
				end
				
				--这个用于判断是否已经到达v[1]的最后内容部分
				if pos1 > #v[1] then
					tmp = v[1];
					v[1] = nil;
				else
					tmp = string.sub(v[1], 1, pos1)
					local flag = 0
					for i=1, pos1 do
						if string.byte(tmp, i) <= 127 then
							flag = flag + 1;
						end
					end
					
	
					if math.fmod(flag,2) == 1 and index == nil  then		--如果包含有单字符
							if string.byte(tmp, -1) > 127 then
								tmp = string.sub(v[1], 1, pos1-1);
								pos2 = pos2 - 1
							end
					end
	
					v[1] = string.sub(v[1], pos2);
				end
					
	
					DrawString(x + l*size/2, y + row*(size+CC.RowPixel), tmp, v[2] or color, size);
	
	
					l = l + #tmp
					--显示文字
					for j=0, l do
						lib.SetClip(x,y,x+j*size/2,y+size+row*(size+CC.RowPixel));
						ShowScreen(1);
					end
					
					--行数+1
					row = row + 1
					l = 0

				
			end

			lib.SetClip(0,0,0,0);
			
			if row == maxlen then
				WaitKey();
				row = 0;
				Cls();
				lib.LoadSur(surid, 0, 0)
				
			end
		end
	end
	lib.SetClip(0,0,0,0);
	WaitKey();
	lib.FreeSur(surid)
end

--十四本天书之后得到5000两
--修复自动洗四神技的BUG
function NEvent2(keypress)
  if JY.SubScene == 70 and GetD(70, 3, 0) == 0 and instruct_18(151) then
    instruct_3(70, 3, 1, 0, 0, 0, 0, 2610, 2610, 2610, 0, -2, -2)
  end
  if GetD(70, 3, 5) == 2610 and JY.SubScene == 70 and JY.Base["人X1"] == 8 and JY.Base["人Y1"] == 41 and JY.Base["人方向"] == 2 and keypress == VK_SPACE then
    say("１咦，有张纸条......Ｈ（小子，这是留给你的五千两银子，好好准备一下吧）Ｈ哈，那老家伙还很够意思嘛！")
    instruct_2(174, 5000)
    SetS(10, 0, 17, 0, 1)
    SetD(83, 48, 4, 882)
    
    instruct_3(70, 3, 1, 0, 0, 0, 0, 2612, 2612, 2612, 0, -2, -2)
  end
end

--胡斐 苗人凤教苗家剑法
function NEvent3(keypress)
  if JY.SubScene == 24 and JY.Base["人X1"] == 18 and JY.Base["人Y1"] == 23 and JY.Base["人方向"] == 2 and (keypress == VK_SPACE or keypress == VK_RETURN) and GetS(10, 0, 3, 0) ~= 1 and instruct_16(1) and instruct_18(145) and JY.Person[1]["武功等级1"] == 999 then
    say("１苗大侠，我已经找到雪山飞狐这本书了", 1)
    say("１嗯，很好！看来你的胡家刀法也已练得炉火纯青了，以后的江湖就看你们这些年轻人的了！这本苗家剑法你拿去吧！", 3)
    say("１多谢苗大侠！", 1)
    for i = 1, 10 do
      if JY.Person[1]["武功" .. i] == 0 then
        JY.Person[1]["武功" .. i] = 44
        JY.Person[1]["武功等级" .. i] = 50
        DrawStrBox(-1, -1, "胡斐学会苗家剑法", C_ORANGE, CC.DefaultFont)
        ShowScreen()
        lib.Delay(1000)
        Cls()
        break;
      end
    end
    instruct_2(117, 1)
    SetS(10, 0, 3, 0, 1)
  end
end

--令狐冲12本书变身
function NEvent4(keypress)
  if JY.SubScene == 7 and JY.Base["人X1"] == 34 and JY.Base["人Y1"] == 11 and JY.Base["人方向"] == 2 then
    local ts = 0
    for i = 1, 200 do
      if JY.Base["物品" .. i] > 143 and JY.Base["物品" .. i] < 158 then
        ts = ts + 1
      end
    end
 
	  if ts > 11 and instruct_16(35) and instruct_18(114) and GetS(10, 1, 1, 0) ~= 1 and JY.Person[35]["武功等级1"] == 999 and keypress == VK_SPACE then
	    SetS(7, 34, 12, 3, 102)
	    instruct_3(7, 102, 1, 0, 0, 0, 0, 7148, 7148, 7148, 0, 34, 12)
	    say("１雕兄－－，真想见识一下独孤前辈的风采啊！最近总感觉到对九剑有了新的领悟，但又很模糊，不能具体总结出来！", 35, 1)
	    say("１哈哈－－－－，是时候了！", 140, 0)
	    say("１风太师叔！！！", 35)
	    instruct_14()
	    SetS(7, 33, 12, 3, 101)
	    instruct_3(7, 101, 1, 0, 0, 0, 0, 5896, 5896, 5896, 0, 33, 12)
	    instruct_13()
	    PlayMIDI(24)
	    lib.Delay(2000)
	    say("４冲儿，跟我一起唱：沧海一声笑　滔滔两岸潮　浮沉随浪只记今朝　苍天笑　纷纷世上潮　谁负谁胜出天知晓　江山笑　烟雨遥　涛浪淘尽红尘俗事知多少　清风笑竟惹寂寥　豪情还剩一襟晚照　苍生笑　不再寂寥　豪情仍在痴痴笑笑", 140, 0)
	    say("１冲儿，九剑的极意就隐藏在这首歌中，自已好好去体会吧！老夫心愿已了，从此再无牵挂，就此去也，哈哈－－－－", 140, 0)
	    say("１多谢太师叔传剑，你老人家多保重！嗯，就在这里参悟九剑的奥义吧－－－－", 35, 1)
	    instruct_14()
	    instruct_3(7, 101, 0, 0, 0, 0, 0, -1, -1, -1, 0, 33, 12)
	    instruct_13()
	    DrawStrBox(-1, -1, "三日后", C_ORANGE, CC.DefaultFont)
	    ShowScreen()
	    lib.Delay(1000)
	    say("１成了！这才是真正的独孤九剑啊！此生有幸能学到独孤前辈之神技，夫复何憾！", 35, 1)
	    DrawStrBox(-1, -1, "令狐冲领悟九剑之秘传", C_ORANGE, CC.DefaultFont)
	    ShowScreen()
	    lib.Delay(2000)
	    Cls()
	    DrawStrBox(-1, -1, "令狐冲称号变改", C_ORANGE, CC.DefaultFont)
	    ShowScreen()
	    lib.Delay(1000)
	    Cls()
	    SetS(10, 1, 1, 0, 1)
	    instruct_3(7, 102, 0, 0, 0, 0, 0, -1, -1, -1, 0, 34, 12)
	  end
  end
end
--倚天邪线，最后给玄慈人头
function NEvent5(keypress)
  if JY.SubScene == 28 and JY.Base["人X1"] == 15 and JY.Base["人Y1"] == 28 and JY.Base["人方向"] == 2 and GetD(11, 109, 0) ~= 1  and instruct_18(219) and (keypress == VK_SPACE or keypress == VK_RETURN) then
    say("１给你人头！")
    say("１给你书！", 70)
    instruct_2(155, 1)
    instruct_32(219, -1)
    
  end
end--山洞事件
function NEvent6(keypress)
  if JY.SubScene == 10 then
    SetD(10, 28, 4, -1)
    SetS(10, 23, 22, 1, 2)
    SetS(10, 22, 22, 1, 2)
  end
  if JY.SubScene == 59 then
    JY.SubSceneX = 0
    JY.SubSceneY = 0
  end
end
--华山觉醒
function NEvent7(keypress)
  
end
--挑战张三丰，得到六如
function NEvent8(keypress)
  if JY.SubScene == 43 and GetS(53, 0, 2, 5) == 1 and GetS(53, 0, 4, 5) == 1 and GetS(53, 0, 5, 5) ~= 1 and JY.Base["人X1"] == 17 and JY.Base["人Y1"] == 27 and JY.Base["人方向"] == 2 and (keypress == VK_SPACE or keypress == VK_RETURN) then
    say("１你终于来了", 5)
    say("拜见真张人")
    say("１事情很简单，这里有个卷轴，只要你能打败我，那么它就是你的", 5)
    say("１Ｒ（......听说在这小子的那个空间中有很多人觉得老夫很弱！也罢，那就来玩玩吧！）", 5)
    if DrawStrBoxYesNo(-1, -1,"要挑战吗？", C_WHITE, CC.DefaultFont) then
      if WarMain(22) then
        PlayMIDI(3)
        say( "１好功夫！这是阮娲留给你的卷轴，拿去吧！", 5)
        say("< １呼，终于到手了！真不容易啊！这老道功夫的确了得！看看这卷轴的内容---- >")
        say("１Ｒ原来是这样~~~~我懂了，原来我的感觉一直都没错")
        DrawStrBoxWaitKey(string.format("%s领悟身世绝学，功力大幅度提升", JY.Person[0]["姓名"]), C_ORANGE, CC.DefaultFont)
 				SetS(53, 0, 5, 5,1)
        SetS(80, 48, 36, 3, 100)
        instruct_3(80, 100, 0, 0, 0, 0, 2002, 0, 0, 0, 0, -2, -2)
        say("１行了，你已经领悟了！继续去完成你的使命吧！", 5)
        
      else
      	say("１还缺点火候，下次再来吧！", 5)
      end
    else
    	say("１随时可以再来！老夫恭候！", 5)
    end
  end
end
--武道大会，直接挑战十五大
function NEvent9(keypress)
  if JY.SubScene == 25 and GetS(10, 0, 8, 0) ~= 1 and GetD(25, 74, 5) == 2610 then
    SetS(25, 40, 33, 3, 101)
    instruct_3(25, 101, 1, 0, 0, 0, 0, 6824, 6824, 6824, 0, -2, -2)
  end
  if JY.Base["人X1"] == 41 and JY.Base["人Y1"] == 33 and JY.Base["人方向"] == 2 and (keypress == VK_SPACE or keypress == VK_RETURN) then
    say("１是否想直接挑战十五大高手？", 300, 0, "软体娃娃")
    if DrawStrBoxYesNo(-1, -1, "要直接挑战吗？", C_ORANGE, CC.DefaultFont) then
      if JY.Person[0]["品德"] > 50 then
        if WarMain(133) then
          say("１恭喜你战胜了十五大，那么－－－－", 300, 0, "软体娃娃")
          instruct_14()
          JY.Base["人X1"] = 11
          JY.Base["人Y1"] = 44
          instruct_13()
          SetS(10, 0, 8, 0, 1)
          instruct_3(25, 72, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2)
          instruct_3(25, 101, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2)
        end
	    else
	      if WarMain(134) then
	        say("１恭喜你战胜了十五大，那么－－－－", 300, 0, "软体娃娃")
	        instruct_14()
	        JY.Base["人X1"] = 11
	        JY.Base["人Y1"] = 44
	        instruct_13()
	        SetS(10, 0, 8, 0, 1)
	        instruct_3(25, 72, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2)
	        instruct_3(25, 101, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2)
	      end
    	end
  	else
    	say("１那就请上擂台吧！", 300, 0, "软体娃娃")
    end
  end
end
--武道大会后，SYP自动放书
function NEvent10(keypress)
  if JY.SubScene == 25 and GetS(10, 0, 9, 0) ~= 1 then
    SetS(25, 9, 44, 3, 103)
    instruct_3(25, 103, 1, 0, 0, 0, 0, 9244, 9244, 9244, 0, -2, -2)
    if JY.Base["人X1"] == 10 and JY.Base["人Y1"] == 44 and JY.Base["人方向"] == 2 and (keypress == VK_SPACE or keypress == VK_RETURN) and GetD(25, 82, 5) == 4662 then
      say("１一路来到这里，真是辛苦了！我来帮你放书吧", 0, 0, "龙的传人")
      instruct_14()
      for i = 79, 92 do
          instruct_3(25, i, 1, 0, 0, 0, 0, 4664, 4664, 4664, 0, -2, -2)
      end
      for ii = CC.BookStart, CC.BookStart + CC.BookNum -1 do
          instruct_32(ii, -10)
      end
      instruct_3(25, 75, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2)
      instruct_3(25, 76, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2)
      instruct_13()
      say("１书已经放好了，从上面的门出去吧", 0, 0, "龙的传人")
      SetS(10, 0, 9, 0, 1)
      instruct_3(25, 103, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2)
      
    end
  end
end
--钓鱼岛 阿朱
function NEvent11(keypress)
  if JY.SubScene == 104 and JY.Person[104]["姓名"] ~= "阿朱 " then
    instruct_3(104, 91, 1, 0, 0, 0, 0, 6086, 6086, 6086, 0, -2, -2)
  end
  if JY.SubScene == 104 and JY.Base["人X1"] == 42 and JY.Base["人Y1"] == 38 and JY.Base["人方向"] == 0 and (keypress == VK_SPACE or keypress == VK_RETURN) and GetD(104, 91, 0) == 1 then
    say("１辽国皇帝耶律洪基即将进军中原，萧大哥在尽力想法劝阻，所以无法赶来相助，这是他让我交给你的东西", 104)
    instruct_2(8, 10)
    say("１我要回去帮助萧大哥了，再见！", 104)
    instruct_3(104, 91, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2)
    JY.Person[104]["姓名"] = "阿朱 "
  end
end
--大功坊 和袁承志对话后，金蛇剑归还
function NEvent12(keypress)
  if JY.SubScene == 95 and GetD(95, 4, 5) ~= 0 and JY.Thing[40]["使用人"] ~= -1 then
    JY.Person[JY.Thing[40]["使用人"]]["武器"] = -1
    JY.Thing[40]["使用人"] = -1
    JY.Thing[40]["加轻功"] = 10
    JY.Thing[40]["加攻击力"] = 20
  end
end

function mm4R()
  local r = nil
  if JY.Thing[202][WZ7] == 1 then
    r = math.random(2)
  else
    r = math.random(4)
  end
  local bdnl = {"姓名", "头像代号", "生命最大值", "内力最大值", "内力性质", "攻击力", "轻功", "防御力", "拳掌功夫", "御剑能力", "耍刀技巧", "特殊兵器", "资质", "武功1"}
  local mm4 = {}
  mm4[1] = {"周芷若", 301, 350, 600, 0, 60, 50, 50, 30, 30, 0, 0, 80+Rnd(5), 41}
  mm4[2] = {"赵敏", 302, 270, 500, 1, 70, 40, 50, 0, 40, 0, 0, 80+Rnd(5), 37}
  mm4[3] = {"郭襄", 303, 200, 500, 2, 40, 40, 40, 20, 20, 20, 20, 80+Rnd(5), 12}
  mm4[4] = {"陆无双", 304, 400, 700, 0, 70, 40, 60, 0, 0, 40, 0, 40+Rnd(5), 54}
  for i = 1, 14 do
    JY.Person[92][bdnl[i]] = mm4[r][i]
  end
  JY.Person[92]["等级"] = 5
  for i = 1, 5 do
    JY.Person[92]["出招动画帧数" .. i] = 0
    JY.Person[92]["出招动画延迟" .. i] = 0
    JY.Person[92]["武功音效延迟" .. i] = 0
  end
  local avi = {
{14, 6, 7}, 
{8, 3, 4}, 
{0, 0, 0}, 
{7, 4, 5}}
  JY.Person[92]["出招动画帧数1"] = avi[r][1]
  JY.Person[92]["出招动画延迟1"] = avi[r][3]
  JY.Person[92]["武功音效延迟1"] = avi[r][2]
  if r == 3 then
    local s = {
{0, 0, 0}, 
{9, 2, 3}, 
{8, 3, 4}, 
{8, 3, 4}, 
{9, 5, 6}}
    for i = 1, 5 do
      JY.Person[92]["出招动画帧数" .. i] = s[i][1]
      JY.Person[92]["出招动画延迟" .. i] = s[i][3]
      JY.Person[92]["武功音效延迟" .. i] = s[i][2]
    end
  end
end