
----------------------------------------------------------
-----------金庸群侠传复刻之Lua版----------------------------

--版权所无，敬请复制
--您可以随意使用代码

---本代码由游泳的鱼编写

--本模块是lua主模块，由C主程序JYLua.exe调用。C程序主要提供游戏需要的视频、音乐、键盘等API函数，供lua调用。
--游戏的所有逻辑都在lua代码中，以方便大家对代码的修改。
--为加快速度，显示主地图/场景地图/战斗地图部分用C API实现。

--导入其他模块。之所以做成函数是为了避免编译查错时编译器会寻找这些模块。
function IncludeFile()              --导入其他模块
	--package.path = "./?.lua;";
	--require("config");
	package.path=CONFIG.ScriptLuaPath;  ---设置加载路径
	require("jyconst");
	require("readkdef");
	require("jywar");
	
end

--Alungky 修复部分物品文字不正确的问题
function Alungky_textFix_invokePerInstance()
  --解决方法来自　苍天泰坦
  JY.Thing[88]["名称"]="须弥山神掌"
  JY.Thing[88]["名称2"]="须弥山神掌"
  JY.Thing[89]["名称"]="七伤拳谱"
  JY.Thing[89]["名称2"]="七伤拳谱"
  JY.Thing[110]["名称2"]="五毒秘传"
  JY.Thing[178]["名称"]="大剪刀刀法"
  JY.Thing[181]["名称2"]="棋盘招式"
  JY.Thing[196]["物品说明"]="大燕传国玉玺"
  JY.Thing[197]["物品说明"]="大燕皇帝世袭图表"
  JY.Thing[212]["名称2"]="广陵散琴曲"
end

function SetGlobal()   --设置游戏内部使用的全程变量
   JY={};

   JY.Status=GAME_INIT;  --游戏当前状态

   --保存R×数据
   JY.Base={};           --基本数据
   JY.PersonNum=0;      --人物个数
   JY.Person={};        --人物数据
   JY.ThingNum=0        --物品数量
   JY.Thing={};         --物品数据
   JY.SceneNum=0        --物品数量
   JY.Scene={};         --物品数据
   JY.WugongNum=0        --物品数量
   JY.Wugong={};         --物品数据
   JY.ShopNum=0        --商店数量
   JY.Shop={};         --商店数据
   
   
   JY.Skill = {}		--技能数据
   JY.SkillNum = 0;
   JY.Data_Skill=nill;

   JY.Data_Base=nil;     --实际保存R*数据
   JY.Data_Person=nil;
   JY.Data_Thing=nil;
   JY.Data_Scene=nil;
   JY.Data_Wugong=nil;
   JY.Data_Shop=nil;

   JY.MyCurrentPic = 0  --主角当前走路贴图在贴图文件中偏移
  JY.MyPic = 0     --主角当前贴图
  JY.Mytick = 0    --主角没有走路的持续帧数
  JY.MyTick2 = 0   --显示事件动画的节拍
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

   JY.SubScene=-1;          --当前子场景编号
   JY.SubSceneX=0;          --子场景显示位置偏移，场景移动指令使用
   JY.SubSceneY=0;

   JY.Darkness=0;             --=0 屏幕正常显示，=1 不显示，屏幕全黑

   JY.CurrentD=-1;          --当前调用D*的编号
   JY.OldDPass=-1;          --上次触发路过事件的D*编号, 避免多次触发
   JY.CurrentEventType=-1   --当前触发事件的方式 1 空格 2 物品 3 路过

   JY.CurrentThing=-1;      --当前选择物品，触发事件使用

   JY.MmapMusic=-1;         --切换大地图音乐，返回主地图时，如果设置，则播放此音乐

   JY.CurrentMIDI=-1;       --当前播放的音乐id，用来在关闭音乐时保存音乐id。
   JY.EnableMusic=1;        --是否播放音乐 1 播放，0 不播放
   JY.EnableSound=1;        --是否播放音效 1 播放，0 不播放

   JY.ThingUseFunction={};          --物品使用时调用函数，SetModify函数使用，增加新类型的物品
   JY.SceneNewEventFunction={};     --调用场景事件函数，SetModify函数使用，定义使用新场景事件触发的函数


   WAR={};     --战斗使用的全程变量。。这里占个位置，因为程序后面不允许定义全局变量了。具体内容在WarSetGlobal函数中

		AutoMoveTab = {[0] = 0}
end


function JY_Main()        --主程序入口
	os.remove("debug.txt");        --清除以前的debug输出
    xpcall(JY_Main_sub,myErrFun);     --捕获调用错误
end

function myErrFun(err)      --错误处理，打印错误信息
    lib.Debug(err);                 --输出错误信息
    lib.Debug(debug.traceback());   --输出调用堆栈信息
end

function JY_Main_sub()        --真正的游戏主程序入口


    IncludeFile();         --导入其他模块
    SetGlobalConst();    --设置全程变量CC, 程序使用的常量
    SetGlobal();         --设置全程变量JY

    GenTalkIdx()
    --SetModify();         --设置对函数的修改，定义新的物品，事件等等

    --禁止访问全程变量
    setmetatable(_G,{ __newindex =function (_,n)
                       error("attempt read write to undeclared variable " .. n,2);
                       end,
                       __index =function (_,n)
                       error("attempt read read to undeclared variable " .. n,2);
                       end,
                     }  );
					
	
    lib.Debug("JY_Main start.");
    

	math.randomseed(os.time());          --初始化随机数发生器

	lib.EnableKeyRepeat(CONFIG.KeyRepeatDelay,CONFIG.KeyRePeatInterval);   --设置键盘重复率

    JY.Status=GAME_START;

    lib.PicInit(CC.PaletteFile);       --加载原来的256色调色板

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
	local menu={  {"重新开始",nil,1},
	              {"载入进度",nil,1},
	              {"离开游戏",nil,1}  };
	local menux=(CC.ScreenW-4*CC.StartMenuFontSize-2*CC.MenuBorderPixel)/2

	local menuReturn=ShowMenu(menu,3,0,menux,CC.StartMenuY,0,0,0,0,CC.StartMenuFontSize,C_STARTMENU, C_RED)
	Cls();
    if menuReturn == 1 then        --重新开始游戏
		NewGame();          --设置新游戏数据
        JY.SubScene = CC.NewGameSceneID
		JY.Base["人X1"] = CC.NewGameSceneX
		JY.Base["人Y1"] = CC.NewGameSceneY
		JY.MyPic = CC.NewPersonPic
		JY.Status = GAME_SMAP
		JY.MmapMusic = -1
		CleanMemory()
		Init_SMap(0)       
        

		if DrawStrBoxYesNo(-1, -1, "是否观看开始动画", C_WHITE, CC.DefaultFont) == true then 
		  oldCallEvent(CC.NewGameEvent)
		else
		  CallCEvent(691)
		end
		
		
	elseif menuReturn == 2 then         --载入旧的进度
			--[[
    	local loadMenu={ {"进度一",nil,1},
	                     {"进度二",nil,1},
	                     {"进度三",nil,1} };

	    local menux=(CC.ScreenW-3*CC.StartMenuFontSize-2*CC.MenuBorderPixel)/2

    	local r=ShowMenu(loadMenu,3,0,menux,CC.StartMenuY,0,0,0,1,CC.StartMenuFontSize,C_STARTMENU, C_RED)
    	]]
    	
    	local r = SaveList();
    	--ESC 重新返回选项
    	if r < 1 then
    		local s = StartMenu();
    		return s;
    	end
    	
    	Cls();
			DrawStrBox(-1,CC.StartMenuY,"请稍候...",C_GOLD,CC.DefaultFont);
			ShowScreen();
    	local result = LoadRecord(r);
    	if result ~= nil then
    		return StartMenu();
    	end

		if JY.Base["无用"] ~= -1 then
		  if JY.SubScene < 0 then
			CleanMemory()
			lib.UnloadMMap()
		  end
		  lib.PicInit()
		  lib.ShowSlow(50, 1)
		  JY.Status = GAME_SMAP
		  JY.SubScene = JY.Base["无用"]
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

function CleanMemory()            --清理lua内存
    if CONFIG.CleanMemory==1 then
		 collectgarbage("collect");
    end

end

