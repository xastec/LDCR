--Alungky �ڰ׺�ѵ����
function Alungky_LianGong(idx)
  local battleID = 245;
  if idx == 1 then
  	battleID = 210
  elseif idx == 2 then
  	battleID = 13
  end 
  return instruct_6(battleID, 8, 0, 1)
end

--���͵�ַ�б�
function My_ChuangSong_List()
	local menu = {};
	local aviSceneNum = 107;
	for i=0, aviSceneNum-1 do
		menu[i+1] = {i..JY.Scene[i]["����"], nil, 1};
		if JY.Scene[i]["��������"] ~= 0 or  i == 84 or i == 83  or i == 82 or  i == 13 then
			menu[i+1][3] = 0;
		end
	end
	
	local r = ShowMenu2(menu,aviSceneNum,4,12,-1,(CC.ScreenH-12*(CC.DefaultFont+CC.RowPixel))/2+20,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE, "��ѡ���͵�ַ");
	
	if r == 0 then
		return 0;
	end
	
	if r > 0 then	
		
		local sid = r-1;
		
		if JY.Scene[sid]["��������"] == 0 and sid ~= 84 and sid ~= 83  and sid ~= 82 and  sid ~= 13 then
				My_Enter_SubScene(sid,-1,-1,-1);
			else
				say("��Ŀǰ���ڲ��ܽ���˳���", 232, 1, "����ͨ");
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
--ѡ�����
function ALungky_fk_rouhulist(name, idx)
	local menu = {};
	local fkNum = 13;

	for i=0, fkNum-1 do
		menu[i+1] = {i..CCX.RH_Name[i+1][1], nil, 1};
	end
	
	local r = ShowMenu2(menu,fkNum,4,12,-1,(CC.ScreenH-12*(CC.DefaultFont+CC.RowPixel))/2+20,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE, "��ѡ������Ҫ�����");
	
	if r == 0 then
		return 0;
	end
	
	if r > 0 then
		say("ԭ����Ҫ"..CCX.RH_Name[r][1].."��������ѽ�������Եȣ������ϰ������͹���Ŷ��",idx,0,name);
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
		if JY.Person[i]["�������ֵ"] > tres then
			menu[k+1] = {i..JY.Person[i]["����"], nil, 1};
			k = k+1;
		end
	end
	
	local r = ShowMenu2(menu,k,4,12,-1,(CC.ScreenH-12*(CC.DefaultFont+CC.RowPixel))/2+20,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE, "��ѡ������");
	
	if r == 0 then
		return 0;
	end

	local rpos = 0;
	if r > 0 then	
		
		local sid = r-1;
		k = 0;
		for j=0, NameNum-1 do
			if JY.Person[j]["�������ֵ"] > tres then
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
--���͵�Ѫħ���
function Alungky_tranfort_XMJJ()
	local XMJJ_ID = 107;
	My_Enter_SubScene(XMJJ_ID,8,32,-1);
end

function Alungky_tranfort_XMJJ_LiLian()
	local XMJJ_ID = 107;
	My_Enter_SubScene(XMJJ_ID,29,11,-1);
end

--���͵�С��
function Alungky_tranfort_XC()
	local XC_ID = 70;
	My_Enter_SubScene(XC_ID,27,27,-1);
end

--���͵��þ�
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

