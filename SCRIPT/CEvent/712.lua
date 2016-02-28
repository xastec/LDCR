--重写挑战十八铜人
--两个选择，一：单挑，挺过800时序   二：群战，500时序内战胜
--OEVENTLUA[712] = function()
		
	local title = "挑战十八铜人";
	local str = "少林铜人巷，每个人只有一次机率*请选择挑战的方式*单挑，胜利条件：挺过800时序*群战，胜利条件：500时序内战胜*"
	local btn = {"单挑","群战","放弃"};
	local num = #btn;
	local r = JYMsgBox(title,str,btn,num);
	
	if r == 3 then
		return;
	end
	
	--单挑
	if r == 1 then
		SetS(86,1,2,5,1);		--判断单挑十八铜人
	end
	
	--群战
	if r == 2 then
		SetS(86,1,2,5,2);		--判断单挑十八铜人
	end

  instruct_1(2881,210,0);   --  1(1):[???]说: 好，施主里边请！
  instruct_0();   --  0(0)::空语句(清屏)
  instruct_19(41,14);   --  19(13):主角移动至29-E
  instruct_0();   --  0(0)::空语句(清屏)

	if instruct_6(217,0,7,1) ==true then    --  6(6):战斗[217]否则跳转到:Label3
	  instruct_19(41,7);   --  19(13):主角移动至29-7
	  instruct_0();   --  0(0)::空语句(清屏)
	  instruct_13();   --  13(D):重新显示场景
	  instruct_0();   --  0(0)::空语句(清屏)
	  do return; end
	end    --:Label3

  instruct_19(42,17);   --  19(13):主角移动至2A-11
  instruct_0();   --  0(0)::空语句(清屏)
  instruct_13();   --  13(D):重新显示场景
  instruct_3(-2,-2,1,0,709,0,0,-2,-2,-2,-2,-2,-2);   --  3(3):修改事件定义:当前场景:当前场景事件编号
--end