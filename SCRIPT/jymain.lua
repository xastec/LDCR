
----------------------------------------------------------
-----------��ӹȺ��������֮Lua��----------------------------

--��Ȩ���ޣ����븴��
--����������ʹ�ô���

---����������Ӿ�����д

--��ģ����lua��ģ�飬��C������JYLua.exe���á�C������Ҫ�ṩ��Ϸ��Ҫ����Ƶ�����֡����̵�API��������lua���á�
--��Ϸ�������߼�����lua�����У��Է����ҶԴ�����޸ġ�
--Ϊ�ӿ��ٶȣ���ʾ����ͼ/������ͼ/ս����ͼ������C APIʵ�֡�

--��������ģ�顣֮�������ɺ�����Ϊ�˱��������ʱ��������Ѱ����Щģ�顣
function IncludeFile()              --��������ģ��
	--package.path = "./?.lua;";
	--require("config");
	package.path=CONFIG.ScriptLuaPath;  ---���ü���·��
	require("jyconst");
	require("readkdef");
	require("jywar");
	
end

--Alungky �޸�������Ʒ���ֲ���ȷ������
function Alungky_textFix_invokePerInstance()
  --����������ԡ�����̩̹
  JY.Thing[88]["����"]="����ɽ����"
  JY.Thing[88]["����2"]="����ɽ����"
  JY.Thing[89]["����"]="����ȭ��"
  JY.Thing[89]["����2"]="����ȭ��"
  JY.Thing[110]["����2"]="�嶾�ش�"
  JY.Thing[178]["����"]="���������"
  JY.Thing[181]["����2"]="������ʽ"
  JY.Thing[196]["��Ʒ˵��"]="���ഫ������"
  JY.Thing[197]["��Ʒ˵��"]="����ʵ���Ϯͼ��"
  JY.Thing[212]["����2"]="����ɢ����"
end

function SetGlobal()   --������Ϸ�ڲ�ʹ�õ�ȫ�̱���
   JY={};

   JY.Status=GAME_INIT;  --��Ϸ��ǰ״̬

   --����R������
   JY.Base={};           --��������
   JY.PersonNum=0;      --�������
   JY.Person={};        --��������
   JY.ThingNum=0        --��Ʒ����
   JY.Thing={};         --��Ʒ����
   JY.SceneNum=0        --��Ʒ����
   JY.Scene={};         --��Ʒ����
   JY.WugongNum=0        --��Ʒ����
   JY.Wugong={};         --��Ʒ����
   JY.ShopNum=0        --�̵�����
   JY.Shop={};         --�̵�����
   
   
   JY.Skill = {}		--��������
   JY.SkillNum = 0;
   JY.Data_Skill=nill;

   JY.Data_Base=nil;     --ʵ�ʱ���R*����
   JY.Data_Person=nil;
   JY.Data_Thing=nil;
   JY.Data_Scene=nil;
   JY.Data_Wugong=nil;
   JY.Data_Shop=nil;

   JY.MyCurrentPic = 0  --���ǵ�ǰ��·��ͼ����ͼ�ļ���ƫ��
  JY.MyPic = 0     --���ǵ�ǰ��ͼ
  JY.Mytick = 0    --����û����·�ĳ���֡��
  JY.MyTick2 = 0   --��ʾ�¼������Ľ���
  JY.CDD = 0
  JY.LOADTIME = 0
  JY.SAVETIME = 0
  JY.GTIME = 0
  JY.JB = 1
  JY.GOLD = 0
  JY.WGLVXS = 0
  JY.MY = 0
  JY.SID = nil
  JY.LID = nil
  JY.XZSPD = 1
  JY.MV = 0
  JY.MAPKJ = 0
  JY.HEADXZ = 1
  JY.LEQ = CC.T1[1] .. CC.T1[4] .. CC.T1[6]
  JY.SQ = CC.T1[7] .. CC.T1[2] .. CC.T1[5] .. CC.T1[3]
  JY.XYK = CC.T1[10] .. CC.T1[8] .. CC.T1[9]
  JY.TF = 0

   JY.SubScene=-1;          --��ǰ�ӳ������
   JY.SubSceneX=0;          --�ӳ�����ʾλ��ƫ�ƣ������ƶ�ָ��ʹ��
   JY.SubSceneY=0;

   JY.Darkness=0;             --=0 ��Ļ������ʾ��=1 ����ʾ����Ļȫ��

   JY.CurrentD=-1;          --��ǰ����D*�ı��
   JY.OldDPass=-1;          --�ϴδ���·���¼���D*���, �����δ���
   JY.CurrentEventType=-1   --��ǰ�����¼��ķ�ʽ 1 �ո� 2 ��Ʒ 3 ·��

   JY.CurrentThing=-1;      --��ǰѡ����Ʒ�������¼�ʹ��

   JY.MmapMusic=-1;         --�л����ͼ���֣���������ͼʱ��������ã��򲥷Ŵ�����

   JY.CurrentMIDI=-1;       --��ǰ���ŵ�����id�������ڹر�����ʱ��������id��
   JY.EnableMusic=1;        --�Ƿ񲥷����� 1 ���ţ�0 ������
   JY.EnableSound=1;        --�Ƿ񲥷���Ч 1 ���ţ�0 ������

   JY.ThingUseFunction={};          --��Ʒʹ��ʱ���ú�����SetModify����ʹ�ã����������͵���Ʒ
   JY.SceneNewEventFunction={};     --���ó����¼�������SetModify����ʹ�ã�����ʹ���³����¼������ĺ���


   WAR={};     --ս��ʹ�õ�ȫ�̱�����������ռ��λ�ã���Ϊ������治������ȫ�ֱ����ˡ�����������WarSetGlobal������

		AutoMoveTab = {[0] = 0}
end


function JY_Main()        --���������
	os.remove("debug.txt");        --�����ǰ��debug���
    xpcall(JY_Main_sub,myErrFun);     --������ô���
end

function myErrFun(err)      --��������ӡ������Ϣ
    lib.Debug(err);                 --���������Ϣ
    lib.Debug(debug.traceback());   --������ö�ջ��Ϣ
end

function JY_Main_sub()        --��������Ϸ���������


    IncludeFile();         --��������ģ��
    SetGlobalConst();    --����ȫ�̱���CC, ����ʹ�õĳ���
    SetGlobal();         --����ȫ�̱���JY

    GenTalkIdx()
    --SetModify();         --���öԺ������޸ģ������µ���Ʒ���¼��ȵ�

    --��ֹ����ȫ�̱���
    setmetatable(_G,{ __newindex =function (_,n)
                       error("attempt read write to undeclared variable " .. n,2);
                       end,
                       __index =function (_,n)
                       error("attempt read read to undeclared variable " .. n,2);
                       end,
                     }  );
					
	
    lib.Debug("JY_Main start.");
    

	math.randomseed(os.time());          --��ʼ�������������

	lib.EnableKeyRepeat(CONFIG.KeyRepeatDelay,CONFIG.KeyRePeatInterval);   --���ü����ظ���

    JY.Status=GAME_START;

    lib.PicInit(CC.PaletteFile);       --����ԭ����256ɫ��ɫ��

    --lib.PlayMPEG(CONFIG.DataPath .. "start.mpg",VK_ESCAPE);
	lib.FillColor(0,0,0,0,0);
	
	--lib.PicLoadFile(CC.HeadPicFile[1], CC.HeadPicFile[2], 1,limitX(CC.ScreenW/6,50,110))
	lib.LoadPNGPath(CC.HeadPath, 1, CC.HeadNum, CC.Scale * 100)
  PlayMIDI(16);
  Cls();
	lib.ShowSlow(50,0);
	
	
	
	local r = StartMenu();
	if r ~= nil then
		return;
	end

	lib.LoadPicture("",0,0);
    lib.GetKey();
    
    Game_Cycle();
end

function StartMenu()
	Cls();
	local menu={  {"���¿�ʼ",nil,1},
	              {"�������",nil,1},
	              {"�뿪��Ϸ",nil,1}  };
	local menux=(CC.ScreenW-4*CC.StartMenuFontSize-2*CC.MenuBorderPixel)/2

	local menuReturn=ShowMenu(menu,3,0,menux,CC.StartMenuY,0,0,0,0,CC.StartMenuFontSize,C_STARTMENU, C_RED)
	Cls();
    if menuReturn == 1 then        --���¿�ʼ��Ϸ
		NewGame();          --��������Ϸ����
        JY.SubScene = CC.NewGameSceneID
		JY.Base["��X1"] = CC.NewGameSceneX
		JY.Base["��Y1"] = CC.NewGameSceneY
		JY.MyPic = CC.NewPersonPic
		JY.Status = GAME_SMAP
		JY.MmapMusic = -1
		CleanMemory()
		Init_SMap(0)       
        

		if DrawStrBoxYesNo(-1, -1, "�Ƿ�ۿ���ʼ����", C_WHITE, CC.DefaultFont) == true then 
		  oldCallEvent(CC.NewGameEvent)
		else
		  CallCEvent(691)
		end
		
		
	elseif menuReturn == 2 then         --����ɵĽ���
			--[[
    	local loadMenu={ {"����һ",nil,1},
	                     {"���ȶ�",nil,1},
	                     {"������",nil,1} };

	    local menux=(CC.ScreenW-3*CC.StartMenuFontSize-2*CC.MenuBorderPixel)/2

    	local r=ShowMenu(loadMenu,3,0,menux,CC.StartMenuY,0,0,0,1,CC.StartMenuFontSize,C_STARTMENU, C_RED)
    	]]
    	
    	local r = SaveList();
    	--ESC ���·���ѡ��
    	if r < 1 then
    		local s = StartMenu();
    		return s;
    	end
    	
    	Cls();
			DrawStrBox(-1,CC.StartMenuY,"���Ժ�...",C_GOLD,CC.DefaultFont);
			ShowScreen();
    	local result = LoadRecord(r);
    	if result ~= nil then
    		return StartMenu();
    	end

		if JY.Base["����"] ~= -1 then
		  if JY.SubScene < 0 then
			CleanMemory()
			lib.UnloadMMap()
		  end
		  lib.PicInit()
		  lib.ShowSlow(50, 1)
		  JY.Status = GAME_SMAP
		  JY.SubScene = JY.Base["����"]
		  JY.MmapMusic = -1
		  JY.MyPic = GetMyPic()
		  Init_SMap(1)
		else
		  JY.SubScene = -1
		  JY.Status = GAME_FIRSTMMAP
		end

	elseif menuReturn == 3 then
        return -1;
	end
	
end

function CleanMemory()            --����lua�ڴ�
    if CONFIG.CleanMemory==1 then
		 collectgarbage("collect");
    end

end