function AlungkySaywithPNG(s,texID,flag,name)          --�����¶Ի�
	local picw=CC.PortraitPicWidth;       --���ͷ��ͼƬ���
	local pich=CC.PortraitPicHeight;
	local talkxnum=18;         --�Ի�һ������
	local talkynum=3;          --�Ի�����
	local dx=2 * CC.Scale;
	local dy=2 * CC.Scale;
	local nbx=96 * CC.Scale;   --��������
	local nby=27 * CC.Scale;   --������߶�
	local boxpicw=picw+10 * CC.Scale;
	local boxpich=pich+10 * CC.Scale;
	local boxtalkw=talkxnum*CC.DefaultFont+10;
	local boxtalkh=boxpich-nby;

	name=name or "δ����"
    local talkBorder = (boxtalkh - talkynum * CC.DefaultFont) / (talkynum+1);

	--��ʾͷ��ͶԻ�������
    local xy={ [0]={headx=dx,heady=dy,
	                talkx=dx+boxpicw+2,talky=dy+nby,
					namex=dx+boxpicw+2,namey=dy,
					showhead=1},--����
                   {headx=CC.ScreenW-1-dx-boxpicw,heady=CC.ScreenH-dy-boxpich,
				    talkx=CC.ScreenW-1-dx-boxpicw-boxtalkw-2,talky= CC.ScreenH-dy-boxpich+nby,
					namex=CC.ScreenW-1-dx-boxpicw-nbx,namey=CC.ScreenH-dy-boxpich,
					showhead=1},--����
                   {headx=dx,heady=dy,
				   talkx=dx+boxpicw-43 * CC.Scale,talky=dy+nby,
					namex=dx+boxpicw+2,namey=dy,
				   showhead=0},--����
                   {headx=CC.ScreenW-1-dx-boxpicw,heady=CC.ScreenH-dy-boxpich,
				   talkx=CC.ScreenW-1-dx-boxpicw-boxtalkw-2,talky= CC.ScreenH-dy-boxpich+nby,
					namex=CC.ScreenW-1-dx-boxpicw-nbx,namey=CC.ScreenH-dy-boxpich,
					showhead=1},
                   {headx=CC.ScreenW-1-dx-boxpicw,heady=dy,
				    talkx=CC.ScreenW-1-dx-boxpicw-boxtalkw-2,talky=dy+nby,
					namex=CC.ScreenW-1-dx-boxpicw-nbx,namey=dy,
					showhead=1},--����
                   {headx=dx,heady=CC.ScreenH-dy-boxpich,
				   talkx=dx+boxpicw+2,talky=CC.ScreenH-dy-boxpich+nby,
					namex=dx+boxpicw+2,namey=CC.ScreenH-dy-boxpich,
				   showhead=1}, --����
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
		local T1={"��","��","��","��","��","��","��","��","��","��"}
		local T2={{"��",C_RED},{"��",C_GOLD},{"��",C_BLACK},{"��",C_WHITE},{"��",C_ORANGE}}
		local T3={{"��",CC.FontNameSong},{"��",CC.FontNameHei},{"��",CC.FontName}}
		--�����������Բ�ͬ����ͬһ����ʾ����Ҫ΢�������꣬�Լ��ֺ�
		--��Ĭ�ϵ�����Ϊ��׼�����������ƣ�ϸ��������
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
			str='��'
			s=string.sub(s,2,-1)
		else
			if string.byte(s,1,1) > 127 then		--�жϵ�˫�ַ�
				str=string.sub(s,1,2)
				s=string.sub(s,3,-1)
			else
				str=string.sub(s,1,1)
				s=string.sub(s,2,-1)
			end
		end
		--��ʼ�����߼�
		if str=="��" then
			cx=0
			cy=cy+1
			if cy==3 then
				cy=0
				page=0
			end
		elseif str=="��" then
			cx=0
			cy=0
			page=0
		elseif str=="��" then
			ShowScreen();
			WaitKey();
			lib.Delay(100)
		elseif str=="��" then
			s=JY.Person[pid]["����"]..s
		elseif str=="��" then
			s=JY.Person[0]["����"]..s
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
		--�����ҳ������ʾ���ȴ�����
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

function AlungkySaywithPic(s,pid,flag,name,fid)          --�����¶Ի�
	local picw=CC.PortraitPicWidth;       --���ͷ��ͼƬ���
	local pich=CC.PortraitPicHeight;
	local talkxnum=18;         --�Ի�һ������
	local talkynum=3;          --�Ի�����
	local dx=2 * CC.Scale;
	local dy=2 * CC.Scale;
	local nbx=96 * CC.Scale;   --��������
	local nby=27 * CC.Scale;   --������߶�
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
	if (headid == 0 or headid == nil) and (name == nil or name == JY.Person[0]["����"]) then
		headid = (280 + GetS(4, 5, 5, 5))
	end

	name=name or JY.Person[pid]["����"]
    local talkBorder = (boxtalkh - talkynum * CC.DefaultFont) / (talkynum+1);

	--��ʾͷ��ͶԻ�������
    local xy={ [0]={headx=dx,heady=dy,
	                talkx=dx+boxpicw+2,talky=dy+nby,
					namex=dx+boxpicw+2,namey=dy,
					showhead=1},--����
                   {headx=CC.ScreenW-1-dx-boxpicw,heady=CC.ScreenH-dy-boxpich,
				    talkx=CC.ScreenW-1-dx-boxpicw-boxtalkw-2,talky= CC.ScreenH-dy-boxpich+nby,
					namex=CC.ScreenW-1-dx-boxpicw-nbx,namey=CC.ScreenH-dy-boxpich,
					showhead=1},--����
                   {headx=dx,heady=dy,
				   talkx=dx+boxpicw-43 * CC.Scale,talky=dy+nby,
					namex=dx+boxpicw+2,namey=dy,
				   showhead=0},--����
                   {headx=CC.ScreenW-1-dx-boxpicw,heady=CC.ScreenH-dy-boxpich,
				   talkx=CC.ScreenW-1-dx-boxpicw-boxtalkw-2,talky= CC.ScreenH-dy-boxpich+nby,
					namex=CC.ScreenW-1-dx-boxpicw-nbx,namey=CC.ScreenH-dy-boxpich,
					showhead=1},
                   {headx=CC.ScreenW-1-dx-boxpicw,heady=dy,
				    talkx=CC.ScreenW-1-dx-boxpicw-boxtalkw-2,talky=dy+nby,
					namex=CC.ScreenW-1-dx-boxpicw-nbx,namey=dy,
					showhead=1},--����
                   {headx=dx,heady=CC.ScreenH-dy-boxpich,
				   talkx=dx+boxpicw+2,talky=CC.ScreenH-dy-boxpich+nby,
					namex=dx+boxpicw+2,namey=CC.ScreenH-dy-boxpich,
				   showhead=1}, --����
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
		local T1={"��","��","��","��","��","��","��","��","��","��"}
		local T2={{"��",C_RED},{"��",C_GOLD},{"��",C_BLACK},{"��",C_WHITE},{"��",C_ORANGE}}
		local T3={{"��",CC.FontNameSong},{"��",CC.FontNameHei},{"��",CC.FontName}}
		--�����������Բ�ͬ����ͬһ����ʾ����Ҫ΢�������꣬�Լ��ֺ�
		--��Ĭ�ϵ�����Ϊ��׼�����������ƣ�ϸ��������
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
			str='��'
			s=string.sub(s,2,-1)
		else
			if string.byte(s,1,1) > 127 then		--�жϵ�˫�ַ�
				str=string.sub(s,1,2)
				s=string.sub(s,3,-1)
			else
				str=string.sub(s,1,1)
				s=string.sub(s,2,-1)
			end
		end
		--��ʼ�����߼�
		if str=="��" then
			cx=0
			cy=cy+1
			if cy==3 then
				cy=0
				page=0
			end
		elseif str=="��" then
			cx=0
			cy=0
			page=0
		elseif str=="��" then
			ShowScreen();
			WaitKey();
			lib.Delay(100)
		elseif str=="��" then
			s=JY.Person[pid]["����"]..s
		elseif str=="��" then
			s=JY.Person[0]["����"]..s
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
		--�����ҳ������ʾ���ȴ�����
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
  local myName = JY.Person[0]["����"];
  if ftype == 1 then
  	fst = "���Ϻá�";
  	snd = "���ڰ���Ŷ!";
  	trd = "��Ѹ���ѹ��·������ŵ�ſ�£�����Բʵ�⻬�����������е��Ե��β���";
  	fth = "��������ź�Ļ�����ɡ�";
  	mth = "��ֱ������ม���";
  	fuckid = 3;
  elseif ftype == 2 then
  	fst = "����Ŀ���������ѽ!";
  	snd = "���������";
  	trd = "���ͽ����£����¿��ӣ���˫�ȣ�����СѨ�������Σ�";
  	fth = "����ô���㿪���Ҿ͸�������";
  	mth = "����������Ҫ������";
  	fuckid = 4;
  elseif ftype == 3 then
  	fst = "�������������ע�����塣";
  	snd = "��֪��������Ǹ���";
  	trd = "���������£�¶�����������е��Ե��ز���������ڸ�����ǽ���ϣ������β���";
  	fth = "��ô����ˬ��ˬ���ҵĹ����аɣ�";
  	mth = "���Ѿ���ȫ�Ȳ����ˣ�";
  	fuckid = 2;
  elseif ftype == 4 then
  	fst = "�����Ƕ����Ž��Ѱ��ء�";
  	snd = "���������";
  	trd = "�����¿��ӣ�����˫�ۣ��͵�ſ�£�����Բʵ�⻬�����������е��Ե��β���";
  	fth = "��ƣ�����˰ɣ������";
  	mth = "ֱ��...ֱ����, ̫�Ը��ˡ�(ʹ�����������ø������";
  	fuckid = 1;
  elseif ftype == 5 then
  	fst = "����ʲô����";
  	snd = "�������������ˣ�";
  	trd = "�����˸������ʵĵط����£�¶��ѩ�׵Ĵ��ȣ����⿪����..��";
  	fth = "��Ϣ�ú�ô���Ҹղŵı��ֿ��Դ򼸷��ء�";
  	mth = "�װ��ģ����Ǻúò���һ�°ɡ�";
  	fuckid = 6;
  elseif ftype == 6 then
  	fst = "�źߣ�";
  	snd = "�ǲ�����������";
  	trd = "�������������ò��ã���Ѹ���ѹ��·��������欵����һ�����ţ�";
  	fth = "�������ǲ��Ǹо���������";
  	mth = "��������ƨ���䶯������";
  	fuckid = 5;
  elseif ftype == 7 then
  	fst = "��ѩ�����ָ��������Щ���·��ء�";
  	snd = "�벻�뿴�Ҵ�ŮӶ����";
  	trd = "��֪������Ӻ�����ң��ҵ����ˡ������¿��ӣ��ͽ�ſ��̨���ϣ��������Σ�";
  	fth = "������ǲ��Ǻ������";
  	mth = "�㴩��������㣬�����㣡����";
  	fuckid = 7;
  elseif ftype == 8 then
  	fst = "����ڣ����������º��ء�";
  	snd = "���ǲ��������ҵ�����ѽ��";
  	trd = "���������ɺã�һ�����Ҵ�����ܼ��ֺò��ã����ѹ��·������ĵ���Σ�����������չ����ǰ)";
  	fth = "�ǲ�����ˬ���������أ�";
  	mth = "����ν���ɶ����ʡ�����������С����";
  	fuckid = 8;
  elseif ftype == 9 then
  	fst = "����������������ʵ�ġ�";
  	snd = "������ǲ����뻻һ��������";
  	trd = "ǰЩ����һ����ѡ�ľ�װ������ɣ��⿪���£����¿��ӣ��Ըж�������";
  	fth = "�о�������ɣ�";
  	mth = "��������ջ��ܲ����ˣ���ֱ�ӽ����������٣�";
  	fuckid = 9;
  elseif ftype == 10 then
  	fst = "����������Ҫʲô��ʲô��";
  	snd = "�崿��ѧ������һ��ϲ����";
  	trd = "ѧ��װ�Ӻ�˿����ɣ������¿��ӣ��ͽ�ſ�ڽϰ���̨���ϣ�";
  	fth = "����ǿ��ѽ�����һ�������Ӵ��������΢��Ц��";
  	mth = "��Ȼ֪�İ����������Ǿ�������ǿ���崿����ǹ��Ҳ��";
  	fuckid = 10;
  elseif ftype == 11 then
  	fst = "��ҵļ��ն��н�չ���ء�";
  	snd = "��֪��������ɻ�������";
  	trd = "��˵��һ���ǽ���Ʒ������ѹ��·����Ʒ��������䣩";
  	fth = "�������е���΢�����أ�������Ҷ�ϰ�������Ǻǡ�";
  	mth = "���ʲô����Ʒ��ˣ�������������ֱ�����⡣";
  	fuckid = 11;
  end

  local r = JYMsgBox("����ʲô", fst,  {"����", "�뿪"}, 2, picid)
  
  --ooxx �����߼�
  if r == 1 then
  	say(snd, picid, 0, name)
  	say(trd, picid, 0, name)
  	--AlungkyShowPic(1)
  	AlungkySaywithPic(mth, 0, 1, myName, fuckid)
  	AlungkySaywithPic("��..��..��������棡", picid, 0, name, fuckid .. "-1")

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
  		AlungkySaywithPic("�������������ˣ�ȫ����������ҵ�����..", picid, 0, name, fuckid .. "-3")
  	else
  		AlungkySaywithPic("�������������ˣ�ȫ����������ҵ�����..", picid, 0, name, fuckid .. "-2")
  	end
  	lib.Delay(500)
  	instruct_14()
    instruct_12()
    instruct_13()
    say(fth, picid, 0, name)
    local subName = Alungky_getSubName(name);
    say("�Һ����㣬" .. subName .. "�����װ���С����������������������Զ��飬��ã�", 0, 1, myName)
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
        	AlungkySaywithPNG("���š����š����˵����������СѨ����",headid,0,name);
        end 
  		if fckSpeed < 10 then
  			AlungkySaywithPic("���ˣ����ˣ������г���", 0, 1, myName, "PK"..texID.."/"..tmpname);
  			instruct_14()
  			instruct_13()
  			AlungkySaywithPic("������ˬ����ˬ��", 0, 1, myName, "PK"..texID.."/"..tmpname);
  			AlungkySaywithPNG("�Һ��ҵ������ں��ˣ���Ҫ�������˵ı����ˣ�",headid,0,name);
  			instruct_14()
  			instruct_13()
  			break;
  		elseif fckSpeed < 20 then
  			AlungkySaywithPNG("���������棡�����һ��У��Һð��㣬���ˡ�",headid,0,name);
  			fckSpeed = fckSpeed - 10;
  		end
	end
end

function Alungky_human_act(actid,headid, name, specstr)
	AlungkySaywithPNG("���ҵ����ˣ������һ��С������Ұ���������",headid,0,name);
	say("�������˾�����ô������������ϲ��������", 0, 1, myName);
	AlungkySaywithPNG(specstr,headid,0,name);
	say("�������ҵ�С���ˡ�����ֱ���������䣡", 0, 1, myName);
	AlungkySaywithPNG("�����������⡫",headid,0,name);
	Alungky_humanfk(actid,headid,name);
end

--��ǿ�洫�͵�ַ�˵�
function My_ChuangSong_Ex()     
	local title = "����ͨ���͹���";
	local str = "����һ���ܷ����������ϵͳ";
	local btn = {"�б�ѡ��", "�������","����"};
	local num = #btn;
	local aviSceneNum = 107;
	local r = JYMsgBox(title,str,btn,num,232,1);
	if r == 1 then
		return My_ChuangSong_List();
	elseif r == 2 then
		Cls();
		local sid = InputNum("�����볡������",0,aviSceneNum,1);
		if sid ~= nil then	
			
			if JY.Scene[sid]["��������"] == 0 and sid ~= 84 and sid ~= 83  and sid ~= 82 and  sid ~= 13 then
				My_Enter_SubScene(sid,-1,-1,-1);
			else
				say("��Ŀǰ���ڲ��ܽ���˳���", 232, 1, "����ͨ");
				return 1;
			end

		end
	end
end

--��ս����
function Fight()
	say("����ɲ�����ô���ǵģ���ɵ�С����", 232, 1, "����ͨ");
	SetS(86, 1, 9, 5, 1);
	
	for i=1, 10 do
		if GetS(86, 2, i, 5) == 0 then
			SetS(86, 2, i, 5, 2);
		end
	end
	
	local menu = {
		{"��������Ƿ�",nil,GetS(86, 2, 1, 5)-1},
		{"������Ͷ�������",nil,GetS(86, 2, 2, 5)-1},
		{"�������ɨ����ɮ",nil,GetS(86, 2, 3, 5)-1},
		{"�Ƿ�Ͷ�������",nil,GetS(86, 2, 4, 5)-1},
		{"�Ƿ��ɨ����ɮ",nil,GetS(86, 2, 5, 5)-1},
		{"�������ܺ�ɨ����ɮ",nil,GetS(86, 2, 6, 5)-1},
		{"�����ᡢ�������ܺ�ɨ����ɮ",nil,GetS(86, 2, 7, 5)-1},
		{"�����ᡢ�Ƿ��ɨ����ɮ",nil,GetS(86, 2, 8, 5)-1},
		{"�����ᡢ�Ƿ�Ͷ�������",nil,GetS(86, 2, 9, 5)-1},
		{"�Ƿ塢�������ܺ�ɨ����ɮ",nil,GetS(86, 2, 10, 5)-1},
	};
	
	local size = CC.DefaultFont;
	
	local x1 = (CC.ScreenW-13*size)/2 ;
	local y1 = (CC.ScreenH - #menu*(size + CC.RowPixel))/2 - size;
	DrawStrBox(x1, y1, "��ѡ����ս����",C_WHITE, size);
	
	local numItem =  #menu;
	
	local r = ShowMenu(menu,numItem,0,x1,y1+2*size,0,0,1,1,size,C_ORANGE,C_WHITE);
	if r > 0 then
		Cls();
		SetS(86, 2, r, 5, 3);
		if WarMain(226) then
			SetS(86, 2, r, 5, 1);
			say("���������ְ���", 232, 1, "����ͨ");
			QZXS("ȫ�����ʵս������ʮ��");
			for i=1, 6 do
				for j=1, #TeamP do
					if JY.Base["����"..i] == TeamP[j] then
						SetS(5, j, 6, 5, GetS(5, j, 6, 5)+30);
						break;
					end
				end
			end
			QZXS("������ѧ��ʶ���10��");
			AddPersonAttrib(0, "��ѧ��ʶ", 10);
		else
			SetS(86, 2, r, 5, 2);
			say("�ܿ�ϧ��������������������", 232, 1, "����ͨ");	
		end
	end
	
	SetS(86, 1, 9, 5, 0);
end

--��������
function LianGong()
	JY.Person[445]["�ȼ�"] = 30 * 100
  JY.Person[446]["�ȼ�"] = JY.Person[445]["�ȼ�"]
  JY.Person[445]["ͷ�����"] = math.random(190)
  JY.Person[446]["ͷ�����"] = math.random(190)
  JY.Person[445]["�������ֵ"] = 10
  JY.Person[446]["�������ֵ"] = 10
  JY.Person[445]["����"] = JY.Person[445]["�������ֵ"]
  JY.Person[446]["����"] = JY.Person[446]["�������ֵ"]
  instruct_6(226, 8, 0, 1)
  JY.Person[445]["�ȼ�"] = 10
  JY.Person[446]["�ȼ�"] = 10
  JY.Person[445]["ͷ�����"] = 208
  JY.Person[446]["ͷ�����"] = 208
	return 1;
end

--װ��˵��
function ZBInstruce()
	local flag = false
	Cls();
	repeat
		local x1 = CC.ScreenW/4 ;
		local y1 = CC.ScreenH/4;
		DrawStrBox(x1, y1, "��ѡ����Ҫ�鿴��װ��",C_WHITE, CC.DefaultFont);
		local menu = {
			{"���佣",nil,1},
			{"����",nil,1},
			{"������",nil,1},
			{"���콣",nil,1},
			{"������",nil,1},
			{"���o��",nil,1}
		};
		
		local numItem = #menu;
		local size = CC.DefaultFont;
		local r = ShowMenu(menu,numItem,0,x1+size*3,y1+size*2,0,0,1,1,size,C_ORANGE,C_WHITE);
		if r == 0 then
			flag = true;
		elseif r == 1 then
			say("���佣��ʹ��̫������������", 232, 1, "����ͨ");
		elseif r == 2 then
			say("�������������㼯���ٶ�", 232, 1, "����ͨ");	
		elseif r == 3 then
			say("��������������������ر������������������߱�����", 232, 1, "����ͨ");	
		elseif r == 4 then
			say("���콣����������Ѫ������һ�����ʷ�Ѩ", 232, 1, "����ͨ");	
		elseif r == 5 then
			say("��������ʹ�õȼ�Ϊ���ĵ�����߰ٷ�֮��ʮ�����ʣ�������������аٷ�֮��ʮ���ʴ����ɱ���������������Ѫ��ɱ���������书�����й�", 232, 1, "����ͨ");	
		elseif r == 6 then
			say("���o�ף��ܵ�ȭϵ�书����ʱ����һ�����˺����ܵ���ȭϵ�书����ʱ�����˺�", 232, 1, "����ͨ");	
		end
	until flag
end

--brolycjw: ������ս
function DYRW()
	Cls();
	local x1 = CC.ScreenW/4 ;
	local y1 = CC.ScreenH/4;
	DrawStrBox(x1, y1, "��ѡ����ս����",C_WHITE, CC.DefaultFont);
	local menu = {}
	local id,tid = 0;
		for i = 1, CC.TeamNum do
			menu[i] = {"", nil, 0}
			id = JY.Base["����" .. i]		
				if id > 0 then
				menu[i][3] = 1
				menu[i][1] = JY.Person[id]["����"]
			end
		end
	local numItem = #menu;
	local size = CC.DefaultFont;
	local r = ShowMenu(menu,numItem,0,x1,y1+CC.DefaultFont,0,0,1,1,size,C_ORANGE,C_WHITE);
	if r > 0 then
		id = JY.Base["����" .. r]
		SetS(86,15,1,5,id)
		for t=1, CC.MyTeamNum do
			if id == TeamP[t] then
				tid = t
				break;
			end
		end
		Cls();
		DrawStrBox(x1, y1, "��ѡ����ս�Ѷ�",C_WHITE, CC.DefaultFont);
		menu = {
			{"����",nil,GetS(86,16,tid,5)-1},
			{"�м�",nil,GetS(86,17,tid,5)-1},
			{"�߼�",nil,GetS(86,18,tid,5)-1},
			{"��",nil,GetS(86,19,tid,5)-1},
		};
		numItem = #menu;
		local rr = ShowMenu(menu,numItem,0,x1,y1+40,0,0,1,1,size,C_ORANGE,C_WHITE);
		if rr > 0 then
			SetS(86,15,2,5,rr)
			if WarMain(79) then
				SetS(86, 15+rr, tid, 5, 1);
				SetS(86, 16+rr, tid, 5, 2);
				say("���Ǻ����ְ���", 232, 1, "����ͨ");
				QZXS(string.format("%s ʵս����%s��",JY.Person[id]["����"],rr*50));
				QZXS(string.format("%s ����������%s��",JY.Person[id]["����"],rr*5));
				SetS(5, tid, 6, 5, GetS(5, tid, 6, 5)+rr*50);
				AddPersonAttrib(id, "������", rr*5);
				AddPersonAttrib(id, "������", rr*5);
				AddPersonAttrib(id, "�Ṧ", rr*5);
			else
				SetS(86, 15+rr, tid, 5, 2);
				say("�ܿ�ϧ��������������������", 232, 1, "����ͨ");	
			end
		end	
	end
	SetS(86,15,1,5,0)
	SetS(86,15,2,5,0)
end

--�书��Ч˵��
function WuGongIntruce()
	local menu = {};
	
	for i = 1, JY.WugongNum-1 do
		menu[i] = {i..JY.Wugong[i]["����"], nil, 0}
	end
	
	--ӵ�е��ؼ�
	for i = 1, CC.MyThingNum do
    if JY.Base["��Ʒ" .. i] > -1 and JY.Base["��Ʒ����" .. i] > 0 then
    	local wg = JY.Thing[JY.Base["��Ʒ" .. i]]["�����书"];
    	if wg > 0 then
    		menu[wg][3] = 1;
    	end
    else
    	break;
    end
  end
  
  --ѧ����书
  for i=1, CC.TeamNum do
  	if JY.Base["����"..i] >= 0 then
  		for j=1, 10 do
  			if JY.Person[JY.Base["����"..i]]["�书"..j] > 0 then
  				menu[JY.Person[JY.Base["����"..i]]["�书"..j]][3] = 1;
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
		
		r = ShowMenu2(menu,JY.WugongNum-1,4,12,10,(CC.ScreenH-12*(CC.DefaultFont+CC.RowPixel))/2+20,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE, "��ѡ��鿴���书", r);
		--local r = ShowMenu(menu,n,15,CC.ScreenW/4,20,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE);
		
		if r > 0 and r < JY.WugongNum then	
			InstruceWuGong(r);
		else
			break;
		end
	end
	
end

--��ʾ�书���ڹ���Ч
function InstruceWuGong(id)
	
	if id < 0 or id >= JY.WugongNum then
		QZXS("�书δ֪�����޷��鿴");
		return;
	end
	
	local filename = string.format("%s%d.txt", CONFIG.WuGongPath,id)
	if existFile(filename) == false then
		QZXS("���书δ�����κ�˵������������ĥ");
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

--��ʾ�书���ڹ���Ч
function InstruceTS(id)
		
	local filename = string.format("%s%d.txt", CONFIG.HelpPath,id)
	if existFile(filename) == false then
		QZXS("δ�ҵ���صĹ����ļ�");
		return;
	end
	
	DrawTxt(filename);
	
end

function DrawTxt(filename)
	Cls();
	
	--��ȡ�ļ�˵��
	local file = io.open(filename,"r")
	local str = file:read("*a")
	file:close()
	
	local size = CC.DefaultFont;
	local color = C_WHITE;
	
	local linenum = 50;		--��ʾ����
	local maxlen = 14;
	local w = linenum*size/2 + size;
	local h = maxlen*(size+CC.RowPixel) + 2*CC.RowPixel;
	
	local bx = (CC.ScreenW-w)/2;
	local by = (CC.ScreenH-h)/2;
	DrawBox(bx,by,bx+w,by+h,C_WHITE);		--�ױ߿�
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
			
			if l+#v[1] < linenum and index == nil then		--���δ�����У�û���ҵ�����
				DrawString(x + l*size/2, y + row*(size+CC.RowPixel), v[1], v[2] or color, size);
				l = l + #v[1]

				if i == #strcolor then
					--��ʾ����	ALungky:j �ĳ� j+1�����ĩβ������ʱ���޷���ʾ�����⡣
					for j=0, l do
						lib.SetClip(x,y,x+(j+1)*size/2,y+size+row*(size+CC.RowPixel));
						ShowScreen(1);
					end
					lib.SetClip(0,0,0,0);
				end
				break;
			else	--����ﵽ����
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
				
				--��������ж��Ƿ��Ѿ�����v[1]��������ݲ���
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
					
	
					if math.fmod(flag,2) == 1 and index == nil  then		--��������е��ַ�
							if string.byte(tmp, -1) > 127 then
								tmp = string.sub(v[1], 1, pos1-1);
								pos2 = pos2 - 1
							end
					end
	
					v[1] = string.sub(v[1], pos2);
				end
					
	
					DrawString(x + l*size/2, y + row*(size+CC.RowPixel), tmp, v[2] or color, size);
	
	
					l = l + #tmp
					--��ʾ����
					for j=0, l do
						lib.SetClip(x,y,x+j*size/2,y+size+row*(size+CC.RowPixel));
						ShowScreen(1);
					end
					
					--����+1
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

--ʮ�ı�����֮��õ�5000��
--�޸��Զ�ϴ���񼼵�BUG
function NEvent2(keypress)
  if JY.SubScene == 70 and GetD(70, 3, 0) == 0 and instruct_18(151) then
    instruct_3(70, 3, 1, 0, 0, 0, 0, 2610, 2610, 2610, 0, -2, -2)
  end
  if GetD(70, 3, 5) == 2610 and JY.SubScene == 70 and JY.Base["��X1"] == 8 and JY.Base["��Y1"] == 41 and JY.Base["�˷���"] == 2 and keypress == VK_SPACE then
    say("���ף�����ֽ��......�ȣ�С�ӣ��������������ǧ�����ӣ��ú�׼��һ�°ɣ��ȹ������ϼһﻹ�ܹ���˼�")
    instruct_2(174, 5000)
    SetS(10, 0, 17, 0, 1)
    SetD(83, 48, 4, 882)
    
    instruct_3(70, 3, 1, 0, 0, 0, 0, 2612, 2612, 2612, 0, -2, -2)
  end
end

--��� ���˷����ҽ���
function NEvent3(keypress)
  if JY.SubScene == 24 and JY.Base["��X1"] == 18 and JY.Base["��Y1"] == 23 and JY.Base["�˷���"] == 2 and (keypress == VK_SPACE or keypress == VK_RETURN) and GetS(10, 0, 3, 0) ~= 1 and instruct_16(1) and instruct_18(145) and JY.Person[1]["�书�ȼ�1"] == 999 then
    say("������������Ѿ��ҵ�ѩɽ�ɺ��Ȿ����", 1)
    say("���ţ��ܺã�������ĺ��ҵ���Ҳ������¯�����ˣ��Ժ�Ľ����Ϳ�������Щ�����˵��ˣ��Ȿ��ҽ�������ȥ�ɣ�", 3)
    say("����л�������", 1)
    for i = 1, 10 do
      if JY.Person[1]["�书" .. i] == 0 then
        JY.Person[1]["�书" .. i] = 44
        JY.Person[1]["�书�ȼ�" .. i] = 50
        DrawStrBox(-1, -1, "���ѧ����ҽ���", C_ORANGE, CC.DefaultFont)
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

--�����12�������
function NEvent4(keypress)
  if JY.SubScene == 7 and JY.Base["��X1"] == 34 and JY.Base["��Y1"] == 11 and JY.Base["�˷���"] == 2 then
    local ts = 0
    for i = 1, 200 do
      if JY.Base["��Ʒ" .. i] > 143 and JY.Base["��Ʒ" .. i] < 158 then
        ts = ts + 1
      end
    end
 
	  if ts > 11 and instruct_16(35) and instruct_18(114) and GetS(10, 1, 1, 0) ~= 1 and JY.Person[35]["�书�ȼ�1"] == 999 and keypress == VK_SPACE then
	    SetS(7, 34, 12, 3, 102)
	    instruct_3(7, 102, 1, 0, 0, 0, 0, 7148, 7148, 7148, 0, 34, 12)
	    say("�����֣����������ʶһ�¶���ǰ���ķ�ɰ�������ܸо����ԾŽ������µ����򣬵��ֺ�ģ�������ܾ����ܽ������", 35, 1)
	    say("������������������ʱ���ˣ�", 140, 0)
	    say("����̫ʦ�壡����", 35)
	    instruct_14()
	    SetS(7, 33, 12, 3, 101)
	    instruct_3(7, 101, 1, 0, 0, 0, 0, 5896, 5896, 5896, 0, 33, 12)
	    instruct_13()
	    PlayMIDI(24)
	    lib.Delay(2000)
	    say("�����������һ�𳪣��׺�һ��Ц����������������������ֻ�ǽ񳯡�����Ц���׷����ϳ���˭��˭ʤ����֪������ɽЦ������ң�������Ծ��쳾����֪���١����Ц���Ǽ��ȡ����黹ʣһ�����ա�����Ц�����ټ��ȡ��������ڳճ�ЦЦ", 140, 0)
	    say("��������Ž��ļ�������������׸��У����Ѻú�ȥ���ɣ��Ϸ���Ը���ˣ��Ӵ�����ǣ�ң��ʹ�ȥҲ��������������", 140, 0)
	    say("����л̫ʦ�崫���������˼Ҷౣ�أ��ţ������������Ž��İ���ɣ�������", 35, 1)
	    instruct_14()
	    instruct_3(7, 101, 0, 0, 0, 0, 0, -1, -1, -1, 0, 33, 12)
	    instruct_13()
	    DrawStrBox(-1, -1, "���պ�", C_ORANGE, CC.DefaultFont)
	    ShowScreen()
	    lib.Delay(1000)
	    say("�����ˣ�����������Ķ��¾Ž���������������ѧ������ǰ��֮�񼼣��򸴺κ���", 35, 1)
	    DrawStrBox(-1, -1, "���������Ž�֮�ش�", C_ORANGE, CC.DefaultFont)
	    ShowScreen()
	    lib.Delay(2000)
	    Cls()
	    DrawStrBox(-1, -1, "�����ƺű��", C_ORANGE, CC.DefaultFont)
	    ShowScreen()
	    lib.Delay(1000)
	    Cls()
	    SetS(10, 1, 1, 0, 1)
	    instruct_3(7, 102, 0, 0, 0, 0, 0, -1, -1, -1, 0, 34, 12)
	  end
  end
end
--����а�ߣ�����������ͷ
function NEvent5(keypress)
  if JY.SubScene == 28 and JY.Base["��X1"] == 15 and JY.Base["��Y1"] == 28 and JY.Base["�˷���"] == 2 and GetD(11, 109, 0) ~= 1  and instruct_18(219) and (keypress == VK_SPACE or keypress == VK_RETURN) then
    say("��������ͷ��")
    say("�������飡", 70)
    instruct_2(155, 1)
    instruct_32(219, -1)
    
  end
end--ɽ���¼�
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
--��ɽ����
function NEvent7(keypress)
  
end
--��ս�����ᣬ�õ�����
function NEvent8(keypress)
  if JY.SubScene == 43 and GetS(53, 0, 2, 5) == 1 and GetS(53, 0, 4, 5) == 1 and GetS(53, 0, 5, 5) ~= 1 and JY.Base["��X1"] == 17 and JY.Base["��Y1"] == 27 and JY.Base["�˷���"] == 2 and (keypress == VK_SPACE or keypress == VK_RETURN) then
    say("������������", 5)
    say("�ݼ�������")
    say("������ܼ򵥣������и����ᣬֻҪ���ܴ���ң���ô���������", 5)
    say("���ң�......��˵����С�ӵ��Ǹ��ռ����кܶ��˾����Ϸ������Ҳ�գ��Ǿ�������ɣ���", 5)
    if DrawStrBoxYesNo(-1, -1,"Ҫ��ս��", C_WHITE, CC.DefaultFont) then
      if WarMain(22) then
        PlayMIDI(3)
        say( "���ù����������������ľ��ᣬ��ȥ�ɣ�", 5)
        say("< ���������ڵ����ˣ��治���װ������ϵ������ȷ�˵ã���������������---- >")
        say("����ԭ��������~~~~�Ҷ��ˣ�ԭ���ҵĸо�һֱ��û��")
        DrawStrBoxWaitKey(string.format("%s����������ѧ���������������", JY.Person[0]["����"]), C_ORANGE, CC.DefaultFont)
 				SetS(53, 0, 5, 5,1)
        SetS(80, 48, 36, 3, 100)
        instruct_3(80, 100, 0, 0, 0, 0, 2002, 0, 0, 0, 0, -2, -2)
        say("�����ˣ����Ѿ������ˣ�����ȥ������ʹ���ɣ�", 5)
        
      else
      	say("����ȱ�����´������ɣ�", 5)
      end
    else
    	say("����ʱ�����������Ϸ򹧺�", 5)
    end
  end
end
--�����ᣬֱ����սʮ���
function NEvent9(keypress)
  if JY.SubScene == 25 and GetS(10, 0, 8, 0) ~= 1 and GetD(25, 74, 5) == 2610 then
    SetS(25, 40, 33, 3, 101)
    instruct_3(25, 101, 1, 0, 0, 0, 0, 6824, 6824, 6824, 0, -2, -2)
  end
  if JY.Base["��X1"] == 41 and JY.Base["��Y1"] == 33 and JY.Base["�˷���"] == 2 and (keypress == VK_SPACE or keypress == VK_RETURN) then
    say("���Ƿ���ֱ����սʮ�����֣�", 300, 0, "��������")
    if DrawStrBoxYesNo(-1, -1, "Ҫֱ����ս��", C_ORANGE, CC.DefaultFont) then
      if JY.Person[0]["Ʒ��"] > 50 then
        if WarMain(133) then
          say("����ϲ��սʤ��ʮ�����ô��������", 300, 0, "��������")
          instruct_14()
          JY.Base["��X1"] = 11
          JY.Base["��Y1"] = 44
          instruct_13()
          SetS(10, 0, 8, 0, 1)
          instruct_3(25, 72, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2)
          instruct_3(25, 101, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2)
        end
	    else
	      if WarMain(134) then
	        say("����ϲ��սʤ��ʮ�����ô��������", 300, 0, "��������")
	        instruct_14()
	        JY.Base["��X1"] = 11
	        JY.Base["��Y1"] = 44
	        instruct_13()
	        SetS(10, 0, 8, 0, 1)
	        instruct_3(25, 72, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2)
	        instruct_3(25, 101, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2)
	      end
    	end
  	else
    	say("���Ǿ�������̨�ɣ�", 300, 0, "��������")
    end
  end
end
--�������SYP�Զ�����
function NEvent10(keypress)
  if JY.SubScene == 25 and GetS(10, 0, 9, 0) ~= 1 then
    SetS(25, 9, 44, 3, 103)
    instruct_3(25, 103, 1, 0, 0, 0, 0, 9244, 9244, 9244, 0, -2, -2)
    if JY.Base["��X1"] == 10 and JY.Base["��Y1"] == 44 and JY.Base["�˷���"] == 2 and (keypress == VK_SPACE or keypress == VK_RETURN) and GetD(25, 82, 5) == 4662 then
      say("��һ·����������������ˣ�������������", 0, 0, "���Ĵ���")
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
      say("�����Ѿ��ź��ˣ���������ų�ȥ��", 0, 0, "���Ĵ���")
      SetS(10, 0, 9, 0, 1)
      instruct_3(25, 103, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2)
      
    end
  end
end
--���㵺 ����
function NEvent11(keypress)
  if JY.SubScene == 104 and JY.Person[104]["����"] ~= "���� " then
    instruct_3(104, 91, 1, 0, 0, 0, 0, 6086, 6086, 6086, 0, -2, -2)
  end
  if JY.SubScene == 104 and JY.Base["��X1"] == 42 and JY.Base["��Y1"] == 38 and JY.Base["�˷���"] == 0 and (keypress == VK_SPACE or keypress == VK_RETURN) and GetD(104, 91, 0) == 1 then
    say("���ɹ��ʵ�Ү�ɺ������������ԭ��������ھ����뷨Ȱ�裬�����޷��������������������ҽ�����Ķ���", 104)
    instruct_2(8, 10)
    say("����Ҫ��ȥ����������ˣ��ټ���", 104)
    instruct_3(104, 91, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2)
    JY.Person[104]["����"] = "���� "
  end
end
--�󹦷� ��Ԭ��־�Ի��󣬽��߽��黹
function NEvent12(keypress)
  if JY.SubScene == 95 and GetD(95, 4, 5) ~= 0 and JY.Thing[40]["ʹ����"] ~= -1 then
    JY.Person[JY.Thing[40]["ʹ����"]]["����"] = -1
    JY.Thing[40]["ʹ����"] = -1
    JY.Thing[40]["���Ṧ"] = 10
    JY.Thing[40]["�ӹ�����"] = 20
  end
end

function mm4R()
  local r = nil
  if JY.Thing[202][WZ7] == 1 then
    r = math.random(2)
  else
    r = math.random(4)
  end
  local bdnl = {"����", "ͷ�����", "�������ֵ", "�������ֵ", "��������", "������", "�Ṧ", "������", "ȭ�ƹ���", "��������", "ˣ������", "�������", "����", "�书1"}
  local mm4 = {}
  mm4[1] = {"������", 301, 350, 600, 0, 60, 50, 50, 30, 30, 0, 0, 80+Rnd(5), 41}
  mm4[2] = {"����", 302, 270, 500, 1, 70, 40, 50, 0, 40, 0, 0, 80+Rnd(5), 37}
  mm4[3] = {"����", 303, 200, 500, 2, 40, 40, 40, 20, 20, 20, 20, 80+Rnd(5), 12}
  mm4[4] = {"½��˫", 304, 400, 700, 0, 70, 40, 60, 0, 0, 40, 0, 40+Rnd(5), 54}
  for i = 1, 14 do
    JY.Person[92][bdnl[i]] = mm4[r][i]
  end
  JY.Person[92]["�ȼ�"] = 5
  for i = 1, 5 do
    JY.Person[92]["���ж���֡��" .. i] = 0
    JY.Person[92]["���ж����ӳ�" .. i] = 0
    JY.Person[92]["�书��Ч�ӳ�" .. i] = 0
  end
  local avi = {
{14, 6, 7}, 
{8, 3, 4}, 
{0, 0, 0}, 
{7, 4, 5}}
  JY.Person[92]["���ж���֡��1"] = avi[r][1]
  JY.Person[92]["���ж����ӳ�1"] = avi[r][3]
  JY.Person[92]["�书��Ч�ӳ�1"] = avi[r][2]
  if r == 3 then
    local s = {
{0, 0, 0}, 
{9, 2, 3}, 
{8, 3, 4}, 
{8, 3, 4}, 
{9, 5, 6}}
    for i = 1, 5 do
      JY.Person[92]["���ж���֡��" .. i] = s[i][1]
      JY.Person[92]["���ж����ӳ�" .. i] = s[i][3]
      JY.Person[92]["�书��Ч�ӳ�" .. i] = s[i][2]
    end
  end
end