function NewGame()     --选择新游戏，设置主角初始属性

	Cls();
	DrawStrBox(-1,CC.StartMenuY,"请稍候...",C_GOLD,CC.DefaultFont);
	ShowScreen();
	LoadRecord(0); --  载入新游戏数据
	
	JY.Status = GAME_NEWNAME;
	ClsN();
  
  
  local van = 1
  if CC.CircleNum > 4 then
  	local vanMode = {"普通凡人","隐世高手"}
  	van = JYMsgBox("游戏级别","恭喜您已经通过四个周目的锻炼*龙的传人粉丝有你更精彩*不同的游戏级别难度更高",vanMode,#vanMode,5);
  	ClsN()
  end

  local mode = limitX(CC.CircleNum-(van-1)*4,1,#MODEXZ2);
  
  --选择难度
  JY.Thing[202][WZ7] = JYMsgBox("难度选择", "请选择游戏难度。*难度越高敌人越对付*周目数决定可选择的难度范围*每打通关一次周目数会自动进行累加", MODEXZ2, mode, 35)
	JY.Thing[202][WZ7] = JY.Thing[202][WZ7] + (van-1)*4;
	
	CC.PersonAttribMax["攻击力"] = CC.PersonAttribMax["攻击力"] + (JY.Thing[202][WZ7]-4)*100
  CC.PersonAttribMax["防御力"] = CC.PersonAttribMax["防御力"] + (JY.Thing[202][WZ7]-4)*100
  CC.PersonAttribMax["轻功"] = CC.PersonAttribMax["轻功"] + (JY.Thing[202][WZ7]-4)*100

	JY.Person[0]["姓名"]=CC.NewPersonName;
  
  JY.Person[0]["生命最大值"] = 50
  JY.Person[0]["内力最大值"] = 100
  JY.Person[0]["攻击力"] = 30
  JY.Person[0]["防御力"] = 30
  JY.Person[0]["轻功"] = 30
  JY.Person[0]["医疗能力"] = 30
  JY.Person[0]["用毒能力"] = 30
  JY.Person[0]["解毒能力"] = 30
  JY.Person[0]["抗毒能力"] = 30
  JY.Person[0]["拳掌功夫"] = 30
  JY.Person[0]["御剑能力"] = 30
  JY.Person[0]["耍刀技巧"] = 30
  JY.Person[0]["特殊兵器"] = 30
  JY.Person[0]["暗器技巧"] = 30
  ClsN()
  
  --选择内力性质
  local nl = JYMsgBox("请选择", "想要哪种属性的内力*不同内力性质将有不同武功路线*天罡忽略内力性质", {"阴性", "阳性", "调和"}, 3, 261)
  if nl == 1 then
    JY.Person[0]["内力性质"] = 0
  elseif nl == 2 then
    JY.Person[0]["内力性质"] = 1
  else
    JY.Person[0]["内力性质"] = 2
  end
  
  ClsN();
  JY.Person[0]["资质"] = InputNum("请输入资质",1,100);

	JY.Person[0]["生命"] = JY.Person[0]["生命最大值"]
	JY.Person[0]["内力"] = JY.Person[0]["内力最大值"]
	ClsN()
	ShowScreen()
	
	--定义初始数据和事件
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
	
	
	
	SetS(103,17,21,3,80);		--新增药王庙事件编号80     --宝象贴图
	SetS(103,29,11,3,81);		--用来显示丁典的坟墓
	SetS(103,29,12,3,82);
	
	SetS(63,20,27,3,80);		--新增天宁寺事件编号80   戚长发贴图
	SetS(63,19,22,3,81);		--新增天宁寺事件编号81   获取连城诀之后路过触发遇到戚长发
	
	--定义所有人物的武功
	for p = 0, JY.PersonNum-1 do
		JY.Person[p]["外号"] = " "
	  local r = 0
    for i,v in pairs(CC.PersonExit) do
      if v[1] == p then
        r = 1
      end
    end
    if p == 0 then
      r = 1
    end
	
		--如果是敌人
	  if r == 0 then
	    for i = 1, 10 do
	      if JY.Person[p]["武功" .. i] > 0 then
	        if p < 191 then
	          JY.Person[p]["武功等级" .. i] = 999    --BOSS武功是为极
		      else
		        JY.Person[p]["武功等级" .. i] = limitX(JY.Thing[202][WZ7]*200 + 300 + Rnd(100),0,999)    --小兵武功为十级
		      end
		    else
		    	break;
		    end
	    end
	    
	    --难度生命
      --Alungky 修正BUG，初始满生命内力的才加满生命，需记录初始生命，否则条件永远不可能成立
      local pointTemp = JY.Person[p]["生命最大值"]
	    if JY.Person[p]["生命最大值"] <= JY.Thing[202][WZ7] * 80 then
	    	JY.Person[p]["生命最大值"] = JY.Thing[202][WZ7] * 150 + Rnd(JY.Thing[202][WZ7])*100
	    else
	    	JY.Person[p]["生命最大值"] = JY.Thing[202][WZ7] * JY.Person[p]["生命最大值"] + 100
	    end
		  if pointTemp == JY.Person[p]["生命"] then		--初始满生命的才加
	      JY.Person[p]["生命"] = JY.Person[p]["生命最大值"]
	    elseif JY.Thing[202][WZ7] > 2 then
	    	JY.Person[p]["生命"] = JY.Person[p]["生命"] + JY.Thing[202][WZ7]*100;
	    end
      
      --难度内力
      --Alungky 同上
      pointTemp = JY.Person[p]["内力最大值"]
      if JY.Person[p]["内力最大值"] <= JY.Thing[202][WZ7] * 200 + 100 then
      	JY.Person[p]["内力最大值"] = JY.Thing[202][WZ7] * 250 + Rnd(JY.Thing[202][WZ7])*100
      elseif JY.Person[p]["内力最大值"] < CC.PersonAttribMax["内力最大值"] * 2 then
      	JY.Person[p]["内力最大值"] = JY.Person[p]["内力最大值"] + 600 * JY.Thing[202][WZ7]
    	end
    	
    	if JY.Person[p]["内力最大值"] > CC.PersonAttribMax["内力最大值"] * 2 then
    		JY.Person[p]["内力最大值"] = CC.PersonAttribMax["内力最大值"] * 2;
    	end
	    if pointTemp == JY.Person[p]["内力"] then			--初始满内力的才加
				JY.Person[p]["内力"] = JY.Person[p]["内力最大值"]
			elseif JY.Thing[202][WZ7] > 2 then
				JY.Person[p]["内力"] = JY.Person[p]["内力"] + JY.Thing[202][WZ7]*200;
	    end
	    
	    --超过四难度之后的三维
    	if JY.Thing[202][WZ7]-4 > 0 then
    		JY.Person[p]["攻击力"] = JY.Person[p]["攻击力"] + (JY.Thing[202][WZ7]-4)*50
    		JY.Person[p]["防御力"] = JY.Person[p]["防御力"] + (JY.Thing[202][WZ7]-4)*50
    		JY.Person[p]["轻功"] = JY.Person[p]["轻功"] + (JY.Thing[202][WZ7]-4)*50
    	end
    	
	  end
	end
	
  
  --选择系
  JY.TF = JYMsgBox("请选择主角的天赋能力", TFXZSAY1, TFE, 7, 50)
  SetS(10, 0, 6, 0, 1)
  if JY.TF == 1 then         --拳
    SetS(4, 5, 5, 5, 1)
    JY.Thing[201][WZ7] = 1
    JY.Person[0]["拳掌功夫"] = 40
	elseif JY.TF == 2 then     --剑
    SetS(4, 5, 5, 5, 2)
    JY.Thing[201][WZ7] = 2
    JY.Person[0]["御剑能力"] = 40   
	elseif JY.TF == 3 then     --刀
    SetS(4, 5, 5, 5, 3)
    JY.Thing[201][WZ7] = 3
    JY.Person[0]["耍刀技巧"] = 40
	elseif JY.TF == 4 then		 --特 
    SetS(4, 5, 5, 5, 4)
    JY.Thing[201][WZ7] = 4
    JY.Person[0]["特殊兵器"] = 40
	elseif JY.TF == 5 then		 --罡
    JY.Person[0]["内力最大值"] = 500
    JY.Person[0]["内力"] = 500
    JY.Person[0]["内力性质"] = 2
    JY.Thing[201][WZ7] = 5
    SetS(4, 5, 5, 5, 5)
	elseif JY.TF == 6 then		 --仁
    JY.Person[0]["品德"] = 100
    JY.Person[0]["拳掌功夫"] = 40
    JY.Person[0]["御剑能力"] = 40
    JY.Person[0]["耍刀技巧"] = 40
    JY.Person[0]["特殊兵器"] = 40
    JY.Thing[201][WZ7] = 6
    SetS(4, 5, 5, 5, 6)
	elseif JY.TF == 7 then		 --医 
    JY.Person[0][PSX[36]] = 200
    JY.Person[0][PSX[37]] = 200
    JY.Person[0][PSX[38]] = 200
    JY.Thing[201][WZ7] = 7
    SetS(4, 5, 5, 5, 7)
  end

  
  --设置实战，初始都为2，到时计算要-2
  for i = 1, #TeamP do
    SetS(5, i, 6, 5, 2)
    
  end
  
  
  --初始化事件，暂时不知道有什么用
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
  
  FINALWORK2()   --初始化物品数据，武功数据，人物出招动作，战役数据等
  
  --初始化设置

	SetS(60,24,26,3,80);		--在龙门客栈门口增加事件编号80   路过事件
	SetS(60,25,26,3,81);		--在龙门客栈门口增加事件编号81
	SetS(60,26,22,3,82);		--在龙门客栈增加事件编号82		--客栈里水笙
	SetS(60,27,22,3,83);		--在龙门客栈增加事件编号83		--客栈里 汪啸风
	SetS(60,25,30,3,84);		--在龙门客栈增加事件编号84			--客栈外  狄云
	SetS(60,24,32,3,85);		--在龙门客栈增加事件编号85			--客栈外 水笙
	SetS(60,25,32,3,86);		--在龙门客栈增加事件编号86			--客栈外 汪啸风
	SetS(60,25,31,3,87);		--在龙门客栈增加事件编号87			--客栈外 血刀老祖
	SetS(60,26,30,3,88);		--在龙门客栈增加事件编号88			--客栈外 水笙被捉
	
	SetS(2,29,30,3,80);			--在雪山增加事件编号80		狄云
	SetS(2,29,31,3,81);			--在雪山增加事件编号81		水笙
	
  
  --队友挑战
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
  JY.Wugong[201]["名称"] = "忍法胧地斩"
  JY.Wugong[201]["攻击力10"] = 1800
  for i = 497, 515 do
    JY.Person[i]["武功1"] = 201
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
    JY.Thing[138]["需内力性质"] = 2
    JY.Thing[138]["名称"] = "无名刀谱"
    JY.Wugong[64]["名称"] = "无名刀法"
    for i = 1, 10 do
      JY.Wugong[64]["移动范围" .. i] = 4
      JY.Wugong[64]["杀伤范围" .. i] = 0
    end
    JY.Wugong[64]["攻击范围"] = 3
  end

  
  --田伯光指令
	if GetS(86,10,12,5) == 1 then
		GRTS[29] = "浪荡"
    GRTSSAY[29] = "效果：本次攻击有机率打出浪荡招式*条件：体力大于50 内力大于500*消耗：体力12点 内力500点"
  elseif GetS(86,10,12,5) == 2 then
  	GRTS[29] = "戒色"
    GRTSSAY[29] = "效果：本回合气防和集气速度提高，受到伤害减少*条件：体力大于50 内力大于500*消耗：体力10点 内力500点"
	end
  
end



--机率判断
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

function Game_Cycle()       --游戏主循环
    lib.Debug("Start game cycle");

    while JY.Status ~=GAME_END do
        local t1=lib.GetTime();

	    JY.Mytick=JY.Mytick+1;    --20个节拍无击键，则主角变为站立状态
		if JY.Mytick%20==0 then
            JY.MyCurrentPic=0;
		end

        if JY.Mytick%1000==0 then
            JY.MYtick=0;
        end

        if JY.Status==GAME_FIRSTMMAP then  --首次显示主场景，重新调用主场景贴图，渐变显示。然后转到正常显示
        
			CleanMemory()
			  lib.ShowSlow(50, 1)
			  JY.MmapMusic = 16
			  JY.Status = GAME_MMAP
			  Init_MMap()
			  lib.DrawMMap(JY.Base["人X"], JY.Base["人Y"], GetMyPic())
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


function Game_MMap()      --主地图
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
			elseif keypress == VK_H then		--按h直接回家
	  		My_Enter_SubScene(70, 27, 30, 2);
	  		return;
	  	elseif keypress == VK_S then
	  		DrawStrBox(-1,-1,"存档中，请稍后...", C_WHITE, CC.DefaultFont);
	  		ShowScreen();
	      JY.Base["无用"] = -1
	      SaveRecord(3)
	      DrawStrBoxWaitKey("存档完毕", C_WHITE, CC.DefaultFont)
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
		    mx = math.modf(mx)+JY.Base["人X"];
		    my = math.modf(my)+ JY.Base["人Y"]
		    
		    --鼠标移动
		    if ktype == 2 then
		    	if lib.GetMMap(mx, my, 3) > 0 then				--如果有建筑，判断是否可进入
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
		
									i=5;		--退出循环
									break;
								end
							end
						end
					else
						CC.MMapAdress[0]= nil;
		
					end
				
				--鼠标左键
		    elseif ktype == 3 then
		    	if CC.MMapAdress[0] ~= nil then
			  		mx = CC.MMapAdress[3] - JY.Base["人X"];
			  		my = CC.MMapAdress[4] - JY.Base["人Y"];
			  		CC.MMapAdress[0]= nil;
			  	else
			  		AutoMoveTab = {[0] = 0}
			  		mx = mx - JY.Base["人X"]
			  		my = my - JY.Base["人Y"]
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


    local x,y;              --按照方向键要到达的坐标
	  local CanMove = function(nd, nnd)
	    local nx, ny = JY.Base["人X"] + CC.DirectX[nd + 1], JY.Base["人Y"] + CC.DirectY[nd + 1]
	    if nnd ~= nil then
	      nx, ny = nx + CC.DirectX[nnd + 1], ny + CC.DirectY[nnd + 1]
	    end
	    if CC.hx == nil and ((lib.GetMMap(nx, ny, 3) == 0 and lib.GetMMap(nx, ny, 4) == 0) or CanEnterScene(nx, ny) ~= -1) then
	      return true
	    else
	      return false
	    end
	  end
    if direct ~= -1 then   --按下了光标键

        AddMyCurrentPic();         --增加主角贴图编号，产生走路效果
        x=JY.Base["人X"]+CC.DirectX[direct+1];
        y=JY.Base["人Y"]+CC.DirectY[direct+1];
        JY.Base["人方向"]=direct;
    else
        x=JY.Base["人X"];
        y=JY.Base["人Y"];

    end

	if direct~=-1 then
		JY.SubScene=CanEnterScene(x,y);   --判断是否进入子场景
	end

    if lib.GetMMap(x,y,3)==0 and lib.GetMMap(x,y,4)==0 then     --没有建筑，可以到达
        JY.Base["人X"]=x;
        JY.Base["人Y"]=y;
    end
    JY.Base["人X"]=limitX(JY.Base["人X"],10,CC.MWidth-10);           --限制坐标不能超出范围
    JY.Base["人Y"]=limitX(JY.Base["人Y"],10,CC.MHeight-10);

    if CC.MMapBoat[lib.GetMMap(JY.Base["人X"],JY.Base["人Y"],0)]==1 then
	    JY.Base["乘船"]=1;
	else
	    JY.Base["乘船"]=0;
	end

    lib.DrawMMap(JY.Base["人X"],JY.Base["人Y"],GetMyPic());             --显示主地图
    if CC.ShowXY==1 then
	    DrawString(10,CC.ScreenH-20,string.format("%d %d",JY.Base["人X"],JY.Base["人Y"]) ,C_GOLD,16);
	end
	
		DrawTimer();
		JYZTB();
		
		
		--显示鼠标指中的场景名称
	  if CC.MMapAdress[0] ~= nil then
			DrawStrBox(CC.MMapAdress[1]+10,CC.MMapAdress[2],JY.Scene[CC.MMapAdress[0]]["名称"],C_GOLD,CC.DefaultFont);
		end
		
    ShowScreen();

    if JY.SubScene >= 0 then          --进入子场景
        CleanMemory();
		lib.UnloadMMap();
        lib.PicInit();
        lib.ShowSlow(50,1)

		JY.Status=GAME_SMAP;
        JY.MmapMusic=-1;

        JY.MyPic=GetMyPic();
        JY.Base["人X1"]=JY.Scene[JY.SubScene]["入口X"]
        JY.Base["人Y1"]=JY.Scene[JY.SubScene]["入口Y"]

        Init_SMap(1);
		return
    end
end

--主角走路
function walkto(xx,yy,x,y,flag)
	local x,y
	AutoMoveTab={[0]=0}
	if JY.Status==GAME_SMAP  then
		x=x or JY.Base["人X1"]
		y=y or JY.Base["人Y1"]
	elseif JY.Status==GAME_MMAP then
		x=x or JY.Base["人X"]
		y=y or JY.Base["人Y"]
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

				CC.AutoMoveEvent[0] = 1;		--鼠标操作触发事件
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

function GetMyPic()      --计算主角当前贴图
    local n;
	if JY.Status==GAME_MMAP and JY.Base["乘船"]==1 then
		if JY.MyCurrentPic >=4 then
			JY.MyCurrentPic=0
		end
	else
		if JY.MyCurrentPic >6 then
			JY.MyCurrentPic=1
		end
	end

	if JY.Base["乘船"]==0 then
        n=CC.MyStartPic+JY.Base["人方向"]*7+JY.MyCurrentPic;
	else
	    n=CC.BoatStartPic+JY.Base["人方向"]*4+JY.MyCurrentPic;
	end
	return n;
end

--增加当前主角走路动画帧, 主地图和场景地图都使用
function AddMyCurrentPic()        ---增加当前主角走路动画帧,
    JY.MyCurrentPic=JY.MyCurrentPic+1;
end

--场景是否可进
--id 场景代号
--x,y 当前主地图坐标
--返回：场景id，-1表示没有场景可进
function CanEnterScene(x,y)         --场景是否可进
    for id = 0,JY.SceneNum-1 do
		local scene=JY.Scene[id];
		if (x==scene["外景入口X1"] and y==scene["外景入口Y1"]) or
		   (x==scene["外景入口X2"] and y==scene["外景入口Y2"]) then
			local e=scene["进入条件"];
			if e==0 then        --可进
				return id;
			elseif e==1 then    --不可进
				return -1
			elseif e==2 then    --有轻功高者进
				for i=1,CC.TeamNum do
					local pid=JY.Base["队伍" .. i];
					if pid>=0 then
						if JY.Person[pid]["轻功"]>=70 then
							return id;
						end
					end
				end
			end
		end
	end
    return -1;
end

--主菜单
function MMenu()      --主菜单
    local menu={      {"医疗",Menu_Doctor,1},
	                  {"解毒",Menu_DecPoison,1},
	                  {"物品",Menu_Thing,1},
	                  {"状态",Menu_Status,1},
	                  {"离队",Menu_PersonExit,1},
	                  {"系统",Menu_System,1},      };
    if JY.Status==GAME_SMAP then  --子场景，后两个菜单不可见
        --menu[5][3]=0;
        --menu[6][3]=0;
    end

    ShowMenu(menu,6,0,CC.MainMenuX,CC.MainMenuY,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE)
end

--系统子菜单
function Menu_System()
  local menu = {
{"读取进度", Menu_ReadRecord, 1}, 
{"保存进度", Menu_SaveRecord, 1}, 
{"关闭音乐", Menu_SetMusic, 1}, 
{"关闭音效", Menu_SetSound, 1}, 
{"物品整理", Menu_WPZL, 1}, 
{"回营整备", nil, 1}, 
{"马车传送", nil, 1}, 
{"系统攻略", Menu_Help, 1},
{"我的代码", Menu_MYDIY, 1},
{"离开游戏", Menu_Exit, 1}}
  if JY.EnableMusic == 0 then
    menu[3][1] = "打开音乐"
  end
  if JY.EnableSound == 0 then
    menu[4][1] = "打开音效"
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
	local r = JYMsgBox("我的代码","执行自定义代码*指定在script/DIY.lua文件",{"确定","取消"},2,nil,1);
	if r == 1 then
		dofile(CONFIG.ScriptPath.."DIY.lua");
	end
end

function Menu_Help()
	local title = "系统攻略";
	local str ="装备说明：查看各种装备的说明。"
						.."*武功说明：查看各种武功的说明。"
						.."*天书攻略：各种天书的拿法，以及游戏技攻略。"
	local btn = {"装备说明","武功说明","天书攻略"};
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

--音乐开关
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
--音效开关
function Menu_SetSound()
  if JY.EnableSound == 0 then
    JY.EnableSound = 1
  else
    JY.EnableSound = 0
  end
  return 1
end

--物品菜单
function Menu_Thing()
  local menu = {
{"全部物品", nil, 1}, 
{"剧情物品", nil, 1}, 
{"神兵宝甲", nil, 1}, 
{"武功秘笈", nil, 1}, 
{"灵丹妙药", nil, 1}, 
{"伤人暗器", nil, 1}}
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
      local id = JY.Base["物品" .. i + 1]
      if id >= 0 then
        if r == 1 then
          thing[i] = id
          thingnum[i] = JY.Base["物品数量" .. i + 1]
        else
	        if JY.Thing[id]["类型"] == r - 2 then
	          thing[num] = id
	          thingnum[num] = JY.Base["物品数量" .. i + 1]
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

--物品整理
function Menu_WPZL()
  
  local function swap(a, b) 
          JY.Base["物品" .. a], JY.Base["物品" .. b] = JY.Base["物品" .. b], JY.Base["物品" .. a]
    JY.Base["物品数量" .. a], JY.Base["物品数量" .. b] = JY.Base["物品数量" .. b], JY.Base["物品数量" .. a]
  end
  
  local flag = 0;
  for i=1, CC.MyThingNum do
          flag = 0;
                for j=1, CC.MyThingNum-i+1 do
                        if JY.Base["物品"..j] > -1 and JY.Base["物品" .. j+1] > -1 then                --如果两个物品有效
                        
                                local wg1 = JY.Thing[JY.Base["物品"..j]]["练出武功"];
                                local wg2 = JY.Thing[JY.Base["物品"..j+1]]["练出武功"];
                                                         
                                if wg2 < 0 then                --不可练出武功的根据编号排序
                                         if wg1 > 0 or  (wg1 < 0 and JY.Base["物品"..j] > JY.Base["物品"..j+1])  then                
                                                swap(j, j+1);
                  flag = 1;
                  
                                        end
                                        
                                elseif wg1 > 0 then                        --可练出武功的根据类型排序，如果类型相同，再根据武功10级威力排序                         
                                         if JY.Wugong[wg1]["武功类型"] > JY.Wugong[wg2]["武功类型"] or (JY.Wugong[wg1]["武功类型"] == JY.Wugong[wg2]["武功类型"]  and JY.Wugong[wg1]["攻击力10"] > JY.Wugong[wg2]["攻击力10"]) then
                                                 swap(j, j+1);
                        flag = 1;
                                         end
                                end
                                
                        end 
                end
                
                if flag == 0 then                        --如果一轮下来没有任何的交换，肯定就是已经排好序了，直接退出
                        break;
                end
  end
  Cls()
  DrawStrBoxWaitKey("物品整理完成", C_WHITE, CC.DefaultFont)
end

--物品使用菜单
function MenuDSJ()
  local menu = {
{"全部物品", nil, 0}, 
{"剧情物品", nil, 0}, 
{"神兵宝甲", nil, 1}, 
{"武功秘笈", nil, 1}, 
{"灵丹妙药", nil, 1}, 
{"伤人暗器", nil, 1}}
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
      local id = JY.Base["物品" .. i + 1]
      if id >= 0 then
        if r == 1 then
          thing[i] = id
          thingnum[i] = JY.Base["物品数量" .. i + 1]  
        else
	        if JY.Thing[id]["类型"] == r - 2 then
	          thing[num] = id
	          thingnum[num] = JY.Base["物品数量" .. i + 1]
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

--回营整备
function Menu_HYZB()
  if JY.SubScene ~= 25 then
    JY.SubScene = 70
    JY.Base["人X1"] = 8
    JY.Base["人Y1"] = 28
    JY.Base["人X"] = 358
    JY.Base["人Y"] = 235
  end
end

--离开菜单
function Menu_Exit()      --离开菜单
    Cls();
    if DrawStrBoxYesNo(-1,-1,"是否真的要离开游戏(Y/N)?",C_WHITE,CC.DefaultFont) == true then
        JY.Status =GAME_END;
    end
    return 1;
end


--保存进度
function Menu_SaveRecord()         --保存进度菜单
--[[
	local menu={ {"进度一",nil,1},
                 {"进度二",nil,1},
                 {"进度三",nil,1},  };
                 
    local r=ShowMenu(menu,3,0,CC.MainSubMenuX2,CC.MainSubMenuY,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE);
]]
	local r = SaveList();
    if r>0 then
        DrawStrBox(CC.MainSubMenuX2,CC.MainSubMenuY,"请稍候......",C_WHITE,CC.DefaultFont);
        ShowScreen();
        SaveRecord(r);
        Cls();
	end
    return 0;
end

--读取进度
function Menu_ReadRecord()        --读取进度菜单
	--[[
	local menu={ {"进度一",nil,1},
                 {"进度二",nil,1},
                 {"进度三",nil,1},  };
    local r=ShowMenu(menu,3,0,CC.MainSubMenuX2,CC.MainSubMenuY,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE);

    if r == 0 then
        return 0;
    elseif r>0 then
        DrawStrBox(CC.MainSubMenuX2,CC.MainSubMenuY,"请稍候......",C_WHITE,CC.DefaultFont);
        ShowScreen();
        LoadRecord(r);
  ]]
  	  local r = SaveList();
    	if r < 1 then
    		return 0;
    	end
    	
    	Cls();
			DrawStrBox(-1,CC.StartMenuY,"请稍候...",C_GOLD,CC.DefaultFont);
			ShowScreen();
    	local result = LoadRecord(r);
    	if result ~= nil then
    		return 0;
    	end
		if JY.Base["无用"] ~= -1 then
		  if JY.SubScene < 0 then
			CleanMemory()
			lib.UnloadMMap()
		  end
		  lib.PicInit()
		  lib.ShowSlow(50, 1)
		  JY.Status = GAME_SMAP
		  JY.SubScene = JY.Base["无用"]
		  JY.MmapMusic = -1
		  JY.MyPic = GetMyPic()
		  Init_SMap(1)
		else
		  JY.SubScene = -1
		  JY.Status = GAME_FIRSTMMAP
		end
    return 1;

end

--状态子菜单
function Menu_Status()           --状态子菜单
    DrawStrBox(CC.MainSubMenuX,CC.MainSubMenuY,"要查阅谁的状态",C_WHITE,CC.DefaultFont);
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

--离队菜单
function Menu_PersonExit()
  DrawStrBox(CC.MainSubMenuX, CC.MainSubMenuY, "要求谁离队", C_WHITE, CC.DefaultFont)
  local nexty = CC.MainSubMenuY + CC.SingleLineHeight
  local r = SelectTeamMenu(CC.MainSubMenuX, nexty)
  if r == 1 then
    DrawStrBoxWaitKey("抱歉！没有你游戏进行不下去", C_WHITE, CC.DefaultFont, 1)
  else
    if JY.SubScene == 82 then
      do return end
    end
  end
  if r > 0 and JY.SubScene == 55 and JY.Base["队伍" .. r] == 35 then
    do return end
  end
  if r > 1 then
    local personid = JY.Base["队伍" .. r]
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

--队伍选择人物菜单
function SelectTeamMenu(x,y)          --队伍选择人物菜单
	local menu={};
	for i=1,CC.TeamNum do
        menu[i]={"",nil,0};
		local id=JY.Base["队伍" .. i]
		if id>=0 then
            if JY.Person[id]["生命"]>0 then
                menu[i][1]=JY.Person[id]["姓名"];
                menu[i][3]=1;
            end
		end
	end
    return ShowMenu(menu,CC.TeamNum,0,x,y,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE);
end

function GetTeamNum()            --得到队友个数
    local r=CC.TeamNum;
	for i=1,CC.TeamNum do
	    if JY.Base["队伍" .. i]<0 then
		    r=i-1;
		    break;
		end
    end
	return r;
end

---显示队友状态
-- 左右键翻页，上下键换队友
function ShowPersonStatus(teamid)
  local page = 1
  local pagenum = 2
  local teamnum = GetTeamNum()
  while true do
    Cls()
    local id = JY.Base["队伍" .. teamid]
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
      	
        say(TFNLJS[tfid], JY.Person[id]["头像代号"], 5, JY.Person[id]["姓名"])
      end
    end
    teamid = limitX(teamid, 1, teamnum)
    page = limitX(page, 1, pagenum)
  end
end

--显示人物具体信息
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
  --local headw, headh = lib.PicGetXY(1, p["头像代号"] * 2)

  local hid = nil
  if id == 0 then
    if GetS(4, 5, 5, 5) < 8 then
      hid = 280 + GetS(4, 5, 5, 5)
    else
      hid = 287 + GetS(4, 5, 5, 4)
    end
  else
    hid = p["头像代号"]
  end
  local headw, headh = lib.GetPNGXY(1, hid*2)
  local headx = (width / 2 - headw) / 3
  local heady = (h * 6 - headh) / 6
  --lib.PicLoadCache(1, hid * 2, x1 + headx, y1 + heady, 1)
  lib.LoadPNG(1, hid * 2 , x1 + headx, y1 + heady, 1)
  i = 5
  DrawString(x1, y1 + h * i, p["姓名"], C_WHITE, size)
  DrawString(x1 + 10 * size / 2, y1 + h * i, string.format("%3d", p["等级"]), C_GOLD, size)
  DrawString(x1 + 13 * size / 2, y1 + h * i, "级", C_ORANGE, size)
  i = i + 1
  DrawString(x1, y1 + h * (i), "天赋：", C_GOLD, size)
  

  --主角如果不是特殊人物，天赋
  if id == 0  then
    DrawString(x1 + size * 3, y1 + h * (i), ZJTF[JY.Thing[201][WZ7]], C_GOLD, size)
  end

  --普通角色天赋
  if id ~= 0 and RWTFLB[id] ~= nil then
    DrawString(x1 + size * 3, y1 + h * (i), RWTFLB[id], C_GOLD, size)
  end
  
  
  --称号
  i = i + 1
  DrawString(x1, y1 + h * (i), "称号：", C_GOLD, size)
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
  
  if JY.Person[49]["武功1"] == 8 and id == 49 then
    DrawString(x1 + size * 3, y1 + h * (i), RWWH["49"], C_GOLD, size)
  end
  
  
  --武功
  for w = 1, 10 do
    if JY.Person[38]["武功" .. w] <= 0 then
      break;
    end
    if JY.Person[38]["武功" .. w] == 102 and id == 38 then
      DrawString(x1 + size * 3, y1 + h * (i), RWWH["38"], C_GOLD, size)
    end
  end
  
  
  --受伤，流血，中毒，封穴，内力性质等属性
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
    if p["受伤程度"] < 33 then
      color = RGB(236, 200, 40)
    elseif p["受伤程度"] < 66 then
      color = RGB(244, 128, 32)
    else
      color = RGB(232, 32, 44)
    end
    i = i + 1
    DrawString(x1, y1 + h * (i), "生命", C_ORANGE, size)
    DrawString(x1 + 2 * size, y1 + h * (i), string.format("%5d", p["生命"]), color, size)
    DrawString(x1 + 9 * size / 2, y1 + h * (i), "/", C_GOLD, size)
    if p["中毒程度"] == 0 then
      color = RGB(252, 148, 16)
    elseif p["中毒程度"] < 50 then
      color = RGB(120, 208, 88)
    else
      color = RGB(56, 136, 36)
    end
    DrawString(x1 + 5 * size, y1 + h * (i), string.format("%5s", p["生命最大值"]), color, size)
    i = i + 1
    if p["内力性质"] == 0 then
      color = RGB(208, 152, 208)
    elseif p["内力性质"] == 1 then
      color = RGB(236, 200, 40)
    else
      color = RGB(236, 236, 236)
    end
    if GetS(4, 5, 5, 5) == 5 and id == 0 then
      color = RGB(216, 20, 24)
    end
    DrawString(x1, y1 + h * (i), "内力", C_ORANGE, size)
    DrawString(x1 + 2 * size, y1 + h * (i), string.format("%5d/%5d", p["内力"], p["内力最大值"]), color, size)
    i = i + 1
    DrawString(x1, y1 + h * (i), "体力", C_ORANGE, size)
    DrawString(x1 + size * 2 + 8, y1 + h * (i), p["体力"], C_GOLD, size)
    DrawString(x1 + size * 4 + 16, y1 + h * (i), "体质", C_ORANGE, size)
    DrawString(x1 + size * 6 + 32, y1 + h * (i), p["生命增长"], C_GOLD, size)
    i = i + 1
    
    --实战
    DrawString(x1, y1 + h * (i), "实战", C_ORANGE, size)
    for j = 1, #TeamP do
      if id == TeamP[j] then
        local num, cl = GetS(5, j, 6, 5) - 2, C_GOLD
        if num > 499 then
          num = "极"
          cl = C_RED
        end
        DrawString(x1 + size * 2 + 8, y1 + h * (i), num, cl, size)
        break;
      end
    end
    
    --左右
    DrawString(x1 + size * 4 + 16, y1 + h * (i), "互搏", C_ORANGE, size)
    local hb = nil
    if p["左右互搏"] == 1 then
      hb = "◎"
    else
      hb = "※"
    end
    
    --经验值
    DrawString(x1 + size * 6 + 24, y1 + h * (i), hb, C_GOLD, size)
    i = i + 1
    DrawString(x1, y1 + h * (i), "升级", C_ORANGE, size)
    local kk = nil
    if p["等级"] >= 30 then
      kk = "   ="
    else
      kk = 2 * (p["经验"] - CC.Exp[p["等级"] - 1])
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
    
    --等级
    DrawString(x1 + size * 2 + 16, y1 + h * (i), kk, C_GOLD, size)
    local tmp = nil
    if CC.Level <= p["等级"] then
      tmp = "="
    else
      tmp = 2 * (CC.Exp[p["等级"]] - CC.Exp[p["等级"] - 1])
    end
    
    --装备
    DrawString(x1 + size * 4 + 16, y1 + h * (i), "/" .. tmp, C_GOLD, size)
    local tmp1, tmp2, tmp3 = 0, 0, 0
    if p["武器"] > -1 then
      tmp1 = tmp1 + JY.Thing[p["武器"]]["加攻击力"]
      tmp2 = tmp2 + JY.Thing[p["武器"]]["加防御力"]
      tmp3 = tmp3 + JY.Thing[p["武器"]]["加轻功"]
    end
    if p["防具"] > -1 then
      tmp1 = tmp1 + JY.Thing[p["防具"]]["加攻击力"]
      tmp2 = tmp2 + JY.Thing[p["防具"]]["加防御力"]
      tmp3 = tmp3 + JY.Thing[p["防具"]]["加轻功"]
    end
    
    --中毒、封穴、流血
    i = i + 1
    DrawString(x1, y1 + h * (i), "中毒", C_ORANGE, size)
    DrawString(x1 + size * 2 + 10, y1 + h * (i), p["中毒程度"], C_BLACK, size)
    DrawString(x1 + size * 4 + 20, y1 + h * (i), "内伤", C_ORANGE, size)
    DrawString(x1 + size * 6 + 30, y1 + h * (i), p["受伤程度"], C_RED, size)
    DrawString(x1 + size * 8 + 40, y1 + h * (i), "封穴", C_ORANGE, size)
    if JY.Status == GAME_WMAP and WAR.FXDS[id] ~= nil then
      DrawString(x1 + size * 10 + 50, y1 + h * (i), WAR.FXDS[id], C_GOLD, size)
    else
      DrawString(x1 + size * 10 + 50, y1 + h * (i), 0, C_GOLD, size)
    end
    DrawString(x1 + size * 12 + 60, y1 + h * (i), "流血", C_ORANGE, size)
    if JY.Status == GAME_WMAP and WAR.LXZT[id] ~= nil then
      DrawString(x1 + size * 14 + 70, y1 + h * (i), WAR.LXZT[id], C_RED, size)
    else
      DrawString(x1 + size * 14 + 70, y1 + h * (i), 0, C_RED, size)
    end
    i = i + 1
    DrawString(x1, y1 + h * (i), "左右键翻页 上下键换人 空格键能力解说", C_RED, size)
    i = 0
    x1 = dx + width / 2 - 24
    DrawAttrib("攻击力", C_WHITE, C_GOLD)
    DrawString(x1 + size * 7, y1, "↑ " .. tmp1, C_GOLD, size)
    DrawAttrib("防御力", C_WHITE, C_GOLD)
    DrawString(x1 + size * 7, y1 + h, "↑ " .. tmp2, C_GOLD, size)
    DrawAttrib("轻功", C_WHITE, C_GOLD)
    if tmp3 > -1 then
      DrawString(x1 + size * 7, y1 + h * 2, "↑ " .. tmp3, C_GOLD, size)
    else
      tmp3 = -(tmp3)
      DrawString(x1 + size * 7, y1 + h * 2, "↓ " .. tmp3, C_GOLD, size)
    end
    
    --能力属性
    DrawAttrib("医疗能力", C_WHITE, C_GOLD)
    DrawAttrib("用毒能力", C_WHITE, C_GOLD)
    DrawAttrib("解毒能力", C_WHITE, C_GOLD)
    DrawAttrib("拳掌功夫", C_WHITE, C_GOLD)
    DrawAttrib("御剑能力", C_WHITE, C_GOLD)
    DrawAttrib("耍刀技巧", C_WHITE, C_GOLD)
    DrawAttrib("特殊兵器", C_WHITE, C_GOLD)
    DrawAttrib("暗器技巧", C_WHITE, C_GOLD)
    DrawAttrib("资质", C_WHITE, C_GOLD)
  elseif page == 2 then
    i = i + 1
    DrawString(x1, y1 + h * (i), "武器:", C_ORANGE, size)
    if p["武器"] > -1 then
      DrawString(x1 + size * 3, y1 + h * (i), JY.Thing[p["武器"]]["名称"], C_GOLD, size)
    end
    i = i + 1
    DrawString(x1, y1 + h * (i), "防具:", C_ORANGE, size)
    if p["防具"] > -1 then
      DrawString(x1 + size * 3, y1 + h * (i), JY.Thing[p["防具"]]["名称"], C_GOLD, size)
    end
    i = i + 1
    DrawString(x1, y1 + h * (i), "特殊:", C_ORANGE, size)
    if p["无用"] > 236 then
      DrawString(x1 + size * 3, y1 + h * (i), JY.Thing[p["无用"]]["名称"], C_ORANGE, size)
      
      lib.SetClip(x1 + size * 3, y1 + h * 1, x1 + size * 3 + string.len(JY.Thing[p["无用"]]["名称"]) * size/2 * JY.Thing[p["无用"]]["需经验"] / 1000, y1 + h * (i) + h)
      DrawString(x1 + size * 3, y1 + h * (i), JY.Thing[p["无用"]]["名称"], M_RoyalBlue, size)
      lib.SetClip(0, 0, 0, 0)
    end
    i = i + 1
    DrawString(x1, y1 + h * (i), "修炼物品", C_ORANGE, size)
    local thingid = p["修炼物品"]
    if thingid > 0 then
      i = i + 1
      DrawString(x1 + size, y1 + h * (i), JY.Thing[thingid]["名称"], C_GOLD, size)
      i = i + 1
      local n = TrainNeedExp(id)
      if n < math.huge then
        DrawString(x1 + size, y1 + h * (i), string.format("%5d/%5d", p["修炼点数"], n), C_GOLD, size)
      else
        DrawString(x1 + size, y1 + h * (i), string.format("%5d/===", p["修炼点数"]), C_GOLD, size)
      end
    else
      i = i + 2
    end
    i = i + 1
    DrawString(x1, y1 + h * (i), "左右键翻页 上下键换人 空格键能力解说", C_RED, size)
    i = 0
    x1 = dx + width / 2
    
    --武功显示
    DrawString(x1, y1 + h * i, "所会功夫", C_ORANGE, size)
    local T = {"一", "二", "三", "四", "五", "六", "七", "八", "九", "十", "极"}
    if JY.Person[0]["武功1"] > 108 and JY.Person[0]["武功等级1"] < 900 then
      JY.Person[0]["武功等级1"] = 900
    end
    for j = 1, 10 do
      i = i + 1
      local wugong = p["武功" .. j]
      if wugong > 0 then
        local level = math.modf(p["武功等级" .. j] / 100) + 1
        if p["武功等级" .. j] == 999 then
          level = 11
        end
        DrawString(x1 + size, y1 + h * (i), string.format("%s", JY.Wugong[wugong]["名称"]), C_GOLD, size)
        if p["武功等级" .. j] > 900 then
          lib.SetClip(x1 + size, y1 + h * 1, x1 + size + string.len(JY.Wugong[wugong]["名称"]) * size * (p["武功等级" .. j] - 900) / 200, y1 + h * (i) + h)
          DrawString(x1 + size, y1 + h * (i), string.format("%s", JY.Wugong[wugong]["名称"]), C_ORANGE, size)
          lib.SetClip(0, 0, 0, 0)
        end
        DrawString(x1 + size * 7, y1 + h * (i), T[level], C_WHITE, size)
      end
    end
    i = 11
    DrawString(x1 + size, y1 + h * i, "怒气", C_ORANGE, size)
    if JY.Status == GAME_WMAP and WAR.LQZ[id] ~= nil then
      DrawString(x1 + size * 3 + 10, y1 + h * i, WAR.LQZ[id], C_GOLD, size)
    else
      DrawString(x1 + size * 3 + 10, y1 + h * i, 0, C_GOLD, size)
    end
    if id == 0 then
    	DrawString(x1 + size * 5 + 10, y1 + h * i, "武常", C_ORANGE, size)
    	DrawString(x1 + size * 7 + 20, y1 + h * i, p["武学常识"], C_GOLD, size)
    else
    	DrawString(x1 + size * 5 + 10, y1 + h * i, "※※", C_ORANGE, size)
    	DrawString(x1 + size * 7 + 20, y1 + h * i, 0, C_GOLD, size)
    end
  end
end


--计算人物修炼成功需要的点数
--id 人物id
function TrainNeedExp(id)         --计算人物修炼物品成功需要的点数
    local thingid=JY.Person[id]["修炼物品"];
	local r =0;
	if thingid >= 0 then
        if JY.Thing[thingid]["练出武功"] >=0 then
            local level=0;          --此处的level是实际level-1。这样没有武功時和炼成一级是一样的。
			for i =1,10 do               -- 查找当前已经炼成武功等级
			    if JY.Person[id]["武功" .. i]==JY.Thing[thingid]["练出武功"] then
                    level=math.modf(JY.Person[id]["武功等级" .. i] /100);
					break;
                end
            end
			if level <9 then
                r=(7-math.modf(JY.Person[id]["资质"]/15))*JY.Thing[thingid]["需经验"]*(level+1);
			else
                r=math.huge;
			end
		else
            r=(7-math.modf(JY.Person[id]["资质"]/15))*JY.Thing[thingid]["需经验"]*2;
		end
	end
    return r;
end

--医疗菜单
function Menu_Doctor()       --医疗菜单
    DrawStrBox(CC.MainSubMenuX,CC.MainSubMenuY,"谁要使用医术",C_WHITE,CC.DefaultFont);
	local nexty=CC.MainSubMenuY+CC.SingleLineHeight;
    DrawStrBox(CC.MainSubMenuX,nexty,"医疗能力",C_ORANGE,CC.DefaultFont);

	local menu1={};
	for i=1,CC.TeamNum do
        menu1[i]={"",nil,0};
		local id=JY.Base["队伍" .. i]
        if id >=0 then
            if JY.Person[id]["医疗能力"]>=20 then
                 menu1[i][1]=string.format("%-10s%4d",JY.Person[id]["姓名"],JY.Person[id]["医疗能力"]);
                 menu1[i][3]=1;
            end
        end
	end

    local id1,id2;
	nexty=nexty+CC.SingleLineHeight;
    local r=ShowMenu(menu1,CC.TeamNum,0,CC.MainSubMenuX,nexty,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE);

    if r >0 then
	    id1=JY.Base["队伍" .. r];
        Cls(CC.MainSubMenuX,CC.MainSubMenuY,CC.ScreenW,CC.ScreenH);
        DrawStrBox(CC.MainSubMenuX,CC.MainSubMenuY,"要医治谁",C_WHITE,CC.DefaultFont);
        nexty=CC.MainSubMenuY+CC.SingleLineHeight;

		local menu2={};
		for i=1,CC.TeamNum do
			menu2[i]={"",nil,0};
			local id=JY.Base["队伍" .. i]
			if id>=0 then
				 menu2[i][1]=string.format("%-10s%4d/%4d",JY.Person[id]["姓名"],JY.Person[id]["生命"],JY.Person[id]["生命最大值"]);
				 menu2[i][3]=1;
			end
		end

		local r2=ShowMenu(menu2,CC.TeamNum,0,CC.MainSubMenuX,nexty,0,0,1,1,CC.DefaultFont,C_ORANGE,C_WHITE);

		if r2 >0 then
	        id2=JY.Base["队伍" .. r2];
            local num=ExecDoctor(id1,id2);
			if num>0 then
                AddPersonAttrib(id1,"体力",-2);
			end
            DrawStrBoxWaitKey(string.format("%s 生命增加 %d",JY.Person[id2]["姓名"],num),C_ORANGE,CC.DefaultFont);
		end
	end

	Cls();

    return 0;
end

--执行医疗
--id1 医疗id2, 返回id2生命增加点数
function ExecDoctor(id1,id2)      --执行医疗
	if JY.Person[id1]["体力"]<50 then
        return 0;
	end

	local add=JY.Person[id1]["医疗能力"];
    local value=JY.Person[id2]["受伤程度"];
    if value > add+20 then
        return 0;
	end

    if value <25 then    --根据受伤程度计算实际医疗能力
        add=add*4/5;
	elseif value <50 then
        add=add*3/4;
	elseif value <75 then
        add=add*2/3;
	else
        add=add/2;
	end
 	add=math.modf(add)+Rnd(5);

    AddPersonAttrib(id2,"受伤程度",-add);
    return AddPersonAttrib(id2,"生命",add)
end

--解毒
function Menu_DecPoison()         --解毒
    DrawStrBox(CC.MainSubMenuX,CC.MainSubMenuY,"谁要帮人解毒",C_WHITE,CC.DefaultFont);
	local nexty=CC.MainSubMenuY+CC.SingleLineHeight;
    DrawStrBox(CC.MainSubMenuX,nexty,"解毒能力",C_ORANGE,CC.DefaultFont);


	local menu1={};
	for i=1,CC.TeamNum do
        menu1[i]={"",nil,0};
		local id=JY.Base["队伍" .. i]
        if id>=0 then
            if JY.Person[id]["解毒能力"]>=20 then
                 menu1[i][1]=string.format("%-10s%4d",JY.Person[id]["姓名"],JY.Person[id]["解毒能力"]);
                 menu1[i][3]=1;
            end
        end
	end

    local id1,id2;
 	nexty=nexty+CC.SingleLineHeight;
    local r=ShowMenu(menu1,CC.TeamNum,0,CC.MainSubMenuX,nexty,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE);

    if r >0 then
	    id1=JY.Base["队伍" .. r];
         Cls(CC.MainSubMenuX,CC.MainSubMenuY,CC.ScreenW,CC.ScreenH);
        DrawStrBox(CC.MainSubMenuX,CC.MainSubMenuY,"替谁解毒",C_WHITE,CC.DefaultFont);
		nexty=CC.MainSubMenuY+CC.SingleLineHeight;

        DrawStrBox(CC.MainSubMenuX,nexty,"中毒程度",C_WHITE,CC.DefaultFont);
	    nexty=nexty+CC.SingleLineHeight;

		local menu2={};
		for i=1,CC.TeamNum do
			menu2[i]={"",nil,0};
			local id=JY.Base["队伍" .. i]
			if id>=0 then
				 menu2[i][1]=string.format("%-10s%5d",JY.Person[id]["姓名"],JY.Person[id]["中毒程度"]);
				 menu2[i][3]=1;
			end
		end

		local r2=ShowMenu(menu2,CC.TeamNum,0,CC.MainSubMenuX,nexty,0,0,1,1,CC.DefaultFont,C_ORANGE, C_WHITE);
		if r2 >0 then
	        id2=JY.Base["队伍" .. r2];
            local num=ExecDecPoison(id1,id2);
            DrawStrBoxWaitKey(string.format("%s 中毒程度减少 %d",JY.Person[id2]["姓名"],num),C_ORANGE,CC.DefaultFont);
		end
	end
    Cls();
    ShowScreen();
    return 0;
end

--解毒
--id1 解毒id2, 返回id2中毒减少点数
function ExecDecPoison(id1,id2)     --执行解毒
    local add=JY.Person[id1]["解毒能力"];
    local value=JY.Person[id2]["中毒程度"];

    if value > add+20 then
        return 0;
	end

 	add=limitX(math.modf(add/3)+Rnd(10)-Rnd(10),0,value);
    return -AddPersonAttrib(id2,"中毒程度",-add);
end


--显示物品菜单
function SelectThing(thing,thingnum)    

  local xnum=CC.MenuThingXnum;
  local ynum=CC.MenuThingYnum;

	local w=CC.ThingPicWidth*xnum+(xnum-1)*CC.ThingGapIn+2*CC.ThingGapOut;  --总体宽度
	local h=CC.ThingPicHeight*ynum+(ynum-1)*CC.ThingGapIn+2*CC.ThingGapOut; --物品栏高度

	local dx=(CC.ScreenW-w)/2;
	local dy=(CC.ScreenH-h-2*(CC.ThingFontSize+2*CC.MenuBorderPixel+8))/2-CC.ThingFontSize;


  local y1_1,y1_2,y2_1,y2_2,y3_1,y3_2;                  --名称，说明和图片的Y坐标

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
	      local id=y*xnum+x+xnum*cur_line         --当前待选择物品
				local boxcolor;
	      if x==cur_x and y==cur_y then
		    	boxcolor=C_WHITE;
	        if thing[id]>=0 then
	          cur_thing=thing[id];
	          local str=JY.Thing[thing[id]]["名称"];
	          if JY.Thing[thing[id]]["类型"]==1 or JY.Thing[thing[id]]["类型"]==2 then
	            if JY.Thing[thing[id]]["使用人"] >=0 then
	            	str=str .. "(" .. JY.Person[JY.Thing[thing[id]]["使用人"]]["姓名"] .. ")";
	            end
	          end
	          str=string.format("%s X %d",str,thingnum[id]);
						local str2=JY.Thing[thing[id]]["物品说明"];
						if thing[id]==182 then
							str2=str2..string.format('(人%3d,%3d)',JY.Base['人X'],JY.Base['人Y'])
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
							elseif myThing[ss]==0 and ss=="需内力性质" then
								mys=string.format(str..':%s',news[myThing[ss]])
							else
								return
							end
							
							--苍天泰坦：修复秘籍限制内力属性为阴性不显示的BUG，并分色显示，老二写的代码
							local ccc=C_GOLD
							if ss=="需内力性质" then
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
						
						--苍天泰坦：同样是老二
						if myThing["练出武功"] > 0 then
							local kfname = "习得:" .. JY.Wugong[myThing["练出武功"]]["名称"]
							DrawStrBox(mx, my, kfname, C_GOLD, myfont)
							mx = mx + myfont * string.len(kfname) / 2 + 12
							if JY.Wugong[myThing["练出武功"]]["攻击力10"] > 0 then
								local kfwl = "威力:" .. JY.Wugong[myThing["练出武功"]]["攻击力10"]
								DrawStrBox(mx, my, kfwl, C_GOLD, myfont)
								mx = mx + myfont * string.len(kfwl) / 2 + 12
							end
						end
	          
						if myThing['类型']>0 then
							drawitem('加生命','生命')
							drawitem('加生命最大值','生命最值')
							drawitem('加中毒解毒','中毒')
							drawitem('加体力','体力')
							if myThing['改变内力性质']==2 then
								drawitem('内力门路阴阳合一')
							end
							drawitem('加内力','内力')
							drawitem('加内力最大值','内力最值')
							drawitem('加攻击力','攻击')
							drawitem('加轻功','轻功')
							drawitem('加防御力','防御')
							drawitem('加医疗能力','医疗')
							drawitem('加用毒能力','用毒')
							drawitem('加解毒能力','解毒')
							drawitem('加抗毒能力','抗毒')
							drawitem('加拳掌功夫','拳掌')
							drawitem('加御剑能力','御剑')
							drawitem('加耍刀技巧','耍刀')
							drawitem('加特殊兵器','特殊')
							drawitem('加暗器技巧','暗器')
							drawitem('加武学常识','武常')
							drawitem('加品德','品德')
							drawitem('加攻击次数','左右',{[0]='否','是'})
							drawitem('加攻击带毒','带毒')
							
							if mx~=dx or my~=y3_2+2 then
								DrawStrBox(dx, y3_2 + 2, " 效果:", C_RED, myfont)
							end
						end
						
						if myThing['类型']==1 or myThing['类型']==2 then
							if mx~=dx then
								mx=dx+4*myfont
								my=my+myfont+20
							end
							myflag=1
							local my2=my
							if myThing['仅修炼人物']>-1 then
								drawitem('仅限:'..JY.Person[myThing['仅修炼人物']]['姓名'])
							end
							drawitem('需内力性质','阴阳',{[0]='阴','阳','不限'})
							drawitem('需内力','内力')
							drawitem('需攻击力','攻击')
							drawitem('需轻功','轻功')
							drawitem('需用毒能力','用毒')
							drawitem('需医疗能力','医疗')
							drawitem('需解毒能力','解毒')
							drawitem('需拳掌功夫','拳掌')
							drawitem('需御剑能力','御剑')
							drawitem('需耍刀技巧','耍刀')
							drawitem('需特殊兵器','特殊')
							drawitem('需暗器技巧','暗器')
							drawitem('需资质','资质')
							drawitem('需经验','修炼经验')
							if mx~=dx or my~=my2 then
								DrawStrBox(dx,my2,' 需求:',C_RED,myfont)
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


--场景处理主函数
function Game_SMap()         --场景处理主函数
	
    DrawSMap();
	if CC.ShowXY==1 then
        DrawString(CC.ScreenW-20*CC.FontSmall,CC.ScreenH-20,string.format("%s %d %d",JY.Scene[JY.SubScene]["名称"],JY.Base["人X1"],JY.Base["人Y1"]) ,C_GOLD,CC.FontSmall);
	end
		if JY.SubScene == 70 then
			local x0=JY.SubSceneX+JY.Base["人X1"]-1;    --绘图中心点
    	local y0=JY.SubSceneY+JY.Base["人Y1"]-1;
    	local x=limitX(x0,12,45)-JY.Base["人X1"];
    	local y=limitX(y0,12,45)-JY.Base["人Y1"];
			local dx = 29 - x0 -x;
      local dy = 23 - y0 - y;
      local rx = CC.XScale * (dx - dy) + CC.ScreenW / 2
      local ry = CC.YScale * (dx + dy) + CC.ScreenH / 2
      local str = "路见不平一声吼啊";
      local size = CC.FontSmall;
      local color = M_DeepSkyBlue;
      lib.Background(rx - #str*size/4, ry - CC.YScale*8, rx + #str*size/4, ry - CC.YScale*8+size, 128)
      DrawString(rx - #str*size/4, ry - CC.YScale*8, str, color, size);
      
		end
		
		DrawTimer();
		
		JYZTB();
    ShowScreen();
    lib.SetClip(0, 0, 0, 0)
  
  local d_pass=GetS(JY.SubScene,JY.Base["人X1"],JY.Base["人Y1"],3);   --当前路过事件
  if d_pass>=0 then
    if d_pass ~=JY.OldDPass then     --避免重复触发
        EventExecute(d_pass,3);       --路过触发事件
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
  local isout=0;                --是否碰到出口
  if (JY.Scene[JY.SubScene]["出口X1"] ==JY.Base["人X1"] and JY.Scene[JY.SubScene]["出口Y1"] ==JY.Base["人Y1"]) or
     (JY.Scene[JY.SubScene]["出口X2"] ==JY.Base["人X1"] and JY.Scene[JY.SubScene]["出口Y2"] ==JY.Base["人Y1"]) or
     (JY.Scene[JY.SubScene]["出口X3"] ==JY.Base["人X1"] and JY.Scene[JY.SubScene]["出口Y3"] ==JY.Base["人Y1"]) then
     isout=1;
  end
  if isout == 1 then
    JY.Status = GAME_MMAP
    lib.PicInit()
    CleanMemory()
    JY.MmapMusic = JY.Scene[JY.SubScene]["出门音乐"]
    if JY.MmapMusic < 0 then
      JY.MmapMusic = 25
    end
    Init_MMap()
    JY.SubScene = -1
    JY.oldSMapX = -1
    JY.oldSMapY = -1
    lib.DrawMMap(JY.Base["人X"], JY.Base["人Y"], GetMyPic())
    lib.GetKey()
		lib.ShowSlow(30,0)
    return 
  end
    --是否跳转到其他场景
    if JY.Scene[JY.SubScene]["跳转场景"] >= 0 and JY.Base["人X1"] == JY.Scene[JY.SubScene]["跳转口X1"] and JY.Base["人Y1"] == JY.Scene[JY.SubScene]["跳转口Y1"] then
    local OldScene = JY.SubScene
    JY.SubScene = JY.Scene[JY.SubScene]["跳转场景"]
    lib.ShowSlow(30, 1)
    if JY.Scene[OldScene]["外景入口X1"] ~= 0 then
      JY.Base["人X1"] = JY.Scene[JY.SubScene]["入口X"]
      JY.Base["人Y1"] = JY.Scene[JY.SubScene]["入口Y"]
    else
      JY.Base["人X1"] = JY.Scene[JY.SubScene]["跳转口X2"]
      JY.Base["人Y1"] = JY.Scene[JY.SubScene]["跳转口Y2"]
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
        if JY.Base["人方向"]>=0 then        --当前方向下一个位置
            local d_num=GetS(JY.SubScene,JY.Base["人X1"]+CC.DirectX[JY.Base["人方向"]+1],JY.Base["人Y1"]+CC.DirectY[JY.Base["人方向"]+1],3);
            if d_num>=0 then
                EventExecute(d_num,1);       --空格触发事件
            end
        end
	    elseif keypress == VK_S then
	    	DrawStrBox(-1,-1,"存档中，请稍后...", C_WHITE, CC.DefaultFont);
	    	ShowScreen();
	      JY.Base["无用"] = JY.SubScene
	      SaveRecord(3)
	      DrawStrBoxWaitKey("存档完毕", C_WHITE, CC.DefaultFont)
	      
	    elseif ktype == 3 then
	    	AutoMoveTab = {[0]=0}
	    	local x0 = JY.Base["人X1"]
			  local y0 = JY.Base["人Y1"]

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
    
    if AutoMoveTab[0] ~= 0 then			--鼠标自动走动
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
        x=JY.Base["人X1"]+CC.DirectX[direct+1];
        y=JY.Base["人Y1"]+CC.DirectY[direct+1];
        JY.Base["人方向"]=direct;
    else
        x=JY.Base["人X1"];
        y=JY.Base["人Y1"];
    end

    JY.MyPic=GetMyPic();
    DtoSMap();
    if SceneCanPass(x,y)==true then          --新的坐标可以走过去
        JY.Base["人X1"]=x;
        JY.Base["人Y1"]=y;
    end

    JY.Base["人X1"]=limitX(JY.Base["人X1"],1,CC.SWidth-2);
    JY.Base["人Y1"]=limitX(JY.Base["人Y1"],1,CC.SHeight-2);
    
    

		NEvent(keypress)

end

--场景坐标(x,y)是否可以通过
--返回true,可以，false不能
function SceneCanPass(x,y)  --场景坐标(x,y)是否可以通过
    local ispass=true;        --是否可以通过

    if GetS(JY.SubScene,x,y,1)>0 then     --场景层1有物品，不可通过
        ispass=false;
    end

    local d_data=GetS(JY.SubScene,x,y,3);     --事件层4
    if d_data>=0 then
        if GetD(JY.SubScene,d_data,0)~=0 then  --d*数据为不能通过
            ispass=false;
        end
    end

    if CC.SceneWater[GetS(JY.SubScene,x,y,0)] ~= nil then   --水面，不可进入
        ispass=false;
    end
    return ispass;
end

function DtoSMap()          ---D*中的事件数据复制到S*中，同时处理动画效果。
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
				if p3<=p1 then     --动画已停止
					if JY.Mytick %100 > delay then
						p3=p3+1;
					end
				else
					if JY.Mytick % 4 ==0 then      --4个节拍动画增加一次
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


function DrawSMap()         --绘场景地图
	local x0=JY.SubSceneX+JY.Base["人X1"]-1;    --绘图中心点
    local y0=JY.SubSceneY+JY.Base["人Y1"]-1;

    local x=limitX(x0,12,45)-JY.Base["人X1"];
    local y=limitX(y0,12,45)-JY.Base["人Y1"];

    lib.DrawSMap(JY.SubScene,JY.Base["人X1"],JY.Base["人Y1"],x,y,JY.MyPic);

    --lib.DrawSMap(JY.SubScene,JY.Base["人X1"],JY.Base["人Y1"],JY.SubSceneX,JY.SubSceneY,JY.MyPic);
end


-- 读取游戏进度
-- id=0 新进度，=1/2/3 进度
--
--这里是先把数据读入Byte数组中。然后定义访问相应表的方法，在访问表时直接从数组访问。
--与以前的实现相比，从文件中读取和保存到文件的时间显著加快。而且内存占用少了
function LoadRecord(id)       -- 读取游戏进度

	if id ~= 0 and ( existFile(string.format(CC.R_GRP, id)) == false or existFile(string.format(CC.S_GRP, id)) == false or existFile(string.format(CC.D_GRP, id))== false) then
		QZXS("此存档数据不全，不能读取。请选择其它存档或重新开始");
		return -1;
	end

    local t1=lib.GetTime();

    --读取R*.idx文件
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
	
	


    --读取R*.grp文件
    JY.Data_Base=Byte.create(idx[1]-idx[0]);              --基本数据
    Byte.loadfile(JY.Data_Base,grpFile,idx[0],idx[1]-idx[0]);

    --设置访问基本数据的方法，这样就可以用访问表的方式访问了。而不用把二进制数据转化为表。节约加载时间和空间
	local meta_t={
	    __index=function(t,k)
	        return GetDataFromStruct(JY.Data_Base,0,CC.Base_S,k);
		end,

		__newindex=function(t,k,v)
	        SetDataFromStruct(JY.Data_Base,0,CC.Base_S,k,v);
	 	end
	}
    setmetatable(JY.Base,meta_t);


    JY.PersonNum=math.floor((idx[2]-idx[1])/CC.PersonSize);   --人物

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

    JY.ThingNum=math.floor((idx[3]-idx[2])/CC.ThingSize);     --物品
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

    JY.SceneNum=math.floor((idx[4]-idx[3])/CC.SceneSize);     --场景
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

    JY.WugongNum=math.floor((idx[5]-idx[4])/CC.WugongSize);     --武功
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

    JY.ShopNum=math.floor((idx[6]-idx[5])/CC.ShopSize);     --小宝商店
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
		if JY.Base["物品" .. i] < 0 then
			break;
		end
		if JY.Base["物品" .. i] == 174 then
			JY.GOLD = JY.Base["物品数量" .. i]
			break;
		end
	end
	
	FINALWORK2()
	
	--读取周目信息
	if existFile(CC.CircleFile) then
		local file = io.open(CC.CircleFile, "rb");
		local str = "";
    --Alungky 读取前须初始化周目信息
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
	
	--预存周目信息
	if id == 0 then
		SetS(53, 0, 1, 5, CC.CircleNum);
	end

     --ALungky 调用修复函数
   Alungky_textFix_invokePerInstance();
   
   --读取技能数据
   LoadSkillData(id);
end

-- 写游戏进度
-- id=0 新进度，=1/2/3 进度
function SaveRecord(id)         -- 写游戏进度

	--判断是否在子场景保存
	if JY.Status == GAME_SMAP then
      JY.Base["无用"] = JY.SubScene
    else
      JY.Base["无用"] = -1
    end
	
    --读取R*.idx文件
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
    --写R*.grp文件
  Byte.savefile(JY.Data_Base,string.format(CC.R_GRP,id),idx[0],idx[1]-idx[0]);

	Byte.savefile(JY.Data_Person,string.format(CC.R_GRP,id),idx[1],CC.PersonSize*JY.PersonNum);

	Byte.savefile(JY.Data_Thing,string.format(CC.R_GRP,id),idx[2],CC.ThingSize*JY.ThingNum);

	Byte.savefile(JY.Data_Scene,string.format(CC.R_GRP,id),idx[3],CC.SceneSize*JY.SceneNum);

	Byte.savefile(JY.Data_Wugong,string.format(CC.R_GRP,id),idx[4],CC.WugongSize*JY.WugongNum);

	Byte.savefile(JY.Data_Shop,string.format(CC.R_GRP,id),idx[5],CC.ShopSize*JY.ShopNum);

    lib.SaveSMap(string.format(CC.S_GRP,id),string.format(CC.D_GRP,id));
    
    --写skill文件
    os.remove(CC.SkillFile);
    Byte.savefile(JY.Data_Skill, CC.SkillFile, 0, CC.SkillSize*JY.SkillNum)
    
    lib.Debug(string.format("SaveRecord time=%d",lib.GetTime()-t1));

end

-------------------------------------------------------------------------------------
-----------------------------------通用函数-------------------------------------------

function filelength(filename)         --得到文件长度
    local inp=io.open(filename,"rb");
    local l= inp:seek("end");
	inp:close();
    return l;
end

--读S×数据, (x,y) 坐标，level 层 0-5
function GetS(id,x,y,level)       --读S×数据
     return lib.GetS(id,x,y,level);
end

--写S×
function SetS(id,x,y,level,v)       --写S×
     lib.SetS(id,x,y,level,v);
end



--读D*
--sceneid 场景编号，
--id D*编号
--要读第几个数据, 0-10
function GetD(Sceneid,id,i)          --读D*
      return lib.GetD(Sceneid,id,i);
end

--写D×
function SetD(Sceneid,id,i,v)         --写D×
      lib.SetD(Sceneid,id,i,v);
end

--从数据的结构中翻译数据
--data 二进制数组
--offset data中的偏移
--t_struct 数据的结构，在jyconst中有很多定义
--key  访问的key
function GetDataFromStruct(data,offset,t_struct,key)  --从数据的结构中翻译数据，用来取数据
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

function SetDataFromStruct(data,offset,t_struct,key,v)  --从数据的结构中翻译数据，保存数据
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


--按照t_struct 定义的结构把数据从data二进制串中读到表t中
function LoadData(t,t_struct,data)        --data二进制串中读到表t中
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


--按照t_struct 定义的结构把数据写入data Byte数组中。
function SaveData(t,t_struct,data)      --数据写入data Byte数组中。
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


function limitX(x,minv,maxv)       --限制x的范围
  if x<minv then
	    x=minv;
	end
	if maxv ~= nil and x>maxv then
	    x=maxv;
	end
	return x
end

function RGB(r,g,b)          --设置颜色RGB
   return r*65536+g*256+b;
end

function GetRGB(color)      --分离颜色的RGB分量
    color=color%(65536*256);
    local r=math.floor(color/65536);
    color=color%65536;
    local g=math.floor(color/256);
    local b=color%256;
    return r,g,b
end

--等待键盘输入
function WaitKey(flag)       --等待键盘输入

	--ktype  1：键盘，2：鼠标移动，3:鼠标左键，4：鼠标右键，5：鼠标中键，6：滚动上，7：滚动下

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

--绘制一个带背景的白色方框，四角凹进
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

--绘制一个带背景的白色方框，四角凹进
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

--显示阴影字符串
function DrawString(x,y,str,color,size)         --显示阴影字符串
		
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

--显示带框的字符串
--(x,y) 坐标，如果都为-1,则在屏幕中间显示
function DrawStrBox(x,y,str,color,size)         --显示带框的字符串
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

--显示并询问Y/N，如果点击Y，则返回true, N则返回false
--(x,y) 坐标，如果都为-1,则在屏幕中间显示
--改为用菜单询问是否
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
{"确定/是", nil, 1}, 
{"取消/否", nil, 2}}
  local r = ShowMenu(menu, 2, 0, x + w - 4 * size - 2 * CC.MenuBorderPixel, y + h + CC.MenuBorderPixel, 0, 0, 1, 0, CC.DefaultFont, C_ORANGE, C_WHITE)
  if r == 1 then
    return true
  else
    return false
  end
end


--显示字符串并等待击键，字符串带框，显示在屏幕中间
function DrawStrBoxWaitKey(s,color,size)          --显示字符串并等待击键
    lib.GetKey();
    Cls();
    DrawStrBox(-1,-1,s,color,size);
    ShowScreen();
    WaitKey();
end

--返回 [0 , i-1] 的整形随机数
function Rnd(i)           --随机数
    local r=math.random(i);
    return r-1;
end

--增加人物属性，如果有最大值限制，则应用最大值限制。最小值则限制为0
--id 人物id
--str属性字符串
--value 要增加的值，负数表示减少
--返回1,实际增加的值
--返回2，字符串：xxx 增加/减少 xxxx，用于显示药品效果
function AddPersonAttrib(id, str, value)
  local oldvalue = JY.Person[id][str]
  local attribmax = math.huge
  if str == "生命" then
    attribmax = JY.Person[id]["生命最大值"]
  elseif str == "内力" then
    attribmax = JY.Person[id]["内力最大值"]
  elseif CC.PersonAttribMax[str] ~= nil then
    attribmax = CC.PersonAttribMax[str]
  end
  
  if str == "内力最大值" then
    local nlmax = math.modf((JY.Person[id]["资质"] - 1) / 15)
    attribmax = 9500 - nlmax * 750
    if T1LEQ(id) or id == 53 then
      attribmax = 10000
    end
    for i = 1, 10 do
      if JY.Person[id]["武功" .. i] == 85 or JY.Person[id]["武功" .. i] == 88 then
        attribmax = attribmax + 750
      end
    end
    if id == 58 then
      attribmax = attribmax - JY.Person[300]["声望"] * 100
    end
    if attribmax < 500 then
      attribmax = 500
    end
    if attribmax > 10000 then
    	attribmax = 10000
  	end
  end
    
  if str == "用毒能力" and id == 2 then
    attribmax = 500
  end
  if str == "用毒能力" and (id == 25 or id == 83 or id == 17) then
    attribmax = 400
  end
  if str == "医疗能力" and (id == 16 or id == 28 or id == 45) then
    attribmax = 500
  end
  if str == "医疗能力" and id == 85 then
    attribmax = 400
  end
  if (str == "医疗能力" or str == "用毒能力" or str == "解毒能力") and  id == 0 and GetS(4, 5, 5, 5) == 7 then
    attribmax = 400
  end
  
  local newvalue = limitX(oldvalue + value, 0, attribmax)
  JY.Person[id][str] = newvalue
  local add = newvalue - oldvalue
  local showstr = ""
  if add > 0 then
    showstr = string.format("%s 增加 %d", str, add)
  elseif add < 0 then
    showstr = string.format("%s 减少 %d", str, -add)
  end
  return add, showstr
end

--播放midi
function PlayMIDI(id)             --播放midi
    JY.CurrentMIDI=id;
    if JY.EnableMusic==0 then
        return ;
    end
    if id>=0 then
        lib.PlayMIDI(string.format(CC.MIDIFile,id+1));
    end
end

--播放音效atk***
function PlayWavAtk(id)             --播放音效atk***
    if JY.EnableSound==0 then
        return ;
    end
    if id>=0 then
        lib.PlayWAV(string.format(CC.ATKFile,id));
    end
end

--播放音效e**
function PlayWavE(id)              --播放音效e**
    if JY.EnableSound==0 then
        return ;
    end
    if id>=0 then
        lib.PlayWAV(string.format(CC.EFile,id));
    end
end


--flag =0 or nil 全部刷新屏幕
--      1 考虑脏矩形的快速刷新
function ShowScreen(flag)
  if JY.Darkness == 0 then
    if flag == nil then
      flag = 0
    end
    lib.ShowSurface(flag)
  end
end

--通用菜单函数
-- menuItem 表，每项保存一个子表，内容为一个菜单项的定义
--          菜单项定义为  {   ItemName,     菜单项名称字符串
--                          ItemFunction, 菜单调用函数，如果没有则为nil
--                          Visible       是否可见  0 不可见 1 可见, 2 可见，作为当前选择项。只能有一个为2，
--                                        多了则只取第一个为2的，没有则第一个菜单项为当前选择项。
--                                        在只显示部分菜单的情况下此值无效。
--                                        此值目前只用于是否菜单缺省显示否的情况
--                       }
--          菜单调用函数说明：         itemfunction(newmenu,id)
--
--       返回值
--              0 正常返回，继续菜单循环 1 调用函数要求退出菜单，不进行菜单循环
--
-- numItem      总菜单项个数
-- numShow      显示菜单项目，如果总菜单项很多，一屏显示不下，则可以定义此值
--                =0表示显示全部菜单项

-- (x1,y1),(x2,y2)  菜单区域的左上角和右下角坐标，如果x2,y2=0,则根据字符串长度和显示菜单项自动计算x2,y2
-- isBox        是否绘制边框，0 不绘制，1 绘制。若绘制，则按照(x1,y1,x2,y2)的矩形绘制白色方框，并使方框内背景变暗
-- isEsc        Esc键是否起作用 0 不起作用，1起作用
-- Size         菜单项字体大小
-- color        正常菜单项颜色，均为RGB
-- selectColor  选中菜单项颜色,
--;
-- 返回值  0 Esc返回
--         >0 选中的菜单项(1表示第一项)
--         <0 选中的菜单项，调用函数要求退出父菜单，这个用于退出多层菜单

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
	  
	  if keyPress==VK_ESCAPE or ktype == 4 then                  --Esc 或 退出
			if isEsc==1 then
				break							-- star：这里用break更好，不会产生内存泄露问题
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
      if newNumItem < current +start then                --Alungky 修复看攻略时会跳出的BUG
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
	    elseif current < num then                --Alungky 修复看攻略时会跳出的BUG
	      start = 1
			end
		else
			local mk = false;
			if ktype == 2 or ktype == 3 then			--选中
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
				  local r=newMenu[current][2](newMenu,current);               --调用菜单函数
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

--基本参数和ShowMenu一样，有一些特别的进行着重说明
--menu 每个数据三个值，1名称，2执行函数，3显示方式(0灰色可选择，1正常显示，2不显示, 3灰色不可选择)
--itemNum 菜单的个数，通常在调用的时候 #menu就可以了
--numShow 每行显示的菜单个数
--showRow 一个版面显示的最大行数，如果可显示菜单个数达不到一个版面的数，函数会自动适应这个值
--str 是标题的文字，传nil不显示
--选中项
function ShowMenu2(menu,itemNum,numShow,showRow,x1,y1,x2,y2,isBox,isEsc,size,color,selectColor, str, selIndex)     --通用菜单函数
    local w=0;
    local h=0;   --边框的宽高
    local i,j=0,0;
    local col=0;     --实际的显示菜单项
    local row=0;
    
    lib.GetKey();
    Cls();
    
    --建一个新的table
    local menuItem = {};
    local numItem = 0;                --显示的总数
    
    --把可显示的部分放到新table
    for i,v in pairs(menu) do
            if v[3] ~= 2 then
                    numItem = numItem + 1;
                    menuItem[numItem] = {v[1],v[2],v[3],i};                --注意第4个位置，保存i的值
            end
    end
    
    --计算实际显示的菜单项数
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

    --计算边框实际宽高
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

    local start=0;             --显示的第一项

    local curx = 1;          --当前选择项
    local cury = 0;
    local current = curx + cury*numShow;
    
    
    --默认有选中
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
                            
                local drawColor=color;           --设置不同的绘制颜色
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

                if keyPress==VK_ESCAPE or ktype == 4 then                  --Esc 退出
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
									if ktype == 2 or ktype == 3 then			--选中
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
                        local r=menuItem[current][2](menuItem,current);               --调用菜单函数
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
        
        --返回值，这个是取第4个位置的值
        if returnValue > 0 then
                return menuItem[returnValue][4]
        else
                return returnValue
        end
end

------------------------------------------------------------------------------------
--------------------------------------物品使用---------------------------------------
--物品使用模块
--当前物品id
--返回1 使用了物品， 0 没有使用物品。可能是某些原因不能使用
function UseThing(id)             --物品使用
    --调用函数
	if JY.ThingUseFunction[id]==nil then
	    return DefaultUseThing(id);
	else
        return JY.ThingUseFunction[id](id);
    end
end

--缺省物品使用函数，实现原始游戏效果
--id 物品id
function DefaultUseThing(id)                --缺省物品使用函数
    if JY.Thing[id]["类型"]==0 then
        return UseThing_Type0(id);
    elseif JY.Thing[id]["类型"]==1 then
        return UseThing_Type1(id);
    elseif JY.Thing[id]["类型"]==2 then
        return UseThing_Type2(id);
    elseif JY.Thing[id]["类型"]==3 then
        return UseThing_Type3(id);
    elseif JY.Thing[id]["类型"]==4 then
        return UseThing_Type4(id);
    end
end

--剧情物品，触发事件
function UseThing_Type0(id)              --剧情物品使用
    if JY.SubScene>=0 then
		local x=JY.Base["人X1"]+CC.DirectX[JY.Base["人方向"]+1];
		local y=JY.Base["人Y1"]+CC.DirectY[JY.Base["人方向"]+1];
        local d_num=GetS(JY.SubScene,x,y,3)
        if d_num>=0 then
            JY.CurrentThing=id;
            EventExecute(d_num,2);       --物品触发事件
            JY.CurrentThing=-1;
			return 1;
		else
		    return 0;
        end
    end
end



--判断一个人是否可以装备或修炼一个物品
--返回 true可以修炼，false不可
function CanUseThing(id, personid)
  local str = ""
  if personid == 76 and id > 63 then
    return true
  elseif (id == 220 or id == 221) and personid == 0 then
    return true
  elseif id > 186 and id < 194 and personid == 44 then
    return true
  elseif id == 114 and personid == 0 and GetS(4, 5, 5, 5) == 2 and JY.Person[0]["御剑能力"] > 99 then
    return true
  elseif id == 86 and personid == 0 and GetS(4, 5, 5, 5) == 1 and JY.Person[0]["拳掌功夫"] > 119 then
    return true
  else
    if JY.Thing[id]["仅修炼人物"] >= 0 and JY.Thing[id]["仅修炼人物"] ~= personid then
      return false
    end
    if JY.Thing[id]["需内力性质"] ~= 2 and JY.Person[personid]["内力性质"] ~= 2 and JY.Thing[id]["需内力性质"] ~= JY.Person[personid]["内力性质"] then
      return false
    end
    if JY.Person[personid]["内力最大值"] < JY.Thing[id]["需内力"] then
      return false
    end
    if JY.Person[personid]["攻击力"] < JY.Thing[id]["需攻击力"] then
      return false
    end
    if JY.Person[personid]["轻功"] < JY.Thing[id]["需轻功"] then
      return false
    end
    if JY.Person[personid]["用毒能力"] < JY.Thing[id]["需用毒能力"] then
      return false
    end
    if JY.Person[personid]["医疗能力"] < JY.Thing[id]["需医疗能力"] then
      return false
    end
    if JY.Person[personid]["解毒能力"] < JY.Thing[id]["需解毒能力"] then
      return false
    end
    

		--第三版本，小无相功减少修炼所需兵器值，每级减少一点
		local lv = 0;
  	for i=1, 10 do
  		if JY.Person[personid]["武功"..i] == 98 then
  			lv = math.modf(JY.Person[personid]["武功等级"..i]/100) + 1;
  			break;
  		end
  	end
  	lv = limitX(lv, 0, 10);
    	
		if JY.Person[personid]["拳掌功夫"] + lv < JY.Thing[id]["需拳掌功夫"] then
      return false
    end
    if JY.Person[personid]["御剑能力"] + lv  < JY.Thing[id]["需御剑能力"] then
      return false
    end
    if JY.Person[personid]["耍刀技巧"] + lv  < JY.Thing[id]["需耍刀技巧"] then
      return false
    end
    if JY.Person[personid]["特殊兵器"] + lv < JY.Thing[id]["需特殊兵器"] then
      return false
    end
    
    
    if JY.Person[personid]["暗器技巧"] < JY.Thing[id]["需暗器技巧"] then
      return false
    end

    if JY.Thing[id]["需资质"] >= 0 then
      if JY.Thing[id]["需资质"] > JY.Person[personid]["资质"] then
          return false;
      end
    else
    	if -JY.Thing[id]["需资质"] < JY.Person[personid]["资质"] then
      	return false;
     	end 
    end
    
    if JY.Person[personid]["姓名"] == CC.s10 then       --SYP不可修练
      return false
    end
  end
  
  --斗转限制
  if id == 118 then
    local R = JY.Person[personid]
    local wp = R["拳掌功夫"] + R["御剑能力"] + R["耍刀技巧"] + R["特殊兵器"]
    if wp < 120 then
    	return false
  	end
  end
  
  return true
end




--药品使用实际效果
--id 物品id，
--personid 使用人id
--返回值：0 使用没有效果，物品数量应该不变。1 使用有效果，则使用后物品数量应该-1
function UseThingEffect(id,personid)          --药品使用实际效果
    local str={};
    str[0]=string.format("使用 %s",JY.Thing[id]["名称"]);
    local strnum=1;
    local addvalue;

    if JY.Thing[id]["加生命"] >0 then
        local add=JY.Thing[id]["加生命"]-math.modf(JY.Person[personid]["受伤程度"]/2)+Rnd(10);
        if add <=0 then
            add=5+Rnd(5);
        end
        AddPersonAttrib(personid,"受伤程度",-JY.Thing[id]["加生命"]/4);
        addvalue,str[strnum]=AddPersonAttrib(personid,"生命",add);
        if addvalue ~=0 then
            strnum=strnum+1
        end
    end

    local function ThingAddAttrib(s)     ---定义局部函数，处理吃药后增加属性
        if JY.Thing[id]["加" .. s] ~=0 then
            addvalue,str[strnum]=AddPersonAttrib(personid,s,JY.Thing[id]["加" .. s]);
            if addvalue ~=0 then
                strnum=strnum+1
            end
        end
    end

    ThingAddAttrib("生命最大值");

    if JY.Thing[id]["加中毒解毒"] <0 then
        addvalue,str[strnum]=AddPersonAttrib(personid,"中毒程度",math.modf(JY.Thing[id]["加中毒解毒"]/2));
        if addvalue ~=0 then
            strnum=strnum+1
        end
    end

    ThingAddAttrib("体力");

    if JY.Thing[id]["改变内力性质"] ==2 then
        str[strnum]="内力门路改为阴阳合一"
        strnum=strnum+1
    end

    ThingAddAttrib("内力");
    ThingAddAttrib("内力最大值");
    ThingAddAttrib("攻击力");
    ThingAddAttrib("防御力");
    ThingAddAttrib("轻功");
    ThingAddAttrib("医疗能力");
    ThingAddAttrib("用毒能力");
    ThingAddAttrib("解毒能力");
    ThingAddAttrib("抗毒能力");
    ThingAddAttrib("拳掌功夫");
    ThingAddAttrib("御剑能力");
    ThingAddAttrib("耍刀技巧");
    ThingAddAttrib("特殊兵器");
    ThingAddAttrib("暗器技巧");
    ThingAddAttrib("武学常识");
    ThingAddAttrib("攻击带毒");

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
		  	--显示点数
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

--装备物品
function UseThing_Type1(id)
  DrawStrBox(CC.MainSubMenuX, CC.MainSubMenuY, string.format("谁要配备%s?", JY.Thing[id]["名称"]), C_WHITE, CC.DefaultFont)
  local nexty = CC.MainSubMenuY + CC.SingleLineHeight
  local r = SelectTeamMenu(CC.MainSubMenuX, nexty)
  local pp1, pp2 = 0, 0
  if r > 0 then
    local personid = JY.Base["队伍" .. r]
    if CanUseThing(id, personid) or T2SQ(personid) then
      if JY.Thing[id]["装备类型"] == 0 then
        if JY.Thing[id]["使用人"] >= 0 then
          if JY.Person[JY.Thing[id]["使用人"]]["姓名"] == JY.SQ then
            JY.Thing[id]["加攻击力"] = JY.Thing[id]["加攻击力"] / 2
            JY.Thing[id]["加防御力"] = JY.Thing[id]["加防御力"] / 2
            JY.Thing[id]["加轻功"] = JY.Thing[id]["加轻功"] / 2
          end
          JY.Person[JY.Thing[id]["使用人"]]["武器"] = -1
        end
        if JY.Person[personid]["武器"] >= 0 then
          if T2SQ(personid) then
            JY.Thing[JY.Person[personid]["武器"]]["加攻击力"] = JY.Thing[JY.Person[personid]["武器"]]["加攻击力"] / 2
            JY.Thing[JY.Person[personid]["武器"]]["加防御力"] = JY.Thing[JY.Person[personid]["武器"]]["加防御力"] / 2
            JY.Thing[JY.Person[personid]["武器"]]["加轻功"] = JY.Thing[JY.Person[personid]["武器"]]["加轻功"] / 2
          end
          JY.Thing[JY.Person[personid]["武器"]]["使用人"] = -1
        end
        JY.Person[personid]["武器"] = id
        if T2SQ(personid) then
          JY.Thing[id]["加攻击力"] = JY.Thing[id]["加攻击力"] * 2
          JY.Thing[id]["加防御力"] = JY.Thing[id]["加防御力"] * 2
          JY.Thing[id]["加轻功"] = JY.Thing[id]["加轻功"] * 2
        end
        
      elseif JY.Thing[id]["装备类型"] == 1 then
          if JY.Thing[id]["使用人"] >= 0 then
            if JY.Person[JY.Thing[id]["使用人"]]["姓名"] == JY.SQ then
              JY.Thing[id]["加攻击力"] = JY.Thing[id]["加攻击力"] / 2
              JY.Thing[id]["加防御力"] = JY.Thing[id]["加防御力"] / 2
              JY.Thing[id]["加轻功"] = JY.Thing[id]["加轻功"] / 2
            end
            JY.Person[JY.Thing[id]["使用人"]]["防具"] = -1
          end
          if JY.Person[personid]["防具"] >= 0 then
            if T2SQ(personid) then
              JY.Thing[JY.Person[personid]["防具"]]["加攻击力"] = JY.Thing[JY.Person[personid]["防具"]]["加攻击力"] / 2
              JY.Thing[JY.Person[personid]["防具"]]["加防御力"] = JY.Thing[JY.Person[personid]["防具"]]["加防御力"] / 2
              JY.Thing[JY.Person[personid]["防具"]]["加轻功"] = JY.Thing[JY.Person[personid]["防具"]]["加轻功"] / 2
            end
            JY.Thing[JY.Person[personid]["防具"]]["使用人"] = -1
          end
          JY.Person[personid]["防具"] = id
          if T2SQ(personid) then
		        JY.Thing[id]["加攻击力"] = JY.Thing[id]["加攻击力"] * 2
		        JY.Thing[id]["加防御力"] = JY.Thing[id]["加防御力"] * 2
		        JY.Thing[id]["加轻功"] = JY.Thing[id]["加轻功"] * 2
		      end
      end
      JY.Thing[id]["使用人"] = personid
    else
    	DrawStrBoxWaitKey("此人不适合配备此物品", C_WHITE, CC.DefaultFont)
    	return 0
    end
  end
  return 1
end
--秘籍物品使用
function UseThing_Type2(id)
  if JY.Thing[id]["使用人"] >= 0 and DrawStrBoxYesNo(-1, -1, "此物品已经有人修炼，是否换人修炼?", C_WHITE, CC.DefaultFont) == false then
    Cls(CC.MainSubMenuX, CC.MainSubMenuY, CC.ScreenW, CC.ScreenH)
    ShowScreen()
    return 0
  end
  Cls()
  DrawStrBox(CC.MainSubMenuX, CC.MainSubMenuY, string.format("谁要修炼%s?", JY.Thing[id]["名称"]), C_WHITE, CC.DefaultFont)
  local nexty = CC.MainSubMenuY + CC.SingleLineHeight
  local r = SelectTeamMenu(CC.MainSubMenuX, nexty)
  if r > 0 then
    local personid = JY.Base["队伍" .. r]
    local yes, full = nil, nil
    if JY.Thing[id]["练出武功"] >= 0 then
      yes = 0
      full = 1
      for i = 1, 10 do
        if JY.Person[personid]["武功" .. i] == JY.Thing[id]["练出武功"] then
          yes = 1
        else
          if JY.Person[personid]["武功" .. i] == 0 then
            full = 0
          end
        end
      end
    end
    
    --如果已经满武功并且选择的武功没有学会，则不可装备修炼
    if yes == 0 and full == 1 then
      DrawStrBoxWaitKey("一个人只能修炼10种武功", C_WHITE, CC.DefaultFont)
      return 0
    end
    
    --葵花宝典
    if CC.Shemale[id] == 1 then
      if T1LEQ(personid) or T2SQ(personid) or T3XYK(personid) then		--特殊人物不用切
        say("５Ｒ欲练神功　挥刀自宫")
        say("２这太惨了吧！先看看再说....Ｈ（翻到下一页）")
        say("５Ｒ若不自宫　也可练功")
        say("１哈，原来不自宫也能练啊！Ｈ太棒了！！！")
        yes = 2;
      elseif personid == 29 and GetS(86,10,12,5) == 1 then			--田伯光，不被阉割之后，不可修炼葵花宝典
      	Talk(JY.Thing[id]["名称"] .. " 这玩意不适合我", 29);
      	return 0
    	elseif JY.Person[personid]["性别"] == 0 and CanUseThing(id, personid) then
        Cls(CC.MainSubMenuX, CC.MainSubMenuY, CC.ScreenW, CC.ScreenH)
        if DrawStrBoxYesNo(-1, -1, "修炼此书必须先挥刀自宫，是否仍要修炼?", C_WHITE, CC.DefaultFont) == false then
          return 0
        else
	        lib.FillColor(0, 0, CC.ScreenW, CC.ScreenH, C_RED, 128)
	        ShowScreen()
	        lib.Delay(80)
	        lib.ShowSlow(15, 1)
	        Cls()
	        lib.ShowSlow(100, 0)
	        JY.Person[personid]["性别"] = 2
	        local add, str = AddPersonAttrib(personid, "攻击力", -15)
	        DrawStrBoxWaitKey(JY.Person[personid]["姓名"] .. str, C_ORANGE, CC.DefaultFont)
	        add, str = AddPersonAttrib(personid, "防御力", -25)
	        DrawStrBoxWaitKey(JY.Person[personid]["姓名"] .. str, C_ORANGE, CC.DefaultFont)
	      end
      elseif JY.Person[personid]["性别"] == 1 then
        DrawStrBoxWaitKey("此人不适合修炼此物品", C_WHITE, CC.DefaultFont)
        return 0
      end
    end
    
    if yes == 1 or CanUseThing(id, personid) or  yes == 2 then
      if JY.Thing[id]["使用人"] == personid then
        return 0
      end
      if JY.Person[personid]["修炼物品"] >= 0 then
        JY.Thing[JY.Person[personid]["修炼物品"]]["使用人"] = -1
      end
      if JY.Thing[id]["使用人"] >= 0 then
        JY.Person[JY.Thing[id]["使用人"]]["修炼物品"] = -1
        JY.Person[JY.Thing[id]["使用人"]]["物品修炼点数"] = 0
      end
      JY.Thing[id]["使用人"] = personid
      JY.Person[personid]["修炼物品"] = id
      JY.Person[personid]["物品修炼点数"] = 0
    else
    	DrawStrBoxWaitKey("此人不适合修炼此物品", C_WHITE, CC.DefaultFont)
    	return 0
    end
  end
  return 1
end
--药品物品
function UseThing_Type3(id)
  local usepersonid = -1
  if JY.Status == GAME_MMAP or JY.Status == GAME_SMAP then
    Cls(CC.MainSubMenuX, CC.MainSubMenuY, CC.ScreenW, CC.ScreenH)
    DrawStrBox(CC.MainSubMenuX, CC.MainSubMenuY, string.format("谁要使用%s?", JY.Thing[id]["名称"]), C_WHITE, CC.DefaultFont)
    local nexty = CC.MainSubMenuY + CC.SingleLineHeight
    local r = SelectTeamMenu(CC.MainSubMenuX, nexty)
    if r > 0 then
      usepersonid = JY.Base["队伍" .. r]
    end
  elseif JY.Status == GAME_WMAP then
    if WAR.Person[WAR.CurID]["人物编号"] == 16 then
      War_CalMoveStep(WAR.CurID, 8, 1)
      local x, y = War_SelectMove()
      if x ~= nil then
        local emeny = GetWarMap(x, y, 2)
        if emeny >= 0 and WAR.Person[WAR.CurID]["我方"] == WAR.Person[emeny]["我方"] then
        	usepersonid = WAR.Person[emeny]["人物编号"]
      	end
      end
    else
    	usepersonid = WAR.Person[WAR.CurID]["人物编号"]
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

--暗器物品
function UseThing_Type4(id)
  if JY.Status == GAME_WMAP then
    return War_UseAnqi(id)
  end
  return 0
end



--------------------------------------------------------------------------------
--------------------------------------事件调用-----------------------------------

--事件调用主入口
--id，d*中的编号
--flag 1 空格触发，2，物品触发，3，路过触发
function EventExecute(id,flag)               --事件调用主入口
    JY.CurrentD=id;
    if JY.SceneNewEventFunction[JY.SubScene]==nil then         --没有定义新的事件处理函数，调用旧的
        oldEventExecute(flag)
	else
        JY.SceneNewEventFunction[JY.SubScene](flag)         --调用新的事件处理函数
    end
    JY.CurrentD=-1;
end

--调用原有的指定位置的函数
--旧的函数名字格式为  oldevent_xxx();  xxx为事件编号
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




--改变大地图坐标，从场景出去后移动到相应坐标
function ChangeMMap(x,y,direct)          --改变大地图坐标
	JY.Base["人X"]=x;
	JY.Base["人Y"]=y;
	JY.Base["人方向"]=direct;
end

--改变当前场景
function ChangeSMap(sceneid,x,y,direct)       --改变当前场景
    JY.SubScene=sceneid;
	JY.Base["人X1"]=x;
	JY.Base["人Y1"]=y;
	JY.Base["人方向"]=direct;
end


--清除(x1,y1)-(x2,y2)矩形内的文字等。
--如果没有参数，则清除整个屏幕表面
--注意该函数并不直接刷新显示屏幕
function Cls(x1,y1,x2,y2)                    --清除屏幕
    if x1==nil then        --第一个参数为nil,表示没有参数，用缺省
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
        lib.DrawMMap(JY.Base["人X"],JY.Base["人Y"],GetMyPic());             --显示主地图
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


--产生对话显示需要的字符串，即每隔n个中文字符加一个星号
function GenTalkString(str,n)              --产生对话显示需要的字符串
    local tmpstr="";
    for s in string.gmatch(str .. "*","(.-)%*") do           --去掉对话中的所有*. 字符串尾部加一个星号，避免无法匹配
        tmpstr=tmpstr .. s;
    end

    local newstr="";
    while #tmpstr>0 do
		local w=0;
		while w<#tmpstr do
		    local v=string.byte(tmpstr,w+1);          --当前字符的值
			if v>=128 then
			    w=w+2;
			else
			    w=w+1;
			end
			if w >= 2*n-1 then     --为了避免跨段中文字符
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

--最简单版本对话
function Talk(s,personid)            --最简单版本对话
    local flag;
    if personid==0 then
        flag=1;
	else
	    flag=0;
	end
	TalkEx(s,JY.Person[personid]["头像代号"],flag);
end


--复杂版本对话
--s 字符串，必须加上*作为分行，如果里面没有*,则会自动加上
function TalkEx(s,headid,flag)          --复杂版本对话
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
          local offset = (boxpicw - (string.len(JY.Person[headid]["姓名"]) * CC.DefaultFont)/2)/2;
	        DrawString(xy[flag].headx + 5 + offset, xy[flag].heady + boxpich-CC.DefaultFont - dy, JY.Person[headid]["姓名"], C_GOLD, CC.DefaultFont)
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

--测试指令，占位置用
function instruct_test(s)
    DrawStrBoxWaitKey(s,C_ORANGE,24);
end

--清屏
function instruct_0()         --清屏
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

--对话
--talkid: 为数字，则为对话编号；为字符串，则为对话本身。
--headid: 头像id
--flag :对话框位置：0 屏幕上方显示, 左边头像，右边对话
--            1 屏幕下方显示, 左边对话，右边头像
--            2 屏幕上方显示, 左边空，右边对话
--            3 屏幕下方显示, 左边对话，右边空
--            4 屏幕上方显示, 左边对话，右边头像
--            5 屏幕下方显示, 左边头像，右边对话

function instruct_1(talkid, headid, flag)
  local s = ReadTalk(talkid)
  if s == nil then
    return 
  end
  TalkEx(s, headid, flag)
end

--根据oldtalk.grp文件来idx索引文件。供后面读对话使用
function GenTalkIdx()         --生成对话索引文件
	
end




--得到物品
function instruct_2(thingid, num)
  if JY.Thing[thingid] == nil then
    return 
  end
  instruct_32(thingid, num)
  if num > 0 then
    DrawStrBoxWaitKey(string.format("得到物品:%s %d", JY.Thing[thingid]["名称"], num), C_ORANGE, CC.DefaultFont)
  else
    DrawStrBoxWaitKey(string.format("失去物品:%s %d", JY.Thing[thingid]["名称"], -num), C_ORANGE, CC.DefaultFont)
  end
  instruct_2_sub()
end


function instruct_2_sub()
  if JY.Person[0]["声望"] < 200 then
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
  return DrawStrBoxYesNo(-1, -1, "是否与之过招(Y/N)?", C_ORANGE, CC.DefaultFont)
end

function instruct_6(warid, tmp, tmp, flag)
  return WarMain(warid, flag)
end

function instruct_7()
  instruct_test("指令7测试")
end

function instruct_8(musicid)
  JY.MmapMusic = musicid
end

function instruct_9()
  return DrawStrBoxYesNo(-1, -1, "是否要求加入(Y/N)?", C_ORANGE, CC.DefaultFont)
end

function instruct_10(personid)
  if JY.Person[personid] == nil then
    lib.Debug("instruct_10 error: person id not exist")
    return 
  end
  local add = 0
  for i = 2, CC.TeamNum do
    if JY.Base["队伍" .. i] < 0 then
      JY.Base["队伍" .. i] = personid
      add = 1
      break;
    end
  end
  if add == 0 then
    lib.Debug("instruct_10 error: 加入队伍已满")
    return 
  end
  for i = 1, 4 do
    local id = JY.Person[personid]["携带物品" .. i]
    local n = JY.Person[personid]["携带物品数量" .. i]
    if n < 0 then
      n = 0
    end
    if id >= 0 and n > 0 then
      instruct_2(id, n)
      JY.Person[personid]["携带物品" .. i] = -1
      JY.Person[personid]["携带物品数量" .. i] = 0
    end
  end
end

function instruct_11()
  return DrawStrBoxYesNo(-1, -1, "是否(Y/N)?", C_ORANGE, CC.DefaultFont)
end

function instruct_12(flag)
  for i = 1, CC.TeamNum do
    local id = JY.Base["队伍" .. i]
    if id >= 0 then
      JY.Person[id]["受伤程度"] = 0
      JY.Person[id]["中毒程度"] = 0
      AddPersonAttrib(id, "体力", math.huge)
      AddPersonAttrib(id, "生命", math.huge)
      AddPersonAttrib(id, "内力", math.huge)
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
  DrawString(CC.GameOverX, CC.GameOverY, JY.Person[0]["姓名"], RGB(0, 0, 0), CC.DefaultFont)
  local x = CC.ScreenW - 9 * CC.DefaultFont
  DrawString(x, 10, os.date("%Y-%m-%d %H:%M"), RGB(216, 20, 24), CC.DefaultFont)
  DrawString(x, 10 + CC.DefaultFont + CC.RowPixel, "在地球的某处", RGB(216, 20, 24), CC.DefaultFont)
  DrawString(x, 10 + (CC.DefaultFont + CC.RowPixel) * 2, "当地人口的失踪数", RGB(216, 20, 24), CC.DefaultFont)
  DrawString(x, 10 + (CC.DefaultFont + CC.RowPixel) * 3, "又多了一笔。。。", RGB(216, 20, 24), CC.DefaultFont)
  ShowScreen();
  local loadMenu = {
{"选择读档", nil, 1},  
{"回家睡觉去", nil, 1}}
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
			DrawStrBox(-1,CC.StartMenuY,"请稍候...",C_GOLD,CC.DefaultFont);
			ShowScreen();
    	local result = LoadRecord(r);
    	if result ~= nil then
    		instruct_15();
    		return 0;
    	end
    if JY.Base["无用"] ~= -1 then
      JY.Status = GAME_SMAP
      JY.SubScene = JY.Base["无用"]
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
    if personid == JY.Base["队伍" .. i] then
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
    if JY.Base["物品" .. i] == thingid then
      return true
    end
  end
  return false
end

function instruct_19(x, y)
  JY.Base["人X1"] = x
  JY.Base["人Y1"] = y
  JY.SubSceneX = 0
  JY.SubSceneY = 0
end

function instruct_20()
  if JY.Base["队伍" .. CC.TeamNum] >= 0 then
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
    if personid == JY.Base["队伍" .. i] then
      j = i
    end
  end
  if j == 0 then
    return 
  end
  for i = j + 1, CC.TeamNum do
    JY.Base["队伍" .. i - 1] = JY.Base["队伍" .. i]
  end
  JY.Base["队伍" .. CC.TeamNum] = -1
  if JY.Person[personid]["武器"] >= 0 then
    JY.Thing[JY.Person[personid]["武器"]]["使用人"] = -1
    JY.Person[personid]["武器"] = -1
  end
  if JY.Person[personid]["防具"] >= 0 then
    JY.Thing[JY.Person[personid]["防具"]]["使用人"] = -1
    JY.Person[personid]["防具"] = -1
  end
  if JY.Person[personid]["修炼物品"] >= 0 then
    JY.Thing[JY.Person[personid]["修炼物品"]]["使用人"] = -1
    JY.Person[personid]["修炼物品"] = -1
  end
  JY.Person[personid]["物品修炼点数"] = 0
end

function instruct_22()
  for i = 1, CC.TeamNum do
    if JY.Base["队伍" .. i] >= 0 then
      JY.Person[JY.Base["队伍" .. i]]["内力"] = 0
    end
  end
end

function instruct_23(personid, value)
  JY.Person[personid]["用毒能力"] = value
  AddPersonAttrib(personid, "用毒能力", 0)
end

function instruct_24()
  instruct_test("指令24测试")
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
  local v = JY.Person[personid]["品德"]
  if vmin <= v and v <= vmax then
    return true
  else
    return false
  end
end

function instruct_29(personid, vmin, vmax)
  local v = JY.Person[personid]["攻击力"]
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
  x = JY.Base["人X1"] + CC.DirectX[direct + 1]
  y = JY.Base["人Y1"] + CC.DirectY[direct + 1]
  JY.Base["人方向"] = direct
  JY.MyPic = GetMyPic()
  DtoSMap()
  if SceneCanPass(x, y) == true then
    JY.Base["人X1"] = x
    JY.Base["人Y1"] = y
  end
  JY.Base["人X1"] = limitX(JY.Base["人X1"], 1, CC.SWidth - 2)
  JY.Base["人Y1"] = limitX(JY.Base["人Y1"], 1, CC.SHeight - 2)
  DrawSMap()
  ShowScreen()
  return 1
end

function instruct_30_sub(direct)
  local x, y = nil, nil
  local d_pass = GetS(JY.SubScene, JY.Base["人X1"], JY.Base["人Y1"], 3)

  if d_pass >= 0 and d_pass ~= JY.OldDPass then
    EventExecute(d_pass, 3)
    JY.OldDPass = d_pass
    JY.oldSMapX = -1
    JY.oldSMapY = -1
    JY.D_Valid = nil
  end

  JY.OldDPass = -1
  local isout = 0
  if (((JY.Scene[JY.SubScene]["出口X1"] == JY.Base["人X1"] and JY.Scene[JY.SubScene]["出口Y1"] == JY.Base["人Y1"]) or JY.Scene[JY.SubScene]["出口X2"] ~= JY.Base["人X1"] or JY.Scene[JY.SubScene]["出口Y2"] == JY.Base["人Y1"] or JY.Scene[JY.SubScene]["出口X3"] == JY.Base["人X1"] and JY.Scene[JY.SubScene]["出口Y3"] == JY.Base["人Y1"])) then
    isout = 1
  end
  if isout == 1 then
    JY.Status = GAME_MMAP
    lib.PicInit()
    CleanMemory()
    lib.ShowSlow(50, 1)
    if JY.MmapMusic < 0 then
      JY.MmapMusic = JY.Scene[JY.SubScene]["出门音乐"]
    end
    Init_MMap()
    JY.SubScene = -1
    JY.oldSMapX = -1
    JY.oldSMapY = -1
    lib.DrawMMap(JY.Base["人X"], JY.Base["人Y"], GetMyPic())
    lib.ShowSlow(50, 0)
    lib.GetKey()
    return 
  end
  if JY.Scene[JY.SubScene]["跳转场景"] >= 0 and JY.Base["人X1"] == JY.Scene[JY.SubScene]["跳转口X1"] and JY.Base["人Y1"] == JY.Scene[JY.SubScene]["跳转口Y1"] then
    JY.SubScene = JY.Scene[JY.SubScene]["跳转场景"]
    lib.ShowSlow(50, 1)
    if JY.Scene[JY.SubScene]["外景入口X1"] == 0 and JY.Scene[JY.SubScene]["外景入口Y1"] == 0 then
      JY.Base["人X1"] = JY.Scene[JY.SubScene]["入口X"]
      JY.Base["人Y1"] = JY.Scene[JY.SubScene]["入口Y"]
    else
      JY.Base["人X1"] = JY.Scene[JY.SubScene]["跳转口X2"]
      JY.Base["人Y1"] = JY.Scene[JY.SubScene]["跳转口Y2"]
    end
    Init_SMap(1)
    return 
  end
  AddMyCurrentPic()
  x = JY.Base["人X1"] + CC.DirectX[direct + 1]
  y = JY.Base["人Y1"] + CC.DirectY[direct + 1]
  JY.Base["人方向"] = direct
  JY.MyPic = GetMyPic()
  DtoSMap()
  if SceneCanPass(x, y) == true then
    JY.Base["人X1"] = x
    JY.Base["人Y1"] = y
  end
  JY.Base["人X1"] = limitX(JY.Base["人X1"], 1, CC.SWidth - 2)
  JY.Base["人Y1"] = limitX(JY.Base["人Y1"], 1, CC.SHeight - 2)
  DrawSMap()
  ShowScreen()
  return 1
end

function instruct_31(num)
  local r = false
  for i = 1, CC.MyThingNum do
    if JY.Base["物品" .. i] == CC.MoneyID and num <= JY.Base["物品数量" .. i] then
      r = true
    end
  end
  return r
end

function instruct_32(thingid, num)
  local p = 1
  for i = 1, CC.MyThingNum do
    if JY.Base["物品" .. i] == thingid then
      JY.Base["物品数量" .. i] = JY.Base["物品数量" .. i] + num
      p = i
      break;
    elseif JY.Base["物品" .. i] == -1 then
      JY.Base["物品" .. i] = thingid
      JY.Base["物品数量" .. i] = num
      p = i
      break;
    end
  end
  if thingid == CC.MoneyID then
    JY.GOLD = JY.GOLD + num
  end
  
  
  --获得天书，增加15点声望
  if thingid >= CC.BookStart and thingid < CC.BookStart + CC.BookNum then
  	JY.Person[JY.MY]["声望"] = JY.Person[JY.MY]["声望"] + 15;
  end
  
  
  if JY.Base["物品数量" .. p] <= 0 then
    for i = p + 1, CC.MyThingNum do
      JY.Base["物品" .. i - 1] = JY.Base["物品" .. i]
      JY.Base["物品数量" .. i - 1] = JY.Base["物品数量" .. i]
    end
    JY.Base["物品" .. CC.MyThingNum] = -1
    JY.Base["物品数量" .. CC.MyThingNum] = 0
  end
end

--人物学会武功
function instruct_33(personid, wugongid, flag)
  local add = 0
  for i = 1, 10 do
    if JY.Person[personid]["武功" .. i] == 0 then
      JY.Person[personid]["武功" .. i] = wugongid
      JY.Person[personid]["武功等级" .. i] = 0
      add = 1
      break;
    end
  end
  if add == 0 then
    JY.Person[personid]["武功10"] = wugongid
    JY.Person[personid]["武功等级10"] = 0
  end
  if flag == 0 then
    DrawStrBoxWaitKey(string.format("%s 学会武功 %s", JY.Person[personid]["姓名"], JY.Wugong[wugongid]["名称"]), C_ORANGE, CC.DefaultFont)
  end
end

function instruct_34(id, value)
  local add, str = AddPersonAttrib(id, "资质", value)
  DrawStrBoxWaitKey(JY.Person[id]["姓名"] .. str, C_ORANGE, CC.DefaultFont)
end


function instruct_35(personid, id, wugongid, wugonglevel)
  if id >= 0 then
    JY.Person[personid]["武功" .. id + 1] = wugongid
    JY.Person[personid]["武功等级" .. id + 1] = wugonglevel
  else
    local flag = 0
    for i = 1, 10 do
      if JY.Person[personid]["武功" .. i] == 0 then
        flag = 1
        JY.Person[personid]["武功" .. i] = wugongid
        JY.Person[personid]["武功等级" .. i] = wugonglevel
        return 
      end
    end
    if flag == 0 then
    	JY.Person[personid]["武功" .. 1] = wugongid
    	JY.Person[personid]["武功等级" .. 1] = wugonglevel
  	end
  end
  
end

function instruct_36(sex)
  if JY.Person[0]["性别"] == sex then
    return true
  else
    return false
  end
end

function instruct_37(v)
  AddPersonAttrib(0, "品德", v)
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
  JY.Scene[sceneid]["进入条件"] = 0
end

function instruct_40(v)
  JY.Base["人方向"] = v
  JY.MyPic = GetMyPic()
end

function instruct_41(personid, thingid, num)
  local k = 0
  for i = 1, 4 do
    if JY.Person[personid]["携带物品" .. i] == thingid then
      JY.Person[personid]["携带物品数量" .. i] = JY.Person[personid]["携带物品数量" .. i] + num
      k = i
      break;
    end
  end
  if k > 0 and JY.Person[personid]["携带物品数量" .. k] <= 0 then
    JY.Person[personid]["携带物品" .. k] = -1
  end
  if k == 0 then
    for i = 1, 4 do
      if JY.Person[personid]["携带物品" .. i] == -1 then
        JY.Person[personid]["携带物品" .. i] = thingid
        JY.Person[personid]["携带物品数量" .. i] = num
        break;
      end
    end
  end
end

function instruct_42()
  local r = false
  for i = 1, CC.TeamNum do
    if JY.Base["队伍" .. i] >= 0 and JY.Person[JY.Base["队伍" .. i]]["性别"] == 1 then
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
   local add, str = AddPersonAttrib(id, "轻功", value)
end

function instruct_46(id, value)
  local add, str = AddPersonAttrib(id, "内力最大值", value)
  AddPersonAttrib(id, "内力", 0)
end

function instruct_47(id, value)
  local add, str = AddPersonAttrib(id, "攻击力", value)
end

function instruct_48(id, value)
   local add, str = AddPersonAttrib(id, "生命最大值", value)
  AddPersonAttrib(id, "生命", 0)
end

function instruct_49(personid, value)
  JY.Person[personid]["内力性质"] = value
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
  DrawStrBoxWaitKey(string.format("你现在的品德指数为: %d", JY.Person[0]["品德"]), C_ORANGE, CC.DefaultFont)
end

function instruct_53()
  DrawStrBoxWaitKey(string.format("你现在的声望指数为: %d", JY.Person[0]["声望"]), C_ORANGE, CC.DefaultFont)
end

function instruct_54()
  for i = 0, JY.SceneNum - 1 do
    JY.Scene[i]["进入条件"] = 0
  end
  JY.Scene[2]["进入条件"] = 2
  JY.Scene[38]["进入条件"] = 2
  JY.Scene[75]["进入条件"] = 1
  JY.Scene[80]["进入条件"] = 1
end

function instruct_55(id, num)
  if GetD(JY.SubScene, id, 2) == num then
    return true
  else
    return false
  end
end

function instruct_56(v)
  --JY.Person[0]["声望"] = JY.Person[0]["声望"] + v
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
      instruct_1(2854 + warnum, JY.Person[WAR.Data["敌人1"]]["头像代号"], 0)
      instruct_0()
      if WarMain(warnum + startwar, 0) == true then
        instruct_0()
        instruct_13()
        TalkEx("还有那位前辈肯赐教？", 0, 1)
        instruct_0()
      else
        instruct_15()
        return 
      end
    end
    if i < group - 1 then
      TalkEx("少侠已连战三场，*可先休息再战．", 70, 0)
      instruct_0()
      instruct_14()
      lib.Delay(300)
      if JY.Person[0]["受伤程度"] < 50 and JY.Person[0]["中毒程度"] <= 0 then
        JY.Person[0]["受伤程度"] = 0
        AddPersonAttrib(0, "体力", math.huge)
        AddPersonAttrib(0, "内力", math.huge)
        AddPersonAttrib(0, "生命", math.huge)
      end
      instruct_13()
      TalkEx("我已经休息够了，*有谁要再上？", 0, 1)
      instruct_0()
    end
  end
  TalkEx("接下来换谁？**．．．．*．．．．***没有人了吗？", 0, 1)
  instruct_0()
  TalkEx("如果还没有人要出来向这位*少侠挑战，那麽这武功天下*第一之名，武林盟主之位，*就由这位少侠夺得．***．．．．．．*．．．．．．*．．．．．．*好，恭喜少侠，这武林盟主*之位就由少侠获得，而这把*”武林神杖”也由你保管．", 70, 0)
  instruct_0()
  TalkEx("恭喜少侠！", 12, 0)
  instruct_0()
  TalkEx("小兄弟，恭喜你！", 64, 4)
  instruct_0()
  TalkEx("好，今年的武林大会到此已*圆满结束，希望明年各位武*林同道能再到我华山一游．", 19, 0)
  instruct_0()
  instruct_14()
  for i = 24, 72 do
    instruct_3(-2, i, 0, 0, -1, -1, -1, -1, -1, -1, -2, -2, -2)
  end
  instruct_0()
  instruct_13()
  TalkEx("历经千辛万苦，我终於打败*群雄，得到这武林盟主之位*及神杖．*但是”圣堂”在那呢？*为什麽没人告诉我，难道大*家都不知道．*这会儿又有的找了．", 0, 1)
  instruct_0()
  instruct_2(143, 1)
end

function instruct_59()
  for i = CC.TeamNum, 2, -1 do
    if JY.Base["队伍" .. i] >= 0 then
      instruct_21(JY.Base["队伍" .. i])
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
  say("感谢下载Ｒ龙的传人制作组Ｗ出品的ＨＧ龙的传人Android版本Ｗ！Ｈ选择重新开始可进行下一周目的游戏！", 260, 5, "龙的传人")
  
  --保存周目
  if GetS(53, 0, 1, 5) >= CC.CircleNum-1 then
  	local data = string.format("%s&&%d&&%d&&%d\n",JY.Person[0]["姓名"],GetS(4, 5, 5, 5),GetS(4, 5, 5, 4),JY.Thing[202][WZ7]);
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
  DrawStrBoxWaitKey( "片尾曲：英雄梦", C_WHITE, CC.DefaultFont)
  DrawStrBoxWaitKey( "按任意键退出", C_WHITE, CC.DefaultFont)
  
  JY.Status=GAME_END;
end

function instruct_63(personid, sex)
  JY.Person[personid]["性别"] = sex
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
  TalkEx("这位小哥，看看有什麽需要*的，小店卖的东西价钱绝*对公道．", headid, 0)
  local menu = {}
  for i = 1, 5 do
    menu[i] = {}
    local thingid = JY.Shop[id]["物品" .. i]
    menu[i][1] = string.format("%-12s %5d", JY.Thing[thingid]["名称"], JY.Shop[id]["物品价格" .. i])
    menu[i][2] = nil
    if JY.Shop[id]["物品数量" .. i] > 0 then
      menu[i][3] = 1
    else
      menu[i][3] = 0
    end
  end
  for i = 1, 200 do
    if JY.Base["物品" .. i] > 143 and JY.Base["物品" .. i] < 158 then
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
    if instruct_31(JY.Shop[id]["物品价格" .. r]) == false then
      TalkEx("非常抱歉，*你身上的钱似乎不够．", headid, 0)
    else
	    JY.Shop[id]["物品数量" .. r] = JY.Shop[id]["物品数量" .. r] - 1
	    instruct_32(CC.MoneyID, -JY.Shop[id]["物品价格" .. r])
	    instruct_32(JY.Shop[id]["物品" .. r], 1)
	    TalkEx("大爷买了小店的东西，*保证绝不後悔．", headid, 0)
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



--选择框，每个选项都带边框
--title 标题
--str 内容 *换行
--button 选项
--num 选项的个数，一定要和选项对应起来
--headid 显示在内容左边的贴图，如果不传值则不显示贴图
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


--显示带边框的文字
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
	--加载场景贴图文件
	lib.PicLoadFile(CC.SMAPPicFile[1], CC.SMAPPicFile[2], 0)
	--lib.PicLoadFile(CC.HeadPicFile[1], CC.HeadPicFile[2], 1, limitX(CC.ScreenW/6,50,110))
	lib.LoadPNGPath(CC.HeadPath, 1, CC.HeadNum, CC.Scale * 100)
	
	lib.PicLoadFile(CC.ThingPicFile[1], CC.ThingPicFile[2], 2)
  
  PlayMIDI(JY.Scene[JY.SubScene]["进门音乐"])
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
    DrawStrBox(-1, 10, JY.Scene[JY.SubScene]["名称"], C_WHITE, CC.DefaultFont)
    ShowScreen()
    WaitKey()



  end
  
  AutoMoveTab = {[0] = 0}
end

--新对话方式
--加入控制字符
--暂停，任意键后继续，ｐ
--控制颜色Ｒ=redＧ=goldＢ=blackＷ=whiteＯ=orange
--控制字符显示速度０,１,２,３,４,５,６,７,８,９
--控制字体ＡＳＤＦ
--控制换行Ｈ   分页Ｐ
--Ｎ代表自己ｎ代表主角
function say(s,pid,flag,name)          --个人新对话
  local picw=CC.PortraitPicWidth;       --最大头像图片宽高
	local pich=CC.PortraitPicHeight;
	local talkxnum=18;         --对话一行字数
	local talkynum=3;          --对话行数
	local dx=2 * CC.Scale;
	local dy=2 * CC.Scale;
  local boxpicw=picw+10 * CC.Scale;
	local boxpich=pich+10 * CC.Scale;
  local nbx=96 * CC.Scale;   --姓名框宽度
  local nby=27 * CC.Scale;   --姓名框高度
	local boxtalkw=talkxnum*CC.DefaultFont+10;
	local boxtalkh=boxpich-nby;
	local headid = pid
	pid=pid or 0
	--ALungky 修复主角说话有时候是猪头的BUG
  --ALungky 增加鲁棒性，如果不设定头像，不设定名字，或使用主角名字但头像为0则为主角,小村“龙的传人”自定义了名字，但不应为主角所以头像为猪头
	if (headid == 0 or headid == nil) and (name == nil or name == JY.Person[0]["姓名"]) then
		headid = (280 + GetS(4, 5, 5, 5))
	end
	
	if flag==nil then
		if pid==0 then
			flag=1
		else
			flag=0
		end
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

---
function MyDrawString(x1, x2, y, str, color, size)
  local len = math.modf(string.len(str) * size / 4)
  local x = math.modf((x1 + x2) / 2) - len
  DrawString(x, y, str, color, size)
end

--分割字符串
--szFullString字符串
--szSeparator分割符
--返回总数,分割后数组
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

--绘制一个带背景的白色方框，四角凹进
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

--绘制四角凹进的方框
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

--初始化主地图
function Init_MMap()
  lib.PicInit()
  lib.LoadMMap(CC.MMapFile[1], CC.MMapFile[2], CC.MMapFile[3], CC.MMapFile[4], CC.MMapFile[5], CC.MWidth, CC.MHeight, JY.Base["人X"], JY.Base["人Y"])
  
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

--自定义的进入子场景的函数
--需要进入的子场景编号
--x进入子场景后人物的X坐标，传入-1则默认为入口X
--y进入子场景后人物的Y坐标，传入-1则默认为入口Y
--direct人物面对的方向
function My_Enter_SubScene(sceneid,x,y,direct)	
	JY.SubScene = sceneid;
	local flag = 1;   --是否自定义的xy坐标, 0是，1否
	if x == -1 and y == -1 then
		JY.Base["人X1"]=JY.Scene[sceneid]["入口X"];
  	JY.Base["人Y1"]=JY.Scene[sceneid]["入口Y"];
  else
  	JY.Base["人X1"] = x;
  	JY.Base["人Y1"] = y;
  	flag = 0;
	end
	
	if direct > -1 then
		JY.Base["人方向"] = direct;
	end
 			
	
	if JY.Status == GAME_MMAP then
		CleanMemory();
		lib.UnloadMMap();
	end
  lib.ShowSlow(20,1)

	JY.Status=GAME_SMAP;  --改变状态
  JY.MmapMusic=-1;

	JY.Base["乘船"]=0;
  JY.MyPic=GetMyPic(); 
  
  --外景入口是个难点，有些子场景是通过跳转的方式进入的，需要判断
  --由于目前最多只能有一个子场景跳转，所以不需要进行循环判断
  local sid = JY.Scene[sceneid]["跳转场景"];
  
  if sid < 0 or (JY.Scene[sid]["外景入口X1"] <= 0 and JY.Scene[sid]["外景入口Y1"] <= 0) then
  	JY.Base["人X"] = JY.Scene[sceneid]["外景入口X1"];  --改变出子场景后的XY坐标
	JY.Base["人Y"] = JY.Scene[sceneid]["外景入口Y1"];
  else
	JY.Base["人X"] = JY.Scene[sid]["外景入口X1"];  --改变出子场景后的XY坐标
	JY.Base["人Y"] = JY.Scene[sid]["外景入口Y1"];
  end


  Init_SMap(flag);  --重新初始化地图
  
  if flag == 0 then    --如果是自定义位置，先传送到那个位置，再显示场景名称
  	DrawStrBox(-1,10,JY.Scene[JY.SubScene]["名称"],C_WHITE,CC.DefaultFont);
		ShowScreen();
		WaitKey();
  end
  
  Cls();
	
end

--简易信息
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
  DrawString(15, 15, string.format("品德:%d 银两:%d", JY.Person[0]["品德"], JY.GOLD), C_GOLD, CC.SmallFont)
  DrawString(15, 15+CC.SmallFont+CC.RowPixel, string.format("游戏时间:%2d时%2d分", t1, t2), C_GOLD, CC.SmallFont)
  DrawString(15, 15+2*(CC.SmallFont+CC.RowPixel), string.format("难度:%s 周目数:%d", MODEXZ2[tnd], CC.CircleNum), C_GOLD, CC.SmallFont)
end

function QZXS(s)
  DrawStrBoxWaitKey(s, C_GOLD, CC.DefaultFont)
end


--显示武功的文字
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

--清除贴图文字
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

--角色是否为零二七
function T1LEQ(id)
  if id == 0 and JY.Person[id]["姓名"] == JY.LEQ and GetS(4, 5, 5, 4) == 1 and GetS(4, 5, 5, 5) == 8 then
    return true
  else
    return false
  end
end--判断角色是否为水镜四奇
function T2SQ(id)
  if id == 0 and JY.Person[id]["姓名"] == JY.SQ and GetS(4, 5, 5, 4) == 2 and GetS(4, 5, 5, 5) == 8 then
    return true
  else
    return false
  end
end--判断角色是否为萧雨客
function T3XYK(id)
  if id == 0 and JY.Person[id]["姓名"] == JY.XYK and GetS(4, 5, 5, 4) == 3 and GetS(4, 5, 5, 5) == 8 then
    return true
  else
    return false
  end
end

---对矩形进行屏幕剪裁
--返回剪裁后的矩形，如果超出屏幕，返回空
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

--计算贴图改变形成的Clip裁剪
--(dx1,dy1) 新贴图和绘图中心点的坐标偏移。在场景中，视角不同而主角动时用到
--pic1 旧的贴图编号
--id1 贴图文件加载编号
--(dx2,dy2) 新贴图和绘图中心点的偏移
--pic2 旧的贴图编号
--id2 贴图文件加载编号
--返回，裁剪矩形 {x1,y1,x2,y2}
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

--合并矩形
function MergeRect(r1, r2)
  local res = {}
  res.x1 = math.min(r1.x1, r2.x1)
  res.y1 = math.min(r1.y1, r2.y1)
  res.x2 = math.max(r1.x2, r2.x2)
  res.y2 = math.max(r1.y2, r2.y2)
  return res
end

--最简单版本对话
function MyTalk(s,personid)            --最简单版本对话
    local flag;
    if personid==0 then
        flag=1;
		else
	    flag=0;
	end
	MyTalkEx(s,personid,flag,1);
end

--最简单版本对话
function MyTalk1(s,personid, name)            --最简单版本对话
    local flag;
    if personid==0 then
        flag=1;
		else
	    flag=0;
	end
	MyTalkEx(s,personid,flag,1, name);
end

--自定义复杂版本对话
--s 字符串，必须加上*作为分行，如果里面没有*,则会自动加上
--pid 人物编号
--flag 显示位置
--showname 是否显示名字
--name 显示的名字
function MyTalkEx(s,pid,flag,showname,name)          --复杂版本对话
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
  local headid = JY.Person[pid]["头像代号"];
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
	      		DrawString(showx, showy, JY.Person[pid]["姓名"], C_GOLD, 20 * CC.Scale)
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


--自定义事件
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

--显示阴影字符串
--如果x,y传-1，那么显示在屏幕中间
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

--由于不能输入数字，使用方向键代替
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
  
  local help = "上下加减一，左右加减十";
  if minNum ~= nil then
  	help = help .. " 最小"..minNum;
  end
  if minNum ~= nil then
  	help = help .. " 最大"..maxNum;
  end
  if isEsc ~= nil then
  	help = help .. " ESC取消输入";
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


--分析字符串中是否有颜色标志
function AnalyString(str)
		local tlen = 0;
		local strcolor = {}
		--检查是否有颜色标志
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

			     --如果已经没有其它颜色标志，直接输入退出循环
			     if f1 == nil then
			     	table.insert(strcolor, {str, nil});
			     	break;
			     end
			  else		--如果找不到结束标志，直接输入退出循环
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


--存档列表
function SaveList()
	--读取R*.idx文件
  local idxData = Byte.create(24)
  Byte.loadfile(idxData, CC.R_IDXFilename[0], 0, 24)
  local idx = {}
  idx[0] = 0
  for i = 1, 6 do
    idx[i] = Byte.get32(idxData, 4 * (i - 1))
  end

  local table_struct = {}
  table_struct["姓名"]={idx[1]+8,2,10}
  table_struct["等级"]={idx[1]+30,0,2}
  
  table_struct["无用"]={idx[0]+2,0,2}
  table_struct["场景名称"]={idx[3]+2,2,10}
  
  --主角编号
  table_struct["队伍1"]={idx[0]+24,0,2}
  
  
  table_struct[WZ7]={idx[2]+88,0,2}
  
  --时间保存在场景数据里
  table_struct["游戏时间"]={(CC.SWidth*CC.SHeight*(14*6+4) + CC.SWidth + 2)*2, 0, 2}
	--S_XMax*S_YMax*(id*6+level)+y*S_XMax+x
	--14, 2, 1, 4
	--sFile,CC.TempS_Filename,JY.SceneNum,CC.SWidth,CC.SHeight

  --读取R*.grp文件

	local len = filelength(CC.R_GRPFilename[0]);
	local data = Byte.create(len);
	
	--读取SMAP.grp
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
			
			local pid = GetDataFromStruct(data,0,table_struct,"队伍1");
			
			name = GetDataFromStruct(data,pid*CC.PersonSize,table_struct,"姓名");
			lv = GetDataFromStruct(data,pid*CC.PersonSize,table_struct,"等级").."级";
			local wy = GetDataFromStruct(data,0,table_struct,"无用");
			if wy == -1 then
				sname = "大地图";
			else
				sname = GetDataFromStruct(data,wy*CC.SceneSize,table_struct,"场景名称").."";
			end
			
			local wz = GetDataFromStruct(data,202*CC.ThingSize,table_struct,WZ7);
			local tnd = math.fmod(wz,#MODEXZ2);
			if tnd == 0 then
				tnd = #MODEXZ2
			end
			nd = MODEXZ2[tnd];
			
			--游戏时间
			Byte.loadfile(sdata, string.format(CC.S_GRP,i), 0, slen);
			
			local t = GetDataFromStruct(sdata, 0, table_struct, "游戏时间")
		  local t1, t2 = 0, 0
		  while t >= 60 do
		    t = t - 60
		    t1 = t1 + 1
		  end
		  t2 = t
		  
		  time = string.format("%2d时%2d秒", t1, t2)
		end
		
		menu[i] = {string.format("%2d: %s  %s  %s  %s %s",i,name, lv, sname, nd, time), nil, 1};
		

	end

	local menux=(CC.ScreenW-20*CC.DefaultFont-2*CC.MenuBorderPixel)/2
	local menuy=(CC.ScreenH - 10*(CC.DefaultFont+CC.RowPixel))/2

  local r=ShowMenu(menu,CC.SaveNum,10,menux,menuy,0,0,1,1,CC.DefaultFont,C_WHITE,C_GOLD)
  
 
  
	CleanMemory()
	return r;
end


--获取已得到的天书个数
function GetBookNum()

	local num = 0;
	for i=1, CC.MyThingNum do
		if JY.Base["物品"..i] < 0 then
			return num;
		end
		
		if JY.Base["物品"..i] >= CC.BookStart and JY.Base["物品"..i] < CC.BookStart + CC.BookNum then
			num = num + 1
		end
	end
	
	return num;


end


--动态显示提示
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

--获取实战
function GetSZ(pid)
	for j = 1, #TeamP do
      if pid == TeamP[j] then
      	return GetS(5, j, 6, 5) - 2;
      end
  end
	return 0;
end


--读取技能数据
function LoadSkillData(id)

	--新档固定长度
	if id == 0 then
		JY.SkillNum = 100;
	else
		JY.SkillNum = filelength(CC.SkillFile)/CC.SkillSize;
	end

	--创建字节数据
	JY.Data_Skill = Byte.create(JY.SkillNum * CC.SkillSize);

	--如果不是重开，则读取文件内容
	if id ~= 0 and existFile(CC.SkillFile) then
		Byte.loadfile(JY.Data_Skill, CC.SkillFile, 0, JY.SkillNum * CC.SkillSize)
	end


  --加载技能数据
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