function NewGame()     --ѡ������Ϸ���������ǳ�ʼ����

	Cls();
	DrawStrBox(-1,CC.StartMenuY,"���Ժ�...",C_GOLD,CC.DefaultFont);
	ShowScreen();
	LoadRecord(0); --  ��������Ϸ����
	
	JY.Status = GAME_NEWNAME;
	ClsN();
  
  
  local van = 1
  if CC.CircleNum > 4 then
  	local vanMode = {"��ͨ����","��������"}
  	van = JYMsgBox("��Ϸ����","��ϲ���Ѿ�ͨ���ĸ���Ŀ�Ķ���*���Ĵ��˷�˿���������*��ͬ����Ϸ�����Ѷȸ���",vanMode,#vanMode,5);
  	ClsN()
  end

  local mode = limitX(CC.CircleNum-(van-1)*4,1,#MODEXZ2);
  
  --ѡ���Ѷ�
  JY.Thing[202][WZ7] = JYMsgBox("�Ѷ�ѡ��", "��ѡ����Ϸ�Ѷȡ�*�Ѷ�Խ�ߵ���Խ�Ը�*��Ŀ��������ѡ����Ѷȷ�Χ*ÿ��ͨ��һ����Ŀ�����Զ������ۼ�", MODEXZ2, mode, 35)
	JY.Thing[202][WZ7] = JY.Thing[202][WZ7] + (van-1)*4;
	
	CC.PersonAttribMax["������"] = CC.PersonAttribMax["������"] + (JY.Thing[202][WZ7]-4)*100
  CC.PersonAttribMax["������"] = CC.PersonAttribMax["������"] + (JY.Thing[202][WZ7]-4)*100
  CC.PersonAttribMax["�Ṧ"] = CC.PersonAttribMax["�Ṧ"] + (JY.Thing[202][WZ7]-4)*100

	JY.Person[0]["����"]=CC.NewPersonName;
  
  JY.Person[0]["�������ֵ"] = 50
  JY.Person[0]["�������ֵ"] = 100
  JY.Person[0]["������"] = 30
  JY.Person[0]["������"] = 30
  JY.Person[0]["�Ṧ"] = 30
  JY.Person[0]["ҽ������"] = 30
  JY.Person[0]["�ö�����"] = 30
  JY.Person[0]["�ⶾ����"] = 30
  JY.Person[0]["��������"] = 30
  JY.Person[0]["ȭ�ƹ���"] = 30
  JY.Person[0]["��������"] = 30
  JY.Person[0]["ˣ������"] = 30
  JY.Person[0]["�������"] = 30
  JY.Person[0]["��������"] = 30
  ClsN()
  
  --ѡ����������
  local nl = JYMsgBox("��ѡ��", "��Ҫ�������Ե�����*��ͬ�������ʽ��в�ͬ�书·��*�������������", {"����", "����", "����"}, 3, 261)
  if nl == 1 then
    JY.Person[0]["��������"] = 0
  elseif nl == 2 then
    JY.Person[0]["��������"] = 1
  else
    JY.Person[0]["��������"] = 2
  end
  
  ClsN();
  JY.Person[0]["����"] = InputNum("����������",1,100);

	JY.Person[0]["����"] = JY.Person[0]["�������ֵ"]
	JY.Person[0]["����"] = JY.Person[0]["�������ֵ"]
	ClsN()
	ShowScreen()
	
	--�����ʼ���ݺ��¼�
	SetS(13, 18, 28, 3, 101)
	SetS(13, 18, 29, 3, 102)
	instruct_3(13, 101, 0, 0, 0, 0, 2001, 0, 0, 0, 0, -2, -2)
	instruct_3(13, 102, 0, 0, 0, 0, 2001, 0, 0, 0, 0, -2, -2)
	SetS(102, 20, 25, 2, 0)
	SetD(102, 13, 2, 0)
	SetS(102, 17, 22, 3, 101)
	instruct_3(102, 101, 1, 0, 1014, 0, 0, 7262, 7262, 7262, 0, -2, -2)
	for i = 5, 7 do
	  SetD(104, 88, i, 8738)
	end
	
	
	
	SetS(103,17,21,3,80);		--����ҩ�����¼����80     --������ͼ
	SetS(103,29,11,3,81);		--������ʾ����ķ�Ĺ
	SetS(103,29,12,3,82);
	
	SetS(63,20,27,3,80);		--�����������¼����80   �ݳ�����ͼ
	SetS(63,19,22,3,81);		--�����������¼����81   ��ȡ���Ǿ�֮��·�����������ݳ���
	
	--��������������书
	for p = 0, JY.PersonNum-1 do
		JY.Person[p]["���"] = " "
	  local r = 0
    for i,v in pairs(CC.PersonExit) do
      if v[1] == p then
        r = 1
      end
    end
    if p == 0 then
      r = 1
    end
	
		--����ǵ���
	  if r == 0 then
	    for i = 1, 10 do
	      if JY.Person[p]["�书" .. i] > 0 then
	        if p < 191 then
	          JY.Person[p]["�书�ȼ�" .. i] = 999    --BOSS�书��Ϊ��
		      else
		        JY.Person[p]["�书�ȼ�" .. i] = limitX(JY.Thing[202][WZ7]*200 + 300 + Rnd(100),0,999)    --С���书Ϊʮ��
		      end
		    else
		    	break;
		    end
	    end
	    
	    --�Ѷ�����
      --Alungky ����BUG����ʼ�����������Ĳż������������¼��ʼ����������������Զ�����ܳ���
      local pointTemp = JY.Person[p]["�������ֵ"]
	    if JY.Person[p]["�������ֵ"] <= JY.Thing[202][WZ7] * 80 then
	    	JY.Person[p]["�������ֵ"] = JY.Thing[202][WZ7] * 150 + Rnd(JY.Thing[202][WZ7])*100
	    else
	    	JY.Person[p]["�������ֵ"] = JY.Thing[202][WZ7] * JY.Person[p]["�������ֵ"] + 100
	    end
		  if pointTemp == JY.Person[p]["����"] then		--��ʼ�������Ĳż�
	      JY.Person[p]["����"] = JY.Person[p]["�������ֵ"]
	    elseif JY.Thing[202][WZ7] > 2 then
	    	JY.Person[p]["����"] = JY.Person[p]["����"] + JY.Thing[202][WZ7]*100;
	    end
      
      --�Ѷ�����
      --Alungky ͬ��
      pointTemp = JY.Person[p]["�������ֵ"]
      if JY.Person[p]["�������ֵ"] <= JY.Thing[202][WZ7] * 200 + 100 then
      	JY.Person[p]["�������ֵ"] = JY.Thing[202][WZ7] * 250 + Rnd(JY.Thing[202][WZ7])*100
      elseif JY.Person[p]["�������ֵ"] < CC.PersonAttribMax["�������ֵ"] * 2 then
      	JY.Person[p]["�������ֵ"] = JY.Person[p]["�������ֵ"] + 600 * JY.Thing[202][WZ7]
    	end
    	
    	if JY.Person[p]["�������ֵ"] > CC.PersonAttribMax["�������ֵ"] * 2 then
    		JY.Person[p]["�������ֵ"] = CC.PersonAttribMax["�������ֵ"] * 2;
    	end
	    if pointTemp == JY.Person[p]["����"] then			--��ʼ�������Ĳż�
				JY.Person[p]["����"] = JY.Person[p]["�������ֵ"]
			elseif JY.Thing[202][WZ7] > 2 then
				JY.Person[p]["����"] = JY.Person[p]["����"] + JY.Thing[202][WZ7]*200;
	    end
	    
	    --�������Ѷ�֮�����ά
    	if JY.Thing[202][WZ7]-4 > 0 then
    		JY.Person[p]["������"] = JY.Person[p]["������"] + (JY.Thing[202][WZ7]-4)*50
    		JY.Person[p]["������"] = JY.Person[p]["������"] + (JY.Thing[202][WZ7]-4)*50
    		JY.Person[p]["�Ṧ"] = JY.Person[p]["�Ṧ"] + (JY.Thing[202][WZ7]-4)*50
    	end
    	
	  end
	end
	
  
  --ѡ��ϵ
  JY.TF = JYMsgBox("��ѡ�����ǵ��츳����", TFXZSAY1, TFE, 7, 50)
  SetS(10, 0, 6, 0, 1)
  if JY.TF == 1 then         --ȭ
    SetS(4, 5, 5, 5, 1)
    JY.Thing[201][WZ7] = 1
    JY.Person[0]["ȭ�ƹ���"] = 40
	elseif JY.TF == 2 then     --��
    SetS(4, 5, 5, 5, 2)
    JY.Thing[201][WZ7] = 2
    JY.Person[0]["��������"] = 40   
	elseif JY.TF == 3 then     --��
    SetS(4, 5, 5, 5, 3)
    JY.Thing[201][WZ7] = 3
    JY.Person[0]["ˣ������"] = 40
	elseif JY.TF == 4 then		 --�� 
    SetS(4, 5, 5, 5, 4)
    JY.Thing[201][WZ7] = 4
    JY.Person[0]["�������"] = 40
	elseif JY.TF == 5 then		 --�
    JY.Person[0]["�������ֵ"] = 500
    JY.Person[0]["����"] = 500
    JY.Person[0]["��������"] = 2
    JY.Thing[201][WZ7] = 5
    SetS(4, 5, 5, 5, 5)
	elseif JY.TF == 6 then		 --��
    JY.Person[0]["Ʒ��"] = 100
    JY.Person[0]["ȭ�ƹ���"] = 40
    JY.Person[0]["��������"] = 40
    JY.Person[0]["ˣ������"] = 40
    JY.Person[0]["�������"] = 40
    JY.Thing[201][WZ7] = 6
    SetS(4, 5, 5, 5, 6)
	elseif JY.TF == 7 then		 --ҽ 
    JY.Person[0][PSX[36]] = 200
    JY.Person[0][PSX[37]] = 200
    JY.Person[0][PSX[38]] = 200
    JY.Thing[201][WZ7] = 7
    SetS(4, 5, 5, 5, 7)
  end

  
  --����ʵս����ʼ��Ϊ2����ʱ����Ҫ-2
  for i = 1, #TeamP do
    SetS(5, i, 6, 5, 2)
    
  end
  
  
  --��ʼ���¼�����ʱ��֪����ʲô��
  SetD(2, 3, 5, 8750)
  SetD(2, 3, 6, 8750)
  SetD(2, 3, 7, 8750)
  SetS(2, 24, 31, 1, 8762)
  SetS(2, 30, 34, 1, 8768)
  SetS(2, 27, 27, 1, 8758)
  JY.Wugong[34][WZ5] = 13225
  SetS(34, 34, 34, 5, 13225)
  SetD(34, 34, 8, 13225)
  JY.Thing[201][WZ6] = 7
  SetS(34, 34, 34, 4, 7)
  SetD(34, 33, 8, 7)
  SetS(34, 0, 9, 3, 80)
  
  FINALWORK2()   --��ʼ����Ʒ���ݣ��书���ݣ�������ж�����ս�����ݵ�
  
  --��ʼ������

	SetS(60,24,26,3,80);		--�����ſ�ջ�ſ������¼����80   ·���¼�
	SetS(60,25,26,3,81);		--�����ſ�ջ�ſ������¼����81
	SetS(60,26,22,3,82);		--�����ſ�ջ�����¼����82		--��ջ��ˮ��
	SetS(60,27,22,3,83);		--�����ſ�ջ�����¼����83		--��ջ�� ��Х��
	SetS(60,25,30,3,84);		--�����ſ�ջ�����¼����84			--��ջ��  ����
	SetS(60,24,32,3,85);		--�����ſ�ջ�����¼����85			--��ջ�� ˮ��
	SetS(60,25,32,3,86);		--�����ſ�ջ�����¼����86			--��ջ�� ��Х��
	SetS(60,25,31,3,87);		--�����ſ�ջ�����¼����87			--��ջ�� Ѫ������
	SetS(60,26,30,3,88);		--�����ſ�ջ�����¼����88			--��ջ�� ˮ�ϱ�׽
	
	SetS(2,29,30,3,80);			--��ѩɽ�����¼����80		����
	SetS(2,29,31,3,81);			--��ѩɽ�����¼����81		ˮ��
	
  
  --������ս
	for i=1, #TeamP do
			SetS(86, 16, i, 5, 2);
			SetS(86, 17, i, 5, 1);
			SetS(86, 18, i, 5, 1);
			SetS(86, 19, i, 5, 1);
	end
	

end

function FINALWORK2()

  JY.Wugong[201] = {}
  for i,v in pairs(CC.Wugong_S) do
    JY.Wugong[201][i] = JY.Wugong[48][i]
  end
  JY.Wugong[201]["����"] = "�̷��ʵ�ն"
  JY.Wugong[201]["������10"] = 1800
  for i = 497, 515 do
    JY.Person[i]["�书1"] = 201
  end
  SetS(70, 32, 7, 1, 0)
  SetS(70, 33, 7, 1, 0)
  SetS(70, 29, 7, 1, 0)
  SetS(28, 37, 11, 1, 1)
  SetS(28, 45, 9, 1, 1)
  SetD(12, 22, 2, 0)
  if GetS(10, 0, 17, 0) ~= 1 then
    SetD(83, 48, 4, 0)
  end
  if GetS(4, 5, 5, 5) == 3 then
    JY.Thing[138]["����������"] = 2
    JY.Thing[138]["����"] = "��������"
    JY.Wugong[64]["����"] = "��������"
    for i = 1, 10 do
      JY.Wugong[64]["�ƶ���Χ" .. i] = 4
      JY.Wugong[64]["ɱ�˷�Χ" .. i] = 0
    end
    JY.Wugong[64]["������Χ"] = 3
  end

  
  --�ﲮ��ָ��
	if GetS(86,10,12,5) == 1 then
		GRTS[29] = "�˵�"
    GRTSSAY[29] = "Ч�������ι����л��ʴ���˵���ʽ*��������������50 ��������500*���ģ�����12�� ����500��"
  elseif GetS(86,10,12,5) == 2 then
  	GRTS[29] = "��ɫ"
    GRTSSAY[29] = "Ч�������غ������ͼ����ٶ���ߣ��ܵ��˺�����*��������������50 ��������500*���ģ�����10�� ����500��"
	end
  
end



--�����ж�
function JLSD(s1, s2, dw)
  local s = math.random(100)
  if inteam(dw) then
    if s1 < s and s < s2 then
      return true
    else
      return false
    end
  elseif s1 - 5 < s and s < s2 + 5 then
    return true
  else
    return false
  end
end


function Paused()
	
end

function Resume()
	
	
end

function Game_Cycle()       --��Ϸ��ѭ��
    lib.Debug("Start game cycle");

    while JY.Status ~=GAME_END do
        local t1=lib.GetTime();

	    JY.Mytick=JY.Mytick+1;    --20�������޻����������Ǳ�Ϊվ��״̬
		if JY.Mytick%20==0 then
            JY.MyCurrentPic=0;
		end

        if JY.Mytick%1000==0 then
            JY.MYtick=0;
        end

        if JY.Status==GAME_FIRSTMMAP then  --�״���ʾ�����������µ�����������ͼ��������ʾ��Ȼ��ת��������ʾ
        
			CleanMemory()
			  lib.ShowSlow(50, 1)
			  JY.MmapMusic = 16
			  JY.Status = GAME_MMAP
			  Init_MMap()
			  lib.DrawMMap(JY.Base["��X"], JY.Base["��Y"], GetMyPic())
			  lib.ShowSlow(50, 0)
        elseif JY.Status==GAME_MMAP then
            Game_MMap();
 		elseif JY.Status==GAME_SMAP then
            Game_SMap()
		end
		collectgarbage("step", 0)
        local t2=lib.GetTime();
	    if t2-t1<CC.Frame then
            lib.Delay(CC.Frame-(t2-t1));
	    end
	    
	    
	end
end


function Game_MMap()      --����ͼ
    local direct = -1;
    local keypress, ktype, mx, my = lib.GetKey();
    if keypress ~= -1 or (ktype ~= nil and ktype ~= -1) then
	    JY.Mytick=0;
		if keypress==VK_ESCAPE or ktype == 4 then
			MMenu();
			if JY.Status ~= GAME_MMAP  then
				return ;
			end
			elseif keypress==VK_UP then
				direct=0;
			elseif keypress==VK_DOWN then
				direct=3;
			elseif keypress==VK_LEFT then
				direct=2;
			elseif keypress==VK_RIGHT then
				direct=1;
			elseif keypress == VK_H then		--��hֱ�ӻؼ�
	  		My_Enter_SubScene(70, 27, 30, 2);
	  		return;
	  	elseif keypress == VK_S then
	  		DrawStrBox(-1,-1,"�浵�У����Ժ�...", C_WHITE, CC.DefaultFont);
	  		ShowScreen();
	      JY.Base["����"] = -1
	      SaveRecord(3)
	      DrawStrBoxWaitKey("�浵���", C_WHITE, CC.DefaultFont)
	    elseif ktype == 2 or ktype == 3 then
	    	local tmpx,tmpy = mx, my
	    	mx = mx - CC.ScreenW / 2
		    my = my - CC.ScreenH / 2
		    mx = (mx) / CC.XScale
		    my = (my) / CC.YScale
		    mx, my = (mx + my) / 2, (my - mx) / 2
		    if mx > 0 then
		      mx = mx + 0.99
		    else
		      mx = mx - 0.01
		    end
		    if my > 0 then
		      my = my + 0.99
		    else
		      mx = mx - 0.01
		    end
		    mx = math.modf(mx)+JY.Base["��X"];
		    my = math.modf(my)+ JY.Base["��Y"]
		    
		    --����ƶ�
		    if ktype == 2 then
		    	if lib.GetMMap(mx, my, 3) > 0 then				--����н������ж��Ƿ�ɽ���
		    		for i=0, 4 do
		    			for j=0, 4 do
		    				local xx, yy = mx-i, my-j;
				    		local sid=CanEnterScene(xx,xx);
				    		if sid < 0 then
				    			xx, yy = mx+i, my+j;
				    			sid=CanEnterScene(xx,yy);
				    		end
								if sid>=0 then
									CC.MMapAdress[0] = sid;
									CC.MMapAdress[1] = tmpx;
									CC.MMapAdress[2] = tmpy;
									CC.MMapAdress[3] = xx;
									CC.MMapAdress[4] = yy;
		
									i=5;		--�˳�ѭ��
									break;
								end
							end
						end
					else
						CC.MMapAdress[0]= nil;
		
					end
				
				--������
		    elseif ktype == 3 then
		    	if CC.MMapAdress[0] ~= nil then
			  		mx = CC.MMapAdress[3] - JY.Base["��X"];
			  		my = CC.MMapAdress[4] - JY.Base["��Y"];
			  		CC.MMapAdress[0]= nil;
			  	else
			  		AutoMoveTab = {[0] = 0}
			  		mx = mx - JY.Base["��X"]
			  		my = my - JY.Base["��Y"]
			  	end
			  	walkto(mx, my)
			  	
		    end
			end
    end
    
    if AutoMoveTab[0] ~= 0 then
	    if direct == -1 then
	      direct = AutoMoveTab[AutoMoveTab[0]]
	      AutoMoveTab[AutoMoveTab[0]] = nil
	      AutoMoveTab[0] = AutoMoveTab[0] - 1
	    end
	  else
	    AutoMoveTab = {[0] = 0}
	  end


    local x,y;              --���շ����Ҫ���������
	  local CanMove = function(nd, nnd)
	    local nx, ny = JY.Base["��X"] + CC.DirectX[nd + 1], JY.Base["��Y"] + CC.DirectY[nd + 1]
	    if nnd ~= nil then
	      nx, ny = nx + CC.DirectX[nnd + 1], ny + CC.DirectY[nnd + 1]
	    end
	    if CC.hx == nil and ((lib.GetMMap(nx, ny, 3) == 0 and lib.GetMMap(nx, ny, 4) == 0) or CanEnterScene(nx, ny) ~= -1) then
	      return true
	    else
	      return false
	    end
	  end
    if direct ~= -1 then   --�����˹���

        AddMyCurrentPic();         --����������ͼ��ţ�������·Ч��
        x=JY.Base["��X"]+CC.DirectX[direct+1];
        y=JY.Base["��Y"]+CC.DirectY[direct+1];
        JY.Base["�˷���"]=direct;
    else
        x=JY.Base["��X"];
        y=JY.Base["��Y"];

    end

	if direct~=-1 then
		JY.SubScene=CanEnterScene(x,y);   --�ж��Ƿ�����ӳ���
	end

    if lib.GetMMap(x,y,3)==0 and lib.GetMMap(x,y,4)==0 then     --û�н��������Ե���
        JY.Base["��X"]=x;
        JY.Base["��Y"]=y;
    end
    JY.Base["��X"]=limitX(JY.Base["��X"],10,CC.MWidth-10);           --�������겻�ܳ�����Χ
    JY.Base["��Y"]=limitX(JY.Base["��Y"],10,CC.MHeight-10);

    if CC.MMapBoat[lib.GetMMap(JY.Base["��X"],JY.Base["��Y"],0)]==1 then
	    JY.Base["�˴�"]=1;
	else
	    JY.Base["�˴�"]=0;
	end

    lib.DrawMMap(JY.Base["��X"],JY.Base["��Y"],GetMyPic());             --��ʾ����ͼ
    if CC.ShowXY==1 then
	    DrawString(10,CC.ScreenH-20,string.format("%d %d",JY.Base["��X"],JY.Base["��Y"]) ,C_GOLD,16);
	end
	
		DrawTimer();
		JYZTB();
		
		
		--��ʾ���ָ�еĳ�������
	  if CC.MMapAdress[0] ~= nil then
			DrawStrBox(CC.MMapAdress[1]+10,CC.MMapAdress[2],JY.Scene[CC.MMapAdress[0]]["����"],C_GOLD,CC.DefaultFont);
		end
		
    ShowScreen();

    if JY.SubScene >= 0 then          --�����ӳ���
        CleanMemory();
		lib.UnloadMMap();
        lib.PicInit();
        lib.ShowSlow(50,1)

		JY.Status=GAME_SMAP;
        JY.MmapMusic=-1;

        JY.MyPic=GetMyPic();
        JY.Base["��X1"]=JY.Scene[JY.SubScene]["���X"]
        JY.Base["��Y1"]=JY.Scene[JY.SubScene]["���Y"]

        Init_SMap(1);
		return
    end
end

--������·
function walkto(xx,yy,x,y,flag)
	local x,y
	AutoMoveTab={[0]=0}
	if JY.Status==GAME_SMAP  then
		x=x or JY.Base["��X1"]
		y=y or JY.Base["��Y1"]
	elseif JY.Status==GAME_MMAP then
		x=x or JY.Base["��X"]
		y=y or JY.Base["��Y"]
	end
	xx,yy=xx+x,yy+y
	if JY.Status==GAME_SMAP then

		if SceneCanPass(xx, yy) == false then
			if GetS(JY.SubScene, xx, yy, 3) > 0 and GetD(JY.SubScene, GetS(JY.SubScene, xx, yy, 3), 2) > 0 then
				CC.AutoMoveEvent[1] = xx;
				CC.AutoMoveEvent[2] = yy;
				if SceneCanPass(xx+1,yy) then
					xx = xx+1;
				elseif SceneCanPass(xx,yy+1) then
					yy = yy+1;
				elseif SceneCanPass(xx,yy-1) then
					yy = yy-1;
				elseif SceneCanPass(xx-1,yy) then
					xx = xx-1;
				else
					return;
				end

				CC.AutoMoveEvent[0] = 1;		--�����������¼�
			else
				return;
			end
		end

	end
	if JY.Status==GAME_MMAP and ((lib.GetMMap(xx,yy,3)==0 and lib.GetMMap(xx,yy,4)==0) or CanEnterScene(xx,yy)~=-1)==false then
		return
	end
	local steparray={};
	local stepmax;
	local xy={}
	if JY.Status==GAME_SMAP then
		for i=0,CC.SWidth-1 do
			xy[i]={}
		end
	elseif JY.Status==GAME_MMAP then
		for i=0,479 do
			xy[i]={}
		end
	end
	if flag~=nil then
		stepmax=640
	else
		stepmax=240
	end
	for i=0,stepmax do
	    steparray[i]={};
        steparray[i].x={};
        steparray[i].y={};
	end
	local function canpass(nx,ny)
		if JY.Status==GAME_SMAP and (nx>CC.SWidth-1 or ny>CC.SWidth-1 or nx<0 or ny<0) then
			return false
		end
		if JY.Status==GAME_MMAP and (nx>479 or ny>479 or nx<1 or ny<1) then
			return false
		end
		if xy[nx][ny]==nil then
			if JY.Status==GAME_SMAP then
				if  SceneCanPass(nx,ny) then
					return true
				end
			elseif JY.Status==GAME_MMAP then
				if (lib.GetMMap(nx,ny,3)==0 and lib.GetMMap(nx,ny,4)==0) or CanEnterScene(nx,ny)~=-1 then
					return true
				end
			end
		end
		return false
	end

	local function FindNextStep(step)
		if step==stepmax then
			return
		end
		local step1=step+1
		local num=0
		for i=1,steparray[step].num do

			if steparray[step].x[i]==xx and steparray[step].y[i]==yy then
				return
			end

			if canpass(steparray[step].x[i]+1,steparray[step].y[i]) then
				num=num+1
				steparray[step1].x[num]=steparray[step].x[i]+1
				steparray[step1].y[num]=steparray[step].y[i]
				xy[steparray[step1].x[num]][steparray[step1].y[num]]=step1
			end
			if canpass(steparray[step].x[i]-1,steparray[step].y[i]) then
				num=num+1
				steparray[step1].x[num]=steparray[step].x[i]-1
				steparray[step1].y[num]=steparray[step].y[i]
				xy[steparray[step1].x[num]][steparray[step1].y[num]]=step1
			end
			if canpass(steparray[step].x[i],steparray[step].y[i]+1) then
				num=num+1
				steparray[step1].x[num]=steparray[step].x[i]
				steparray[step1].y[num]=steparray[step].y[i]+1
				xy[steparray[step1].x[num]][steparray[step1].y[num]]=step1
			end
			if canpass(steparray[step].x[i],steparray[step].y[i]-1) then
				num=num+1
				steparray[step1].x[num]=steparray[step].x[i]
				steparray[step1].y[num]=steparray[step].y[i]-1
				xy[steparray[step1].x[num]][steparray[step1].y[num]]=step1
			end
		end
		if num>0 then
			steparray[step1].num=num
			FindNextStep(step1)
		end
	end

  steparray[0].num=1;
	steparray[0].x[1]=x;
	steparray[0].y[1]=y;
	xy[x][y]=0
	FindNextStep(0);


    local movenum=xy[xx][yy];

	if movenum==nil then
		return
	end
	AutoMoveTab[0]=movenum
	for i=movenum,1,-1 do
        if xy[xx-1][yy]==i-1 then
            xx=xx-1;
            AutoMoveTab[1+movenum-i]=1;
        elseif xy[xx+1][yy]==i-1 then
            xx=xx+1;
            AutoMoveTab[1+movenum-i]=2;
        elseif xy[xx][yy-1]==i-1 then
            yy=yy-1;
            AutoMoveTab[1+movenum-i]=3;
        elseif xy[xx][yy+1]==i-1 then
            yy=yy+1;
            AutoMoveTab[1+movenum-i]=0;
        end
	end
end

function GetMyPic()      --�������ǵ�ǰ��ͼ
    local n;
	if JY.Status==GAME_MMAP and JY.Base["�˴�"]==1 then
		if JY.MyCurrentPic >=4 then
			JY.MyCurrentPic=0
		end
	else
		if JY.MyCurrentPic >6 then
			JY.MyCurrentPic=1
		end
	end

	if JY.Base["�˴�"]==0 then
        n=CC.MyStartPic+JY.Base["�˷���"]*7+JY.MyCurrentPic;
	else
	    n=CC.BoatStartPic+JY.Base["�˷���"]*4+JY.MyCurrentPic;
	end
	return n;
end

--���ӵ�ǰ������·����֡, ����ͼ�ͳ�����ͼ��ʹ��
function AddMyCurrentPic()        ---���ӵ�ǰ������·����֡,
    JY.MyCurrentPic=JY.MyCurrentPic+1;
end

--�����Ƿ�ɽ�
--id ��������
--x,y ��ǰ����ͼ����
--���أ�����id��-1��ʾû�г����ɽ�
function CanEnterScene(x,y)         --�����Ƿ�ɽ�
    for id = 0,JY.SceneNum-1 do
		local scene=JY.Scene[id];
		if (x==scene["�⾰���X1"] and y==scene["�⾰���Y1"]) or
		   (x==scene["�⾰���X2"] and y==scene["�⾰���Y2"]) then
			local e=scene["��������"];
			if e==0 then        --�ɽ�
				return id;
			elseif e==1 then    --���ɽ�
				return -1
			elseif e==2 then    --���Ṧ���߽�
				for i=1,CC.TeamNum do
					local pid=JY.Base["����" .. i];
					if pid>=0 then
						if JY.Person[pid]["�Ṧ"]>=70 then
							return id;
						end
					end
				end
			end
		end
	end
    return -1;
end

--���˵�
function MMenu()      --���˵�
    local menu={      {"ҽ��",Menu_Doctor,1},
	                  {"�ⶾ",Menu_DecPoison,1},
	                  {"��Ʒ",Menu_Thing,1},
	                  {"״̬",Menu_Status,1},
	                  {"���",Menu_PersonExit,1},
	                  {"ϵͳ",Menu_System,1},      };
    if JY.Status==GAME_SMAP then  --�ӳ������������˵����ɼ�
        --menu[5][3]=0;
        --menu[6][3]=0;
    end

    ShowMenu(menu,6,0,CC.MainMenuX,CC.MainMenuY,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE)
end

--ϵͳ�Ӳ˵�
function Menu_System()
  local menu = {
{"��ȡ����", Menu_ReadRecord, 1}, 
{"�������", Menu_SaveRecord, 1}, 
{"�ر�����", Menu_SetMusic, 1}, 
{"�ر���Ч", Menu_SetSound, 1}, 
{"��Ʒ����", Menu_WPZL, 1}, 
{"��Ӫ����", nil, 1}, 
{"������", nil, 1}, 
{"ϵͳ����", Menu_Help, 1},
{"�ҵĴ���", Menu_MYDIY, 1},
{"�뿪��Ϸ", Menu_Exit, 1}}
  if JY.EnableMusic == 0 then
    menu[3][1] = "������"
  end
  if JY.EnableSound == 0 then
    menu[4][1] = "����Ч"
  end
  if JY.Status == GAME_SMAP then
  	menu[6][3] = 0
  	menu[7][3] = 0
	  if JY.SubScene ~= 42 and JY.SubScene ~= 82 and JY.SubScene ~= 13 then
	  	menu[1][3] = 1
	  	menu[2][3] = 1
	  else
	  	menu[1][3] = 0
	  	menu[2][3] = 0
	  end
	end
  
  local r = ShowMenu(menu, #menu, 0, CC.MainSubMenuX, CC.MainSubMenuY, 0, 0, 1, 1, CC.DefaultFont, C_ORANGE, C_WHITE)
  if r == 6 then
    Menu_HYZB()
    return 1
  end
  if r == 7 then
    My_ChuangSong_Ex()
	return 1;
  end
  if r == 0 then
    return 0
  elseif r < 0 then
    return 1
  end
end

function Menu_MYDIY()
	local r = JYMsgBox("�ҵĴ���","ִ���Զ������*ָ����script/DIY.lua�ļ�",{"ȷ��","ȡ��"},2,nil,1);
	if r == 1 then
		dofile(CONFIG.ScriptPath.."DIY.lua");
	end
end

function Menu_Help()
	local title = "ϵͳ����";
	local str ="װ��˵�����鿴����װ����˵����"
						.."*�书˵�����鿴�����书��˵����"
						.."*���鹥�ԣ�����������÷����Լ���Ϸ�����ԡ�"
	local btn = {"װ��˵��","�书˵��","���鹥��"};
	local num = #btn;
	local r = JYMsgBox(title,str,btn,num,nil,1);

	if r == 1 then
		ZBInstruce();
	elseif r == 2 then
		WuGongIntruce();
	elseif r == 3 then
		TSInstruce();
	end
	
	return 1;
end

--���ֿ���
function Menu_SetMusic()
  if JY.EnableMusic == 0 then
    JY.EnableMusic = 1
    PlayMIDI(JY.CurrentMIDI)
  else
    JY.EnableMusic = 0
    lib.PlayMIDI("")
  end
  return 1
end
--��Ч����
function Menu_SetSound()
  if JY.EnableSound == 0 then
    JY.EnableSound = 1
  else
    JY.EnableSound = 0
  end
  return 1
end

--��Ʒ�˵�
function Menu_Thing()
  local menu = {
{"ȫ����Ʒ", nil, 1}, 
{"������Ʒ", nil, 1}, 
{"�������", nil, 1}, 
{"�书����", nil, 1}, 
{"�鵤��ҩ", nil, 1}, 
{"���˰���", nil, 1}}
  local r = ShowMenu(menu, CC.TeamNum, 0, CC.MainSubMenuX, CC.MainSubMenuY, 0, 0, 1, 1, CC.DefaultFont, C_ORANGE, C_WHITE)
  if r > 0 then
    local thing = {}
    local thingnum = {}
    for i = 0, CC.MyThingNum - 1 do
      thing[i] = -1
      thingnum[i] = 0
    end
    local num = 0
    for i = 0, CC.MyThingNum - 1 do
      local id = JY.Base["��Ʒ" .. i + 1]
      if id >= 0 then
        if r == 1 then
          thing[i] = id
          thingnum[i] = JY.Base["��Ʒ����" .. i + 1]
        else
	        if JY.Thing[id]["����"] == r - 2 then
	          thing[num] = id
	          thingnum[num] = JY.Base["��Ʒ����" .. i + 1]
	          num = num + 1
	        end
      	end
      end 
    end
    local r = SelectThing(thing, thingnum)
    if r >= 0 then
    	UseThing(r)
    	return 1
  	end
  end
  return 0
end

--��Ʒ����
function Menu_WPZL()
  
  local function swap(a, b) 
          JY.Base["��Ʒ" .. a], JY.Base["��Ʒ" .. b] = JY.Base["��Ʒ" .. b], JY.Base["��Ʒ" .. a]
    JY.Base["��Ʒ����" .. a], JY.Base["��Ʒ����" .. b] = JY.Base["��Ʒ����" .. b], JY.Base["��Ʒ����" .. a]
  end
  
  local flag = 0;
  for i=1, CC.MyThingNum do
          flag = 0;
                for j=1, CC.MyThingNum-i+1 do
                        if JY.Base["��Ʒ"..j] > -1 and JY.Base["��Ʒ" .. j+1] > -1 then                --���������Ʒ��Ч
                        
                                local wg1 = JY.Thing[JY.Base["��Ʒ"..j]]["�����书"];
                                local wg2 = JY.Thing[JY.Base["��Ʒ"..j+1]]["�����书"];
                                                         
                                if wg2 < 0 then                --���������书�ĸ��ݱ������
                                         if wg1 > 0 or  (wg1 < 0 and JY.Base["��Ʒ"..j] > JY.Base["��Ʒ"..j+1])  then                
                                                swap(j, j+1);
                  flag = 1;
                  
                                        end
                                        
                                elseif wg1 > 0 then                        --�������书�ĸ��������������������ͬ���ٸ����书10����������                         
                                         if JY.Wugong[wg1]["�书����"] > JY.Wugong[wg2]["�书����"] or (JY.Wugong[wg1]["�书����"] == JY.Wugong[wg2]["�书����"]  and JY.Wugong[wg1]["������10"] > JY.Wugong[wg2]["������10"]) then
                                                 swap(j, j+1);
                        flag = 1;
                                         end
                                end
                                
                        end 
                end
                
                if flag == 0 then                        --���һ������û���κεĽ������϶������Ѿ��ź����ˣ�ֱ���˳�
                        break;
                end
  end
  Cls()
  DrawStrBoxWaitKey("��Ʒ�������", C_WHITE, CC.DefaultFont)
end

--��Ʒʹ�ò˵�
function MenuDSJ()
  local menu = {
{"ȫ����Ʒ", nil, 0}, 
{"������Ʒ", nil, 0}, 
{"�������", nil, 1}, 
{"�书����", nil, 1}, 
{"�鵤��ҩ", nil, 1}, 
{"���˰���", nil, 1}}
  local r = ShowMenu(menu, CC.TeamNum, 0, CC.MainSubMenuX, CC.MainSubMenuY, 0, 0, 1, 1, CC.DefaultFont, C_ORANGE, C_WHITE)
  if r > 0 then
    local thing = {}
    local thingnum = {}
    for i = 0, CC.MyThingNum - 1 do
      thing[i] = -1
      thingnum[i] = 0
    end
    local num = 0
    for i = 0, CC.MyThingNum - 1 do
      local id = JY.Base["��Ʒ" .. i + 1]
      if id >= 0 then
        if r == 1 then
          thing[i] = id
          thingnum[i] = JY.Base["��Ʒ����" .. i + 1]  
        else
	        if JY.Thing[id]["����"] == r - 2 then
	          thing[num] = id
	          thingnum[num] = JY.Base["��Ʒ����" .. i + 1]
	          num = num + 1
	        end
        end
      end
    end
  
    local r = SelectThing(thing, thingnum)
    if r >= 0 then
      return r
    end
  end
  return -1
end

--��Ӫ����
function Menu_HYZB()
  if JY.SubScene ~= 25 then
    JY.SubScene = 70
    JY.Base["��X1"] = 8
    JY.Base["��Y1"] = 28
    JY.Base["��X"] = 358
    JY.Base["��Y"] = 235
  end
end

--�뿪�˵�
function Menu_Exit()      --�뿪�˵�
    Cls();
    if DrawStrBoxYesNo(-1,-1,"�Ƿ����Ҫ�뿪��Ϸ(Y/N)?",C_WHITE,CC.DefaultFont) == true then
        JY.Status =GAME_END;
    end
    return 1;
end


--�������
function Menu_SaveRecord()         --������Ȳ˵�
--[[
	local menu={ {"����һ",nil,1},
                 {"���ȶ�",nil,1},
                 {"������",nil,1},  };
                 
    local r=ShowMenu(menu,3,0,CC.MainSubMenuX2,CC.MainSubMenuY,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE);
]]
	local r = SaveList();
    if r>0 then
        DrawStrBox(CC.MainSubMenuX2,CC.MainSubMenuY,"���Ժ�......",C_WHITE,CC.DefaultFont);
        ShowScreen();
        SaveRecord(r);
        Cls();
	end
    return 0;
end

--��ȡ����
function Menu_ReadRecord()        --��ȡ���Ȳ˵�
	--[[
	local menu={ {"����һ",nil,1},
                 {"���ȶ�",nil,1},
                 {"������",nil,1},  };
    local r=ShowMenu(menu,3,0,CC.MainSubMenuX2,CC.MainSubMenuY,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE);

    if r == 0 then
        return 0;
    elseif r>0 then
        DrawStrBox(CC.MainSubMenuX2,CC.MainSubMenuY,"���Ժ�......",C_WHITE,CC.DefaultFont);
        ShowScreen();
        LoadRecord(r);
  ]]
  	  local r = SaveList();
    	if r < 1 then
    		return 0;
    	end
    	
    	Cls();
			DrawStrBox(-1,CC.StartMenuY,"���Ժ�...",C_GOLD,CC.DefaultFont);
			ShowScreen();
    	local result = LoadRecord(r);
    	if result ~= nil then
    		return 0;
    	end
		if JY.Base["����"] ~= -1 then
		  if JY.SubScene < 0 then
			CleanMemory()
			lib.UnloadMMap()
		  end
		  lib.PicInit()
		  lib.ShowSlow(50, 1)
		  JY.Status = GAME_SMAP
		  JY.SubScene = JY.Base["����"]
		  JY.MmapMusic = -1
		  JY.MyPic = GetMyPic()
		  Init_SMap(1)
		else
		  JY.SubScene = -1
		  JY.Status = GAME_FIRSTMMAP
		end
    return 1;

end

--״̬�Ӳ˵�
function Menu_Status()           --״̬�Ӳ˵�
    DrawStrBox(CC.MainSubMenuX,CC.MainSubMenuY,"Ҫ����˭��״̬",C_WHITE,CC.DefaultFont);
	local nexty=CC.MainSubMenuY+CC.SingleLineHeight;

    local r=SelectTeamMenu(CC.MainSubMenuX,nexty);
    if r >0 then
        ShowPersonStatus(r)
		return 1;
	else
        Cls(CC.MainSubMenuX,CC.MainSubMenuY,CC.ScreenW,CC.ScreenH);
        return 0;
	end
end

--��Ӳ˵�
function Menu_PersonExit()
  DrawStrBox(CC.MainSubMenuX, CC.MainSubMenuY, "Ҫ��˭���", C_WHITE, CC.DefaultFont)
  local nexty = CC.MainSubMenuY + CC.SingleLineHeight
  local r = SelectTeamMenu(CC.MainSubMenuX, nexty)
  if r == 1 then
    DrawStrBoxWaitKey("��Ǹ��û������Ϸ���в���ȥ", C_WHITE, CC.DefaultFont, 1)
  else
    if JY.SubScene == 82 then
      do return end
    end
  end
  if r > 0 and JY.SubScene == 55 and JY.Base["����" .. r] == 35 then
    do return end
  end
  if r > 1 then
    local personid = JY.Base["����" .. r]
    for i,v in ipairs(CC.PersonExit) do
      if personid == v[1] then
					if CallCEvent(v[2]) then
      
			    else
				  	oldCallEvent(v[2])
			    end
			    break;
      end
    end
  end
  Cls()
  return 0
end

--����ѡ������˵�
function SelectTeamMenu(x,y)          --����ѡ������˵�
	local menu={};
	for i=1,CC.TeamNum do
        menu[i]={"",nil,0};
		local id=JY.Base["����" .. i]
		if id>=0 then
            if JY.Person[id]["����"]>0 then
                menu[i][1]=JY.Person[id]["����"];
                menu[i][3]=1;
            end
		end
	end
    return ShowMenu(menu,CC.TeamNum,0,x,y,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE);
end

function GetTeamNum()            --�õ����Ѹ���
    local r=CC.TeamNum;
	for i=1,CC.TeamNum do
	    if JY.Base["����" .. i]<0 then
		    r=i-1;
		    break;
		end
    end
	return r;
end

---��ʾ����״̬
-- ���Ҽ���ҳ�����¼�������
function ShowPersonStatus(teamid)
  local page = 1
  local pagenum = 2
  local teamnum = GetTeamNum()
  while true do
    Cls()
    local id = JY.Base["����" .. teamid]
    ShowPersonStatus_sub(id, page)
    ShowScreen()
    local keypress, ktype, mx, my = WaitKey()
    lib.Delay(CC.Frame)
    if keypress == VK_ESCAPE or ktype == 4 then
      break;
    elseif keypress == VK_UP  then
      teamid = teamid - 1
    elseif keypress == VK_DOWN or ktype == 5  then
      teamid = teamid + 1
    elseif keypress == VK_LEFT or ktype == 6 then
      page = page - 1
    elseif keypress == VK_RIGHT or ktype == 7 then
      page = page + 1
    elseif keypress == VK_SPACE or ktype == 3 then
      Cls()
      if TFNLJS[id] ~= nil then
      
      	local tfid = id;
      	if id == 35 and GetS(10, 1, 1, 0) == 1 then
			     tfid = "35";
			  end
      	
        say(TFNLJS[tfid], JY.Person[id]["ͷ�����"], 5, JY.Person[id]["����"])
      end
    end
    teamid = limitX(teamid, 1, teamnum)
    page = limitX(page, 1, pagenum)
  end
end

--��ʾ���������Ϣ
function ShowPersonStatus_sub(id, page)
  local size = CC.DefaultFont
  local p = JY.Person[id]
  local p0 = JY.Person[0]
  local width = 20 * size + 15
  local h = size + CC.PersonStateRowPixel
  local height = 15 * h + 10
  local dx = (CC.ScreenW - width) / 2
  local dy = (CC.ScreenH - height) / 2
  local i = 1
  local x1, y1, x2 = nil, nil, nil
  DrawBox(dx, dy, dx + width, dy + height, C_WHITE)
  x1 = dx + 5
  y1 = dy + 5
  x2 = 4 * size
  --local headw, headh = lib.PicGetXY(1, p["ͷ�����"] * 2)

  local hid = nil
  if id == 0 then
    if GetS(4, 5, 5, 5) < 8 then
      hid = 280 + GetS(4, 5, 5, 5)
    else
      hid = 287 + GetS(4, 5, 5, 4)
    end
  else
    hid = p["ͷ�����"]
  end
  local headw, headh = lib.GetPNGXY(1, hid*2)
  local headx = (width / 2 - headw) / 3
  local heady = (h * 6 - headh) / 6
  --lib.PicLoadCache(1, hid * 2, x1 + headx, y1 + heady, 1)
  lib.LoadPNG(1, hid * 2 , x1 + headx, y1 + heady, 1)
  i = 5
  DrawString(x1, y1 + h * i, p["����"], C_WHITE, size)
  DrawString(x1 + 10 * size / 2, y1 + h * i, string.format("%3d", p["�ȼ�"]), C_GOLD, size)
  DrawString(x1 + 13 * size / 2, y1 + h * i, "��", C_ORANGE, size)
  i = i + 1
  DrawString(x1, y1 + h * (i), "�츳��", C_GOLD, size)
  

  --�������������������츳
  if id == 0  then
    DrawString(x1 + size * 3, y1 + h * (i), ZJTF[JY.Thing[201][WZ7]], C_GOLD, size)
  end

  --��ͨ��ɫ�츳
  if id ~= 0 and RWTFLB[id] ~= nil then
    DrawString(x1 + size * 3, y1 + h * (i), RWTFLB[id], C_GOLD, size)
  end
  
  
  --�ƺ�
  i = i + 1
  DrawString(x1, y1 + h * (i), "�ƺţ�", C_GOLD, size)
  if RWWH[id] ~= nil and id ~= 35 then
    DrawString(x1 + size * 3, y1 + h * (i), RWWH[id], C_GOLD, size)
  end

  if id == 35 then
    if GetS(10, 1, 1, 0) == 1 then
      DrawString(x1 + size * 3, y1 + h * (i), RWWH["35"], C_GOLD, size)
    else
    	DrawString(x1 + size * 3, y1 + h * (i), RWWH[id], C_GOLD, size)
    end
  end

  if id == 0 and GetS(10, 0, 7, 0) == 1 and JY.Thing[201][WZ7] ~= 8 then
    DrawString(x1 + size * 3, y1 + h * (i), RWWH["04"], C_GOLD, size)
  end
  
  if JY.Person[49]["�书1"] == 8 and id == 49 then
    DrawString(x1 + size * 3, y1 + h * (i), RWWH["49"], C_GOLD, size)
  end
  
  
  --�书
  for w = 1, 10 do
    if JY.Person[38]["�书" .. w] <= 0 then
      break;
    end
    if JY.Person[38]["�书" .. w] == 102 and id == 38 then
      DrawString(x1 + size * 3, y1 + h * (i), RWWH["38"], C_GOLD, size)
    end
  end
  
  
  --���ˣ���Ѫ���ж�����Ѩ���������ʵ�����
  local function DrawAttrib(str, color1, color2, v)
    if not v then
      v = 0
    end
    DrawString(x1, y1 + h * i, str, color1, size)
    DrawString(x1 + x2, y1 + h * i, string.format("%5d", p[str] + v), color2, size)
    i = i + 1
  end
  if page == 1 then
    local color = nil
    if p["���˳̶�"] < 33 then
      color = RGB(236, 200, 40)
    elseif p["���˳̶�"] < 66 then
      color = RGB(244, 128, 32)
    else
      color = RGB(232, 32, 44)
    end
    i = i + 1
    DrawString(x1, y1 + h * (i), "����", C_ORANGE, size)
    DrawString(x1 + 2 * size, y1 + h * (i), string.format("%5d", p["����"]), color, size)
    DrawString(x1 + 9 * size / 2, y1 + h * (i), "/", C_GOLD, size)
    if p["�ж��̶�"] == 0 then
      color = RGB(252, 148, 16)
    elseif p["�ж��̶�"] < 50 then
      color = RGB(120, 208, 88)
    else
      color = RGB(56, 136, 36)
    end
    DrawString(x1 + 5 * size, y1 + h * (i), string.format("%5s", p["�������ֵ"]), color, size)
    i = i + 1
    if p["��������"] == 0 then
      color = RGB(208, 152, 208)
    elseif p["��������"] == 1 then
      color = RGB(236, 200, 40)
    else
      color = RGB(236, 236, 236)
    end
    if GetS(4, 5, 5, 5) == 5 and id == 0 then
      color = RGB(216, 20, 24)
    end
    DrawString(x1, y1 + h * (i), "����", C_ORANGE, size)
    DrawString(x1 + 2 * size, y1 + h * (i), string.format("%5d/%5d", p["����"], p["�������ֵ"]), color, size)
    i = i + 1
    DrawString(x1, y1 + h * (i), "����", C_ORANGE, size)
    DrawString(x1 + size * 2 + 8, y1 + h * (i), p["����"], C_GOLD, size)
    DrawString(x1 + size * 4 + 16, y1 + h * (i), "����", C_ORANGE, size)
    DrawString(x1 + size * 6 + 32, y1 + h * (i), p["��������"], C_GOLD, size)
    i = i + 1
    
    --ʵս
    DrawString(x1, y1 + h * (i), "ʵս", C_ORANGE, size)
    for j = 1, #TeamP do
      if id == TeamP[j] then
        local num, cl = GetS(5, j, 6, 5) - 2, C_GOLD
        if num > 499 then
          num = "��"
          cl = C_RED
        end
        DrawString(x1 + size * 2 + 8, y1 + h * (i), num, cl, size)
        break;
      end
    end
    
    --����
    DrawString(x1 + size * 4 + 16, y1 + h * (i), "����", C_ORANGE, size)
    local hb = nil
    if p["���һ���"] == 1 then
      hb = "��"
    else
      hb = "��"
    end
    
    --����ֵ
    DrawString(x1 + size * 6 + 24, y1 + h * (i), hb, C_GOLD, size)
    i = i + 1
    DrawString(x1, y1 + h * (i), "����", C_ORANGE, size)
    local kk = nil
    if p["�ȼ�"] >= 30 then
      kk = "   ="
    else
      kk = 2 * (p["����"] - CC.Exp[p["�ȼ�"] - 1])
      if kk < 0 then
        kk = "  0"
	    elseif kk < 10 then
	      kk = "   " .. kk
	    elseif kk < 100 then
	      kk = "  " .. kk
	    elseif kk < 1000 then
	      kk = " " .. kk
	    end
    end
    
    --�ȼ�
    DrawString(x1 + size * 2 + 16, y1 + h * (i), kk, C_GOLD, size)
    local tmp = nil
    if CC.Level <= p["�ȼ�"] then
      tmp = "="
    else
      tmp = 2 * (CC.Exp[p["�ȼ�"]] - CC.Exp[p["�ȼ�"] - 1])
    end
    
    --װ��
    DrawString(x1 + size * 4 + 16, y1 + h * (i), "/" .. tmp, C_GOLD, size)
    local tmp1, tmp2, tmp3 = 0, 0, 0
    if p["����"] > -1 then
      tmp1 = tmp1 + JY.Thing[p["����"]]["�ӹ�����"]
      tmp2 = tmp2 + JY.Thing[p["����"]]["�ӷ�����"]
      tmp3 = tmp3 + JY.Thing[p["����"]]["���Ṧ"]
    end
    if p["����"] > -1 then
      tmp1 = tmp1 + JY.Thing[p["����"]]["�ӹ�����"]
      tmp2 = tmp2 + JY.Thing[p["����"]]["�ӷ�����"]
      tmp3 = tmp3 + JY.Thing[p["����"]]["���Ṧ"]
    end
    
    --�ж�����Ѩ����Ѫ
    i = i + 1
    DrawString(x1, y1 + h * (i), "�ж�", C_ORANGE, size)
    DrawString(x1 + size * 2 + 10, y1 + h * (i), p["�ж��̶�"], C_BLACK, size)
    DrawString(x1 + size * 4 + 20, y1 + h * (i), "����", C_ORANGE, size)
    DrawString(x1 + size * 6 + 30, y1 + h * (i), p["���˳̶�"], C_RED, size)
    DrawString(x1 + size * 8 + 40, y1 + h * (i), "��Ѩ", C_ORANGE, size)
    if JY.Status == GAME_WMAP and WAR.FXDS[id] ~= nil then
      DrawString(x1 + size * 10 + 50, y1 + h * (i), WAR.FXDS[id], C_GOLD, size)
    else
      DrawString(x1 + size * 10 + 50, y1 + h * (i), 0, C_GOLD, size)
    end
    DrawString(x1 + size * 12 + 60, y1 + h * (i), "��Ѫ", C_ORANGE, size)
    if JY.Status == GAME_WMAP and WAR.LXZT[id] ~= nil then
      DrawString(x1 + size * 14 + 70, y1 + h * (i), WAR.LXZT[id], C_RED, size)
    else
      DrawString(x1 + size * 14 + 70, y1 + h * (i), 0, C_RED, size)
    end
    i = i + 1
    DrawString(x1, y1 + h * (i), "���Ҽ���ҳ ���¼����� �ո��������˵", C_RED, size)
    i = 0
    x1 = dx + width / 2 - 24
    DrawAttrib("������", C_WHITE, C_GOLD)
    DrawString(x1 + size * 7, y1, "�� " .. tmp1, C_GOLD, size)
    DrawAttrib("������", C_WHITE, C_GOLD)
    DrawString(x1 + size * 7, y1 + h, "�� " .. tmp2, C_GOLD, size)
    DrawAttrib("�Ṧ", C_WHITE, C_GOLD)
    if tmp3 > -1 then
      DrawString(x1 + size * 7, y1 + h * 2, "�� " .. tmp3, C_GOLD, size)
    else
      tmp3 = -(tmp3)
      DrawString(x1 + size * 7, y1 + h * 2, "�� " .. tmp3, C_GOLD, size)
    end
    
    --��������
    DrawAttrib("ҽ������", C_WHITE, C_GOLD)
    DrawAttrib("�ö�����", C_WHITE, C_GOLD)
    DrawAttrib("�ⶾ����", C_WHITE, C_GOLD)
    DrawAttrib("ȭ�ƹ���", C_WHITE, C_GOLD)
    DrawAttrib("��������", C_WHITE, C_GOLD)
    DrawAttrib("ˣ������", C_WHITE, C_GOLD)
    DrawAttrib("�������", C_WHITE, C_GOLD)
    DrawAttrib("��������", C_WHITE, C_GOLD)
    DrawAttrib("����", C_WHITE, C_GOLD)
  elseif page == 2 then
    i = i + 1
    DrawString(x1, y1 + h * (i), "����:", C_ORANGE, size)
    if p["����"] > -1 then
      DrawString(x1 + size * 3, y1 + h * (i), JY.Thing[p["����"]]["����"], C_GOLD, size)
    end
    i = i + 1
    DrawString(x1, y1 + h * (i), "����:", C_ORANGE, size)
    if p["����"] > -1 then
      DrawString(x1 + size * 3, y1 + h * (i), JY.Thing[p["����"]]["����"], C_GOLD, size)
    end
    i = i + 1
    DrawString(x1, y1 + h * (i), "����:", C_ORANGE, size)
    if p["����"] > 236 then
      DrawString(x1 + size * 3, y1 + h * (i), JY.Thing[p["����"]]["����"], C_ORANGE, size)
      
      lib.SetClip(x1 + size * 3, y1 + h * 1, x1 + size * 3 + string.len(JY.Thing[p["����"]]["����"]) * size/2 * JY.Thing[p["����"]]["�辭��"] / 1000, y1 + h * (i) + h)
      DrawString(x1 + size * 3, y1 + h * (i), JY.Thing[p["����"]]["����"], M_RoyalBlue, size)
      lib.SetClip(0, 0, 0, 0)
    end
    i = i + 1
    DrawString(x1, y1 + h * (i), "������Ʒ", C_ORANGE, size)
    local thingid = p["������Ʒ"]
    if thingid > 0 then
      i = i + 1
      DrawString(x1 + size, y1 + h * (i), JY.Thing[thingid]["����"], C_GOLD, size)
      i = i + 1
      local n = TrainNeedExp(id)
      if n < math.huge then
        DrawString(x1 + size, y1 + h * (i), string.format("%5d/%5d", p["��������"], n), C_GOLD, size)
      else
        DrawString(x1 + size, y1 + h * (i), string.format("%5d/===", p["��������"]), C_GOLD, size)
      end
    else
      i = i + 2
    end
    i = i + 1
    DrawString(x1, y1 + h * (i), "���Ҽ���ҳ ���¼����� �ո��������˵", C_RED, size)
    i = 0
    x1 = dx + width / 2
    
    --�书��ʾ
    DrawString(x1, y1 + h * i, "���Ṧ��", C_ORANGE, size)
    local T = {"һ", "��", "��", "��", "��", "��", "��", "��", "��", "ʮ", "��"}
    if JY.Person[0]["�书1"] > 108 and JY.Person[0]["�书�ȼ�1"] < 900 then
      JY.Person[0]["�书�ȼ�1"] = 900
    end
    for j = 1, 10 do
      i = i + 1
      local wugong = p["�书" .. j]
      if wugong > 0 then
        local level = math.modf(p["�书�ȼ�" .. j] / 100) + 1
        if p["�书�ȼ�" .. j] == 999 then
          level = 11
        end
        DrawString(x1 + size, y1 + h * (i), string.format("%s", JY.Wugong[wugong]["����"]), C_GOLD, size)
        if p["�书�ȼ�" .. j] > 900 then
          lib.SetClip(x1 + size, y1 + h * 1, x1 + size + string.len(JY.Wugong[wugong]["����"]) * size * (p["�书�ȼ�" .. j] - 900) / 200, y1 + h * (i) + h)
          DrawString(x1 + size, y1 + h * (i), string.format("%s", JY.Wugong[wugong]["����"]), C_ORANGE, size)
          lib.SetClip(0, 0, 0, 0)
        end
        DrawString(x1 + size * 7, y1 + h * (i), T[level], C_WHITE, size)
      end
    end
    i = 11
    DrawString(x1 + size, y1 + h * i, "ŭ��", C_ORANGE, size)
    if JY.Status == GAME_WMAP and WAR.LQZ[id] ~= nil then
      DrawString(x1 + size * 3 + 10, y1 + h * i, WAR.LQZ[id], C_GOLD, size)
    else
      DrawString(x1 + size * 3 + 10, y1 + h * i, 0, C_GOLD, size)
    end
    if id == 0 then
    	DrawString(x1 + size * 5 + 10, y1 + h * i, "�䳣", C_ORANGE, size)
    	DrawString(x1 + size * 7 + 20, y1 + h * i, p["��ѧ��ʶ"], C_GOLD, size)
    else
    	DrawString(x1 + size * 5 + 10, y1 + h * i, "����", C_ORANGE, size)
    	DrawString(x1 + size * 7 + 20, y1 + h * i, 0, C_GOLD, size)
    end
  end
end


--�������������ɹ���Ҫ�ĵ���
--id ����id
function TrainNeedExp(id)         --��������������Ʒ�ɹ���Ҫ�ĵ���
    local thingid=JY.Person[id]["������Ʒ"];
	local r =0;
	if thingid >= 0 then
        if JY.Thing[thingid]["�����书"] >=0 then
            local level=0;          --�˴���level��ʵ��level-1������û���书�r������һ����һ���ġ�
			for i =1,10 do               -- ���ҵ�ǰ�Ѿ������书�ȼ�
			    if JY.Person[id]["�书" .. i]==JY.Thing[thingid]["�����书"] then
                    level=math.modf(JY.Person[id]["�书�ȼ�" .. i] /100);
					break;
                end
            end
			if level <9 then
                r=(7-math.modf(JY.Person[id]["����"]/15))*JY.Thing[thingid]["�辭��"]*(level+1);
			else
                r=math.huge;
			end
		else
            r=(7-math.modf(JY.Person[id]["����"]/15))*JY.Thing[thingid]["�辭��"]*2;
		end
	end
    return r;
end

--ҽ�Ʋ˵�
function Menu_Doctor()       --ҽ�Ʋ˵�
    DrawStrBox(CC.MainSubMenuX,CC.MainSubMenuY,"˭Ҫʹ��ҽ��",C_WHITE,CC.DefaultFont);
	local nexty=CC.MainSubMenuY+CC.SingleLineHeight;
    DrawStrBox(CC.MainSubMenuX,nexty,"ҽ������",C_ORANGE,CC.DefaultFont);

	local menu1={};
	for i=1,CC.TeamNum do
        menu1[i]={"",nil,0};
		local id=JY.Base["����" .. i]
        if id >=0 then
            if JY.Person[id]["ҽ������"]>=20 then
                 menu1[i][1]=string.format("%-10s%4d",JY.Person[id]["����"],JY.Person[id]["ҽ������"]);
                 menu1[i][3]=1;
            end
        end
	end

    local id1,id2;
	nexty=nexty+CC.SingleLineHeight;
    local r=ShowMenu(menu1,CC.TeamNum,0,CC.MainSubMenuX,nexty,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE);

    if r >0 then
	    id1=JY.Base["����" .. r];
        Cls(CC.MainSubMenuX,CC.MainSubMenuY,CC.ScreenW,CC.ScreenH);
        DrawStrBox(CC.MainSubMenuX,CC.MainSubMenuY,"Ҫҽ��˭",C_WHITE,CC.DefaultFont);
        nexty=CC.MainSubMenuY+CC.SingleLineHeight;

		local menu2={};
		for i=1,CC.TeamNum do
			menu2[i]={"",nil,0};
			local id=JY.Base["����" .. i]
			if id>=0 then
				 menu2[i][1]=string.format("%-10s%4d/%4d",JY.Person[id]["����"],JY.Person[id]["����"],JY.Person[id]["�������ֵ"]);
				 menu2[i][3]=1;
			end
		end

		local r2=ShowMenu(menu2,CC.TeamNum,0,CC.MainSubMenuX,nexty,0,0,1,1,CC.DefaultFont,C_ORANGE,C_WHITE);

		if r2 >0 then
	        id2=JY.Base["����" .. r2];
            local num=ExecDoctor(id1,id2);
			if num>0 then
                AddPersonAttrib(id1,"����",-2);
			end
            DrawStrBoxWaitKey(string.format("%s �������� %d",JY.Person[id2]["����"],num),C_ORANGE,CC.DefaultFont);
		end
	end

	Cls();

    return 0;
end

--ִ��ҽ��
--id1 ҽ��id2, ����id2�������ӵ���
function ExecDoctor(id1,id2)      --ִ��ҽ��
	if JY.Person[id1]["����"]<50 then
        return 0;
	end

	local add=JY.Person[id1]["ҽ������"];
    local value=JY.Person[id2]["���˳̶�"];
    if value > add+20 then
        return 0;
	end

    if value <25 then    --�������˳̶ȼ���ʵ��ҽ������
        add=add*4/5;
	elseif value <50 then
        add=add*3/4;
	elseif value <75 then
        add=add*2/3;
	else
        add=add/2;
	end
 	add=math.modf(add)+Rnd(5);

    AddPersonAttrib(id2,"���˳̶�",-add);
    return AddPersonAttrib(id2,"����",add)
end

--�ⶾ
function Menu_DecPoison()         --�ⶾ
    DrawStrBox(CC.MainSubMenuX,CC.MainSubMenuY,"˭Ҫ���˽ⶾ",C_WHITE,CC.DefaultFont);
	local nexty=CC.MainSubMenuY+CC.SingleLineHeight;
    DrawStrBox(CC.MainSubMenuX,nexty,"�ⶾ����",C_ORANGE,CC.DefaultFont);


	local menu1={};
	for i=1,CC.TeamNum do
        menu1[i]={"",nil,0};
		local id=JY.Base["����" .. i]
        if id>=0 then
            if JY.Person[id]["�ⶾ����"]>=20 then
                 menu1[i][1]=string.format("%-10s%4d",JY.Person[id]["����"],JY.Person[id]["�ⶾ����"]);
                 menu1[i][3]=1;
            end
        end
	end

    local id1,id2;
 	nexty=nexty+CC.SingleLineHeight;
    local r=ShowMenu(menu1,CC.TeamNum,0,CC.MainSubMenuX,nexty,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE);

    if r >0 then
	    id1=JY.Base["����" .. r];
         Cls(CC.MainSubMenuX,CC.MainSubMenuY,CC.ScreenW,CC.ScreenH);
        DrawStrBox(CC.MainSubMenuX,CC.MainSubMenuY,"��˭�ⶾ",C_WHITE,CC.DefaultFont);
		nexty=CC.MainSubMenuY+CC.SingleLineHeight;

        DrawStrBox(CC.MainSubMenuX,nexty,"�ж��̶�",C_WHITE,CC.DefaultFont);
	    nexty=nexty+CC.SingleLineHeight;

		local menu2={};
		for i=1,CC.TeamNum do
			menu2[i]={"",nil,0};
			local id=JY.Base["����" .. i]
			if id>=0 then
				 menu2[i][1]=string.format("%-10s%5d",JY.Person[id]["����"],JY.Person[id]["�ж��̶�"]);
				 menu2[i][3]=1;
			end
		end

		local r2=ShowMenu(menu2,CC.TeamNum,0,CC.MainSubMenuX,nexty,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE);
		if r2 >0 then
	        id2=JY.Base["����" .. r2];
            local num=ExecDecPoison(id1,id2);
            DrawStrBoxWaitKey(string.format("%s �ж��̶ȼ��� %d",JY.Person[id2]["����"],num),C_ORANGE,CC.DefaultFont);
		end
	end
    Cls();
    ShowScreen();
    return 0;
end

--�ⶾ
--id1 �ⶾid2, ����id2�ж����ٵ���
function ExecDecPoison(id1,id2)     --ִ�нⶾ
    local add=JY.Person[id1]["�ⶾ����"];
    local value=JY.Person[id2]["�ж��̶�"];

    if value > add+20 then
        return 0;
	end

 	add=limitX(math.modf(add/3)+Rnd(10)-Rnd(10),0,value);
    return -AddPersonAttrib(id2,"�ж��̶�",-add);
end


--��ʾ��Ʒ�˵�
function SelectThing(thing,thingnum)    

  local xnum=CC.MenuThingXnum;
  local ynum=CC.MenuThingYnum;

	local w=CC.ThingPicWidth*xnum+(xnum-1)*CC.ThingGapIn+2*CC.ThingGapOut;  --������
	local h=CC.ThingPicHeight*ynum+(ynum-1)*CC.ThingGapIn+2*CC.ThingGapOut; --��Ʒ���߶�

	local dx=(CC.ScreenW-w)/2;
	local dy=(CC.ScreenH-h-2*(CC.ThingFontSize+2*CC.MenuBorderPixel+8))/2-CC.ThingFontSize;


  local y1_1,y1_2,y2_1,y2_2,y3_1,y3_2;                  --���ƣ�˵����ͼƬ��Y����

  local cur_line=0;
  local cur_x=0;
  local cur_y=0;
  local cur_thing=-1;

	while true do
	  Cls();
		y1_1=dy;
    y1_2=y1_1+CC.ThingFontSize+2*CC.MenuBorderPixel;
    DrawBox(dx,y1_1,dx+w,y1_2,C_WHITE);
		y2_1=y1_2+5
		y2_2=y2_1+CC.ThingFontSize+2*CC.MenuBorderPixel
    DrawBox(dx,y2_1,dx+w,y2_2,C_WHITE);
    y3_1=y2_2+5;
    y3_2=y3_1+h;
		DrawBox(dx,y3_1,dx+w,y3_2,C_WHITE);

    for y=0,ynum-1 do
      for x=0,xnum-1 do
	      local id=y*xnum+x+xnum*cur_line         --��ǰ��ѡ����Ʒ
				local boxcolor;
	      if x==cur_x and y==cur_y then
		    	boxcolor=C_WHITE;
	        if thing[id]>=0 then
	          cur_thing=thing[id];
	          local str=JY.Thing[thing[id]]["����"];
	          if JY.Thing[thing[id]]["����"]==1 or JY.Thing[thing[id]]["����"]==2 then
	            if JY.Thing[thing[id]]["ʹ����"] >=0 then
	            	str=str .. "(" .. JY.Person[JY.Thing[thing[id]]["ʹ����"]]["����"] .. ")";
	            end
	          end
	          str=string.format("%s X %d",str,thingnum[id]);
						local str2=JY.Thing[thing[id]]["��Ʒ˵��"];
						if thing[id]==182 then
							str2=str2..string.format('(��%3d,%3d)',JY.Base['��X'],JY.Base['��Y'])
						end
	   			  DrawString(dx+CC.ThingGapOut,y1_1+CC.MenuBorderPixel,str,C_GOLD,CC.ThingFontSize);
	   			  DrawString(dx+CC.ThingGapOut,y2_1+CC.MenuBorderPixel,str2,C_ORANGE,CC.ThingFontSize);
						local myfont=CC.FontSmall
						local mx, my = dx + 4 * myfont, y3_2 + 2
						local myflag=0
						local myThing=JY.Thing[thing[id]]
						
						--
						local function drawitem(ss,str,news)
							local mys
							if str==nil then
								mys=ss
							elseif myThing[ss]~=0 then
								if news==nil then
									if myflag==0 then
										mys=string.format(str..':%+d',myThing[ss])
									elseif myflag==1 then
										mys=string.format(str..':%d',myThing[ss])
									end
								else
									if myThing[ss]<0 then
										return
									end
									mys=string.format(str..':%s',news[myThing[ss]])
								end
							elseif myThing[ss]==0 and ss=="����������" then
								mys=string.format(str..':%s',news[myThing[ss]])
							else
								return
							end
							
							--����̩̹���޸��ؼ�������������Ϊ���Բ���ʾ��BUG������ɫ��ʾ���϶�д�Ĵ���
							local ccc=C_GOLD
							if ss=="����������" then
								if myThing[ss]==0 then
									ccc=M_DeepSkyBlue
								elseif myThing[ss]==1 then
									ccc=C_ORANGE
								elseif myThing[ss]==2 then
									ccc=C_WHITE
								end
							end
							
							local mylen = myfont * string.len(mys) / 2 + 12
							if CC.ScreenW - dx < mx + mylen then
	            	my = my + myfont + 10
	            	mx = dx + 4 * myfont
	            end
							DrawStrBox(mx,my,mys,C_GOLD,myfont)
							mx=mx+mylen
						end
						
						--����̩̹��ͬ�����϶�
						if myThing["�����书"] > 0 then
							local kfname = "ϰ��:" .. JY.Wugong[myThing["�����书"]]["����"]
							DrawStrBox(mx, my, kfname, C_GOLD, myfont)
							mx = mx + myfont * string.len(kfname) / 2 + 12
							if JY.Wugong[myThing["�����书"]]["������10"] > 0 then
								local kfwl = "����:" .. JY.Wugong[myThing["�����书"]]["������10"]
								DrawStrBox(mx, my, kfwl, C_GOLD, myfont)
								mx = mx + myfont * string.len(kfwl) / 2 + 12
							end
						end
	          
						if myThing['����']>0 then
							drawitem('������','����')
							drawitem('���������ֵ','������ֵ')
							drawitem('���ж��ⶾ','�ж�')
							drawitem('������','����')
							if myThing['�ı���������']==2 then
								drawitem('������·������һ')
							end
							drawitem('������','����')
							drawitem('���������ֵ','������ֵ')
							drawitem('�ӹ�����','����')
							drawitem('���Ṧ','�Ṧ')
							drawitem('�ӷ�����','����')
							drawitem('��ҽ������','ҽ��')
							drawitem('���ö�����','�ö�')
							drawitem('�ӽⶾ����','�ⶾ')
							drawitem('�ӿ�������','����')
							drawitem('��ȭ�ƹ���','ȭ��')
							drawitem('����������','����')
							drawitem('��ˣ������','ˣ��')
							drawitem('���������','����')
							drawitem('�Ӱ�������','����')
							drawitem('����ѧ��ʶ','�䳣')
							drawitem('��Ʒ��','Ʒ��')
							drawitem('�ӹ�������','����',{[0]='��','��'})
							drawitem('�ӹ�������','����')
							
							if mx~=dx or my~=y3_2+2 then
								DrawStrBox(dx, y3_2 + 2, " Ч��:", C_RED, myfont)
							end
						end
						
						if myThing['����']==1 or myThing['����']==2 then
							if mx~=dx then
								mx=dx+4*myfont
								my=my+myfont+20
							end
							myflag=1
							local my2=my
							if myThing['����������']>-1 then
								drawitem('����:'..JY.Person[myThing['����������']]['����'])
							end
							drawitem('����������','����',{[0]='��','��','����'})
							drawitem('������','����')
							drawitem('�蹥����','����')
							drawitem('���Ṧ','�Ṧ')
							drawitem('���ö�����','�ö�')
							drawitem('��ҽ������','ҽ��')
							drawitem('��ⶾ����','�ⶾ')
							drawitem('��ȭ�ƹ���','ȭ��')
							drawitem('����������','����')
							drawitem('��ˣ������','ˣ��')
							drawitem('���������','����')
							drawitem('�谵������','����')
							drawitem('������','����')
							drawitem('�辭��','��������')
							if mx~=dx or my~=my2 then
								DrawStrBox(dx,my2,' ����:',C_RED,myfont)
							end
						end
	        else
	        	cur_thing=-1;
	        end
	      else
					boxcolor=C_BLACK;
				end
      
				local boxx = dx + CC.ThingGapOut + x * (CC.ThingPicWidth + CC.ThingGapIn)
	      local boxy = y3_1 + CC.ThingGapOut + y * (CC.ThingPicHeight + CC.ThingGapIn)
	      lib.DrawRect(boxx, boxy, boxx + CC.ThingPicWidth + 1, boxy + CC.ThingPicHeight + 1, boxcolor)
	      if thing[id] >= 0 then
		      lib.PicLoadCache(2, thing[id] * 2, boxx + 1, boxy + 1, 1)
	      end
	    end
		end

  	ShowScreen();
  	
		local keypress, ktype, mx, my = WaitKey(1)
  	lib.Delay(CC.Frame);
  	if keypress==VK_ESCAPE or ktype == 4 then
    	cur_thing=-1;
    	break;
    elseif keypress==VK_RETURN or keypress==VK_SPACE then
      break;
    elseif keypress==VK_UP or ktype == 6 then
    	if  cur_y == 0 then
      	if  cur_line > 0 then
        	cur_line = cur_line - 1;
        end
      else
      	cur_y = cur_y - 1;
      end
    elseif keypress==VK_DOWN or ktype == 7 then
    	if  cur_y ==ynum-1 then
    		if  cur_line < (math.modf(200/xnum)-ynum) then
        	cur_line = cur_line + 1;
        end
      else
      	cur_y = cur_y + 1;
      end
      
    elseif keypress==VK_LEFT then
    	if  cur_x > 0 then
      	cur_x=cur_x-1;
      else
      	cur_x=xnum-1;
      end
      
    elseif keypress==VK_RIGHT then
    	if  cur_x ==xnum-1 then
      	cur_x=0;
      else
      	cur_x=cur_x+1;
      end
    elseif ktype == 2 or ktype == 3 then
    	if mx>dx and my>dy and mx<CC.ScreenW-dx and my<CC.ScreenH-dy then
				cur_x=math.modf((mx-dx-CC.ThingGapOut/2)/(CC.ThingPicWidth+CC.ThingGapIn))
				cur_y=math.modf((my-y3_1-CC.ThingGapOut/2)/(CC.ThingPicHeight+CC.ThingGapIn))
				if ktype==3 then
					break
				end
			end
    end
	end

  Cls();
  return cur_thing;
end


--��������������
function Game_SMap()         --��������������
	
    DrawSMap();
	if CC.ShowXY==1 then
        DrawString(CC.ScreenW-20*CC.FontSmall,CC.ScreenH-20,string.format("%s %d %d",JY.Scene[JY.SubScene]["����"],JY.Base["��X1"],JY.Base["��Y1"]) ,C_GOLD,CC.FontSmall);
	end
		if JY.SubScene == 70 then
			local x0=JY.SubSceneX+JY.Base["��X1"]-1;    --��ͼ���ĵ�
    	local y0=JY.SubSceneY+JY.Base["��Y1"]-1;
    	local x=limitX(x0,12,45)-JY.Base["��X1"];
    	local y=limitX(y0,12,45)-JY.Base["��Y1"];
			local dx = 29 - x0 -x;
      local dy = 23 - y0 - y;
      local rx = CC.XScale * (dx - dy) + CC.ScreenW / 2
      local ry = CC.YScale * (dx + dy) + CC.ScreenH / 2
      local str = "·����ƽһ����";
      local size = CC.FontSmall;
      local color = M_DeepSkyBlue;
      lib.Background(rx - #str*size/4, ry - CC.YScale*8, rx + #str*size/4, ry - CC.YScale*8+size, 128)
      DrawString(rx - #str*size/4, ry - CC.YScale*8, str, color, size);
      
		end
		
		DrawTimer();
		
		JYZTB();
    ShowScreen();
    lib.SetClip(0, 0, 0, 0)
  
  local d_pass=GetS(JY.SubScene,JY.Base["��X1"],JY.Base["��Y1"],3);   --��ǰ·���¼�
  if d_pass>=0 then
    if d_pass ~=JY.OldDPass then     --�����ظ�����
        EventExecute(d_pass,3);       --·�������¼�
        JY.OldDPass=d_pass;
		    JY.oldSMapX=-1;
		    JY.oldSMapY=-1;
				JY.D_Valid=nil;
		end
		if JY.Status~=GAME_SMAP then
			return ;
    else
       JY.OldDPass=-1;
    end
  end
  local isout=0;                --�Ƿ���������
  if (JY.Scene[JY.SubScene]["����X1"] ==JY.Base["��X1"] and JY.Scene[JY.SubScene]["����Y1"] ==JY.Base["��Y1"]) or
     (JY.Scene[JY.SubScene]["����X2"] ==JY.Base["��X1"] and JY.Scene[JY.SubScene]["����Y2"] ==JY.Base["��Y1"]) or
     (JY.Scene[JY.SubScene]["����X3"] ==JY.Base["��X1"] and JY.Scene[JY.SubScene]["����Y3"] ==JY.Base["��Y1"]) then
     isout=1;
  end
  if isout == 1 then
    JY.Status = GAME_MMAP
    lib.PicInit()
    CleanMemory()
    JY.MmapMusic = JY.Scene[JY.SubScene]["��������"]
    if JY.MmapMusic < 0 then
      JY.MmapMusic = 25
    end
    Init_MMap()
    JY.SubScene = -1
    JY.oldSMapX = -1
    JY.oldSMapY = -1
    lib.DrawMMap(JY.Base["��X"], JY.Base["��Y"], GetMyPic())
    lib.GetKey()
		lib.ShowSlow(30,0)
    return 
  end
    --�Ƿ���ת����������
    if JY.Scene[JY.SubScene]["��ת����"] >= 0 and JY.Base["��X1"] == JY.Scene[JY.SubScene]["��ת��X1"] and JY.Base["��Y1"] == JY.Scene[JY.SubScene]["��ת��Y1"] then
    local OldScene = JY.SubScene
    JY.SubScene = JY.Scene[JY.SubScene]["��ת����"]
    lib.ShowSlow(30, 1)
    if JY.Scene[OldScene]["�⾰���X1"] ~= 0 then
      JY.Base["��X1"] = JY.Scene[JY.SubScene]["���X"]
      JY.Base["��Y1"] = JY.Scene[JY.SubScene]["���Y"]
    else
      JY.Base["��X1"] = JY.Scene[JY.SubScene]["��ת��X2"]
      JY.Base["��Y1"] = JY.Scene[JY.SubScene]["��ת��Y2"]
    end
    Init_SMap(1)
    return 
  end

    local x,y;
    local keypress, ktype, mx, my = lib.GetKey();
    local direct=-1;
    if keypress ~= -1 or (ktype ~= nil and ktype ~= -1) then
			JY.Mytick=0;
			if keypress==VK_ESCAPE or ktype == 4 then
				MMenu();
			elseif keypress==VK_UP then
				direct=0;
			elseif keypress==VK_DOWN then
				direct=3;
			elseif keypress==VK_LEFT then
				direct=2;
			elseif keypress==VK_RIGHT then
				direct=1;
			elseif keypress==VK_SPACE or keypress==VK_RETURN  then
        if JY.Base["�˷���"]>=0 then        --��ǰ������һ��λ��
            local d_num=GetS(JY.SubScene,JY.Base["��X1"]+CC.DirectX[JY.Base["�˷���"]+1],JY.Base["��Y1"]+CC.DirectY[JY.Base["�˷���"]+1],3);
            if d_num>=0 then
                EventExecute(d_num,1);       --�ո񴥷��¼�
            end
        end
	    elseif keypress == VK_S then
	    	DrawStrBox(-1,-1,"�浵�У����Ժ�...", C_WHITE, CC.DefaultFont);
	    	ShowScreen();
	      JY.Base["����"] = JY.SubScene
	      SaveRecord(3)
	      DrawStrBoxWaitKey("�浵���", C_WHITE, CC.DefaultFont)
	      
	    elseif ktype == 3 then
	    	AutoMoveTab = {[0]=0}
	    	local x0 = JY.Base["��X1"]
			  local y0 = JY.Base["��Y1"]

				mx = mx + (x0-y0)*CC.XScale - CC.ScreenW/2
				my = my + (x0+y0)*CC.YScale - CC.ScreenH/2
			
				local xx = (mx/CC.XScale + my/CC.YScale)/2;
				local yy = (my/CC.YScale - mx/CC.XScale)/2;
			
				if xx - math.modf(xx) > 0 then
					xx = math.modf(xx+1);
				end
			
				if yy - math.modf(yy) > 0 then
					yy = math.modf(yy+1);
				end
	    	if xx >= 0 and xx < CC.SWidth and yy >= 0 and yy < CC.SHeight then
	      	walkto(xx - x0,yy - y0)
	      end
			end
    end

    if JY.Status~=GAME_SMAP then
        return ;
    end
    
    if AutoMoveTab[0] ~= 0 then			--����Զ��߶�
	    if direct == -1 then
	      direct = AutoMoveTab[AutoMoveTab[0]]
	      AutoMoveTab[AutoMoveTab[0]] = nil
	      AutoMoveTab[0] = AutoMoveTab[0] - 1
	
	    end
	  else
	    AutoMoveTab = {[0] = 0}
			if CC.AutoMoveEvent[0] == 1 then
				EventExecute(GetS(JY.SubScene,CC.AutoMoveEvent[1],CC.AutoMoveEvent[2],3),1);
				CC.AutoMoveEvent[0] = 0;
			end
	  end

    if direct ~= -1 then
        AddMyCurrentPic();
        x=JY.Base["��X1"]+CC.DirectX[direct+1];
        y=JY.Base["��Y1"]+CC.DirectY[direct+1];
        JY.Base["�˷���"]=direct;
    else
        x=JY.Base["��X1"];
        y=JY.Base["��Y1"];
    end

    JY.MyPic=GetMyPic();
    DtoSMap();
    if SceneCanPass(x,y)==true then          --�µ���������߹�ȥ
        JY.Base["��X1"]=x;
        JY.Base["��Y1"]=y;
    end

    JY.Base["��X1"]=limitX(JY.Base["��X1"],1,CC.SWidth-2);
    JY.Base["��Y1"]=limitX(JY.Base["��Y1"],1,CC.SHeight-2);
    
    

		NEvent(keypress)

end

--��������(x,y)�Ƿ����ͨ��
--����true,���ԣ�false����
function SceneCanPass(x,y)  --��������(x,y)�Ƿ����ͨ��
    local ispass=true;        --�Ƿ����ͨ��

    if GetS(JY.SubScene,x,y,1)>0 then     --������1����Ʒ������ͨ��
        ispass=false;
    end

    local d_data=GetS(JY.SubScene,x,y,3);     --�¼���4
    if d_data>=0 then
        if GetD(JY.SubScene,d_data,0)~=0 then  --d*����Ϊ����ͨ��
            ispass=false;
        end
    end

    if CC.SceneWater[GetS(JY.SubScene,x,y,0)] ~= nil then   --ˮ�棬���ɽ���
        ispass=false;
    end
    return ispass;
end

function DtoSMap()          ---D*�е��¼����ݸ��Ƶ�S*�У�ͬʱ������Ч����
    for i=0,CC.DNum-1 do
        local x=GetD(JY.SubScene,i,9);
        local y=GetD(JY.SubScene,i,10);
        if x>0 and y>0 then
            SetS(JY.SubScene,x,y,3,i);

			local p1=GetD(JY.SubScene,i,5);
			if p1>=0 then
				local p2=GetD(JY.SubScene,i,6);
				local p3=GetD(JY.SubScene,i,7);
				local delay=GetD(JY.SubScene,i,8);
				if p3<=p1 then     --������ֹͣ
					if JY.Mytick %100 > delay then
						p3=p3+1;
					end
				else
					if JY.Mytick % 4 ==0 then      --4�����Ķ�������һ��
						p3=p3+1;
					end
				end
				if p3>p2 then
					 p3=p1;
				end
				SetD(JY.SubScene,i,7,p3);
			end
        end
    end
end


function DrawSMap()         --�泡����ͼ
	local x0=JY.SubSceneX+JY.Base["��X1"]-1;    --��ͼ���ĵ�
    local y0=JY.SubSceneY+JY.Base["��Y1"]-1;

    local x=limitX(x0,12,45)-JY.Base["��X1"];
    local y=limitX(y0,12,45)-JY.Base["��Y1"];

    lib.DrawSMap(JY.SubScene,JY.Base["��X1"],JY.Base["��Y1"],x,y,JY.MyPic);

    --lib.DrawSMap(JY.SubScene,JY.Base["��X1"],JY.Base["��Y1"],JY.SubSceneX,JY.SubSceneY,JY.MyPic);
end


-- ��ȡ��Ϸ����
-- id=0 �½��ȣ�=1/2/3 ����
--
--�������Ȱ����ݶ���Byte�����С�Ȼ���������Ӧ��ķ������ڷ��ʱ�ʱֱ�Ӵ�������ʡ�
--����ǰ��ʵ����ȣ����ļ��ж�ȡ�ͱ��浽�ļ���ʱ�������ӿ졣�����ڴ�ռ������
function LoadRecord(id)       -- ��ȡ��Ϸ����

	if id ~= 0 and ( existFile(string.format(CC.R_GRP, id)) == false or existFile(string.format(CC.S_GRP, id)) == false or existFile(string.format(CC.D_GRP, id))== false) then
		QZXS("�˴浵���ݲ�ȫ�����ܶ�ȡ����ѡ�������浵�����¿�ʼ");
		return -1;
	end

    local t1=lib.GetTime();

    --��ȡR*.idx�ļ�
    local data=Byte.create(6*4);
    Byte.loadfile(data,CC.R_IDXFilename[0],0,6*4);

	local idx={};
	idx[0]=0;
	for i =1,6 do
	    idx[i]=Byte.get32(data,4*(i-1));
	end
	
	local grpFile = string.format(CC.R_GRP,id);
	local sFile = string.format(CC.S_GRP,id);
	local dFile = string.format(CC.D_GRP,id);
	if id == 0 then
		grpFile = CC.R_GRPFilename[id];
		sFile = CC.S_Filename[id];
		dFile = CC.D_Filename[id];
	end
	
	


    --��ȡR*.grp�ļ�
    JY.Data_Base=Byte.create(idx[1]-idx[0]);              --��������
    Byte.loadfile(JY.Data_Base,grpFile,idx[0],idx[1]-idx[0]);

    --���÷��ʻ������ݵķ����������Ϳ����÷��ʱ�ķ�ʽ�����ˡ������ðѶ���������ת��Ϊ����Լ����ʱ��Ϳռ�
	local meta_t={
	    __index=function(t,k)
	        return GetDataFromStruct(JY.Data_Base,0,CC.Base_S,k);
		end,

		__newindex=function(t,k,v)
	        SetDataFromStruct(JY.Data_Base,0,CC.Base_S,k,v);
	 	end
	}
    setmetatable(JY.Base,meta_t);


    JY.PersonNum=math.floor((idx[2]-idx[1])/CC.PersonSize);   --����

	JY.Data_Person=Byte.create(CC.PersonSize*JY.PersonNum);
	Byte.loadfile(JY.Data_Person,grpFile,idx[1],CC.PersonSize*JY.PersonNum);

	for i=0,JY.PersonNum-1 do
		JY.Person[i]={};
		local meta_t={
			__index=function(t,k)
				return GetDataFromStruct(JY.Data_Person,i*CC.PersonSize,CC.Person_S,k);
			end,

			__newindex=function(t,k,v)
				SetDataFromStruct(JY.Data_Person,i*CC.PersonSize,CC.Person_S,k,v);
			end
		}
        setmetatable(JY.Person[i],meta_t);
	end

    JY.ThingNum=math.floor((idx[3]-idx[2])/CC.ThingSize);     --��Ʒ
	JY.Data_Thing=Byte.create(CC.ThingSize*JY.ThingNum);
	Byte.loadfile(JY.Data_Thing,grpFile,idx[2],CC.ThingSize*JY.ThingNum);
	for i=0,JY.ThingNum-1 do
		JY.Thing[i]={};
		local meta_t={
			__index=function(t,k)
				return GetDataFromStruct(JY.Data_Thing,i*CC.ThingSize,CC.Thing_S,k);
			end,

			__newindex=function(t,k,v)
				SetDataFromStruct(JY.Data_Thing,i*CC.ThingSize,CC.Thing_S,k,v);
			end
		}
        setmetatable(JY.Thing[i],meta_t);
	end

    JY.SceneNum=math.floor((idx[4]-idx[3])/CC.SceneSize);     --����
	JY.Data_Scene=Byte.create(CC.SceneSize*JY.SceneNum);
	Byte.loadfile(JY.Data_Scene,grpFile,idx[3],CC.SceneSize*JY.SceneNum);
	for i=0,JY.SceneNum-1 do
		JY.Scene[i]={};
		local meta_t={
			__index=function(t,k)
				return GetDataFromStruct(JY.Data_Scene,i*CC.SceneSize,CC.Scene_S,k);
			end,

			__newindex=function(t,k,v)
				SetDataFromStruct(JY.Data_Scene,i*CC.SceneSize,CC.Scene_S,k,v);
			end
		}
        setmetatable(JY.Scene[i],meta_t);
	end

    JY.WugongNum=math.floor((idx[5]-idx[4])/CC.WugongSize);     --�书
	JY.Data_Wugong=Byte.create(CC.WugongSize*JY.WugongNum);
	Byte.loadfile(JY.Data_Wugong,grpFile,idx[4],CC.WugongSize*JY.WugongNum);
	for i=0,JY.WugongNum-1 do
		JY.Wugong[i]={};
		local meta_t={
			__index=function(t,k)
				return GetDataFromStruct(JY.Data_Wugong,i*CC.WugongSize,CC.Wugong_S,k);
			end,

			__newindex=function(t,k,v)
				SetDataFromStruct(JY.Data_Wugong,i*CC.WugongSize,CC.Wugong_S,k,v);
			end
		}
        setmetatable(JY.Wugong[i],meta_t);
	end

    JY.ShopNum=math.floor((idx[6]-idx[5])/CC.ShopSize);     --С���̵�
	JY.Data_Shop=Byte.create(CC.ShopSize*JY.ShopNum);
	Byte.loadfile(JY.Data_Shop,grpFile,idx[5],CC.ShopSize*JY.ShopNum);
	for i=0,JY.ShopNum-1 do
		JY.Shop[i]={};
		local meta_t={
			__index=function(t,k)
				return GetDataFromStruct(JY.Data_Shop,i*CC.ShopSize,CC.Shop_S,k);
			end,

			__newindex=function(t,k,v)
				SetDataFromStruct(JY.Data_Shop,i*CC.ShopSize,CC.Shop_S,k,v);
			end
		}
        setmetatable(JY.Shop[i],meta_t);

    end

    lib.LoadSMap(sFile,CC.TempS_Filename,JY.SceneNum,CC.SWidth,CC.SHeight,dFile,CC.DNum,11);
	collectgarbage();

	lib.Debug(string.format("Loadrecord time=%d",lib.GetTime()-t1));
	
	JY.LOADTIME = lib.GetTime()
	
	for i = 1, CC.MyThingNum do
		if JY.Base["��Ʒ" .. i] < 0 then
			break;
		end
		if JY.Base["��Ʒ" .. i] == 174 then
			JY.GOLD = JY.Base["��Ʒ����" .. i]
			break;
		end
	end
	
	FINALWORK2()
	
	--��ȡ��Ŀ��Ϣ
	if existFile(CC.CircleFile) then
		local file = io.open(CC.CircleFile, "rb");
		local str = "";
    --Alungky ��ȡǰ���ʼ����Ŀ��Ϣ
    CC.CircleNum = 1;
		while true do
		    local bytes = file:read(2)
		    if not bytes then break end
		    if bytes ~= "0A" then
		    	str = str .. bytes;
		    else
		    	--print (string.char(string.sub(str, -2)))
		    	if #str > 0 then
		    		CC.CircleNum = CC.CircleNum + 1
		    	end
		    	str = "";
		    end
		end
		file:close()
	end
	
	--Ԥ����Ŀ��Ϣ
	if id == 0 then
		SetS(53, 0, 1, 5, CC.CircleNum);
	end

     --ALungky �����޸�����
   Alungky_textFix_invokePerInstance();
   
   --��ȡ��������
   LoadSkillData(id);
end

-- д��Ϸ����
-- id=0 �½��ȣ�=1/2/3 ����
function SaveRecord(id)         -- д��Ϸ����

	--�ж��Ƿ����ӳ�������
	if JY.Status == GAME_SMAP then
      JY.Base["����"] = JY.SubScene
    else
      JY.Base["����"] = -1
    end
	
    --��ȡR*.idx�ļ�
    local t1 = lib.GetTime()
	JY.SAVETIME = lib.GetTime()
	JY.GTIME = math.modf((JY.SAVETIME - JY.LOADTIME) / 60000)
	SetS(14, 2, 1, 4, GetS(14, 2, 1, 4) + JY.GTIME)
	JY.LOADTIME = lib.GetTime()

    local data=Byte.create(6*4);
    Byte.loadfile(data,CC.R_IDXFilename[0],0,6*4);

	local idx={};
	idx[0]=0;
	for i =1,6 do
	    idx[i]=Byte.get32(data,4*(i-1));
	end

	os.remove(string.format(CC.R_GRP,id));
    --дR*.grp�ļ�
  Byte.savefile(JY.Data_Base,string.format(CC.R_GRP,id),idx[0],idx[1]-idx[0]);

	Byte.savefile(JY.Data_Person,string.format(CC.R_GRP,id),idx[1],CC.PersonSize*JY.PersonNum);

	Byte.savefile(JY.Data_Thing,string.format(CC.R_GRP,id),idx[2],CC.ThingSize*JY.ThingNum);

	Byte.savefile(JY.Data_Scene,string.format(CC.R_GRP,id),idx[3],CC.SceneSize*JY.SceneNum);

	Byte.savefile(JY.Data_Wugong,string.format(CC.R_GRP,id),idx[4],CC.WugongSize*JY.WugongNum);

	Byte.savefile(JY.Data_Shop,string.format(CC.R_GRP,id),idx[5],CC.ShopSize*JY.ShopNum);

    lib.SaveSMap(string.format(CC.S_GRP,id),string.format(CC.D_GRP,id));
    
    --дskill�ļ�
    os.remove(CC.SkillFile);
    Byte.savefile(JY.Data_Skill, CC.SkillFile, 0, CC.SkillSize*JY.SkillNum)
    
    lib.Debug(string.format("SaveRecord time=%d",lib.GetTime()-t1));

end

-------------------------------------------------------------------------------------
-----------------------------------ͨ�ú���-------------------------------------------

function filelength(filename)         --�õ��ļ�����
    local inp=io.open(filename,"rb");
    local l= inp:seek("end");
	inp:close();
    return l;
end

--��S������, (x,y) ���꣬level �� 0-5
function GetS(id,x,y,level)       --��S������
     return lib.GetS(id,x,y,level);
end

--дS��
function SetS(id,x,y,level,v)       --дS��
     lib.SetS(id,x,y,level,v);
end



--��D*
--sceneid ������ţ�
--id D*���
--Ҫ���ڼ�������, 0-10
function GetD(Sceneid,id,i)          --��D*
      return lib.GetD(Sceneid,id,i);
end

--дD��
function SetD(Sceneid,id,i,v)         --дD��
      lib.SetD(Sceneid,id,i,v);
end

--�����ݵĽṹ�з�������
--data ����������
--offset data�е�ƫ��
--t_struct ���ݵĽṹ����jyconst���кܶඨ��
--key  ���ʵ�key
function GetDataFromStruct(data,offset,t_struct,key)  --�����ݵĽṹ�з������ݣ�����ȡ����
    local t=t_struct[key];
	local r;
	if t[2]==0 then
		r=Byte.get16(data,t[1]+offset);
	elseif t[2]==1 then
		r=Byte.getu16(data,t[1]+offset);
	elseif t[2]==2 then
		if CC.SrcCharSet==0 then
			r=lib.CharSet(Byte.getstr(data,t[1]+offset,t[3]),0);
		else
			r=Byte.getstr(data,t[1]+offset,t[3]);
		end
	end
	return r;
end

function SetDataFromStruct(data,offset,t_struct,key,v)  --�����ݵĽṹ�з������ݣ���������
    local t=t_struct[key];
	if t[2]==0 then
		Byte.set16(data,t[1]+offset,v);
	elseif t[2]==1 then
		Byte.setu16(data,t[1]+offset,v);
	elseif t[2]==2 then
		local s;
		if CC.SrcCharSet==0 then
			s=lib.CharSet(v,1);
		else
			s=v;
		end
		Byte.setstr(data,t[1]+offset,t[3],s);
	end
end


--����t_struct ����Ľṹ�����ݴ�data�����ƴ��ж�����t��
function LoadData(t,t_struct,data)        --data�����ƴ��ж�����t��
    for k,v in pairs(t_struct) do
        if v[2]==0 then
            t[k]=Byte.get16(data,v[1]);
        elseif v[2]==1 then
            t[k]=Byte.getu16(data,v[1]);
		elseif v[2]==2 then
            if CC.SrcCharSet==0 then
                t[k]=lib.CharSet(Byte.getstr(data,v[1],v[3]),0);
		    else
		        t[k]=Byte.getstr(data,v[1],v[3]);
		    end
		end
	end
end


--����t_struct ����Ľṹ������д��data Byte�����С�
function SaveData(t,t_struct,data)      --����д��data Byte�����С�
    for k,v in pairs(t_struct) do
        if v[2]==0 then
            Byte.set16(data,v[1],t[k]);
		elseif v[2]==1 then
            Byte.setu16(data,v[1],t[k]);
		elseif v[2]==2 then
		    local s;
			if CC.SrcCharSet==0 then
			    s=lib.CharSet(t[k],1);
            else
			    s=t[k];
		    end
            Byte.setstr(data,v[1],v[3],s);
		end
	end
end


function limitX(x,minv,maxv)       --����x�ķ�Χ
  if x<minv then
	    x=minv;
	end
	if maxv ~= nil and x>maxv then
	    x=maxv;
	end
	return x
end

function RGB(r,g,b)          --������ɫRGB
   return r*65536+g*256+b;
end

function GetRGB(color)      --������ɫ��RGB����
    color=color%(65536*256);
    local r=math.floor(color/65536);
    color=color%65536;
    local g=math.floor(color/256);
    local b=color%256;
    return r,g,b
end

--�ȴ���������
function WaitKey(flag)       --�ȴ���������

	--ktype  1�����̣�2������ƶ���3:��������4������Ҽ���5������м���6�������ϣ�7��������

  local key, ktype, mx, my=-1,-1,-1,-1;
  while true do
		key, ktype, mx, my=lib.GetKey();
		if ktype == nil then
			ktype, mx, my=-1,-1,-1;
		end
		if ktype ~=-1 or key ~= -1 then
			if (flag == nil or flag == 0) and ktype ~= 2 then
	     	break;
	    elseif flag ~= nil and flag ~= 0 then
	    	break;
	    end
	  end
    lib.Delay(CC.Frame/2);
    
    --ShowScreen(0);
	end
	return key, ktype, mx, my;
end

--����һ���������İ�ɫ�����Ľǰ���
function DrawBox(x1, y1, x2, y2, color)
  local s = 4
  lib.Background(x1 + 4, y1, x2 - 4, y1 + s, 128)
  lib.Background(x1 + 1, y1 + 1, x1 + s, y1 + s, 128)
  lib.Background(x2 - s, y1 + 1, x2 - 1, y1 + s, 128)
  lib.Background(x1, y1 + 4, x2, y2 - 4, 128)
  lib.Background(x1 + 1, y2 - s, x1 + s, y2 - 1, 128)
  lib.Background(x2 - s, y2 - s + 1, x2 - 1, y2, 128)
  lib.Background(x1 + 4, y2 - s, x2 - 4, y2, 128)
  local r, g, b = GetRGB(color)
  DrawBox_1(x1 + 1, y1 + 1, x2, y2, RGB(math.modf(r / 2), math.modf(g / 2), math.modf(b / 2)))
  DrawBox_1(x1, y1, x2 - 1, y2 - 1, color)
end

--����һ���������İ�ɫ�����Ľǰ���
function DrawBox_1(x1, y1, x2, y2, color)
  local s = 4
  lib.DrawRect(x1 + s, y1, x2 - s, y1, color)
  lib.DrawRect(x1 + s, y2, x2 - s, y2, color)
  lib.DrawRect(x1, y1 + s, x1, y2 - s, color)
  lib.DrawRect(x2, y1 + s, x2, y2 - s, color)
  lib.DrawRect(x1 + 2, y1 + 1, x1 + s - 1, y1 + 1, color)
  lib.DrawRect(x1 + 1, y1 + 2, x1 + 1, y1 + s - 1, color)
  lib.DrawRect(x2 - s + 1, y1 + 1, x2 - 2, y1 + 1, color)
  lib.DrawRect(x2 - 1, y1 + 2, x2 - 1, y1 + s - 1, color)
  lib.DrawRect(x1 + 2, y2 - 1, x1 + s - 1, y2 - 1, color)
  lib.DrawRect(x1 + 1, y2 - s + 1, x1 + 1, y2 - 2, color)
  lib.DrawRect(x2 - s + 1, y2 - 1, x2 - 2, y2 - 1, color)
  lib.DrawRect(x2 - 1, y2 - s + 1, x2 - 1, y2 - 2, color)
end

--��ʾ��Ӱ�ַ���
function DrawString(x,y,str,color,size)         --��ʾ��Ӱ�ַ���
		
	if x==-1 then
		local ll=#str;
    local w=size*ll/2+2*CC.MenuBorderPixel;
    x=(CC.ScreenW-size/2*ll-2*CC.MenuBorderPixel)/2;
	end
	if y == -1 then
    y = (CC.ScreenH - size - 2 * CC.MenuBorderPixel) / 2
  end
    lib.DrawStr(x,y,str,color,size,CC.FontName,CC.SrcCharSet,CC.OSCharSet);

end

--��ʾ������ַ���
--(x,y) ���꣬�����Ϊ-1,������Ļ�м���ʾ
function DrawStrBox(x,y,str,color,size)         --��ʾ������ַ���
    local ll=#str;
    local w=size*ll/2+2*CC.MenuBorderPixel;
	local h=size+2*CC.MenuBorderPixel;
	if x==-1 then
        x=(CC.ScreenW-size/2*ll-2*CC.MenuBorderPixel)/2;
	end
	if y==-1 then
        y=(CC.ScreenH-size-2*CC.MenuBorderPixel)/2;
	end

    DrawBox(x,y,x+w-1,y+h-1,C_WHITE);
    DrawString(x+CC.MenuBorderPixel,y+CC.MenuBorderPixel,str,color,size);
end

--��ʾ��ѯ��Y/N��������Y���򷵻�true, N�򷵻�false
--(x,y) ���꣬�����Ϊ-1,������Ļ�м���ʾ
--��Ϊ�ò˵�ѯ���Ƿ�
function DrawStrBoxYesNo(x, y, str, color, size)
  lib.GetKey()
  local ll = #str
  local w = size * ll / 2 + 2 * CC.MenuBorderPixel
  local h = size + 2 * CC.MenuBorderPixel
  if x == -1 then
    x = (CC.ScreenW - size / 2 * ll - 2 * CC.MenuBorderPixel) / 2
  end
  if y == -1 then
    y = (CC.ScreenH - size - 2 * CC.MenuBorderPixel) / 2
  end
	Cls();
  DrawStrBox(x, y, str, color, size)
  local menu = {
{"ȷ��/��", nil, 1}, 
{"ȡ��/��", nil, 2}}
  local r = ShowMenu(menu, 2, 0, x + w - 4 * size - 2 * CC.MenuBorderPixel, y + h + CC.MenuBorderPixel, 0, 0, 1, 0, CC.DefaultFont, C_ORANGE, C_WHITE)
  if r == 1 then
    return true
  else
    return false
  end
end


--��ʾ�ַ������ȴ��������ַ���������ʾ����Ļ�м�
function DrawStrBoxWaitKey(s,color,size)          --��ʾ�ַ������ȴ�����
    lib.GetKey();
    Cls();
    DrawStrBox(-1,-1,s,color,size);
    ShowScreen();
    WaitKey();
end

--���� [0 , i-1] �����������
function Rnd(i)           --�����
    local r=math.random(i);
    return r-1;
end

--�����������ԣ���������ֵ���ƣ���Ӧ�����ֵ���ơ���Сֵ������Ϊ0
--id ����id
--str�����ַ���
--value Ҫ���ӵ�ֵ��������ʾ����
--����1,ʵ�����ӵ�ֵ
--����2���ַ�����xxx ����/���� xxxx��������ʾҩƷЧ��
function AddPersonAttrib(id, str, value)
  local oldvalue = JY.Person[id][str]
  local attribmax = math.huge
  if str == "����" then
    attribmax = JY.Person[id]["�������ֵ"]
  elseif str == "����" then
    attribmax = JY.Person[id]["�������ֵ"]
  elseif CC.PersonAttribMax[str] ~= nil then
    attribmax = CC.PersonAttribMax[str]
  end
  
  if str == "�������ֵ" then
    local nlmax = math.modf((JY.Person[id]["����"] - 1) / 15)
    attribmax = 9500 - nlmax * 750
    if T1LEQ(id) or id == 53 then
      attribmax = 10000
    end
    for i = 1, 10 do
      if JY.Person[id]["�书" .. i] == 85 or JY.Person[id]["�书" .. i] == 88 then
        attribmax = attribmax + 750
      end
    end
    if id == 58 then
      attribmax = attribmax - JY.Person[300]["����"] * 100
    end
    if attribmax < 500 then
      attribmax = 500
    end
    if attribmax > 10000 then
    	attribmax = 10000
  	end
  end
    
  if str == "�ö�����" and id == 2 then
    attribmax = 500
  end
  if str == "�ö�����" and (id == 25 or id == 83 or id == 17) then
    attribmax = 400
  end
  if str == "ҽ������" and (id == 16 or id == 28 or id == 45) then
    attribmax = 500
  end
  if str == "ҽ������" and id == 85 then
    attribmax = 400
  end
  if (str == "ҽ������" or str == "�ö�����" or str == "�ⶾ����") and  id == 0 and GetS(4, 5, 5, 5) == 7 then
    attribmax = 400
  end
  
  local newvalue = limitX(oldvalue + value, 0, attribmax)
  JY.Person[id][str] = newvalue
  local add = newvalue - oldvalue
  local showstr = ""
  if add > 0 then
    showstr = string.format("%s ���� %d", str, add)
  elseif add < 0 then
    showstr = string.format("%s ���� %d", str, -add)
  end
  return add, showstr
end

--����midi
function PlayMIDI(id)             --����midi
    JY.CurrentMIDI=id;
    if JY.EnableMusic==0 then
        return ;
    end
    if id>=0 then
        lib.PlayMIDI(string.format(CC.MIDIFile,id+1));
    end
end

--������Чatk***
function PlayWavAtk(id)             --������Чatk***
    if JY.EnableSound==0 then
        return ;
    end
    if id>=0 then
        lib.PlayWAV(string.format(CC.ATKFile,id));
    end
end

--������Чe**
function PlayWavE(id)              --������Чe**
    if JY.EnableSound==0 then
        return ;
    end
    if id>=0 then
        lib.PlayWAV(string.format(CC.EFile,id));
    end
end


--flag =0 or nil ȫ��ˢ����Ļ
--      1 ��������εĿ���ˢ��
function ShowScreen(flag)
  if JY.Darkness == 0 then
    if flag == nil then
      flag = 0
    end
    lib.ShowSurface(flag)
  end
end

--ͨ�ò˵�����
-- menuItem ��ÿ���һ���ӱ�����Ϊһ���˵���Ķ���
--          �˵����Ϊ  {   ItemName,     �˵��������ַ���
--                          ItemFunction, �˵����ú��������û����Ϊnil
--                          Visible       �Ƿ�ɼ�  0 ���ɼ� 1 �ɼ�, 2 �ɼ�����Ϊ��ǰѡ���ֻ����һ��Ϊ2��
--                                        ������ֻȡ��һ��Ϊ2�ģ�û�����һ���˵���Ϊ��ǰѡ���
--                                        ��ֻ��ʾ���ֲ˵�������´�ֵ��Ч��
--                                        ��ֵĿǰֻ�����Ƿ�˵�ȱʡ��ʾ������
--                       }
--          �˵����ú���˵����         itemfunction(newmenu,id)
--
--       ����ֵ
--              0 �������أ������˵�ѭ�� 1 ���ú���Ҫ���˳��˵��������в˵�ѭ��
--
-- numItem      �ܲ˵������
-- numShow      ��ʾ�˵���Ŀ������ܲ˵���ܶ࣬һ����ʾ���£�����Զ����ֵ
--                =0��ʾ��ʾȫ���˵���

-- (x1,y1),(x2,y2)  �˵���������ϽǺ����½����꣬���x2,y2=0,������ַ������Ⱥ���ʾ�˵����Զ�����x2,y2
-- isBox        �Ƿ���Ʊ߿�0 �����ƣ�1 ���ơ������ƣ�����(x1,y1,x2,y2)�ľ��λ��ư�ɫ���򣬲�ʹ�����ڱ����䰵
-- isEsc        Esc���Ƿ������� 0 �������ã�1������
-- Size         �˵��������С
-- color        �����˵�����ɫ����ΪRGB
-- selectColor  ѡ�в˵�����ɫ,
--;
-- ����ֵ  0 Esc����
--         >0 ѡ�еĲ˵���(1��ʾ��һ��)
--         <0 ѡ�еĲ˵�����ú���Ҫ���˳����˵�����������˳����˵�

function ShowMenu(menuItem, numItem, numShow, x1, y1, x2, y2, isBox, isEsc, size, color, selectColor)
  local w = 0
  local h = 0
  local i = 0
  local num = 0
  local newNumItem = 0
  lib.GetKey()
  local newMenu = {}
  for i = 1, numItem do
    if menuItem[i][3] > 0 then
      newNumItem = newNumItem + 1
      newMenu[newNumItem] = {menuItem[i][1], menuItem[i][2], menuItem[i][3], i}
    end
  end
  if newNumItem == 0 then
    return 0
  end
  if numShow == 0 or newNumItem < numShow then
    num = newNumItem
  else
    num = numShow
  end
  local maxlength = 0
  if x2 == 0 and y2 == 0 then
    for i = 1, newNumItem do
      if maxlength < string.len(newMenu[i][1]) then
        maxlength = string.len(newMenu[i][1])
      end
    end
    w = size * maxlength / 2 + 2 * CC.MenuBorderPixel
    h = (size + CC.RowPixel) * num + CC.MenuBorderPixel
  else
    w = x2 - x1
    h = y2 - y1
  end
  local start = 1
  local current = 1
  for i = 1, newNumItem do
    if newMenu[i][3] == 2 then
      current = i
    end
  end
  if numShow ~= 0 then
    current = 1
  end
  local surid = lib.SaveSur(0, 0, CC.ScreenW, CC.ScreenH)
  local returnValue = 0
  if isBox == 1 then
    DrawBox(x1, y1, x1 + (w), y1 + (h), C_WHITE)
  end
  
  
  while true do
    if num ~= 0 then
		Cls();
		lib.LoadSur(surid, 0, 0)
	    if isBox == 1 then
	      DrawBox(x1, y1, x1 + (w), y1 + (h), C_WHITE)
	    end
  	end
	  for i = start, start + num - 1 do
	    local drawColor = color
	    if i == current then
	      drawColor = selectColor
	      lib.Background(x1 + CC.MenuBorderPixel, y1 + CC.MenuBorderPixel + (i - start) * (size + CC.RowPixel), x1 - CC.MenuBorderPixel + (w), y1 + CC.MenuBorderPixel + (i - start) * (size + CC.RowPixel) + size, 128, color)
	    end
	    DrawString(x1 + CC.MenuBorderPixel, y1 + CC.MenuBorderPixel + (i - start) * (size + CC.RowPixel), newMenu[i][1], drawColor, size)
	  end

	  ShowScreen()
	  local keyPress, ktype, mx, my = lib.GetKey()
	  
	  if keyPress==VK_ESCAPE or ktype == 4 then                  --Esc �� �˳�
			if isEsc==1 then
				break							-- star��������break���ã���������ڴ�й¶����
				--return 0
			end
	  elseif keyPress==VK_DOWN or ktype == 7 then                --Down
	    current = current +1;
	    if current > (start + num-1) then
	        start=start+1;
	    end
	    if current > newNumItem then
	        start=1;
	        current =1;
	    end
		elseif keyPress==VK_UP or ktype == 6 then                  --Up
	    current = current -1;
	    if current < start then
	        start=start-1;
	    end
	    if current < 1 then
	        current = newNumItem;
	        start =current-num+1;
	    end
	  elseif keyPress == VK_RIGHT then
      current = current + 10
      if start + num - 1 < current then
      	start = start + 10
      end
      if newNumItem < current +start then                --Alungky �޸�������ʱ��������BUG
      	current = newNumItem
      	start = current - num + 1
      end
    elseif keyPress == VK_LEFT then
			current = current - 10
			if current < start then
				start = start - 10
			end
			if current < 1 then
				start = 1
				current = 1
	    elseif current < num then                --Alungky �޸�������ʱ��������BUG
	      start = 1
			end
		else
			local mk = false;
			if ktype == 2 or ktype == 3 then			--ѡ��
				if mx >= x1 and mx <= x1 + w and my >= y1 and my <= y1 + h then
					current = start + math.modf((my - y1 - CC.MenuBorderPixel) / (size + CC.RowPixel))
					mk = true;
				end
			end
			if  keyPress==VK_SPACE or keyPress==VK_RETURN or ktype == 5 or (ktype == 3 and mk) then
				if newMenu[current][2]==nil then
				  returnValue=newMenu[current][4];
				  break;
				else
				  local r=newMenu[current][2](newMenu,current);               --���ò˵�����
				  if r==1 then
					  returnValue= -newMenu[current][4];
					  break;
				  end
					ClsN();
					lib.LoadSur(surid,0,0);
					if isBox==1 then
						DrawBox(x1,y1,x1+w,y1+h,C_WHITE);
					end
				end
			end
		end
	end
	lib.FreeSur(surid)
	return returnValue
	
end

--����������ShowMenuһ������һЩ�ر�Ľ�������˵��
--menu ÿ����������ֵ��1���ƣ�2ִ�к�����3��ʾ��ʽ(0��ɫ��ѡ��1������ʾ��2����ʾ, 3��ɫ����ѡ��)
--itemNum �˵��ĸ�����ͨ���ڵ��õ�ʱ�� #menu�Ϳ�����
--numShow ÿ����ʾ�Ĳ˵�����
--showRow һ��������ʾ������������������ʾ�˵������ﲻ��һ������������������Զ���Ӧ���ֵ
--str �Ǳ�������֣���nil����ʾ
--ѡ����
function ShowMenu2(menu,itemNum,numShow,showRow,x1,y1,x2,y2,isBox,isEsc,size,color,selectColor, str, selIndex)     --ͨ�ò˵�����
    local w=0;
    local h=0;   --�߿�Ŀ��
    local i,j=0,0;
    local col=0;     --ʵ�ʵ���ʾ�˵���
    local row=0;
    
    lib.GetKey();
    Cls();
    
    --��һ���µ�table
    local menuItem = {};
    local numItem = 0;                --��ʾ������
    
    --�ѿ���ʾ�Ĳ��ַŵ���table
    for i,v in pairs(menu) do
            if v[3] ~= 2 then
                    numItem = numItem + 1;
                    menuItem[numItem] = {v[1],v[2],v[3],i};                --ע���4��λ�ã�����i��ֵ
            end
    end
    
    --����ʵ����ʾ�Ĳ˵�����
    if numShow==0 or numShow > numItem then
        col=numItem;
        row = 1;
    else
        col=numShow;
        row = math.modf((numItem-1)/col);
    end
    
    if showRow > row + 1 then
            showRow = row + 1;
    end

    --����߿�ʵ�ʿ��
    local maxlength=0;
    if x2==0 and y2==0 then
        for i=1,numItem do
            if string.len(menuItem[i][1])>maxlength then
                maxlength=string.len(menuItem[i][1]);
            end
        end
                w=(size*maxlength/2+CC.RowPixel)*col+2*CC.MenuBorderPixel;
                h=showRow*(size+CC.RowPixel) + 2*CC.MenuBorderPixel;
    else
        w=x2-x1;
        h=y2-y1;
    end
    
    if x1 == -1 then
    	x1 = (CC.ScreenW-w)/2;
    end
    if y1 == -1 then
    	y1 = (CC.ScreenH-h+size)/2;
    end

    local start=0;             --��ʾ�ĵ�һ��

    local curx = 1;          --��ǰѡ����
    local cury = 0;
    local current = curx + cury*numShow;
    
    
    --Ĭ����ѡ��
    if selIndex ~= nil and selIndex > 0 then
    	current = selIndex;
    	curx = math.fmod((selIndex-1),numShow) + 1;
    	cury = (selIndex - curx)/numShow;
    	if cury >= showRow/2 then
         start = limitX(cury-showRow/2,0,row-showRow+1);
      end
    end
    
    

    local returnValue =0;
    if str ~= nil then
            DrawStrBox(-1, y1 - size - 2*CC.MenuBorderPixel, str, color, size)
    end
    local surid = lib.SaveSur(0, 0, CC.ScreenW, CC.ScreenH)
                if isBox==1 then
                        DrawBox(x1,y1,x1+w,y1+h,C_WHITE);
                end
    while true do
            if col ~= 0 then
              lib.LoadSur(surid, 0, 0)
                    if isBox == 1 then
                      DrawBox(x1, y1, x1 + (w), y1 + (h), C_WHITE)
                    end
                  end
            for i=start,showRow+start-1 do
                    for j=1, col do
                            local n = i*col+j;
                            if n > numItem then
                                    break;
                            end
                            
                local drawColor=color;           --���ò�ͬ�Ļ�����ɫ
                if menuItem[n][3] == 0 or menuItem[n][3] == 3 then
                        drawColor = M_DimGray
                end
                local xx = x1+(j-1)*(size*maxlength/2+CC.RowPixel) + CC.MenuBorderPixel
                local yy = y1+(i-start)*(size+CC.RowPixel) + CC.MenuBorderPixel
                if n==current then
                    drawColor=selectColor;
                                lib.Background(xx, yy, xx + size*maxlength/2, yy + size, 128, color)
                end
                                        DrawString(xx,yy,menuItem[n][1],drawColor,size);

                          end
            end
            ShowScreen();
                local keyPress, ktype, mx, my = WaitKey(1)
                lib.Delay(CC.Frame);

                if keyPress==VK_ESCAPE or ktype == 4 then                  --Esc �˳�
                    if isEsc==1 then
                        break;
                    end
                elseif keyPress==VK_DOWN or ktype == 7 then                --Down
                        if curx + (cury+1)*col <= numItem then
                    cury = cury + 1;
                    
                    if cury > row then
                            cury = row;
                    elseif cury >= showRow/2 and cury <= row - showRow/2 + 1 and start <= row-showRow  then
                                    start = start + 1;
                    end
                   end
            
                elseif keyPress==VK_UP or ktype == 6 then                  --Up
            cury = cury -1;
            if cury < 0 then
                cury = 0;
            elseif cury >= showRow/2-1 and cury < row - showRow/2 and start > 0 then
                            start = start - 1;
            end
            
                elseif keyPress==VK_RIGHT then                --RIGHT
                    curx = curx +1;
                    if curx > col then
                        curx = 1;
                    elseif curx + cury*col > numItem then
                                curx = 1;
                    end
                elseif keyPress==VK_LEFT then                  --LEFT
                    curx = curx -1;
                    if curx < 1 then
                        curx = col;
                        if curx + cury*col > numItem then
                                curx = numItem - cury*col;
                        end
                    end
                else
	                local mk = false;
									if ktype == 2 or ktype == 3 then			--ѡ��
										if mx >= x1 and mx <= x1 + w and my >= y1 and my <= y1 + h then
											
											curx = math.modf((mx-x1-CC.MenuBorderPixel)/(size*maxlength/2+CC.RowPixel)) + 1
											cury = start + math.modf((my - y1 - CC.MenuBorderPixel) / (size + CC.RowPixel))
											mk = true;
										end
									end
									if  keyPress==VK_SPACE or keyPress==VK_RETURN or ktype == 5 or (ktype == 3 and mk) then
                    current = curx + cury*col;
                    if menuItem[current][3]==3 then
                                        
                    elseif menuItem[current][2]==nil then
                        returnValue=current;
                        break;
                    else
                        local r=menuItem[current][2](menuItem,current);               --���ò˵�����
                        if r==1 then
                            returnValue= -current;
                            break;
                                                else
                                lib.LoadSur(surid, 0, 0)
                                                        if isBox==1 then
                                                                DrawBox(x1, y1, x1 + (w), y1 + (h), C_WHITE)
                                                        end
                              end
                    		end
                      end
                   end 
                   current = curx + cury*col;
    end
        lib.FreeSur(surid)
        
        --����ֵ�������ȡ��4��λ�õ�ֵ
        if returnValue > 0 then
                return menuItem[returnValue][4]
        else
                return returnValue
        end
end

------------------------------------------------------------------------------------
--------------------------------------��Ʒʹ��---------------------------------------
--��Ʒʹ��ģ��
--��ǰ��Ʒid
--����1 ʹ������Ʒ�� 0 û��ʹ����Ʒ��������ĳЩԭ����ʹ��
function UseThing(id)             --��Ʒʹ��
    --���ú���
	if JY.ThingUseFunction[id]==nil then
	    return DefaultUseThing(id);
	else
        return JY.ThingUseFunction[id](id);
    end
end

--ȱʡ��Ʒʹ�ú�����ʵ��ԭʼ��ϷЧ��
--id ��Ʒid
function DefaultUseThing(id)                --ȱʡ��Ʒʹ�ú���
    if JY.Thing[id]["����"]==0 then
        return UseThing_Type0(id);
    elseif JY.Thing[id]["����"]==1 then
        return UseThing_Type1(id);
    elseif JY.Thing[id]["����"]==2 then
        return UseThing_Type2(id);
    elseif JY.Thing[id]["����"]==3 then
        return UseThing_Type3(id);
    elseif JY.Thing[id]["����"]==4 then
        return UseThing_Type4(id);
    end
end

--������Ʒ�������¼�
function UseThing_Type0(id)              --������Ʒʹ��
    if JY.SubScene>=0 then
		local x=JY.Base["��X1"]+CC.DirectX[JY.Base["�˷���"]+1];
		local y=JY.Base["��Y1"]+CC.DirectY[JY.Base["�˷���"]+1];
        local d_num=GetS(JY.SubScene,x,y,3)
        if d_num>=0 then
            JY.CurrentThing=id;
            EventExecute(d_num,2);       --��Ʒ�����¼�
            JY.CurrentThing=-1;
			return 1;
		else
		    return 0;
        end
    end
end



--�ж�һ�����Ƿ����װ��������һ����Ʒ
--���� true����������false����
function CanUseThing(id, personid)
  local str = ""
  if personid == 76 and id > 63 then
    return true
  elseif (id == 220 or id == 221) and personid == 0 then
    return true
  elseif id > 186 and id < 194 and personid == 44 then
    return true
  elseif id == 114 and personid == 0 and GetS(4, 5, 5, 5) == 2 and JY.Person[0]["��������"] > 99 then
    return true
  elseif id == 86 and personid == 0 and GetS(4, 5, 5, 5) == 1 and JY.Person[0]["ȭ�ƹ���"] > 119 then
    return true
  else
    if JY.Thing[id]["����������"] >= 0 and JY.Thing[id]["����������"] ~= personid then
      return false
    end
    if JY.Thing[id]["����������"] ~= 2 and JY.Person[personid]["��������"] ~= 2 and JY.Thing[id]["����������"] ~= JY.Person[personid]["��������"] then
      return false
    end
    if JY.Person[personid]["�������ֵ"] < JY.Thing[id]["������"] then
      return false
    end
    if JY.Person[personid]["������"] < JY.Thing[id]["�蹥����"] then
      return false
    end
    if JY.Person[personid]["�Ṧ"] < JY.Thing[id]["���Ṧ"] then
      return false
    end
    if JY.Person[personid]["�ö�����"] < JY.Thing[id]["���ö�����"] then
      return false
    end
    if JY.Person[personid]["ҽ������"] < JY.Thing[id]["��ҽ������"] then
      return false
    end
    if JY.Person[personid]["�ⶾ����"] < JY.Thing[id]["��ⶾ����"] then
      return false
    end
    

		--�����汾��С���๦���������������ֵ��ÿ������һ��
		local lv = 0;
  	for i=1, 10 do
  		if JY.Person[personid]["�书"..i] == 98 then
  			lv = math.modf(JY.Person[personid]["�书�ȼ�"..i]/100) + 1;
  			break;
  		end
  	end
  	lv = limitX(lv, 0, 10);
    	
		if JY.Person[personid]["ȭ�ƹ���"] + lv < JY.Thing[id]["��ȭ�ƹ���"] then
      return false
    end
    if JY.Person[personid]["��������"] + lv  < JY.Thing[id]["����������"] then
      return false
    end
    if JY.Person[personid]["ˣ������"] + lv  < JY.Thing[id]["��ˣ������"] then
      return false
    end
    if JY.Person[personid]["�������"] + lv < JY.Thing[id]["���������"] then
      return false
    end
    
    
    if JY.Person[personid]["��������"] < JY.Thing[id]["�谵������"] then
      return false
    end

    if JY.Thing[id]["������"] >= 0 then
      if JY.Thing[id]["������"] > JY.Person[personid]["����"] then
          return false;
      end
    else
    	if -JY.Thing[id]["������"] < JY.Person[personid]["����"] then
      	return false;
     	end 
    end
    
    if JY.Person[personid]["����"] == CC.s10 then       --SYP��������
      return false
    end
  end
  
  --��ת����
  if id == 118 then
    local R = JY.Person[personid]
    local wp = R["ȭ�ƹ���"] + R["��������"] + R["ˣ������"] + R["�������"]
    if wp < 120 then
    	return false
  	end
  end
  
  return true
end




--ҩƷʹ��ʵ��Ч��
--id ��Ʒid��
--personid ʹ����id
--����ֵ��0 ʹ��û��Ч������Ʒ����Ӧ�ò��䡣1 ʹ����Ч������ʹ�ú���Ʒ����Ӧ��-1
function UseThingEffect(id,personid)          --ҩƷʹ��ʵ��Ч��
    local str={};
    str[0]=string.format("ʹ�� %s",JY.Thing[id]["����"]);
    local strnum=1;
    local addvalue;

    if JY.Thing[id]["������"] >0 then
        local add=JY.Thing[id]["������"]-math.modf(JY.Person[personid]["���˳̶�"]/2)+Rnd(10);
        if add <=0 then
            add=5+Rnd(5);
        end
        AddPersonAttrib(personid,"���˳̶�",-JY.Thing[id]["������"]/4);
        addvalue,str[strnum]=AddPersonAttrib(personid,"����",add);
        if addvalue ~=0 then
            strnum=strnum+1
        end
    end

    local function ThingAddAttrib(s)     ---����ֲ������������ҩ����������
        if JY.Thing[id]["��" .. s] ~=0 then
            addvalue,str[strnum]=AddPersonAttrib(personid,s,JY.Thing[id]["��" .. s]);
            if addvalue ~=0 then
                strnum=strnum+1
            end
        end
    end

    ThingAddAttrib("�������ֵ");

    if JY.Thing[id]["���ж��ⶾ"] <0 then
        addvalue,str[strnum]=AddPersonAttrib(personid,"�ж��̶�",math.modf(JY.Thing[id]["���ж��ⶾ"]/2));
        if addvalue ~=0 then
            strnum=strnum+1
        end
    end

    ThingAddAttrib("����");

    if JY.Thing[id]["�ı���������"] ==2 then
        str[strnum]="������·��Ϊ������һ"
        strnum=strnum+1
    end

    ThingAddAttrib("����");
    ThingAddAttrib("�������ֵ");
    ThingAddAttrib("������");
    ThingAddAttrib("������");
    ThingAddAttrib("�Ṧ");
    ThingAddAttrib("ҽ������");
    ThingAddAttrib("�ö�����");
    ThingAddAttrib("�ⶾ����");
    ThingAddAttrib("��������");
    ThingAddAttrib("ȭ�ƹ���");
    ThingAddAttrib("��������");
    ThingAddAttrib("ˣ������");
    ThingAddAttrib("�������");
    ThingAddAttrib("��������");
    ThingAddAttrib("��ѧ��ʶ");
    ThingAddAttrib("��������");

    if strnum > 1 then
	    local maxlength = 0
	    for i = 0, strnum-1 do
	      if maxlength < #str[i] then
	        maxlength = #str[i]
	      end
	    end
	    Cls()
	    
	    if JY.Status ~= GAME_WMAP then
		    local ww = maxlength * CC.DefaultFont / 2 + CC.MenuBorderPixel * 2
		    local hh = (strnum) * CC.DefaultFont + (strnum - 1) * CC.RowPixel + 2 * CC.MenuBorderPixel
		    local x = (CC.ScreenW - ww) / 2
		    local y = (CC.ScreenH - hh) / 2
		    DrawBox(x, y, x + ww, y + hh, C_WHITE)
		    DrawString(x + CC.MenuBorderPixel, y + CC.MenuBorderPixel, str[0], C_WHITE, CC.DefaultFont)
		    for i = 1, strnum - 1 do
		      DrawString(x + CC.MenuBorderPixel, y + CC.MenuBorderPixel + (CC.DefaultFont + CC.RowPixel) * i, str[i], C_ORANGE, CC.DefaultFont)
		    end
		    ShowScreen()
		  else
		  	--��ʾ����
		  	War_Show_Count(WAR.CurID);
		  	return 1;
		  end
	    
	    
	    return 1
	  else
	    DrawStrBox(-1, -1, str[0], C_WHITE, CC.DefaultFont)
	    ShowScreen()
	    return 1
	  end

end

--װ����Ʒ
function UseThing_Type1(id)
  DrawStrBox(CC.MainSubMenuX, CC.MainSubMenuY, string.format("˭Ҫ�䱸%s?", JY.Thing[id]["����"]), C_WHITE, CC.DefaultFont)
  local nexty = CC.MainSubMenuY + CC.SingleLineHeight
  local r = SelectTeamMenu(CC.MainSubMenuX, nexty)
  local pp1, pp2 = 0, 0
  if r > 0 then
    local personid = JY.Base["����" .. r]
    if CanUseThing(id, personid) or T2SQ(personid) then
      if JY.Thing[id]["װ������"] == 0 then
        if JY.Thing[id]["ʹ����"] >= 0 then
          if JY.Person[JY.Thing[id]["ʹ����"]]["����"] == JY.SQ then
            JY.Thing[id]["�ӹ�����"] = JY.Thing[id]["�ӹ�����"] / 2
            JY.Thing[id]["�ӷ�����"] = JY.Thing[id]["�ӷ�����"] / 2
            JY.Thing[id]["���Ṧ"] = JY.Thing[id]["���Ṧ"] / 2
          end
          JY.Person[JY.Thing[id]["ʹ����"]]["����"] = -1
        end
        if JY.Person[personid]["����"] >= 0 then
          if T2SQ(personid) then
            JY.Thing[JY.Person[personid]["����"]]["�ӹ�����"] = JY.Thing[JY.Person[personid]["����"]]["�ӹ�����"] / 2
            JY.Thing[JY.Person[personid]["����"]]["�ӷ�����"] = JY.Thing[JY.Person[personid]["����"]]["�ӷ�����"] / 2
            JY.Thing[JY.Person[personid]["����"]]["���Ṧ"] = JY.Thing[JY.Person[personid]["����"]]["���Ṧ"] / 2
          end
          JY.Thing[JY.Person[personid]["����"]]["ʹ����"] = -1
        end
        JY.Person[personid]["����"] = id
        if T2SQ(personid) then
          JY.Thing[id]["�ӹ�����"] = JY.Thing[id]["�ӹ�����"] * 2
          JY.Thing[id]["�ӷ�����"] = JY.Thing[id]["�ӷ�����"] * 2
          JY.Thing[id]["���Ṧ"] = JY.Thing[id]["���Ṧ"] * 2
        end
        
      elseif JY.Thing[id]["װ������"] == 1 then
          if JY.Thing[id]["ʹ����"] >= 0 then
            if JY.Person[JY.Thing[id]["ʹ����"]]["����"] == JY.SQ then
              JY.Thing[id]["�ӹ�����"] = JY.Thing[id]["�ӹ�����"] / 2
              JY.Thing[id]["�ӷ�����"] = JY.Thing[id]["�ӷ�����"] / 2
              JY.Thing[id]["���Ṧ"] = JY.Thing[id]["���Ṧ"] / 2
            end
            JY.Person[JY.Thing[id]["ʹ����"]]["����"] = -1
          end
          if JY.Person[personid]["����"] >= 0 then
            if T2SQ(personid) then
              JY.Thing[JY.Person[personid]["����"]]["�ӹ�����"] = JY.Thing[JY.Person[personid]["����"]]["�ӹ�����"] / 2
              JY.Thing[JY.Person[personid]["����"]]["�ӷ�����"] = JY.Thing[JY.Person[personid]["����"]]["�ӷ�����"] / 2
              JY.Thing[JY.Person[personid]["����"]]["���Ṧ"] = JY.Thing[JY.Person[personid]["����"]]["���Ṧ"] / 2
            end
            JY.Thing[JY.Person[personid]["����"]]["ʹ����"] = -1
          end
          JY.Person[personid]["����"] = id
          if T2SQ(personid) then
		        JY.Thing[id]["�ӹ�����"] = JY.Thing[id]["�ӹ�����"] * 2
		        JY.Thing[id]["�ӷ�����"] = JY.Thing[id]["�ӷ�����"] * 2
		        JY.Thing[id]["���Ṧ"] = JY.Thing[id]["���Ṧ"] * 2
		      end
      end
      JY.Thing[id]["ʹ����"] = personid
    else
    	DrawStrBoxWaitKey("���˲��ʺ��䱸����Ʒ", C_WHITE, CC.DefaultFont)
    	return 0
    end
  end
  return 1
end
--�ؼ���Ʒʹ��
function UseThing_Type2(id)
  if JY.Thing[id]["ʹ����"] >= 0 and DrawStrBoxYesNo(-1, -1, "����Ʒ�Ѿ������������Ƿ�������?", C_WHITE, CC.DefaultFont) == false then
    Cls(CC.MainSubMenuX, CC.MainSubMenuY, CC.ScreenW, CC.ScreenH)
    ShowScreen()
    return 0
  end
  Cls()
  DrawStrBox(CC.MainSubMenuX, CC.MainSubMenuY, string.format("˭Ҫ����%s?", JY.Thing[id]["����"]), C_WHITE, CC.DefaultFont)
  local nexty = CC.MainSubMenuY + CC.SingleLineHeight
  local r = SelectTeamMenu(CC.MainSubMenuX, nexty)
  if r > 0 then
    local personid = JY.Base["����" .. r]
    local yes, full = nil, nil
    if JY.Thing[id]["�����书"] >= 0 then
      yes = 0
      full = 1
      for i = 1, 10 do
        if JY.Person[personid]["�书" .. i] == JY.Thing[id]["�����书"] then
          yes = 1
        else
          if JY.Person[personid]["�书" .. i] == 0 then
            full = 0
          end
        end
      end
    end
    
    --����Ѿ����书����ѡ����书û��ѧ�ᣬ�򲻿�װ������
    if yes == 0 and full == 1 then
      DrawStrBoxWaitKey("һ����ֻ������10���书", C_WHITE, CC.DefaultFont)
      return 0
    end
    
    --��������
    if CC.Shemale[id] == 1 then
      if T1LEQ(personid) or T2SQ(personid) or T3XYK(personid) then		--�������ﲻ����
        say("���������񹦡��ӵ��Թ�")
        say("����̫���˰ɣ��ȿ�����˵....�ȣ�������һҳ��")
        say("���������Թ���Ҳ������")
        say("������ԭ�����Թ�Ҳ����������̫���ˣ�����")
        yes = 2;
      elseif personid == 29 and GetS(86,10,12,5) == 1 then			--�ﲮ�⣬�����˸�֮�󣬲���������������
      	Talk(JY.Thing[id]["����"] .. " �����ⲻ�ʺ���", 29);
      	return 0
    	elseif JY.Person[personid]["�Ա�"] == 0 and CanUseThing(id, personid) then
        Cls(CC.MainSubMenuX, CC.MainSubMenuY, CC.ScreenW, CC.ScreenH)
        if DrawStrBoxYesNo(-1, -1, "������������Ȼӵ��Թ����Ƿ���Ҫ����?", C_WHITE, CC.DefaultFont) == false then
          return 0
        else
	        lib.FillColor(0, 0, CC.ScreenW, CC.ScreenH, C_RED, 128)
	        ShowScreen()
	        lib.Delay(80)
	        lib.ShowSlow(15, 1)
	        Cls()
	        lib.ShowSlow(100, 0)
	        JY.Person[personid]["�Ա�"] = 2
	        local add, str = AddPersonAttrib(personid, "������", -15)
	        DrawStrBoxWaitKey(JY.Person[personid]["����"] .. str, C_ORANGE, CC.DefaultFont)
	        add, str = AddPersonAttrib(personid, "������", -25)
	        DrawStrBoxWaitKey(JY.Person[personid]["����"] .. str, C_ORANGE, CC.DefaultFont)
	      end
      elseif JY.Person[personid]["�Ա�"] == 1 then
        DrawStrBoxWaitKey("���˲��ʺ���������Ʒ", C_WHITE, CC.DefaultFont)
        return 0
      end
    end
    
    if yes == 1 or CanUseThing(id, personid) or  yes == 2 then
      if JY.Thing[id]["ʹ����"] == personid then
        return 0
      end
      if JY.Person[personid]["������Ʒ"] >= 0 then
        JY.Thing[JY.Person[personid]["������Ʒ"]]["ʹ����"] = -1
      end
      if JY.Thing[id]["ʹ����"] >= 0 then
        JY.Person[JY.Thing[id]["ʹ����"]]["������Ʒ"] = -1
        JY.Person[JY.Thing[id]["ʹ����"]]["��Ʒ��������"] = 0
      end
      JY.Thing[id]["ʹ����"] = personid
      JY.Person[personid]["������Ʒ"] = id
      JY.Person[personid]["��Ʒ��������"] = 0
    else
    	DrawStrBoxWaitKey("���˲��ʺ���������Ʒ", C_WHITE, CC.DefaultFont)
    	return 0
    end
  end
  return 1
end
--ҩƷ��Ʒ
function UseThing_Type3(id)
  local usepersonid = -1
  if JY.Status == GAME_MMAP or JY.Status == GAME_SMAP then
    Cls(CC.MainSubMenuX, CC.MainSubMenuY, CC.ScreenW, CC.ScreenH)
    DrawStrBox(CC.MainSubMenuX, CC.MainSubMenuY, string.format("˭Ҫʹ��%s?", JY.Thing[id]["����"]), C_WHITE, CC.DefaultFont)
    local nexty = CC.MainSubMenuY + CC.SingleLineHeight
    local r = SelectTeamMenu(CC.MainSubMenuX, nexty)
    if r > 0 then
      usepersonid = JY.Base["����" .. r]
    end
  elseif JY.Status == GAME_WMAP then
    if WAR.Person[WAR.CurID]["������"] == 16 then
      War_CalMoveStep(WAR.CurID, 8, 1)
      local x, y = War_SelectMove()
      if x ~= nil then
        local emeny = GetWarMap(x, y, 2)
        if emeny >= 0 and WAR.Person[WAR.CurID]["�ҷ�"] == WAR.Person[emeny]["�ҷ�"] then
        	usepersonid = WAR.Person[emeny]["������"]
      	end
      end
    else
    	usepersonid = WAR.Person[WAR.CurID]["������"]
    end
  end
  
  if usepersonid >= 0 then
    if UseThingEffect(id, usepersonid) == 1 then
      instruct_32(id, -1)
      WaitKey()
    end
  else
    return 0
  end
  return 1
end

--������Ʒ
function UseThing_Type4(id)
  if JY.Status == GAME_WMAP then
    return War_UseAnqi(id)
  end
  return 0
end



--------------------------------------------------------------------------------
--------------------------------------�¼�����-----------------------------------

--�¼����������
--id��d*�еı��
--flag 1 �ո񴥷���2����Ʒ������3��·������
function EventExecute(id,flag)               --�¼����������
    JY.CurrentD=id;
    if JY.SceneNewEventFunction[JY.SubScene]==nil then         --û�ж����µ��¼������������þɵ�
        oldEventExecute(flag)
	else
        JY.SceneNewEventFunction[JY.SubScene](flag)         --�����µ��¼�������
    end
    JY.CurrentD=-1;
end

--����ԭ�е�ָ��λ�õĺ���
--�ɵĺ������ָ�ʽΪ  oldevent_xxx();  xxxΪ�¼����
function oldEventExecute(flag)
  local eventnum = nil
  if flag == 1 then
    eventnum = GetD(JY.SubScene, JY.CurrentD, 2)
  elseif flag == 2 then
    eventnum = GetD(JY.SubScene, JY.CurrentD, 3)
  elseif flag == 3 then
    eventnum = GetD(JY.SubScene, JY.CurrentD, 4)
  end
  if eventnum > 0 then
		lib.Debug(eventnum.."");
	end
  if eventnum > 0 then
    if CallCEvent(eventnum) then
      
    else
	  oldCallEvent(eventnum)
    end
  end
end

function existFile(filename)
    local f = io.open(filename)
    if f == nil then
        return false
    end
    io.close(f)
    return true
end

function CallCEvent(eventnum)
  local eventfilename = string.format("%s%d.lua", CONFIG.CEventPath,eventnum)
  if existFile(eventfilename) then
	dofile(eventfilename)
	return true
  else
    return false
  end
end




--�ı���ͼ���꣬�ӳ�����ȥ���ƶ�����Ӧ����
function ChangeMMap(x,y,direct)          --�ı���ͼ����
	JY.Base["��X"]=x;
	JY.Base["��Y"]=y;
	JY.Base["�˷���"]=direct;
end

--�ı䵱ǰ����
function ChangeSMap(sceneid,x,y,direct)       --�ı䵱ǰ����
    JY.SubScene=sceneid;
	JY.Base["��X1"]=x;
	JY.Base["��Y1"]=y;
	JY.Base["�˷���"]=direct;
end


--���(x1,y1)-(x2,y2)�����ڵ����ֵȡ�
--���û�в����������������Ļ����
--ע��ú�������ֱ��ˢ����ʾ��Ļ
function Cls(x1,y1,x2,y2)                    --�����Ļ
    if x1==nil then        --��һ������Ϊnil,��ʾû�в�������ȱʡ
	    x1=0;
		y1=0;
		x2=CC.ScreenW;
		y2=CC.ScreenH;
	end

	lib.SetClip(x1,y1,x2,y2);

	if JY.Status==GAME_START then
	    lib.FillColor(0,0,0,0,0);
        lib.LoadPicture(CC.FirstFile,-1,-1);
	elseif JY.Status==GAME_MMAP then
        lib.DrawMMap(JY.Base["��X"],JY.Base["��Y"],GetMyPic());             --��ʾ����ͼ
	elseif JY.Status==GAME_SMAP then
        DrawSMap();
	elseif JY.Status==GAME_WMAP then
        WarDrawMap(0);
	elseif JY.Status==GAME_DEAD then
	    lib.FillColor(0,0,0,0,0);
        lib.LoadPicture(CC.DeadFile,-1,-1);
	end
	lib.SetClip(0,0,CC.ScreenW,CC.ScreenH);
end


--�����Ի���ʾ��Ҫ���ַ�������ÿ��n�������ַ���һ���Ǻ�
function GenTalkString(str,n)              --�����Ի���ʾ��Ҫ���ַ���
    local tmpstr="";
    for s in string.gmatch(str .. "*","(.-)%*") do           --ȥ���Ի��е�����*. �ַ���β����һ���Ǻţ������޷�ƥ��
        tmpstr=tmpstr .. s;
    end

    local newstr="";
    while #tmpstr>0 do
		local w=0;
		while w<#tmpstr do
		    local v=string.byte(tmpstr,w+1);          --��ǰ�ַ���ֵ
			if v>=128 then
			    w=w+2;
			else
			    w=w+1;
			end
			if w >= 2*n-1 then     --Ϊ�˱����������ַ�
			    break;
			end
		end

        if w<#tmpstr then
		    if w==2*n-1 and string.byte(tmpstr,w+1)<128 then
				newstr=newstr .. string.sub(tmpstr,1,w+1) .. "*";
				tmpstr=string.sub(tmpstr,w+2,-1);
			else
				newstr=newstr .. string.sub(tmpstr,1,w)  .. "*";
				tmpstr=string.sub(tmpstr,w+1,-1);
			end
		else
		    newstr=newstr .. tmpstr;
			break;
		end
	end
    return newstr;
end

--��򵥰汾�Ի�
function Talk(s,personid)            --��򵥰汾�Ի�
    local flag;
    if personid==0 then
        flag=1;
	else
	    flag=0;
	end
	TalkEx(s,JY.Person[personid]["ͷ�����"],flag);
end


--���Ӱ汾�Ի�
--s �ַ������������*��Ϊ���У��������û��*,����Զ�����
function TalkEx(s,headid,flag)          --���Ӱ汾�Ի�
  local picw = CC.PortraitPicWidth
  local pich = CC.PortraitPicHeight
  local talkxnum = 18
  local talkynum = 3
  local dx=2 * CC.Scale;
  local dy=2 * CC.Scale;
  local boxpicw = picw + 10 * CC.Scale
  local boxpich = pich + 10 * CC.Scale
  local boxtalkw = 12 * CC.DefaultFont + 10
  local boxtalkh = boxpich
  local talkBorder = (boxtalkh - talkynum * CC.DefaultFont) / (talkynum + 1)
  local xy = {
{headx = CC.ScreenW - 1 - dx - boxpicw, heady = CC.ScreenH - dy - boxpich, talkx = CC.ScreenW - 1 - dx - boxpicw - boxtalkw - 2, talky = CC.ScreenH - dy - boxpich, showhead = 1}, 
{headx = dx, heady = dy, talkx = dx + boxpicw + 2, talky = dy, showhead = 0}, 
{headx = CC.ScreenW - 1 - dx - boxpicw, heady = CC.ScreenH - dy - boxpich, talkx = CC.ScreenW - 1 - dx - boxpicw - boxtalkw - 2, talky = CC.ScreenH - dy - boxpich, showhead = 1}, 
{headx = CC.ScreenW - 1 - dx - boxpicw, heady = dy, talkx = CC.ScreenW - 1 - dx - boxpicw - boxtalkw - 2, talky = dy, showhead = 1}, 
{headx = dx, heady = CC.ScreenH - dy - boxpich, talkx = dx + boxpicw + 2, talky = CC.ScreenH - dy - boxpich, showhead = 1}; 
[0] = {headx = dx, heady = dy, talkx = dx + boxpicw + 2, talky = dy, showhead = 1}}
  if flag < 0 or flag > 5 then
    flag = 0
  end
  if xy[flag].showhead == 0 then
    headid = -1
  end
  if string.find(s, "*") == nil then
    s = GenTalkString(s, 12)
  end
  if CONFIG.KeyRepeat == 0 then
    lib.EnableKeyRepeat(0, CONFIG.KeyRepeatInterval)
  end
  lib.GetKey()
  local startp = 1
  local endp = nil
  local dy = 0
  while 1 do
    if dy == 0 then
      Cls()
      if headid >= 0 then
        if headid > 243 and headid < 249 then
          headid = 0
        end
        if headid == 0 then
          if GetS(4, 5, 5, 5) < 8 then
            headid = 280 + GetS(4, 5, 5, 5)
          else
	          headid = 287 + GetS(4, 5, 5, 4)
	        end
        end
        DrawBox(xy[flag].headx, xy[flag].heady, xy[flag].headx + boxpicw, xy[flag].heady + boxpich, C_WHITE)
        --local w, h = lib.PicGetXY(1, (headid) * 2)
				local w, h = lib.GetPNGXY(1, (headid)*2)
        local x = (boxpicw - w)/2
        local y = boxpich - h - 2
        --lib.PicLoadCache(1, (headid) * 2, xy[flag].headx + 5 + x, xy[flag].heady + 5 + y, 1)
				lib.LoadPNG(1, (headid)*2, xy[flag].headx + x, xy[flag].heady + y, 1)
        if headid > 0 and headid < 190 then
          local offset = (boxpicw - (string.len(JY.Person[headid]["����"]) * CC.DefaultFont)/2)/2;
	        DrawString(xy[flag].headx + 5 + offset, xy[flag].heady + boxpich-CC.DefaultFont - dy, JY.Person[headid]["����"], C_GOLD, CC.DefaultFont)
	      end
	      DrawBox(xy[flag].talkx, xy[flag].talky, xy[flag].talkx + boxtalkw, xy[flag].talky + boxtalkh, C_WHITE)
      end
      
    end
    
    endp = string.find(s, "*", startp)
    if endp == nil then
      DrawString(xy[flag].talkx + 5, xy[flag].talky + talkBorder + dy * (CC.DefaultFont + talkBorder), string.sub(s, startp), C_WHITE, CC.DefaultFont)
      ShowScreen()
      WaitKey()
      break;
    else
      DrawString(xy[flag].talkx + 5, xy[flag].talky + talkBorder + dy * (CC.DefaultFont + talkBorder), string.sub(s, startp, endp - 1), C_WHITE, CC.DefaultFont)
    end
    dy = dy + 1
    startp = endp + 1
    if talkynum <= dy then
      ShowScreen()
      WaitKey()
      dy = 0
    end
  end
  if CONFIG.KeyRepeat == 0 then
    lib.EnableKeyRepeat(CONFIG.KeyRepeatDelay, CONFIG.KeyRepeatInterval)
  end
  Cls()
end

--����ָ�ռλ����
function instruct_test(s)
    DrawStrBoxWaitKey(s,C_ORANGE,24);
end

--����
function instruct_0()         --����
    Cls();
end

function ReadTalk(id, flag)
  local tidx = Byte.create(id * 4 + 4)
  Byte.loadfile(tidx, CC.TDX, 0, id * 4 + 4)
  local idx1, idx2 = nil, nil
  if id < 1 then
    idx1 = 0
  else
    idx1 = Byte.get32(tidx, (id - 1) * 4)
  end
  idx2 = Byte.get32(tidx, id * 4)
  local len = idx2 - idx1
  local talk = Byte.create(len)
  Byte.loadfile(talk, CC.TRP, idx1, len)
  local str = ""
  for i = 0, len - 2 do
    local byte = Byte.getu16(talk, i)
    byte = 255 - math.fmod(byte, 256)
    str = str .. string.char(byte)
  end
  if flag == nil then
    str = lib.CharSet(str, 0)
    str = GenTalkString(str, 12)
  end
  return str
end

--�Ի�
--talkid: Ϊ���֣���Ϊ�Ի���ţ�Ϊ�ַ�������Ϊ�Ի�����
--headid: ͷ��id
--flag :�Ի���λ�ã�0 ��Ļ�Ϸ���ʾ, ���ͷ���ұ߶Ի�
--            1 ��Ļ�·���ʾ, ��߶Ի����ұ�ͷ��
--            2 ��Ļ�Ϸ���ʾ, ��߿գ��ұ߶Ի�
--            3 ��Ļ�·���ʾ, ��߶Ի����ұ߿�
--            4 ��Ļ�Ϸ���ʾ, ��߶Ի����ұ�ͷ��
--            5 ��Ļ�·���ʾ, ���ͷ���ұ߶Ի�

function instruct_1(talkid, headid, flag)
  local s = ReadTalk(talkid)
  if s == nil then
    return 
  end
  TalkEx(s, headid, flag)
end

--����oldtalk.grp�ļ���idx�����ļ�����������Ի�ʹ��
function GenTalkIdx()         --���ɶԻ������ļ�
	
end




--�õ���Ʒ
function instruct_2(thingid, num)
  if JY.Thing[thingid] == nil then
    return 
  end
  instruct_32(thingid, num)
  if num > 0 then
    DrawStrBoxWaitKey(string.format("�õ���Ʒ:%s %d", JY.Thing[thingid]["����"], num), C_ORANGE, CC.DefaultFont)
  else
    DrawStrBoxWaitKey(string.format("ʧȥ��Ʒ:%s %d", JY.Thing[thingid]["����"], -num), C_ORANGE, CC.DefaultFont)
  end
  instruct_2_sub()
end


function instruct_2_sub()
  if JY.Person[0]["����"] < 200 then
    return 
  end
  if instruct_18(189) == true then
    return 
  end
  local booknum = 0
  for i = 1, CC.BookNum do
    if instruct_18(CC.BookStart + i - 1) == true then
      booknum = booknum + 1
    end
  end
  if booknum == CC.BookNum then
    instruct_3(70, 11, -1, 1, 932, -1, -1, 7968, 7968, 7968, -2, -2, -2)
  end
end

function instruct_3(sceneid, id, v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10)
  if sceneid == -2 then
    sceneid = JY.SubScene
  end
  if id == -2 then
    id = JY.CurrentD
  end
  if v0 ~= -2 then
    SetD(sceneid, id, 0, v0)
  end
  if v1 ~= -2 then
    SetD(sceneid, id, 1, v1)
  end
  if v2 ~= -2 then
    SetD(sceneid, id, 2, v2)
  end
  if v3 ~= -2 then
    SetD(sceneid, id, 3, v3)
  end
  if v4 ~= -2 then
    SetD(sceneid, id, 4, v4)
  end
  if v5 ~= -2 then
    SetD(sceneid, id, 5, v5)
  end
  if v6 ~= -2 then
    SetD(sceneid, id, 6, v6)
  end
  if v7 ~= -2 then
    SetD(sceneid, id, 7, v7)
  end
  if v8 ~= -2 then
    SetD(sceneid, id, 8, v8)
  end
  if v9 ~= -2 and v10 ~= -2 and v9 > 0 and v10 > 0 then
    SetS(sceneid, GetD(sceneid, id, 9), GetD(sceneid, id, 10), 3, -1)
    SetD(sceneid, id, 9, v9)
    SetD(sceneid, id, 10, v10)
    SetS(sceneid, GetD(sceneid, id, 9), GetD(sceneid, id, 10), 3, id)
  end
end


function instruct_4(thingid)
  if JY.CurrentThing == thingid then
    return true
  else
    return false
  end
end

function instruct_5()
  return DrawStrBoxYesNo(-1, -1, "�Ƿ���֮����(Y/N)?", C_ORANGE, CC.DefaultFont)
end

function instruct_6(warid, tmp, tmp, flag)
  return WarMain(warid, flag)
end

function instruct_7()
  instruct_test("ָ��7����")
end

function instruct_8(musicid)
  JY.MmapMusic = musicid
end

function instruct_9()
  return DrawStrBoxYesNo(-1, -1, "�Ƿ�Ҫ�����(Y/N)?", C_ORANGE, CC.DefaultFont)
end

function instruct_10(personid)
  if JY.Person[personid] == nil then
    lib.Debug("instruct_10 error: person id not exist")
    return 
  end
  local add = 0
  for i = 2, CC.TeamNum do
    if JY.Base["����" .. i] < 0 then
      JY.Base["����" .. i] = personid
      add = 1
      break;
    end
  end
  if add == 0 then
    lib.Debug("instruct_10 error: �����������")
    return 
  end
  for i = 1, 4 do
    local id = JY.Person[personid]["Я����Ʒ" .. i]
    local n = JY.Person[personid]["Я����Ʒ����" .. i]
    if n < 0 then
      n = 0
    end
    if id >= 0 and n > 0 then
      instruct_2(id, n)
      JY.Person[personid]["Я����Ʒ" .. i] = -1
      JY.Person[personid]["Я����Ʒ����" .. i] = 0
    end
  end
end

function instruct_11()
  return DrawStrBoxYesNo(-1, -1, "�Ƿ�(Y/N)?", C_ORANGE, CC.DefaultFont)
end

function instruct_12(flag)
  for i = 1, CC.TeamNum do
    local id = JY.Base["����" .. i]
    if id >= 0 then
      JY.Person[id]["���˳̶�"] = 0
      JY.Person[id]["�ж��̶�"] = 0
      AddPersonAttrib(id, "����", math.huge)
      AddPersonAttrib(id, "����", math.huge)
      AddPersonAttrib(id, "����", math.huge)
    end
  end
end

function instruct_13()
  Cls()
  JY.Darkness = 0
  lib.ShowSlow(40, 0)
  lib.GetKey()
end

function instruct_14()
  lib.ShowSlow(40, 1)
  JY.Darkness = 1
end

function instruct_15()
  JY.Status = GAME_DEAD
  Cls()
  DrawString(CC.GameOverX, CC.GameOverY, JY.Person[0]["����"], RGB(0, 0, 0), CC.DefaultFont)
  local x = CC.ScreenW - 9 * CC.DefaultFont
  DrawString(x, 10, os.date("%Y-%m-%d %H:%M"), RGB(216, 20, 24), CC.DefaultFont)
  DrawString(x, 10 + CC.DefaultFont + CC.RowPixel, "�ڵ����ĳ��", RGB(216, 20, 24), CC.DefaultFont)
  DrawString(x, 10 + (CC.DefaultFont + CC.RowPixel) * 2, "�����˿ڵ�ʧ����", RGB(216, 20, 24), CC.DefaultFont)
  DrawString(x, 10 + (CC.DefaultFont + CC.RowPixel) * 3, "�ֶ���һ�ʡ�����", RGB(216, 20, 24), CC.DefaultFont)
  ShowScreen();
  local loadMenu = {
{"ѡ�����", nil, 1},  
{"�ؼ�˯��ȥ", nil, 1}}
  local y = CC.ScreenH - 4 * (CC.DefaultFont + CC.RowPixel) - 10
  local sl = ShowMenu(loadMenu, #loadMenu, 0, x, y, 0, 0, 0, 0, CC.DefaultFont, C_ORANGE, C_WHITE)
  if sl ==1 then
     local r = SaveList();
    	if r < 1 then
    		--JY.Status = GAME_END
    		instruct_15();
    		return 0;
    	end
    	
    	Cls();
			DrawStrBox(-1,CC.StartMenuY,"���Ժ�...",C_GOLD,CC.DefaultFont);
			ShowScreen();
    	local result = LoadRecord(r);
    	if result ~= nil then
    		instruct_15();
    		return 0;
    	end
    if JY.Base["����"] ~= -1 then
      JY.Status = GAME_SMAP
      JY.SubScene = JY.Base["����"]
      JY.MmapMusic = -1
      JY.MyPic = GetMyPic()
      Init_SMap(1)
    else
      JY.SubScene = -1
      JY.Status = GAME_FIRSTMMAP
    end
    ShowScreen()
    lib.LoadPicture("", 0, 0)
    lib.GetKey()
    Game_Cycle()
  else
    JY.Status = GAME_END
  end
end

function inteam(pid)
  return instruct_16(pid)
end

function instruct_16(personid)
  local r = false
  for i = 1, CC.TeamNum do
    if personid == JY.Base["����" .. i] then
      r = true
      break;
    end
  end
  return r
end

function instruct_17(sceneid, level, x, y, v)
  if sceneid == -2 then
    sceneid = JY.SubScene
  end
  SetS(sceneid, x, y, level, v)
end

function instruct_18(thingid)
  for i = 1, CC.MyThingNum do
    if JY.Base["��Ʒ" .. i] == thingid then
      return true
    end
  end
  return false
end

function instruct_19(x, y)
  JY.Base["��X1"] = x
  JY.Base["��Y1"] = y
  JY.SubSceneX = 0
  JY.SubSceneY = 0
end

function instruct_20()
  if JY.Base["����" .. CC.TeamNum] >= 0 then
    return true
  end
  return false
end

function instruct_21(personid)
  if JY.Person[personid] == nil then
    lib.Debug("instruct_21 error: personid not exist")
    return 
  end
  local j = 0
  for i = 1, CC.TeamNum do
    if personid == JY.Base["����" .. i] then
      j = i
    end
  end
  if j == 0 then
    return 
  end
  for i = j + 1, CC.TeamNum do
    JY.Base["����" .. i - 1] = JY.Base["����" .. i]
  end
  JY.Base["����" .. CC.TeamNum] = -1
  if JY.Person[personid]["����"] >= 0 then
    JY.Thing[JY.Person[personid]["����"]]["ʹ����"] = -1
    JY.Person[personid]["����"] = -1
  end
  if JY.Person[personid]["����"] >= 0 then
    JY.Thing[JY.Person[personid]["����"]]["ʹ����"] = -1
    JY.Person[personid]["����"] = -1
  end
  if JY.Person[personid]["������Ʒ"] >= 0 then
    JY.Thing[JY.Person[personid]["������Ʒ"]]["ʹ����"] = -1
    JY.Person[personid]["������Ʒ"] = -1
  end
  JY.Person[personid]["��Ʒ��������"] = 0
end

function instruct_22()
  for i = 1, CC.TeamNum do
    if JY.Base["����" .. i] >= 0 then
      JY.Person[JY.Base["����" .. i]]["����"] = 0
    end
  end
end

function instruct_23(personid, value)
  JY.Person[personid]["�ö�����"] = value
  AddPersonAttrib(personid, "�ö�����", 0)
end

function instruct_24()
  instruct_test("ָ��24����")
end

function instruct_25(x1, y1, x2, y2)
  local sign = nil
  if y1 ~= y2 then
    if y2 < y1 then
      sign = -1
    else
      sign = 1
    end
    for i = y1 + sign, y2, sign do
      local t1 = lib.GetTime()
      JY.SubSceneY = JY.SubSceneY + sign
      DrawSMap()
      ShowScreen()
      local t2 = lib.GetTime()
      if t2 - t1 < CC.SceneMoveFrame then
        lib.Delay(CC.SceneMoveFrame - (t2 - t1))
      end
    end
  end
  if x1 ~= x2 then
    if x2 < x1 then
      sign = -1
    else
      sign = 1
    end
    for i = x1 + sign, x2, sign do
      local t1 = lib.GetTime()
      JY.SubSceneX = JY.SubSceneX + sign
      DrawSMap()
      ShowScreen()
      local t2 = lib.GetTime()
      if t2 - t1 < CC.SceneMoveFrame then
        lib.Delay(CC.SceneMoveFrame - (t2 - t1))
      end
    end
  end
end

function instruct_26(sceneid, id, v1, v2, v3)
  if sceneid == -2 then
    sceneid = JY.SubScene
  end
  local v = GetD(sceneid, id, 2)
  SetD(sceneid, id, 2, v + v1)
  v = GetD(sceneid, id, 3)
  SetD(sceneid, id, 3, v + v2)
  v = GetD(sceneid, id, 4)
  SetD(sceneid, id, 4, v + v3)
end

function instruct_27(id, startpic, endpic)
  local old1, old2, old3 = nil
  if id ~= -1 then
    old1 = GetD(JY.SubScene, id, 5)
    old2 = GetD(JY.SubScene, id, 6)
    old3 = GetD(JY.SubScene, id, 7)
  end
  for i = startpic, endpic, 2 do
    local t1 = lib.GetTime()
    if id == -1 then
      JY.MyPic = i / 2
    else
      SetD(JY.SubScene, id, 5, i)
      SetD(JY.SubScene, id, 6, i)
      SetD(JY.SubScene, id, 7, i)
    end
    DtoSMap()
    DrawSMap()
    ShowScreen()
    local t2 = lib.GetTime()
    if t2 - t1 < CC.AnimationFrame then
      lib.Delay(CC.AnimationFrame - (t2 - t1))
    end
  end
  if id ~= -1 then
    SetD(JY.SubScene, id, 5, old1)
    SetD(JY.SubScene, id, 6, old2)
    SetD(JY.SubScene, id, 7, old3)
  end
end

function instruct_28(personid, vmin, vmax)
  local v = JY.Person[personid]["Ʒ��"]
  if vmin <= v and v <= vmax then
    return true
  else
    return false
  end
end

function instruct_29(personid, vmin, vmax)
  local v = JY.Person[personid]["������"]
  if vmin <= v and v <= vmax then
    return true
  else
    return false
  end
end

function instruct_30(x1, y1, x2, y2)
  if x1 < x2 then
    for i = x1 + 1, x2 do
      local t1 = lib.GetTime()
      instruct_30_sub1(1)
      local t2 = lib.GetTime()
      if t2 - t1 < CC.PersonMoveFrame then
        lib.Delay(CC.PersonMoveFrame - (t2 - t1))
      end
    end
  elseif x2 < x1 then
    for i = x2 + 1, x1 do
      local t1 = lib.GetTime()
      instruct_30_sub1(2)
      local t2 = lib.GetTime()
      if t2 - t1 < CC.PersonMoveFrame then
        lib.Delay(CC.PersonMoveFrame - (t2 - t1))
      end
    end
  end
  if y1 < y2 then
    for i = y1 + 1, y2 do
      local t1 = lib.GetTime()
      instruct_30_sub1(3)
      local t2 = lib.GetTime()
      if t2 - t1 < CC.PersonMoveFrame then
        lib.Delay(CC.PersonMoveFrame - (t2 - t1))
      end
    end
  elseif y2 < y1 then
    for i = y2 + 1, y1 do
      local t1 = lib.GetTime()
      instruct_30_sub1(0)
      local t2 = lib.GetTime()
      if t2 - t1 < CC.PersonMoveFrame then
        lib.Delay(CC.PersonMoveFrame - (t2 - t1))
      end
    end
  end
end

function instruct_30_sub1(direct)
  local x, y = nil, nil
  AddMyCurrentPic()
  x = JY.Base["��X1"] + CC.DirectX[direct + 1]
  y = JY.Base["��Y1"] + CC.DirectY[direct + 1]
  JY.Base["�˷���"] = direct
  JY.MyPic = GetMyPic()
  DtoSMap()
  if SceneCanPass(x, y) == true then
    JY.Base["��X1"] = x
    JY.Base["��Y1"] = y
  end
  JY.Base["��X1"] = limitX(JY.Base["��X1"], 1, CC.SWidth - 2)
  JY.Base["��Y1"] = limitX(JY.Base["��Y1"], 1, CC.SHeight - 2)
  DrawSMap()
  ShowScreen()
  return 1
end

function instruct_30_sub(direct)
  local x, y = nil, nil
  local d_pass = GetS(JY.SubScene, JY.Base["��X1"], JY.Base["��Y1"], 3)

  if d_pass >= 0 and d_pass ~= JY.OldDPass then
    EventExecute(d_pass, 3)
    JY.OldDPass = d_pass
    JY.oldSMapX = -1
    JY.oldSMapY = -1
    JY.D_Valid = nil
  end

  JY.OldDPass = -1
  local isout = 0
  if (((JY.Scene[JY.SubScene]["����X1"] == JY.Base["��X1"] and JY.Scene[JY.SubScene]["����Y1"] == JY.Base["��Y1"]) or JY.Scene[JY.SubScene]["����X2"] ~= JY.Base["��X1"] or JY.Scene[JY.SubScene]["����Y2"] == JY.Base["��Y1"] or JY.Scene[JY.SubScene]["����X3"] == JY.Base["��X1"] and JY.Scene[JY.SubScene]["����Y3"] == JY.Base["��Y1"])) then
    isout = 1
  end
  if isout == 1 then
    JY.Status = GAME_MMAP
    lib.PicInit()
    CleanMemory()
    lib.ShowSlow(50, 1)
    if JY.MmapMusic < 0 then
      JY.MmapMusic = JY.Scene[JY.SubScene]["��������"]
    end
    Init_MMap()
    JY.SubScene = -1
    JY.oldSMapX = -1
    JY.oldSMapY = -1
    lib.DrawMMap(JY.Base["��X"], JY.Base["��Y"], GetMyPic())
    lib.ShowSlow(50, 0)
    lib.GetKey()
    return 
  end
  if JY.Scene[JY.SubScene]["��ת����"] >= 0 and JY.Base["��X1"] == JY.Scene[JY.SubScene]["��ת��X1"] and JY.Base["��Y1"] == JY.Scene[JY.SubScene]["��ת��Y1"] then
    JY.SubScene = JY.Scene[JY.SubScene]["��ת����"]
    lib.ShowSlow(50, 1)
    if JY.Scene[JY.SubScene]["�⾰���X1"] == 0 and JY.Scene[JY.SubScene]["�⾰���Y1"] == 0 then
      JY.Base["��X1"] = JY.Scene[JY.SubScene]["���X"]
      JY.Base["��Y1"] = JY.Scene[JY.SubScene]["���Y"]
    else
      JY.Base["��X1"] = JY.Scene[JY.SubScene]["��ת��X2"]
      JY.Base["��Y1"] = JY.Scene[JY.SubScene]["��ת��Y2"]
    end
    Init_SMap(1)
    return 
  end
  AddMyCurrentPic()
  x = JY.Base["��X1"] + CC.DirectX[direct + 1]
  y = JY.Base["��Y1"] + CC.DirectY[direct + 1]
  JY.Base["�˷���"] = direct
  JY.MyPic = GetMyPic()
  DtoSMap()
  if SceneCanPass(x, y) == true then
    JY.Base["��X1"] = x
    JY.Base["��Y1"] = y
  end
  JY.Base["��X1"] = limitX(JY.Base["��X1"], 1, CC.SWidth - 2)
  JY.Base["��Y1"] = limitX(JY.Base["��Y1"], 1, CC.SHeight - 2)
  DrawSMap()
  ShowScreen()
  return 1
end

function instruct_31(num)
  local r = false
  for i = 1, CC.MyThingNum do
    if JY.Base["��Ʒ" .. i] == CC.MoneyID and num <= JY.Base["��Ʒ����" .. i] then
      r = true
    end
  end
  return r
end

function instruct_32(thingid, num)
  local p = 1
  for i = 1, CC.MyThingNum do
    if JY.Base["��Ʒ" .. i] == thingid then
      JY.Base["��Ʒ����" .. i] = JY.Base["��Ʒ����" .. i] + num
      p = i
      break;
    elseif JY.Base["��Ʒ" .. i] == -1 then
      JY.Base["��Ʒ" .. i] = thingid
      JY.Base["��Ʒ����" .. i] = num
      p = i
      break;
    end
  end
  if thingid == CC.MoneyID then
    JY.GOLD = JY.GOLD + num
  end
  
  
  --������飬����15������
  if thingid >= CC.BookStart and thingid < CC.BookStart + CC.BookNum then
  	JY.Person[JY.MY]["����"] = JY.Person[JY.MY]["����"] + 15;
  end
  
  
  if JY.Base["��Ʒ����" .. p] <= 0 then
    for i = p + 1, CC.MyThingNum do
      JY.Base["��Ʒ" .. i - 1] = JY.Base["��Ʒ" .. i]
      JY.Base["��Ʒ����" .. i - 1] = JY.Base["��Ʒ����" .. i]
    end
    JY.Base["��Ʒ" .. CC.MyThingNum] = -1
    JY.Base["��Ʒ����" .. CC.MyThingNum] = 0
  end
end

--����ѧ���书
function instruct_33(personid, wugongid, flag)
  local add = 0
  for i = 1, 10 do
    if JY.Person[personid]["�书" .. i] == 0 then
      JY.Person[personid]["�书" .. i] = wugongid
      JY.Person[personid]["�书�ȼ�" .. i] = 0
      add = 1
      break;
    end
  end
  if add == 0 then
    JY.Person[personid]["�书10"] = wugongid
    JY.Person[personid]["�书�ȼ�10"] = 0
  end
  if flag == 0 then
    DrawStrBoxWaitKey(string.format("%s ѧ���书 %s", JY.Person[personid]["����"], JY.Wugong[wugongid]["����"]), C_ORANGE, CC.DefaultFont)
  end
end

function instruct_34(id, value)
  local add, str = AddPersonAttrib(id, "����", value)
  DrawStrBoxWaitKey(JY.Person[id]["����"] .. str, C_ORANGE, CC.DefaultFont)
end


function instruct_35(personid, id, wugongid, wugonglevel)
  if id >= 0 then
    JY.Person[personid]["�书" .. id + 1] = wugongid
    JY.Person[personid]["�书�ȼ�" .. id + 1] = wugonglevel
  else
    local flag = 0
    for i = 1, 10 do
      if JY.Person[personid]["�书" .. i] == 0 then
        flag = 1
        JY.Person[personid]["�书" .. i] = wugongid
        JY.Person[personid]["�书�ȼ�" .. i] = wugonglevel
        return 
      end
    end
    if flag == 0 then
    	JY.Person[personid]["�书" .. 1] = wugongid
    	JY.Person[personid]["�书�ȼ�" .. 1] = wugonglevel
  	end
  end
  
end

function instruct_36(sex)
  if JY.Person[0]["�Ա�"] == sex then
    return true
  else
    return false
  end
end

function instruct_37(v)
  AddPersonAttrib(0, "Ʒ��", v)
end

function instruct_38(sceneid, level, oldpic, newpic)
  if sceneid == -2 then
    sceneid = JY.SubScene
  end
  for i = 0, CC.SWidth - 1 do
    for j = 1, CC.SHeight - 1 do
      if GetS(sceneid, i, j, level) == oldpic then
        SetS(sceneid, i, j, level, newpic)
      end
    end
  end
end

function instruct_39(sceneid)
  JY.Scene[sceneid]["��������"] = 0
end

function instruct_40(v)
  JY.Base["�˷���"] = v
  JY.MyPic = GetMyPic()
end

function instruct_41(personid, thingid, num)
  local k = 0
  for i = 1, 4 do
    if JY.Person[personid]["Я����Ʒ" .. i] == thingid then
      JY.Person[personid]["Я����Ʒ����" .. i] = JY.Person[personid]["Я����Ʒ����" .. i] + num
      k = i
      break;
    end
  end
  if k > 0 and JY.Person[personid]["Я����Ʒ����" .. k] <= 0 then
    JY.Person[personid]["Я����Ʒ" .. k] = -1
  end
  if k == 0 then
    for i = 1, 4 do
      if JY.Person[personid]["Я����Ʒ" .. i] == -1 then
        JY.Person[personid]["Я����Ʒ" .. i] = thingid
        JY.Person[personid]["Я����Ʒ����" .. i] = num
        break;
      end
    end
  end
end

function instruct_42()
  local r = false
  for i = 1, CC.TeamNum do
    if JY.Base["����" .. i] >= 0 and JY.Person[JY.Base["����" .. i]]["�Ա�"] == 1 then
      r = true
    end
  end
  return r
end

function instruct_43(thingid)
  return instruct_18(thingid)
end

function instruct_44(id1, startpic1, endpic1, id2, startpic2, endpic2)
  local old1 = GetD(JY.SubScene, id1, 5)
  local old2 = GetD(JY.SubScene, id1, 6)
  local old3 = GetD(JY.SubScene, id1, 7)
  local old4 = GetD(JY.SubScene, id2, 5)
  local old5 = GetD(JY.SubScene, id2, 6)
  local old6 = GetD(JY.SubScene, id2, 7)
  for i = startpic1, endpic1, 2 do
    local t1 = lib.GetTime()
    if id1 == -1 then
      JY.MyPic = i / 2
    else
      SetD(JY.SubScene, id1, 5, i)
      SetD(JY.SubScene, id1, 6, i)
      SetD(JY.SubScene, id1, 7, i)
    end
    if id2 == -1 then
      JY.MyPic = i / 2
    else
      SetD(JY.SubScene, id2, 5, i - startpic1 + startpic2)
      SetD(JY.SubScene, id2, 6, i - startpic1 + startpic2)
      SetD(JY.SubScene, id2, 7, i - startpic1 + startpic2)
    end
    DtoSMap()
    DrawSMap()
    ShowScreen()
    local t2 = lib.GetTime()
    if t2 - t1 < CC.AnimationFrame then
      lib.Delay(CC.AnimationFrame - (t2 - t1))
    end
  end
  SetD(JY.SubScene, id1, 5, old1)
  SetD(JY.SubScene, id1, 6, old2)
  SetD(JY.SubScene, id1, 7, old3)
  SetD(JY.SubScene, id2, 5, old4)
  SetD(JY.SubScene, id2, 6, old5)
  SetD(JY.SubScene, id2, 7, old6)
end


function instruct_45(id, value)
   local add, str = AddPersonAttrib(id, "�Ṧ", value)
end

function instruct_46(id, value)
  local add, str = AddPersonAttrib(id, "�������ֵ", value)
  AddPersonAttrib(id, "����", 0)
end

function instruct_47(id, value)
  local add, str = AddPersonAttrib(id, "������", value)
end

function instruct_48(id, value)
   local add, str = AddPersonAttrib(id, "�������ֵ", value)
  AddPersonAttrib(id, "����", 0)
end

function instruct_49(personid, value)
  JY.Person[personid]["��������"] = value
end

function instruct_50(id1, id2, id3, id4, id5)
  local num = 0
  if instruct_18(id1) == true then
    num = num + 1
  end
  if instruct_18(id2) == true then
    num = num + 1
  end
  if instruct_18(id3) == true then
    num = num + 1
  end
  if instruct_18(id4) == true then
    num = num + 1
  end
  if instruct_18(id5) == true then
    num = num + 1
  end
  if num == 5 then
    return true
  else
    return false
  end
end

function instruct_51()
  instruct_1(2547 + Rnd(18), 114, 0)
end

function instruct_52()
  DrawStrBoxWaitKey(string.format("�����ڵ�Ʒ��ָ��Ϊ: %d", JY.Person[0]["Ʒ��"]), C_ORANGE, CC.DefaultFont)
end

function instruct_53()
  DrawStrBoxWaitKey(string.format("�����ڵ�����ָ��Ϊ: %d", JY.Person[0]["����"]), C_ORANGE, CC.DefaultFont)
end

function instruct_54()
  for i = 0, JY.SceneNum - 1 do
    JY.Scene[i]["��������"] = 0
  end
  JY.Scene[2]["��������"] = 2
  JY.Scene[38]["��������"] = 2
  JY.Scene[75]["��������"] = 1
  JY.Scene[80]["��������"] = 1
end

function instruct_55(id, num)
  if GetD(JY.SubScene, id, 2) == num then
    return true
  else
    return false
  end
end

function instruct_56(v)
  --JY.Person[0]["����"] = JY.Person[0]["����"] + v
  instruct_2_sub()
end

function instruct_57()
  instruct_27(-1, 7664, 7674)
  for i = 0, 56, 2 do
    local t1 = lib.GetTime()
    if JY.MyPic < 3844 then
      JY.MyPic = (7676 + i) / 2
    end
    SetD(JY.SubScene, 2, 5, i + 7690)
    SetD(JY.SubScene, 2, 6, i + 7690)
    SetD(JY.SubScene, 2, 7, i + 7690)
    SetD(JY.SubScene, 3, 5, i + 7748)
    SetD(JY.SubScene, 3, 6, i + 7748)
    SetD(JY.SubScene, 3, 7, i + 7748)
    SetD(JY.SubScene, 4, 5, i + 7806)
    SetD(JY.SubScene, 4, 6, i + 7806)
    SetD(JY.SubScene, 4, 7, i + 7806)
    DtoSMap()
    DrawSMap()
    ShowScreen()
    local t2 = lib.GetTime()
    if t2 - t1 < CC.AnimationFrame then
      lib.Delay(CC.AnimationFrame - (t2 - t1))
    end
  end
end

function instruct_58()
  local group = 5
  local num1 = 6
  local num2 = 3
  local startwar = 102
  local flag = {}
  for i = 0, group - 1 do
    for j = 0, num1 - 1 do
      flag[j] = 0
    end
    for j = 1, num2 do
      local r = nil
      while 1 do
        r = Rnd(num1)
        if flag[r] == 0 then
          flag[r] = 1
          do break end
        end
      end
      local warnum = r + i * num1
      WarLoad(warnum + startwar)
      instruct_1(2854 + warnum, JY.Person[WAR.Data["����1"]]["ͷ�����"], 0)
      instruct_0()
      if WarMain(warnum + startwar, 0) == true then
        instruct_0()
        instruct_13()
        TalkEx("������λǰ���ϴͽ̣�", 0, 1)
        instruct_0()
      else
        instruct_15()
        return 
      end
    end
    if i < group - 1 then
      TalkEx("��������ս������*������Ϣ��ս��", 70, 0)
      instruct_0()
      instruct_14()
      lib.Delay(300)
      if JY.Person[0]["���˳̶�"] < 50 and JY.Person[0]["�ж��̶�"] <= 0 then
        JY.Person[0]["���˳̶�"] = 0
        AddPersonAttrib(0, "����", math.huge)
        AddPersonAttrib(0, "����", math.huge)
        AddPersonAttrib(0, "����", math.huge)
      end
      instruct_13()
      TalkEx("���Ѿ���Ϣ���ˣ�*��˭Ҫ���ϣ�", 0, 1)
      instruct_0()
    end
  end
  TalkEx("��������˭��**��������*��������***û��������", 0, 1)
  instruct_0()
  TalkEx("�����û����Ҫ��������λ*������ս���������书����*��һ֮������������֮λ��*������λ������ã�***������������*������������*������������*�ã���ϲ����������������*֮λ����������ã������*���������ȡ�Ҳ���㱣�ܣ�", 70, 0)
  instruct_0()
  TalkEx("��ϲ������", 12, 0)
  instruct_0()
  TalkEx("С�ֵܣ���ϲ�㣡", 64, 4)
  instruct_0()
  TalkEx("�ã���������ִ�ᵽ����*Բ��������ϣ�������λ��*��ͬ�����ٵ��һ�ɽһ�Σ�", 19, 0)
  instruct_0()
  instruct_14()
  for i = 24, 72 do
    instruct_3(-2, i, 0, 0, -1, -1, -1, -1, -1, -1, -2, -2, -2)
  end
  instruct_0()
  instruct_13()
  TalkEx("����ǧ����࣬����춴��*Ⱥ�ۣ��õ�����������֮λ*�����ȣ�*���ǡ�ʥ�á������أ�*Ϊʲ��û�˸����ң��ѵ���*�Ҷ���֪����*�������е����ˣ�", 0, 1)
  instruct_0()
  instruct_2(143, 1)
end

function instruct_59()
  for i = CC.TeamNum, 2, -1 do
    if JY.Base["����" .. i] >= 0 then
      instruct_21(JY.Base["����" .. i])
    end
  end
  for i,v in ipairs(CC.AllPersonExit) do
    instruct_3(v[1], v[2], 0, 0, -1, -1, -1, -1, -1, -1, 0, -2, -2)
  end
end

function instruct_60(sceneid, id, num)
  if sceneid == -2 then
    sceneid = JY.SubScene
  end
  if id == -2 then
    id = JY.CurrentD
  end
  if GetD(sceneid, id, 5) == num then
    return true
  else
    return false
  end
end

function instruct_61()
  for i = 11, 24 do
    if GetD(JY.SubScene, i, 5) ~= 4664 then
      return false
    end
  end
  return true
end

function instruct_62(id1, startnum1, endnum1, id2, startnum2, endnum2)
  JY.MyPic = -1
  instruct_44(id1, startnum1, endnum1, id2, startnum2, endnum2)
  ShowScreen()
  lib.Delay(2000)
  say("��л���أ����Ĵ���������׳�Ʒ�ģȣ����Ĵ���Android�汾�ף���ѡ�����¿�ʼ�ɽ�����һ��Ŀ����Ϸ��", 260, 5, "���Ĵ���")
  
  --������Ŀ
  if GetS(53, 0, 1, 5) >= CC.CircleNum-1 then
  	local data = string.format("%s&&%d&&%d&&%d\n",JY.Person[0]["����"],GetS(4, 5, 5, 5),GetS(4, 5, 5, 4),JY.Thing[202][WZ7]);
	  local file = io.open(CC.CircleFile, "ab");
		if(file) then
			for i=1, #data do
		  	file:write(string.format("%02X", string.byte(string.sub(data,i,i))));
		  end
		  file:close();
		end
	end
  
  PlayMIDI(60)
  Cls()
  lib.FillColor(0, 0, CC.ScreenW, CC.ScreenH, C_BLACK)
  ShowScreen()
  lib.Delay(1000)
  DrawStrBoxWaitKey( "Ƭβ����Ӣ����", C_WHITE, CC.DefaultFont)
  DrawStrBoxWaitKey( "��������˳�", C_WHITE, CC.DefaultFont)
  
  JY.Status=GAME_END;
end

function instruct_63(personid, sex)
  JY.Person[personid]["�Ա�"] = sex
end

function instruct_64()
  local headid = 223
  local ts = 0
  local id = -1
  for i = 0, JY.ShopNum - 1 do
    if CC.ShopScene[i].sceneid == JY.SubScene then
      id = i
    end
  end
  if id < 0 then
    return 
  end
  TalkEx("��λС�磬������ʲ����Ҫ*�ģ�С�����Ķ�����Ǯ��*�Թ�����", headid, 0)
  local menu = {}
  for i = 1, 5 do
    menu[i] = {}
    local thingid = JY.Shop[id]["��Ʒ" .. i]
    menu[i][1] = string.format("%-12s %5d", JY.Thing[thingid]["����"], JY.Shop[id]["��Ʒ�۸�" .. i])
    menu[i][2] = nil
    if JY.Shop[id]["��Ʒ����" .. i] > 0 then
      menu[i][3] = 1
    else
      menu[i][3] = 0
    end
  end
  for i = 1, 200 do
    if JY.Base["��Ʒ" .. i] > 143 and JY.Base["��Ʒ" .. i] < 158 then
      ts = ts + 1
    end
  end
  if ts < 6 and id == 0 then
    menu[5][3] = 0
  end
  if ts < 8 and id == 4 then
    menu[5][3] = 0
  end
  local x1 = (CC.ScreenW - 9 * CC.DefaultFont - 2 * CC.MenuBorderPixel) / 2
  local y1 = (CC.ScreenH - 5 * CC.DefaultFont - 4 * CC.RowPixel - 2 * CC.MenuBorderPixel) / 2
  local r = ShowMenu(menu, 5, 0, x1, y1, 0, 0, 1, 1, CC.DefaultFont, C_ORANGE, C_WHITE)
  local itemJC = {}
  itemJC[0] = {38, 12, 28, 14, 68, 400, 100, 80, 500, 6000}
  itemJC[1] = {48, 0, 29, 15, 90, 400, 100, 100, 500, 1000}
  itemJC[2] = {54, 3, 32, 16, 159, 400, 100, 100, 600, 600}
  itemJC[3] = {63, 7, 33, 17, 175, 400, 200, 120, 600, 800}
  itemJC[4] = {27, 9, 34, 22, 69, 2000, 50, 130, 400, 8000}
  if r > 0 then
    if instruct_31(JY.Shop[id]["��Ʒ�۸�" .. r]) == false then
      TalkEx("�ǳ���Ǹ��*�����ϵ�Ǯ�ƺ�������", headid, 0)
    else
	    JY.Shop[id]["��Ʒ����" .. r] = JY.Shop[id]["��Ʒ����" .. r] - 1
	    instruct_32(CC.MoneyID, -JY.Shop[id]["��Ʒ�۸�" .. r])
	    instruct_32(JY.Shop[id]["��Ʒ" .. r], 1)
	    TalkEx("��ү����С��Ķ�����*��֤������ڣ�", headid, 0)
    end
  end
  for i,v in ipairs(CC.ShopScene[id].d_leave) do
    instruct_3(-2, v, 0, -2, -1, -1, 939, -1, -1, -1, -2, -2, -2)
  end
end

function instruct_65()
  local id = -1
  for i = 0, JY.ShopNum - 1 do
    if CC.ShopScene[i].sceneid == JY.SubScene then
      id = i
    end
  end
  if id < 0 then
    return 
  end
  instruct_3(-2, CC.ShopScene[id].d_shop, 0, -2, -1, -1, -1, -1, -1, -1, -2, -2, -2)
  for i,v in ipairs(CC.ShopScene[id].d_leave) do
    instruct_3(-2, v, 0, -2, -1, -1, -1, -1, -1, -1, -2, -2, -2)
  end
  local newid = id + 1
  if newid >= 5 then
    newid = 0
  end
  instruct_3(CC.ShopScene[newid].sceneid, CC.ShopScene[newid].d_shop, 1, -2, 938, -1, -1, 8256, 8256, 8256, -2, -2, -2)
end

function instruct_66(id)
  PlayMIDI(id)
end

function instruct_67(id)
  PlayWavAtk(id)
end



--ѡ���ÿ��ѡ����߿�
--title ����
--str ���� *����
--button ѡ��
--num ѡ��ĸ�����һ��Ҫ��ѡ���Ӧ����
--headid ��ʾ��������ߵ���ͼ���������ֵ����ʾ��ͼ
function JYMsgBox(title, str, button, num, headid, isEsc)
  local strArray = {}
  local xnum, ynum, width, height = nil, nil, nil, nil
  local picw, pich = 0, 0
  local x1, x2, y1, y2 = nil, nil, nil, nil
  local size = CC.DefaultFont;
  local xarr = {};

  local function between(x)
  	for i=1, num do
  		if xarr[i] < x and x < xarr[i] + string.len(button[i])*size/2 then
  			return i;
  		end
  	end
  	return 0;
  end
  
  if headid ~= nil then
  headid = headid*2;
    --picw, pich = lib.PicGetXY(1, headid)
	picw, pich = lib.GetPNGXY(1, headid)
    picw = picw + CC.MenuBorderPixel * 2
    pich = pich + CC.MenuBorderPixel * 2
  end
  ynum, strArray = Split(str, "*")
  xnum = 0
  for i = 1, ynum do
    local len = string.len(strArray[i])
    if xnum < len then
      xnum = len
    end
  end
  if xnum < 12 then
    xnum = 12
  end
  width = CC.MenuBorderPixel * 2 + math.modf(size * xnum / 2) + (picw)
  height = CC.MenuBorderPixel * 2 + (size + CC.MenuBorderPixel) * ynum
  if height < pich then
    height = pich
  end
  y2 = height
  height = height + CC.MenuBorderPixel * 2 + size * 2
  x1 = (CC.ScreenW - (width)) / 2 + CC.MenuBorderPixel
  x2 = x1 + (picw)
  y1 = (CC.ScreenH - (height)) / 2 + CC.MenuBorderPixel + 2 + size * 0.7
  y2 = y2 + (y1) - 5
  local select = 1
  
  
  Cls();
  
  DrawBoxTitle(width, height, title, C_GOLD)
  if headid ~= nil then
    --lib.PicLoadCache(1, headid, x1, y1, 1, 0)
	lib.LoadPNG(1, headid, x1, y1,1)
  end
  for i = 1, ynum do
    DrawString(x2, y1 + (CC.MenuBorderPixel + size) * (i - 1), strArray[i], C_WHITE, size)
  end
  
  local surid = lib.SaveSur((CC.ScreenW - (width)) / 2 - 4, (CC.ScreenH - (height)) / 2 - size, (CC.ScreenW + (width)) / 2 + 4, (CC.ScreenH + (height)) / 2 + 4)
  
  while true do
  	Cls();
  	lib.LoadSur(surid, (CC.ScreenW - (width)) / 2 - 4, (CC.ScreenH - (height)) / 2 - size)
  	
	  for i = 1, num do
	    local color, bjcolor = nil, nil
	    if i == select then
	      color = M_Yellow
	      bjcolor = M_DarkOliveGreen
	    else
	      color = M_DarkOliveGreen
	    end
	    xarr[i] = (CC.ScreenW - (width)) / 2 + (width) * i / (num + 1) - string.len(button[i]) * size / 4;
	    DrawStrBox2(xarr[i], y2, button[i], color, size, bjcolor)
	  end
	  ShowScreen()
	  
	  local key, ktype, mx, my = WaitKey(1)
	  lib.Delay(CC.Frame)
	  if key == VK_ESCAPE or ktype == 4 then
	  	if isEsc ~= nil and isEsc == 1 then
	  		select = -2;
	  		break;
	  	end
	  elseif key == VK_LEFT or ktype == 6 then
	    select = select - 1
	    if select < 1 then
	      select = num
	    end
	  elseif key == VK_RIGHT or ktype == 7 then
	    select = select + 1
	    if num < select then
	      select = 1
	    end
	  elseif key == VK_RETURN or key == VK_SPACE or ktype == 5 then
	    break;
	  elseif ktype == 2 or ktype == 3 then
	  	if mx >= x1 and mx <= x1 + width and my >= y2 and my <= y2 + 2*CC.MenuBorderPixel + size then
	  		select = between(mx);
				if select > 0 and select <= num and ktype==3 then
					break;
				end
	  	end
	  end
	end
	select = limitX(select, -2, num)
	lib.FreeSur(surid)
	
	Cls();
	return select
end


--��ʾ���߿������
function DrawBoxTitle(width, height, str, color)
  local s = 4
  local x1, y1, x2, y2, tx1, tx2 = nil, nil, nil, nil, nil, nil
  local fontsize = s + CC.DefaultFont
  local len = string.len(str) * fontsize / 2
  x1 = (CC.ScreenW - width) / 2
  x2 = (CC.ScreenW + width) / 2
  y1 = (CC.ScreenH - height) / 2
  y2 = (CC.ScreenH + height) / 2
  tx1 = (CC.ScreenW - len) / 2
  tx2 = (CC.ScreenW + len) / 2
  lib.Background(x1, y1 + s, x1 + s, y2 - s, 128)
  lib.Background(x1 + s, y1, x2 - s, y2, 128)
  lib.Background(x2 - s, y1 + s, x2, y2 - s, 128)
  lib.Background(tx1, y1 - fontsize / 2 + s, tx2, y1, 128)
  lib.Background(tx1 + s, y1 - fontsize / 2, tx2 - s, y1 - fontsize / 2 + s, 128)
  local r, g, b = GetRGB(color)
  DrawBoxTitle_sub(x1 + 1, y1 + 1, x2, y2, tx1 + 1, y1 - fontsize / 2 + 1, tx2, y1 + fontsize / 2, RGB(math.modf(r / 2), math.modf(g / 2), math.modf(b / 2)))
  DrawBoxTitle_sub(x1, y1, x2 - 1, y2 - 1, tx1, y1 - fontsize / 2, tx2 - 1, y1 + fontsize / 2 - 1, color)
  DrawString(tx1 + 2 * s, y1 - (fontsize - s) / 2, str, color, CC.DefaultFont)
end

function DrawBoxTitle_sub(x1, y1, x2, y2, tx1, ty1, tx2, ty2, color)
  local s = 4
  lib.DrawRect(x1 + s, y1, tx1, y1, color)
  lib.DrawRect(tx2, y1, x2 - s, y1, color)
  lib.DrawRect(x2 - s, y1, x2 - s, y1 + s, color)
  lib.DrawRect(x2 - s, y1 + s, x2, y1 + s, color)
  lib.DrawRect(x2, y1 + s, x2, y2 - s, color)
  lib.DrawRect(x2, y2 - s, x2 - s, y2 - s, color)
  lib.DrawRect(x2 - s, y2 - s, x2 - s, y2, color)
  lib.DrawRect(x2 - s, y2, x1 + s, y2, color)
  lib.DrawRect(x1 + s, y2, x1 + s, y2 - s, color)
  lib.DrawRect(x1 + s, y2 - s, x1, y2 - s, color)
  lib.DrawRect(x1, y2 - s, x1, y1 + s, color)
  lib.DrawRect(x1, y1 + s, x1 + s, y1 + s, color)
  lib.DrawRect(x1 + s, y1 + s, x1 + s, y1, color)
  DrawBox_1(tx1, ty1, tx2, ty2, color)
end

function Init_SMap(showname)
  lib.PicInit()
	--���س�����ͼ�ļ�
	lib.PicLoadFile(CC.SMAPPicFile[1], CC.SMAPPicFile[2], 0)
	--lib.PicLoadFile(CC.HeadPicFile[1], CC.HeadPicFile[2], 1, limitX(CC.ScreenW/6,50,110))
	lib.LoadPNGPath(CC.HeadPath, 1, CC.HeadNum, CC.Scale * 100)
	
	lib.PicLoadFile(CC.ThingPicFile[1], CC.ThingPicFile[2], 2)
  
  PlayMIDI(JY.Scene[JY.SubScene]["��������"])
  JY.oldSMapX = -1
  JY.oldSMapY = -1
  JY.SubSceneX = 0
  JY.SubSceneY = 0
  JY.OldDPass = -1
  JY.D_Valid = nil
  DrawSMap()
  lib.GetKey()
  
  instruct_13();
  if showname == 1 then
    DrawStrBox(-1, 10, JY.Scene[JY.SubScene]["����"], C_WHITE, CC.DefaultFont)
    ShowScreen()
    WaitKey()



  end
  
  AutoMoveTab = {[0] = 0}
end

--�¶Ի���ʽ
--��������ַ�
--��ͣ����������������
--������ɫ��=red��=gold��=black��=white��=orange
--�����ַ���ʾ�ٶȣ�,��,��,��,��,��,��,��,��,��
--����������ӣģ�
--���ƻ��У�   ��ҳ��
--�δ����Լ����������
function say(s,pid,flag,name)          --�����¶Ի�
  local picw=CC.PortraitPicWidth;       --���ͷ��ͼƬ���
	local pich=CC.PortraitPicHeight;
	local talkxnum=18;         --�Ի�һ������
	local talkynum=3;          --�Ի�����
	local dx=2 * CC.Scale;
	local dy=2 * CC.Scale;
  local boxpicw=picw+10 * CC.Scale;
	local boxpich=pich+10 * CC.Scale;
  local nbx=96 * CC.Scale;   --��������
  local nby=27 * CC.Scale;   --������߶�
	local boxtalkw=talkxnum*CC.DefaultFont+10;
	local boxtalkh=boxpich-nby;
	local headid = pid
	pid=pid or 0
	--ALungky �޸�����˵����ʱ������ͷ��BUG
  --ALungky ����³���ԣ�������趨ͷ�񣬲��趨���֣���ʹ���������ֵ�ͷ��Ϊ0��Ϊ����,С�塰���Ĵ��ˡ��Զ��������֣�����ӦΪ��������ͷ��Ϊ��ͷ
	if (headid == 0 or headid == nil) and (name == nil or name == JY.Person[0]["����"]) then
		headid = (280 + GetS(4, 5, 5, 5))
	end
	
	if flag==nil then
		if pid==0 then
			flag=1
		else
			flag=0
		end
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
        local x = (boxpicw - w)/2
        local y = boxpich - h - 2
        --lib.PicLoadCache(1, headid * 2, xy[flag].headx + 5 + x, xy[flag].heady + 5 + y, 1)
        lib.LoadPNG(1, (headid)*2, xy[flag].headx + x, xy[flag].heady + y, 1)
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
							xy[flag].talky+(CC.DefaultFont+talkBorder)*cy + talkBorder,
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

---
function MyDrawString(x1, x2, y, str, color, size)
  local len = math.modf(string.len(str) * size / 4)
  local x = math.modf((x1 + x2) / 2) - len
  DrawString(x, y, str, color, size)
end

--�ָ��ַ���
--szFullString�ַ���
--szSeparator�ָ��
--��������,�ָ������
function Split(szFullString, szSeparator)
  local nFindStartIndex = 1
  local nSplitIndex = 1
  local nSplitArray = {}
  while true do
    local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
    if not nFindLastIndex then
      nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
      break;
    else
	    nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
	    nFindStartIndex = nFindLastIndex + string.len(szSeparator)
	    nSplitIndex = nSplitIndex + 1
	  end
  end
  return nSplitIndex, nSplitArray
end

function DrawStrBox2(x, y, str, color, size, bjcolor)
  local strarray = {}
  local num, maxlen = nil, nil
  maxlen = 0
  num, strarray = Split(str, "*")
  for i = 1, num do
    local len = string.len(strarray[i])
    if maxlen < len then
      maxlen = len
    end
  end
  local w = size * maxlen / 2 + 2 * CC.MenuBorderPixel
  local h = 2 * CC.MenuBorderPixel + size * num
  if x == -1 then
    x = (CC.ScreenW - size / 2 * maxlen - 2 * CC.MenuBorderPixel) / 2
  end
  if y == -1 then
    y = (CC.ScreenH - size * num - 2 * CC.MenuBorderPixel) / 2
  end
  DrawBox2(x, y, x + w - 1, y + h - 1, C_WHITE, bjcolor)
  for i = 1, num do
    DrawString(x + CC.MenuBorderPixel, y + CC.MenuBorderPixel + size * (i - 1), strarray[i], color, size)
  end
end

--����һ���������İ�ɫ�����Ľǰ���
function DrawBox2(x1, y1, x2, y2, color, bjcolor)
  local s = 4
  if not bjcolor then
    bjcolor = 0
  end
  if bjcolor >= 0 then
    lib.Background(x1, y1 + s, x1 + s, y2 - s, 128, bjcolor)
    lib.Background(x1 + s, y1, x2 - s, y2, 128, bjcolor)
    lib.Background(x2 - s, y1 + s, x2, y2 - s, 128, bjcolor)
  end
  if color >= 0 then
    local r, g, b = GetRGB(color)
    DrawBox_2(x1 + 1, y1, x2, y2, RGB(math.modf(r / 2), math.modf(g / 2), math.modf(b / 2)))
    DrawBox_2(x1, y1, x2 - 1, y2 - 1, color)
  end
end

--�����Ľǰ����ķ���
function DrawBox_2(x1, y1, x2, y2, color)
  local s = 4
  lib.DrawRect(x1 + s, y1, x2 - s, y1, color)
  lib.DrawRect(x2 - s, y1, x2 - s, y1 + s, color)
  lib.DrawRect(x2 - s, y1 + s, x2, y1 + s, color)
  lib.DrawRect(x2, y1 + s, x2, y2 - s, color)
  lib.DrawRect(x2, y2 - s, x2 - s, y2 - s, color)
  lib.DrawRect(x2 - s, y2 - s, x2 - s, y2, color)
  lib.DrawRect(x2 - s, y2, x1 + s, y2, color)
  lib.DrawRect(x1 + s, y2, x1 + s, y2 - s, color)
  lib.DrawRect(x1 + s, y2 - s, x1, y2 - s, color)
  lib.DrawRect(x1, y2 - s, x1, y1 + s, color)
  lib.DrawRect(x1, y1 + s, x1 + s, y1 + s, color)
  lib.DrawRect(x1 + s, y1 + s, x1 + s, y1, color)
end

--��ʼ������ͼ
function Init_MMap()
  lib.PicInit()
  lib.LoadMMap(CC.MMapFile[1], CC.MMapFile[2], CC.MMapFile[3], CC.MMapFile[4], CC.MMapFile[5], CC.MWidth, CC.MHeight, JY.Base["��X"], JY.Base["��Y"])
  
  lib.PicLoadFile(CC.MMAPPicFile[1], CC.MMAPPicFile[2], 0)
  --lib.PicLoadFile(CC.HeadPicFile[1], CC.HeadPicFile[2], 1, limitX(CC.ScreenW/6,50,110))
  lib.LoadPNGPath(CC.HeadPath, 1, CC.HeadNum, CC.Scale * 100)
  lib.PicLoadFile(CC.ThingPicFile[1], CC.ThingPicFile[2], 2)

  JY.EnterSceneXY = nil
  JY.oldMMapX = -1
  JY.oldMMapY = -1
  PlayMIDI(JY.MmapMusic)
  
  AutoMoveTab = {[0] = 0}
end

--�Զ���Ľ����ӳ����ĺ���
--��Ҫ������ӳ������
--x�����ӳ����������X���꣬����-1��Ĭ��Ϊ���X
--y�����ӳ����������Y���꣬����-1��Ĭ��Ϊ���Y
--direct������Եķ���
function My_Enter_SubScene(sceneid,x,y,direct)	
	JY.SubScene = sceneid;
	local flag = 1;   --�Ƿ��Զ����xy����, 0�ǣ�1��
	if x == -1 and y == -1 then
		JY.Base["��X1"]=JY.Scene[sceneid]["���X"];
  	JY.Base["��Y1"]=JY.Scene[sceneid]["���Y"];
  else
  	JY.Base["��X1"] = x;
  	JY.Base["��Y1"] = y;
  	flag = 0;
	end
	
	if direct > -1 then
		JY.Base["�˷���"] = direct;
	end
 			
	
	if JY.Status == GAME_MMAP then
		CleanMemory();
		lib.UnloadMMap();
	end
  lib.ShowSlow(20,1)

	JY.Status=GAME_SMAP;  --�ı�״̬
  JY.MmapMusic=-1;

	JY.Base["�˴�"]=0;
  JY.MyPic=GetMyPic(); 
  
  --�⾰����Ǹ��ѵ㣬��Щ�ӳ�����ͨ����ת�ķ�ʽ����ģ���Ҫ�ж�
  --����Ŀǰ���ֻ����һ���ӳ�����ת�����Բ���Ҫ����ѭ���ж�
  local sid = JY.Scene[sceneid]["��ת����"];
  
  if sid < 0 or (JY.Scene[sid]["�⾰���X1"] <= 0 and JY.Scene[sid]["�⾰���Y1"] <= 0) then
  	JY.Base["��X"] = JY.Scene[sceneid]["�⾰���X1"];  --�ı���ӳ������XY����
	JY.Base["��Y"] = JY.Scene[sceneid]["�⾰���Y1"];
  else
	JY.Base["��X"] = JY.Scene[sid]["�⾰���X1"];  --�ı���ӳ������XY����
	JY.Base["��Y"] = JY.Scene[sid]["�⾰���Y1"];
  end


  Init_SMap(flag);  --���³�ʼ����ͼ
  
  if flag == 0 then    --������Զ���λ�ã��ȴ��͵��Ǹ�λ�ã�����ʾ��������
  	DrawStrBox(-1,10,JY.Scene[JY.SubScene]["����"],C_WHITE,CC.DefaultFont);
		ShowScreen();
		WaitKey();
  end
  
  Cls();
	
end

--������Ϣ
function JYZTB()

	local tnd = math.fmod(JY.Thing[202][WZ7],#MODEXZ2);
		if tnd == 0 then
			tnd = #MODEXZ2
		end

  local t = math.modf((lib.GetTime() - JY.LOADTIME) / 60000 + GetS(14, 2, 1, 4))
  local t1, t2 = 0, 0
  while t >= 60 do
    t = t - 60
    t1 = t1 + 1
  end
  t2 = t
  DrawBox(10, 10, 15 + 12*CC.SmallFont, 15 + 3*(CC.SmallFont + CC.RowPixel), M_Yellow)
  DrawString(15, 15, string.format("Ʒ��:%d ����:%d", JY.Person[0]["Ʒ��"], JY.GOLD), C_GOLD, CC.SmallFont)
  DrawString(15, 15+CC.SmallFont+CC.RowPixel, string.format("��Ϸʱ��:%2dʱ%2d��", t1, t2), C_GOLD, CC.SmallFont)
  DrawString(15, 15+2*(CC.SmallFont+CC.RowPixel), string.format("�Ѷ�:%s ��Ŀ��:%d", MODEXZ2[tnd], CC.CircleNum), C_GOLD, CC.SmallFont)
end

function QZXS(s)
  DrawStrBoxWaitKey(s, C_GOLD, CC.DefaultFont)
end


--��ʾ�书������
function KungfuString(str, x, y, color, size, font, place)
  if str == nil then
    return 
  end
  local w, h = size, size + 5
  local len = string.len(str) / 2
  x = x - len * w / 2
  y = y - h * place
  lib.DrawStr(x, y, str, color, size, font, 0, 0)
end

--�����ͼ����
function ClsN(x1, y1, x2, y2)
  if x1 == nil then
    x1 = 0
    y1 = 0
    x2 = 0
    y2 = 0
  end
  lib.SetClip(x1, y1, x2, y2)
  lib.FillColor(0, 0, 0, 0, 0)
  lib.SetClip(0, 0, 0, 0)
end

--��ɫ�Ƿ�Ϊ�����
function T1LEQ(id)
  if id == 0 and JY.Person[id]["����"] == JY.LEQ and GetS(4, 5, 5, 4) == 1 and GetS(4, 5, 5, 5) == 8 then
    return true
  else
    return false
  end
end--�жϽ�ɫ�Ƿ�Ϊˮ������
function T2SQ(id)
  if id == 0 and JY.Person[id]["����"] == JY.SQ and GetS(4, 5, 5, 4) == 2 and GetS(4, 5, 5, 5) == 8 then
    return true
  else
    return false
  end
end--�жϽ�ɫ�Ƿ�Ϊ�����
function T3XYK(id)
  if id == 0 and JY.Person[id]["����"] == JY.XYK and GetS(4, 5, 5, 4) == 3 and GetS(4, 5, 5, 5) == 8 then
    return true
  else
    return false
  end
end

---�Ծ��ν�����Ļ����
--���ؼ��ú�ľ��Σ����������Ļ�����ؿ�
function ClipRect(r)
  if CC.ScreenW <= r.x1 or r.x2 <= 0 or CC.ScreenH <= r.y1 or r.y2 <= 0 then
    return nil
  else
    local res = {}
    res.x1 = limitX(r.x1, 0, CC.ScreenW)
    res.x2 = limitX(r.x2, 0, CC.ScreenW)
    res.y1 = limitX(r.y1, 0, CC.ScreenH)
    res.y2 = limitX(r.y2, 0, CC.ScreenH)
    return res
  end
end

--������ͼ�ı��γɵ�Clip�ü�
--(dx1,dy1) ����ͼ�ͻ�ͼ���ĵ������ƫ�ơ��ڳ����У��ӽǲ�ͬ�����Ƕ�ʱ�õ�
--pic1 �ɵ���ͼ���
--id1 ��ͼ�ļ����ر��
--(dx2,dy2) ����ͼ�ͻ�ͼ���ĵ��ƫ��
--pic2 �ɵ���ͼ���
--id2 ��ͼ�ļ����ر��
--���أ��ü����� {x1,y1,x2,y2}
function Cal_PicClip(dx1, dy1, pic1, id1, dx2, dy2, pic2, id2)
  local w1, h1, x1_off, y1_off = lib.PicGetXY(id1, pic1 * 2)
  local old_r = {}
  old_r.x1 = CC.XScale * (dx1 - dy1) + CC.ScreenW / 2 - x1_off
  old_r.y1 = CC.YScale * (dx1 + dy1) + CC.ScreenH / 2 - y1_off
  old_r.x2 = old_r.x1 + w1
  old_r.y2 = old_r.y1 + h1
  local w2, h2, x2_off, y2_off = lib.PicGetXY(id2, pic2 * 2)
  local new_r = {}
  new_r.x1 = CC.XScale * (dx2 - dy2) + CC.ScreenW / 2 - x2_off
  new_r.y1 = CC.YScale * (dx2 + dy2) + CC.ScreenH / 2 - y2_off
  new_r.x2 = new_r.x1 + w2
  new_r.y2 = new_r.y1 + h2
  return MergeRect(old_r, new_r)
end

--�ϲ�����
function MergeRect(r1, r2)
  local res = {}
  res.x1 = math.min(r1.x1, r2.x1)
  res.y1 = math.min(r1.y1, r2.y1)
  res.x2 = math.max(r1.x2, r2.x2)
  res.y2 = math.max(r1.y2, r2.y2)
  return res
end

--��򵥰汾�Ի�
function MyTalk(s,personid)            --��򵥰汾�Ի�
    local flag;
    if personid==0 then
        flag=1;
		else
	    flag=0;
	end
	MyTalkEx(s,personid,flag,1);
end

--��򵥰汾�Ի�
function MyTalk1(s,personid, name)            --��򵥰汾�Ի�
    local flag;
    if personid==0 then
        flag=1;
		else
	    flag=0;
	end
	MyTalkEx(s,personid,flag,1, name);
end

--�Զ��帴�Ӱ汾�Ի�
--s �ַ������������*��Ϊ���У��������û��*,����Զ�����
--pid ������
--flag ��ʾλ��
--showname �Ƿ���ʾ����
--name ��ʾ������
function MyTalkEx(s,pid,flag,showname,name)          --���Ӱ汾�Ի�
  local picw = CC.PortraitPicWidth
  local pich = CC.PortraitPicHeight
  local talkxnum = 18
  local talkynum = 3
  local dx = 2 * CC.Scale
  local dy = 2 * CC.Scale
  local boxpicw = picw + 10 * CC.Scale
  local boxpich = pich + 10 * CC.Scale
  local boxtalkw = 12 * CC.DefaultFont + 10
  local boxtalkh = boxpich
  local talkBorder = (pich - talkynum * CC.DefaultFont) / (talkynum + 1)
  local xy = {
{headx = CC.ScreenW - 1 - dx - boxpicw, heady = CC.ScreenH - dy - boxpich, talkx = CC.ScreenW - 1 - dx - boxpicw - boxtalkw - 2, talky = CC.ScreenH - dy - boxpich, showhead = 1}, 
{headx = dx, heady = dy, talkx = dx + boxpicw + 2, talky = dy, showhead = 0}, 
{headx = CC.ScreenW - 1 - dx - boxpicw, heady = CC.ScreenH - dy - boxpich, talkx = CC.ScreenW - 1 - dx - boxpicw - boxtalkw - 2, talky = CC.ScreenH - dy - boxpich, showhead = 1}, 
{headx = CC.ScreenW - 1 - dx - boxpicw, heady = dy, talkx = CC.ScreenW - 1 - dx - boxpicw - boxtalkw - 2, talky = dy, showhead = 1}, 
{headx = dx, heady = CC.ScreenH - dy - boxpich, talkx = dx + boxpicw + 2, talky = CC.ScreenH - dy - boxpich, showhead = 1}; 
[0] = {headx = dx, heady = dy, talkx = dx + boxpicw + 2, talky = dy, showhead = 1}}
  if flag < 0 or flag > 5 then
    flag = 0
  end
  if string.find(s, "*") == nil then
    s = GenTalkString(s, 12)
  end
  if CONFIG.KeyRepeat == 0 then
    lib.EnableKeyRepeat(0, CONFIG.KeyRepeatInterval)
  end
  lib.GetKey()
  local startp = 1
  local endp = nil
  local dy = 0
  local headid = JY.Person[pid]["ͷ�����"];
  while 1 do
    if dy == 0 then
      Cls()
      if headid >= 0 then
        if headid > 243 and headid < 249 then
          headid = 0
        end
        if headid == 0 then
          if GetS(4, 5, 5, 5) < 8 then
            headid = 280 + GetS(4, 5, 5, 5)
          else
	          headid = 287 + GetS(4, 5, 5, 4)
	        end
        end
        DrawBox(xy[flag].headx, xy[flag].heady, xy[flag].headx + boxpicw, xy[flag].heady + boxpich, C_WHITE)
        --local w, h = lib.PicGetXY(1, (headid) * 2)
		local w, h = lib.GetPNGXY(1, (headid)*2 )
        local x = (picw - w) / 2
        local y = (pich - h) / 2
        --lib.PicLoadCache(1, (headid) * 2, xy[flag].headx + 5 + x, xy[flag].heady + 5 + y, 1)
		lib.LoadPNG(1, (headid)*2, xy[flag].headx + 5 + x, xy[flag].heady + 5 + y, 1)
        if showname ~= nil and showname == 1 then
        	local showx = xy[flag].headx + 5;
        	local showy = xy[flag].heady + 5 + pich - 20
        	if name ~= nil then
	      		DrawString(showx, showy, name, C_GOLD, 20 * CC.Scale)
	      	else
	      		DrawString(showx, showy, JY.Person[pid]["����"], C_GOLD, 20 * CC.Scale)
	      	end
	      end
	      DrawBox(xy[flag].talkx, xy[flag].talky, xy[flag].talkx + boxtalkw, xy[flag].talky + boxtalkh, C_WHITE)
      end
      
    end
    endp = string.find(s, "*", startp)
    if endp == nil then
      DrawString(xy[flag].talkx + 5, xy[flag].talky + 5 + talkBorder + dy * (CC.DefaultFont + talkBorder), string.sub(s, startp), C_WHITE, CC.DefaultFont)
      ShowScreen()
      WaitKey()
      break;
    else
      DrawString(xy[flag].talkx + 5, xy[flag].talky + 5 + talkBorder + dy * (CC.DefaultFont + talkBorder), string.sub(s, startp, endp - 1), C_WHITE, CC.DefaultFont)
    end
    dy = dy + 1
    startp = endp + 1
    if talkynum <= dy then
      ShowScreen()
      WaitKey()
      dy = 0
    end
  end
  if CONFIG.KeyRepeat == 0 then
    lib.EnableKeyRepeat(CONFIG.KeyRepeatDelay, CONFIG.KeyRepeatInterval)
  end
  Cls()
end


--�Զ����¼�
function NEvent(keypress)
  NEvent2(keypress)
  NEvent3(keypress)
  NEvent4(keypress)
  NEvent5(keypress)
  NEvent6(keypress)
  NEvent7(keypress)
  NEvent8(keypress)
  NEvent9(keypress)
  NEvent10(keypress)
  NEvent11(keypress)
  NEvent12(keypress)
  
end

--��ʾ��Ӱ�ַ���
--���x,y��-1����ô��ʾ����Ļ�м�
function NewDrawString(x, y, str, color, size)
  local ll = #str
  local w = size * ll / 2 + 2 * CC.MenuBorderPixel
  local h = size + 2 * CC.MenuBorderPixel
  if x == -1 then
    x = (CC.ScreenW - size / 2 * ll - 2 * CC.MenuBorderPixel) / 2
  else
    x = (x - size / 2 * ll - 2 * CC.MenuBorderPixel) / 2
  end
  if y == -1 then
    y = (CC.ScreenH - size - 2 * CC.MenuBorderPixel) / 2
  else
    y = (y - size - 2 * CC.MenuBorderPixel) / 2
  end
  lib.DrawStr(x, y, str, color, size, CC.FontName, CC.SrcCharSet, CC.OSCharSet)
end

--���ڲ����������֣�ʹ�÷��������
function InputNum(str, minNum, maxNum, isEsc)
	local size = CC.DefaultFont;
	local color = C_WHITE;
	local ll=#str;
  local w=size*ll/2+2*CC.MenuBorderPixel;
	local h=size+2*CC.MenuBorderPixel;
  local x=(CC.ScreenW-size/2*ll-2*CC.MenuBorderPixel)/2;
  local y=(CC.ScreenH-size-2*CC.MenuBorderPixel)/2;

  DrawBox(x,y,x+w-1,y+h-1,C_WHITE);
  DrawString(x+CC.MenuBorderPixel,y+CC.MenuBorderPixel,str,color,size);
  
  if minNum > maxNum then
  	minNum, maxNum = maxNum, minNum;
  end
  
  local help = "���¼Ӽ�һ�����ҼӼ�ʮ";
  if minNum ~= nil then
  	help = help .. " ��С"..minNum;
  end
  if minNum ~= nil then
  	help = help .. " ���"..maxNum;
  end
  if isEsc ~= nil then
  	help = help .. " ESCȡ������";
  end
  
  DrawString((CC.ScreenW-size*#help/2)/2,y-2*size,help,color,size);
  
  
  
  local sid = lib.SaveSur(0, 0, CC.ScreenW, CC.ScreenH);
  
  local num = 0;
  if minNum ~= nil then
  	num = minNum;
  end
  while 1 do
  	DrawString(CC.ScreenW/2,y+h+size,num.."",C_RED,size);
  	ShowScreen()
    local key, ktype, mx, my = WaitKey(1)
		lib.Delay(CC.Frame)
    if key == VK_UP or ktype == 6 then
    	if maxNum == nil or num < maxNum  then
    		num = num + 1
    	end
    elseif key == VK_DOWN or ktype == 7 then
      if minNum == nil or num > minNum  then
    		num = num - 1
    	end
    elseif key == VK_LEFT then
      if minNum == nil or num >= minNum+10  then
    		num = num - 10
    	else
    		num = minNum
    	end
    elseif key == VK_RIGHT then
      if maxNum == nil or num <= maxNum-10  then
    		num = num + 10
    	else
    		num = maxNum
    	end
    elseif key == VK_SPACE or key == VK_RETURN or ktype == 3 then
      break;
    elseif (key == VK_ESCAPE or ktype == 4) and isEsc ~= nil then
      num = nil;
      break;
    end
	ClsN();
  	lib.LoadSur(sid,0,0)
  end
  lib.FreeSur(sid);
  return num;
end


--�����ַ������Ƿ�����ɫ��־
function AnalyString(str)
		local tlen = 0;
		local strcolor = {}
		--����Ƿ�����ɫ��־
		local f1, f2 = string.find(str, "<[A-R]>");
		if f1 ~= nil then
			while 1 do
			  if f1 > 1 then
			    local s1 = string.sub(str, 1, f1-1)
			    table.insert(strcolor, {s1, nil});
			    tlen = tlen + #s1;
			  end

			  local match = string.match(str, "<([A-R])>");
			  local f3, f4 = string.find(str, "</"..match..">"); 
			  if f3 ~= nil then
			     local s2 = string.sub(str, f2+1, f3-1);

			     table.insert(strcolor, {s2, CC.Color[match]});

			     tlen = tlen + #s2;
					 if f4+1 >= #str then
					 	break;
					 end
			     str = string.sub(str, f4+1, #str);
			     f1, f2 = string.find(str, "<[A-R]>");

			     --����Ѿ�û��������ɫ��־��ֱ�������˳�ѭ��
			     if f1 == nil then
			     	table.insert(strcolor, {str, nil});
			     	break;
			     end
			  else		--����Ҳ���������־��ֱ�������˳�ѭ��
			     str = string.sub(str, f2+1, #str);
			     table.insert(strcolor, {str, CC.Color[match]});
			     break;
			  end
			end
		else
			table.insert(strcolor, {str, nil});
		end

		return strcolor;
end


--�浵�б�
function SaveList()
	--��ȡR*.idx�ļ�
  local idxData = Byte.create(24)
  Byte.loadfile(idxData, CC.R_IDXFilename[0], 0, 24)
  local idx = {}
  idx[0] = 0
  for i = 1, 6 do
    idx[i] = Byte.get32(idxData, 4 * (i - 1))
  end

  local table_struct = {}
  table_struct["����"]={idx[1]+8,2,10}
  table_struct["�ȼ�"]={idx[1]+30,0,2}
  
  table_struct["����"]={idx[0]+2,0,2}
  table_struct["��������"]={idx[3]+2,2,10}
  
  --���Ǳ��
  table_struct["����1"]={idx[0]+24,0,2}
  
  
  table_struct[WZ7]={idx[2]+88,0,2}
  
  --ʱ�䱣���ڳ���������
  table_struct["��Ϸʱ��"]={(CC.SWidth*CC.SHeight*(14*6+4) + CC.SWidth + 2)*2, 0, 2}
	--S_XMax*S_YMax*(id*6+level)+y*S_XMax+x
	--14, 2, 1, 4
	--sFile,CC.TempS_Filename,JY.SceneNum,CC.SWidth,CC.SHeight

  --��ȡR*.grp�ļ�

	local len = filelength(CC.R_GRPFilename[0]);
	local data = Byte.create(len);
	
	--��ȡSMAP.grp
	local slen  = filelength(CC.S_Filename[0]);
	local sdata = Byte.create(slen);
	
	local menu = {};

	for i=1, CC.SaveNum do
	
		local name = "";
		local lv = "";
		local sname = "";
		local nd = "";
		local time = "";
	
		if existFile(string.format(CC.R_GRP,i)) then
			Byte.loadfile(data, string.format(CC.R_GRP,i), 0, len);
			
			local pid = GetDataFromStruct(data,0,table_struct,"����1");
			
			name = GetDataFromStruct(data,pid*CC.PersonSize,table_struct,"����");
			lv = GetDataFromStruct(data,pid*CC.PersonSize,table_struct,"�ȼ�").."��";
			local wy = GetDataFromStruct(data,0,table_struct,"����");
			if wy == -1 then
				sname = "���ͼ";
			else
				sname = GetDataFromStruct(data,wy*CC.SceneSize,table_struct,"��������").."";
			end
			
			local wz = GetDataFromStruct(data,202*CC.ThingSize,table_struct,WZ7);
			local tnd = math.fmod(wz,#MODEXZ2);
			if tnd == 0 then
				tnd = #MODEXZ2
			end
			nd = MODEXZ2[tnd];
			
			--��Ϸʱ��
			Byte.loadfile(sdata, string.format(CC.S_GRP,i), 0, slen);
			
			local t = GetDataFromStruct(sdata, 0, table_struct, "��Ϸʱ��")
		  local t1, t2 = 0, 0
		  while t >= 60 do
		    t = t - 60
		    t1 = t1 + 1
		  end
		  t2 = t
		  
		  time = string.format("%2dʱ%2d��", t1, t2)
		end
		
		menu[i] = {string.format("%2d: %s  %s  %s  %s %s",i,name, lv, sname, nd, time), nil, 1};
		

	end

	local menux=(CC.ScreenW-20*CC.DefaultFont-2*CC.MenuBorderPixel)/2
	local menuy=(CC.ScreenH - 10*(CC.DefaultFont+CC.RowPixel))/2

  local r=ShowMenu(menu,CC.SaveNum,10,menux,menuy,0,0,1,1,CC.DefaultFont,C_WHITE,C_GOLD)
  
 
  
	CleanMemory()
	return r;
end


--��ȡ�ѵõ����������
function GetBookNum()

	local num = 0;
	for i=1, CC.MyThingNum do
		if JY.Base["��Ʒ"..i] < 0 then
			return num;
		end
		
		if JY.Base["��Ʒ"..i] >= CC.BookStart and JY.Base["��Ʒ"..i] < CC.BookStart + CC.BookNum then
			num = num + 1
		end
	end
	
	return num;


end


--��̬��ʾ��ʾ
function DrawTimer()
	if CC.OpenTimmerRemind ~= 1 then
		return;
	end
	local t2 = lib.GetTime();
	if CC.Timer.status==0  then
		if t2-CC.Timer.stime>60000 or CC.Timer.stime == 0 then
			CC.Timer.stime=t2;
			CC.Timer.status=1;
			CC.Timer.str=CC.RUNSTR[math.random(#CC.RUNSTR)];
			CC.Timer.len=string.len(CC.Timer.str)/2+3;
		end
	else
		CC.Timer.fun(t2);
	end
end

function demostr(t)
	local tt=t-CC.Timer.stime;
	tt=math.modf(tt/25)%(CC.ScreenW+CC.Timer.len*CC.Fontsmall);
	if runword(CC.Timer.str,M_Orange,CC.Fontsmall,1,tt)==1 then
		if Rnd(2)==1 then
			CC.Timer.status=0;
			CC.Timer.stime=t;
		end
	end
end

function runword(str,color,size,place,offset)
	offset=CC.ScreenW-offset;
	local y1,y2
	if place==0 then
		y1=0;
		y2=size;
	elseif place==1 then
		y1=CC.ScreenH-size;
		y2=CC.ScreenH;
	end
	lib.Background(0,y1,CC.ScreenW,y2,128);
	if -offset>(CC.Timer.len-1)*size then
		return 1;
	end
	DrawString(offset,y1,str,color,size);
	return 0;
end

--��ȡʵս
function GetSZ(pid)
	for j = 1, #TeamP do
      if pid == TeamP[j] then
      	return GetS(5, j, 6, 5) - 2;
      end
  end
	return 0;
end


--��ȡ��������
function LoadSkillData(id)

	--�µ��̶�����
	if id == 0 then
		JY.SkillNum = 100;
	else
		JY.SkillNum = filelength(CC.SkillFile)/CC.SkillSize;
	end

	--�����ֽ�����
	JY.Data_Skill = Byte.create(JY.SkillNum * CC.SkillSize);

	--��������ؿ������ȡ�ļ�����
	if id ~= 0 and existFile(CC.SkillFile) then
		Byte.loadfile(JY.Data_Skill, CC.SkillFile, 0, JY.SkillNum * CC.SkillSize)
	end


  --���ؼ�������
  for i = 0, JY.SkillNum - 1 do
    JY.Skill[i] = {}
    local meta_t = {__index = function(t, k)
      return GetDataFromStruct(JY.Data_Skill, i * CC.SkillSize, CC.Skill_S, k)
    end, __newindex = function(t, k, v)
      SetDataFromStruct(JY.Data_Skill, i * CC.SkillSize, CC.Skill_S, k, v)
    end}
    setmetatable(JY.Skill[i], meta_t)
  end
	
end