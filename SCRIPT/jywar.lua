function War_Contact(id, txwz, str)
		if WAR.Person[id][txwz] ~= nil then
			WAR.Person[id][txwz] = WAR.Person[id][txwz] .. "+".. str
			else
			WAR.Person[id][txwz] = str
		end
end

--返回两人之间的实际距离
function War_realjl(ida, idb)
  if ida == nil then
    ida = WAR.CurID
  end
  CleanWarMap(3, 255)
  local x = WAR.Person[ida]["坐标X"]
  local y = WAR.Person[ida]["坐标Y"]
  local steparray = {}
  steparray[0] = {}
  steparray[0].bushu = {}
  steparray[0].x = {}
  steparray[0].y = {}
  SetWarMap(x, y, 3, 0)
  steparray[0].num = 1
  steparray[0].bushu[1] = 0		--还能移动的步数
  steparray[0].x[1] = x
  steparray[0].y[1] = y
  return War_FindNextStep1(steparray, 0, ida, idb)
end

function unnamed(kfid)
  local pid = WAR.Person[WAR.CurID]["人物编号"]
  local kungfuid = JY.Person[pid]["武功" .. kfid]
  local kungfulv = JY.Person[pid]["武功等级" .. kfid]
  if kungfulv == 999 then
    kungfulv = 11
  else
    kungfulv = math.modf(kungfulv / 100) + 1
  end
  local m1, m2, a1, a2, a3, a4, a5 = refw(kungfuid, kungfulv)
  local mfw = {m1, m2}
  local atkfw = {a1, a2, a3, a4, a5}
  if kungfulv == 11 then
    kungfulv = 10
  end
  local kungfuatk = JY.Wugong[kungfuid]["攻击力" .. kungfulv]
  local atkarray = {}
  local num = 0
  CleanWarMap(4, -1)
  local movearray = War_CalMoveStep(WAR.CurID, WAR.Person[WAR.CurID]["移动步数"], 0)
  WarDrawMap(1)
  ShowScreen()
  for i = 0, WAR.Person[WAR.CurID]["移动步数"] do
    local step_num = movearray[i].num
    if step_num ~= nil then
	    for j = 1, step_num do
	      local xx = movearray[i].x[j]
	      local yy = movearray[i].y[j]
	      num = num + 1
	      atkarray[num] = {}
	      atkarray[num].x, atkarray[num].y = xx, yy
	      atkarray[num].p, atkarray[num].ax, atkarray[num].ay = GetAtkNum(xx, yy, mfw, atkfw, kungfuatk)
	      
	      
	    end
    end
  end
  for i = 1, num - 1 do
    for j = i + 1, num do
      if atkarray[i].p < atkarray[j].p then
        atkarray[i], atkarray[j] = atkarray[j], atkarray[i]
      end
    end
  end
  if atkarray[1].p > 0 then
    for i = 2, num do
      if atkarray[i].p == 0 or atkarray[i].p < atkarray[1].p / 2 then
        num = i - 1
        break;
      end
    end
    for i = 1, num do
      atkarray[i].p = atkarray[i].p + GetMovePoint(atkarray[i].x, atkarray[i].y)
    end
    for i = 1, num - 1 do
      for j = i + 1, num do
        if atkarray[i].p < atkarray[j].p then
          atkarray[i], atkarray[j] = atkarray[j], atkarray[i]
        elseif atkarray[i].p == atkarray[j].p and math.random(2) > 1 then
        	atkarray[i], atkarray[j] = atkarray[j], atkarray[i]
        end
      end
    end
    for i = 2, num do
      if atkarray[i].p < atkarray[1].p *4/5 then
        num = i - 1
        break;
      end
    end
    local select = 1
    
    War_CalMoveStep(WAR.CurID, WAR.Person[WAR.CurID]["移动步数"], 0)
    War_MovePerson(atkarray[select].x, atkarray[select].y)
    War_Fight_Sub(WAR.CurID, kfid, atkarray[select].ax, atkarray[select].ay)
  else
    local jl, nx, ny = War_realjl()
    --if jl == -1 then
      AutoMove()
    --end
    War_RestMenu()
  end
end


function AutoMove()
  local x, y = nil, nil
  local minDest = math.huge
  local enemyid=War_AutoSelectEnemy()   --选择最近敌人

	War_CalMoveStep(WAR.CurID,100,0);   --计算移动步数 假设最大100步

	for i=0,CC.WarWidth-1 do
     for j=0,CC.WarHeight-1 do
				local dest=GetWarMap(i,j,3);
        if dest <128 then
          local dx=math.abs(i-WAR.Person[enemyid]["坐标X"])
          local dy=math.abs(j-WAR.Person[enemyid]["坐标Y"])
          if minDest>(dx+dy) then        --此时x,y是距离敌人的最短路径，虽然可能被围住
            minDest=dx+dy;
            x=i;
            y=j;
          elseif minDest==(dx+dy) then
            if Rnd(2)==0 then
                x=i;
                y=j;
            end
          end
        end
    end
	end

	if minDest<math.huge then   --有路可走
	    while true do    --从目的位置反着找到可以移动的位置，作为移动的次序
				local i=GetWarMap(x,y,3);
			if i<=WAR.Person[WAR.CurID]["移动步数"] then
				break;
			end

			if GetWarMap(x-1,y,3)==i-1 then
				x=x-1;
			elseif GetWarMap(x+1,y,3)==i-1 then
				x=x+1;
			elseif GetWarMap(x,y-1,3)==i-1 then
				y=y-1;
			elseif GetWarMap(x,y+1,3)==i-1 then
				y=y+1;
			end
	    end
	  War_MovePerson(x,y);    --移动到相应的位置
  end
end



function GetMovePoint(x, y, flag)
  local point = 0
  local wofang = WAR.Person[WAR.CurID]["我方"]
  local movearray = MY_CalMoveStep(x, y, 9, 1)
  for i = 1, 9 do
    local step_num = movearray[i].num
    if step_num ~= nil then
    	if step_num == 0 then
    		break;
    	end
	    for j = 1, step_num do
	      local xx = movearray[i].x[j]
	      local yy = movearray[i].y[j]
	      local v = GetWarMap(xx, yy, 2)
	      if v ~= -1 then
	        if v == WAR.CurID then
						break;
					else   
			      if WAR.Person[v]["我方"] == wofang then
			        point = point + i * 2 - 19
			      elseif WAR.Person[v]["我方"] ~= wofang then
			      
			        if flag ~= nil then
			          point = point + i - 10
				      else
				        point = point + 19 - i
				      end
				    end
				  end
		    end
	    end
    end
  end
  return point
end

function MY_CalMoveStep(x, y, stepmax, flag)
  CleanWarMap(3, 255)
  local steparray = {}
  for i = 0, stepmax do
    steparray[i] = {}
    steparray[i].bushu = {}
    steparray[i].x = {}
    steparray[i].y = {}
  end
  SetWarMap(x, y, 3, 0)
  steparray[0].num = 1
  steparray[0].bushu[1] = stepmax
  steparray[0].x[1] = x
  steparray[0].y[1] = y
  War_FindNextStep(steparray, 0, flag)
  return steparray
end


--战斗会跳出的问题
function GetAtkNum(x, y, movfw, atkfw, atk)
  local point = {}
  local num = 0
  local kind, len = movfw[1], movfw[2]
  
  if kind == 0 then
    local array = MY_CalMoveStep(x, y, len, 1)
    for i = 0, len do
      local step_num = array[i].num
      if step_num ~= nil then
        if step_num == 0 then
          break;
        end
	      for j = 1, step_num do
	        num = num + 1
	        point[num] = {array[i].x[j], array[i].y[j]}
	      end
	    end
    end
  elseif kind == 1 then
    local array = MY_CalMoveStep(x, y, len * 2, 1)
    for r = 1, len * 2 do
      for i = 0, r do
        local j = r - i
        if len < i or len < j then
          SetWarMap(x + i, y + j, 3, 255)
          SetWarMap(x + i, y - j, 3, 255)
          SetWarMap(x - i, y + j, 3, 255)
          SetWarMap(x - i, y - j, 3, 255)
        end
      end
    end
    for i = 0, len do
      local step_num = array[i].num
      if step_num ~= nil then
        if step_num == 0 then
          break;
        end
	      for j = 1, step_num do
	        if GetWarMap(array[i].x[j], array[i].y[j], 3) < 128 then
	          num = num + 1
	          point[num] = {array[i].x[j], array[i].y[j]}
	        end
	      end
	    end
    end
  elseif kind == 2 then
    if not len then
      len = 1
    end
    for i = 1, len do
      if x + i < CC.WarWidth - 1 and GetWarMap(x + i, y, 1) > 0 and CC.WarWater[GetWarMap(x + i, y, 0)] == nil then
        break;
      end
      num = num + 1
      point[num] = {x + i, y}
    end
    for i = 1, len do
      if x - i > 0 and GetWarMap(x - i, y, 1) > 0 and CC.WarWater[GetWarMap(x - i, y, 0)] == nil then
        break;
      end
      num = num + 1
      point[num] = {x - i, y}
    end
    for i = 1, len do
      if y + i < CC.WarHeight - 1 and GetWarMap(x, y + i, 1) > 0 and CC.WarWater[GetWarMap(x, y + i, 0)] == nil then
        break;
      end
      num = num + 1
      point[num] = {x, y + i}
    end
    for i = 1, len do
      if y - i > 0 and GetWarMap(x, y - i, 1) > 0 and CC.WarWater[GetWarMap(x, y - i, 0)] == nil then
        break;
      end
      num = num + 1
      point[num] = {x, y - i}
    end
  elseif kind == 3 then
    if x + 1 < CC.WarWidth - 1 and GetWarMap(x + 1, y, 1) == 0 and CC.WarWater[GetWarMap(x + 1, y, 0)] == nil then
      num = num + 1
      point[num] = {x + 1, y}
    end
    if x - 1 > 0 and GetWarMap(x - 1, y, 1) == 0 and CC.WarWater[GetWarMap(x - 1, y, 0)] == nil then
      num = num + 1
      point[num] = {x - 1, y}
    end
    if y + 1 < CC.WarHeight - 1 and GetWarMap(x, y + 1, 1) == 0 and CC.WarWater[GetWarMap(x, y + 1, 0)] == nil then
      num = num + 1
      point[num] = {x, y + 1}
    end
    if y - 1 > 0 and GetWarMap(x, y - 1, 1) == 0 and CC.WarWater[GetWarMap(x, y - 1, 0)] == nil then
      num = num + 1
      point[num] = {x, y - 1}
    end
    if x + 1 < CC.WarWidth - 1 and y + 1 < CC.WarHeight - 1 and GetWarMap(x + 1, y + 1, 1) == 0 and CC.WarWater[GetWarMap(x + 1, y + 1, 0)] == nil then
      num = num + 1
      point[num] = {x + 1, y + 1}
    end
    if x - 1 > 0 and y + 1 < CC.WarHeight - 1 and GetWarMap(x - 1, y + 1, 1) == 0 and CC.WarWater[GetWarMap(x - 1, y + 1, 0)] == nil then
      num = num + 1
      point[num] = {x - 1, y + 1}
    end
    if x + 1 < CC.WarWidth - 1 and y - 1 > 0 and GetWarMap(x + 1, y - 1, 1) == 0 and CC.WarWater[GetWarMap(x + 1, y - 1, 0)] == nil then
      num = num + 1
      point[num] = {x + 1, y - 1}
    end
    if x - 1 > 0 and y - 1 > 0 and GetWarMap(x - 1, y - 1, 1) == 0 and CC.WarWater[GetWarMap(x - 1, y - 1, 0)] == nil then
    	num = num + 1
    	point[num] = {x - 1, y - 1}
  	end
  end
  local maxx, maxy, maxnum, atknum = 0, 0, 0, 0
  

  for i = 1, num do
    atknum = GetWarMap(point[i][1], point[i][2], 4)
    
    if atknum == -1 or atkfw[1] > 9 then
      atknum = WarDrawAtt(point[i][1], point[i][2], atkfw, 2, x, y, atk)
      SetWarMap(point[i][1], point[i][2], 4, atknum)
    end
    if atknum~= nil and maxnum < atknum then
      maxnum, maxx, maxy = atknum, point[i][1], point[i][2]
    end
  end
  
  return maxnum, maxx, maxy
end



function War_FindNextStep1(steparray,step,id,idb)      --设置下一步可移动的坐标
 --被上面的函数调用   
	local num=0;
	local step1=step+1;
	
	    steparray[step1]={};
		steparray[step1].bushu={};
        steparray[step1].x={};
        steparray[step1].y={};
	
	local function fujinnum(tx,ty)
		local tnum=0
		local wofang=WAR.Person[id]["我方"]
		local tv;
		tv=GetWarMap(tx+1,ty,2);
		if idb==nil then
			if tv~=-1 then
				if WAR.Person[tv]["我方"]~=wofang then
					return -1
				end
			end
		elseif tv==idb then
			return -1
		end
		if tv~=-1 then
			if WAR.Person[tv]["我方"]~=wofang then
				tnum=tnum+1
			end
		end
		tv=GetWarMap(tx-1,ty,2);
		if idb==nil then
			if tv~=-1 then
				if WAR.Person[tv]["我方"]~=wofang then
					return -1
				end
			end
		elseif tv==idb then
			return -1
		end
		if tv~=-1 then
			if WAR.Person[tv]["我方"]~=wofang then
				tnum=tnum+1
			end
		end
		tv=GetWarMap(tx,ty+1,2);
		if idb==nil then
			if tv~=-1 then
				if WAR.Person[tv]["我方"]~=wofang then
					return -1
				end
			end
		elseif tv==idb then
			return -1
		end
		if tv~=-1 then
			if WAR.Person[tv]["我方"]~=wofang then
				tnum=tnum+1
			end
		end
		tv=GetWarMap(tx,ty-1,2);
		if idb==nil then
			if tv~=-1 then
				if WAR.Person[tv]["我方"]~=wofang then
					return -1
				end
			end
		elseif tv==idb then
			return -1
		end
		if tv~=-1 then
			if WAR.Person[tv]["我方"]~=wofang then
				tnum=tnum+1
			end
		end
		return tnum
	end
	
	
	
	for i=1,steparray[step].num do
		--if steparray[step].bushu[i]<128 then
		steparray[step].bushu[i]=steparray[step].bushu[i]+1;
	    local x=steparray[step].x[i];
	    local y=steparray[step].y[i];
	    if x+1<CC.WarWidth-1 then                        --当前步数的相邻格
		    local v=GetWarMap(x+1,y,3);
			if v ==255 and War_CanMoveXY(x+1,y,0)==true then
                num= num+1;
                steparray[step1].x[num]=x+1;
                steparray[step1].y[num]=y;
				SetWarMap(x+1,y,3,step1);
				local mnum=fujinnum(x+1,y);
				if mnum==-1 then 
					return steparray[step].bushu[i],x+1,y
				else
					steparray[step1].bushu[num]=steparray[step].bushu[i]+mnum;
				end
			end
		end

	    if x-1>0 then                        --当前步数的相邻格
		    local v=GetWarMap(x-1,y,3);
			if v ==255 and War_CanMoveXY(x-1,y,0)==true then
                 num=num+1;
                steparray[step1].x[num]=x-1;
                steparray[step1].y[num]=y;
				SetWarMap(x-1,y,3,step1);
				local mnum=fujinnum(x-1,y);
				if mnum==-1 then 
					return steparray[step].bushu[i],x-1,y
				else
					steparray[step1].bushu[num]=steparray[step].bushu[i]+mnum;
				end
			end
		end

	    if y+1<CC.WarHeight-1 then                        --当前步数的相邻格
		    local v=GetWarMap(x,y+1,3);
			if v ==255 and War_CanMoveXY(x,y+1,0)==true then
                 num= num+1;
                steparray[step1].x[num]=x;
                steparray[step1].y[num]=y+1;
				SetWarMap(x,y+1,3,step1);
				local mnum=fujinnum(x,y+1);
				if mnum==-1 then 
					return steparray[step].bushu[i],x,y+1
				else
					steparray[step1].bushu[num]=steparray[step].bushu[i]+mnum;
				end
			end
		end

	    if y-1>0 then                        --当前步数的相邻格
		    local v=GetWarMap(x ,y-1,3);
			if v ==255 and War_CanMoveXY(x,y-1,0)==true then
                num= num+1;
                steparray[step1].x[num]=x ;
                steparray[step1].y[num]=y-1;
				SetWarMap(x ,y-1,3,step1);
				local mnum=fujinnum(x,y-1);
				if mnum==-1 then 
					return steparray[step].bushu[i],x,y-1
				else
					steparray[step1].bushu[num]=steparray[step].bushu[i]+mnum;
				end
			end
		end
		--end
	end
	if num==0 then return -1 end;
    steparray[step1].num=num;
	for i=1,num-1 do
		for j=i+1,num do
			if steparray[step1].bushu[i]>steparray[step1].bushu[j] then
				steparray[step1].bushu[i],steparray[step1].bushu[j]=steparray[step1].bushu[j],steparray[step1].bushu[i]
				steparray[step1].x[i],steparray[step1].x[j]=steparray[step1].x[j],steparray[step1].x[i]
				steparray[step1].y[i],steparray[step1].y[j]=steparray[step1].y[j],steparray[step1].y[i]
			end
		end
	end
	
	
	return War_FindNextStep1(steparray,step1,id,idb)

end
--修炼物品
function War_PersonTrainDrug(pid)
  local p = JY.Person[pid]
  local thingid = p["修炼物品"]
  if thingid < 0 then
    return 
  end
  if JY.Thing[thingid]["练出物品需经验"] <= 0 then
    return 
  end
  local needpoint = (7 - math.modf(p["资质"] / 15)) * JY.Thing[thingid]["练出物品需经验"]
  if p["物品修炼点数"] < needpoint then
    return 
  end
  
  local haveMaterial = 0
  local MaterialNum = -1
  for i = 1, CC.MyThingNum do
    if JY.Base["物品" .. i] == JY.Thing[thingid]["需材料"] then
      haveMaterial = 1
      MaterialNum = JY.Base["物品数量" .. i]
    end
  end
  
  --材料足够
  if haveMaterial == 1 then
    local enough = {}
    local canMake = 0
    for i = 1, 5 do
      if JY.Thing[thingid]["练出物品" .. i] >= 0 and JY.Thing[thingid]["需要物品数量" .. i] <= MaterialNum then
        canMake = 1
        enough[i] = 1
      else
        enough[i] = 0
      end
    end

  
	  --可以练出
	  if canMake == 1 then
	    local makeID = nil
	    while true do
	      makeID = Rnd(5) + 1
	      if thingid == 221 and pid == 88 and enough[4] == 1 then
	        makeID = 4
	      end
	      if thingid == 220 and pid == 89 and enough[4] == 1 then
	        makeID = 4
	      end
	      if enough[makeID] == 1 then
	        break;
	      end
	    end
	    
	    local newThingID = JY.Thing[thingid]["练出物品" .. makeID]
	    DrawStrBoxWaitKey(string.format("%s 制造出 %s", p["姓名"], JY.Thing[newThingID]["名称"]), C_WHITE, CC.DefaultFont)
	    if instruct_18(newThingID) == true then
	      instruct_32(newThingID, 1)
	    else
	      instruct_32(newThingID, 1)
	    end
	    instruct_32(JY.Thing[thingid]["需材料"], -JY.Thing[thingid]["需要物品数量" .. makeID])
	    p["物品修炼点数"] = 0
	  end
	end
end--计算敌人中毒点数
--pid 使毒人，
--enemyid  中毒人
function War_PoisonHurt(pid, enemyid)
  local vv = math.modf((JY.Person[pid]["用毒能力"] - JY.Person[enemyid]["抗毒能力"]) / 4)
  if JY.Status == GAME_WMAP then
    for i,v in pairs(CC.AddPoi) do
      if v[1] == pid then
        for wid = 0, WAR.PersonNum - 1 do
          if WAR.Person[wid]["人物编号"] == v[2] and WAR.Person[wid]["死亡"] == false then
            vv = vv + v[3] / 4
          end
        end
      end
    end
  end
  vv = vv - JY.Person[enemyid]["内力"] / 200
  for i = 1, 10 do
    if JY.Person[enemyid]["武功" .. i] == 108 then
      vv = 0
    end
  end
  vv = math.modf(vv)
  if vv < 0 then
    vv = 0
  end
  return AddPersonAttrib(enemyid, "中毒程度", vv)
end


--人物按轻功进行排序
function WarPersonSort(flag)
  for i = 0, WAR.PersonNum - 1 do
    local id = WAR.Person[i]["人物编号"]
    local add = 0
    if JY.Person[id]["武器"] > -1 then
      add = add + JY.Thing[JY.Person[id]["武器"]]["加轻功"]
    end
    if JY.Person[id]["防具"] > -1 then
      add = add + JY.Thing[JY.Person[id]["防具"]]["加轻功"]
    end
    WAR.Person[i]["轻功"] = JY.Person[id]["轻功"] + (add)
    if WAR.Person[i]["我方"] then
      
    else
	    if GetS(0, 0, 0, 0) == 1 then
	      WAR.Person[i]["轻功"] = WAR.Person[i]["轻功"] + math.modf(JY.Person[id]["内力最大值"] / 50) + JY.Person[id]["等级"]
	    else
	      WAR.Person[i]["轻功"] = WAR.Person[i]["轻功"] + math.modf(JY.Person[id]["内力最大值"] / 100)
	    end
	  end
    for ii,v in pairs(CC.AddSpd) do
      if v[1] == id then
        for wid = 0, WAR.PersonNum - 1 do
          if WAR.Person[wid]["人物编号"] == v[2] and WAR.Person[wid]["死亡"] == false then
            WAR.Person[i]["轻功"] = WAR.Person[i]["轻功"] + v[3]
          end
        end
      end
    end
  end
  if flag ~= nil then
    return 
  end
  for i = 0, WAR.PersonNum - 2 do
    local maxid = i
    for j = i, WAR.PersonNum - 1 do
      if WAR.Person[maxid]["轻功"] < WAR.Person[j]["轻功"] then
        maxid = j;
      end
    end
    WAR.Person[maxid], WAR.Person[i] = WAR.Person[i], WAR.Person[maxid]
  end
end

--显示非攻击时的点数
function War_Show_Count(id, str)

	local pid = WAR.Person[id]["人物编号"];
	local x = WAR.Person[id]["坐标X"];
	local y = WAR.Person[id]["坐标Y"];
	
	local hp = WAR.Person[id]["生命点数"];
  local mp = WAR.Person[id]["内力点数"];
  local tl = WAR.Person[id]["体力点数"];
  local ed = WAR.Person[id]["中毒点数"];
  local dd = WAR.Person[id]["解毒点数"];
  local ns = WAR.Person[id]["内伤点数"];
  
  local show = {x, y, nil, nil, nil, nil, nil, nil, nil, nil, nil};		--x, y, 生命, 内力, 体力, 封穴, 流血, 中毒, 解毒, 内伤
	
	if hp ~= nil and hp ~= 0 then		--显示生命
		if hp > 0 then
    	show[3] = "命+"..hp;
    else
    	show[3] = "命"..hp;
    end
	end
	
	if mp ~= nil and mp ~= 0 then		--显示内力
		if mp > 0 then
    	show[4] = "内+"..mp;
    else
    	show[4] = "内"..mp;
    end
	end
	
	if tl ~= nil and tl ~= 0 then		--显示体力
		if tl > 0 then
    	show[5] = "体+"..tl;
    else
    	show[5] = "体"..tl;
    end
	end
	
	
	if ed ~= nil and ed ~= 0 then		--显示中毒
    show[8] = "毒+"..ed;
	end
	
	if dd ~= nil and dd ~= 0 then		--显示解毒
    show[9] = "毒-"..dd;
	end
	
	if ns ~= nil and ns ~= 0 then		--显示内伤
		if ns > 0 then
    	show[10] = ns;
    else
    	--show[10] = "内伤↓ ";
    end
	end
	
	--记录哪个位置上有点数
	local showValue = {};
	local showNum = 0;
	for i=3, 10 do
		if show[i] ~= nil then
			showNum = showNum + 1;
			showValue[showNum] = i;
		end
	end

	if showNum == 0 then
		return;
	end
	
	local hb = GetS(JY.SubScene, x, y, 4);
  
  local ll = string.len(show[showValue[1]]);	--长度
	
	local w = ll * CC.DefaultFont / 2 + 1
  local clip = {x1 = CC.ScreenW / 2 - w/2 - CC.XScale/2, y1 = CC.YScale + CC.ScreenH / 2 - hb, x2 = CC.XScale + CC.ScreenW / 2 + w, y2 = CC.YScale + CC.ScreenH / 2 + CC.DefaultFont + 1}
	local area = (clip.x2 - clip.x1) * (clip.y2 - clip.y1) + CC.DefaultFont*4		--绘画的范围
  local surid = lib.SaveSur(0, 0, CC.ScreenW, CC.ScreenH)		--绘画句柄
  
  local fastdraw = nil;
  --[[
  if CONFIG.FastShowScreen == 0 or CC.AutoWarShowHead == 1 then
    fastdraw = 0
  else
    fastdraw = 1
  end
  ]]
  for i = 5, 18 do
  	local tstart = lib.GetTime()
  	local y_off = i * 2
  	
  	--
  	if fastdraw == 1 and area < CC.ScreenW * CC.ScreenH / 2 then
  		local tmpclip = {x1 = clip.x1, y1 = clip.y1 - y_off, x2 = clip.x2, y2 = clip.y2 - y_off};
  		tmpclip = ClipRect(tmpclip)
      if tmpclip ~= nil then
        lib.SetClip(tmpclip.x1, tmpclip.y1, tmpclip.x2, tmpclip.y2)
        WarDrawMap(0)
        
        --显示文字
        if str ~= nil then
       		DrawString(clip.x1 - #str*CC.Fontsmall/5, clip.y1 - y_off  - CC.DefaultFont*4, str, C_WHITE, CC.Fontsmall);
       	end
        
        for j=1, showNum do
        	local c = showValue[j] - 1;
        	if showValue[j] == 3 and string.sub(show[3],1,1) == "-" then		--减少生命，显示为红色
        		c = 1;
        	end
        	DrawString(clip.x1, clip.y1 - y_off - (showNum-j+1)*CC.DefaultFont, show[showValue[j]], WAR.L_EffectColor[c], CC.DefaultFont); 	
        end       
      end
    else
    	lib.SetClip(0, 0, CC.ScreenW, CC.ScreenH)
      lib.LoadSur(surid, 0, 0)
      --显示文字
      if str ~= nil then
     		DrawString(clip.x1 - #str*CC.Fontsmall/5, clip.y1 - y_off - CC.DefaultFont*4, str, C_WHITE, CC.Fontsmall);
     	end
      for j=1, showNum do
      	local c = showValue[j] - 1;
      	if showValue[j] == 3 and (string.sub(show[3],1,1) == "-" or string.sub(show[3],2,2) == "-") then		--减少生命，显示为红色
      		c = 1;
      	end
      	DrawString(clip.x1, clip.y1 - y_off - (showNum-j+1)*CC.DefaultFont, show[showValue[j]], WAR.L_EffectColor[c], CC.DefaultFont); 	
      end 
  	end
  	
  	ShowScreen(1)
    lib.SetClip(0, 0, 0, 0)		--清除
    local tend = lib.GetTime()
    if tend - tstart < CC.Frame then
      lib.Delay(CC.Frame - (tend - tstart))
    end
  end
  
  lib.SetClip(0, 0, 0, 0)		--清除
  WAR.Person[id]["生命点数"] = nil;
  WAR.Person[id]["内力点数"] = nil;
  WAR.Person[id]["体力点数"] = nil;
  WAR.Person[id]["中毒点数"] = nil;
  WAR.Person[id]["解毒点数"] = nil;
  WAR.Person[id]["内伤点数"] = nil;
  
  lib.FreeSur(surid)
end


--药品使用实际效果
--id 物品id，
--personid 使用人id
--返回值：0 使用没有效果，物品数量应该不变。1 使用有效果，则使用后物品数量应该-1
function UseThingEffect(id, personid)
  local str = {}
  str[0] = string.format("使用 %s", JY.Thing[id]["名称"])
  local strnum = 1
  local addvalue = nil
  if JY.Thing[id]["加生命"] > 0 then
    local add = JY.Thing[id]["加生命"] - math.modf(JY.Thing[id]["加生命"] * JY.Person[personid]["受伤程度"] / 200) + Rnd(5)
    
    --胡青牛在队，吃药效果为1.3倍
    if JY.Status == GAME_WMAP and inteam(personid) and inteam(16) then
      for w = 0, WAR.PersonNum - 1 do
        if WAR.Person[w]["人物编号"] == 16 and WAR.Person[w]["死亡"] == false and WAR.Person[w]["我方"] then
          add = math.modf(add * 1.3)
          break;
        end
      end
    end
    if add <= 0 then
      add = 5 + Rnd(5)
    end
    add = math.modf(add)
    
    if JY.Status == GAME_WMAP then
	    if inteam(personid) then
	      WAR.Person[WAR.CurID]["内伤点数"] = AddPersonAttrib(personid, "受伤程度", -math.modf(add / 10))
	    else
	      WAR.Person[WAR.CurID]["内伤点数"] = AddPersonAttrib(personid, "受伤程度", -math.modf(add / 4))
	    end
	  end
	  --敌人吃药效果加倍
	  if not inteam(personid) then
	  	add = add * 2;
	  end
    addvalue, str[strnum] = AddPersonAttrib(personid, "生命", add)
    
    --蓝烟清：显示生命点数
    if JY.Status == GAME_WMAP then
    	WAR.Person[WAR.CurID]["生命点数"] = addvalue;
    end

    if addvalue ~= 0 then
    	strnum = strnum + 1
  	end
  end
  
  local function ThingAddAttrib(s)
    if JY.Thing[id]["加" .. s] ~= 0 then
      addvalue, str[strnum] = AddPersonAttrib(personid, s, JY.Thing[id]["加" .. s])
      if addvalue ~= 0 then
      	strnum = strnum + 1
    	end
    	
    	--蓝烟清：显示体力，内力点数
    	if JY.Status == GAME_WMAP then
  			if s == "体力" then
  				WAR.Person[WAR.CurID]["体力点数"] = addvalue;
  			elseif s == "内力" then
  				WAR.Person[WAR.CurID]["内力点数"] = addvalue;
  			end
  		end
    end
    
  end
  
  
  ThingAddAttrib("生命最大值")
  
  if JY.Thing[id]["加中毒解毒"] < 0 then
    addvalue, str[strnum] = AddPersonAttrib(personid, "中毒程度", math.modf(JY.Thing[id]["加中毒解毒"] / 2))
  	if addvalue ~= 0 then
    	strnum = strnum + 1
 		end
 		
 		--蓝烟清：显示中解毒点数
    if JY.Status == GAME_WMAP then
	 		if addvalue < 0 then
	 			WAR.Person[WAR.CurID]["解毒点数"] = -addvalue;
	 		elseif addvalue > 0 then
	 			WAR.Person[WAR.CurID]["中毒点数"] = addvalue;
	 		end
	 	end
  end
  
  ThingAddAttrib("体力")
  
  if JY.Thing[id]["改变内力性质"] == 2 then
    str[strnum] = "内力门路改为阴阳合一"
    strnum = strnum + 1
  end

  ThingAddAttrib("内力")
  ThingAddAttrib("内力最大值")
  ThingAddAttrib("攻击力")
  ThingAddAttrib("防御力")
  ThingAddAttrib("轻功")
  ThingAddAttrib("医疗能力")
  ThingAddAttrib("用毒能力")
  ThingAddAttrib("解毒能力")
  ThingAddAttrib("抗毒能力")
  ThingAddAttrib("拳掌功夫")
  ThingAddAttrib("御剑能力")
  ThingAddAttrib("耍刀技巧")
  ThingAddAttrib("特殊兵器")
  ThingAddAttrib("暗器技巧")
  ThingAddAttrib("武学常识")
  ThingAddAttrib("攻击带毒")
  
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
	  
	  	--显示使用物品文字
	  	DrawString(CC.MainMenuX, CC.ScreenH-(strnum+2)*CC.Fontsmall, JY.Person[WAR.Person[WAR.CurID]["人物编号"]]["姓名"].." "..str[0], C_WHITE, CC.Fontsmall);
	  	for i=1, strnum-1 do 
	  		DrawString(CC.MainMenuX, CC.ScreenH + (i-strnum-2)*CC.Fontsmall, str[i], C_WHITE, CC.Fontsmall);
	  	end
	  	
	  	ShowScreen()
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

--计算医疗量
--id1 医疗id2, 返回id2生命增加点数
function ExecDoctor(id1, id2)
  if JY.Person[id1]["体力"] < 50 then
    return 0
  end
  local add = JY.Person[id1]["医疗能力"]
  local value = JY.Person[id2]["受伤程度"]
  if add + 20 < value then
    return 0
  end
  
  -- 平一指，医疗量和杀人数有关
  if id1 == 28 and JY.Status == GAME_WMAP then
    add = math.modf(JY.Person[id1]["医疗能力"] * (1 + WAR.PYZ / 10))
  end
  
  --战斗状态的医疗
  --程灵素对胡斐有额外120点，胡青牛和王难姑互加额外50
  if JY.Status == GAME_WMAP then
    for i,v in pairs(CC.AddDoc) do
      if v[1] == id1 then
        for wid = 0, WAR.PersonNum - 1 do
          if WAR.Person[wid]["人物编号"] == v[2] and WAR.Person[wid]["死亡"] == false then
            add = add + v[3]
          end
        end
      end
    end
  end
  
  add = add - (add) * value / 200
  add = math.modf(add) + Rnd(5)
  
  local n = AddPersonAttrib(id2, "受伤程度", -math.modf((add) / 10))
  --蓝烟清：医疗时显示内伤减少
  if JY.Status == GAME_WMAP then
	  local p = -1;
	  for wid = 0, WAR.PersonNum - 1 do
	    if WAR.Person[wid]["人物编号"] == id2 and WAR.Person[wid]["死亡"] == false then
	      p = wid;
	      break;
	    end
	  end
	  WAR.Person[p]["内伤点数"] = n;
	end
  
  
  return AddPersonAttrib(id2, "生命", add)
end


--基础机率
function baseRandom(p)
	local jl = 0;

	--王语嫣+10点
	for i = 0, WAR.PersonNum - 1 do
    local pid = WAR.Person[i]["人物编号"]
    if WAR.Person[i]["死亡"] == false and WAR.Person[i]["我方"] and pid == 76 and inteam(p) then
      jl = jl + 10	
    end
  end

	--内力值最多+10点
	jl = jl + limitX(math.modf(JY.Person[p]["内力"] / 800), 0, 12);
	
	--生命值最多+20点
	jl = jl + math.modf(JY.Person[p]["生命最大值"] * 2 / (JY.Person[p]["生命"] + 100))
	
	--实战加成
  --满实战+20点
  
  local jp = math.modf(GetSZ(p) / 25 + 1)
  if jp > 20 then
    jp = 20
  end
  jl = jl + jp

 
  
  --石破天+10点
  if p == 38 then
    jl = jl + 10
  end
  
  for i = 1, 10 do
    if JY.Person[p]["武功" .. i] == 102 then
      jl = jl + (math.modf(JY.Person[p]["武功等级" .. i] / 100) + 1)     --太玄神功+10点
      break;
    end
  end
  
  --新逆运增加机率
  if WAR.L_NYZH[p] ~= nil then
  	jl = jl + 20;
  end
  
  if not inteam(p) then		--敌人额外的机率
  	jl = jl + 10;
  end
  
  return jl;
end

--根据人物的攻击力计算机率
--jl 初始机率
--p 人物编号
function atkRandom(jl, p)
	
	local atk = JY.Person[p]["攻击力"];
	--队友攻击力加成
  for i,v in pairs(CC.AddAtk) do
    if v[1] == p then
      for wid = 0, WAR.PersonNum - 1 do
        if WAR.Person[wid]["人物编号"] == v[2] and WAR.Person[wid]["死亡"] == false then
          atk = atk + v[3]
        end
      end
    end
  end
	
	--装备攻击加成
	if JY.Person[p]["武器"] >= 0 then
  	atk = JY.Thing[JY.Person[p]["武器"]]["加攻击力"];
  end
  if JY.Person[p]["防具"] >= 0 then
    atk = JY.Thing[JY.Person[p]["防具"]]["加攻击力"];
  end
  
  --攻击力加成机率
  jl = jl + limitX(math.modf(atk / 15), 0, 40);
  
  --计算额外的基础机率
  jl = jl + baseRandom(p);
  
  
  
  
  
  return jl > math.random(110);
end


--根据人物的防御力计算机率
--jl 初始机率
--p 人物编号
function defRandom(jl, p)
	
	local def = JY.Person[p]["防御力"];
	--队友防御力加成
  for i,v in pairs(CC.AddDef) do
    if v[1] == p then
      for wid = 0, WAR.PersonNum - 1 do
        if WAR.Person[wid]["人物编号"] == v[2] and WAR.Person[wid]["死亡"] == false then
          def = def + v[3]
        end
      end
    end
  end
	
	--装备防御加成
	if JY.Person[p]["武器"] >= 0 then
  	def = JY.Thing[JY.Person[p]["武器"]]["加防御力"];
  end
  if JY.Person[p]["防具"] >= 0 then
    def = JY.Thing[JY.Person[p]["防具"]]["加防御力"];
  end
  
  --防御力加成机率
  jl = jl + limitX(math.modf(def / 12), 0, 40);
  
  --计算额外的基础机率
  jl = jl + baseRandom(p);
  
  return jl > math.random(100);
end
	
--根据人物的轻功计算机率
--jl 初始机率
--p 人物编号
function spdRandom(jl, p)
	
	local spd = JY.Person[p]["轻功"];
	--队友轻功加成
  for i,v in pairs(CC.AddSpd) do
    if v[1] == p then
      for wid = 0, WAR.PersonNum - 1 do
        if WAR.Person[wid]["人物编号"] == v[2] and WAR.Person[wid]["死亡"] == false then
          spd = spd + v[3]
        end
      end
    end
  end
	
	--装备轻功加成
	if JY.Person[p]["武器"] >= 0 then
  	spd = JY.Thing[JY.Person[p]["武器"]]["加轻功"];
  end
  if JY.Person[p]["防具"] >= 0 then
    spd = JY.Thing[JY.Person[p]["防具"]]["加轻功"];
  end
  
  --轻功加成机率
  jl = jl + limitX(math.modf(spd / 15), 0, 40);
  
  --计算额外的基础机率
  jl = jl + baseRandom(p);
  
  return jl > math.random(110);
end

--根据人物的攻击力、防御力计算机率
--jl 初始机率
--p 人物编号
--根据人物的防御力计算机率
--jl 初始机率
--p 人物编号
function atkdefRandom(jl, p)

	local atk = JY.Person[p]["攻击力"];
	--队友攻击力加成
  for i,v in pairs(CC.AddAtk) do
    if v[1] == p then
      for wid = 0, WAR.PersonNum - 1 do
        if WAR.Person[wid]["人物编号"] == v[2] and WAR.Person[wid]["死亡"] == false then
          atk = atk + v[3]
        end
      end
    end
  end
	
	--装备攻击加成
	if JY.Person[p]["武器"] >= 0 then
  	atk = JY.Thing[JY.Person[p]["武器"]]["加攻击力"];
  end
  if JY.Person[p]["防具"] >= 0 then
    atk = JY.Thing[JY.Person[p]["防具"]]["加攻击力"];
  end
  
  --攻击力加成机率
  local jl1 =  limitX(math.modf(atk / 15), 0, 40);
	
	local def = JY.Person[p]["防御力"];
	--队友防御力加成
  for i,v in pairs(CC.AddDef) do
    if v[1] == p then
      for wid = 0, WAR.PersonNum - 1 do
        if WAR.Person[wid]["人物编号"] == v[2] and WAR.Person[wid]["死亡"] == false then
          def = def + v[3]
        end
      end
    end
  end
	
	--装备防御加成
	if JY.Person[p]["武器"] >= 0 then
  	def = JY.Thing[JY.Person[p]["武器"]]["加防御力"];
  end
  if JY.Person[p]["防具"] >= 0 then
    def = JY.Thing[JY.Person[p]["防具"]]["加防御力"];
  end
  
  --防御力加成机率
  local jl2 = limitX(math.modf(def / 15), 0, 40);
  
  --计算机率
  jl = jl + math.modf((jl1+jl2)/2) + baseRandom(p);
  
  return jl > math.random(110);
end


--计算武功伤害
function War_WugongHurtLife(enemyid, wugong, level, ang, x, y)

  local pid = WAR.Person[WAR.CurID]["人物编号"]
  local eid = WAR.Person[enemyid]["人物编号"]
  local dng = 0
  local WGLX = JY.Wugong[wugong]["武功类型"]
  
  --是否为自己人
  local function DWPD()
    if WAR.Person[enemyid]["我方"] ~= WAR.Person[WAR.CurID]["我方"] then
      return true
    else
      return false
    end
  end
  
  local mywuxue = 0
  local emenywuxue = 0
  for i = 0, WAR.PersonNum - 1 do
    local id = WAR.Person[i]["人物编号"]
    
    --武学常识共用....
    if WAR.Person[i]["死亡"] == false and JY.Person[id]["武学常识"] > 10 then
      if WAR.Person[WAR.CurID]["我方"] == WAR.Person[i]["我方"] and mywuxue < JY.Person[id]["武学常识"] then
        mywuxue = JY.Person[id]["武学常识"]
      end
      if WAR.Person[enemyid]["我方"] == WAR.Person[i]["我方"] and emenywuxue < JY.Person[id]["武学常识"] then
      	emenywuxue = JY.Person[id]["武学常识"]
    	end
    end
    
    if emenywuxue < 50 then
      emenywuxue = 50
    end
  end
  
  --计算实际使用武功等级
  while true do
  	if JY.Person[pid]["内力"] < math.modf((level + 1) / 2) * JY.Wugong[wugong]["消耗内力点数"] then
   		level = level - 1
  	else
  		break;
  	end
  end

	--防止出现左右互博时第一次攻击完毕，第二次攻击没有内力的情况。
	if level <= 0 then
	  level = 1
	end
	
	
	
	--蓝烟清：新内功护体触发
	local ht = {};		
	local num = 0;	--当前学了多少个防护内功
	for i = 1, 10 do
		local kfid = JY.Person[eid]["武功" .. i]
		
		--蛤蟆功、乾坤大挪移、八荒六合功， 优先高机率触发防护
		if (kfid == 95 or kfid == 97 or kfid == 101) and WAR.Person[enemyid]["我方"] ~= WAR.Person[WAR.CurID]["我方"] then
			num = num + 1;
			ht[num] = {kfid,i};
		end
	end
	
	--防护内功优先发动
	if num > 0 then
		--仁者有额外15%的机率触发防护内功防护
		if defRandom(30, eid) or  (eid == 0 and GetS(4, 5, 5, 5) == 6 and JLSD(50, 75, 0)) then
			local n = math.random(num);
			local kfid = ht[n][1];
		
			local lv = math.modf(JY.Person[eid]["武功等级" .. ht[n][2]] / 100) + 1
			local wl = JY.Wugong[kfid]["攻击力" .. lv];
			dng = wl;
			WAR.Person[enemyid]["特效文字2"] = JY.Wugong[kfid]["名称"] .. "防护"
	  	WAR.Person[enemyid]["特效动画"] = math.fmod(kfid, 10) + 85
	  	WAR.NGHT = kfid;
		end
	end
	
	--如果没有触发内功防护则重新判断普通内功护体
	if WAR.NGHT == 0 then
		for i = 1, 10 do
			local kfid = JY.Person[eid]["武功" .. i]
			--蛤蟆功、乾坤大挪移、八荒六合功、易筋经、葵花神功、太玄神功、九阳神功（阳内或天罡），不触发护体
			if kfid > 88 and kfid < 109 and kfid ~= 97 and kfid ~= 95 and kfid ~= 101 and kfid ~= 108 and kfid ~= 107 and kfid ~= 106 and kfid ~= 105 and kfid ~= 102 and WAR.Person[enemyid]["我方"] ~= WAR.Person[WAR.CurID]["我方"] then
				
					if defRandom(30, eid) or (eid == 0 and GetS(4, 5, 5, 5) == 6 and JLSD(50, 75, 0)) then
						
						local lv = math.modf(JY.Person[eid]["武功等级" .. i] / 100) + 1
						local wl = JY.Wugong[kfid]["攻击力" .. lv]
						if dng < wl then
							dng = wl;
							WAR.Person[enemyid]["特效文字2"] = JY.Wugong[kfid]["名称"] .. "护体"
				  		WAR.Person[enemyid]["特效动画"] = math.fmod(kfid, 10) + 85
				  		WAR.NGHT = kfid;
						end
					end
			end
		end
	end
	
	--神功护体，额外护体
	ht = {};		
	num = 0;	--当前学了多少神功
	for i = 1, 10 do
		local kfid = JY.Person[eid]["武功" .. i]
		
		--易筋经、太玄神功、葵花神功、九阳神功（阳内或天罡）
		if (kfid == 108 or kfid == 102 or kfid == 105 or (kfid == 106 and (JY.Person[eid]["内力性质"] == 1 or  (eid == 0 and GetS(4, 5, 5, 5) == 5)))) and WAR.Person[enemyid]["我方"] ~= WAR.Person[WAR.CurID]["我方"] then
			num = num + 1;
			ht[num] = {kfid,i};
		end
	end
	
	--如果学有神功
	if num > 0 then

		local n = math.random(num);
		local kfid = ht[n][1];
		local lv = math.modf(JY.Person[eid]["武功等级" .. ht[n][2]] / 100) + 1
		local wl = JY.Wugong[kfid]["攻击力" .. lv]
		
		--易筋经神功护体，额外增加气防
		if kfid == 108 and atkdefRandom(30,eid) then
			dng = dng + math.modf(wl/2) + 1000;	--增加气防
			WAR.L_SGHT = kfid;
			if WAR.Person[enemyid]["特效文字1"] ~= nil then
				WAR.Person[enemyid]["特效文字1"] = WAR.Person[enemyid]["特效文字1"] .."+易筋经神功护体";
			else
				WAR.Person[enemyid]["特效文字1"] = JY.Wugong[kfid]["名称"] .. "神功护体";
			end
			WAR.Person[enemyid]["特效动画"] = 79

		--太玄神功，有机率把杀集气转为集气值
		elseif kfid == 102 and (JLSD(30,70,eid) or (eid == 38 and  JLSD(40,60,eid))) then
			WAR.L_SGHT = kfid;
			if WAR.Person[enemyid]["特效文字1"] ~= nil then
				WAR.Person[enemyid]["特效文字1"] = WAR.Person[enemyid]["特效文字1"] .."+太玄神功护体";
			else
				WAR.Person[enemyid]["特效文字1"] = "太玄神功护体";
			end
			WAR.Person[enemyid]["特效动画"] = 63
		
		--葵花神功，有机率发动葵花移形，林平之有额外几率，除东方之外
		elseif kfid == 105 and (JLSD(30,55,eid) or (eid == 36 and  JLSD(40,60,eid))) and eid ~= 27 then
			WAR.L_SGHT = kfid;
			if WAR.Person[enemyid]["特效文字1"] ~= nil then
				WAR.Person[enemyid]["特效文字1"] = WAR.Person[enemyid]["特效文字1"] .."+葵花移形";
			else
				WAR.Person[enemyid]["特效文字1"] = "葵花移形";
			end
		
		--九阳神功，额外减少40%的伤害，阴内或者天罡有效
		elseif (kfid == 106 and defRandom(30, eid)) then
			WAR.L_SGHT = kfid;
			dng = dng + 1000;
			if WAR.Person[enemyid]["特效文字1"] ~= nil then
				WAR.Person[enemyid]["特效文字1"] = WAR.Person[enemyid]["特效文字1"] .."+九阳神功护体";
			else
				WAR.Person[enemyid]["特效文字1"] = "九阳神功护体";
			end
			WAR.Person[enemyid]["特效动画"] = 7
		end

	end
	
	--防御状态
	if WAR.Defup[eid] == 1 then
	  if WAR.Person[enemyid]["特效文字3"] ~= nil then
	    WAR.Person[enemyid]["特效文字3"] = WAR.Person[enemyid]["特效文字3"] .. "+防御状态"
	  else
	    WAR.Person[enemyid]["特效文字3"] = "防御状态"
	  end
	  if PersonKF(eid, 101) then     --八六气防+1000
	    dng = dng + 1000
		else
	  	dng = dng + 500
	  end
	end
	
	
	--觉醒之力
  --身世选择不知道
  --概率平均
  --仁者增加机率，因为仁者没有大招比较弱
  if eid==JY.MY and GetS(53, 0, 2, 5) == 1 and GetS(53, 0, 3, 5) == 1  then
  	local rate = limitX(math.modf(JY.Person[eid]["声望"]/5 + (100-JY.Person[eid]["资质"])/10 + GetSZ(eid)/50 + JY.Person[eid]["防御力"]/40 + JY.Person[eid]["武学常识"]/10),0,100);
  	local low = 25;
  	
  	--十本书觉醒，增加机率
  	if GetS(53, 0, 4, 5) == 1 then
  		low = 15;
  	end
  	
  	local t = 0;
  	if JLSD(low, rate, eid) or (GetS(4, 5, 5, 5) == 6 and JLSD(low/3, rate/2, eid)) then
  		t = math.random(3)
  	end
  	
  	if t == 1 then
  		WAR.Person[enemyid]["特效动画"] = 6
	    if WAR.Person[enemyid]["特效文字2"] ~= nil then
	    	WAR.Person[enemyid]["特效文字2"] = WAR.Person[enemyid]["特效文字2"] .."+"..FLHSYL[2]
	    else
	    	WAR.Person[enemyid]["特效文字2"] = FLHSYL[2]		--其徐如林
	    end
	    WAR.FLHS2 = WAR.FLHS2 + 2
  	elseif t == 2 then
  		WAR.Person[enemyid]["特效动画"] = 6
		  if WAR.Person[enemyid]["特效文字2"] ~= nil then
	    	WAR.Person[enemyid]["特效文字2"] = WAR.Person[enemyid]["特效文字2"] .."+"..FLHSYL[4]		--不动如山
	    else
	    	WAR.Person[enemyid]["特效文字2"] = FLHSYL[4]		--不动如山
	    end
		  WAR.FLHS4 = 1
  	elseif t == 3 and WAR.Person[enemyid]["我方"] ~= WAR.Person[WAR.CurID]["我方"] then
  		WAR.Person[enemyid]["特效动画"] = 6
	    if WAR.Person[enemyid]["特效文字2"] ~= nil then
	    	WAR.Person[enemyid]["特效文字2"] = WAR.Person[enemyid]["特效文字2"] .."+"..FLHSYL[5]		--难知如阴
	    else
	    	WAR.Person[enemyid]["特效文字2"] = FLHSYL[5]		--难知如阴
	    end
	    WAR.ACT = 10
	    WAR.ZYHB = 0
	    WAR.FLHS5 = 1
  	end
  end
	
	--张无忌 九阳神功护体
	if eid == 9 and WAR.Person[enemyid]["特效文字2"] == nil and PersonKF(9, 106) then
	  WAR.Person[enemyid]["特效动画"] = math.fmod(106, 10) + 85
	  WAR.Person[enemyid]["特效文字2"] = "九阳神功护体"
	  dng = dng + 1000
	end
	
	--乔峰 擒龙功护体
	if eid == 50 and WAR.Person[enemyid]["特效文字2"] == nil then
	  WAR.Person[enemyid]["特效动画"] = 53
	  WAR.Person[enemyid]["特效文字2"] = "擒龙功护体"
	  dng = dng + 1500
	end
	
	--鸠摩智  小无相功护体
	if eid == 103 then
	  WAR.Person[enemyid]["特效动画"] = math.fmod(98, 10) + 85
	  WAR.Person[enemyid]["特效文字2"] = "小无相功护体"
	  dng = dng + 1000
	end
	
	--成崑 混元霹雳功护体
	if eid == 18 then
	  WAR.Person[enemyid]["特效文字2"] = "混元霹雳功护体"
	  WAR.Person[enemyid]["特效动画"] = math.fmod(106, 10) + 85
	  dng = dng + 1200
	end
	
	--brolycjw: 周伯通
    if eid == 64 then
      WAR.Person[enemyid]["特效动画"] = 66
      WAR.Person[enemyid]["特效文字2"] = "九阴神功护体"
      dng = dng + 1500
    end
	
	--brolycjw: 洪七公
    if eid == 69 and WAR.ZDDH ~= 188 then
      WAR.Person[enemyid]["特效动画"] = 67
      WAR.Person[enemyid]["特效文字2"] = "九阴真气"
      dng = dng + 1500
    end
 
	--brolycjw: 黄药师
    if eid == 57 then
      WAR.Person[enemyid]["特效动画"] = 95
      WAR.Person[enemyid]["特效文字2"] = "奇门奥义"
      dng = dng + 1500
    end
	
	--brolycjw: 谢烟客
    if eid == 164 then
      WAR.Person[enemyid]["特效动画"] = 23
      WAR.Person[enemyid]["特效文字2"] = "摩天居士"
      dng = dng + 1500
    end
	
		--brolycjw: 独孤求败
    if pid == 592 then
		if WAR.L_DGQB_X < 3 then
			dng = dng + 1200
		elseif WAR.L_DGQB_X < 5 then
			dng = dng + 1400		
		elseif WAR.L_DGQB_X < 7 then
			dng = dng + 1600	
		elseif WAR.L_DGQB_X < 9 then
			dng = dng + 1800				
		else
			dng = dng + 2000		
		end
    end
	
	--任我行  日月·同辉
	if eid == 26 then
	  WAR.Person[enemyid]["特效动画"] = 6
	  WAR.Person[enemyid]["特效文字2"] = "日月·同辉"
	  dng = dng + 1200
	end
	
	--北冥神功
	if (PersonKF(eid, 85) or T1LEQ(eid)) and JLSD(30, 70, eid) or eid == 118 then
	  if WAR.Person[enemyid]["特效动画"] == -1 then
	    WAR.Person[enemyid]["特效动画"] = 85
	  end
	  if WAR.Person[enemyid]["特效文字2"] == nil then
	    WAR.Person[enemyid]["特效文字2"] = "北冥真气"
	  else
	    WAR.Person[enemyid]["特效文字2"] = WAR.Person[enemyid]["特效文字2"] .. "+" .. "北冥真气"
	    dng = dng + 800
	  end
	  WAR.B_BMJQ = 1;
	end
	
	--斗转星移
  for i = 1, 10 do
    local kfid = JY.Person[eid]["武功" .. i]
    if kfid == 43 and JY.Person[eid]["体力"] > 10 and WAR.Person[enemyid]["反击武功"] == -1 and WAR.Person[enemyid]["我方"] ~= WAR.Person[WAR.CurID]["我方"] and ((not JLSD(30, 70, eid)) or (eid == 51 and JLSD(20, 80, eid)) or (WAR.tmp[1000 + eid] == 1 and JLSD(30, 70, eid))) then
      local p = JY.Person[eid]
      local dzlv = p["拳掌功夫"] + p["御剑能力"] + p["耍刀技巧"] + p["特殊兵器"]
      local dzwz = nil
      if dzlv >= 300 or eid == 51 then      
        dzwz = "离合参商"			--离合参商
        WAR.DZXYLV[eid] = 3
      elseif dzlv >= 220 then
        dzwz = "斗转星移"			--斗转星移
        WAR.DZXYLV[eid] = 2
      else
        dzwz = "北斗移辰"			--北斗移辰
        WAR.DZXYLV[eid] = 1
      end
      if WAR.Person[enemyid]["特效文字2"] ~= nil then
        WAR.Person[enemyid]["特效文字2"] = WAR.Person[enemyid]["特效文字2"] .. "+" .. dzwz
      else
        WAR.Person[enemyid]["特效文字2"] = dzwz
      end
      if WAR.Person[enemyid]["特效动画"] == nil then
        WAR.Person[enemyid]["特效动画"] = math.fmod(kfid, 10) + 85
      end
      WAR.Person[enemyid]["反击武功"] = wugong
      JY.Person[eid]["体力"] = JY.Person[eid]["体力"] - 3
      break;
    end
  end
  
  --计算受到的伤害
  local hurt = nil
  if level > 10 then
    hurt = JY.Wugong[wugong]["攻击力" .. 10] / 3
    level = 10
  else
    hurt = JY.Wugong[wugong]["攻击力" .. level] / 4
  end
  
  
  --刀系用玄虚刀法，提高伤害(刀二十）
  if wugong == 64 and pid == 0 and GetS(4, 5, 5, 5) == 3 then
    hurt = hurt + math.modf(GetS(14, 3, 1, 4) / 3 + 1)
  end
  
  --武器装备伤害加成
  for i,v in ipairs(CC.ExtraOffense) do
    if v[1] == JY.Person[pid]["武器"] and v[2] == wugong then
      hurt = hurt + v[3] / 4
    end
  end
  
  --太极拳，借力打力
  if wugong == 16 and WAR.tmp[3000 + pid] ~= nil and WAR.tmp[3000 + pid] > 0 then
    if WAR.tmp[3000 + pid] > 200 then
      WAR.tmp[3000 + pid] = 200
    end
    hurt = hurt + WAR.tmp[3000 + pid]
    WAR.tmp[3000 + pid] = 0
  end
  
  --
  local atk = JY.Person[pid]["攻击力"]
  local def = JY.Person[eid]["防御力"]
  if JY.Status == GAME_WMAP then
  
  	--队友攻击力加成
    for i,v in pairs(CC.AddAtk) do
      if v[1] == pid then
        for wid = 0, WAR.PersonNum - 1 do
          if WAR.Person[wid]["人物编号"] == v[2] and WAR.Person[wid]["死亡"] == false then
            atk = atk + v[3]
          end
        end
      end
    end
    
    --队友防御力加成
    for i,v in pairs(CC.AddDef) do
      if v[1] == eid then
        for wid = 0, WAR.PersonNum - 1 do
          if WAR.Person[wid]["人物编号"] == v[2] and WAR.Person[wid]["死亡"] == false then
            def = def + v[3]
          end
        end
      end
    end
  end
  
  local function getnl(id)
    return (JY.Person[id]["内力"] * 2 + JY.Person[id]["内力最大值"]) / 3
  end
  
  local t = nil
  if inteam(pid) then
    t = 1
  else
    hurt = (hurt) * 1.2 + 30
    if GetS(0, 0, 0, 0) ~= 1 then
      t = 1.5
  	else
    	t = 2
    end
  end
  
  --蓝烟清：如果使用的不是雷震剑法，释放雷震剑法的加成
  if wugong ~= 28 and WAR.L_LZJF_ATK[pid] ~= nil then
  	atk = atk + WAR.L_LZJF_ATK[pid];
  	WAR.L_LZJF_ATK[pid] = nil;
  elseif WAR.L_LZJF_ATK[pid] ~= nil then
  	atk = atk + WAR.L_LZJF_ATK[pid];
  end
  
  atk = atk + t * getnl(pid) / 50
  hurt = hurt + (atk) / 4
  if inteam(pid) then
    hurt = hurt + (mywuxue - emenywuxue) / 2
  else
    hurt = hurt + (mywuxue - emenywuxue) / 2
  end
  
  
  
  def = def + 1.2 * getnl(eid) / 40 + emenywuxue
  atk = atk + mywuxue + ang / 10
  hurt = (hurt) * (atk) / (atk + (def))
  if inteam(pid) == false and WAR.tmp[200 + pid] ~= nil then
    hurt = hurt + WAR.tmp[200 + pid] / 2
  end
  
  local function myrnd(x)
    if x <= 1 then
      return 0
    end
    return math.random(x * 0.5, x)
  end
  
  --防具伤害计算
  if JY.Person[pid]["武器"] >= 0 then
    hurt = hurt + myrnd(JY.Thing[JY.Person[pid]["武器"]]["加攻击力"])
  end
  if JY.Person[pid]["防具"] >= 0 then
    hurt = hurt + myrnd(JY.Thing[JY.Person[pid]["防具"]]["加攻击力"])
  end
  if JY.Person[eid]["武器"] >= 0 then
    hurt = hurt - myrnd(JY.Thing[JY.Person[eid]["武器"]]["加防御力"])
  end
  if JY.Person[eid]["防具"] >= 0 then
    hurt = hurt - myrnd(JY.Thing[JY.Person[eid]["防具"]]["加防御力"])
  end
  
  --防御力，气防伤害计算
  hurt = hurt - (def) / 12
  hurt = hurt - (dng) / 30 + JY.Person[pid]["体力"] / 5 - JY.Person[eid]["体力"] / 5 + JY.Person[eid]["受伤程度"] / 3 - JY.Person[pid]["受伤程度"] / 3 + JY.Person[eid]["中毒程度"] / 2 - JY.Person[pid]["中毒程度"] / 2
  
  --距离伤害计算
  if inteam(pid) then
    local offset = math.abs(WAR.Person[WAR.CurID]["坐标X"] - WAR.Person[enemyid]["坐标X"]) + math.abs(WAR.Person[WAR.CurID]["坐标Y"] - WAR.Person[enemyid]["坐标Y"])
    if offset < 10 then
      hurt = (hurt) * (100 - (offset - 1) * 3) / 100
    end
  else
    hurt = hurt * 2 / 3
  end
  
  --暴击
  if WAR.BJ == 1 then
    local SLWX = 0
    for i = 1, 10 do
      if JY.Person[eid]["武功" .. i] == 106 or JY.Person[eid]["武功" .. i] == 107 then
        SLWX = SLWX + 1
      end
    end
    
    if JY.Person[eid]["内力性质"] == 2 or eid == 0 and GetS(4, 5, 5, 5) == 5 then
      SLWX = SLWX + 1
    end
    if SLWX == 3 then
      WAR.Person[enemyid]["特效动画"] = 6
      if WAR.Person[enemyid]["特效文字2"] ~= nil then
        WAR.Person[enemyid]["特效文字2"] = WAR.Person[enemyid]["特效文字2"] .. "+森罗万象"    --森罗万象
	    else
	      WAR.Person[enemyid]["特效文字2"] = "森罗万象"
	    end
    --岳老三 暴击伤害加倍
    elseif pid == 44 or pid == 98 or pid == 99 or pid == 100 then
    	hurt = hurt * 2
	  else
	    hurt = math.modf(hurt * 1.5)
	  end
  end
  
  --蓝烟清：南山刀法，伤害加成
  if WAR.L_NSDF[eid] ~= nil then
  	hurt = hurt * 2;
  	ang = ang * 2;
  	WAR.L_NSDF[eid] = nil;
  end

	--蓝烟清：南山刀法命中
	if WAR.L_NSDFCC == 1 and DWPD() then
		WAR.L_NSDF[eid] = 1;
	end 
	
	--蓝烟清：燃木刀法，普通内功加力额外增加伤害
	if wugong == 65 and WAR.NGJL > 0 then
		hurt  = hurt + math.modf(JY.Wugong[WAR.NGJL]["攻击力10"]/12);
	end
  

  --乔峰
  if pid == 50 then
    hurt = math.modf(hurt * 1.5)
  end
  
  --谢逊
  if eid == 13 then
    hurt = math.modf(hurt * 0.6)
  end
  
  --狄云
  if pid == 37 and JY.Person[0]["品德"] > 70 then
    hurt = math.modf((1 + (JY.Person[0]["品德"] - 70) / 100) * hurt)
  end
  
  --程英
  if pid == 63 and JY.Person[pid]["生命"] < math.modf(JY.Person[pid]["生命最大值"] / 2) then
    hurt = math.modf(hurt * 1.2)
  end
  
  --brolycjw: 龙岛主
  if pid == 39 then
    hurt = math.modf(hurt * 1.2)
  end
  
 --brolycjw: 木岛主
  if eid == 40 then
    hurt = math.modf(hurt * 0.8)
  end
  
  --刀剑合壁
  if WAR.DJGZ == 1 then
    hurt = math.modf(hurt * 1.3)
  end
  
  --梅超风攻击
  if WAR.MCF == 1 then
    hurt = math.modf(hurt * 2)
  end
  
  --蓝凤凰，何铁手，攻击
  if WAR.TFH == 1 then
    hurt = math.modf(hurt * 1.2)
  end
  
  --温青青，使用雷震剑法
  if WAR.WQQ == 1 then
    hurt = math.modf(hurt * (1 + math.random(200) / 100))
  end
  
  --周伯通
  if pid == 64 then
    hurt = math.modf(hurt * (1 + WAR.ZBT / 10))
  end
  
  --拳系大招
  if WAR.LXZQ == 1 then
    hurt = math.modf(hurt * 1.3)
  end
  
  --宋青书 有女的攻击加成
  if pid == 82 then
    local s = 0
    for j = 0, WAR.PersonNum - 1 do
      if WAR.Person[j]["死亡"] == false and WAR.Person[j]["我方"] == WAR.Person[WAR.CurID]["我方"] and JY.Person[WAR.Person[j]["人物编号"]]["性别"] == 1 then
        s = s + 1
      end
    end
    hurt = math.modf(hurt * (1 + (s) / 3))
  end
  
  
  --主角拳系，学拳法伤害加成
  if GetS(4, 5, 5, 5) == 1 and pid == 0 then
    local lxzq = 0
    for i = 1, 10 do
      if (JY.Person[0]["武功" .. i] == 109 or JY.Person[0]["武功" .. i] == 49 or (JY.Person[0]["武功" .. i] <= 26 and JY.Person[0]["武功" .. i] > 0)) and JY.Person[0]["武功等级" .. i] == 999 then
        lxzq = lxzq + 1
      end
    end
    hurt = math.modf(hurt * (1 + 0.05 * (lxzq)))
  end
  
  --主角刀系，防御加成
  if GetS(4, 5, 5, 5) == 3 and eid == 0 then
    local askd = 0
    for i = 1, 10 do
      if (JY.Person[0]["武功" .. i] == 111 or (JY.Person[0]["武功" .. i] <= 67 and JY.Person[0]["武功" .. i] >= 50)) and JY.Person[0]["武功等级" .. i] == 999 then
        askd = askd + 1
      end
    end
    hurt = math.modf(hurt * (1 - 0.05 * (askd)))
  end
  
  --武道大会，或者岳灵珊武功剑法加成
  if (WAR.ZDDH == 118 and pid ~= 5) or pid == 79 then
    local JF = 0
    for i = 1, 10 do
      if JY.Person[79]["武功" .. i] < 50 and JY.Person[79]["武功" .. i] > 26 and JY.Person[79]["武功等级" .. i] == 999 then
        JF = JF + 1
      end
    end
    hurt = math.modf(hurt * (1 + 0.05 * (JF)))
  end
  
  --苏荃和霍青桐 在战场时，伤害减少10%
  if not inteam(pid) then
    for j = 0, WAR.PersonNum - 1 do
      if (WAR.Person[j]["人物编号"] == 87 or WAR.Person[j]["人物编号"] == 74) and WAR.Person[j]["死亡"] == false and WAR.Person[j]["我方"] ~= WAR.Person[WAR.CurID]["我方"] then
        hurt = math.modf(hurt * 0.9)
      end
    end
  end
  
  --阿珂 已方攻击伤害提高10%
  if inteam(pid) then
    for j = 0, WAR.PersonNum - 1 do
      if (WAR.Person[j]["人物编号"] == 86 or WAR.Person[j]["人物编号"] == 80) and WAR.Person[j]["死亡"] == false and WAR.Person[j]["我方"] == WAR.Person[WAR.CurID]["我方"] then
        hurt = math.modf(hurt * 1.1)
      end
    end
  end
  
  --灭绝剑法，增加伤害
  --灭
  if WAR.L_MJJF == 1 then
  	hurt = hurt + 50;	
  	if JY.Person[pid]["武器"] == 37 then
  		hurt = hurt + 50;
  	end
  end
  
  
	--蓝烟清：被太玄加力攻击的敌人，攻击时消耗体力加倍
  if WAR.L_SGJL == 102 then
  	if WAR.Person[WAR.CurID]["我方"] ~= WAR.Person[enemyid]["我方"] then
  		WAR.L_TXSG[eid] = 1;
  	end
  end
  
  --蓝烟清：被阳性内力使用龙爪手攻击的敌人，下回合不可移动
  if wugong == 20 and JY.Person[pid]["内力性质"] == 1 and WAR.Person[WAR.CurID]["我方"] ~= WAR.Person[enemyid]["我方"] then
  	WAR.L_NOT_MOVE[eid] = 1;
  end
  
  --蓝烟清：被阴性内力使用鹰爪功攻击的敌人，下回合不可移动
  if wugong == 4 and JY.Person[pid]["内力性质"] == 0 and WAR.Person[WAR.CurID]["我方"] ~= WAR.Person[enemyid]["我方"] then
  	WAR.L_NOT_MOVE[eid] = 1;
  end
 
  --蓝烟清：紫霞神功使用剑系武功伤害加成
  if WAR.L_ZXSG == 2 then
  	hurt = math.modf(hurt*1.1);
  end
  
  --蓝烟清：田伯光，使用戒色指令后减少伤害和增加气防
  if eid == 29 and WAR.L_TBGZL == 2 then
  	if WAR.Person[enemyid]["特效文字2"] ~= nil then
  		WAR.Person[enemyid]["特效文字2"] = WAR.Person[enemyid]["特效文字2"] .. "·不可不戒"
  	else
  		WAR.Person[enemyid]["特效文字2"] = "不可不戒"
  	end
  	hurt = math.modf(hurt*0.9);
  	dng = dng + 500;
  end
  
  --冰糖恋：瓦尔拉齐称号特效  改为70%的机率上毒30点
  if pid == 138 then
    if JLSD(25, 95, 138) then
    	AddPersonAttrib(eid,"中毒程度", 30);
    	WAR.Person[WAR.CurID]["特效文字3"] = RWWH[138];  	
		end
  end
  
  --小日本 攻击伤害提高
  if WAR.BSMT == 1 then
    hurt = math.modf(hurt + 100 + math.random(50))
  end
  
  --斗转星移伤害和杀集气计算
  if WAR.DZXYLV[pid] ~= nil and WAR.DZXYLV[pid] > 10 then
    hurt = math.modf(hurt * WAR.DZXYLV[pid] / 100)
    ang = ang + WAR.DZXYLV[pid] * 10
  end
  
  --逆运走火
  if WAR.tmp[1000 + pid] == 1 and inteam(pid) then
    hurt = math.modf(hurt * 1.4)
  end
  
  --宗师，击退敌人
  if WAR.ZSJT == 1 and pid == JY.MY and GetS(53, 0, 2, 5) == 3 and WAR.Person[enemyid]["我方"] ~= WAR.Person[WAR.CurID]["我方"] and (JY.Person[pid]["内力"] > JY.Person[eid]["内力"] or math.random(100)>50) then
    local x1 = WAR.Person[enemyid]["坐标X"] - x
  	local y1 = WAR.Person[enemyid]["坐标Y"] - y
  	
  	local x2, y2 = WAR.Person[enemyid]["坐标X"], WAR.Person[enemyid]["坐标Y"];
    
    
		if x1 > 0 then
			x2 = WAR.Person[enemyid]["坐标X"] + 1
		elseif x1 < 0 then
			x2 = WAR.Person[enemyid]["坐标X"] - 1
		end
		
		if y1 > 0 then
			y2 = WAR.Person[enemyid]["坐标Y"] + 1
		elseif y1 < 0 then
			y2 = WAR.Person[enemyid]["坐标Y"] - 1
		end
    
    if War_CanMoveXY(x2, y2, 0) then
    	WAR.tmp[6000+enemyid] = {x2, y2};
    else
    	hurt = math.modf(hurt * 1.2)
    	ang = math.modf(ang * 1.5)
    end
    
  end
  
  
  if WAR.tmp[1000 + eid] == 1 and inteam(eid) then
    hurt = math.modf(hurt * 0.7)
  end
  

  --受内伤，攻击伤害减少
  if inteam(pid) then
    hurt = math.modf(hurt * (1 - JY.Person[pid]["受伤程度"] * 0.002))
  end
  
  --内伤，被攻击伤害提高
  if inteam(eid) then
    hurt = math.modf(hurt * (1 + JY.Person[pid]["受伤程度"] * 0.0015))
  end
  
  --张三丰
  if pid == 5 and WAR.ZDDH > 220 then
    hurt = math.modf(hurt * 1.1)
  end
  
  --张三丰，化朽为奇
  if WAR.ZSF2 == 1 then
    hurt = math.modf(hurt * 1.2)
  end
  
  --欧阳锋  队友伤害减少
  if pid == 60 and WAR.ZDDH == 171 then
    hurt = math.modf(hurt * 0.75)
  end
  
  --欧阳锋  敌人伤害提高
  if eid == 60 and WAR.ZDDH == 171 then
    hurt = math.modf(hurt * 1.2)
  end
  

  
  --三大圣使 圣火阵
  if WAR.ZDDH == 14 and (pid == 173 or pid == 174 or pid == 175) then
    local shz = 0
    for j = 0, WAR.PersonNum - 1 do
      if WAR.Person[j]["死亡"] == false and WAR.Person[j]["我方"] == WAR.Person[WAR.CurID]["我方"] then
        shz = shz + 1
      end
    end
    if shz == 3 then
    	hurt = math.modf(hurt * 1.5)
    	ang = ang + 1000
 		end
  end
  
  --波斯三圣使
  if WAR.ZDDH == 14 and (eid == 173 or eid == 174 or eid == 175) then
    local shz = 0
    for j = 0, WAR.PersonNum - 1 do
      if WAR.Person[j]["死亡"] == false and WAR.Person[j]["我方"] == WAR.Person[enemyid]["我方"] then
        shz = shz + 1
      end
    end
    if shz == 3 then
    	hurt = math.modf(hurt * 0.5)
    	dng = dng + 1000
  	end
  end
  
  
  --全真七子，天罡北斗阵，增加伤害和气攻
  if WAR.ZDDH == 73 then
    local num = 0
    for j = 0, WAR.PersonNum - 1 do
      if WAR.Person[j]["死亡"] == false and WAR.Person[j]["我方"] == WAR.Person[WAR.CurID]["我方"] and WAR.Person[WAR.CurID]["我方"] == false then
        num = num + 1
      end
    end
    for n=1, num do
    	hurt = math.modf(hurt * (1+0.04))
    	ang = ang + 100
    end
  end
  
  --全真七子，天罡北斗阵，减少伤害和增加气防
  if WAR.ZDDH == 73 then
    local num = 0
    for j = 0, WAR.PersonNum - 1 do
      if WAR.Person[j]["死亡"] == false and WAR.Person[j]["我方"] == WAR.Person[enemyid]["我方"] and WAR.Person[enemyid]["我方"] == false then
        num = num + 1
      end
    end
    for n=1, num do
    	hurt = math.modf(hurt * (1-0.03))
    	dng = dng + 100
    end
  end
  
  --霍都攻击
  if WAR.HDWZ == 1 then
    hurt = math.modf(hurt + 50)
    JY.Person[eid]["中毒程度"] = JY.Person[eid]["中毒程度"] + 15
	  if JY.Person[eid]["中毒程度"] > 100 then
	    JY.Person[eid]["中毒程度"] = 100
	  end
	end
	
	--扫地老僧 伤害减少40%
  if eid == 114 then
    hurt = math.modf(hurt * 0.7)
  end
  
  
  local defadd = 0
  local wgtype = JY.Wugong[wugong]["武功类型"];
  if wgtype == 5 then
    wgtype = math.random(4)
  end
  if wgtype == 1 then
    defadd = JY.Person[eid]["拳掌功夫"]
  elseif wgtype == 2 then
    defadd = JY.Person[eid]["御剑能力"]
  elseif wgtype == 3 then
    defadd = JY.Person[eid]["耍刀技巧"]
  elseif wgtype == 4 then
    defadd = JY.Person[eid]["特殊兵器"]
  end
  
  hurt = math.modf(hurt * limitX(1.2 - defadd / 240, 0.2, 1.2))
  if eid == 35 and GetS(10, 1, 1, 0) == 1 and JLSD(15, 85, eid) and WAR.Person[enemyid]["我方"] ~= WAR.Person[WAR.CurID]["我方"] then
    if JY.Wugong[wugong]["武功类型"] == 1 then
      WAR.Person[enemyid]["特效文字3"] = "秘传·破掌式"
    elseif JY.Wugong[wugong]["武功类型"] == 2 then
      WAR.Person[enemyid]["特效文字3"] = "秘传·破剑式"
    elseif JY.Wugong[wugong]["武功类型"] == 3 then
      WAR.Person[enemyid]["特效文字3"] = "秘传·破刀式"
    elseif JY.Wugong[wugong]["武功类型"] == 4 then
      WAR.Person[enemyid]["特效文字3"] = "秘传·破棍式"
    elseif JY.Wugong[wugong]["武功类型"] == 5 then
      WAR.Person[enemyid]["特效文字3"] = "秘传·破气式"
    end
    WAR.Person[enemyid]["特效动画"] = 83
    hurt = math.modf(hurt * (4 + math.random(3)) / 10)
  end
  
  --乔峰 受到伤害减少
  if eid == 50 then
    hurt = math.modf(hurt * 0.9)
    local minhurt = math.modf(hurt / 2)
    hurt = math.modf(hurt * JY.Person[eid]["生命"] / JY.Person[eid]["生命最大值"])
    if hurt < minhurt then
    	hurt = minhurt
  	end
  end
  
  --蓄力攻击
  if WAR.Actup[pid] ~= nil and WAR.DZXY ~= 1 then
    if PersonKF(pid, 103) then         --有龙象
      hurt = math.modf(hurt * 1.4)
    else
    	hurt = math.modf(hurt * 1.25)
    end
  end


	  
  	--brolycjw: 罗汉伏魔神功加力时杀气和伤害增加, 受当前内力和武功消耗内力影响
	if WAR.NGJL == 96 then
		local nlmod = JY.Person[pid]["内力"]/4000
		local wgmod = JY.Wugong[wugong]["消耗内力点数"]/200
		local totalmod = 1.1 + nlmod * wgmod;
		if pid == 38 then
			totalmod = totalmod * 1.2;
			ang = math.modf(ang * totalmod)
			hurt = math.modf(hurt * totalmod)
		else
			ang = math.modf(ang * totalmod)
			hurt = math.modf(hurt * totalmod)
		end
	end
	
	--蓝烟清：新逆运伤害提高30%
	if WAR.L_NYZH[pid] ~= nil then
		hurt = math.modf(hurt * 1.3);
	end
	
	--蓝烟清：新内功护体，防护内功
  --蛤蟆功防护，蛤蟆蓄力，额外气防+1000点
  if WAR.NGHT == 95 then
  	
  	if WAR.tmp[200 + eid] == nil or WAR.tmp[200 + eid] == 0 then
  		WAR.tmp[200 + eid] = 50;
  	else
  		WAR.tmp[200 + eid] = WAR.tmp[200 + eid] + 35;
  	end
  	
  	WAR.Person[enemyid]["特效文字2"] = WAR.Person[enemyid]["特效文字2"] .. "·蛤蟆蓄力";
  	dng = dng + 1000;
  	if WAR.tmp[200 + eid] >= 100 then
  		dng = dng + 1000;
  	end
  end
  

  --九阴神功加力，额外增加40%的伤害
  if WAR.L_SGJL == 107 then
  	hurt = math.modf(hurt*1.4);
  	ang = math.modf(ang * 1.3)
  end
	
	
  --防御状态
  if WAR.Defup[eid] == 1 then
    if PersonKF(eid, 101) then
      hurt = math.modf(hurt * 0.6)
    else
    	hurt = math.modf(hurt * 0.75)
    end
  end
  
  --龙象蓄力时，减少20%的伤害
  if WAR.Actup[eid] ~= nil and PersonKF(eid, 103) then
     hurt = math.modf(hurt * 0.8)
  end
  
  --蓝烟清：五岳剑法，增加伤害
  if WAR.L_WYJFA > 0 then
  	hurt = math.modf(hurt * 1.2)
  end
  
  --宗师：吉凶地加成
  local jxjc = GetWarMap(WAR.Person[enemyid]["坐标X"], WAR.Person[enemyid]["坐标Y"],6);
  if jxjc == 1 then		 --吉
  	hurt = math.modf(hurt * 0.8)
  	dng = math.modf(dng*1.2);
  elseif jxjc == 2 then		--凶
  	hurt = math.modf(hurt * 1.2)
  	ang = math.modf(ang * 1.2)
  elseif jxjc == 3 then		--大吉
  	hurt = math.modf(hurt * 0.5)
  	dng = math.modf(dng*1.5);
  elseif jxjc == 4 and WAR.Person[enemyid]["我方"] == false then		--大凶，我方不承受大凶
  	hurt = math.modf(hurt * 1.4)
  	ang = math.modf(ang * 1.4)
  end
  
  
  
  --宗师 觉醒后被攻击有机率转化吉凶地
	if GetS(53, 0, 2, 5) == 3 and GetS(53, 0, 4, 5) == 1 and jxjc ~= 3 and WAR.Person[enemyid]["我方"] and math.random(100)>50 then
		WAR.Person[enemyid]["特效文字2"] = "化险为夷";
		if math.random(10) > 3 then
			SetWarMap(WAR.Person[enemyid]["坐标X"], WAR.Person[enemyid]["坐标Y"],6, 1)
		else
			SetWarMap(WAR.Person[enemyid]["坐标X"], WAR.Person[enemyid]["坐标Y"],6, 3)
		end
	end
  
  
  --连击，伤害减少
  --连城剑法不减少
  if WAR.ACT > 1 and pid ~= 27 and wugong ~= 114 then
    hurt = math.modf(hurt * 0.7)
    ang = math.modf((ang) * 0.7)
  end
  
  
  local hurt2 = 0
  local hurt2js = 0
  --难度判断
  hurt2js = limitX(7-JY.Thing[202][WZ7],1)

  
  
  if inteam(pid) then
    hurt2 = math.modf(math.random(5) + (atk) / 7)
  else
    hurt2 = math.modf(math.random(20) + (atk) / hurt2js)
  end
    
  if not inteam(pid) then
    hurt2 = math.modf(hurt2 * 1.2)
  end
  if hurt < hurt2 then
    hurt = hurt2
  end
  
  --难度三下增加伤害
  if not inteam(pid) and JY.Thing[202][WZ7] > 2 then
    hurt = math.modf(hurt * (1 + JY.Thing[202][WZ7]/40))
  end
  
  --宗师：被攻击时，有机率发动防护特效
  if eid==JY.MY and GetS(53, 0, 2, 5) == 3 then 
  	local rate = 30 + JY.Person[eid]["声望"]/10 + JY.Person[eid]["武学常识"]/5 + GetSZ(eid)/100;
  	if GetS(53, 0, 4, 5) == 1 then
  		rate = rate + 10;
  	end
  	if rate > math.random(100) then
  		WAR.Person[enemyid]["特效动画"] = 90
  		
  		if GetS(53, 0, 4, 5) == 1 and math.random(100) > 40 then
  			WAR.Person[enemyid]["特效文字2"] = "真-以招拆招"
  			hurt = math.modf(hurt*(0.2 - Rnd(1)/10));
  			ang = math.modf(ang*(0.2 - Rnd(1)/10));
  		else
  			WAR.Person[enemyid]["特效文字2"] = "以招拆招"
  			hurt = math.modf(hurt * (0.6-math.random(3)/10))
  			dng = math.modf(dng*(2 + math.random(5)/10));
  		end
  	end
  end
  
  --蓝烟清：主角灵犀真拳 蓄力状态，每个拳法练到极，减少受到的5%伤害和10%集气
  if WAR.Actup[eid] ~= nil and eid == 0 and GetS(4, 5, 5, 5) == 1 then
  	local lxzq = 0
    for i = 1, 10 do
      if (JY.Person[0]["武功" .. i] == 109 or JY.Person[0]["武功" .. i] == 49  or (JY.Person[0]["武功" .. i] <= 26 and JY.Person[0]["武功" .. i] > 0)) and JY.Person[0]["武功等级" .. i] == 999 then
        lxzq = lxzq + 1
      end
    end
    hurt = math.modf(hurt * (1 - 0.05 * (lxzq)));
    ang = math.modf(ang * (1 - 0.1 * (lxzq)));
    if WAR.Person[enemyid]["特效文字2"] ~= nil then
    	WAR.Person[enemyid]["特效文字2"] = WAR.Person[enemyid]["特效文字2"] .. "+真拳气功护体"
    else
    	WAR.Person[enemyid]["特效文字2"] = "真拳气功护体"
    end
  end
  
  --八荒六合功防护：减一半伤害变内力伤害,如果有北冥真气，减的内力变加一半
  if WAR.NGHT == 101 and WAR.B_BMJQ == 1 then
		
		hurt = math.modf(hurt/2);
  	WAR.Person[enemyid]["内力点数"] = (WAR.Person[enemyid]["内力点数"] or 0)+hurt;
  	AddPersonAttrib(eid, "内力", hurt);
  elseif WAR.NGHT == 101 then
  	if JY.Person[eid]["内力"] < math.modf(hurt/2) then
  		hurt = math.modf(hurt-JY.Person[eid]["内力"] - hurt/4);
  	else
  		hurt = math.modf(hurt/2);
  	end
  	WAR.Person[enemyid]["内力点数"] = (WAR.Person[enemyid]["内力点数"] or 0)-2*hurt;
  	AddPersonAttrib(eid, "内力", -2*hurt);
  end
  
  --护符作用
  if eid == JY.MY and GetS(53, 0, 2, 5) == 2 then
  	local rate = JY.Thing[238]["需经验"]/30 + JY.Person[eid]["声望"]/15 + JY.Person[eid]["武学常识"]/20 + JY.Person[eid]["内力"]/1000 + JY.Person[eid]["防御力"]/100 + GetSZ(eid)/100
  	
  	--仁者在护符激活时增加机率
  	if JLSD(0,rate,eid) or (GetS(4, 5, 5, 5) == 6 and GetS(53, 0, 5, 5) == 1 and JLSD(0,30,eid)) then
  		local t = math.random(2);
  		
  		--发动时增加经验
  		if WAR.tmp[8002] == nil then
  			WAR.tmp[8002] = 0;
	  	end
	  	WAR.tmp[8002] = WAR.tmp[8002] + math.random(3);
  		
  		if t == 1 then
  			hurt = math.modf(hurt * 0.3)
  			dng = math.modf(dng * 0.6);
  			WAR.Person[enemyid]["特效文字2"] = "护符守护"	
	    	WAR.Person[enemyid]["特效动画"] = 88
	    	
	    	for j = 0, WAR.PersonNum - 1 do
          if WAR.Person[j]["死亡"] == false and WAR.Person[j]["我方"] == WAR.Person[enemyid]["我方"] then
            WAR.Person[j].Time = WAR.Person[j].Time + 100
          end
          if WAR.Person[j].Time > 980 then
            WAR.Person[j].Time = 980
          end
        end
  		else
  			hurt = math.modf(hurt * 0.6)
  			dng = math.modf(dng * 0.3);
  			WAR.Person[enemyid]["特效文字2"] = "护符救驾"	
	    	WAR.Person[enemyid]["特效动画"] = 89
	    	
	    	WAR.FLHS2 = WAR.FLHS2 + 3
  		end
  	end
  	
  	if GetS(53, 0, 5, 5) == 1 and JLSD(0,rate/2,eid) then
  		hurt = 0
	    WAR.Person[enemyid]["特效文字2"] = "护符神威"
	    WAR.Person[enemyid]["特效动画"] = 87
	    WAR.ACT = 10
		  WAR.ZYHB = 0
  	end
  	
  	
  	
  end
  
  
  if WAR.LHQ_BNZ == 1 then		--般若掌 伤害+50
    hurt = hurt + 50
  end
  if WAR.JGZ_DMZ == 1 then		--达摩掌 伤害+100
    hurt = hurt + 100
  end
  
  --蓝烟清：独孤求败攻击时，根据X变化
	 if pid == 592 then
		 if WAR.L_DGQB_X < 8 then
			hurt = math.modf(hurt*(WAR.L_DGQB_X/5));
		 else
			hurt = math.modf(hurt*(1 + WAR.L_DGQB_X/10));
		 end
	 end
  
  --蓝烟清：七伤拳：对有内伤的目标造成额外伤害。随着目标内伤增加，额外伤害也随之增加。额外伤害不受到气防影响，当自己内力值低于4000时，会有机率受到内伤。
  if wugong == 23 then
  	if JY.Person[eid]["受伤程度"] > 0 then
  		hurt = hurt + math.modf(JY.Person[eid]["受伤程度"]*3/2);
  		if JY.Person[pid]["内力"] < 4000 and JLSD(0, math.modf(4000-JY.Person[pid]["内力"])) then
  			AddPersonAttrib(pid, "受伤程度", 10);
  		end
  	end
  end
  
  
  --乾坤大挪移防护，反弹伤害，减少受到的伤害
  if WAR.NGHT == 97 then
    WAR.fthurt = 0
    
    
    local nydx = {}
    local nynum = 1
    for i = 0, WAR.PersonNum - 1 do
      if WAR.Person[i]["我方"] ~= WAR.Person[enemyid]["我方"] and WAR.Person[i]["死亡"] == false then
        nydx[nynum] = i
        nynum = nynum + 1
      end
    end
    
    local nyft = nydx[math.random(nynum - 1)]
    local nyft2 = nydx[math.random(nynum - 1)]
    
    --反弹的伤害根据两者的内力值判断
    local nl = limitX(math.modf((JY.Person[eid]["内力"] - JY.Person[WAR.Person[nyft]["人物编号"]]["内力"])/100), 0, 30);
    local jl = 30 - nl;
    local h = 0;
    
    --张无忌必反弹，其它角色有机率反弹，不反弹时只减少20%伤害
    if (jl > math.random(100) or  WAR.L_QKDNY[WAR.Person[nyft]["人物编号"]] ~= nil) and eid ~= 9  then
    	hurt = math.modf((hurt) * 0.6)
    	if WAR.Person[nyft]["特效动画"] == -1 then
    		WAR.Person[nyft]["特效动画"] = 85;
    	end
    	WAR.Person[nyft]["特效文字2"] = "借力消力"
    else
    	if eid == 9 then		--张无忌反一半伤害
      	WAR.fthurt = math.modf(hurt*0.7)			
      	hurt = math.modf(hurt*0.5)
    	else
    		WAR.fthurt = math.modf(hurt*0.5)
    		hurt = math.modf(hurt*0.7)
    	end
    	h = math.modf(WAR.fthurt / 2 + Rnd(10));		--反弹的伤害
    	SetWarMap(WAR.Person[nyft]["坐标X"], WAR.Person[nyft]["坐标Y"], 4, 2);	--反弹者标识为被命中
    	
    	WAR.L_QKDNY[WAR.Person[nyft]["人物编号"]] = 1;
    end
    	

    WAR.Person[nyft]["生命点数"] = (WAR.Person[nyft]["生命点数"] or 0) - h;
    JY.Person[WAR.Person[nyft]["人物编号"]]["生命"] = JY.Person[WAR.Person[nyft]["人物编号"]]["生命"] - h
    if JY.Person[WAR.Person[nyft]["人物编号"]]["生命"] < 1 then
      JY.Person[WAR.Person[nyft]["人物编号"]]["生命"] = 1
    end
    
    
    WAR.Person[enemyid]["特效文字2"] = WAR.Person[enemyid]["特效文字2"] .."·".. "反弹"
      
    --张无忌，可以反弹两个人
    if eid == 9 and nyft ~= nyft2 then
    	WAR.Person[nyft2]["生命点数"] = (WAR.Person[nyft2]["生命点数"] or 0) - h;
      JY.Person[WAR.Person[nyft2]["人物编号"]]["生命"] = JY.Person[WAR.Person[nyft2]["人物编号"]]["生命"] - h;
      if JY.Person[WAR.Person[nyft2]["人物编号"]]["生命"] < 1 then
        JY.Person[WAR.Person[nyft2]["人物编号"]]["生命"] = 1
      end
      WAR.Person[enemyid]["特效文字2"] = WAR.Person[enemyid]["特效文字2"] .. "·双"
      SetWarMap(WAR.Person[nyft2]["坐标X"], WAR.Person[nyft2]["坐标Y"], 4, 2);	--反弹者标识为被命中
    end
    
  end
  
  
  --被刺目，伤害为0
  if (WAR.KHCM[pid] == 1 and JLSD(30,70,pid)) or WAR.KHCM[pid] == 2 then
    hurt = 0
  end
  
  --brolycjw: 葵花移行
  if (eid == 27 and JLSD(20, 80, eid)) or WAR.L_SGHT == 105 then
    hurt = math.modf(hurt / 2)
    ang = 0
    WAR.Person[enemyid]["特效文字2"] = "葵花移形"		--葵花移形
    WAR.Person[enemyid]["特效动画"] = math.fmod(105, 10) + 85
  end
  
  --祖千秋
  if eid == 88 and JLSD(35, 65, eid) then
    hurt = 0
    WAR.Person[enemyid]["特效文字2"] = "酒神秘踪步"	--酒神秘踪步
    WAR.Person[enemyid]["特效动画"] = 89
  end

	--段誉 指令
  if eid == 53  then
  	if WAR.TZ_DY == 1 and JLSD(10, 90, eid) then
	    hurt = 0
	    WAR.Person[enemyid]["特效文字2"] = "凌波微步"		--凌波微步
	    WAR.Person[enemyid]["特效动画"] = 88
	  elseif JLSD(30, 60, eid) then
	    hurt = 0
	    WAR.Person[enemyid]["特效文字2"] = "凌波微步"
	    WAR.Person[enemyid]["特效动画"] = 88
	  end
  end
 

  --主角 特系
  if GetS(4, 5, 5, 5) == 4 and eid == 0 then
    local gctj = 0
    for i = 1, 10 do
      if (JY.Person[0]["武功" .. i] == 112 or (JY.Person[0]["武功" .. i] <= 86 and JY.Person[0]["武功" .. i] >= 68 and JY.Person[0]["武功" .. i] ~= 85)) and JY.Person[0]["武功等级" .. i] == 999 then
        gctj = gctj + 1
      end
    end
    local tjsf = 10 + (gctj) * 5
    if JLSD(30, 30 + tjsf, eid) then
	    hurt = 0
	    WAR.Person[enemyid]["特效文字3"] = "天机身法"		--天机身法
	    WAR.Person[enemyid]["特效动画"] = 88
  	end
  end
  
  --蓝烟清：田伯光 
  if eid == 29 and WAR.L_TBGZL == 1 and JLSD(30,60,pid) then
  	hurt = 0
	  WAR.Person[enemyid]["特效文字2"] = "风骚惊天下"
	  WAR.Person[enemyid]["特效动画"] = 88
  end
  
  --主角 不动如山
  if eid == JY.MY and WAR.FLHS4 > 0 and hurt > 0 then
    hurt = 10
  end
  
  --天罡大招
  if eid == JY.MY and WAR.JSTG > 0 then
    if hurt <= WAR.JSTG then
      WAR.JSTG = WAR.JSTG - hurt
      hurt = 5 + Rnd(6)
      ang = math.modf(ang / 2)
    else
      hurt = hurt - WAR.JSTG
      WAR.JSTG = 0
    end
    if WAR.Person[enemyid]["特效文字3"] == nil then
      WAR.Person[enemyid]["特效文字3"] = "天罡护体"		--天罡护体
    else
      WAR.Person[enemyid]["特效文字3"] = WAR.Person[enemyid]["特效文字3"] .. "+天罡护体"
    end
    WAR.Person[enemyid]["特效动画"] = 6
  end
  
  for i = 1, 10 do
    local kfid = JY.Person[eid]["武功" .. i]
  	--逆运走火，普通角色不再走火
    if kfid == 104 then
		  if WAR.tmp[1000 + eid] ~= 1 and WAR.ZDDH ~= 171 and eid == 60 then
			  if JY.Person[eid]["体力"] > 50 then
			    WAR.Person[enemyid]["特效动画"] = math.fmod(wugong, 10) + 85
			    if eid == 60 then
			      WAR.Person[enemyid]["特效文字1"] = "真--逆运筋脉走火入魔"		--真--逆运筋脉走火入魔
			    else
			    	WAR.Person[enemyid]["特效文字1"] = JY.Wugong[kfid]["名称"] .. "走火入魔"
			    end
			    WAR.tmp[1000 + eid] = 1
			  end
			end
		end
	end

	--张无忌 九阳神功反弹
  if eid == 9 and WAR.Person[enemyid]["特效文字1"] == nil and WAR.Person[enemyid]["我方"] ~= WAR.Person[WAR.CurID]["我方"] and hurt > 10 and PersonKF(9, 106) then
    WAR.Person[enemyid]["特效动画"] = math.fmod(97, 10) + 85
    WAR.Person[enemyid]["特效文字1"] = "九阳神功反震"
    SetWarMap(WAR.Person[WAR.CurID]["坐标X"], WAR.Person[WAR.CurID]["坐标Y"], 4, 2)
    local selfhurt = math.modf(hurt * 0.3)
    JY.Person[pid]["生命"] = JY.Person[pid]["生命"] - math.modf(selfhurt / 2)
    WAR.Person[WAR.CurID]["生命点数"] = (WAR.Person[WAR.CurID]["生命点数"] or 0)-math.modf(selfhurt / 2)
  end
  
  --蓝烟清：装备软蝟甲反弹拳系武功20%伤害，非拳系则减伤10%，弹不死
  if WAR.Person[enemyid]["我方"] and JY.Person[eid]["防具"] == 58 then
  	if (wugong >= 1 and wugong <= 26) or wugong == 109 then		--拳系武功
  		local selfhurt = 20
  		if WAR.Person[enemyid]["特效文字1"] ~= nil then
  			WAR.Person[enemyid]["特效文字1"] = WAR.Person[enemyid]["特效文字1"] .. "+" ..JY.Thing[58]["名称"].."反弹"
  		else
  			WAR.Person[enemyid]["特效文字1"] = JY.Thing[58]["名称"].."反弹"
  		end
  		if WAR.Person[enemyid]["特效动画"] == -1 then
      	WAR.Person[enemyid]["特效动画"] = math.fmod(97, 10) + 85
      end
      SetWarMap(WAR.Person[WAR.CurID]["坐标X"], WAR.Person[WAR.CurID]["坐标Y"], 4, 2)
      JY.Person[pid]["生命"] = JY.Person[pid]["生命"] - selfhurt;
      if JY.Person[pid]["生命"] <= 0 then		--弹不死
      	JY.Person[pid]["生命"] = 1;
      end
    	WAR.Person[WAR.CurID]["生命点数"] = (WAR.Person[WAR.CurID]["生命点数"] or 0)-selfhurt
  	else
  		hurt = hurt - 20
  	end
  end
  


	
 	 --brolycjw: 石破天与石中玉被攻击时伤害分散
	if eid == 591 and WAR.Person[enemyid]["我方"] ~= WAR.Person[WAR.CurID]["我方"] and hurt > 10 then
		for j = 0, WAR.PersonNum - 1 do
			if WAR.Person[j]["人物编号"] == 38 and WAR.Person[j]["死亡"] == false and WAR.Person[j]["我方"] == WAR.Person[enemyid]["我方"] then
				hurt = math.modf(hurt*0.5)
				JY.Person[38]["生命"] = JY.Person[38]["生命"] - hurt	
				WAR.Person[enemyid]["特效文字3"] = "本是同根生"
				WAR.Person[j]["生命点数"] = (WAR.Person[j]["生命点数"] or 0)-hurt;
				SetWarMap(WAR.Person[j]["坐标X"], WAR.Person[j]["坐标Y"], 4, 2);
			end
		end
	end	  
	if eid == 38 and WAR.Person[enemyid]["我方"] ~= WAR.Person[WAR.CurID]["我方"] and hurt > 10 then
		for j = 0, WAR.PersonNum - 1 do
			if WAR.Person[j]["人物编号"] == 591 and WAR.Person[j]["死亡"] == false and WAR.Person[j]["我方"] == WAR.Person[enemyid]["我方"] then
				hurt = math.modf(hurt*0.5)
				JY.Person[591]["生命"] = JY.Person[591]["生命"] - hurt	
				WAR.Person[enemyid]["特效文字3"] = "本是同根生"
				WAR.Person[j]["生命点数"] = (WAR.Person[j]["生命点数"] or 0)-hurt;
				SetWarMap(WAR.Person[j]["坐标X"], WAR.Person[j]["坐标Y"], 4, 2);
			end
		end
	end
	
	
	--蓝烟清：新内功，九阳神功护体，伤害减少40%
	if WAR.L_SGHT == 106 then
		hurt = math.modf(hurt*0.6);
		ang = math.modf(ang*0.5);
	end
	
	--蓝烟清：独孤求败，被攻击时额外判断
	if eid == 592 then
	
		local wgtype = JY.Wugong[wugong]["武功类型"];
		
		--brolycjw: 内功类型
		if wugong > 88 and wugong < 109 then
			wgtype = 5;
		end
		
		--重复使用相同的武功攻击时，攻击无效
		if wgtype == WAR.L_DGQB_DEF then
			hurt = 0;
			ang = 0;
			WAR.L_DGQB_X = WAR.L_DGQB_X + 1;
			
		--拳防御，被剑攻击，  剑防御刀攻击，  刀防御拳攻击， 特防御内功攻击，内功攻击后再改其它武功，时伤害和杀集气为1.5倍
		elseif (WAR.L_DGQB_DEF == 1 and wgtype == 2) or (WAR.L_DGQB_DEF == 2 and wgtype == 3) or (WAR.L_DGQB_DEF == 3 and wgtype == 1) or (WAR.L_DGQB_DEF == 4 and wgtype == 5) or (WAR.L_DGQB_DEF == 5 and wgtype < 5)then
			hurt = math.modf(hurt*(1-WAR.L_DGQB_X/10));
			if hurt < 0 then
				hurt = 0;
			else
				
			end
			WAR.L_DGQB_X = WAR.L_DGQB_X - 1;
		else
			hurt = math.modf(hurt*(1-WAR.L_DGQB_X/10));
			ang = 0;
			WAR.L_DGQB_X = WAR.L_DGQB_X + 1;
		end
		
		--brolycjw: 改变防御类型
		if wgtype > 0 then 
			WAR.L_DGQB_DEF = wgtype;
		end
		
		--连击无效，可以左右
		WAR.ACT = 10;
		if WAR.L_DGQB_X <= 0 then
			WAR.L_DGQB_X = 1;
		end
		if WAR.Person[enemyid]["特效文字2"] ~= nil then
			WAR.Person[enemyid]["特效文字2"] = WAR.Person[enemyid]["特效文字2"] .. "+" ..WAR.L_DGQB_DEF_STR[WAR.L_DGQB_DEF]
		else
			WAR.Person[enemyid]["特效文字2"] = WAR.L_DGQB_DEF_STR[WAR.L_DGQB_DEF]
		end
		
		WAR.Person[enemyid]["特效动画"] = 96
	end
	 
	 
  
  --死亡
  if JY.Person[pid]["生命"] <= 0 then
    JY.Person[pid]["生命"] = 0
  end
  
  
  --蓝烟清：装备倚天剑，必流血，有20%机率封穴
  if JY.Person[pid]["武器"] == 37 then
  	WAR.L_YTJ1 = 1;
  	if JLSD(50,70,pid) then
  		WAR.L_YTJ2 = 1;
  	end
  end
  

  
  --打到自己人
  if WAR.Person[WAR.CurID]["我方"] == WAR.Person[enemyid]["我方"]  then
    if WAR.Person[WAR.CurID]["我方"] then
    
    	if WAR.L_NYZH[pid] ~= nil then			--蓝烟清：新逆运走火，打到已方伤害提高
      	hurt = math.modf(hurt * 0.8) + Rnd(3)
      else
      	hurt = math.modf(hurt * 0.5) + Rnd(3)
      end
    else
    	hurt = math.modf((hurt) * 0.2) + Rnd(3)
    end
  end
  
	--独孤求败，极意时另外计算
 	if WAR.L_DGQB_X >= 10 and pid == 592 then
		if JY.Person[eid]["生命"] >= 500 then
			hurt = JY.Person[eid]["生命"] - 1;
			JY.Person[eid]["生命"] = 1;
		else
			hurt = JY.Person[eid]["生命"];
			JY.Person[eid]["生命"] = 0;	
		end
	else
		JY.Person[eid]["生命"] = JY.Person[eid]["生命"] - (hurt)
	end

  
  --太拳极，借力打力
  for i = 1, 10 do
    local kfid = JY.Person[eid]["武功" .. i]
    if kfid == 16 then
      if WAR.tmp[3000 + eid] == nil then
        WAR.tmp[3000 + eid] = 0
      end
      WAR.tmp[3000 + eid] = hurt;
      break;
    end
  end
  
  --获取得经验
  WAR.Person[WAR.CurID]["经验"] = WAR.Person[WAR.CurID]["经验"] + math.modf((hurt) / 5)
  
  --神照重生
  if JY.Person[eid]["生命"] <= 0 then
    for i = 1, 10 do
      local kfid = JY.Person[eid]["武功" .. i]
      if kfid == 94 and WAR.tmp[2000 + eid] == nil then
        WAR.Person[enemyid]["特效动画"] = math.fmod(kfid, 10) + 85
        WAR.Person[enemyid]["特效文字1"] = JY.Wugong[kfid]["名称"] .. "起死回生"
        local lv = math.modf(JY.Person[eid]["武功等级" .. i] / 100) + 1
        if eid == 37 then
          JY.Person[eid]["生命"] = JY.Person[eid]["生命最大值"]
        else
          JY.Person[eid]["生命"] = math.modf(JY.Person[eid]["生命最大值"] * (1 + lv) / 25)
        end
        JY.Person[eid]["内力"] = math.modf((JY.Person[eid]["内力"] + JY.Person[eid]["内力最大值"]) / 2)
        JY.Person[eid]["体力"] = math.modf((JY.Person[eid]["体力"] + 50) / 2)
        JY.Person[eid]["中毒程度"] = math.modf(JY.Person[eid]["中毒程度"] / 2)
        JY.Person[eid]["受伤程度"] = math.modf(JY.Person[eid]["受伤程度"] / 2)
        WAR.Person[enemyid].Time = WAR.Person[enemyid].Time + 500
        if eid == 37 then
          WAR.Person[enemyid].Time = 990
          WAR.DYSZ = 1
        end
        if WAR.Person[enemyid].Time > 990 then
          WAR.Person[enemyid].Time = 990
        end
        --十分之一的机率。。。再次重生
		    if math.random(10) ~= 8 then		
		      WAR.tmp[2000 + eid] = 1
		    end
      end
    end
    
  end
  
  --王重阳，一灯，复活
  if JY.Person[eid]["生命"] <= 0 and (eid == 129 or eid == 65) and WAR.WCY < 1 then
    WAR.Person[enemyid]["特效动画"] = 19
    WAR.Person[enemyid]["特效文字1"] = "先天一阳 起死回生"
    WAR.WCY = WAR.WCY + 1
    JY.Person[eid]["生命"] = JY.Person[eid]["生命最大值"]
    JY.Person[eid]["内力"] = JY.Person[eid]["内力最大值"]
    JY.Person[eid]["中毒程度"] = 0
    JY.Person[eid]["受伤程度"] = 0
    JY.Person[eid]["体力"] = 100
    WAR.Person[enemyid].Time = 980
  end
  
  --薛慕华 复活一个人
  if JY.Person[eid]["生命"] <= 0 and WAR.XMH == 0 then
    for i = 0, WAR.PersonNum - 1 do
      if WAR.Person[i]["人物编号"] == 45 and WAR.Person[i]["死亡"] == false and WAR.Person[i]["我方"] == WAR.Person[enemyid]["我方"] then
        WAR.Person[enemyid]["特效动画"] = 89
        WAR.Person[enemyid]["特效文字1"] = "阎王敌 重生"		--阎王敌 重生
        JY.Person[eid]["生命"] = JY.Person[eid]["生命最大值"]
        JY.Person[eid]["内力"] = JY.Person[eid]["内力最大值"]
        JY.Person[eid]["中毒程度"] = 0
        JY.Person[eid]["受伤程度"] = 0
        JY.Person[eid]["体力"] = 100
        WAR.FXDS[eid] = nil
        WAR.LXZT[eid] = nil
        WAR.XMH = 1
        break;
      end
    end
  end
  
  --小日本
  if eid == 553 and JY.Person[eid]["生命"] <= 0 then
    WAR.YZB = 1
  end
  
  
  if JY.Person[eid]["生命"] <= 0 then
    JY.Person[eid]["生命"] = 0
    WAR.Person[WAR.CurID]["经验"] = WAR.Person[WAR.CurID]["经验"] + JY.Person[eid]["等级"] * 5
    WAR.Person[enemyid]["反击武功"] = -1
  end
  
  --计算是否破防，dng为0表示被破防
  ang = ang - dng
  if 0 < ang then
    dng = 0
  else
    dng = -ang
    ang = 0
  end
  
  --扫地  免杀气
  if eid == 114 then
    WAR.Person[enemyid]["特效文字2"] = "天地独尊"	--天地独尊
    WAR.Person[enemyid]["特效动画"] = 39
    dng = 1
  end
  
  --伤害小于20 免内伤，免杀气 
  if hurt < 20 then
    dng = 1
  end
  
  --狄云复活第一回合，免内伤，免杀气 
  if eid == 37 and WAR.DYSZ == 1 then
    dng = 1
    WAR.DYSZ = 0
  end
  
  --不动如山 免内伤，免杀气 
  if eid == 0 and 0 < WAR.FLHS4 then
    dng = 1
  end
  
  --太极奥义，免免内伤，免杀气 
  for i = 1, 10 do
    if (JY.Person[eid]["武功" .. i] == 16 or JY.Person[eid]["武功" .. i] == 46) and JY.Person[eid]["武功等级" .. i] == 999 then
      WAR.TJAY = WAR.TJAY + 1
    end
  end
  if WAR.TJAY == 2 and JLSD(10, 45 + math.modf(JY.Person[eid]["资质"] / 2.5), eid) then
    dng = 1
    if WAR.Person[enemyid]["特效文字2"] ~= nil and WAR.Person[enemyid]["特效文字2"] ~= " " then
      WAR.Person[enemyid]["特效文字2"] = WAR.Person[enemyid]["特效文字2"] .. "+太极奥义"
    else
      WAR.Person[enemyid]["特效文字2"] = "太极奥义--四两拨千斤"
    end
    WAR.Person[enemyid]["特效动画"] = 21
    
    --张三丰伤害减少50%
	  if eid == 5 then
	    WAR.Person[enemyid]["特效文字3"] = "无根无形"
	    WAR.Person[enemyid]["特效动画"] = 21
	    hurt = math.modf(hurt * 0.5)
	    WAR.Person[enemyid].TimeAdd = WAR.Person[enemyid].TimeAdd + hurt
	  else
	  	hurt = math.modf(hurt * 0.8)
	  end
  end
  
  
  WAR.TJAY = 0
  
  --刀系大招 直接破防
  if WAR.ASKD == 1 then
    dng = 0
  end
  
  
  --蓝烟清：狮吼功加力 对敌人造成迟缓
  if WAR.NGJL == 92 then
  	local n = math.modf((JY.Person[pid]["内力"]*2 - JY.Person[eid]["内力"])/1000);
  	WAR.CHZ[eid] = 10 + limitX(n,0,10);
  	
  	--内功加力有小机率直接破防
  	if JLSD(0,15,pid) then
  		dng = 0
  	end
  end
  
  
  --破防后内伤计算
  --龙象般若功加力必内伤
  if (WAR.NGJL == 103 or dng == 0) and hurt > 0 and WAR.Person[WAR.CurID]["我方"] ~= WAR.Person[enemyid]["我方"]  then
  	local n = 0;		--内伤点数值
    if inteam(eid) then		--队友内伤计算
      if pid == 80 then				--张召重攻击，内伤加倍
        	n = myrnd((hurt) * 2 / 8);
	    else
      		n = myrnd((hurt) / 8);
    	end
   	else
   		--计算敌方内伤
	  	if pid == 80 then			--张召重攻击，内伤加倍
		      n = myrnd((hurt) * 2 / 16);
		  else
		    n = myrnd((hurt) / 16);
		  end
  	end
  	
  	--先天功内伤减半
  	if PersonKF(eid, 100) then
  		n = math.modf(n/2);
  	end
  	
  	
  	--太玄神功，把受到的内伤转为回复内伤
    if WAR.L_SGHT == 102 then
    	WAR.Person[enemyid]["内伤点数"] = (WAR.Person[enemyid]["内伤点数"] or 0) - n;
  		AddPersonAttrib(eid, "受伤程度", -n);
    else
    	WAR.Person[enemyid]["内伤点数"] = (WAR.Person[enemyid]["内伤点数"] or 0) + n;
  		AddPersonAttrib(eid, "受伤程度", n);
    end
  end
  
  --破防杀集气计算
  if dng == 0 and hurt > 0 and WAR.Person[WAR.CurID]["我方"] ~= WAR.Person[enemyid]["我方"] then
    local killsq = limitX(9-JY.Thing[202][WZ7],1) -- 难度判断
    
    local killjq = 0
    if inteam(eid) then  
    	killjq = math.modf(ang / killsq)
    else
    	killjq = math.modf(ang / 8)
    end
    
    
    
    --受伤害额外杀集气
    local spdhurt = 0
    if inteam(eid) then
      spdhurt = math.modf((hurt) * 0.7)
    end
    for i = 1, 10 do
      if JY.Person[pid]["武功" .. i] == 103 then			--龙象
        spdhurt = math.modf((hurt) * 2 / 5)
      end
    end
    for i = 1, 10 do
      if JY.Person[eid]["武功" .. i] == 101 then			--如果学了八六不受伤害杀集气
        spdhurt = 0
      end
    end
    killjq = killjq + spdhurt
    
    --太玄神功，把被杀的集气转为自己的集气值
    if WAR.L_SGHT == 102 then
    	WAR.Person[enemyid].TimeAdd = WAR.Person[enemyid].TimeAdd + killjq;
    else
    	WAR.Person[enemyid].TimeAdd = WAR.Person[enemyid].TimeAdd - killjq;
    	if WAR.L_SGHT == 106 and JLSD(0,70,eid)  then		--九阳神功护体，有机率回复被杀集气的血量
    		WAR.Person[enemyid]["生命点数"] = (WAR.Person[enemyid]["生命点数"] or 0) + AddPersonAttrib(eid, "生命", math.modf((hurt+killjq)*(0.4+math.random(4)/10)));
    		WAR.Person[enemyid]["体力点数"] = (WAR.Person[enemyid]["体力点数"] or 0) + AddPersonAttrib(eid, "体力", 3);
    	end
    end
  end
  
  --小龙女死掉，杨过吼
  if eid == 59 and JY.Person[eid]["生命"] <= 0 then
    WAR.XK = 1
    WAR.XK2 = WAR.Person[enemyid]["我方"]
  end
  
  --欧阳锋  攻击中毒+30
  if pid == 60 then
    WAR.Person[enemyid]["中毒点数"] = (WAR.Person[enemyid]["中毒点数"] or 0) + AddPersonAttrib(eid, "中毒程度", 30)
  end
  
  
  --偷东西
  if WAR.TD == -2 then
    local i = nil
    i = math.random(4)
    if 0 < JY.Person[eid]["携带物品数量" .. i] and -1 < JY.Person[eid]["携带物品" .. i] and WAR.Person[WAR.CurID]["我方"] ~= WAR.Person[enemyid]["我方"] then
      JY.Person[eid]["携带物品数量" .. i] = JY.Person[eid]["携带物品数量" .. i] - 1
      WAR.TD = JY.Person[eid]["携带物品" .. i]
    end
    if JY.Person[eid]["携带物品数量" .. i] < 1 then
      JY.Person[eid]["携带物品" .. i] = -1
    end
  else
    WAR.TD = -1
  end
  
  --血刀吸血
  if WAR.XDDF == 1 then
  	WAR.Person[WAR.CurID]["生命点数"] = (WAR.Person[WAR.CurID]["生命点数"] or 0) + AddPersonAttrib(pid, "生命", math.modf((hurt) * 0.1));
    
    WAR.XDXX = WAR.XDXX + math.modf((hurt) * 0.1)
  end
  
  --贝海石 被攻击后生命+50
  if eid == 85 and 0 < JY.Person[eid]["生命"] then
    WAR.Person[enemyid]["生命点数"] = (WAR.Person[enemyid]["生命点数"] or 0) + AddPersonAttrib(eid, "生命", 50);
  end
  
  --宫本武藏 被攻击后生命+150
  if eid == 516 and 0 < JY.Person[eid]["生命"] then
    WAR.Person[enemyid]["生命点数"] = (WAR.Person[enemyid]["生命点数"] or 0) + AddPersonAttrib(pid, "生命", 50);
  end
  
  --霍青桐 杀体力
  if WAR.HQT == 1 then
  	WAR.Person[enemyid]["体力点数"] = (WAR.Person[enemyid]["体力点数"] or 0) + AddPersonAttrib(eid, "体力", -15);
  end
  
  
  --程英 杀内力
  if WAR.CY == 1 then
    WAR.Person[enemyid]["内力点数"] = (WAR.Person[enemyid]["内力点数"] or 0) + AddPersonAttrib(eid, "内力", -300);
  end
  
  --田归农 用雷震剑法杀死苗人凤
  if WAR.Data["代号"] == 0 and pid == 72 and eid == 3 and JY.Person[eid]["生命"] <= 0 and JY.Person[72]["武功1"] == 28 then
    WAR.TGN = 1
  end
  
  --阎基偷钱
  if eid ~= 445 and eid ~= 446 and eid < 578 and eid ~= 64 and WAR.ZDDH ~= 17 and pid == 4 and JY.Person[eid]["生命"] <= 0 and inteam(pid) and WAR.Person[enemyid]["我方"] ~= WAR.Person[WAR.CurID]["我方"] and not inteam(eid) then
    WAR.YJ = WAR.YJ + math.random(15) + 25
  end
  
  --田归农与阎基的加成，中毒+5 + 随机15
  if pid == 72 then
    for j = 0, WAR.PersonNum - 1 do
      if WAR.Person[j]["人物编号"] == 4 and WAR.Person[j]["死亡"] == false and WAR.Person[j]["我方"] == WAR.Person[WAR.CurID]["我方"] then
        WAR.Person[enemyid]["中毒点数"] = AddPersonAttrib(eid, "中毒程度", JY.Person[eid]["中毒程度"] + 5 + math.random(15));
      end
    end
  end
  
  --葵花刺目，40%机率MISS 
  if WAR.KHBX == 1 and 0 < hurt and (WAR.KHCM[eid] == nil or WAR.KHCM[eid] == 0)  then
    WAR.KHCM[eid] = 1
  end
  
  --辟邪刺目，100%MISS
  if WAR.KHBX == 2 and 0 < hurt  then
    WAR.KHCM[eid] = 2
  end
  
  --宫本宝藏 秒杀
  if WAR.GBWZ == 1 and math.random(10) < 6 and WAR.Person[enemyid]["我方"] ~= WAR.Person[WAR.CurID]["我方"] then
  	WAR.Person[enemyid]["生命点数"] = -JY.Person[eid]["生命"];
    JY.Person[eid]["生命"] = 0
  end
  
  if not inteam(pid) then
    local gfxp = {114, 26, 129, 65, 18, 39, 70, 98, 57, 185}
    for g = 1, 10 do
      if pid == gfxp[g] and JLSD(30, 70, pid) then
        WAR.BFX = 1
      end
    end
  end
  
  --封穴计算
  if WAR.LXZQ == 1 and JLSD(25, 75, pid) then
    WAR.BFX = 1
  end
  
  --蓝烟清：装备倚天剑有20%机率封穴
  --太玄神功护体，免封穴
  --乔峰免封穴
  --宗师，50%机率增加封穴
  if PersonKF(eid, 104) == false and WAR.L_SGHT ~= 102 and eid ~= 50  and (100 < hurt and (JLSD(30, 75, pid) or WAR.GCTJ == 1 or WAR.BFX == 1) and (WGLX == 1 or WGLX == 4 or JLSD(35, 70, pid) or WAR.BFX == 1) or  WAR.L_YTJ2 == 1 or (wugong == 19 and JLSD(30,80,pid) and JY.Person[pid]["内力性质"] == 0) or (wugong == 17 and JLSD(30,80,pid) and JY.Person[pid]["内力性质"] == 1) or WAR.L_WYJFA == 33 or (pid==JY.MY and GetS(53, 0, 2, 5) == 3  and 50 > math.random(100))) then
    
    
    if WAR.FXDS[eid] == nil then
      if inteam(eid) then
        WAR.FXDS[eid] = math.modf((hurt) / 15)
        if WAR.FXDS[eid] < 10 then
          WAR.FXDS[eid] = 10
        end
      else
        WAR.FXDS[eid] = math.modf((hurt) / 20)
        if WAR.FXDS[eid] < 5 then
        	WAR.FXDS[eid] = 5
      	end
      end   
    elseif inteam(eid) then
      WAR.FXDS[eid] = WAR.FXDS[eid] + math.modf((hurt) / 20)
    else
      WAR.FXDS[eid] = WAR.FXDS[eid] + math.modf((hurt) / 30)
    end
    WAR.FXXS[eid] = 1
    if 50 < WAR.FXDS[eid] then
    	WAR.FXDS[eid] = 50
  	end
  end
  
  
  WAR.BFX = 0
  if not inteam(pid) then
    local glxp = {6, 3, 40, 97, 103, 19, 60, 71, 189, 27}
    for g = 1, 10 do
      if pid == glxp[g] and JLSD(30, 70, pid) then
        WAR.BLX = 1
      end
    end
  end
  
  --流血计算
  if WAR.ASKD == 1 and JLSD(25, 75, pid) then
    WAR.BLX = 1
  end
  
  --蓝烟清：装备倚天剑必流血    屠龙刀机率流血
  --龙象般若功加力必流血
  --乔峰免流血
  if hurt > 0 and (WAR.L_YTJ1 == 1 or WAR.L_TLD == 1 or WAR.NGJL == 103 or WAR.BLX == 1 or WAR.GCTJ == 1 or  (50 < hurt and JLSD(30, 75, pid)) or (wugong == 18 and JLSD(30, 90, pid)) or WAR.L_WYJFA == 32 or WAR.L_WYJFA == 30 ) then
		if pid == 591 then
			if WAR.LXZT[eid] == nil then
			  WAR.LXZT[eid] = math.modf((hurt) / 2.5)
			else
			  WAR.LXZT[eid] = WAR.LXZT[eid] + math.modf((hurt) / 2.5)
			end
			if 100 < WAR.LXZT[eid] then
				WAR.LXZT[eid] = 100
			end	
		else
			if WAR.LXZT[eid] == nil then
			  WAR.LXZT[eid] = math.modf((hurt) / 5)
			else
			  WAR.LXZT[eid] = WAR.LXZT[eid] + math.modf((hurt) / 5)
			end
			WAR.LXXS[eid] = 1
			if 100 < WAR.LXZT[eid] then
				WAR.LXZT[eid] = 100
			end
		end
  end
  
  --蓝烟清：水笙攻击迟缓计算
  --龙象蓄力攻击也会造成迟缓
  --寒冰绵掌和雪山剑法，会对敌人造成迟缓
  if (WAR.L_SSBD == 1 or WAR.L_LXXL == 1 or wugong == 5 or wugong == 35 or WAR.L_WYJFA == 31) and hurt > 0 and WAR.Person[enemyid]["我方"] ~= WAR.Person[WAR.CurID]["我方"] then
  	if WAR.CHZ[eid] == nil then
      WAR.CHZ[eid] = math.modf((hurt) / 5)
    else
      WAR.CHZ[eid] = WAR.CHZ[eid] + math.modf((hurt) / 5)
    end
    if 100 < WAR.CHZ[eid] then
    	WAR.CHZ[eid] = 100
  	end
  	
  end
  
  
  WAR.BLX = 0

	--怒气值计算
	--蓝烟清：新逆运走火，不会暴气
  if WAR.L_NYZH[eid] == nil and 0 < JY.Person[eid]["生命"] and hurt > 0 and (WAR.LQZ[eid] == nil or WAR.LQZ[eid] < 100) and DWPD() and WAR.DZXY ~= 1 and WAR.ASKD ~= 1 then
    local minlqzj = math.modf((hurt) / 3 * 0.2 + 1)
    local lqzj = math.random(math.modf((hurt) / 3) + 1)
    if lqzj < minlqzj then
      lqzj = minlqzj
    end
    
    --敌人难度下额外增加的怒气值
    if WAR.Person[enemyid]["我方"] == false then
      local flqzj = 0
      if JY.Thing[202][WZ7] == 1 then
        flqzj = 1
      elseif JY.Thing[202][WZ7] == 2 then
        flqzj = 8
      else
        flqzj = 12 + JY.Thing[202][WZ7]
      end
      lqzj = lqzj + flqzj;
    end
    
    --太玄神功加力时，反杀怒气值
    if WAR.L_SGJL == 102 then 
	    if WAR.LQZ[eid] ~= nil then
	      WAR.LQZ[eid] = WAR.LQZ[eid] - lqzj
	    end
	  else
	  	if WAR.LQZ[eid] == nil then
	      WAR.LQZ[eid] = lqzj + 2
	    else
	      WAR.LQZ[eid] = WAR.LQZ[eid] + lqzj + 2
	    end
	  end
	  
	  if WAR.LQZ[eid] ~= nil and WAR.LQZ[eid] <= 0 then
	  	WAR.LQZ[eid] = nil;
	  end
    
    --怒气暴发
	  if WAR.LQZ[eid] ~=  nil and 100 < WAR.LQZ[eid] then
	    WAR.LQZ[eid] = 100
	    WAR.Person[enemyid]["特效动画"] = 6
	    if WAR.Person[enemyid]["特效文字3"] ~= nil then
	      WAR.Person[enemyid]["特效文字3"] = WAR.Person[enemyid]["特效文字3"] .. "+怒气爆发"
	    else
	    	WAR.Person[enemyid]["特效文字3"] = "怒气爆发"
	  	end
	  end
  end
  
  
  
  if WAR.ASKD == 1 and DWPD() then
    WAR.LQZ[eid] = 0
  end
  
  --血刀老祖 迷惑，减少为40%
  if pid == 97 and math.random(10) < 4 and WAR.Person[enemyid]["我方"] ~= WAR.Person[WAR.CurID]["我方"] then
    WAR.Person[enemyid]["我方"] = WAR.Person[WAR.CurID]["我方"]
  end
  
  --主角选择豪门护符攻击有机率迷惑
  if pid == JY.MY and GetS(53, 0, 2, 5) == 2 and WAR.Person[enemyid]["我方"] ~= WAR.Person[WAR.CurID]["我方"] and (JY.Person[eid]["内力最大值"]-600 * JY.Thing[202][WZ7]) < 1000 then
    local rate = (JY.Person[pid]["资质"] - 2*JY.Person[eid]["资质"])/10 + (JY.Person[pid]["内力"] - 3*JY.Person[eid]["内力"])/600 + JY.Person[pid]["声望"]/20 + JY.Thing[238]["需经验"]/50 ;
    if JLSD(0,rate,pid) or (GetS(53, 0, 4, 5) == 1 and JLSD(0,10,pid)) then
    	if JLSD(0,30-JY.Thing[202][WZ7]*5,pid)  then
    		say("$$钱~~~~钱~~~",WAR.tmp[5000+enemyid],0,WAR.tmp[5500+enemyid]);
    		WAR.Person[enemyid]["我方"] = WAR.Person[WAR.CurID]["我方"]
    	elseif JLSD(0,30,pid) then
    		say("Ｒ纨绔子弟~~~不足道哉~~~",WAR.tmp[5000+enemyid],0,WAR.tmp[5500+enemyid]);
    	end
    end
    
    
  end
  
  --成不忧 被令狐冲 秒杀
  if WAR.ZDDH == 205 and eid == 141 then
  	WAR.Person[enemyid]["生命点数"] = -JY.Person[eid]["生命"];
    JY.Person[eid]["生命"] = 0
  end
  
  --游坦之 上毒
  if pid == 48 then
    local d = math.modf((340 - JY.Person[eid]["抗毒能力"] - JY.Person[eid]["内力"] / 50) / 4)
    if d < 0 then
      d = 0
    end
    WAR.Person[enemyid]["中毒点数"] = (WAR.Person[enemyid]["中毒点数"] or 0) + AddPersonAttrib(eid, "中毒程度", d);
  end
  
  --蓝烟清：铁掌，高机率造成固定内伤20点
  if wugong == 13 and JLSD(30, 90, pid) then
  	AddPersonAttrib(eid, "受伤程度", 20);
  end
  
  --蓝烟清：玄冥神掌，保持阴内，有机率造成内伤和无视上毒10点
  if wugong == 21 and JY.Person[pid]["内力性质"] == 0 then
  	local jl = 40;
  	for i=1, 10 do
  		if JY.Person[pid]["武功"..i] == 3 or JY.Person[pid]["武功"..i] == 5 then
  			jl = jl + 15;
  		end
  	end
  	if JLSD(10, 10+jl) then
  		AddPersonAttrib(eid, "受伤程度", 10);
  		WAR.Person[enemyid]["中毒点数"] = (WAR.Person[enemyid]["中毒点数"] or 0) + AddPersonAttrib(eid, "中毒程度", 10);
  	end
  end
  
  
  --乾坤反弹伤害
  if eid == -1 then
	  local x, y = nil, nil
	  while true do
		  x = math.random(63)
		  y = math.random(63)
		  if not SceneCanPass(x, y) or GetWarMap(x, y, 2) < 0 then
		    SetWarMap(WAR.Person[enemyid]["坐标X"], WAR.Person[enemyid]["坐标Y"], 2, -1)
		    SetWarMap(WAR.Person[enemyid]["坐标X"], WAR.Person[enemyid]["坐标Y"], 5, -1)
		    WAR.Person[enemyid]["坐标X"] = x
		    WAR.Person[enemyid]["坐标Y"] = y
		    SetWarMap(WAR.Person[enemyid]["坐标X"], WAR.Person[enemyid]["坐标Y"], 2, enemyid)
		    SetWarMap(WAR.Person[enemyid]["坐标X"], WAR.Person[enemyid]["坐标Y"], 5, WAR.Person[enemyid]["贴图"])
		    break;
		  end
		end
  end
  
  --判断是否可以加实战
  if JY.Person[eid]["生命"] <= 0 and inteam(pid) and DWPD() and WAR.SZJPYX[eid] == nil then
    
    --崆峒派战斗、高升客栈杀欧阳克、家里练功房、全真教练功、青城派练功、少林练功   不加实战
    local wxzd = {17, 67, 226, 220, 224, 219, 79}
    local wx = 0
    for i = 1, 7 do
      if WAR.ZDDH == wxzd[i] then
        wx = 1
      end
    end
    
    --丐帮门口
    if WAR.ZDDH == 82 and GetS(10, 0, 18, 0) == 1 then
      wx = 1
    end
    --木人巷
    if WAR.ZDDH == 214 and GetS(10, 0, 19, 0) == 1 then
      wx = 1
    end
    
    --如果可加实战
    if wx == 0 then
      for i = 1, #TeamP do
        if pid == TeamP[i] then
          local szexp = 1
          if eid < 191 and 0 < eid then
            szexp = WARSZJY[eid]
          end
          SetS(5, i, 6, 5, GetS(5, i, 6, 5) + szexp)
          WAR.SZJPYX[eid] = 1
        end
      end
    end
  end
  
  --平一指杀人
  if JY.Person[eid]["生命"] <= 0 and pid == 28 then
    WAR.PYZ = WAR.PYZ + 1
    if 10 < WAR.PYZ then
    	WAR.PYZ = 10
  	end
  end
  
  
  --北冥神功和吸星大法，加内力上限
  if (WAR.BMXH == 1 or WAR.BMXH == 2) and 0 < hurt and DWPD() and wugong ~= 92 then
    local xnl = nil
    xnl = math.modf(JY.Person[eid]["内力"] / 12 + math.random(10))	--brolycjw: 改
    WAR.Person[enemyid]["内力点数"] = (WAR.Person[enemyid]["内力点数"] or 0) + AddPersonAttrib(eid, "内力", -xnl);
    WAR.Person[WAR.CurID]["内力点数"] = (WAR.Person[WAR.CurID]["内力点数"] or 0) + AddPersonAttrib(pid, "内力", math.modf(xnl + 1))
    AddPersonAttrib(pid, "内力最大值", math.modf(xnl * 2 / 3 + 10))
  end
  
  
  
  --化功大法 上毒 减内力
  if WAR.BMXH == 3 and 0 < hurt and DWPD() then
    local xnl = nil
    xnl = math.modf(JY.Person[eid]["内力"] / 20 + 2)
    
    WAR.Person[enemyid]["内力点数"] = AddPersonAttrib(eid, "内力", -xnl);
    WAR.Person[enemyid]["中毒点数"] = AddPersonAttrib(eid, "中毒程度", 20)
  end
  
  --吸星大法 吸体力
  if WAR.BMXH == 2 and 0 < hurt and DWPD() then
    local xt1 = Rnd(3) + 2
    local xt2 = Rnd(5) + 6
    local xt3 = 2 + Rnd(2)
    local n = AddPersonAttrib(eid, "体力", -xt1)
    local m = AddPersonAttrib(pid, "体力", xt3)
    
    --任我行 额外吸体力
    if pid == 26 then
    	n = n + AddPersonAttrib(eid, "体力", -xt2)
    	m = m + AddPersonAttrib(pid, "体力", xt2)
  	end
  	
  	WAR.Person[enemyid]["体力点数"] = (WAR.Person[enemyid]["体力点数"] or 0) + n;
  	WAR.Person[WAR.CurID]["体力点数"] = (WAR.Person[WAR.CurID]["体力点数"] or 0) + m;
  end
  
  --无名刀
  if wugong == 64 and pid == 0 and GetS(4, 5, 5, 5) == 3 and 0 < hurt and WAR.XXCC == 0 then
    for i = 1, 10 do
      if JY.Person[0]["武功" .. i] == 64 and JY.Person[0]["武功等级" .. i] == 999 then
        SetS(14, 3, 1, 4, GetS(14, 3, 1, 4) + 5 + math.random(5))
        if 600 < GetS(14, 3, 1, 4) then
          SetS(14, 3, 1, 4, 600)
        end
        if JY.Person[0]["耍刀技巧"] * 10 - 900 < GetS(14, 3, 1, 4) then
          SetS(14, 3, 1, 4, limitX(JY.Person[0]["耍刀技巧"] * 10 - 900,0))
        end
        WAR.XXCC = 1
      end
    end
  end
  
  --蓝烟清：雷震剑法，每次攻击会累加
  if wugong == 28 and DWPD() and  0 < hurt and WAR.L_LZJFCC == 0 then
  	if WAR.L_LZJF_ATK[pid] ~= nil then
  		WAR.L_LZJF_ATK[pid] = WAR.L_LZJF_ATK[pid] + 50
  	else
  		WAR.L_LZJF_ATK[pid] = 50;
  	end
  	if WAR.L_LZJF_ATK[pid] > 300 then
  		WAR.L_LZJF_ATK[pid] = 300;
  	end
  	WAR.L_LZJFCC = 1;
  end
  
  --蓝烟清：柔云剑法，每次攻击会累加，最多累加五次
  if wugong == 36 and DWPD() and  0 < hurt and WAR.L_RYJFCC == 0 then
  	if WAR.L_RYJF[pid] ~= nil then
  		WAR.L_RYJF[pid] = WAR.L_RYJF[pid] + 1
  	else
  		WAR.L_RYJF[pid] = 1;
  	end
  	if WAR.L_RYJF[pid] > 5 then
  		WAR.L_RYJF[pid] = 5;
  	end
  	WAR.L_RYJFCC = 1;
  end
  
  
  if WAR.TZ_XZ == 1 and DWPD() then
    WAR.TZ_XZ_SSH[eid] = 1
  end
  
  --中毒计算
  local poisonnum = math.modf(level * JY.Wugong[wugong]["敌人中毒点数"] + 5 * JY.Person[pid]["攻击带毒"])
  if JY.Person[eid]["抗毒能力"] < poisonnum and dng == 0 and pid ~= 48 and WAR.Person[WAR.CurID]["我方"] ~= WAR.Person[enemyid]["我方"] then
  	if WAR.Person[enemyid]["我方"] then
  		poisonnum = math.modf(poisonnum / 10 - JY.Person[eid]["抗毒能力"]/10 - JY.Person[eid]["内力"] / 200)
  	else
  		poisonnum = math.modf(poisonnum / 15 - JY.Person[eid]["抗毒能力"]/5 - JY.Person[eid]["内力"] / 150)
  	end
    if poisonnum < 0 then
      poisonnum = 0
    end
    WAR.Person[enemyid]["中毒点数"] = (WAR.Person[enemyid]["中毒点数"] or 0) + AddPersonAttrib(eid, "中毒程度", myrnd(poisonnum))
    --Alungky: 取消中毒的小数点
    WAR.Person[enemyid]["中毒点数"] = math.modf(WAR.Person[enemyid]["中毒点数"]);
  end
  
  --蓝烟清：发动蟾震九天时中毒40点
  if WAR.L_CZJT == 1 then
  	
  	local n = 30;		--最低30点
  	n = n + math.modf((WAR.tmp[200 + pid]-100)/10);		--超过100之后每10点蓄力值增加1点中毒
  	WAR.tmp[200 + pid] = 0
  	
  	--如果学了白驼雪山掌，上毒效果加倍
  	if PersonKFJ(pid, 9) then
  		n = n + math.modf(n/2);
  		
  	end
  	
  	WAR.Person[enemyid]["中毒点数"] = (WAR.Person[enemyid]["中毒点数"] or 0 ) + AddPersonAttrib(eid, "中毒程度", n);
  end
  
  WAR.NGHT = 0
  WAR.FLHS4 = 0
  
  WAR.L_SGHT = 0;

  
  if WAR.Person[enemyid]["特效文字2"] == nil then
    WAR.Person[enemyid]["特效文字2"] = "  "
  end
  if DWPD() == false then
    WAR.Person[enemyid]["特效动画"] = -1
    WAR.Person[enemyid]["特效文字0"] = nil
    WAR.Person[enemyid]["特效文字1"] = nil
    WAR.Person[enemyid]["特效文字2"] = nil
    WAR.Person[enemyid]["特效文字3"] = nil
  end
  
  
  --护符增加经验
  if eid == JY.MY and GetS(53, 0, 2, 5) == 2 and WAR.Person[enemyid]["我方"] ~= WAR.Person[WAR.CurID]["我方"] then
  	if WAR.tmp[8002] == nil then
  		WAR.tmp[8002] = 0;
  	end
  	WAR.tmp[8002] = WAR.tmp[8002] + math.modf(hurt/100) + limitX(-WAR.Person[enemyid].TimeAdd/100,0,3);
  end
  
  --宗师，被攻击时，下回合提升集气速度
  if eid == JY.MY and GetS(53, 0, 2, 5) == 3 and WAR.Person[enemyid]["我方"] ~= WAR.Person[WAR.CurID]["我方"] and hurt > 0 then
  	local rate = limitX(hurt/10,0,40) + JY.Person[eid]["武学常识"]/5 + JY.Person[eid]["声望"]/10 + JY.Person[eid]["内力"]/400;
  	if rate > math.random(100) or 30 > math.random(100) then
  		if WAR.tmp[8003] == nil then
  			WAR.tmp[8003] = 1;
  		elseif GetS(53, 0, 4, 5) == 1 then
  			WAR.tmp[8003] = WAR.tmp[8003]+1;
  		end
  		WAR.Person[enemyid]["特效动画"] = 90;
  		WAR.Person[enemyid]["特效文字2"] = "伺机而动";
  		
  	end
  end
  
  
  return limitX(hurt, 0, hurt);
end

--绘画战斗地图
function WarDrawMap(flag, v1, v2, v3, v4, v5, ex, ey)
  local x = WAR.Person[WAR.CurID]["坐标X"]
  local y = WAR.Person[WAR.CurID]["坐标Y"]
  if not v4 then
    v4 = JY.SubScene
  end
	if not v5 then
		v5 = -1;
	end
  
  if flag == 0 then
    lib.DrawWarMap(0, x, y, 0, 0, -1, v4)
  elseif flag == 1 then
    if v4 == 0 or v4 == 2 or v4 == 3 or v4 == 4 or v4 == 39 then
      lib.DrawWarMap(1, x, y, v1, v2, -1, v4)
    else
      lib.DrawWarMap(2, x, y, v1, v2, -1, v4)
    end
  elseif flag == 2 then
    lib.DrawWarMap(3, x, y, 0, 0, -1, v4)
  elseif flag == 4 then
    lib.DrawWarMap(4, x, y, v1, v2, v3, v4,v5, ex, ey)
  end
  
  if WAR.ShowHead == 1 then
    WarShowHead()
  end
  
  
end

--敌方战斗数据
function WarSelectEnemy()


  if PNLBD[WAR.ZDDH] ~= nil then
    PNLBD[WAR.ZDDH]()
  end
  
  
  --日本战数据  
  for i = 1, 20 do
    if WAR.Data["敌人" .. i] > 0 then
    	if WAR.ZDDH == 137 then
    		if GetS(86, 10, 10, 5) == 1 then			--蓝烟清：杀宝象
    			WAR.Data["敌人" .. i] = 9999;
    		elseif GetS(86, 10, 10, 5) == 2 then	--蓝烟清：杀戚长发
    			WAR.Data["敌人" .. i] = 9999;
    		end
    	end
    	
    	if WAR.ZDDH == 226 and GetS(86, 1, 9, 5) == 1 then		--把练功点改成挑战四神组合
    		if GetS(86, 2, 1, 5) == 3 then				--张三丰和乔峰
    			WAR.Data["敌人1"] = 5;
    			WAR.Data["敌人2"] = 50;
    		elseif GetS(86, 2, 2, 5) == 3 then		--张三丰和东方不败
    			WAR.Data["敌人1"] = 5;
    			WAR.Data["敌人2"] = 27;
    		elseif GetS(86, 2, 3, 5) == 3 then		--张三丰和扫地神僧
    			WAR.Data["敌人1"] = 5;
    			WAR.Data["敌人2"] = 114;
    		elseif GetS(86, 2, 4, 5) == 3 then		--乔峰和东方不败
    			WAR.Data["敌人1"] = 50;
    			WAR.Data["敌人2"] = 27;
    		elseif GetS(86, 2, 5, 5) == 3 then		--乔峰和扫地神僧
    			WAR.Data["敌人1"] = 50;
    			WAR.Data["敌人2"] = 114;
    		elseif GetS(86, 2, 6, 5) == 3 then		--东方不败和扫地神僧
    			WAR.Data["敌人1"] = 27;
    			WAR.Data["敌人2"] = 114;
    		elseif GetS(86, 2, 7, 5) == 3 then		--张三丰、东方不败和扫地神僧
    			WAR.Data["敌人1"] = 5;
    			WAR.Data["敌人2"] = 27;
    			WAR.Data["敌人3"] = 114;
    		elseif GetS(86, 2, 8, 5) == 3 then		--张三丰、乔峰和扫地神僧
    			WAR.Data["敌人1"] = 5;
    			WAR.Data["敌人2"] = 50;
    			WAR.Data["敌人3"] = 114;
    		elseif GetS(86, 2, 9, 5) == 3 then		--张三丰、乔峰和东方不败
    			WAR.Data["敌人1"] = 5;
    			WAR.Data["敌人2"] = 50;
    			WAR.Data["敌人3"] = 27;
    		elseif GetS(86, 2, 10, 5) == 3 then		--乔峰、东方不败和扫地神僧
    			WAR.Data["敌人1"] = 50;
    			WAR.Data["敌人2"] = 27;
    			WAR.Data["敌人3"] = 114;
    		end
    		
    		WAR.Data["敌方X1"] = 45;
				WAR.Data["敌方Y1"] = 36;
				WAR.Data["敌方X2"] = 45;
				WAR.Data["敌方Y2"] = 28;
				WAR.Data["敌方X3"] = 52;
				WAR.Data["敌方Y3"] = 28;
				WAR.Data["敌方X4"] = 52;
				WAR.Data["敌方Y4"] = 36;
    	end
    	
		if WAR.ZDDH == 226 and GetS(86,20,20,5) == 3 then		--brolycjw：战欧阳锋鸠摩智		
				WAR.Data["敌人1"] = 60;
				WAR.Data["敌人2"] = 103;
				SetS(86,20,20,5,0);	--临时存放
		end
		
		if WAR.ZDDH == 79 then
    		if GetS(86, 11, 12, 5) == 1 then			--brolycjw：杀金轮
    			WAR.Data["敌人1"] = 62;
					WAR.Data["敌方X1"] = 21
					WAR.Data["敌方Y1"] = 30
				elseif GetS(86,15,2,5) > 0 then
	    		if GetS(86,15,2,5) == 1 then			--队友初级挑战
						local enemy = {3,184,67,98,118,164}
						local pick = math.random(6)
						WAR.Data["敌人1"] = enemy[pick]
					elseif GetS(86,15,2,5) == 2 then			--队友中级挑战
						local enemy = {62,65,71,103,69,6}
						local pick = math.random(6)
						WAR.Data["敌人1"] = enemy[pick]
					elseif GetS(86,15,2,5) == 3 then			--队友高级挑战
						local enemy = {129,64,26,60,57}
						local pick = math.random(5)
						WAR.Data["敌人1"] = enemy[pick]
					elseif GetS(86,15,2,5) == 4 then			--队友神级挑战
						local enemy = {5,27,50,114}
						local pick = math.random(4)
						WAR.Data["敌人1"] = enemy[pick]			
					end
					
					WAR.Data["敌方X1"] = 45;
					WAR.Data["敌方Y1"] = 15;
				end
    	end
    	
    if WAR.ZDDH == 185 then				--brolycjw：战
			WAR.Data["敌人14"] = 65;
			WAR.Data["敌方X14"] = 44
			WAR.Data["敌方Y14"] = 22
			WAR.Data["敌人15"] = 55;
			WAR.Data["敌人16"] = 56;
			WAR.Data["敌方X15"] = 44
			WAR.Data["敌方Y15"] = 23
			WAR.Data["敌方X16"] = 44
			WAR.Data["敌方Y16"] = 24			
		end
		if WAR.ZDDH == 170 then
			if GetS(86,20,20,5) == 1 then			--brolycjw：战谢烟客
    			WAR.Data["敌人1"] = 164;
				for i = 2, 5 do
					WAR.Data["敌人".. i] = -1;
				end
			elseif GetS(86,20,20,5) == 2 then			--brolycjw：战龙木岛主
    			WAR.Data["敌人3"] = 38;
				WAR.Data["敌人4"] = -1;
				WAR.Data["敌人5"] = -1;
			else
				WAR.Data["敌人5"] = -1;
			end
		end
    	if WAR.ZDDH == 92 and GetS(87,31,33,5) == 1 then		--冰糖恋：单挑陈达海
     		for i=2,5 do	
	 				WAR.Data["敌人" .. i] = -1;
     		end
			end
			
			--冰糖恋：单挑瓦尔拉齐
			if WAR.ZDDH == 91 and GetS(87,31,34,5) == 1 then
				WAR.Data["敌人1"] = 138
		    for i=2,12 do
			 		WAR.Data["敌人" .. i] = -1;
		    end
			end

			if WAR.ZDDH == 20 and GetS(87,31,35,5) == 1 then
   		 	WAR.Data["敌人1"] = 9999;--临时人物数据代替心魔 
   		end
   		
			if WAR.ZDDH == 20 and GetS(87,31,35,5) == 2 then
				WAR.Data["敌人1"] = 92
			end

			
			--蓝烟清：重新摆十八铜人的位置，单挑时的位置
			if WAR.ZDDH == 217 and GetS(86,1,2,5) == 1 then
				--把三个铜人放在门口位置
				WAR.Data["敌方X16"] = 40
				WAR.Data["敌方Y16"] = 40
				
				WAR.Data["敌方X17"] = 40
				WAR.Data["敌方Y17"] = 38
				
				WAR.Data["敌方X18"] = 40
				WAR.Data["敌方Y18"] = 42
			end
			
			--蓝烟清：重新摆十八铜人的位置，群战时的位置
			if WAR.ZDDH == 217 and GetS(86,1,2,5) == 2 then
				for i=1,9 do
					WAR.Data["敌方X" .. i] = 22
					WAR.Data["敌方Y" .. i] = 32 + i;
				end
				
				for i=10, 18 do
					WAR.Data["敌方X" .. i] = 27
					WAR.Data["敌方Y" .. i] = 32 + (i-9);
				end
			end
			
			
			
			
			
			--蓝烟清：难度3，敌方小兵武功等级随机为极
			if JY.Thing[202][WZ7] > 2 then
				if JY.Person[WAR.Data["敌人" .. i]]["武功等级1"] ~= 999 then
					if math.random(1) then
						JY.Person[WAR.Data["敌人" .. i]]["武功等级1"] = 999;
					end
				end
			end
			
    	WAR.Person[WAR.PersonNum]["人物编号"] = WAR.Data["敌人" .. i]
      WAR.Person[WAR.PersonNum]["我方"] = false
      WAR.Person[WAR.PersonNum]["坐标X"] = WAR.Data["敌方X" .. i]
      WAR.Person[WAR.PersonNum]["坐标Y"] = WAR.Data["敌方Y" .. i]
      WAR.Person[WAR.PersonNum]["死亡"] = false
      WAR.Person[WAR.PersonNum]["人方向"] = 1
      WAR.PersonNum = WAR.PersonNum + 1
    end
  end
end--战斗人物选择
function WarSelectTeam()
  WAR.PersonNum = 0
  
  
  --brolycjw：自定义自动选择参战人
  --设置了之后，会直接战斗，而不可以选择队友
  if WAR.ZDDH == 79 then				--战斗编号
	if GetS(86, 11, 12, 5) == 1 then			--brolycjw：杀金轮
		WAR.Data["自动选择参战人1"] = 0;
		WAR.Data["我方X1"] = 22
		WAR.Data["我方Y1"] = 38
		
		WAR.Data["自动选择参战人2"] = 59;
		WAR.Data["我方X2"] = 23
		WAR.Data["我方Y2"] = 38

	elseif GetS(86,15,2,5) > 0 then
		WAR.Data["自动选择参战人1"] = GetS(86,15,1,5);
	end
  end
  
  --冰糖恋：单挑陈达海
	if WAR.ZDDH == 92 and GetS(87,31,33,5) == 1 then
	  	WAR.Data["自动选择参战人1"] = 0;
	  	WAR.Data["我方X1"] = 43
	  	WAR.Data["我方Y1"] = 25
	end
	
	--冰糖恋：单挑瓦尔拉齐
	if WAR.ZDDH == 91 and GetS(87,31,34,5) == 1 then
  	WAR.Data["自动选择参战人1"] = 0;
  	WAR.Data["我方X1"] = 21
  	WAR.Data["我方Y1"] = 28
	end
	
	
	--蓝烟清：重新摆十八铜人，群战，我方的位置
	if WAR.ZDDH == 217 and GetS(86,1,2,5) == 2 then
		for i=1, 6 do
			WAR.Data["我方X" .. i] = 25;
			if i < 4 then
				WAR.Data["我方Y" .. i] = 38 - i
			else
				WAR.Data["我方Y" .. i] = 38 + (i-4)
			end
		end
	end
	
	--挑战四神，我方位置
	if WAR.ZDDH == 226 and GetS(86, 1, 9, 5) == 1 then
		for i=1, 6 do
			WAR.Data["我方X" .. i] = 48;
			if i < 4 then
				WAR.Data["我方Y" .. i] = 34 - i;
			else
				WAR.Data["我方Y" .. i] = 34 + (i-4)
			end
		end
	end
	
	--队友挑战，我方位置
	if WAR.ZDDH == 79 then
		if GetS(86,15,2,5) > 0 then
			WAR.Data["我方X1"] = 51;
			WAR.Data["我方Y1"] = 15;
		end
		
	end

  
  for i = 1, 6 do
    local id = WAR.Data["自动选择参战人" .. i]
    if id >= 0 then
      WAR.Person[WAR.PersonNum]["人物编号"] = id
      WAR.Person[WAR.PersonNum]["我方"] = true
      WAR.Person[WAR.PersonNum]["坐标X"] = WAR.Data["我方X" .. i]
      WAR.Person[WAR.PersonNum]["坐标Y"] = WAR.Data["我方Y" .. i]
      WAR.Person[WAR.PersonNum]["死亡"] = false
      WAR.Person[WAR.PersonNum]["人方向"] = 2
      WAR.PersonNum = WAR.PersonNum + 1
    end
  end
  
  --蓝烟清：群战十八铜人战
  if WAR.ZDDH == 217 and GetS(86,1,2,5) == 2 then
  	WAR.PersonNum = 0;
  end
  
  if WAR.PersonNum > 0 and WAR.ZDDH ~= 235 then
    return 
  end
  
  for i = 1, CC.TeamNum do
    WAR.SelectPerson[i] = 0
    local id = JY.Base["队伍" .. i]
    if id >= 0 then
      for j = 1, 6 do
        if WAR.Data["手动选择参战人" .. j] == id then
          WAR.SelectPerson[i] = 1
        end
      end
    end
  end
  
  
  local menu = {}
  for i = 1, CC.TeamNum do
    menu[i] = {"", WarSelectMenu, 0}
    local id = JY.Base["队伍" .. i]
    if id >= 0 then
      menu[i][3] = 1
      local s = JY.Person[id]["姓名"]
      if WAR.SelectPerson[i] == 1 then
        menu[i][1] = "*" .. s
      else
     		menu[i][1] = " " .. s
      end
    end
  end
  
  menu[CC.TeamNum + 1] = {" 结束", nil, 1}
  
  while true do
    Cls()
    local x = (CC.ScreenW - 7 * CC.DefaultFont - 2 * CC.MenuBorderPixel) / 2
    DrawStrBox(x, 10, "请选择参战人物", C_WHITE, CC.DefaultFont)
    local r = ShowMenu(menu, CC.TeamNum + 1, 0, x, 10 + CC.SingleLineHeight, 0, 0, 1, 0, CC.DefaultFont, C_ORANGE, C_WHITE)
    Cls()
    for i = 1, 6 do
      if WAR.SelectPerson[i] > 0 then
        WAR.Person[WAR.PersonNum]["人物编号"] = JY.Base["队伍" .. i]
        WAR.Person[WAR.PersonNum]["我方"] = true
        WAR.Person[WAR.PersonNum]["坐标X"] = WAR.Data["我方X" .. i]
        WAR.Person[WAR.PersonNum]["坐标Y"] = WAR.Data["我方Y" .. i]
        WAR.Person[WAR.PersonNum]["死亡"] = false
        WAR.Person[WAR.PersonNum]["人方向"] = 2
        WAR.PersonNum = WAR.PersonNum + 1
      end
    end
    if WAR.PersonNum > 0 then
      break;
    end
  end
end




--计算战斗人物贴图
function WarCalPersonPic(id)
  local n = 5106
  n = n + JY.Person[WAR.Person[id]["人物编号"]]["头像代号"] * 8 + WAR.Person[id]["人方向"] * 2
  return n
end
--已方战斗时选择人物的菜单
function WarSelectMenu(newmenu, newid)
  local id = newmenu[newid][4]
  if WAR.SelectPerson[id] == 0 then
    WAR.SelectPerson[id] = 2
  else
    if WAR.SelectPerson[id] == 2 then
      WAR.SelectPerson[id] = 0
    end
  end
  if WAR.SelectPerson[id] > 0 then
    newmenu[newid][1] = "*" .. string.sub(newmenu[newid][1], 2)
  else
    newmenu[newid][1] = " " .. string.sub(newmenu[newid][1], 2)
  end
  return 0
end
-- 战斗是否结束
function War_isEnd()
  for i = 0, WAR.PersonNum - 1 do
    if JY.Person[WAR.Person[i]["人物编号"]]["生命"] <= 0 then
      WAR.Person[i]["死亡"] = true
    end
  end
  WarSetPerson()
  Cls()
  ShowScreen()
  local myNum = 0
  local EmenyNum = 0
  for i = 0, WAR.PersonNum - 1 do
    if WAR.Person[i]["死亡"] == false then
      if WAR.Person[i]["我方"] == true then
        myNum = 1
      else
				EmenyNum = 1
			end
    end
  end

  if EmenyNum == 0 then
    return 1;
  end
  if myNum == 0 then
  	return 2;
  end
  return 0
end

--设置战斗全局变量
function WarSetGlobal()
  WAR = {}
  WAR.Data = {}
  WAR.SelectPerson = {}
  WAR.Person = {}
  for i = 0, 30 do
    WAR.Person[i] = {}
    WAR.Person[i]["人物编号"] = -1
    WAR.Person[i]["我方"] = true
    WAR.Person[i]["坐标X"] = -1
    WAR.Person[i]["坐标Y"] = -1
    WAR.Person[i]["死亡"] = true
    WAR.Person[i]["人方向"] = -1
    WAR.Person[i]["贴图"] = -1
    WAR.Person[i]["贴图类型"] = 0
    WAR.Person[i]["轻功"] = 0
    WAR.Person[i]["移动步数"] = 0
    WAR.Person[i]["经验"] = 0
    WAR.Person[i]["自动选择对手"] = -1
    WAR.Person[i].Move = {}
    WAR.Person[i].Action = {}
    WAR.Person[i].Time = 0
    WAR.Person[i].TimeAdd = 0
    WAR.Person[i].SpdAdd = 0
    WAR.Person[i].Point = 0
    WAR.Person[i]["特效动画"] = -1
    WAR.Person[i]["反击武功"] = -1
    WAR.Person[i]["特效文字1"] = nil
    WAR.Person[i]["特效文字2"] = nil
    WAR.Person[i]["特效文字3"] = nil
  end
  WAR.PersonNum = 0
  WAR.AutoFight = 0
  WAR.CurID = -1
  WAR.SXTJ = 0
  WAR.WGWL = 0
  WAR.EVENT1 = 0
  WAR.ZYHB = 0
  WAR.ZYHBP = -1
  WAR.BJ = 0
  WAR.XK = 0
  WAR.XK2 = nil
  WAR.TD = -1
  WAR.HTSS = 0
  WAR.YTFS = 0
  WAR.SQFJ = 0
  WAR.YT1 = 0
  WAR.YT2 = 0
  WAR.ZSF = 0
  WAR.ZSF2 = 0
  WAR.XZZ = 0
  WAR.WCY = 0
  WAR.MCF = 0
  WAR.FS = 0
  WAR.DYSZ = 0
  WAR.TFH = 0
  WAR.WQQ = 0
  WAR.ZBT = 1
  WAR.HQT = 0
  WAR.CY = 0
  WAR.HDWZ = 0
  WAR.ZJZ = 0
  WAR.TGN = 0
  WAR.YJ = 0
  WAR.XMH = 0
  WAR.PYZ = 0
  WAR.YZB = 0
  WAR.YZB2 = 0
  WAR.YZB3 = 0
  WAR.GBWZ = 0
  WAR.SSQX = 0
  WAR.BSMT = 0
  WAR.XDLZ = 0
  WAR.DJGZ = 0
  WAR.XDDF = 0
  WAR.XXCC = 0
  WAR.XDXX = 0
  WAR.WS = 0
  WAR.ACT = 1
  WAR.ZDDH = -1
  WAR.NO1 = -1
  WAR.TJAY = 0
  WAR.DZXY = 0
  WAR.DZXYLV = {}
  WAR.QKNY = 0
  WAR.fthurt = 0
  WAR.NYSH = {}
  WAR.LXZQ = 0
  WAR.JSYX = 0
  WAR.ASKD = 0
  WAR.GCTJ = 0
  WAR.JSTG = 0
  WAR.FLHS1 = 0
  WAR.FLHS2 = 0
  WAR.FLHS4 = 0
  WAR.FLHS5 = 0
  WAR.FLHS6 = 0
  WAR.NGJL = 0
  WAR.NGHT = 0
  WAR.BMXH = 0
  WAR.ZYYD = 0
  WAR.SSFwav = 0
  WAR.LMSJwav = 0
  WAR.JGZ_DMZ = 0
  WAR.LHQ_BNZ = 0
  WAR.ShowHead = 0
  WAR.Effect = 0
  WAR.EffectColor = {}
  WAR.EffectColor[2] = RGB(236, 200, 40)
  WAR.EffectColor[3] = RGB(112, 12, 112)
  WAR.EffectColor[4] = RGB(236, 200, 40)
  WAR.EffectColor[5] = RGB(96, 176, 64)
  WAR.EffectColor[6] = RGB(104, 192, 232)
  WAR.Delay = 0
  WAR.LifeNum = 0
  WAR.EffectXY = nil
  WAR.EffectXYNum = 0
  WAR.tmp = {}
  WAR.Actup = {}
  WAR.Defup = {}
  WAR.KHBX = 0
  WAR.KHCM = {}
  WAR.LQZ = {}
  WAR.FXDS = {}
  WAR.FXXS = {}
  WAR.LXZT = {}
  WAR.CHZ = {}		--自定义迟缓值
  WAR.LXXS = {}
  WAR.SZJPYX = {}
  WAR.TZ_DY = 0
  WAR.TZ_XZ = 0
  WAR.TZ_XZ_SSH = {}
  WAR.BFX = 0
  WAR.BLX = 0

  
  WAR.JYFX = {}			--brolycjw: 九阳封穴
  WAR.L_TLD = 0;		--装备屠龙刀特效，1流血
  WAR.L_YTJ1 = 0;		--装备倚天剑特效，1流血
  WAR.L_YTJ2 = 0;		--装备倚天剑特效，1封穴
  WAR.L_LWX = 0;		--李文秀特色指令，一次战斗仅限一次
  
  WAR.L_SSBD = 0;		--水笙是否发动攻击减速特效
  WAR.L_SGHT = 0;		--是否有神功护体
  WAR.L_SGJL = 0;		--是否有神功加力
  WAR.L_LXXL = 0;		--龙象蓄力攻击，造成迟缓
  WAR.B_BMJQ = 0;		--北冥真气发动
  
  WAR.L_EffectColor = {}		--自定义的战斗颜色显示
  WAR.L_EffectColor[1] = RGB(255, 10, 10);		--显示减少生命
  WAR.L_EffectColor[2] = RGB(247, 212, 215);		--显示增加生命
  WAR.L_EffectColor[3] = RGB(0, 102, 153);		--显示内力减少和增加
  WAR.L_EffectColor[4] = RGB(197, 207, 125);		--显示体力减少和增加
  WAR.L_EffectColor[5] = RGB(255, 236, 150);		--显示封穴
  WAR.L_EffectColor[6] = RGB(255, 236, 150);		--显示流血
  WAR.L_EffectColor[7] = RGB(51, 204, 102);		--显示中毒
  WAR.L_EffectColor[8] = RGB(174, 239, 220);		--显示解毒
  WAR.L_EffectColor[9] = RGB(255, 10, 10);		--显示内伤减少和增加
  
  WAR.L_ZXSG = 0;	 --是否修炼有紫霞神功
  WAR.L_CZJT = 0;	--是否发动蟾震九天
  WAR.L_NYZH = {};		--是否触发逆运走火
  WAR.L_WNGZL = {};		--王难姑指令，持续中毒减血
  WAR.L_HQNZL = {};		--胡青牛指令，持续回血回内伤
  
  WAR.L_TXSG = {};	--记录被太玄神功加力攻击过的敌人
  WAR.L_NOT_MOVE = {};		--记录不可移动的人
  WAR.L_LZJF_ATK = {};		--雷震剑法，每次攻击累加50点攻击力，上限是300点，如果使用其它武功加成攻击力并且攻击累加归0
  WAR.L_LZJFCC = 0			--是否已经累加过雷震剑法
  
  WAR.L_RYJF = {};		--柔云剑法，每次攻击会增加3点连机率，200点杀集气，最多可累加5次。使用其它武功则释放累加值
  WAR.L_RYJFCC = 0;		--是否已经累加过柔云剑法
  WAR.L_QKDNY = {};		--设定攻击多个人时，乾坤只能被反一次
  WAR.L_MJJF = 0;			--灭绝剑法招式
  WAR.L_WYJFA = 0;		--五岳剑法
  WAR.L_NSDF = {};		--南山刀法，有机率使被攻击的单位下回合受到的杀集气和伤害加倍
  WAR.L_NSDFCC = 0;		--南山刀法是否触发特效
  
  
  WAR.L_DGQB_X = 1;		--独孤求败被攻击的X
  WAR.L_DGQB_DEF = 0;		--初始没有，1被拳攻击，2被剑攻击，3被刀攻击，4被特攻击
  WAR.L_DGQB_ZS = {"独孤一式", "独孤二式", "独孤三式", "独孤四式", "独孤五式", "独孤六式","独孤七式", "独孤八式", "独孤九式", "独孤极意·无招胜有招"};
  WAR.L_DGQB_DEF_STR = {"破掌式", "破剑式", "破刀式", "破特式", "破气式"}
  
  WAR.L_DGQB_ZL = 0;		--召唤独孤求败，一次战场只限一次

	WAR.EFT = {}
	WAR.EFTNUM = 0;
  
  --宗师击退开关
  WAR.ZSJT = 1;		--默认打开
	
end


--显示人物的战斗信息，包括头像，生命，内力等
function WarShowHead(id)
  if not id then
    id = WAR.CurID
  end
  if id < 0 then
    return 
  end
  local pid = WAR.Person[id]["人物编号"]
  local p = JY.Person[pid]
  local h = CC.DefaultFont
  local width = CC.Fontsmall*10 + 2 * CC.MenuBorderPixel
  local height = (CC.Fontsmall+CC.RowPixel)*11  + 2 * CC.MenuBorderPixel
  local x1, y1 = nil, nil
  local i = 1
  if WAR.Person[id]["我方"] == true then
    x1 = CC.ScreenW - width - 10
    y1 = CC.ScreenH - height - CC.ScreenH/6
    DrawBox(x1, y1, x1 + width, y1 + height + CC.ScreenH/6, C_WHITE)
  else
    x1 = 10
    y1 = 10
    DrawBox(x1, y1, x1 + width, y1 + height + 30, C_WHITE)
  end
  
  --local headw, headh = lib.PicGetXY(1, p["头像代号"] * 2)
	local headw, headh = lib.GetPNGXY(1, p["头像代号"])
  local headx = (width - headw) / 2
  local heady = (CC.ScreenH/5 - headh) / 2
  if pid == 0 then
    if GetS(4, 5, 5, 5) < 8 then
      --lib.PicLoadCache(1, (280 + GetS(4, 5, 5, 5)) * 2, x1 + 5 + headx, y1 + 5 + heady, 1)
		lib.LoadPNG(1, (280 + GetS(4, 5, 5, 5))*2, x1 + 5 + headx, y1 + 5 + heady, 1)
    else
      --lib.PicLoadCache(1, (287 + GetS(4, 5, 5, 4)) * 2, x1 + 5 + headx, y1 + 5 + heady, 1)
		lib.LoadPNG(1, (287 + GetS(4, 5, 5, 4))*2, x1 + 5 + headx, y1 + 5 + heady, 1)
    end
  else
    --lib.PicLoadCache(1, p["头像代号"] * 2, x1 + 5 + headx, y1 + 5 + heady, 1)
		lib.LoadPNG(1, p["头像代号"]*2, x1 + 5 + headx, y1 + 5 + heady, 1)
  end
  x1 = x1 + CC.RowPixel
  y1 = y1 + CC.RowPixel + CC.ScreenH/6 + h
  local color = nil
  if p["受伤程度"] < p["中毒程度"] then
    if p["中毒程度"] == 0 then
      color = RGB(252, 148, 16)
    elseif p["中毒程度"] < 50 then
      color = RGB(120, 208, 88)
    else
      color = RGB(56, 136, 36)
    end
  elseif p["受伤程度"] < 33 then
    color = RGB(236, 200, 40)
  elseif p["受伤程度"] < 66 then
    color = RGB(244, 128, 32)
  else
    color = RGB(232, 32, 44)
  end
  MyDrawString(x1, x1 + width, y1 + CC.RowPixel, p["姓名"], color, CC.DefaultFont)
  y1 = y1 + CC.DefaultFont + CC.RowPixel
  
  
  
  DrawString(x1 + 3, y1 + CC.RowPixel, "命:", C_ORANGE, CC.Fontsmall)
  DrawString(x1 + 3, y1 + CC.RowPixel + CC.RowPixel + CC.Fontsmall, "内:", C_ORANGE, CC.Fontsmall)
  DrawString(x1 + 3, y1 + CC.RowPixel + 2*(CC.RowPixel + CC.Fontsmall), "体:", C_ORANGE, CC.Fontsmall)
  DrawString(x1 + 3, y1 + CC.RowPixel + 3*(CC.RowPixel + CC.Fontsmall), "气:", C_ORANGE, CC.Fontsmall)
  DrawString(x1 + 3, y1 + CC.RowPixel + 4*(CC.RowPixel + CC.Fontsmall), "毒:", C_ORANGE, CC.Fontsmall)
  

  --颜色条
  local pcx = x1 + 3 + 2*CC.Fontsmall - CC.RowPixel;
  local pcy = y1 + CC.RowPixel
  
  --生命条
  lib.LoadPNG(1, 325 * 2 , pcx  , pcy, 1)
  local pcw, pch = lib.GetPNGXY(1, 324 * 2);
  lib.SetClip(pcx, pcy, pcx + (p["生命"]/p["生命最大值"])*pcw, pcy + pch)
  lib.LoadPNG(1, 324 * 2 , pcx  , pcy, 1,0,0,0,(p["生命"]/p["生命最大值"])*pcw,pch)
  pcy = pcy + CC.RowPixel + CC.Fontsmall
  lib.SetClip(0,0,0,0)
  
  
  --内力条
  lib.LoadPNG(1, 325 * 2 , pcx  , pcy, 1)
  local pcw, pch = lib.GetPNGXY(1, 323 * 2);
  lib.SetClip(pcx, pcy, pcx + (p["内力"]/p["内力最大值"])*pcw, pcy + pch)
  lib.LoadPNG(1, 323 * 2 , pcx  , pcy, 1,0,0,0,(p["内力"]/p["内力最大值"])*pcw,pch)
  pcy = pcy + CC.RowPixel + CC.Fontsmall
  lib.SetClip(0,0,0,0)
  
  --体力条
  lib.LoadPNG(1, 325 * 2 , pcx  , pcy, 1)
  local pcw, pch = lib.GetPNGXY(1, 326 * 2);
  lib.SetClip(pcx, pcy, pcx + (p["体力"]/100)*pcw, pcy + pch)
  lib.LoadPNG(1, 326 * 2 , pcx  , pcy, 1,0,0,0,(p["体力"]/100)*pcw,pch)
  pcy = pcy + CC.RowPixel + CC.Fontsmall
  lib.SetClip(0,0,0,0)
  
  --怒气条
  lib.LoadPNG(1, 325 * 2 , pcx  , pcy, 1)
  local pcw, pch = lib.GetPNGXY(1, 324 * 2);
  lib.SetClip(pcx, pcy, pcx + ((WAR.LQZ[pid] or 0)/100)*pcw, pcy + pch)
  lib.LoadPNG(1, 324 * 2 , pcx  , pcy, 1,0,0,0,((WAR.LQZ[pid] or 0)/100)*pcw,pch)
  pcy = pcy + CC.RowPixel + CC.Fontsmall
  lib.SetClip(0,0,0,0)
  
  --中毒条
  lib.LoadPNG(1, 325 * 2 , pcx  , pcy, 1)
  local pcw, pch = lib.GetPNGXY(1, 322 * 2);
  lib.SetClip(pcx, pcy, pcx + (p["中毒程度"]/100)*pcw, pcy + pch)
  lib.LoadPNG(1, 322 * 2 , pcx  , pcy, 1,0,0,0,(p["中毒程度"]/100)*pcw,pch)
  
  lib.SetClip(0,0,0,0)
  
  local lifexs = p["生命"].."/"..p["生命最大值"]
  local nlxs = p["内力"].."/"..p["内力最大值"]
  local tlxs = p["体力"].."/100"
  local lqzxs = WAR.LQZ[pid] or 0;
  local zdxs = p["中毒程度"]
  
  --已方才显示的
  local nsxs = p["受伤程度"];		--内伤
  local fxxs = WAR.FXDS[pid] or 0;		--封穴
  local lxxs = WAR.LXZT[pid] or 0;		--流血
  local chxs = WAR.CHZ[pid] or 0;		--迟缓
  
  if p["受伤程度"] < 33 then
      color = RGB(236, 200, 40)
    elseif p["受伤程度"] < 66 then
      color = RGB(244, 128, 32)
    else
      color = RGB(232, 32, 44)
    end
  
  DrawString(x1 + 3 + 2*CC.Fontsmall, y1 + CC.RowPixel, lifexs, color, CC.Fontsmall)
  
  	if p["内力性质"] == 0 then
      color = RGB(208, 152, 208)
    elseif p["内力性质"] == 1 then
      color = RGB(236, 200, 40)
    else
      color = RGB(236, 236, 236)
    end
    if GetS(4, 5, 5, 5) == 5 and pid == 0 then
      color = RGB(216, 20, 24)
    end
  
  DrawString(x1 + 3 + 2*CC.Fontsmall, y1 + CC.RowPixel + CC.RowPixel + CC.Fontsmall, nlxs, color, CC.Fontsmall)
  DrawString(x1 + 3 + 2*CC.Fontsmall, y1 + CC.RowPixel + 2*(CC.RowPixel + CC.Fontsmall), tlxs, C_GOLD, CC.Fontsmall)
  DrawString(x1 + 3 + 3*CC.Fontsmall, y1 + CC.RowPixel + 3*(CC.RowPixel + CC.Fontsmall), lqzxs, RGB(244, 128, 32), CC.Fontsmall)
  
  DrawString(x1 + 3 + 3*CC.Fontsmall, y1 + CC.RowPixel + 4*(CC.RowPixel + CC.Fontsmall), zdxs, RGB(120, 208, 88), CC.Fontsmall)		--中毒
  
  y1 = y1 + 5*(CC.RowPixel + CC.Fontsmall)
  if WAR.Person[id]["我方"] then
  	
  	local myx1 = 3;
  	local myy1 = 0;
  	DrawString(x1 + myx1, y1, "内伤:", C_ORANGE, CC.Fontsmall)
  	DrawString(x1 + CC.Fontsmall*5/2 + myx1, y1, nsxs, M_DarkSlateGray, CC.Fontsmall)		--内伤
  	myx1 = myx1 + CC.Fontsmall * 5;
  	
  	DrawString(x1 + myx1, y1, "流血:", C_ORANGE, CC.Fontsmall)
  	DrawString(x1 + myx1 + CC.Fontsmall*2 + 10, y1, lxxs, M_DarkRed, CC.Fontsmall)		--流血

		myx1 = 3;
		myy1 = CC.RowPixel + CC.Fontsmall;
  	DrawString(x1 + myx1, y1  + myy1, "封穴:", C_ORANGE, CC.Fontsmall)
  	DrawString(x1 + CC.Fontsmall*5/2, y1 + myy1, fxxs, C_GOLD, CC.Fontsmall)		--封穴
  	myx1 = myx1 + CC.Fontsmall * 5;
  	
		DrawString(x1 + myx1, y1  + myy1, "迟缓:", C_ORANGE, CC.Fontsmall)
  	DrawString(x1 + myx1 + CC.Fontsmall*5/2, y1 + myy1, lxxs, M_RoyalBlue, CC.Fontsmall)		--迟缓
  	
  	y1 = y1 + myy1
  	myx1 = 3;
		myy1 = CC.RowPixel + CC.Fontsmall;
		--队友攻击力加成
		local atk = 0;
	  for i,v in pairs(CC.AddAtk) do
	    if v[1] == pid then
	      for wid = 0, WAR.PersonNum - 1 do
	        if WAR.Person[wid]["人物编号"] == v[2] and WAR.Person[wid]["死亡"] == false then
	          atk = atk + v[3]
	        end
	      end
	    end
	  end
	  
	  --队友防御力加成
	  local def = 0;
	  for i,v in pairs(CC.AddDef) do
	    if v[1] == pid then
	      for wid = 0, WAR.PersonNum - 1 do
	        if WAR.Person[wid]["人物编号"] == v[2] and WAR.Person[wid]["死亡"] == false then
	          def = def + v[3]
	        end
	      end
	    end
	  end
	  
	  --队友轻功加成
	  local spd = 0;
	  for i,v in pairs(CC.AddSpd) do
	    if v[1] == pid then
	      for wid = 0, WAR.PersonNum - 1 do
	        if WAR.Person[wid]["人物编号"] == v[2] and WAR.Person[wid]["死亡"] == false then
	          spd = spd + v[3]
	        end
	      end
	    end
	  end
	  
	  local color = C_ORANGE;
	  local ac, dc, sc = color,color,color;
	  if atk > 0 then
	  	ac = RGB(204,255,102);
	  end
	  if def > 0 then
	  	dc = RGB(204,255,102);
	  end
	  if spd > 0 then
	  	sc = RGB(204,255,102);
	  end
  	DrawString(x1 + 3, y1 + myy1, "攻:"..atk, ac, CC.Fontsmall)		--队友加成
  	DrawString(x1 + CC.Fontsmall*7/2, y1 + myy1, "防:"..def, dc, CC.Fontsmall)		--队友加成
  	DrawString(x1 + CC.Fontsmall*13/2, y1 + myy1, "轻:"..spd, sc, CC.Fontsmall)		--队友加成
  end
  
  
  if WAR.Person[id]["我方"] == false then
	y1 = y1 + 2*(CC.RowPixel + CC.Fontsmall)
    DrawBox(x1 - 5, y1, x1 + width - 5, y1 + CC.DefaultFont*6, C_WHITE)
    local hl = 1
    for i = 1, 4 do
      local wp = p["携带物品" .. i]
      local wps = p["携带物品数量" .. i]
      if wp >= 0 then
        local wpm = JY.Thing[wp]["名称"]
        DrawString(x1, y1 + hl * (CC.DefaultFont+CC.RowPixel), wpm .. wps, C_ORANGE, CC.DefaultFont)
        hl = hl + 1
      end
    end
  end
end

--自动选择合适的武功
function War_AutoSelectWugong()
  local pid = WAR.Person[WAR.CurID]["人物编号"]
  local probability = {}
  local wugongnum = 10
  for i = 1, 10 do
    local wugongid = JY.Person[pid]["武功" .. i]
    if wugongid > 0 then
      if JY.Wugong[wugongid]["伤害类型"] == 0 then
      
      	--选择杀生命的武功，必须消耗内力比现有内力小，起码可以发出一级的武功。
        if JY.Wugong[wugongid]["消耗内力点数"] <= JY.Person[pid]["内力"] then
          local level = math.modf(JY.Person[pid]["武功等级" .. i] / 100) + 1
          probability[i] = (JY.Person[pid]["攻击力"] * 3 + JY.Wugong[wugongid]["攻击力" .. level]) / 2
        else
          probability[i] = 0
        end
        
        --内功攻击
        if inteam(pid) and WAR.Person[WAR.CurID]["我方"] then
        	--蓝烟清：新逆运走火状态下可以使用逆运神功攻击
          if wugongid > 88 and wugongid<109 then
          	if WAR.L_NYZH[pid] ~= nil and wugongid == 104 then
          	
          	elseif wugongid == 105 and pid == 36 then		--林平之 显示葵花神功
          	
          	elseif wugongid == 102 and pid == 38 then		--石破天 显示太玄神功
          	
          	elseif wugongid == 106 and pid == 9 then		--张无忌 显示九阳神功
          	
          	elseif wugongid == 94 and pid == 37 then		----狄云 显示神经照
          		
            elseif (pid == 0 and GetS(4, 5, 5, 5) == 5) or pid == 48 then			--天罡才可以使用内功
            	
            else
            	probability[i] = 0
            end
          end
        end
        
        --吸功不可攻击
        if wugongid == 85 or wugongid == 87 or wugongid == 88  then
          probability[i] = 0
        end
        
        --斗转星移
        if wugongid == 43 and inteam(pid) and pid ~= 51 then
          if pid == 0 and GetS(4, 5, 5, 5) == 5 then
          	probability[i] = 0
          else
          	probability[i] = 0
          end
        end
        
        --张三丰不用纯阳么
        if wugongid == 99 and pid == 5 then
          probability[i] = 0
        end
        
        --李沚元，不可使用内功攻击
        if pid == 92 and wugongid > 84 and wugongid < 109 then
          probability[i] = 0
        end

      else
        probability[i] = 10		 --很小的概率选择杀内力
      end
    else
      wugongnum = i - 1
      break;
    end
	  
  end
  
  if wugongnum ==  0 then			--如果没有武功，直接返回-1
  	return -1;
  end

	local maxoffense = 0		--计算最大攻击力
	for i = 1, wugongnum do
	  if maxoffense < probability[i] then
	    maxoffense = probability[i]
	  end
	end
	
	local mynum = 0			--计算我方和敌人个数
	local enemynum = 0
	for i = 0, WAR.PersonNum - 1 do
	  if WAR.Person[i]["死亡"] == false then
	    if WAR.Person[i]["我方"] == WAR.Person[WAR.CurID]["我方"] then
	      mynum = mynum + 1
	    else
	    	enemynum = enemynum + 1
	    end
	  end
	end
	
	
	local factor = 0		--敌人人数影响因子，敌人多则对线面等攻击多人武功的选择概率增加
	if mynum < enemynum then
	  factor = 2
	else
	  factor = 1
	end
	
	for i = 1, wugongnum do		--考虑其他概率效果
	  local wugongid = JY.Person[pid]["武功" .. i]
	  if probability[i] > 0 then
	    if probability[i] < maxoffense*3/4 then		--去掉攻击力小的武功
	      probability[i] = 0
	    else
		    local extranum = 0			--武功武器配合的攻击力
		    for j,v in ipairs(CC.ExtraOffense) do
		      if v[1] == JY.Person[pid]["武器"] and v[2] == wugongid then
		        extranum = v[3]
		        break;
		      end
		    end
		    local level = math.modf(JY.Person[pid]["武功等级" .. i] / 100) + 1
		    probability[i] = probability[i] + JY.Wugong[wugongid]["移动范围".. level]  * factor*10
		    if JY.Wugong[wugongid]["杀伤范围" .. level] > 0 then
		    	probability[i] = probability[i] + JY.Wugong[wugongid]["杀伤范围" .. level]* factor*10
		    end
	    end
	  end
	end
	
	local s = {}		--按照概率依次累加
	local maxnum = 0
	for i = 1, wugongnum do
	  s[i] = maxnum
	  maxnum = maxnum + probability[i]
	end
	s[wugongnum + 1] = maxnum
	if maxnum == 0 then		--没有可以选择的武功
	  return -1
	end
	
	local v = Rnd(maxnum)		 --产生随机数
	local selectid = 0
	for i = 1, wugongnum do		--根据产生的随机数，寻找落在哪个武功区间
	  if s[i] <= v and v < s[i + 1] then
	    selectid = i
  	end
	end
	return selectid
end


--战斗武功选择菜单
function War_FightMenu()
  local pid = WAR.Person[WAR.CurID]["人物编号"]
  local numwugong = 0
  local menu = {}
  for i = 1, 10 do
    local tmp = JY.Person[pid]["武功" .. i]
    if tmp > 0 then
      if JY.WGLVXS == 1 then
        menu[i] = {JY.Wugong[tmp]["名称"] .. "·" .. JY.Person[pid]["武功等级" .. i], nil, 1}
      else
        menu[i] = {JY.Wugong[tmp]["名称"], nil, 1}
      end
      
      --内力少不显示
      if JY.Person[pid]["内力"] < JY.Wugong[tmp]["消耗内力点数"] then
        menu[i][3] = 0
      end
      
      --北冥神功、化功大法、吸星大法、斗转星移不显示
      if tmp == 85 or tmp == 87 or tmp == 88 or tmp == 43 then
        menu[i][3] = 0
      end
      
      --如果不是游坦之，内功武功不显示
      if pid ~= 48 and tmp > 88 and tmp < 109 then
        menu[i][3] = 0
      end
      
      --如果主角是天罡，内功武功显示
      if pid == 0 and GetS(4, 5, 5, 5) == 5 and tmp > 88 and tmp < 109 then
        menu[i][3] = 1
      end
      
      --林平之 显示葵花神功
      if tmp == 105 and pid == 36 then
        menu[i][3] = 1
      end
       
      --石破天 显示太玄神功
      if tmp == 102 and pid == 38 then
        menu[i][3] = 1
      end
      
      --张无忌 显示九阳神功
      if tmp == 106 and pid == 9 then
        menu[i][3] = 1
      end
      
      --狄云 显示神经照
      if tmp == 94 and pid == 37 then
        menu[i][3] = 1
      end
      
      --慕容复 显示斗转星移
      if tmp == 43 and pid == 51 then
        menu[i][3] = 1
      end
      
      numwugong = numwugong + 1
    end
  end
  if numwugong == 0 then
    return 0
  end
  local r = nil
  r = ShowMenu(menu, numwugong, 0, CC.MainSubMenuX, CC.MainSubMenuY, 0, 0, 1, 1, CC.DefaultFont, C_ORANGE, C_WHITE)
  if r == 0 then
    return 0
  end
  WAR.ShowHead = 0
  
  local r2 = War_Fight_Sub(WAR.CurID, r)
  WAR.ShowHead = 1
  Cls()
  return r2
end

--自动战斗时 做思考
function War_Think()
  local pid = WAR.Person[WAR.CurID]["人物编号"]
  local r = -1
  if JY.Person[pid]["体力"] < 10 then
    r = War_ThinkDrug(4)
    if r >= 0 then
      return r
    end
    return 0
  end
  if JY.Person[pid]["生命"] < 20 or JY.Person[pid]["受伤程度"] > 50 then
    r = War_ThinkDrug(2)
	    if r >= 0 then
	    return r
  	end
  end
  
  local rate = -1
  if JY.Person[pid]["生命"] < JY.Person[pid]["生命最大值"] / 5 then
    rate = 90
  elseif JY.Person[pid]["生命"] < JY.Person[pid]["生命最大值"] / 4 then
      rate = 70
  elseif JY.Person[pid]["生命"] < JY.Person[pid]["生命最大值"] / 3 then
      rate = 50
  elseif JY.Person[pid]["生命"] < JY.Person[pid]["生命最大值"] / 2 then
      rate = 25
  end
  
  --暴气时，不吃药
  if Rnd(100) < rate and WAR.LQZ[pid] ~= nil and WAR.LQZ[pid] ~= 100 then
    r = War_ThinkDrug(2)
    if r >= 0 then				--如果有药吃药
      return r
    else
    	r = War_ThinkDoctor()		--如果没有药，考虑医疗
  		if r >= 0 then
    		return r
  		end
    end
  end

  --考虑内力
  rate = -1
  if JY.Person[pid]["内力"] < JY.Person[pid]["内力最大值"] / 6 then
  	rate = 100
  elseif JY.Person[pid]["内力"] < JY.Person[pid]["内力最大值"] / 5 then
    rate = 75
  elseif JY.Person[pid]["内力"] < JY.Person[pid]["内力最大值"] / 4 then
    rate = 50
  end
  
  --蓝烟清如果是满血，减少吃药的机率
 	if JY.Person[pid]["生命"] == JY.Person[pid]["生命最大值"] then
 		rate = rate - 50;
 	end
  
  if Rnd(100) < rate then
    r = War_ThinkDrug(3)
    if r >= 0 then
    	return r
  	end
  end
  
  
  rate = -1
  if CC.PersonAttribMax["中毒程度"] * 3 / 4 < JY.Person[pid]["中毒程度"] then
    rate = 60
  else
    if CC.PersonAttribMax["中毒程度"] / 2 < JY.Person[pid]["中毒程度"] then
      rate = 30
    end
  end
  
  --半血以下，才吃解毒药
  if Rnd(100) < rate and JY.Person[pid]["生命"] < JY.Person[pid]["生命最大值"] / 2 then
    r = War_ThinkDrug(6)
    if r >= 0 then
    	return r
  	end
  end
  
  
  local minNeili = War_GetMinNeiLi(pid)
  if minNeili <= JY.Person[pid]["内力"] then
    r = 1
  else
    r = 0
  end
  return r
end
--自动攻击
function War_AutoFight()
  local wugongnum = War_AutoSelectWugong()
  if wugongnum <= 0 then
    War_AutoEscape()
    War_RestMenu()
    return 
  end
  unnamed(wugongnum)
end

--自动战斗
function War_Auto()
  local pid = WAR.Person[WAR.CurID]["人物编号"]
  WAR.ShowHead = 1
  WarDrawMap(0)
  ShowScreen()
  lib.Delay(CC.WarAutoDelay)
  WAR.ShowHead = 0
  if CC.AutoWarShowHead == 1 then
    WAR.ShowHead = 1
  end
  local autotype = War_Think()
  if WAR.Person[WAR.CurID]["我方"] or WAR.ZDDH == 238 then
    if JY.Person[pid]["内力"] > 50 and JY.Person[pid]["体力"] > 10 then
      autotype = 1
    else
    	autotype = 0
  	end
  end
  
  --蓝烟清：新逆运走火的状态下，有20%的机率会休息一下
  if autotype == 1 and inteam(pid) and JLSD(30, 45, pid) and WAR.L_NYZH[pid] ~= nil then
  	if JY.Person[pid]["生命"] < JY.Person[pid]["生命最大值"]*0.15 and JLSD(0, 50, pid) then
    	
    else
    	autotype = 7
    end
  end
  if autotype == 0 then
    War_AutoEscape()
    War_RestMenu()
  elseif autotype == 1 then
    War_AutoFight()
  elseif autotype == 2 then
    War_AutoEscape()
    War_AutoEatDrug(2)
  elseif autotype == 3 then
    War_AutoEscape()
    War_AutoEatDrug(3)
  elseif autotype == 4 then
    War_AutoEscape()
    War_AutoEatDrug(4)
  elseif autotype == 5 then
    War_AutoEscape()
    War_AutoDoctor()
  elseif autotype == 6 then
    War_AutoEscape()
    War_AutoEatDrug(6)
  elseif autotype == 7 then
    CurIDTXDH(WAR.CurID, 89,1, "休息一下")
    War_RestMenu()
  end
  return 0
end

--人物升级
function War_AddPersonLVUP(pid)
  local tmplevel = JY.Person[pid]["等级"]
  if CC.Level <= tmplevel then
    return false
  end
  if JY.Person[pid]["经验"] < CC.Exp[tmplevel] then
    return false
  end
  while CC.Exp[tmplevel] <= JY.Person[pid]["经验"] do
    tmplevel = tmplevel + 1
    if CC.Level <= tmplevel then
    	break;
    end
  end
  
  DrawStrBoxWaitKey(string.format("%s 升级了", JY.Person[pid]["姓名"]), C_WHITE, CC.DefaultFont)
  --计算提升的等级
	local leveladd = tmplevel - JY.Person[pid]["等级"]
	
	JY.Person[pid]["等级"] = JY.Person[pid]["等级"] + leveladd
	
	--提高生命增长
	AddPersonAttrib(pid, "生命最大值", (JY.Person[pid]["生命增长"] + Rnd(2) + 2) * leveladd * 4)
	
	JY.Person[pid]["生命"] = JY.Person[pid]["生命最大值"]
	JY.Person[pid]["体力"] = CC.PersonAttribMax["体力"]
	JY.Person[pid]["受伤程度"] = 0
	JY.Person[pid]["中毒程度"] = 0
	
	--属性点资质加成
	local function cleveradd()
	  local ca, rndnum = nil, nil
	  if CC.Debug then
	    rndnum = math.random(1)
	  else
	    rndnum = math.random(1)
	  end
	  ca = JY.Person[pid]["资质"] / (rndnum + 4)
	  return ca
	end

	
	local theadd = cleveradd()
	--聪明人内力加少。。。
	--增加内力的成长
	AddPersonAttrib(pid, "内力最大值", math.modf(leveladd * ((16 - JY.Person[pid]["生命增长"]) * 7 + 210 / (theadd + 1))))
	
	--天罡内力每级额外加50
	if pid == 0 and GetS(4, 5, 5, 5) == 5 then
	  AddPersonAttrib(pid, "内力最大值", 50 * leveladd)
	end
	JY.Person[pid]["内力"] = JY.Person[pid]["内力最大值"]
	
	--循环提升等级，累加属性
	for i = 1, leveladd do
	  local ups = math.modf((JY.Person[pid]["资质"] - 1) / 15) + 1
	  
	  --令狐冲 内伤回复前，每级3点
	  if pid == 35 and GetD(82, 1, 0) == 1 then
	    ups = 3
	  end
	  
	  --郭靖 20级之后，每级6点
	  if pid == 55 and JY.Person[pid]["等级"] > 20 then
	    ups = 6
	  end
	  
	  --零二七，每级8点
	  if T1LEQ(pid) then
	    ups = 8
	  end
	  
	  --难度额外加成
	  ups = ups + JY.Thing[202][WZ7]  
	  
	  AddPersonAttrib(pid, "攻击力", ups)
	  AddPersonAttrib(pid, "防御力", ups)
	  AddPersonAttrib(pid, "轻功", ups)
	  
	  
	  --修复医疗、用毒、解毒能力不与等级挂钩的问题
	  if JY.Person[pid]["医疗能力"] >= 20 then
  		AddPersonAttrib(pid, "医疗能力", math.random(2))
		end
		if JY.Person[pid]["用毒能力"] >= 20 then
  		AddPersonAttrib(pid, "用毒能力", math.random(2))
		end
		if JY.Person[pid]["解毒能力"] >= 20 then
  		AddPersonAttrib(pid, "解毒能力", math.random(2))
		end
		
		--陈家洛 升级加四围
		if pid == 75 then
		  if JY.Person[pid]["拳掌功夫"] >= 0 then
		    AddPersonAttrib(pid, "拳掌功夫", math.random(3))
		  end
		  if JY.Person[pid]["御剑能力"] >= 0 then
		    AddPersonAttrib(pid, "御剑能力", (7 + math.random(0,1)))
		  end
		  if JY.Person[pid]["耍刀技巧"] >= 0 then
		    AddPersonAttrib(pid, "耍刀技巧", (7 + math.random(0,1)))
		  end
		  if JY.Person[pid]["特殊兵器"] >= 0 then
		  	AddPersonAttrib(pid, "特殊兵器", (7 + math.random(0,1)))
			end
		end
		
		--暗器每级提高
		if JY.Person[pid]["暗器技巧"] >= 20 then
		  AddPersonAttrib(pid, "暗器技巧", math.random(2))
		end
	end

	local ey = 1;  --每级的随机点数
	ey = ey + JY.Thing[202][WZ7] - 1;
  
  local n = ey*leveladd;		--计算随机额外点数

	--难度一 随机分配点数
	if JY.Thing[202][WZ7] == 1 then
		local a = math.random(n+1)-1;
		local b = limitX(math.random(n+1-a)-1,0,n);
		local c = limitX(math.random(n+1-a-b)-1,0,n);
	  AddPersonAttrib(pid,"攻击力",a);
	  AddPersonAttrib(pid,"防御力",b);
	  AddPersonAttrib(pid,"轻功",c);
	  
	--高难度自由分配
	else
		local gj = JY.Person[pid]["攻击力"];
	  local fy = JY.Person[pid]["防御力"];
	  local qg = JY.Person[pid]["轻功"];
	  local tmpN = n;
		repeat
	  	Cls();
	  	
			local title = JY.Person[pid]["姓名"].." 升级随机点分配";
			local str = string.format("剩余的额外随机升级点数：%d 点*攻击：%d*防御：%d*轻功：%d",tmpN, gj, fy, qg);
			local btn = {"加攻","加防","加轻","重置","确定"};
			local num = #btn;
			local r = JYMsgBox(title,str,btn,num);
			Cls();
			if tmpN == 0 and r < 4 then
				DrawStrBoxWaitKey("对不起，已经没有可分配点数。请选择“确定”或“重置”", C_WHITE, CC.DefaultFont)
			else
				if r ==  1 then			--输入攻击力
			    local r = InputNum("请输入分配的攻击力点数", 1, tmpN, 1)
			    
			    if r ~= nil then
			    	gj =  gj + r
			    	tmpN = tmpN-r
			    end
	
				elseif r ==  2 then		--输入防御力
			    local r = InputNum("请输入分配的防御力点数", 1, tmpN, 1)
			    
			    if r ~= nil then
			    	fy =  fy + r
			    	tmpN = tmpN-r
			    end
		
				elseif r ==  3 then		--输入轻功
			    local r = InputNum("请输入分配的轻功点数", 1, tmpN, 1)
			    
			    if r ~= nil then
			    	qg =  qg + r
			    	tmpN = tmpN-r
			    end
				elseif r == 4 then
					gj = JY.Person[pid]["攻击力"];
		  	  fy = JY.Person[pid]["防御力"];
		  		qg = JY.Person[pid]["轻功"];
		  	  tmpN = n;
				elseif r == 5 then
					if tmpN > 0 then
						DrawStrBoxWaitKey("对不起，"..JY.Person[pid]["姓名"].."还有剩余的点数没加!", C_WHITE, CC.DefaultFont)
					else
						JY.Person[pid]["攻击力"] = gj;
						JY.Person[pid]["防御力"] = fy;
						JY.Person[pid]["轻功"] = qg;
						n = 0;
					end
				end
			end
	 	until n == 0
	end
	
	return true
end



--战斗结束处理函数
--isexp 经验值
--warStatus 战斗状态
function War_EndPersonData(isexp, warStatus)
  for i = 0, WAR.PersonNum - 1 do
    local pid = WAR.Person[i]["人物编号"]
    
    --敌方回复满状态
    if not instruct_16(pid) then
      JY.Person[pid]["生命"] = JY.Person[pid]["生命最大值"]
      JY.Person[pid]["内力"] = JY.Person[pid]["内力最大值"]
      JY.Person[pid]["体力"] = CC.PersonAttribMax["体力"]
      JY.Person[pid]["受伤程度"] = 0
      JY.Person[pid]["中毒程度"] = 0
    end
  end
  
  
  for i = 0, WAR.PersonNum - 1 do
    local pid = WAR.Person[i]["人物编号"]
    if instruct_16(pid) then
      if warStatus == 1 then
        JY.Person[pid]["生命"] = JY.Person[pid]["生命"] + math.modf((JY.Person[pid]["生命最大值"] - JY.Person[pid]["生命"]) * 0.3)
        JY.Person[pid]["内力"] = JY.Person[pid]["内力"] + math.modf((JY.Person[pid]["内力最大值"] - JY.Person[pid]["内力"]) * 0.3)
        JY.Person[pid]["体力"] = JY.Person[pid]["体力"] + math.modf((100 - JY.Person[pid]["体力"]) * 0.3)
        JY.Person[pid]["受伤程度"] = math.modf(JY.Person[pid]["受伤程度"] / 2)
        JY.Person[pid]["中毒程度"] = math.modf(JY.Person[pid]["中毒程度"] / 2)
      else
	      if JY.Person[pid]["生命"] < JY.Person[pid]["生命最大值"] / 4 then
	        JY.Person[pid]["生命"] = math.modf(JY.Person[pid]["生命最大值"] / 4)
	      end
      end  
    end
    if JY.Person[pid]["体力"] < 10 then
      JY.Person[pid]["体力"] = 10
    end
  end
  
  --乔峰武功回复
  JY.Person[50]["武功1"] = 26
  JY.Wugong[13]["名称"] = "铁掌"
  
  --破丐帮打狗阵
  if WAR.ZDDH == 82 then
    SetS(10, 0, 18, 0, 1)
  end
  
  --十八铜人，战斗胜利
  if WAR.ZDDH == 217 and warStatus == 1 then
    SetS(10, 0, 16, 0, 1)
  end
  
  --梅庄 秃笔翁战斗后
  if WAR.ZDDH == 44 then
    instruct_3(55, 6, 1, 0, 0, 0, 0, -2, -2, -2, 0, -2, -2)
    instruct_3(55, 7, 1, 0, 0, 0, 0, -2, -2, -2, 0, -2, -2)
  end
  
  --梅庄 黑白子战斗
  if WAR.ZDDH == 45 then
    instruct_3(55, 9, 1, 0, 0, 0, 0, -2, -2, -2, 0, -2, -2)
  end
  
  --梅庄 黄钟公战斗
  if WAR.ZDDH == 46 then
    instruct_3(55, 13, 0, 0, 0, 0, 0, -2, -2, -2, 0, -2, -2)
  end
  
  
  --战斗失败，并且无经验
  if warStatus == 2 and isexp == 0 then
    return 
  end
  
  --统计活的人数
  local liveNum = 0
  for i = 0, WAR.PersonNum - 1 do
    if WAR.Person[i]["我方"] == true and JY.Person[WAR.Person[i]["人物编号"]]["生命"] > 0 then
      liveNum = liveNum + 1
    end
  end
  
  --分配经验
  local canyu = false
  if warStatus == 1 then
    if WAR.Data["经验"] < 1000 then
      WAR.Data["经验"] = 1000
    end
    for i = 0, WAR.PersonNum - 1 do
      local pid = WAR.Person[i]["人物编号"]
      if WAR.Person[i]["我方"] == true and inteam(pid) and JY.Person[pid]["生命"] > 0 then
        if pid == 0 then
          canyu = true
        end
        for ii = 1, 10 do
          if JY.Person[pid]["武功" .. ii] == 98 then
            WAR.Person[i]["经验"] = WAR.Person[i]["经验"] + math.modf(WAR.Data["经验"] * 1.5 / (liveNum))
          end
        end
        WAR.Person[i]["经验"] = WAR.Person[i]["经验"] + math.modf(WAR.Data["经验"] / (liveNum))
      end
    end
  end
  
  --修炼点经验
  for i = 0, WAR.PersonNum - 1 do
    local pid = WAR.Person[i]["人物编号"]
    AddPersonAttrib(pid, "物品修炼点数", math.modf(WAR.Person[i]["经验"] * 8 / 10))
    AddPersonAttrib(pid, "修炼点数", math.modf(WAR.Person[i]["经验"] * 8 / 10))
    if JY.Person[pid]["修炼点数"] < 0 then
      JY.Person[pid]["修炼点数"] = 0
    end
    War_PersonTrainBook(pid)     --修炼秘籍
    War_PersonTrainDrug(pid)		 --修炼药品
  end
  
  
  --把等级放在修炼秘籍的后面
  for i = 0, WAR.PersonNum - 1 do
  	local pid = WAR.Person[i]["人物编号"]
	  if WAR.Person[i]["我方"] == true and inteam(pid) then
  		AddPersonAttrib(pid, "经验", math.modf(WAR.Person[i]["经验"] / 2))
      DrawStrBoxWaitKey(string.format("%s 获得经验点数 %d", JY.Person[pid]["姓名"], WAR.Person[i]["经验"]), C_WHITE, CC.DefaultFont)
      War_AddPersonLVUP(pid)
    else
      AddPersonAttrib(pid, "经验", WAR.Person[i]["经验"])
    end
	end
  
  --青城四秀
  if WAR.ZDDH == 48 then
    SetS(57, 52, 29, 1, 0)
    SetS(57, 52, 30, 1, 0)
    
  -- 一灯居，欧阳锋，裘千刃
  elseif WAR.ZDDH == 175 then
      instruct_3(32, 12, 1, 0, 0, 0, 0, 0, 0, 0, -2, -2, -2)
      
  --
  elseif WAR.ZDDH == 82 then
      SetS(10, 0, 18, 0, 1)
      
  --破打狗阵
  elseif WAR.ZDDH == 214 then
      SetS(10, 0, 19, 0, 1)
  end
  
  --十八铜人战斗胜利
  if WAR.ZDDH == 217 and warStatus == 1 then
    SetS(65, 1, 1, 5, 517)
  end
end
--执行战斗，自动和手动战斗都调用
--id战斗人物编号
--wugongnum 使用的武功在位置
--x,y为战斗场景坐标
function War_Fight_Sub(id, wugongnum, x, y)
	
  local pid = WAR.Person[id]["人物编号"]
  local wugong = 0
  if wugongnum < 100 then
    wugong = JY.Person[pid]["武功" .. wugongnum]
  else
    wugong = wugongnum - 100
    wugongnum = 1
	  for i = 1, 10 do
	    if JY.Person[pid]["武功" .. i] == 43 then   --如果学习有斗转星移
	      wugongnum = i     --记录斗转武功位置
	  		break;
	    end
	  end
	  x = WAR.Person[WAR.CurID]["坐标X"] - x
	  y = WAR.Person[WAR.CurID]["坐标Y"] - y
	  WarDrawMap(0)   
	  local fj = nil
	  if WAR.DZXYLV[pid] == 110 then    --斗转星移提示的文字
	    fj = string.format("%s发动离合参商反击", JY.Person[pid]["姓名"])
	  elseif WAR.DZXYLV[pid] == 85 then
	      fj = string.format("%s发动斗转星移反击", JY.Person[pid]["姓名"])
	  elseif WAR.DZXYLV[pid] == 60 then
	      fj = string.format("%s发动北斗移辰反击", JY.Person[pid]["姓名"])
	  end
	  
	  for i = 1, 10 do
	    DrawStrBox(-1, 24, fj, C_ORANGE, 20 + i)
	    ShowScreen()
	    if i == 10 then
	      lib.Delay(40)
	    else
	      lib.Delay(1)
	    end
	  end
	end
	
	
	--蓝烟清：修炼紫霞神功，增加剑系武功的伤害和攻击范围
  if PersonKF(pid, 89) then
  	if (wugong == 110 or wugong == 114 or (wugong <= 48 and wugong >= 27)) and JY.Person[pid]["武功等级" .. wugongnum] == 999 then
  		JY.Wugong[wugong]["移动范围10"] = JY.Wugong[wugong]["移动范围10"]+2;
  		JY.Wugong[wugong]["杀伤范围10"] = JY.Wugong[wugong]["杀伤范围10"]+2;
  		
  		WAR.L_ZXSG = 1;		--触发了紫霞神功，攻击结束之后范围必须还原
  	end
  end
	
  WAR.WGWL = JY.Wugong[wugong]["攻击力10"]
  local fightscope = JY.Wugong[wugong]["攻击范围"]
  local kfkind = JY.Wugong[wugong]["武功类型"]
  local level = JY.Person[pid]["武功等级" .. wugongnum]   --判断武功是否为极

  if level == 999 then
    level = 11
  else
    level = math.modf(level / 100) + 1
  end
  WAR.ShowHead = 0
  local m1, m2, a1, a2, a3, a4, a5 = refw(wugong, level)  --获取武功的范围
  local movefanwei = {m1, m2}   --可移动的范围
  local atkfanwei = {a1, a2, a3, a4, a5}   --攻击范围
  if WAR.SQFJ == 1 then   
    
  else
  	x, y = War_FightSelectType(movefanwei, atkfanwei, x, y,wugong)
  end
  
  --蓝烟清：紫霞神功剑系攻击范围回复
  if WAR.L_ZXSG == 1 then
  	JY.Wugong[wugong]["移动范围10"] = JY.Wugong[wugong]["移动范围10"]-2;
  	JY.Wugong[wugong]["杀伤范围10"] = JY.Wugong[wugong]["杀伤范围10"]-2;
  	WAR.L_ZXSG = 2;
  end
  
  if x == nil then
  	WAR.L_ZXSG = 0;		--防止出现选择武功后取消的情况
    return 0
  end
  
  --蓝烟清：使用小无相功攻击，随机变化武功
  if wugong == 98 then
  	local kfvl = 0;
  	while (kfvl < 800 or kfvl > 1100) do
  		wugong = math.random(JY.WugongNum - 1);
  		kfvl = JY.Wugong[wugong]["攻击力10"];
  	end
  end
  
  
  
  --判断合击
  local ZHEN_ID = -1
  local x0, y0 = WAR.Person[WAR.CurID]["坐标X"], WAR.Person[WAR.CurID]["坐标Y"]
  for i = 0, WAR.PersonNum - 1 do
    if WAR.Person[WAR.CurID]["我方"] == WAR.Person[i]["我方"] and i ~= WAR.CurID and WAR.Person[i]["死亡"] == false and WAR.SQFJ ~= 1 then
      local nx = WAR.Person[i]["坐标X"]
      local ny = WAR.Person[i]["坐标Y"]
      local fid = WAR.Person[i]["人物编号"]
      for j = 1, 10 do
	      if JY.Person[fid]["武功" .. j] == wugong then         
	        if math.abs(nx-x0)+math.abs(ny-y0)<9 then
	          local flagx, flagy = 0, 0
	          if math.abs(nx - x0) <= 1 then
	            flagx = 1
	          end
	          if math.abs(ny - y0) <= 1 then
	            flagy = 1
	          end
	          if x0 == nx then
	            flagy = 1
	          end
	          if y0 == ny then
	            flagx = 1
	          end
	          if between(x, x0, nx, flagx) and between(y, y0, ny, flagy) then
	            ZHEN_ID = i
	            WAR.Person[i]["人方向"] = 3 - War_Direct(x0, y0, x, y)
	            break;
	          end
	        end
	      end
	   	end
	   	if ZHEN_ID >= 0 then
      	break;
    	end
    end
   
  end
  
  
     
  local fightnum = 1  --攻击次数
  
  
  --判定左右
  if JY.Person[pid]["左右互搏"] == 1  and WAR.ZYHB == 0 then
  	--判断左右
	  local zyjl = 75 - JY.Person[pid]["资质"]
	  if zyjl < 0 then
	    zyjl = 0
	  end
	  if pid == 64 then
	    zyjl = 100
	  end
	  if pid == 59 then
	    zyjl = 70
	  end
	  
	  --主角身世之迷选择不知道
	  --觉醒之后增加左右的机率
	  if pid == JY.MY and GetS(53, 0, 2, 5) == 1 and GetS(53, 0, 3, 5) == 1 then
	  	zyjl = zyjl + math.modf(JY.Person[pid]["声望"]/8) + JY.Thing[202][WZ7]*2
	  end
  
  	if JLSD(0, zyjl, pid)  and WAR.DZXY == 0 and WAR.SQFJ ~= 1 then
	    WAR.ZYHB = 1
	
	    --改到特效文字0显示
	    if WAR.Person[WAR.CurID]["特效文字0"] ~= nil then
	    	WAR.Person[WAR.CurID]["特效文字0"] = WAR.Person[WAR.CurID]["特效文字0"] .."·左右互搏";
	    else
	    	WAR.Person[WAR.CurID]["特效文字0"] = "左右互搏";
	    end
	  end
    
  end
      
  --判断连击
  local LJ1 = math.modf(JY.Person[pid]["轻功"] / 18)
  local LJ2 = math.modf((JY.Person[pid]["内力最大值"] + JY.Person[pid]["内力"]) / 1000)
  local LJ3 = math.modf(JY.Person[pid]["资质"] / 10)
  local LJ = 0
  LJ = LJ1 + LJ2 + LJ3
  if WAR.Person[id]["我方"] then
    
  else
  	LJ = LJ + 20    --敌人连击+20
  end
  
  for i = 1, 10 do
    if JY.Person[pid]["武功" .. i] == 47 then    --独孤九剑连击+10
      LJ = LJ + 10
    end
  end
  
  --蓝烟清：新逆运走火，连击提高10点
  if WAR.L_NYZH[pid] ~= nil then
  	LJ = LJ + 10
  end
  
  --local ljup = {10, 15, 42, 31, 54, 60, 68, 76, 79}   --连击武功，每个连击+5
  local ljup = {10, 15, 42, 31, 54, 60, 68, 76, 79,114}   --连击武功，每个连击+5，蓝烟清：114连城剑法
  local up = 0
  for i = 1, 10 do
    if JY.Person[pid]["武功" .. i] > 0 then
      for ii = 1, 9 do
        if JY.Person[pid]["武功" .. i] == ljup[ii] then
          LJ = LJ + 5
          up = up + 1
        end
      end
    else
    	break;
    end
  end
      
  if T1LEQ(pid) then   --零二七，连击+20
    LJ = LJ + 20
  end
      
  if pid == 59 then     --小龙女，连击+10
    LJ = LJ + 10
  end

  
  local jp = math.modf(GetSZ(pid) / 25 + 1)   --实战加连击
  if jp > 20 then
    jp = 20
  end
  LJ = LJ + jp

  
  --蓝烟清：柔云剑法，累加连击
  if WAR.L_RYJF[pid] ~= nil then
  	LJ = LJ + 3*WAR.L_RYJF[pid];
  end
  
  if LJ > 100 then
    LJ = 100
  end
  if LJ < 10 then
    LJ = 10
  end
    
  local jl = math.random(200)    --判断连击机率
  if jl > 60 and jl < 60 + LJ then
    fightnum = 2
  end
  if inteam(pid) and JLSD(50, 55, pid) then  --加5%的机率再判断
    fightnum = 2
  end
  
  --brolycjw: 独孤求败的连击
  if pid == 592 then
	if WAR.L_DGQB_X < 2 then
		fightnum = 5
	elseif WAR.L_DGQB_X < 4 then
		fightnum = 4		
	elseif WAR.L_DGQB_X < 6 then
		fightnum = 3
	elseif WAR.L_DGQB_X < 8 then
		fightnum = 2
	else
		fightnum = 1
	end
	end
  --灭绝、裘千仞、洪教主、成崑、萧半和 增加20%的二次攻击机会
  if (pid < 200 and (pid == 6 or pid == 67 or pid == 71 or pid == 18 or pid == 189) and fightnum ~= 2 and math.random(10) < 8) then
    fightnum = 2
  end
    
  if pid == 50 then   --乔峰
    if WAR.ZDDH == 83 and WAR.FS == 0 then   --打四帮主时的乔峰
      say("１（唉，这些年轻人闯荡江湖也不容易，也罢，此战就以Ｒ太祖长拳Ｗ来陪你们玩玩吧！）", 50)
      WAR.FS = 1
    end
    JY.Wugong[13]["名称"] = "太祖长拳"
    if JLSD(40, 70, pid) then   --增加(70-40+10)%的二次攻击机会
      fightnum = 2
    end
    
    --如果乔峰用的是降龙，那么有(55-45+10)%的机率三连击，怒气暴发时必三连
    if JY.Person[pid]["武功" .. wugongnum] == 26 and (JLSD(45, 55, pid) or WAR.LQZ[pid] == 100) then
      fightnum = 3
      WAR.FS = 1
      for i = 1, 10 do
        DrawStrBox(-1, 24, "降龙三叠浪", C_ORANGE, 20 + i)   -- 降龙三叠浪在这里
        ShowScreen()
        lib.Delay(1)
      end
    end
    if JY.Person[pid]["内力"] < math.modf(JY.Person[pid]["内力最大值"] / 3) then    --万恶的峰神，无限内力
    	JY.Person[pid]["内力"] = math.modf(JY.Person[pid]["内力最大值"] / 3)
    	
  	end
  end
    
  --东方不败，必三连
  if pid == 27 then
    fightnum = 3
  end
  
  --令狐冲，变身之后，增加(85-15)%的连击
  if pid == 35 and GetS(10, 1, 1, 0) == 1 and JLSD(15, 85, pid) then
    fightnum = 2
  end
  
  --小龙女，如果使用玉女素心剑必连击
  if pid == 59 and JY.Person[pid]["武功" .. wugongnum] == 42 then
    fightnum = 2
  end
  
  --欧阳锋，射中最后一场，十五邪战斗， WAR.tmp[1060]还没明白
  if pid == 60 and WAR.tmp[1060] == 1 and (WAR.ZDDH == 176 or WAR.ZDDH == 133) then
    fightnum = 2
  end
  
  --倚天密道，成昆有(70-30+10)%的机率变成不连击
  if WAR.ZDDH == 237 and pid == 18 and JLSD(30, 70, pid) then
    fightnum = 1
  end
  
  --高连击武功
  local glj = {7, 2, 34, 37, 55, 57, 70, 77}
  for i = 1, 8 do
    if JY.Person[pid]["武功" .. wugongnum] == glj[i] and JLSD(25, 75, pid) then
      fightnum = 2
      break;
    end
  end
    
  --任我行，杀东方阿姨，只能单连，悲剧
  if WAR.ZDDH == 54 and pid == 26 then
    fightnum = 1
  end
  
  --蓝烟清： brolycjw邪线，小龙女死后，杨过黯然销魂掌练到极后发出黯然极意 机率三连
  if pid == 58 and JY.Person[pid]["武功" .. wugongnum] == 25 and JY.Person[pid]["武功等级" .. wugongnum] == 999 and GetS(86,11,11,5) == 2 then
  	local jl = 10;		--默认发动机率为10%
  	if JY.Person[58]["受伤程度"] > 50 then		--内伤大于50时， 每增加10点极意增加10%，并且集气速度增加5
  		jl = jl + (JY.Person[58]["受伤程度"]-50);		--平滑设置，比如内伤为55时，增加5%的机率    		
  	end    
  	if JY.Person[58]["生命"] < JY.Person[58]["生命最大值"]/2 then		--生命少于二分之一时，每少一百生命，机率增加10%
  		jl = jl + math.ceil((JY.Person[58]["生命最大值"]/2 - JY.Person[58]["生命"])/10);	  		
  	end
  
  	if jl > Rnd(100) then			--判断极意触发 三连
  		fightnum = 3;
  	end	
  end
  
  --蓝烟清：装备真武剑时使用太极剑法必连击
  if JY.Person[pid]["武器"] == 236  and  JY.Person[pid]["武功" .. wugongnum] == 46 then
  	fightnum = 2;
  end
  
  --蓝烟清：五岳剑法
  if wugong == 30 or wugong == 31 or wugong == 32 or wugong == 33 or wugong == 34 then
  	local n = 0;
  	for i=1, 10 do
  		if (JY.Person[pid]["武功"..i] == 30 or JY.Person[pid]["武功"..i] == 31 or JY.Person[pid]["武功"..i] == 32 or JY.Person[pid]["武功"..i] == 33 or JY.Person[pid]["武功"..i] == 34) and JY.Person[pid]["武功等级"..i] == 999 then
  			n = n + 1
  		end
  	end
  	if n == 5 then		--70%的机率触发
  		--万花剑法  必流血+暴击
  		--泰山十八盘   迟缓+暴击
  		--云雾十三式  必流血+暴击
  		--万岳朝宗  必封穴
  		--太岳三青峰  必连击
  		if JLSD(20, 90, pid) then
  			WAR.L_WYJFA = wugong;
  		else
  			WAR.L_WYJFA = -1;
  		end
  	end
  end
  
  --五剑太岳，必连击
  if WAR.L_WYJFA == 34 and fightnum < 2 then
  	fightnum = 2;
  end
  
  --主角身世之迷选择不知道
	--觉醒之力增加连击机率
	if pid == JY.MY and GetS(53, 0, 2, 5) == 1 and GetS(53, 0, 3, 5) == 1 then
  	if JLSD(0,JY.Person[pid]["声望"]/10,pid)  then
  		fightnum = fightnum + 1
  	elseif JY.Person[pid]["左右互搏"] == 0 and JLSD(0,JY.Person[pid]["资质"]/4,pid)  then
  		fightnum = fightnum + 1
  	end
  end
  
  --豪门护符作用
  --护符以防护为主，在激活之后才有进攻特效，而且机率也比较低
  if pid == JY.MY and GetS(53, 0, 2, 5) == 2 and GetS(53, 0, 5, 5) == 1 then
  	local rate = JY.Thing[238]["需经验"]/100 + JY.Person[pid]["声望"]/20
  	--仁者在护符激活时增加机率
  	if JLSD(0,rate,pid) or (GetS(4, 5, 5, 5) == 6 and JLSD(0,15,pid)) then
  		fightnum = fightnum + 1
  	end
	end
	
	--宗师增加连击率
	if pid == JY.MY and GetS(53, 0, 2, 5) == 3 then
		if JLSD(0,JY.Person[pid]["声望"]/10,pid) or JLSD(0,JY.Person[pid]["内力"]/200,pid) then
  		fightnum = fightnum + 1
  	elseif JY.Person[pid]["左右互搏"] == 0 and JLSD(0,JY.Person[pid]["资质"]/4,pid)  then
  		fightnum = fightnum + 1
  	elseif GetS(53, 0, 5, 5) == 1 and JLSD(0,40,pid) then
  		fightnum = fightnum + 1
  	end
	end
  
  WAR.ACT = 1
  WAR.FLHS6 = 0
  if WAR.DZXY == 1 or WAR.SQFJ == 1 then
    fightnum = 1
  end
  
  
  
  while WAR.ACT <= fightnum do
    if WAR.WS == 1 then
      WAR.WS = 0
    end
    if WAR.BJ == 1 then
      WAR.BJ = 0
    end
    if WAR.DJGZ == 1 then
      WAR.DJGZ = 0
    end
    if WAR.MCF == 1 then
      WAR.MCF = 0
    end
    if WAR.HQT == 1 then
      WAR.HQT = 0
    end
    if WAR.CY == 1 then
      WAR.CY = 0
    end
    if WAR.TFH == 1 then
      WAR.TFH = 0
    end
    if WAR.WQQ == 1 then
      WAR.WQQ = 0
    end
    if WAR.HDWZ == 1 then
      WAR.HDWZ = 0
    end
    if WAR.L_YTJ1 == 1 then	--装备倚天剑特效，1流血
      WAR.L_YTJ1 = 0;	
    end
    if WAR.L_YTJ2 == 1 then	--装备倚天剑特效，1封穴
      WAR.L_YTJ2 = 0;		
    end
	WAR.NGJL2 = WAR.NGJL;
    WAR.XDDF = 0
    WAR.NGJL = 0
    WAR.KHBX = 0
    WAR.GBWZ = 0
    WAR.BSMT = 0
    WAR.LXZQ = 0
    WAR.GCTJ = 0
    WAR.ASKD = 0
    WAR.JSYX = 0
    WAR.BMXH = 0
    WAR.TD = -1
    WAR.XXCC = 0
    WAR.TZ_XZ = 0
    WAR.ZSF2 = 0
    WAR.JGZ_DMZ = 0
    WAR.LHQ_BNZ = 0
    CleanWarMap(4, 0)
    
    WAR.L_CZJT = 0;			--蟾震九天 默认为0
    WAR.L_TLD = 0		--装备屠龙刀特效，流血
    WAR.L_SSBD = 0;	--水笙攻击特效，迟缓
    WAR.L_SGJL = 0;	--神功加力，默认为0
    WAR.L_LXXL = 0;	--龙象般若功蓄力攻击，会造成迟缓
    WAR.L_LZJFCC = 0		--雷震剑法攻击是否有效
    WAR.L_RYJFCC = 0		--柔云剑法攻击是否有效
    
    WAR.L_QKDNY = {}	--重新计算乾坤大挪移是否被反弹过
    
    WAR.L_MJJF = 0;		--灭绝剑法招式
    WAR.L_NSDFCC = 0;	--南山刀法是否触发
    
    
    WarDrawAtt(x, y, atkfanwei, 3)
    if ZHEN_ID >= 0 then
      local tmp_id = WAR.CurID
      WAR.CurID = ZHEN_ID
      WarDrawAtt(WAR.Person[ZHEN_ID]["坐标X"] + x0 - x, WAR.Person[ZHEN_ID]["坐标Y"] + y0 - y, atkfanwei, 3)
      WAR.CurID = tmp_id
    end
    if WAR.SQFJ == 1 then
      CleanWarMap(4, 0)
      for i = 0, WAR.PersonNum - 1 do
        if WAR.Person[i]["我方"] ~= WAR.Person[WAR.CurID]["我方"] and WAR.Person[i]["死亡"] == false then
          SetWarMap(WAR.Person[i]["坐标X"], WAR.Person[i]["坐标Y"], 4, 1)
        end
      end
    end
      
    --判断攻击次数大于1
    if WAR.ACT > 1 then   
      local A = WAR.ACT.."连击"    --显示连击
      if pid == 27 then
        A = "风云再起"    --显示风云再起
      end
      
      --改到特效文字0显示
      if WAR.Person[WAR.CurID]["特效文字0"] ~= nil then
      	WAR.Person[WAR.CurID]["特效文字0"] = WAR.Person[WAR.CurID]["特效文字0"] .."·".. A
      else
      	WAR.Person[WAR.CurID]["特效文字0"] = A;
      end
      
    end
      
    --计算暴击
    local BJ1 = math.modf(JY.Person[pid]["攻击力"] / 18)
    local BJ2 = math.modf((JY.Person[pid]["内力最大值"] + JY.Person[pid]["内力"]) / 1000)
    local BJ3 = math.modf(JY.Person[pid]["体力"] / 10)
    local BJ = 0
    BJ = BJ1 + BJ2 + BJ3
    if WAR.Person[id]["我方"] then
     
    else
    	BJ = BJ + 20     --敌人+20点
    end
    
    --杨过，血量少于四分之一时，暴击率额外判断 (80-10)%   如果是敌人+10%
    if pid == 58 and JY.Person[pid]["生命"] < JY.Person[pid]["生命最大值"] / 4 and JLSD(10, 80, pid) then
      WAR.BJ = 1
    --杨过，血量少于二分之一，暴击率额外判断 (75-25)% 如果是敌人+10%
    elseif pid == 58 and JY.Person[pid]["生命"] < JY.Person[pid]["生命最大值"] / 2 and JLSD(25, 75, pid) then
      WAR.BJ = 1
    end
    
    --袁承志，暴击加 30
    if pid == 54 then
      BJ = BJ + 30
    end
    
    --加暴击的武功
    local bjup = {18, 22, 39, 40, 56, 65, 71, 78, 74, 61}
    local up = 0
    for i = 1, 10 do
      if JY.Person[pid]["武功" .. i] > 0 then
        for ii = 1, 9 do
          if JY.Person[pid]["武功" .. i] == bjup[ii] then
            BJ = BJ + 5
            up = up + 1
          end
        end
      else
      	break;
      end
    end
    
    local jp = math.modf(GetSZ(pid) / 25 + 1)   --实战加成
    if jp > 20 then
      jp = 20
    end
    BJ = BJ + jp

    if BJ > 100 then
      BJ = 100
    end
    if BJ < 10 then
      BJ = 10
    end
    local jl = math.random(200)
    if jl > 60 and jl < 60 + BJ then
      WAR.BJ = 1
    end
    if inteam(pid) and JLSD(50, 55, pid) then  --
      WAR.BJ = 1
    end
    if pid < 200 and JLSD(50, 60, pid) then
      WAR.BJ = 1
    end
    
    --高暴击的敌人，血刀老祖、裘千仞、洪教主、任我行、玉真子、萧半和
    if (pid == 97 or pid == 67 or pid == 71 or pid == 26 or pid == 184 or pid == 189) and WAR.BJ ~= 1 and math.random(10) < 8 then
      WAR.BJ = 1
    end
    
    --萧峰、灭绝，必暴击
    if pid == 50 or pid == 6 then
      WAR.BJ = 1
    end
    
    --游坦之，有阿紫为队友必暴击
    if pid == 48 then
      for j = 0, WAR.PersonNum - 1 do
        if WAR.Person[j]["人物编号"] == 47 and WAR.Person[j]["死亡"] == false and WAR.Person[j]["我方"] == WAR.Person[WAR.CurID]["我方"] then
          WAR.BJ = 1
          break;
        end
      end
    end
    
    --萧中慧  夫妻刀法 必暴击
    if pid == 77 and JY.Person[pid]["武功" .. wugongnum] == 62 then
      WAR.BJ = 1
    end
    
    --欧阳锋 逆运状态下必暴击
    if pid == 60 and WAR.tmp[1060] == 1 then
      WAR.BJ = 1
    end
    
    --高暴击武功
    local gbj = {11, 13, 28, 33, 58, 59, 72, 75}
    for i = 1, 8 do
      if JY.Person[pid]["武功" .. wugongnum] == gbj[i] and JLSD(20, 75, pid) then
        WAR.BJ = 1
        break;
      end
    end
    
    --怒气值100，必暴击
    if WAR.LQZ[pid] == 100 and WAR.DZXY ~= 1 and WAR.SQFJ ~= 1 then
      WAR.BJ = 1
    end
    
    --蓝烟清：装备玄铁剑配合玄铁剑法必暴击，配合其它剑法提高40%暴击率
    if JY.Person[pid]["武器"] == 36 then
    	if wugong == 45 then
    		WAR.BJ = 1
    	elseif (wugong==114 or wugong==110 or (wugong>=27 and wugong<=49)) and JLSD(35, 75, pid) then
    		WAR.BJ = 1
    	end
    end
    
    --蓝烟清：装备屠龙刀，使用等级为极的刀法提高40%暴击率，暴击的情况下有50%机率大幅度杀集气，并且造成流血。杀集气量与武功威力有关
	  if JY.Person[pid]["武器"] == 43 then
	  	if (wugong==111 or (wugong>=50 and wugong<=67)) and JY.Person[pid]["武功等级" .. wugongnum] == 999 then
	  	 	if JLSD(35, 75, pid) then	
    			WAR.BJ = 1
    		end
    		
    		if WAR.BJ == 1 and JLSD(25, 75, pid) then
    			WAR.L_TLD = 1;
    		end
    	end
	  end
	  
	  --蓝烟清：新逆运走火暴击率提高20%
	  if WAR.L_NYZH[pid] ~= nil and JLSD(55, 75, pid) then
	  	WAR.BJ = 1;
	  end
	  
	  --蓝烟清：五岳剑法，万岳朝宗 必暴击
	  if (WAR.L_WYJFA == 30 or WAR.L_WYJFA == 31 or WAR.L_WYJFA == 32) then
	  	WAR.BJ = 1;
	  end
	  
	  local ng = 0

    
    if WAR.BJ == 1 then
      WAR.Person[id]["特效动画"] = 89   --暴击特效动画
      if pid == 50 then    --乔峰
        local r = nil
        r = math.random(3)
        if r == 1 then
        	War_Contact(id,"特效文字1","教单于折箭 六军辟易 奋英雄怒");
        elseif r == 2 then
          WAR.Person[id]["特效文字1"] = "虽万千人吾往矣"  --虽万千人吾往矣
        elseif r == 3 then
          WAR.Person[id]["特效文字1"] = "胡汉恩仇  须倾英雄泪"  --胡汉恩仇  须倾英雄泪
        end
      elseif pid == 27 then   --东方不败
        WAR.Person[id]["特效文字2"] = "日出东方  唯我不败"    --日出东方  唯我不败
      else
        WAR.Person[id]["特效文字2"] = "暴击加力"    --暴击加力
      end
      
      --改成特效文字0显示
      if WAR.Person[WAR.CurID]["特效文字0"] ~= nil then
      	WAR.Person[WAR.CurID]["特效文字0"] = WAR.Person[WAR.CurID]["特效文字0"] .."·".. "暴击"
      else
      	WAR.Person[WAR.CurID]["特效文字0"] = "暴击";
      end

    end
      
    
    
    --蟾震九天，最先判断，不影响加力
    --斗转和水镜的反击不触发
    if WAR.DZXY == 0 and WAR.SQFJ ~= 1 then
	    for i = 1, 10 do
	      local kfid = JY.Person[pid]["武功" .. i]
	      if kfid == 95 then    --蛤蟆功特效
	        if WAR.tmp[200 + pid] == nil then
	          WAR.tmp[200 + pid] = 0
	      	elseif WAR.tmp[200 + pid] > 100 then
	          ng = WAR.tmp[200 + pid] * 10 + 1500
	          
	          --白驼雪山掌 增加杀集气
	          if PersonKFJ(pid, 9) then
	          	ng = ng + ng/2;
	          	War_Contact(id,"特效文字2",JY.Wugong[kfid]["名称"] .. "·神蟾震九天");
	          else
	          	War_Contact(id,"特效文字2",JY.Wugong[kfid]["名称"] .. "·蟾震九天");
	          end

	          WAR.Person[id]["特效动画"] = math.fmod(kfid, 10) + 85
	          WAR.L_CZJT = 1;		--发动蟾震九天，无视上毒
	          break;
	        end
	      end
	    end
	  end
    
    --蓝烟清：新内功加力触发
		local atkjl = {};		
		local num = 0;	--当前学了多少个攻击内功
		for i = 1, 10 do
			local kfid = JY.Person[pid]["武功" .. i]
			
			--罗汉伏魔功、狮吼功、龙象般若功， 优先高机率触发加力
			if kfid == 96 or kfid == 92 or kfid == 103 then
				num = num + 1;
				atkjl[num] = {kfid,i};
			end
		end
		
		--优先判断进攻型内功加力
		if num > 0 then
			if atkRandom(30, pid) or  (pid == 0 and GetS(4, 5, 5, 5) == 6 and JLSD(30, 55, pid)) then
				local n = math.random(num);
				local kfid = atkjl[n][1];
				local lv = math.modf(JY.Person[pid]["武功等级" .. atkjl[n][2]] / 100) + 1
				local wl = JY.Wugong[kfid]["攻击力" .. lv];
				ng = ng + wl;
				War_Contact(id,"特效文字2",JY.Wugong[kfid]["名称"] .. "加力");
		  	WAR.Person[id]["特效动画"] = math.fmod(kfid, 10) + 85
		  	WAR.NGJL = kfid
			end
		end
		
		--如果没有加力，再继续判断普通内功
		if WAR.NGJL < 0 then
	    for i = 1, 10 do
	      local kfid = JY.Person[pid]["武功" .. i]
	      if kfid < 0 then
	      	break;
	      end
	      if kfid > 88 and kfid < 109 and kfid ~= 108 and kfid ~= 107 and kfid ~= 106 and kfid ~= 105 and kfid ~= 102 then     --内功范围
		      
		      --仁者额外增加机率
		      if atkRandom(30, pid) or (pid == 0 and GetS(4, 5, 5, 5) == 6 and JLSD(30, 55, pid)) then
			      local lv = math.modf(JY.Person[pid]["武功等级" .. i] / 100) + 1
			      local wl = JY.Wugong[kfid]["攻击力" .. lv]
			      if ng < wl then
			        ng = wl
			        WAR.Person[id]["特效动画"] = math.fmod(kfid, 10) + 85
			        War_Contact(id,"特效文字2",JY.Wugong[kfid]["名称"] .. "加力");
			        WAR.NGJL = kfid
			      end
			    end
		    end
	    end
	  end
    
    --蓝烟清：新内功，神功加力。 九阴需要阴性内力或天罡
    local num = 0;
    local sg = {};
    for i = 1, 10 do
      local kfid = JY.Person[pid]["武功" .. i]
      if kfid < 0 then
	      	break;
	      end
      if kfid == 108 or (kfid == 107 and ((JY.Person[pid]["内力性质"]==0 or (pid==0 and GetS(4, 5, 5, 5) == 5)) or pid == 55)) or kfid == 105 or kfid == 102 then
      	num = num + 1;
      	sg[num] = {kfid, i};
      end
    end
    
    --计算是否触发神功加力
    if num > 0 then
    	local n =  math.random(num);
    	local kfid = sg[n][1];
    	local lv = math.modf(JY.Person[pid]["武功等级" .. sg[n][2]] / 100) + 1
	    local wl = JY.Wugong[kfid]["攻击力" .. lv]
    	
    	--易筋经神功加力，额外增加杀集气
    	if kfid == 108 and atkdefRandom(20,pid) then
    		WAR.L_SGJL = kfid;
    		ng = ng + math.modf(wl/2) + 300;		--额外增加杀集气
    		if WAR.Person[id]["特效文字1"] ~= nil then
    			WAR.Person[id]["特效文字1"] = WAR.Person[id]["特效文字1"] .."+易筋经神功";
    		else
    			WAR.Person[id]["特效文字1"] = "易筋经神功";
    		end
				WAR.Person[id]["特效动画"] = 79
    	
    	--九阴神功加力，伤害额外增加40%
    	elseif kfid == 107 and atkRandom(25, pid) then
    		WAR.L_SGJL = kfid;
    		ng = ng + 500;
    		if WAR.Person[id]["特效文字1"] ~= nil then
    			WAR.Person[id]["特效文字1"] = WAR.Person[id]["特效文字1"] .."+九阴神功";
    		else
    			WAR.Person[id]["特效文字1"] = "九阴神功";
    		end
				WAR.Person[id]["特效动画"] = 66

    	--葵花神功加力，必造成刺目
    	elseif kfid == 105 and (JLSD(30,60,pid) or (pid == 36 and  JLSD(40,60,pid))) then
    		WAR.L_SGJL = kfid;
    		if WAR.Person[id]["特效文字1"] ~= nil then
    			WAR.Person[id]["特效文字1"] = WAR.Person[id]["特效文字1"] .."+葵花神功";
    		else
    			WAR.Person[id]["特效文字1"] = "葵花神功";
    		end
				WAR.Person[id]["特效动画"] = 44

    	--太玄神功加力，杀怒气值，并使敌人消耗的体力加倍
    	elseif kfid == 102 and (JLSD(30,60,pid)  or (pid == 38 and JLSD(40,60,pid))) then
    		WAR.L_SGJL = kfid;
    		if WAR.Person[id]["特效文字1"] ~= nil then
    			WAR.Person[id]["特效文字1"] = WAR.Person[id]["特效文字1"] .."+太玄神功";
    		else
    			WAR.Person[id]["特效文字1"] = "太玄神功";
    		end
				WAR.Person[id]["特效动画"] = 63
    	end
  
    end
    
    --蓝烟清：狮吼功新特效
    if wugong == 92 then
    	if WAR.Person[id]["特效动画"] == -1 then
    		WAR.Person[id]["特效动画"] = math.fmod(92, 10) + 85
    	end
    	
    	local nl = JY.Person[pid]["内力"];
    	local f = 0;
    	
    	for j = 0, WAR.PersonNum - 1 do
        if WAR.Person[j]["我方"] ~= WAR.Person[WAR.CurID]["我方"] and WAR.Person[j]["死亡"] == false and JY.Person[WAR.Person[j]["人物编号"]]["内力"] < math.modf(nl*2/3) then
          f = 1;
          if pid == 13 then
          	WAR.Person[j].TimeAdd = WAR.Person[j].TimeAdd - 200    --谢逊用，减200
          else
          	WAR.Person[j].TimeAdd = WAR.Person[j].TimeAdd - 100   --普通角色用，全部集气减100
          end
        end
        
      end
      
      if f == 1 then
      	if WAR.Person[id]["特效文字2"] == nil then
    			WAR.Person[id]["特效文字2"] = "战吼"
    		else
    			WAR.Person[id]["特效文字2"] = WAR.Person[id]["特效文字2"] .. "+战吼";
    		end
      end

    end
		--蓝烟清：狮吼功加力
    if WAR.NGJL == 92 then
    	ng = ng + 1000 + JY.Person[pid]["内力"]/5
    end
  
    --葵花攻击特效
    if PersonKF(pid, 105) and WAR.Person[id]["特效文字2"] == nil and math.random(10) < 6 then
      WAR.Person[id]["特效动画"] = math.fmod(105, 10) + 85
      WAR.Person[id]["特效文字2"] = "葵花神功加力"
      WAR.NGJL = 105
      ng = ng + 1000
    end
    
    --觉醒之力
    --身世选择不知道
    --以团队为主，大概率触发其疾如风，小概率如火
    --仁者增加如火的机率，因为仁者没有大招比较弱
    if pid==JY.MY and GetS(53, 0, 2, 5) == 1 and GetS(53, 0, 3, 5) == 1 then
    	local rate = limitX(math.modf(JY.Person[pid]["声望"]/4 + (100-JY.Person[pid]["资质"])/10 + GetSZ(pid)/40 + JY.Person[pid]["攻击力"]/50 + JY.Person[pid]["武学常识"]/10),0,100);
    	local low = 25;
    	
    	if GetS(53, 0, 4, 5) == 1 then
    		low = 15;
    	end
    	
    	if JLSD(low, rate, pid) then
    		WAR.Person[id]["特效动画"] = 6
        if WAR.Person[id]["特效文字2"] ~= nil then
        	WAR.Person[id]["特效文字2"] = WAR.Person[id]["特效文字2"] .. "+"..FLHSYL[1];
        else
        	WAR.Person[id]["特效文字2"] = FLHSYL[1]    --其疾如风
        end
        WAR.FLHS1 = 1
        for j = 0, WAR.PersonNum - 1 do
          if WAR.Person[j]["死亡"] == false and WAR.Person[j]["我方"] == WAR.Person[WAR.CurID]["我方"] then
            WAR.Person[j].Time = WAR.Person[j].Time + 100
          end
          if WAR.Person[j].Time > 980 then
            WAR.Person[j].Time = 980
          end
        end
      elseif JLSD(low/2, rate*3/4, pid) or (GetS(4, 5, 5, 5) == 6 and  JLSD(low, rate, pid)) then
      	WAR.Person[id]["特效动画"] = 6
	      if WAR.Person[id]["特效文字2"] ~= nil then
        	WAR.Person[id]["特效文字2"] = WAR.Person[id]["特效文字2"] .. "+"..FLHSYL[3]    --侵略如火
        else
        	WAR.Person[id]["特效文字2"] = FLHSYL[3]    --侵略如火
        end
	      ng = ng + 1500
	      if GetS(53, 0, 4, 5) == 1 then
	      	ng = ng + 1000
	      end
	      
	      if GetS(53, 0, 4, 5) == 1 then
	      	ng = ng + 1000
	      end
    	end
    	
    end
    
    --如果学会北冥神功或者角色是零二七
    if (PersonKF(pid, 85) or T1LEQ(pid)) and JLSD(25, 75, pid) or pid == 118 then
      if WAR.Person[id]["特效动画"] == -1 then
        WAR.Person[id]["特效动画"] = math.fmod(85, 10) + 85
      end
      if WAR.Person[id]["特效文字2"] == nil then
        WAR.Person[id]["特效文字2"] = "北冥神功"
      else
        WAR.Person[id]["特效文字2"] = WAR.Person[id]["特效文字2"] .. "+" .. "北冥神功"
      end
      WAR.BMXH = 1
      
      --北冥神功升级
      for w = 1, 10 do
        if JY.Person[pid]["武功" .. w] == 85 then
          JY.Person[pid]["武功等级" .. w] = JY.Person[pid]["武功等级" .. w] + 10
        end
        if JY.Person[pid]["武功等级" .. w] > 999 then
          JY.Person[pid]["武功等级" .. w] = 999
        end
      end
    end
      
    --吸星大法，任我行必触发，与北冥不可同时触发
    if (PersonKF(pid, 88) and JLSD(25, 75, pid) and WAR.BMXH == 0) or pid == 26 then
      if WAR.Person[id]["特效动画"] == -1 then
        WAR.Person[id]["特效动画"] = math.fmod(88, 10) + 85
      end
      if WAR.Person[id]["特效文字2"] == nil then
        WAR.Person[id]["特效文字2"] = "吸星大法"
      else
        WAR.Person[id]["特效文字2"] = WAR.Person[id]["特效文字2"] .. "+" .. "吸星大法"
      end
      WAR.BMXH = 2
      
      --吸星大法升级
      for w = 1, 10 do
      	if JY.Person[pid]["武功" .. w] < 0 then
      		break;
      	end
        if JY.Person[pid]["武功" .. w] == 88 then
          JY.Person[pid]["武功等级" .. w] = JY.Person[pid]["武功等级" .. w] + 10
          if JY.Person[pid]["武功等级" .. w] > 999 then
          	JY.Person[pid]["武功等级" .. w] = 999
        	end
        	break;
        end
        
      end
    end
    
    --化功大法
    if PersonKF(pid, 87) and JLSD(25, 75, pid) and WAR.BMXH == 0 then
      if WAR.Person[id]["特效动画"] == -1 then
        WAR.Person[id]["特效动画"] = math.fmod(87, 10) + 85
      end
      if WAR.Person[id]["特效文字2"] == nil then
        WAR.Person[id]["特效文字2"] = "化功大法"
      else
        WAR.Person[id]["特效文字2"] = WAR.Person[id]["特效文字2"] .. "+" .. "化功大法"
      end
      WAR.BMXH = 3
      
      --化功大法升级
      for w = 1, 10 do
      	if JY.Person[pid]["武功" .. w] < 0 then
      		break;
      	end
        if JY.Person[pid]["武功" .. w] == 87 then
          JY.Person[pid]["武功等级" .. w] = JY.Person[pid]["武功等级" .. w] + 10
          if JY.Person[pid]["武功等级" .. w] > 999 then
          	JY.Person[pid]["武功等级" .. w] = 999
        	end
        	break;
        end
        
      end
    end
      
    --乔峰
    if pid == 50 and WAR.Person[id]["特效文字2"] == nil then
      WAR.Person[id]["特效动画"] = 53
      WAR.Person[id]["特效文字2"] = "擒龙功加力"   --擒龙功加力
      ng = ng + 1500
    end
    
    --鸠摩智
    if pid == 103 then
      WAR.Person[id]["特效动画"] = math.fmod(98, 10) + 85
      WAR.Person[id]["特效文字2"] = "小无相功加力"  --小无相功加力
      ng = ng + 1000
    end
    
    --brolycjw: 周伯通
    if pid == 64 then
      WAR.Person[id]["特效动画"] = 66
      WAR.Person[id]["特效文字2"] = "九阴神功加力"
      ng = ng + 1000
    end
	
	--brolycjw: 洪七公
    if pid == 69 and WAR.ZDDH ~= 188 then
      WAR.Person[id]["特效动画"] = 67
      WAR.Person[id]["特效文字2"] = "九阴运气"
      ng = ng + 1000
    end
 
	--brolycjw: 黄药师
    if pid == 57 then
      WAR.Person[id]["特效动画"] = 95
      WAR.Person[id]["特效文字2"] = "奇门奥义"
      ng = ng + 1000
    end
	
	--brolycjw: 谢烟客
    if pid == 164 then
      WAR.Person[id]["特效动画"] = 23
      WAR.Person[id]["特效文字2"] = "摩天居士"
      ng = ng + 1000
    end
	
	--brolycjw: 独孤求败
    if pid == 592 then
		if WAR.L_DGQB_X < 3 then
			WAR.Person[id]["特效动画"] = 24
			WAR.Person[id]["特效文字2"] = "利剑"
			ng = ng + 1200
		elseif WAR.L_DGQB_X < 5 then
			WAR.Person[id]["特效动画"] = 48
			WAR.Person[id]["特效文字2"] = "软剑"
			ng = ng + 1400		
		elseif WAR.L_DGQB_X < 7 then
			WAR.Person[id]["特效动画"] = 10
			WAR.Person[id]["特效文字2"] = "重剑"
			ng = ng + 1600	
		elseif WAR.L_DGQB_X < 9 then
			WAR.Person[id]["特效动画"] = 46
			WAR.Person[id]["特效文字2"] = "木剑"
			ng = ng + 1800				
		else
			WAR.Person[id]["特效文字2"] = "无剑"
			ng = ng + 2000		
		end
    end
    
    --天罡内功为极，发动天罡真气·
    if pid == 0 and GetS(4, 5, 5, 5) == 5 and JY.Person[pid]["武功" .. wugongnum] > 88 and JY.Person[pid]["武功" .. wugongnum] < 109 then
      if JY.Person[pid]["武功等级" .. wugongnum] == 999 and JLSD(25, 75, pid) then
        WAR.Person[id]["特效文字3"] = "天罡真气·" .. JY.Wugong[JY.Person[pid]["武功" .. wugongnum]]["名称"]
        ng = ng + JY.Wugong[JY.Person[pid]["武功" .. wugongnum]]["攻击力10"]
      end
      if JY.Person[pid]["武功等级" .. wugongnum] == 999 then
     	 	WAR.WS = 1
    	end
    end
    

    --张无忌
    if pid == 9 and WAR.Person[id]["特效文字2"] == nil and PersonKF(pid, 106) then
      local z = math.random(2)
      if z == 1 then
        WAR.Person[id]["特效动画"] = math.fmod(97, 10) + 85
        WAR.Person[id]["特效文字2"] = "乾坤大挪移加力"   --乾坤大挪移加力
        ng = ng + 850
      else
        WAR.Person[id]["特效动画"] = math.fmod(106, 10) + 85
        WAR.Person[id]["特效文字2"] = "九阳神功加力"  --九阳神功加力
        ng = ng + 1200
      end
    end
    
    --任我行 
    if pid == 26 then
      WAR.Person[id]["特效动画"] = 6
      WAR.Person[id]["特效文字2"] = "魔帝·吸星"   --魔帝·吸星
      ng = ng + 1500
    end
    
    --使用降龙十八掌
    if JY.Person[pid]["武功" .. wugongnum] == 26 then  	
    	--乔峰必出极意，郭靖有(40%)，洪七公40%+10%，拳主角40%
      if pid == 50 or (pid == 55 and math.random(10) < 5) or ((pid == 69 or (pid == 0 and GetS(4, 5, 5, 5) == 1 and JY.Person[pid]["武功等级" .. wugongnum] == 999)) and JLSD(30, 70, pid)) then
        WAR.Person[id]["特效文字3"] = XL18JY[math.random(8)]
        ng = ng + 2500
        WAR.WS = 1
        for i = 1, (level) / 2 + 1 do
          for j = 1, (level) / 2 + 1 do
            SetWarMap(x + i - 1, y + j - 1, 4, 1)
            SetWarMap(x - i + 1, y + j - 1, 4, 1)
            SetWarMap(x + i - 1, y - j + 1, 4, 1)
            SetWarMap(x - i + 1, y - j + 1, 4, 1)
          end
        end
    	elseif myrandom(15 + (level), pid) then	
        WAR.Person[id]["特效文字3"] = XL18[math.random(6)]
        ng = ng + 2000
        for i = 1, (1 + (level)) / 2 do
          for j = 1, (1 + (level)) / 2 do
            SetWarMap(WAR.Person[WAR.CurID]["坐标X"] + i * 2 - 1, WAR.Person[WAR.CurID]["坐标Y"] + j * 2 - 1, 4, 1)
            SetWarMap(WAR.Person[WAR.CurID]["坐标X"] - i * 2 + 1, WAR.Person[WAR.CurID]["坐标Y"] + j * 2 - 1, 4, 1)
            SetWarMap(WAR.Person[WAR.CurID]["坐标X"] + i * 2 - 1, WAR.Person[WAR.CurID]["坐标Y"] - j * 2 + 1, 4, 1)
            SetWarMap(WAR.Person[WAR.CurID]["坐标X"] - i * 2 + 1, WAR.Person[WAR.CurID]["坐标Y"] - j * 2 + 1, 4, 1)
          end
        end
      end
    end
      
		--使用六脉神剑
    if JY.Person[pid]["武功" .. wugongnum] == 49 then
    	--学会一阳指，60%的机率出六脉大招，如果是段誉学一阳指必出
     	if PersonKF(pid, 17) and (JLSD(20, 80, pid) or pid == 53) then
        WAR.Person[id]["特效文字3"] = LMSJ[math.random(6)]
        ng = ng + 2000
       	if pid == 53 then   --段誉六脉音效
          WAR.LMSJwav = 1
          WAR.WS = 1
      	end
      --如果没学会一阳指
      elseif myrandom(level, pid) or pid == 53 and math.random(10) < 6 then
        WAR.Person[id]["特效文字3"] = LMSJ[math.random(6)]
        ng = ng + 2000
        if pid == 53 then
        	WAR.LMSJwav = 1
      	end
      end
    end
    
    
      
    --罗汉拳，易筋经变身，般若掌
    if JY.Person[pid]["武功" .. wugongnum] == 1 and PersonKF(pid, 108) then
    	--易筋经加力
    	if inteam(pid) and WAR.L_SGJL == 108 then
     	 	WAR.LHQ_BNZ = 1
    	elseif not inteam(pid) then	--敌方100%
    		WAR.LHQ_BNZ = 1
    	end
    end
      
    --大力金刚掌，易筋经变身，达摩掌
    if JY.Person[pid]["武功" .. wugongnum] == 22 and PersonKF(pid, 108)  then
    	--易筋经加力 
    	if inteam(pid) and WAR.L_SGJL == 108 then
      	WAR.JGZ_DMZ = 1
    	elseif not inteam(pid) then   --敌方100%
    		WAR.JGZ_DMZ = 1
    	end
    end
      
    --铜人阵，9个强力铜人
    if pid > 480 and pid < 490 then
      WAR.Person[id]["特效文字2"] = "易经筋加力"
      ng = ng + 1200
      WAR.JGZ_DMZ = 1   --直接触发达摩掌
    end
    
    --石破天，太玄神功，(75-25)%出特效
    if pid == 38 and wugong == 102 and JY.Person[pid]["武功等级" .. wugongnum] == 999 and JLSD(25, 75, pid) then
      WAR.Person[id]["特效文字3"] = XKXSJ[math.random(4)]
      ng = ng + 1200
    end
    
    --狄云，神经照，(75-25)%特效
    if pid == 37 and wugong == 94 and JY.Person[pid]["武功等级" .. wugongnum] == 999 and JLSD(25, 75, pid) then
      WAR.Person[id]["特效文字3"] = "神照经·无影神拳"
      ng = ng + 1000
    end
    
    --苗家剑法，为极，配合胡家刀法。 60%刀剑合壁
    if JY.Person[pid]["武功" .. wugongnum] == 44 and JY.Person[pid]["武功等级" .. wugongnum] == 999 and math.random(10) < 6 then
      for i = 1, 10 do
        if JY.Person[pid]["武功" .. i] == 67 and JY.Person[pid]["武功等级" .. i] == 999 then
        	if WAR.Person[id]["特效文字1"] ~= nil then
        		WAR.Person[id]["特效文字1"] = WAR.Person[id]["特效文字1"] .. "+" .."胡刀苗剑 归真合一"
        	else
          	WAR.Person[id]["特效文字1"] = "胡刀苗剑 归真合一"
          end
          WAR.Person[id]["特效动画"] = 6
          WAR.DJGZ = 1
          ng = ng + 2000
        end
      end
    end
    
    --胡家刀法，为极，配合苗家剑法。 60%刀剑合壁
    if JY.Person[pid]["武功" .. wugongnum] == 67 and JY.Person[pid]["武功等级" .. wugongnum] == 999 and math.random(10) < 6 then
      for i = 1, 10 do
        if JY.Person[pid]["武功" .. i] == 44 and JY.Person[pid]["武功等级" .. i] == 999 then
          if WAR.Person[id]["特效文字1"] ~= nil then
        		WAR.Person[id]["特效文字1"] = WAR.Person[id]["特效文字1"] .. "+" .."胡刀苗剑 归真合一"
        	else
          	WAR.Person[id]["特效文字1"] = "胡刀苗剑 归真合一"
          end
          WAR.Person[id]["特效动画"] = 6
          WAR.DJGZ = 1
          ng = ng + 2000
        end
      end
    end
    
    --钟灵 使用闪电貂，可偷窃
    if pid == 90 and JY.Person[pid]["武功" .. wugongnum] == 113 then
      WAR.TD = -2
      --蓝烟清：挑战战斗不可偷东西
	    if WAR.ZDDH == 226 or WAR.ZDDH == 79 then
	    	WAR.TD = -1;
	    end
    end
    
    
    
    --黄药师，第一次攻击，伤内力1000
    if pid == 57 and WAR.ACT == 1 and JLSD(20,85,pid) then
      for j = 0, WAR.PersonNum - 1 do
        if WAR.Person[j]["死亡"] == false and WAR.Person[j]["我方"] ~= WAR.Person[WAR.CurID]["我方"] then
          if JY.Person[WAR.Person[j]["人物编号"]]["内力"] > 1000 then
            JY.Person[WAR.Person[j]["人物编号"]]["内力"] = JY.Person[WAR.Person[j]["人物编号"]]["内力"] - 1000
            WAR.Person[j]["内力点数"] = (WAR.Person[j]["内力点数"] or 0) - 1000;
          else
          	WAR.Person[j]["内力点数"] = (WAR.Person[j]["内力点数"] or 0) - JY.Person[WAR.Person[j]["人物编号"]]["内力"];
          	JY.Person[WAR.Person[j]["人物编号"]]["内力"] = 0
          	JY.Person[WAR.Person[j]["人物编号"]]["生命"] = JY.Person[WAR.Person[j]["人物编号"]]["生命"] - 100
          	WAR.Person[j]["生命点数"] = (WAR.Person[j]["生命点数"] or 0) - 100;
        	end
        end
      end
      WAR.Person[id]["特效文字3"] = "魔音·碧海潮生曲"
      WAR.Person[id]["特效动画"] = 39
    end
    
    --欧阳锋
    if pid == 60 then
      WAR.WS = 1
    end
    
    --东方不败
    if pid == 27 then
      WAR.WS = 1
    end
    
    --乔峰，郭靖，洪七公，使用降龙十八掌
    if (pid == 50 or pid == 55 or pid == 69) and JY.Person[pid]["武功" .. wugongnum] == 26 then
      WAR.WS = 1
    end
    
    --令狐冲 变身后，使用独孤九剑
    if pid == 35 and GetS(10, 1, 1, 0) == 1 and JY.Person[pid]["武功" .. wugongnum] == 47 then
      WAR.WS = 1
    end
    
    --金轮法王 攻击杀集气+2000
    if pid == 62 then
      ng = ng + 2000
    end
    
    --霍都 攻击杀集气+1000
    if pid == 84 then
      ng = ng + 1000
    end
    
    --梅超风，使用九阴白骨爪，伤害加倍
    if pid == 78 and JY.Person[pid]["武功" .. wugongnum] == 11 then
      WAR.MCF = 1
      WAR.Person[id]["特效文字3"] = "铁尸之怨念"
    end
    
    --花铁干，使用中平枪法，杀集气+1000
    if pid == 52 and JY.Person[pid]["武功" .. wugongnum] == 70 then
      WAR.Person[id]["特效文字3"] = "中平神枪"
      ng = ng + 1000
    end
    
    --蓝凤凰，何铁手，攻击伤害提高10%
    if pid == 25 or pid == 83 then
      WAR.TFH = 1
    end
    
    --温青青，使用雷震剑法，伤害随机提高，最高为3倍
    if pid == 91 and JY.Person[pid]["武功" .. wugongnum] == 28 then
      WAR.WQQ = 1
    end
    
    --霍青桐，使用三分剑法，伤体力15
    if pid == 74 and JY.Person[pid]["武功" .. wugongnum] == 29 then
      WAR.HQT = 1
    end
    
    --程英，使用玉箫剑法，杀内力300
    if pid == 63 and JY.Person[pid]["武功" .. wugongnum] == 38 then
      WAR.CY = 1
    end
    
    --蓝烟清：水笙，70%机率发动雪谷冰山·冻结 
    if pid == 589 and JLSD(20,90,pid) then
    	WAR.L_SSBD = 1;
    	WAR.Person[id]["特效文字3"] = "雪谷冰山·冻结";
    end
    
    --蓝烟清：龙爪手，怒气暴击时，会攻击两格范围
    if wugong == 20 and JY.Person[pid]["内力性质"] == 1 and WAR.LQZ[pid] ~= nil and WAR.LQZ[pid] >= 100 then
    	for i = 1, 2 do
        for j = 1, 2 do
          SetWarMap(x + i - 1, y + j - 1, 4, 1)
          SetWarMap(x - i + 1, y + j - 1, 4, 1)
          SetWarMap(x + i - 1, y - j + 1, 4, 1)
          SetWarMap(x - i + 1, y - j + 1, 4, 1)
        end
      end
    end
    
    --蓝烟清：鹰爪功，怒气暴击时，会攻击两格范围
    if wugong == 4 and JY.Person[pid]["内力性质"] == 0 and WAR.LQZ[pid] ~= nil and WAR.LQZ[pid] >= 100 then
    	for i = 1, 2 do
        for j = 1, 2 do
          SetWarMap(x + i - 1, y + j - 1, 4, 1)
          SetWarMap(x - i + 1, y + j - 1, 4, 1)
          SetWarMap(x + i - 1, y - j + 1, 4, 1)
          SetWarMap(x - i + 1, y - j + 1, 4, 1)
        end
      end
    end
    
    
    
    
    --杨过 攻击，非吼 全体集气减100
    if pid == 58 and WAR.XK ~= 2 then
      for j = 0, WAR.PersonNum - 1 do
        if WAR.Person[j]["死亡"] == false and WAR.Person[j]["我方"] ~= WAR.Person[WAR.CurID]["我方"] then
          WAR.Person[j].TimeAdd = WAR.Person[j].TimeAdd - 100
        end
      end
      if WAR.Person[id]["特效动画"] == nil then
        WAR.Person[id]["特效动画"] = 89
      end
      if WAR.Person[id]["特效文字1"] ~= nil then
      	WAR.Person[id]["特效文字1"] = WAR.Person[id]["特效文字1"] .. "+" .."西狂之怒啸"
      else
      	WAR.Person[id]["特效文字1"] = "西狂之怒啸"
      end
    end
      
    --杨过吼
    if WAR.XK == 2 and pid == 58 and WAR.Person[WAR.CurID]["我方"] == WAR.XK2 then
      for e = 0, WAR.PersonNum - 1 do
        if WAR.Person[e]["死亡"] == false and WAR.Person[e]["我方"] ~= WAR.Person[WAR.CurID]["我方"] then
          WAR.Person[e].TimeAdd = WAR.Person[e].TimeAdd - math.modf(JY.Person[WAR.Person[WAR.CurID]["人物编号"]]["内力"] / 5)
          if WAR.Person[e].Time < -450 then
            WAR.Person[e].Time = -450
          end
          JY.Person[WAR.Person[e]["人物编号"]]["内力"] = JY.Person[WAR.Person[e]["人物编号"]]["内力"] - math.modf(JY.Person[WAR.Person[WAR.CurID]["人物编号"]]["内力"] / 5)
          if JY.Person[WAR.Person[e]["人物编号"]]["内力"] < 0 then
            JY.Person[WAR.Person[e]["人物编号"]]["内力"] = 0
          end
          JY.Person[WAR.Person[e]["人物编号"]]["生命"] = JY.Person[WAR.Person[e]["人物编号"]]["生命"] - math.modf(JY.Person[WAR.Person[WAR.CurID]["人物编号"]]["内力"] / 25)
        end
        if JY.Person[WAR.Person[e]["人物编号"]]["生命"] < 0 then
          JY.Person[WAR.Person[e]["人物编号"]]["生命"] = 0
        end
      end
        
      --吼过之后，内力为0，内力最大值-100，并且用声望控制上限
      if inteam(pid) then
        JY.Person[pid]["内力"] = 0
        JY.Person[pid]["内力最大值"] = JY.Person[pid]["内力最大值"] - 100
        JY.Person[300]["声望"] = JY.Person[300]["声望"] + 1
      else
        AddPersonAttrib(pid, "内力", -1000)  --做敌方内力只减1000，额
      end
      
      if JY.Person[pid]["内力最大值"] < 500 then
        JY.Person[pid]["内力最大值"] = 500
      end
      if WAR.Person[id]["特效文字1"] ~= nil then
      	WAR.Person[id]["特效文字1"] = WAR.Person[id]["特效文字1"] .. "+" .."西狂之震怒·雷霆狂啸"   --西狂之震怒·雷霆狂啸
      else
      	WAR.Person[id]["特效文字1"] = "西狂之震怒·雷霆狂啸"   --西狂之震怒·雷霆狂啸
      end
      WAR.Person[id]["特效动画"] = 6
      WAR.XK = 3
		end    
      
    --任盈盈，使用持瑶琴
    if pid == 73 and JY.Person[pid]["武功" .. wugongnum] == 73 then
      if math.random(10) < 7 then
        WAR.Person[id]["特效文字3"] = "七弦无琴剑气"
        WAR.Person[id]["特效动画"] = 89
        for j = 0, WAR.PersonNum - 1 do
          if WAR.Person[j]["死亡"] == false and WAR.Person[j]["我方"] ~= WAR.Person[WAR.CurID]["我方"] then
            JY.Person[WAR.Person[j]["人物编号"]]["生命"] = JY.Person[WAR.Person[j]["人物编号"]]["生命"] - 70
          end
        end
	    else
	    	--唱歌时，与令狐冲回复体力100，并回复内伤
	      if math.random(10) < 7 then
	        for j = 0, WAR.PersonNum - 1 do
	          if WAR.Person[j]["人物编号"] == 35 and WAR.Person[j]["死亡"] == false and WAR.Person[j]["我方"] == WAR.Person[WAR.CurID]["我方"] then
	            JY.Person[WAR.Person[j]["人物编号"]]["体力"] = 100
	            JY.Person[WAR.Person[WAR.CurID]["人物编号"]]["体力"] = 100
	            JY.Person[WAR.Person[j]["人物编号"]]["受伤程度"] = 0
	            JY.Person[WAR.Person[WAR.CurID]["人物编号"]]["受伤程度"] = 0
	            WAR.Person[id]["特效文字3"] = "剑胆琴心 笑傲江湖"
	            WAR.Person[id]["特效动画"] = 89
	          end
	        end
	      end
	    end
	  end
	  
	  
      
    --张三丰 万法自然，集气从500开始
    if pid == 5 and math.random(10) < 8 then
      WAR.ZSF = 1
      WAR.Person[id]["特效文字1"] ="万法自然"
    end
    
    --虚竹  福泽加护，集气从200开始
    if pid == 49 and math.random(10) < 7 then
      WAR.XZZ = 1
      if WAR.Person[id]["特效文字1"] ~= nil then
      	WAR.Person[id]["特效文字1"] = WAR.Person[id]["特效文字1"] .."+".."福泽加护"
      else
      	WAR.Person[id]["特效文字1"] = "福泽加护"
      end
    end
    
    --东方不败  葵花点穴手，杀集气+1200
    if pid == 27 and math.random(10) < 7 then
      WAR.Person[id]["特效文字3"] = "葵花点穴手"
      ng = ng + 1200
    end
    
    --程灵素 攻击全屏中毒+20
    if pid == 2 then
      for j = 0, WAR.PersonNum - 1 do
        if WAR.Person[j]["死亡"] == false and WAR.Person[j]["我方"] ~= WAR.Person[WAR.CurID]["我方"] then
          JY.Person[WAR.Person[j]["人物编号"]]["中毒程度"] = JY.Person[WAR.Person[j]["人物编号"]]["中毒程度"] + 20
        end
        if 100 < JY.Person[WAR.Person[j]["人物编号"]]["中毒程度"] then
          JY.Person[WAR.Person[j]["人物编号"]]["中毒程度"] = 100
        end
      end
      if WAR.Person[id]["特效文字1"] ~= nil then
      	WAR.Person[id]["特效文字1"] = WAR.Person[id]["特效文字1"] .."+".."七心海棠"
      else
      	WAR.Person[id]["特效文字1"] = "七心海棠"
      end
      WAR.Person[id]["特效动画"] = 64
    end
      
    --鸠摩智  使用火焰刀法，加内伤30，加杀集气1000
    --普通角色使用有30%的机率
    if wugong == 66 and JY.Person[pid]["武功等级" .. wugongnum] == 999 and (pid == 103 or (pid ~= 103 and JLSD(30,60,pid) or pid == 0 and JLSD(10,20,pid)))  then
      for j = 0, WAR.PersonNum - 1 do
        if WAR.Person[j]["死亡"] == false and WAR.Person[j]["我方"] ~= WAR.Person[WAR.CurID]["我方"] then
          JY.Person[WAR.Person[j]["人物编号"]]["受伤程度"] = JY.Person[WAR.Person[j]["人物编号"]]["受伤程度"] + 30
        end
        if 100 < JY.Person[WAR.Person[j]["人物编号"]]["受伤程度"] then
          JY.Person[WAR.Person[j]["人物编号"]]["受伤程度"] = 100
        end
      end
      if WAR.Person[id]["特效文字1"] ~= nil then
      	WAR.Person[id]["特效文字1"] = WAR.Person[id]["特效文字1"] .."+".."大轮密宗·火焰刀"  --大轮密宗·火焰刀
      else
      	WAR.Person[id]["特效文字1"] = "大轮密宗·火焰刀"  --大轮密宗·火焰刀
      end
      WAR.Person[id]["特效动画"] = 58
      ng = ng + 1000
    end
    
    --成崑，攻击杀集气2000
    if pid == 18 then
      WAR.Person[id]["特效文字2"] = "混元霹雳功加力"  --混元霹雳功加力
      WAR.Person[id]["特效动画"] = 6
      ng = ng + 2000
      WAR.Person[id]["特效文字3"] = "魔相·幻阴"  --魔相·幻阴
    end
    
    --使用血刀大法，配带血刀或血刀老祖使用时，吸血10%
    if JY.Person[pid]["武功" .. wugongnum] == 63 and (JY.Person[pid]["武器"] == 44 or pid == 97) then
      WAR.XDDF = 1
    end
    
    --太极拳，才加杀1点集气，额
    if JY.Person[pid]["武功" .. wugongnum] == 16 then
      if WAR.tmp[3000 + pid] == nil then
        WAR.tmp[3000 + pid] = 0
    	elseif 0 < WAR.tmp[3000 + pid] then
        WAR.Person[id]["特效文字3"] = "太极拳借力打力"   --太极拳借力打力
        ng = ng + WAR.tmp[3000 + pid] * 5
      end
    end
      
    --武功招式加杀集气
    for i,v in pairs(CC.KfName) do
      if v[1] == wugong  then
      	if myrandom(level, pid) or WAR.NGJL == 98 or WAR.LQZ[pid] == 100 or (PersonKF(pid, 98) and JLSD(30, 70, pid)) then
      		if WAR.Person[id]["特效文字3"] ~= nil then
      			WAR.Person[id]["特效文字3"] = WAR.Person[id]["特效文字3"] .. "+"..v[2]
      		else
        		WAR.Person[id]["特效文字3"] = v[2]
        	end
        	ng = ng + v[3]

        	--灭绝剑法，招式加成
        	if wugong == 41 then
        		if v[2] == "灭" then
        			WAR.L_MJJF = 1;
        		else
        			WAR.L_MJJF = 2;
        		end
        	end
        	break;
        end
      end
    end
    
    --蓝烟清：南山刀法，杨家枪法增加机率
    if wugong == 53 and (JLSD(10, 50) or (PersonKF(68, pid) and JLSD(20, 50))) then
    	WAR.L_NSDFCC = 1;
    	if WAR.Person[id]["特效文字3"] ~= nil then
  			WAR.Person[id]["特效文字3"] = WAR.Person[id]["特效文字3"] .. "·单刀破枪"
  		else
    		WAR.Person[id]["特效文字3"] = "单刀破枪"
    	end
    	WAR.ACT = 10   --出特效之后取消连击
    end
    
    --蓝烟清：五岳剑法，增加杀气
    if WAR.L_WYJFA > 0 then
    	CleanWarMap(4, 0);
    	local n = 6;
    	local tn = 1800;
    	if PersonKF(pid, 89) then		--紫霞剑法增加范围
    		n = 8;
    		tn = tn + 500;
    	end
    	for i = 1, n do
        for j = 1, n do
          SetWarMap(x + i - 1, y + j - 1, 4, 1)
          SetWarMap(x - i + 1, y + j - 1, 4, 1)
          SetWarMap(x + i - 1, y - j + 1, 4, 1)
          SetWarMap(x - i + 1, y - j + 1, 4, 1)
        end
      end
      
      ng = ng + tn;
      if WAR.Person[id]["特效文字3"] ~= nil then
      	WAR.Person[id]["特效文字3"] = WAR.Person[id]["特效文字3"] .. "·五岳剑法"
      else
      	WAR.Person[id]["特效文字3"] = "五岳剑法"
      end
      WAR.WS = 1
    end

    
    --张三丰，(70-30+10)%机率增加20%的伤害，杀集气+1000
    if pid == 5 and WAR.Person[id]["特效文字3"] ~= nil and JLSD(30, 70, pid) then
      WAR.Person[id]["特效文字3"] = "化朽为奇" .. "·" .. WAR.Person[id]["特效文字3"]  --化朽为奇
      ng = ng + 1000
      WAR.ZSF2 = 1
    end
    
    --主角刀系用玄虚刀法，60%机率至少增加600点杀集气
    if pid == 0 and GetS(4, 5, 5, 5) == 3 and wugong == 64 and JLSD(20, 80, pid) then
      local d = math.random(math.modf(GetS(14, 3, 1, 4) / 100 + 1) + 2) + 6
      ng = ng + d * 100
      WAR.Person[id]["特效文字3"] = "刀" .. SZB[d]
    end
    
    --虚竹使用天山六阳掌，出生死符，杀集气+1700
    if JY.Person[pid]["武功" .. wugongnum] == 8 and pid == 49 and PersonKF(pid, 101) and (JLSD(20, 80, pid) or WAR.NGJL == 98) then
      WAR.Person[id]["特效文字3"] = "灵鹫宫绝学·生死符"   --灵鹫宫绝学·生死符
      ng = ng + 1700
      WAR.SSFwav = 1   --音效
      WAR.TZ_XZ = 1
    end
    
    --蓝烟清：李文秀使用特系攻击60%的机率大幅度杀集气
    if pid == 590 and (wugong >= 68 and wugong <= 84 or wugong == 86 or wugong == 112) and JLSD(30, 80, pid) then
    	WAR.Person[id]["特效文字3"] = "心秀天铃·星月争辉";
    	ng = ng + 1200
      WAR.SSFwav = 1   --音效	
    end
    
    
    --蓝烟清：柔云剑法，累加杀集气
    if WAR.L_RYJF[pid] ~= nil then
    	ng = ng + 200*WAR.L_RYJF[pid];
    end
    
    --蓝烟清：灭绝剑法，灭加伤害，装备倚天剑效果加倍
    --绝
    if WAR.L_MJJF == 2 then
    	ng = ng + 300;
    	if JY.Person[pid]["武器"] == 37 then
    		ng = ng + 300;
    	end
    end
    
    --打狗棒法 特效  
    if JY.Person[pid]["武功" .. wugongnum] == 80 and JY.Person[pid]["武功等级" .. wugongnum] == 999 and (JLSD(30, 70, pid) or (GetS(4, 5, 5, 5) == 4 and JLSD(30, 75, pid))) then
      WAR.Person[id]["特效文字3"] = "打狗棒法绝学--天下无狗"   --打狗棒法绝学--天下无狗
      WAR.Person[id]["特效动画"] = 89
      if WAR.Person[id]["特效文字3"] ~= nil then
        ng = ng - 800
      end
      ng = ng + 1500
      WAR.WS = 1
      for i = 1, 6 do
        for j = 1, 6 do
          SetWarMap(x + i - 1, y + j - 1, 4, 1)
          SetWarMap(x - i + 1, y + j - 1, 4, 1)
          SetWarMap(x + i - 1, y - j + 1, 4, 1)
          SetWarMap(x - i + 1, y - j + 1, 4, 1)
        end
      end
    end
    
    --胡斐使用胡家刀法，杀集气+1200
    
    --蓝烟清：胡家刀法，极意
    --刀系主角40%，胡斐50%
    if wugong == 67 and JY.Person[pid]["武功等级" .. wugongnum] == 999 and ((pid == 0 and GetS(4,5,5,5) == 3 and JLSD(30,70,pid)) or (pid == 1 and JLSD(20,70,pid))) then
      local HDJY = {"极意·伏虎式","极意·拜佛听经","极意·穿手藏刀","极意·沙鸥掠波","极意·参拜北斗","极意·闭门铁扇刀","极意·缠身摘心刀","极意·进步连环刀","极意·八方藏刀式"};
      WAR.Person[id]["特效文字3"] = HDJY[math.random(9)];
      WAR.Person[id]["特效动画"] = 6
      ng = ng + 1800
      WAR.WS = 1
      for i = 1, 5 do
        for j = 1, 5 do
          SetWarMap(x + i - 1, y + j - 1, 4, 1)
          SetWarMap(x - i + 1, y + j - 1, 4, 1)
          SetWarMap(x + i - 1, y - j + 1, 4, 1)
          SetWarMap(x - i + 1, y - j + 1, 4, 1)
        end
      end
    end
    
    --杨过使用玄铁剑法
    if pid == 58 and JY.Person[pid]["武功" .. wugongnum] == 45 and WAR.Person[id]["特效文字3"] == nil and JY.Person[pid]["武功等级" .. wugongnum] == 999 and math.random(10) < 7 then
      WAR.Person[id]["特效文字3"] = "重剑真传·浪如山涌剑如虹"  --重剑真传·浪如山涌剑如虹
      WAR.Person[id]["特效动画"] = 84
      ng = ng + 1800
      WAR.WS = 1
      for i = 1, 5 do
        for j = 1, 5 do
          SetWarMap(x + i - 1, y + j - 1, 4, 1)
          SetWarMap(x - i + 1, y + j - 1, 4, 1)
          SetWarMap(x + i - 1, y - j + 1, 4, 1)
          SetWarMap(x - i + 1, y - j + 1, 4, 1)
        end
      end
    end
    
    --霍都攻击，中毒+15，伤害+50
    if pid == 84 and WAR.Person[id]["特效文字1"] == nil and math.random(10) < 7 then
      WAR.HDWZ = 1
      WAR.Person[id]["特效文字1"] = "暗箭·扇中钉"  --暗箭·扇中钉
      WAR.Person[id]["特效动画"] = 89
    end
    
    
      
    --真田幸村
    if pid == 553 and 0 < WAR.YZB2 then
      if 2 < WAR.YZB2 then
        WAR.Person[id]["特效文字3"] = "炎枪素浅鸣·无双乱舞皆传"   --炎枪素浅鸣·无双乱舞皆传
      elseif 1 < WAR.YZB2 then
          WAR.Person[id]["特效文字3"] = "炎枪素浅鸣·真无双乱舞"   --炎枪素浅鸣·真无双乱舞
      elseif 0 < WAR.YZB2 then
          WAR.Person[id]["特效文字3"] = "炎枪素浅鸣·无双乱舞"   --炎枪素浅鸣·无双乱舞
      end
      WAR.Person[id]["特效动画"] = 6
      ng = ng + 200 + WAR.YZB2 * 600
      WAR.WS = 1
      for i = 1, 4 + WAR.YZB2 * 2 do
        for j = 1, 4 + WAR.YZB2 * 2 do
          SetWarMap(x + i - 1, y + j - 1, 4, 1)
          SetWarMap(x - i + 1, y + j - 1, 4, 1)
          SetWarMap(x + i - 1, y - j + 1, 4, 1)
          SetWarMap(x - i + 1, y - j + 1, 4, 1)
        end
      end
    end
    
    --宫本武藏，秒杀 - -
    if pid == 516 and WAR.KHCM[pid] ~= 1 then
      WAR.Person[id]["特效文字3"] = "二天一流秘奥义·万物一空"  --二天一流秘奥义·万物一空
      WAR.Person[id]["特效动画"] = 6
      WAR.GBWZ = 1
      WAR.WS = 1
      ng = ng + 1500
    end
      
      
    if WAR.Data["代号"] == 130 then
      for j = 0, WAR.PersonNum - 1 do
        if WAR.Person[j]["人物编号"] == 541 and WAR.Person[j]["死亡"] == false and WAR.Person[j]["我方"] == WAR.Person[WAR.CurID]["我方"] then
          WAR.BSMT = 1
          WAR.WS = 1
          ng = ng + 1500
          WAR.Person[id]["特效文字1"] = "毗沙门天之加护"  --毗沙门天之加护
          WAR.Person[id]["特效动画"] = 6
        end
      end
    end
    
    --田伯光特色指令，文字显示
    if pid == 29 then
    	if WAR.L_TBGZL == 1 and JLSD(30, 90, pid) then
    		if WAR.Person[id]["特效文字1"] ~= nil then
    			WAR.Person[id]["特效文字1"] = WAR.Person[id]["特效文字1"] .. "+淫荡动世人";
    		else
    			WAR.Person[id]["特效文字1"] = "淫荡动世人";
    		end
    		ng = ng + 1000;
    	end
    end
    
    
      
    --辟邪剑法 葵花刺目
    --if JY.Person[pid]["武功" .. wugongnum] == 48 and JY.Person[pid]["武功等级" .. wugongnum] == 999 and WAR.NGJL == 105 and WAR.KHCM[pid] ~= 1 then
     -- WAR.KHBX = 1
      --WAR.Person[id]["特效文字3"] = "真辟邪剑法·葵花刺目"  --真辟邪剑法·葵花刺目
      --WAR.Person[id]["特效动画"] = 6
    --end
    
    --蓝烟清：葵花神功加力，必造成刺目
    if WAR.L_SGJL == 105 then
		if wugong == 48 then
			WAR.KHBX = 2
			WAR.Person[id]["特效文字3"] = "真辟邪剑法·葵花刺目";
			WAR.Person[id]["特效动画"] = 6
		else
			WAR.KHBX = 1
			if WAR.Person[id]["特效文字3"] ~= nil then
				WAR.Person[id]["特效文字3"] = WAR.Person[id]["特效文字3"] .. "·葵花刺目";
			else
				WAR.Person[id]["特效文字3"] = "葵花刺目";
			end
			WAR.Person[id]["特效动画"] = 6
    	end
    end
    
    --盲目状态·攻击无效
    if WAR.KHCM[pid] == 1 or WAR.KHCM[pid] == 2 then
      WAR.Person[id]["特效动画"] = 89
      WAR.Person[id]["特效文字2"] = "状态·盲目攻击"  --状态·攻击无效
    end
    
    --蓝烟清：独孤求败攻击，X为10时发动全屏攻击，通过X不断变化被攻击的人数
    if pid == 592 then

    	local num = WAR.L_DGQB_X;
    	local n = 0;
    	local person = {};
    	--清掉之前的范围
  		CleanWarMap(4, 0)
  		
  		
      for i = 0, WAR.PersonNum - 1 do
        if WAR.Person[i]["我方"] ~= WAR.Person[WAR.CurID]["我方"] and WAR.Person[i]["死亡"] == false then
          n = n + 1
					person[n] = i;
          
        end
      end
      
      --根据不同的X攻击不同的敌人
      if n <= num or WAR.L_DGQB_X >= 10 then
      	for i=1, n do
      		SetWarMap(WAR.Person[person[i]]["坐标X"], WAR.Person[person[i]]["坐标Y"], 4, 1)
      	end
      else
      	while num > 0 do
      		local t = math.random(n);
      		if person[t] ~= nil then
      			SetWarMap(WAR.Person[person[t]]["坐标X"], WAR.Person[person[t]]["坐标Y"], 4, 1)
      			person[t] = nil;
      			num = num - 1;
      		end
      	end
      end
      
      
	  local str = WAR.L_DGQB_ZS[limitX(WAR.L_DGQB_X,1, 10)]
      WAR.Person[id]["特效文字3"] = str;
      Cls()
      ShowScreen()
      if WAR.L_DGQB_X >= 10 then		--独孤求败发动极意后，恢复５００命，２０００内力，内伤和中毒减半
	      WAR.Person[id]["生命点数"] = (WAR.Person[id]["生命点数"] or 0) + AddPersonAttrib(pid, "生命", 500);
	      WAR.Person[id]["内力点数"] = (WAR.Person[id]["内力点数"] or 0) + AddPersonAttrib(pid, "内力", 2000);
	      WAR.Person[id]["解毒点数"] = (WAR.Person[id]["解毒点数"] or 0) - AddPersonAttrib(pid, "中毒程度", -50);
		  	AddPersonAttrib(pid, "受伤程度", -50);
				WAR.Person[id]["特效动画"] = 6
	      for i = 1, 10 do
	        NewDrawString(-1, -1, str, C_GOLD, CC.DefaultFont + i)
	        ShowScreen()
	        if i == 10 then
	          Cls()
	          NewDrawString(-1, -1, str, C_GOLD, CC.DefaultFont + i)
	          ShowScreen()
	          lib.Delay(500)
	        else
	          lib.Delay(1)
	        end
	      end
	    end
  	end

            
    local xb = JY.Wugong[wugong]["武功类型"]
    local pz = math.modf(JY.Person[0]["资质"] / 5)
    
    --主角剑神大招，全屏攻击
    if pid == 0 and GetS(4, 5, 5, 5) == 2 and 120 <= JY.Person[pid]["御剑能力"] and 0 < JY.Person[pid]["武功10"] and xb == 2 and wugong ~= 49 and wugong ~= 43 and JLSD(30, 50 + pz, pid) and GetS(53, 0, 4, 5) == 1 then
      CleanWarMap(4, 0)
      for i = 0, WAR.PersonNum - 1 do
        if WAR.Person[i]["我方"] ~= WAR.Person[WAR.CurID]["我方"] and WAR.Person[i]["死亡"] == false then
          SetWarMap(WAR.Person[i]["坐标X"], WAR.Person[i]["坐标Y"], 4, 1)
        end
      end
      WAR.Person[id]["特效动画"] = 6
      if WAR.Person[id]["特效文字3"] == nil then
        WAR.Person[id]["特效文字3"] = ZJTF[2]
      else
        WAR.Person[id]["特效文字3"] = ZJTF[2] .. "·" .. WAR.Person[id]["特效文字3"]
      end
      ng = ng + 1500
      WAR.WS = 1
      Cls()
      --[[
      if JY.HEADXZ == 1 then    --大贴图
        lib.PicLoadCache(91, 2, 100, -1, 1)
      else
        lib.PicLoadCache(91, 2, -1, 1, 1)
      end
      ]]
      
      ShowScreen()
      lib.Delay(40)
      for i = 1, 10 do
        NewDrawString(-1, -1, ZJTF[2] .. TFSSJ[2], C_GOLD, CC.DefaultFont + i*2)
        ShowScreen()
        if i == 10 then
          Cls()
          NewDrawString(-1, -1, ZJTF[2] .. TFSSJ[2], C_GOLD, CC.DefaultFont + i*2)
          ShowScreen()
          lib.Delay(500)
        else
          lib.Delay(1)
        end
      end
      WAR.JSYX = 1
    end
      
    --主角拳系大招
    if pid == 0 and GetS(4, 5, 5, 5) == 1 and 0 < JY.Person[pid]["武功10"] and 120 <= JY.Person[pid]["拳掌功夫"] and JLSD(30, 50 + pz, pid) and (xb == 1 or wugong == 49) and GetS(53, 0, 4, 5) == 1 then
      WAR.Person[id]["特效动画"] = 6
      if WAR.Person[id]["特效文字3"] == nil then
        WAR.Person[id]["特效文字3"] = ZJTF[1]
      else
        WAR.Person[id]["特效文字3"] = ZJTF[1] .. "·" .. WAR.Person[id]["特效文字3"]
      end
      ng = ng + 1200
      WAR.WS = 1
      Cls()
      --[[
      if JY.HEADXZ == 1 then
        lib.PicLoadCache(91, 0, -1, -1, 1)
      else
        lib.PicLoadCache(91, 0, 25, 1, 1)
      end
      ]]
      
      ShowScreen()
      lib.Delay(40)
      for i = 1, 10 do
        NewDrawString(-1, -1, ZJTF[1] .. TFSSJ[1], C_GOLD, CC.DefaultFont + i*2)
        ShowScreen()
        if i == 10 then
          Cls()
          NewDrawString(-1, -1, ZJTF[1] .. TFSSJ[1], C_GOLD, CC.DefaultFont + i*2)
          ShowScreen()
          lib.Delay(500)
        else
          lib.Delay(1)
        end
      end
      WAR.LXZQ = 1
    end
    
    --主角特系大招
    if pid == 0 and GetS(4, 5, 5, 5) == 4 and 0 < JY.Person[pid]["武功10"] and 120 <= JY.Person[pid]["特殊兵器"] and JLSD(25, 55 + pz, pid) and xb == 4 and GetS(53, 0, 4, 5) == 1 then
      WAR.Person[id]["特效动画"] = 6
      if WAR.Person[id]["特效文字3"] == nil then
        WAR.Person[id]["特效文字3"] = ZJTF[4]
      else
        WAR.Person[id]["特效文字3"] = ZJTF[4] .. "·" .. WAR.Person[id]["特效文字3"]
      end
      ng = ng + 1000
      WAR.WS = 1
      Cls()
      --[[
      if JY.HEADXZ == 1 then
        lib.PicLoadCache(91, 6, -100, -1, 1)
      else
        lib.PicLoadCache(91, 6, 130, 1, 1)
      end
      ]]
      
      ShowScreen()
      lib.Delay(40)
      for i = 1, 10 do
        NewDrawString(-1, -1, ZJTF[4] .. TFSSJ[4], C_GOLD, CC.DefaultFont + i*2)
        ShowScreen()
        if i == 10 then
          Cls()
          NewDrawString(-1, -1, ZJTF[4] .. TFSSJ[4], C_GOLD, CC.DefaultFont + i*2)
          ShowScreen()
          lib.Delay(500)
        else
          lib.Delay(1)
        end
      end
      WAR.GCTJ = 1
    end
    
    --主角刀系大招
    if pid == 0 and GetS(4, 5, 5, 5) == 3 and 0 < JY.Person[pid]["武功10"] and 120 <= JY.Person[pid]["耍刀技巧"] and JLSD(30, 55 + pz, pid) and xb == 3 and GetS(53, 0, 4, 5) == 1 then
      WAR.Person[id]["特效动画"] = 6
      if WAR.Person[id]["特效文字3"] == nil then
        WAR.Person[id]["特效文字3"] = ZJTF[3]
      else
        WAR.Person[id]["特效文字3"] = ZJTF[3] .. "·" .. WAR.Person[id]["特效文字3"]
      end
      ng = ng + 2000
      WAR.WS = 1
      Cls()
      --[[
      if JY.HEADXZ == 1 then
        lib.PicLoadCache(91, 4, -1, -1, 1)
      else
        lib.PicLoadCache(91, 4, 55, 1, 1)
      end
      ]]
      
      ShowScreen()
      lib.Delay(40)
      for i = 1, 10 do
        NewDrawString(-1, -1, ZJTF[3] .. TFSSJ[3], C_GOLD, CC.DefaultFont + i*2)
        ShowScreen()
        if i == 10 then
          Cls()
          NewDrawString(-1, -1, ZJTF[3] .. TFSSJ[3], C_GOLD, CC.DefaultFont + i*2)
          ShowScreen()
          lib.Delay(500)
        else
          lib.Delay(1)
        end
      end
      WAR.ASKD = 1
    end
      
    --主角天罡大招
    if pid == 0 and GetS(4, 5, 5, 5) == 5 and WAR.JSTG < 150 and WAR.DZXY ~= 1 and JLSD(25, 55 + pz, pid) and GetS(53, 0, 4, 5) == 1 then
      local tg = 0
      for i = 1, 10 do
        if (84 < JY.Person[pid]["武功" .. i] and JY.Person[pid]["武功" .. i] < 109 and JY.Person[pid]["武功" .. i] ~= 86) or JY.Person[pid]["武功" .. i] == 43 and JY.Person[pid]["武功等级" .. i] == 999 then
          tg = tg + 1
        end
      end
	    if tg == 10 then
	      Cls()
	      --[[
	      if JY.HEADXZ == 1 then
	        lib.PicLoadCache(91, 8, 100, -1, 1)
	      else
	        lib.PicLoadCache(91, 8, 49, 1, 1)
	      end
	      ]]
	      
	      ShowScreen()
	      lib.Delay(40)
	      for i = 1, 10 do
	        NewDrawString(-1, -1, ZJTF[5] .. TFSSJ[5], C_GOLD, CC.DefaultFont + i*2)
	        ShowScreen()
	        if i == 10 then
	          Cls()
	          NewDrawString(-1, -1, ZJTF[5] .. TFSSJ[5], C_GOLD, CC.DefaultFont + i*2)
	          ShowScreen()
	          lib.Delay(500)
	        else
	          lib.Delay(1)
	        end
	      end
	      WAR.JSTG = 150 + JY.Thing[202][WZ7]*30
	    end
	  end
	  
	  --蓝烟清：杨过 黯然神伤特效文字
	  
    if pid == 58 and fightnum == 3 and GetS(86,11,11,5) == 2 then
    	--暂时加在这里
  		local ARSSJY = {"黯然极意·六神不安","黯然极意·倒行逆施","黯然极意·行尸走肉"}
  		WAR.Person[id]["特效文字3"] = ARSSJY[WAR.ACT];
  	end
    
    --怒气暴发
    if WAR.LQZ[pid] == 100 and WAR.DZXY ~= 1 and WAR.SQFJ ~= 1 then
      WAR.Person[id]["特效动画"] = 6
      if WAR.Person[id]["特效文字1"] ~= nil then
        WAR.Person[id]["特效文字1"] = WAR.Person[id]["特效文字1"] .. "+会心之一击"
      else
        WAR.Person[id]["特效文字1"] = "会心之一击"   --会心之一击
      end
      ng = ng + 1500
    end
      
    --蓄力攻击
    if WAR.Actup[pid] ~= nil then
    	local str = "蓄力攻击";  --ALungky: 修复蓄力攻击前面有时候会有两个加号
    	if PersonKF(pid, 103) then    --学龙象+1200杀集气
        ng = ng + 1200
        WAR.L_LXXL = 1;			--造成迟缓
        str = JY.Wugong[103]["名称"].."+蓄力攻击";
      else
      	ng = ng + 600
      end
      
      if WAR.Person[id]["特效文字1"] ~= nil then
        WAR.Person[id]["特效文字1"] = WAR.Person[id]["特效文字1"] .. "+"..str  --蓄力攻击
      else
        WAR.Person[id]["特效文字1"] = "蓄力攻击"
      end
    end
    
    
    --蓝烟清：使用九阴白骨爪并且九阴神功加力时，额外大幅度增加杀气
	 	if WAR.L_SGJL == 107 and wugong == 11 then
	 		ng = ng + 1200;
	 	end
    
    --蓝烟清：装备屠龙刀，使用等级为极的刀法提高40%暴击率，暴击的情况下有50%机率大幅度杀集气，并且造成流血。杀集气量与武功威力有关
  	if WAR.L_TLD == 1 then
			ng = ng + JY.Wugong[wugong]["攻击力10"];
			WAR.Person[WAR.CurID]["特效文字3"] = JY.Thing[43]["名称"].."·".."暴击"
  	end
  	
    --brolycjw: 石中玉攻击的地方，如果有石破天，那么就为无误伤攻击
  	if pid == 591 and WAR.Person[id]["我方"] then
	    for i = 0, CC.WarWidth - 1 do
	      for j = 0, CC.WarHeight - 1 do
	        local effect = GetWarMap(i, j, 4)
	        if 0 < effect then
	          local emeny = GetWarMap(i, j, 2)
	    			if 0 <= emeny and WAR.Person[emeny]["人物编号"] == 38 then
	    				WAR.WS = 1;
	    				if WAR.Person[id]["特效文字1"] ~= nil then
	        			WAR.Person[id]["特效文字1"] = WAR.Person[id]["特效文字1"] .. "+相煎何太急"
	      			else
	        			WAR.Person[id]["特效文字1"] = "相煎何太急"
	      			end
	    				break;
	    			end
	    		end
	    	end
	    end
	  end
	  
	 --brolycjw: 石破天攻击的地方，如果有石中玉，那么就为无误伤攻击
  	if pid == 38 and WAR.Person[id]["我方"] then
	    for i = 0, CC.WarWidth - 1 do
	      for j = 0, CC.WarHeight - 1 do
	        local effect = GetWarMap(i, j, 4)
	        if 0 < effect then
	          local emeny = GetWarMap(i, j, 2)
	    			if 0 <= emeny and WAR.Person[emeny]["人物编号"] == 591 then
	    				WAR.WS = 1;
	    				if WAR.Person[id]["特效文字1"] ~= nil then
	        			WAR.Person[id]["特效文字1"] = WAR.Person[id]["特效文字1"] .. "+相煎何太急"
	      			else
	        			WAR.Person[id]["特效文字1"] = "相煎何太急"
	      			end
	    				break;
	    			end
	    		end
	    	end
	    end
	  end
	  
	  --蓝烟清：持瑶琴
  	if wugong == 73  then
  		WAR.WS = 1;
	    for i = 0, CC.WarWidth - 1 do
	      for j = 0, CC.WarHeight - 1 do
	        local effect = GetWarMap(i, j, 4)
	        if 0 < effect then
	          local emeny = GetWarMap(i, j, 2)
	    			if 0 <= emeny and WAR.Person[id]["我方"] == WAR.Person[emeny]["我方"] and emeny ~= WAR.CurID then
	    				local tp = WAR.Person[emeny]["人物编号"];
	    				WAR.Person[emeny]["体力点数"] = (WAR.Person[emeny]["体力点数"] or 0) + AddPersonAttrib(tp, "体力", 10);
	    				AddPersonAttrib(tp, "受伤程度", -10);
	    				SetWarMap(i, j, 4, 2)
	    			end
	    		end
	    	end
	    end
	  end

    --特效文字1，动画为红色圈
    if WAR.Person[id]["特效文字1"] ~= nil and WAR.Person[id]["特效动画"] == -1 then
      WAR.Person[id]["特效动画"] = 88
    end
    
    --宗师攻击，无误伤
    if pid == 0 and GetS(53, 0, 2, 5) == 3 then
    	WAR.WS = 1;
    end
      
    --计算伤害的敌人
    for i = 0, CC.WarWidth - 1 do
      for j = 0, CC.WarHeight - 1 do
        local effect = GetWarMap(i, j, 4)
        if 0 < effect then
          local emeny = GetWarMap(i, j, 2)
	        if 0 <= emeny and emeny ~= WAR.CurID then		--如果有人，并且不是当前控制人
	        
						if WAR.Person[WAR.CurID]["我方"] ~= WAR.Person[emeny]["我方"] or (WAR.tmp[1000 + pid] ~= nil or (ZHEN_ID < 0 and WAR.WS == 0)) then
		          if JY.Wugong[wugong]["伤害类型"] == 1 and (fightscope == 0 or fightscope == 3) then
		            if level == 11 then
		              level = 10
		            end
		            WAR.Person[emeny]["内力点数"] = (WAR.Person[emeny]["内力点数"] or 0) - War_WugongHurtNeili(emeny, wugong, level)
		            SetWarMap(i, j, 4, 3)
		            WAR.Effect = 3
			        else
			          WAR.Person[emeny]["生命点数"] = (WAR.Person[emeny]["生命点数"] or 0) - War_WugongHurtLife(emeny, wugong, level, ng, x, y)
			          WAR.Effect = 2
			          SetWarMap(i, j, 4, 2)
			        end
			     	end
		      end
		    end
      end
    end
	    

    local dhxg = JY.Wugong[wugong]["武功动画&音效"]
    if WAR.LXZQ == 1 then
      dhxg = 71
    elseif WAR.JSYX == 1 then
        dhxg = 84
    elseif WAR.ASKD == 1 then
        dhxg = 65
    elseif WAR.GCTJ == 1 then
        dhxg = 108
    end
    
		
		War_ShowFight(pid, wugong, JY.Wugong[wugong]["武功类型"], level, x, y, dhxg, ZHEN_ID)
		War_Show_Count(WAR.CurID);		--显示当前控制人的点数
    
    WAR.Person[WAR.CurID]["经验"] = WAR.Person[WAR.CurID]["经验"] + 2
    local rz = 0
    if WAR.Person[id]["我方"] then
    	rz = 4;
    else
    	rz = 40
    end
    
    if JY.WGLVXS == 1 then
      rz = 100
    end
    
    --武功增加经验和升级
    if inteam(pid) then
      if JY.Person[pid]["武功等级" .. wugongnum] < 900 then
        JY.Person[pid]["武功等级" .. wugongnum] = JY.Person[pid]["武功等级" .. wugongnum] + 2 + Rnd(2)
	    elseif JY.Person[pid]["武功等级" .. wugongnum] < 999 then
	      --JY.Person[pid]["武功等级" .. wugongnum] = JY.Person[pid]["武功等级" .. wugongnum] + math.modf(JY.Person[pid]["资质"] / 20 + math.random(2)) + rz
	    	--空挥一次到极
	    	JY.Person[pid]["武功等级" .. wugongnum] = JY.Person[pid]["武功等级" .. wugongnum] + 100;
	    	--武功提升为极
	      if 999 <= JY.Person[pid]["武功等级" .. wugongnum] then
	        JY.Person[pid]["武功等级" .. wugongnum] = 999
	        PlayWavAtk(42)
	        DrawStrBoxWaitKey(string.format("%s修炼%s到登峰造极", JY.Person[pid]["姓名"], JY.Wugong[JY.Person[pid]["武功" .. wugongnum]]["名称"]), C_ORANGE, CC.DefaultFont)

	        
	        --石破天 太玄神功为极，增加轻功50
	        if pid == 38 and JY.Person[pid]["武功" .. wugongnum] == 102 then
	          say("１控制这蝌蚪一样的气流在体内游走越发随心所欲了！真有趣！", 38)
	          DrawStrBoxWaitKey("石破天轻功上升50点", C_ORANGE, CC.DefaultFont)
	          JY.Person[38]["轻功"] = JY.Person[38]["轻功"] + 50
	        end
	        
	        --狄云 神照功为极，增加轻功20点
	        if pid == 37 and JY.Person[pid]["武功" .. wugongnum] == 94 then
	          say("神照经当真奇妙，四肢百骸感觉劲力充盈。丁大哥，我一定不会让你失望的~~~", 37)
	          DrawStrBoxWaitKey("狄云领悟神照经的真髓，轻功加二十", C_ORANGE, CC.DefaultFont)
	          AddPersonAttrib(37, "轻功", 20)
	          SetS(86, 8, 10, 5, 2);
	        end
	        
	        --胡斐，胡家刀法到极，增加10点耍刀技巧
	        if pid == 1 and wugong == 67 then
	        	say("刀法真是越练越精妙", 1);
	        	DrawStrBoxWaitKey("胡斐攻、防、轻、耍刀技巧各增加10点", C_ORANGE, CC.DefaultFont)
	          AddPersonAttrib(1, "攻击力", 10)
	          AddPersonAttrib(1, "防御力", 10)
	          AddPersonAttrib(1, "轻功", 10)
	          AddPersonAttrib(1, "耍刀技巧", 10)
	        end
	      end
      end
        
      --武功提升普通等级
      if level < math.modf(JY.Person[pid]["武功等级" .. wugongnum] / 100) + 1 then
        level = math.modf(JY.Person[pid]["武功等级" .. wugongnum] / 100) + 1
        DrawStrBox(-1, -1, string.format("%s 升为 %d 级", JY.Wugong[JY.Person[pid]["武功" .. wugongnum]]["名称"], level), C_ORANGE, CC.DefaultFont)
        ShowScreen()
        lib.Delay(500)
        Cls()
        ShowScreen()
      end
    end
      
    --我方，消耗的内力
    if WAR.Person[WAR.CurID]["我方"] then
      local nl = nil
      if JY.Person[pid]["武功" .. wugongnum] == 43 then    --斗转星移 消耗
        nl = math.modf((level + 3) / 2) * JY.Wugong[wugong]["消耗内力点数"]
        if 400 < nl then
          nl = 400
        end
        if pid == 51 then    --慕容复消耗减半
          nl = math.modf(nl / 2)
        end
      else
        nl = math.modf((level + 3) / 2) * JY.Wugong[wugong]["消耗内力点数"]
      end
      
      --纯阳无极功消耗内力，补回一半
      for i = 1, 10 do
        if JY.Person[pid]["武功" .. i] == 99 then
          nl = nl - math.modf(nl * (JY.Person[pid]["武功等级" .. i] / 100 * 0.05))
          break;
        end
      end
      
      --蓝烟清：谢逊攻击，只消耗一半内力
      if pid == 13 then
      	nl = math.modf(nl/2);
      end
      
      --豪门护符，减少内力消耗
      if pid == JY.MY and GetS(53, 0, 2, 5) == 2 then
      	nl = nl - math.modf(limitX((2000-JY.Thing[238]["需经验"])/2000*nl,0, nl/2))
      	
      	--激活之后，消耗的内力大减
      	if GetS(53, 0, 5, 5) == 1 then
      	  if JLSD(0,15,pid) then
      			nl = math.modf(nl/3);
      		elseif JLSD(0,25,pid) then
      			nl = math.modf(nl/2);
      		end
      	end
      	
      end
      
      --阴内，攻击时，减少内力消耗
		  if JY.Person[pid]["内力性质"] == 0 then
		  	nl = math.modf(nl*(1-math.random(2)/10));
		  end
      
      AddPersonAttrib(pid, "内力", -(nl))    
    else
      if GetS(0, 0, 0, 0) ~= 1 then
        AddPersonAttrib(pid, "内力", -math.modf((level + 1) / 3) * JY.Wugong[wugong]["消耗内力点数"])           
      else
        AddPersonAttrib(pid, "内力", -math.modf((level + 1) / 6) * JY.Wugong[wugong]["消耗内力点数"])
      end
    end
    
    if JY.Person[pid]["内力"] < 0 then
      JY.Person[pid]["内力"] = 0
    end
    
    if JY.Person[pid]["生命"] <= 0 then
      break;
    end
    
  	DrawTimeBar2()
  	
  	--蓝烟清：独孤求败每次攻击之后X加1
  	if pid == 592 then
	  	if WAR.L_DGQB_X >= 10 then
	  		WAR.L_DGQB_X = 1;
	  	else
	  		WAR.L_DGQB_X = WAR.L_DGQB_X + 1;
	  	end
  	end
  	
  	--蓝烟清：使用非柔云剑法时，释放累加值
  	if wugong ~= 36 and WAR.L_RYJF[pid] ~= nil then
  		WAR.L_RYJF[pid] = 36;
  	end
  	
  	--蓝烟清：五岳剑法 特效取消
  	
  	if WAR.L_WYJFA ~= 0 then
  		if JLSD(20, 90, pid) then
  			WAR.L_WYJFA = wugong;
  		else
  			WAR.L_WYJFA = 0;
  		end
  	end
  	
 		WAR.ACT = WAR.ACT + 1   --统计攻击次数累加1
 		
  	--蓝烟清：攻击范围内的敌人全部死亡时取消连击
  	local flag = 0;
  	local n = 0;
    for i = 0, CC.WarWidth - 1 do
      for j = 0, CC.WarHeight - 1 do
        local effect = GetWarMap(i, j, 4)
        if 0 < effect then
          local emeny = GetWarMap(i, j, 2)
    			if 0 <= emeny and WAR.Person[id]["我方"] ~= WAR.Person[emeny]["我方"] then
    				n = n + 1;
    				if JY.Person[WAR.Person[emeny]["人物编号"]]["生命"] > 0 then
							flag = 1;
						end
    			end
    		end
    	end
    end
    
    if flag == 0 and n > 0 then
    	break;
    end
    
    

  end

	--蓝烟清：五岳剑法 特效取消
	WAR.L_WYJFA = 0;
  
  --计算消耗的体力
  local jtl = 0
  if 1100 <= WAR.WGWL then
    jtl = 7 + math.random(2)
  elseif 900 <= WAR.WGWL then
      jtl = 5 + math.random(2)
  elseif 600 <= WAR.WGWL then
      jtl = 3 + math.random(2)
  else
    jtl = 1 + math.random(2)
  end
  
  --豪门护符减少体力消耗
  if pid == JY.MY and GetS(53, 0, 2, 5) == 2 then
     jtl = jtl - math.modf(limitX((1500-JY.Thing[238]["需经验"])/1500*jtl,0, jtl/3))
     --激活之后，消耗的体力大减
  	if GetS(53, 0, 5, 5) == 1 then
  	  if JLSD(0,15,pid) then
  			jtl = limitX(jtl-math.random(2),0,jtl);
  		elseif JLSD(0,25,pid) then
  			jtl = limitX(jtl-1,0,jtl);
  		end
  	end
  end
  
  --阳内，攻击时，减少体力
  if JY.Person[pid]["内力性质"] == 1 then
  	jtl = limitX(jtl-math.random(2),0,jtl);
  end
    
  --人厨子
  if pid == 89 then
   	--人厨子攻击不消耗体力
  else
  	if WAR.Person[WAR.CurID]["我方"] then
    	AddPersonAttrib(pid, "体力", -(jtl))
    	
    	--被太玄神功攻击后，体力消耗加倍
 			if WAR.L_TXSG[pid] ~= nil then
 				AddPersonAttrib(pid, "体力", -(jtl));
 				WAR.L_TXSG[pid] = nil;
 			end
  	else
    	AddPersonAttrib(pid, "体力", -math.modf(jtl/2));
    	--被太玄神功攻击后，体力消耗加倍
 			if WAR.L_TXSG[pid] ~= nil then
 				AddPersonAttrib(pid, "体力", -(jtl));
 				WAR.L_TXSG[pid] = nil;
 			end
  	end
  end
    
  --斗转星移计算
  local dz = {}
  local dznum = 0
  for i = 0, WAR.PersonNum - 1 do
    if WAR.Person[i]["反击武功"] ~= -1 and WAR.Person[i]["反击武功"] ~= 9999 then
      dznum = dznum + 1
      dz[dznum] = {i, WAR.Person[i]["反击武功"], x - WAR.Person[WAR.CurID]["坐标X"], y - WAR.Person[WAR.CurID]["坐标Y"]}
      WAR.Person[i]["反击武功"] = 9999
    end
  end
  for i = 1, dznum do
    local tmp = WAR.CurID
    WAR.CurID = dz[i][1]
    WAR.DZXY = 1
    if WAR.DZXYLV[WAR.Person[WAR.CurID]["人物编号"]] == 1 then
      WAR.DZXYLV[WAR.Person[WAR.CurID]["人物编号"]] = 60
    elseif WAR.DZXYLV[WAR.Person[WAR.CurID]["人物编号"]] == 2 then
        WAR.DZXYLV[WAR.Person[WAR.CurID]["人物编号"]] = 85
    elseif WAR.DZXYLV[WAR.Person[WAR.CurID]["人物编号"]] == 3 then
        WAR.DZXYLV[WAR.Person[WAR.CurID]["人物编号"]] = 110
    end
    War_Fight_Sub(dz[i][1], dz[i][2] + 100, dz[i][3], dz[1][4])
    WAR.Person[WAR.CurID]["反击武功"] = -1
    WAR.DZXYLV[WAR.Person[WAR.CurID]["人物编号"]] = nil
    WAR.CurID = tmp
    WAR.DZXY = 0
  end
      
  --水镜四奇发动云体风身
  if WAR.YTFS == -1 then
    for i = 0, WAR.PersonNum - 1 do
      if WAR.Person[i]["人物编号"] == 0 and T2SQ(WAR.Person[i]["人物编号"]) then
        local tmp = WAR.CurID
        WAR.CurID = i
        WAR.SQFJ = 1
        WAR.YTFS = 0
        WarDrawMap(0)
        CurIDTXDH(i, 81, 0)
        CurIDTXDH(i, 79, 0)
        Cls()
        --lib.PicLoadCache(91, 14, 150, -1, 1)
        ShowScreen()
        lib.Delay(40)
        for ii = 12, 24 do
          NewDrawString(-1, -1, "云体风身反攻", C_GOLD, 25 + ii)
          ShowScreen()
          if ii == 24 then
            Cls()
            NewDrawString(-1, -1, "云体风身反攻", C_GOLD, 25 + ii)
            ShowScreen()
            lib.Delay(500)
          else
            lib.Delay(1)
          end
        end
        
        --云体风身反击
        War_Fight_Sub(i, 2, WAR.Person[i]["坐标X"], WAR.Person[i]["坐标Y"])
        
        WAR.SQFJ = 0
        --洗武功
        for w = 1, 10 do
          if JY.Person[0]["武功" .. w] == JY.Person[0]["武功2"] and w ~= 2 then
            JY.Person[0]["武功2"] = WAR.YT1
            JY.Person[0]["武功等级2"] = WAR.YT2
          end
        end
        
        WAR.CurID = tmp
      end
    end    
  end
  return 1;
end

function War_SelectMove()
  local x0 = WAR.Person[WAR.CurID]["坐标X"]
  local y0 = WAR.Person[WAR.CurID]["坐标Y"]
  local x = x0
  local y = y0
  while true do
    local x2 = x
    local y2 = y
    WarDrawMap(1, x, y)
    WarShowHead(GetWarMap(x, y, 2))
    ShowScreen()
    local key, ktype, mx, my = WaitKey(1)
    if key == VK_UP then
      y2 = y - 1
    elseif key == VK_DOWN then
      y2 = y + 1
    elseif key == VK_LEFT then
      x2 = x - 1
    elseif key == VK_RIGHT then
      x2 = x + 1
    elseif key == VK_SPACE or key == VK_RETURN then
      return x, y
    elseif key == VK_ESCAPE or ktype == 4 then
      return nil
    elseif ktype == 2 or ktype == 3 then
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
      mx = math.modf(mx)
      my = math.modf(my)
      for i = 0, 10 do
        if mx + i <= 63 then
          if my + i > 63 then
            break;
          end
        end
        local hb = GetS(JY.SubScene, x0 + mx + i, y0 + my + i, 4)

        if math.abs(hb - CC.YScale * i * 2) < 5 then
          mx = mx + i
          my = my + i
        end
      end
      x2, y2 = mx + x0, my + y0
      
      if ktype == 3 then
      	return x, y
    	end
    end
    
 	if x2 >= 0 and x2 < CC.WarWidth and y2 >= 0 and y2 < CC.WarHeight then
    if GetWarMap(x2, y2, 3) < 128 then
      x = x2
      y = y2
    end
  end
  end
end

--获取武功最小内力
function War_GetMinNeiLi(pid)
  local minv = math.huge
  for i = 1, 10 do
    local tmpid = JY.Person[pid]["武功" .. i]
    if tmpid > 0 and JY.Wugong[tmpid]["消耗内力点数"] < minv then
      minv = JY.Wugong[tmpid]["消耗内力点数"]
    end
  end
  return minv
end

function War_Manual()
  local r = nil
  local x, y, move, pic = WAR.Person[WAR.CurID]["坐标X"], WAR.Person[WAR.CurID]["坐标Y"], WAR.Person[WAR.CurID]["移动步数"], WAR.Person[WAR.CurID]["贴图"]
  while true do
	  WAR.ShowHead = 1
	  r = War_Manual_Sub()
	  if r == 1 or r == -1 then
	    WAR.Person[WAR.CurID]["移动步数"] = 0  
	  elseif r == 0 then
	    SetWarMap(WAR.Person[WAR.CurID]["坐标X"], WAR.Person[WAR.CurID]["坐标Y"], 2, -1)
	    SetWarMap(WAR.Person[WAR.CurID]["坐标X"], WAR.Person[WAR.CurID]["坐标Y"], 5, -1)
	    WAR.Person[WAR.CurID]["坐标X"], WAR.Person[WAR.CurID]["坐标Y"], WAR.Person[WAR.CurID]["移动步数"] = x, y, move
	    SetWarMap(WAR.Person[WAR.CurID]["坐标X"], WAR.Person[WAR.CurID]["坐标Y"], 2, WAR.CurID)
	    SetWarMap(WAR.Person[WAR.CurID]["坐标X"], WAR.Person[WAR.CurID]["坐标Y"], 5, pic)
	  else
	  	break;
	  end
	end
	WAR.ShowHead = 0
	WarDrawMap(0)
	return r
end
	      
--手动战斗菜单
function War_Manual_Sub()
  local pid = WAR.Person[WAR.CurID]["人物编号"]
  local isEsc = 0
  local warmenu = {
{"移动", War_MoveMenu, 1}, 
{"攻击", War_FightMenu, 1}, 
{"用毒", War_PoisonMenu, 1}, 
{"解毒", War_DecPoisonMenu, 1}, 
{"医疗", War_DoctorMenu, 1}, 
{"物品", War_ThingMenu, 1}, 
{"蓄力", War_ActupMenu, 1}, 
{"防御", War_DefupMenu, 1}, 
{"状态", War_StatusMenu, 1}, 
{"休息", War_RestMenu, 1}, 
{"特色", War_TgrtsMenu, 1}, 
{"专属", War_JTMenu, 0}, 
{"自动", War_AutoMenu, 1}
}

	--特色指令
  if GRTS[pid] ~= nil then
    warmenu[11][1] = GRTS[pid]
  else
    warmenu[11][3] = 0
  end
  
  --虚竹
  if pid == 49 then
    local t = 0
    for i = 0, WAR.PersonNum - 1 do
      local wid = WAR.Person[i]["人物编号"]
      if WAR.TZ_XZ_SSH[wid] == 1 and WAR.Person[i]["死亡"] == false then
        t = 1
      end
    end
    if t == 0 then
      warmenu[11][3] = 0
    end
    if JY.Person[pid]["体力"] < 20 then   --体力小于20不显示特色指令
    	warmenu[11][3] = 0
    end
  end
  
  --祖千秋
  if pid == 88 then
    local yes = 0
    for i = 0, WAR.PersonNum - 1 do
      if WAR.Person[i]["我方"] == true and WAR.Person[i]["死亡"] == false and RealJL(WAR.CurID, i, 5) and i ~= WAR.CurID then
        yes = 1
      end
    end
    if yes == 0 then
      warmenu[11][3] = 0
    end
    if JY.Person[pid]["体力"] < 10 then
    	warmenu[11][3] = 0
    end
  end
  
  --人厨子
  if pid == 89 then
    local px, py = WAR.Person[WAR.CurID]["坐标X"], WAR.Person[WAR.CurID]["坐标Y"]
    local mxy = {
			{WAR.Person[WAR.CurID]["坐标X"], WAR.Person[WAR.CurID]["坐标Y"] + 1}, 
			{WAR.Person[WAR.CurID]["坐标X"], WAR.Person[WAR.CurID]["坐标Y"] - 1}, 
			{WAR.Person[WAR.CurID]["坐标X"] + 1, WAR.Person[WAR.CurID]["坐标Y"]}, 
			{WAR.Person[WAR.CurID]["坐标X"] - 1, WAR.Person[WAR.CurID]["坐标Y"]}}

    local yes = 0
    for i = 1, 4 do
      if GetWarMap(mxy[i][1], mxy[i][2], 2) >= 0 then
        local mid = GetWarMap(mxy[i][1], mxy[i][2], 2)
        if inteam(WAR.Person[mid]["人物编号"]) then
        	yes = 1
    		end
      end  
    end
    if yes == 0 then
      warmenu[11][3] = 0
    end
    if JY.Person[pid]["体力"] < 25 then
   		warmenu[11][3] = 0
   	end
  end

	--张无忌
  if pid == 9 then
    local yes = 0
    for i = 0, WAR.PersonNum - 1 do
      if WAR.Person[i]["我方"] == true and WAR.Person[i]["死亡"] == false and RealJL(WAR.CurID, i, 8) and i ~= WAR.CurID then
        yes = 1
      end
    end
    if yes == 0 then
      warmenu[11][3] = 0
    end
    if JY.Person[pid]["体力"] < 10 then
			warmenu[11][3] = 0
    end
  end
  
  if pid == 9 and JY.Person[pid]["体力"] < 20 then
    warmenu[11][3] = 0
  end
  
  --蓝烟清：霍青桐统率指令
  if pid == 74 then
    if JY.Person[pid]["体力"] <= 10 then
    	warmenu[11][3] = 0
    end
  end
  
  --蓝烟清：平一指疗伤指令
  if pid == 28 then
  	if JY.Person[pid]["体力"] < 50 then
    	warmenu[11][3] = 0
    end
  end
  
  --蓝烟清：李文秀天铃指令
  if pid == 590 and WAR.L_LWX == 1 then
  	warmenu[11][3] = 0
  end
  
  --蓝烟清：主角召唤独孤前辈
  if pid == 0 then
  	if WAR.L_DGQB_ZL == 1 or JY.Person[pid]["体力"] < 50 or JY.Person[pid]["内力"] < 500 or JY.Person[592]["声望"] > 3 or GetS(86,10,20,5) ~= 1 then
  		warmenu[11][3] = 0
  	end
  end
  
  --蓝烟清：田伯光 特色指令
  if pid == 29 then
  	if (GetS(86,10,12,5) ~= 1 and GetS(86,10,12,5) ~= 2) or JY.Person[pid]["内力"] < 500 or JY.Person[pid]["体力"] < 50 then
  		warmenu[11][3] = 0
  	end
  end

  
  --出左右时，只有攻击和休息可见
  if WAR.ZYHB == 2 then
    for i = 1, 12 do
      if i == 2 or i == 10 then
        i = i + 1
      end
      warmenu[i][3] = 0
    end
  end
  
  --体力小于5或者已经移动过时，移动不可见
  if JY.Person[pid]["体力"] <= 5 or WAR.Person[WAR.CurID]["移动步数"] <= 0 then
    warmenu[1][3] = 0
    isEsc = 1
  end
  
  --判断最小内力，是否可显示攻击
  local minv = War_GetMinNeiLi(pid)
  if JY.Person[pid]["内力"] < minv or JY.Person[pid]["体力"] < 10 then
    warmenu[2][3] = 0
  end
  
  if JY.Person[pid]["体力"] < 10 or JY.Person[pid]["用毒能力"] < 20 then
    warmenu[3][3] = 0
  end
  if JY.Person[pid]["体力"] < 10 or JY.Person[pid]["解毒能力"] < 20 then
    warmenu[4][3] = 0
  end
  if JY.Person[pid]["体力"] < 50 or JY.Person[pid]["医疗能力"] < 20 then
    warmenu[5][3] = 0
  end
  
  --逆运走火状态
  if WAR.tmp[1000 + pid] == 1 then
    for i = 3, 12 do
      warmenu[i][3] = 0
    end
    warmenu[10][3] = 1
  end
  
  --新华山论剑，不可使用物品
  if WAR.ZDDH == 238 then
    warmenu[6][3] = 0
  end
  
  --宗师，可以选择是否攻击击退
  if pid == 0 and GetS(53, 0, 2, 5) == 3 then
  	warmenu[12][3] = 1
  end
  
  lib.GetKey()
  Cls()
  DrawTimeBar_sub()
  return ShowMenu(warmenu, #warmenu, 0, CC.MainMenuX, CC.MainMenuY, 0, 0, 1, isEsc, CC.DefaultFont, C_ORANGE, C_WHITE)
end

--修炼武功
function War_PersonTrainBook(pid)
  local p = JY.Person[pid]
  local thingid = p["修炼物品"]
  if thingid < 0 then
    return 
  end
  JY.Thing[101]["加御剑能力"] = 1
  JY.Thing[123]["加拳掌功夫"] = 1
  local wugongid = JY.Thing[thingid]["练出武功"]
  local wg = 0
  if JY.Person[pid]["武功10"] > 0 and wugongid >= 0 then
    for i = 1, 10 do
      if JY.Thing[thingid]["练出武功"] == JY.Person[pid]["武功" .. i] then
        wg = 1
      end
    end
  if wg == 0 then		--修复第一版本，不可修炼武功的BUG
  	return 
	end
  end
  
  
  local yes1, yes2, kfnum = false, false, nil
  while true do 
	  local needpoint = TrainNeedExp(pid)
	  if needpoint <= p["修炼点数"] then
	    yes1 = true
	    AddPersonAttrib(pid, "生命最大值", JY.Thing[thingid]["加生命最大值"])
	    if thingid == 139 then
	      AddPersonAttrib(pid, "生命最大值", -15)
	      AddPersonAttrib(pid, "生命", -15)
	      if JY.Person[pid]["生命最大值"] < 1 then
	        JY.Person[pid]["生命最大值"] = 1
	      end
	    end
	    if JY.Person[pid]["生命"] < 1 then
	      JY.Person[pid]["生命"] = 1
	    end
	    if JY.Thing[thingid]["改变内力性质"] == 2 then
	      p["内力性质"] = 2
	    end
	    
	    AddPersonAttrib(pid, "内力最大值", JY.Thing[thingid]["加内力最大值"])
	    AddPersonAttrib(pid, "攻击力", JY.Thing[thingid]["加攻击力"])
	    AddPersonAttrib(pid, "轻功", JY.Thing[thingid]["加轻功"])
	    AddPersonAttrib(pid, "防御力", JY.Thing[thingid]["加防御力"])
	    AddPersonAttrib(pid, "医疗能力", JY.Thing[thingid]["加医疗能力"])
	    AddPersonAttrib(pid, "用毒能力", JY.Thing[thingid]["加用毒能力"])
	    AddPersonAttrib(pid, "解毒能力", JY.Thing[thingid]["加解毒能力"])
	    AddPersonAttrib(pid, "抗毒能力", JY.Thing[thingid]["加抗毒能力"])
	    if pid == 56 then		--黄蓉 双倍兵器值
	      AddPersonAttrib(pid, "拳掌功夫", JY.Thing[thingid]["加拳掌功夫"] * 2)
	      AddPersonAttrib(pid, "御剑能力", JY.Thing[thingid]["加御剑能力"] * 2)
	      AddPersonAttrib(pid, "耍刀技巧", JY.Thing[thingid]["加耍刀技巧"] * 2)
	      AddPersonAttrib(pid, "特殊兵器", JY.Thing[thingid]["加特殊兵器"] * 2)
	    elseif pid == 590 then		--李文秀 双倍特殊兵器值
	    	AddPersonAttrib(pid, "拳掌功夫", JY.Thing[thingid]["加拳掌功夫"])
	      AddPersonAttrib(pid, "御剑能力", JY.Thing[thingid]["加御剑能力"])
	      AddPersonAttrib(pid, "耍刀技巧", JY.Thing[thingid]["加耍刀技巧"])
	      AddPersonAttrib(pid, "特殊兵器", JY.Thing[thingid]["加特殊兵器"]*2)
	    else
	      AddPersonAttrib(pid, "拳掌功夫", JY.Thing[thingid]["加拳掌功夫"])
	      AddPersonAttrib(pid, "御剑能力", JY.Thing[thingid]["加御剑能力"])
	      AddPersonAttrib(pid, "耍刀技巧", JY.Thing[thingid]["加耍刀技巧"])
	      AddPersonAttrib(pid, "特殊兵器", JY.Thing[thingid]["加特殊兵器"])
	    end
	    
	    --蓝烟清：StarShine萧中慧的天赋，额外增加三围
	    if pid == 77 then		-- 萧中慧天赋
				AddPersonAttrib(pid,"攻击力",JY.Thing[thingid]["加耍刀技巧"]);
				AddPersonAttrib(pid,"轻功",JY.Thing[thingid]["加耍刀技巧"]);
				AddPersonAttrib(pid,"防御力",JY.Thing[thingid]["加耍刀技巧"]);
			end

	    
	    AddPersonAttrib(pid, "暗器技巧", JY.Thing[thingid]["加暗器技巧"])
	    AddPersonAttrib(pid, "武学常识", JY.Thing[thingid]["加武学常识"])
	    AddPersonAttrib(pid, "品德", JY.Thing[thingid]["加品德"])
	    AddPersonAttrib(pid, "攻击带毒", JY.Thing[thingid]["加攻击带毒"])
	    if JY.Thing[thingid]["加攻击次数"] == 1 then
	      p["左右互搏"] = 1
	    end
	    if thingid > 186 then
	      p["修炼点数"] = p["修炼点数"] - needpoint
	    end
	    if JY.WGLVXS == 0 and thingid < 187 then
	      p["修炼点数"] = p["修炼点数"] - needpoint
	    end
	    
	    if wugongid >= 0 then 
	      yes2 = true
	      local oldwugong = 0
	      for i = 1, 10 do
	        if p["武功" .. i] == wugongid then
	          oldwugong = 1
	          p["武功等级" .. i] = math.modf((p["武功等级" .. i] + 100) / 100) * 100
	          kfnum = i
	          break;
	        end
	      end
	      if oldwugong == 0 then
			    for i = 1, 10 do
			      if p["武功" .. i] == 0 then
			        p["武功" .. i] = wugongid
			        p["武功等级" .. i] = 0;
			        kfnum = i
			        break;
			      end
			    end
			  end
	    end
	    
	    
	  else
	  	break;
		end
	end
	if yes1 then
		DrawStrBoxWaitKey(string.format("%s 修炼 %s 成功", p["姓名"], JY.Thing[thingid]["名称"]), C_WHITE, CC.DefaultFont)
	end
	if yes2 then
		DrawStrBoxWaitKey(string.format("%s 升为第%s级", JY.Wugong[wugongid]["名称"], math.modf(p["武功等级" .. kfnum] / 100) + 1), C_WHITE, CC.DefaultFont)
	end
end

--宗师 攻击击退选择
function War_JTMenu()
	local pid = WAR.Person[WAR.CurID]["人物编号"]
  Cls()
  WAR.ShowHead = 0
  WarDrawMap(0)
  
  local jt = "击退"
  if WAR.ZSJT == 1 then
    jt = "取消击退";
  end
  
  local yn = JYMsgBox("专属技能","击退或取消击退*击退攻击打退敌人，取消击退则固定* *侦破地形*重新审视当前地形，消耗10点体力和500点内力*需求：体力大于30点" ,{jt, "侦破地形"}, 2, pid,1)
  --击退选项
  if yn == 1 then
    if WAR.ZSJT == 1 then
    	WAR.ZSJT = 2;
    else
    	WAR.ZSJT = 1;
    end
 	elseif yn == 2 then		--重新获取地形
 		if pid == 0 then
	    if JY.Person[pid]["体力"] >= 30 and JY.Person[pid]["内力"] > 500 then
	      
	      CleanWarMap(6,-2);
	      WarNewLand();
	      
	      JY.Person[pid]["体力"] = JY.Person[pid]["体力"] - 10
	      JY.Person[pid]["内力"] = JY.Person[pid]["内力"]-500
				
				CurIDTXDH(WAR.CurID, 71,0, "侦破地形")
				WAR.tmp[8003] = 3     --增加集气速度
	      return 1
	    else
	    	DrawStrBoxWaitKey("未满足发动条件", C_WHITE, CC.DefaultFont)
	    	return 0
	    end
  	end
  end
  
  return 0;
end

--特色指令
function War_TgrtsMenu()
  local pid = WAR.Person[WAR.CurID]["人物编号"]
  Cls()
  WAR.ShowHead = 0
  WarDrawMap(0)
  local yn = JYMsgBox("特色指令：" .. GRTS[pid], GRTSSAY[pid], {"确定", "取消"}, 2, pid)
  if yn == 2 then
    return 0
  end
  
  --段誉  
  if pid == 53 then
    if JY.Person[pid]["体力"] > 20 then
      WAR.TZ_DY = 1
      PlayWavE(16)
      CurIDTXDH(WAR.CurID, 71,0, "休迅飞凫 飘忽若神")
      JY.Person[pid]["体力"] = JY.Person[pid]["体力"] - 10
    else
    	DrawStrBoxWaitKey("未满足发动条件", C_WHITE, CC.DefaultFont)
    	return 0
    end
  end
  
  --虚竹
  if pid == 49 then
    if JY.Person[pid]["体力"] > 20 and JY.Person[pid]["内力"] > 1000 then
      JY.Person[pid]["体力"] = JY.Person[pid]["体力"] - 5
      JY.Person[pid]["内力"] = JY.Person[pid]["内力"] - 500
      local ssh = {}
      local num = 1
      for i = 0, WAR.PersonNum - 1 do
        local wid = WAR.Person[i]["人物编号"]
        if WAR.TZ_XZ_SSH[wid] == 1 and WAR.Person[i]["死亡"] == false then
          if WAR.FXDS[wid] == nil then
            WAR.FXDS[wid] = 25
          else
            WAR.FXDS[wid] = WAR.FXDS[wid] + 25
          end
          if WAR.FXDS[wid] > 50 then
            WAR.FXDS[wid] = 50
          end
          WAR.TZ_XZ_SSH[wid] = nil
          if WAR.Person[i].Time > 995 then
            WAR.Person[i].Time = 995
          end
          ssh[num] = {}
          ssh[num][1] = i
          ssh[num][2] = wid
          num = num + 1
        end
      end
      local name = {}
      for i = 1, num - 1 do
        name[i] = {}
        name[i][1] = JY.Person[ssh[i][2]]["姓名"]
        name[i][2] = nil
        name[i][3] = 1
      end
      DrawStrBox(CC.MainMenuX, CC.MainMenuY, "催符：", C_GOLD, CC.DefaultFont)
      ShowMenu(name, num - 1, 10, CC.MainMenuX, CC.MainMenuY + 45, 0, 0, 1, 0, CC.DefaultFont, C_RED, C_GOLD)
      Cls()
      PlayWavAtk(32)
      CurIDTXDH(WAR.CurID, 72,0, "符掌生死 德折群雄")
      PlayWavE(8)
      local sssid = lib.SaveSur(0, 0, CC.ScreenW, CC.ScreenH)
      for DH = 114, 129 do
        for i = 1, num - 1 do
          local x0 = WAR.Person[WAR.CurID]["坐标X"]
          local y0 = WAR.Person[WAR.CurID]["坐标Y"]
          local dx = WAR.Person[ssh[i][1]]["坐标X"] - x0
          local dy = WAR.Person[ssh[i][1]]["坐标Y"] - y0
          local rx = CC.XScale * (dx - dy) + CC.ScreenW / 2
          local ry = CC.YScale * (dx + dy) + CC.ScreenH / 2
          local hb = GetS(JY.SubScene, dx + x0, dy + y0, 4)

          ry = ry - hb
          lib.PicLoadCache(3, DH * 2, rx, ry, 2, 192)
          if DH > 124 then
            DrawString(rx - 10, ry - 15, "封穴", C_GOLD, CC.DefaultFont)
          end
        end
        lib.ShowSurface(0)
        lib.LoadSur(sssid, 0, 0)
        lib.Delay(30)
      end
      lib.FreeSur(sssid)
    else
    	DrawStrBoxWaitKey("未满足发动条件", C_WHITE, CC.DefaultFont)
    	return 0
    end
  end
  
  --人厨子
  if pid == 89 then
    if JY.Person[pid]["体力"] > 25 and JY.Person[pid]["内力"] > 300 then
      local px, py = WAR.Person[WAR.CurID]["坐标X"], WAR.Person[WAR.CurID]["坐标Y"]
      local mxy = {
{WAR.Person[WAR.CurID]["坐标X"], WAR.Person[WAR.CurID]["坐标Y"] + 1}, 
{WAR.Person[WAR.CurID]["坐标X"], WAR.Person[WAR.CurID]["坐标Y"] - 1}, 
{WAR.Person[WAR.CurID]["坐标X"] + 1, WAR.Person[WAR.CurID]["坐标Y"]}, 
{WAR.Person[WAR.CurID]["坐标X"] - 1, WAR.Person[WAR.CurID]["坐标Y"]}}
      local zdp = {}
      local num = 1
      for i = 1, 4 do
        if GetWarMap(mxy[i][1], mxy[i][2], 2) >= 0 then
          local mid = GetWarMap(mxy[i][1], mxy[i][2], 2)
          if inteam(WAR.Person[mid]["人物编号"]) then
          	zdp[num] = WAR.Person[mid]["人物编号"]
          	num = num + 1
        	end
        end
        
      end
      local zdp2 = {}
      for i = 1, num - 1 do
        zdp2[i] = {}
        zdp2[i][1] = JY.Person[zdp[i]]["姓名"] .. "·" .. JY.Person[zdp[i]]["体力"]
        zdp2[i][2] = nil
        zdp2[i][3] = 1
      end
      DrawStrBox(CC.MainMenuX, CC.MainMenuY, "气补：", C_GOLD, CC.DefaultFont)
      local r = ShowMenu(zdp2, num - 1, 10, CC.MainMenuX, CC.MainMenuY + 45, 0, 0, 1, 0, CC.DefaultFont, C_RED, C_GOLD)
      Cls()
      AddPersonAttrib(zdp[r], "体力", 50)
      AddPersonAttrib(89, "体力", -25)
      AddPersonAttrib(89, "内力", -300)
      PlayWavE(28)
      lib.Delay(10)
      CurIDTXDH(WAR.CurID, 86,0, "化气补元")
      local Ocur = WAR.CurID
      for i = 0, WAR.PersonNum - 1 do
        if WAR.Person[i]["人物编号"] == zdp[r] then
          WAR.CurID = i
        end
      end
      WarDrawMap(0)
      PlayWavE(36)
      lib.Delay(100)
      CurIDTXDH(WAR.CurID, 86, 0, "恢复体力50点")
      WAR.CurID = Ocur
      WarDrawMap(0)
    else
    	DrawStrBoxWaitKey("未满足发动条件", C_WHITE, CC.DefaultFont)
    	return 0
    end
  end
  
  --张无忌
  if pid == 9 then
    if JY.Person[pid]["体力"] > 10 and JY.Person[pid]["内力"] > 500 then
      local nyp = {}
      local num = 1
      for i = 0, WAR.PersonNum - 1 do
        if WAR.Person[i]["我方"] == true and WAR.Person[i]["死亡"] == false and RealJL(WAR.CurID, i, 8) and i ~= WAR.CurID then
          nyp[num] = {}
          nyp[num][1] = JY.Person[WAR.Person[i]["人物编号"]]["姓名"]
          nyp[num][2] = nil
          nyp[num][3] = 1
          nyp[num][4] = i
          num = num + 1
        end
      end
      DrawStrBox(CC.MainMenuX, CC.MainMenuY, "挪移：", C_GOLD, CC.DefaultFont)
      local r = ShowMenu(nyp, num - 1, 10, CC.MainMenuX, CC.MainMenuY + 45, 0, 0, 1, 0, CC.DefaultFont, C_RED, C_GOLD)
      Cls()
      local mid = WAR.Person[nyp[r][4]]["人物编号"]
      QZXS("请选择要将" .. JY.Person[mid]["姓名"] .. "挪移到什么位置？")
      War_CalMoveStep(WAR.CurID, 8, 1)
      local nx, ny = nil, nil
      while true do
	      nx, ny = War_SelectMove()
	      if nx ~= nil then
		      if lib.GetWarMap(nx, ny, 2) > 0 or lib.GetWarMap(nx, ny, 5) > 0 then
		        QZXS("此处有人！请重新选择")			--此处有人！请重新选择
	      	elseif CC.SceneWater[lib.GetWarMap(nx, ny, 0)] ~= nil then
	        	QZXS("水面，不可进入！请重新选择")		--水面，不可进入！请重新选择
	       	else
	       		break;
	        end
	      end
	    end
	    PlayWavE(5)
	    CurIDTXDH(WAR.CurID, 88,0, "九阳明尊 挪移乾坤")		--九阳明尊 挪移乾坤
	    local Ocur = WAR.CurID
	    WAR.CurID = nyp[r][4]
	    WarDrawMap(0)
	    CurIDTXDH(WAR.CurID, 88,0)
	    lib.SetWarMap(WAR.Person[WAR.CurID]["坐标X"], WAR.Person[WAR.CurID]["坐标Y"], 5, -1)
	    lib.SetWarMap(WAR.Person[WAR.CurID]["坐标X"], WAR.Person[WAR.CurID]["坐标Y"], 2, -1)
	    WarDrawMap(0)
	    CurIDTXDH(WAR.CurID, 88,0)
	    WAR.Person[WAR.CurID]["坐标X"], WAR.Person[WAR.CurID]["坐标Y"] = nx, ny
	    WarDrawMap(0)
	    CurIDTXDH(WAR.CurID, 88,0)
	    lib.SetWarMap(WAR.Person[WAR.CurID]["坐标X"], WAR.Person[WAR.CurID]["坐标Y"], 5, WAR.Person[WAR.CurID]["贴图"])
	    lib.SetWarMap(WAR.Person[WAR.CurID]["坐标X"], WAR.Person[WAR.CurID]["坐标Y"], 2, WAR.CurID)
	    WarDrawMap(0)
	    CurIDTXDH(WAR.CurID, 88,0)
	    WAR.CurID = Ocur
	    AddPersonAttrib(9, "体力", -10)
	    AddPersonAttrib(9, "内力", -500)
	    
	  else
	  	DrawStrBoxWaitKey("未满足发动条件", C_WHITE, CC.DefaultFont)
	  	return 0
	  end
	end
	
	--祖千秋
	if pid == 88 then
	  if JY.Person[pid]["体力"] > 10 and JY.Person[pid]["内力"] > 700 then
	    local dxp = {}
	    local num = 1
	    for i = 0, WAR.PersonNum - 1 do
	      if WAR.Person[i]["我方"] == true and WAR.Person[i]["死亡"] == false and RealJL(WAR.CurID, i, 5) and i ~= WAR.CurID then
	        dxp[num] = {}
	        dxp[num][1] = JY.Person[WAR.Person[i]["人物编号"]]["姓名"]
	        dxp[num][2] = nil
	        dxp[num][3] = 1
	        dxp[num][4] = i
	        num = num + 1
	      end
	    end
	    DrawStrBox(CC.MainMenuX, CC.MainMenuY, "传功：", C_GOLD, 30)
	    local r = ShowMenu(dxp, num - 1, 10, CC.MainMenuX, CC.MainMenuY + 45, 0, 0, 1, 0, CC.DefaultFont, C_RED, C_GOLD)
	    Cls()
	    local mid = WAR.Person[dxp[r][4]]["人物编号"]
	    PlayWavE(28)
	    lib.Delay(10)
	    CurIDTXDH(WAR.CurID,87,0, "酒神戏红尘")
	    local Ocur = WAR.CurID
	    WAR.CurID = dxp[r][4]
	    WarDrawMap(0)
	    PlayWavE(36)
	    lib.Delay(100)
	    CurIDTXDH(WAR.CurID, 87, 0, "集气上升500")
	    WAR.CurID = Ocur
	    WarDrawMap(0)
	    WAR.Person[dxp[r][4]].Time = WAR.Person[dxp[r][4]].Time + 500
	    if WAR.Person[dxp[r][4]].Time > 999 then
	      WAR.Person[dxp[r][4]].Time = 999
	    end
	    AddPersonAttrib(88, "体力", -10)
	    AddPersonAttrib(88, "内力", -1000)
	  else
	  	DrawStrBoxWaitKey("未满足发动条件", C_WHITE, CC.DefaultFont)
	  	return 0
		end
	end
	
	
	--蓝烟清：霍青桐统率指令，我方全体集气值加200点
	if pid == 74 then
		if JY.Person[pid]["体力"] > 10 and JY.Person[pid]["内力"] > 150 then
			CurIDTXDH(WAR.CurID, 92,0, GRTS[74]);		--动画显示
			for i = 0, WAR.PersonNum - 1 do
				if WAR.Person[i]["我方"] == true and WAR.Person[i]["死亡"] == false and i ~= WAR.CurID then
					WAR.Person[i].Time = WAR.Person[i].Time + 200;
					if WAR.Person[i].Time > 999 then
						WAR.Person[i].Time = 999;
					end
				end
			end
			AddPersonAttrib(74, "体力", -10)
	    AddPersonAttrib(74, "内力", -150)
	    lib.Delay(100)
		else
			DrawStrBoxWaitKey("未满足发动条件", C_WHITE, CC.DefaultFont)
	  	return 0
		end
	end
	
	--蓝烟清：平一指疗伤指令，我方全体回复一定生命值和内伤
	if pid == 28 then
		if JY.Person[pid]["体力"] >= 50 and JY.Person[pid]["内力"] > 250 then
			CleanWarMap(4,0);
			AddPersonAttrib(28, "体力", -10)
	    AddPersonAttrib(28, "内力", -250)
			for i = 0, WAR.PersonNum - 1 do
				if WAR.Person[i]["我方"] == true and WAR.Person[i]["死亡"] == false then
					local id = WAR.Person[i]["人物编号"];
					local add = JY.Person[28]["医疗能力"]/4 + JY.Person[28]["医疗能力"]*WAR.PYZ/16 + math.random(30);		--和杀人数有关
					if add > JY.Person[28]["医疗能力"]/2 then	--最大为医疗值的一半
						add = JY.Person[28]["医疗能力"]/2 + math.random(30) + 30;
					end
					
					add = math.modf(add);		
					WAR.Person[i]["内伤点数"] = (WAR.Person[i]["内伤点数"] or 0) + AddPersonAttrib(id, "受伤程度", -math.modf((add) / 5));
					WAR.Person[i]["生命点数"] = (WAR.Person[i]["生命点数"] or 0) + AddPersonAttrib(id, "生命", add);
					
					
					SetWarMap(WAR.Person[i]["坐标X"], WAR.Person[i]["坐标Y"], 4, 4)
					
				end
			end
			WAR.Person[WAR.CurID]["特效文字2"] = GRTS[28];
			
			War_ShowFight(28,0,0,0,WAR.Person[WAR.CurID]["坐标X"],WAR.Person[WAR.CurID]["坐标Y"],0);
		else
			DrawStrBoxWaitKey("未满足发动条件", C_WHITE, CC.DefaultFont)
	  	return 0
		end
	end
	
	--Star：萧中慧--慧心
	if pid == 77 then
		if JY.Person[pid]["生命"] > 500 and JY.Person[pid]["受伤程度"] < 50 then
			local zjwid = nil
			for i = 0, WAR.PersonNum - 1 do
				if WAR.Person[i]["人物编号"] == 0 and WAR.Person[i]["死亡"] == false then
					zjwid = i
					break
				end
			end
			if zjwid ~= nil then
				DrawStrBoxWaitKey("我心本慧·侠女柔情", C_RED, 36)
				say("２慧妹！。。。。",0)
				say("１ｎ哥哥，９请。。。。。。２加油！",77)
				JY.Person[pid]["生命"] = 1
				JY.Person[pid]["受伤程度"] = 100
				WAR.Person[WAR.CurID].Time = -500
				JY.Person[0]["生命"] = JY.Person[0]["生命最大值"]
				JY.Person[0]["受伤程度"] = 0
				WAR.Person[zjwid].Time = 999
				WAR.FXDS[0] = nil
				WAR.LQZ[0] = 100
			else
				DrawStrBoxWaitKey("未满足发动条件", C_WHITE, CC.DefaultFont)		-- "未满足发动条件"
				return 0
			end

		else
			DrawStrBoxWaitKey("未满足发动条件", C_WHITE, CC.DefaultFont)		-- "未满足发动条件"
			return 0
		end
	end
	
	--蓝烟清：李文秀天铃指令，全体队友回复李文秀当前生命、内力、体力的一半，并回复内伤、封穴、流血状态。
	--使用后李文秀生命、内力、体力为1，内伤、封穴、流血为满
	if pid == 590 then
		if WAR.L_LWX == 0 then
			CurIDTXDH(WAR.CurID,33,0, GRTS[590]);		--动画显示
			lib.Delay(100);
			for i = 0, WAR.PersonNum - 1 do
				if WAR.Person[i]["我方"] == true and WAR.Person[i]["死亡"] == false and i ~= WAR.CurID then
					local id = WAR.Person[i]["人物编号"];
					
					AddPersonAttrib(id, "生命", math.modf(JY.Person[590]["生命"]/2));
					AddPersonAttrib(id, "内力", math.modf(JY.Person[590]["内力"]/2));
					AddPersonAttrib(id, "体力", math.modf(JY.Person[590]["体力"]/2));
					JY.Person[id]["受伤程度"] = 0;
					WAR.FXDS[id] = nil;
					WAR.LXZT[id] = nil;

				end
			end
			
			JY.Person[590]["生命"] = 1;
			JY.Person[590]["内力"] = 1;
			JY.Person[590]["体力"] = 1;
			JY.Person[590]["受伤程度"] = 100;
			WAR.FXDS[590] = 50
			WAR.LXZT[590] = 100
			WAR.L_LWX = 1;
		else
			DrawStrBoxWaitKey("未满足发动条件", C_WHITE, CC.DefaultFont)
	  	return 0
		end
	end
	
	--蓝烟清：王难姑特色指令 - 施毒  周围五格范围内的敌人时序中毒并时序减血
	if pid == 17 then
		if JY.Person[pid]["体力"] >= 30 and JY.Person[pid]["内力"] >= 300 then
			CleanWarMap(4,0);
			AddPersonAttrib(17, "体力", -15)
	    AddPersonAttrib(17, "内力", -300)
			local x1 = WAR.Person[WAR.CurID]["坐标X"];
			local y1 = WAR.Person[WAR.CurID]["坐标Y"];
			for ex = x1 - 5, x1 + 5 do
	      for ey = y1 - 5, y1 + 5 do
	        SetWarMap(ex, ey, 4, 1)
	        if GetWarMap(ex, ey, 2) ~= nil and GetWarMap(ex, ey, 2) > -1 then
	          local ep = GetWarMap(ex, ey, 2)
	          if WAR.Person[WAR.CurID]["我方"] ~= WAR.Person[ep]["我方"] then
	          
	          	WAR.L_WNGZL[WAR.Person[ep]["人物编号"]] = 50;			--50时序内持续减中毒+减血
		          SetWarMap(ex, ey, 4, 4)
		        end
	        end
	      end
	    end
			War_ShowFight(17,0,0,0,x1,y1,30);
		else
			DrawStrBoxWaitKey("未满足发动条件", C_WHITE, CC.DefaultFont)
	  	return 0
	  end
	end
	
		--brolycjw：胡青牛特色指令 - 群疗  周围四格范围内的队友时序回内伤并按比例回血
	if pid == 16 then
		if JY.Person[pid]["体力"] >= 30 and JY.Person[pid]["内力"] >= 300 then
			CleanWarMap(4,0);
			AddPersonAttrib(16, "体力", -15)
	    AddPersonAttrib(16, "内力", -300)
			local x1 = WAR.Person[WAR.CurID]["坐标X"];
			local y1 = WAR.Person[WAR.CurID]["坐标Y"];
			
			for ex = x1 - 4, x1 + 4 do
	      for ey = y1 - 4, y1 + 4 do
	        SetWarMap(ex, ey, 4, 1)
	        if GetWarMap(ex, ey, 2) ~= nil and GetWarMap(ex, ey, 2) > -1 then
	          local ep = GetWarMap(ex, ey, 2)
	          if WAR.Person[WAR.CurID]["我方"] == WAR.Person[ep]["我方"] then
	          
	          	WAR.L_HQNZL[WAR.Person[ep]["人物编号"]] = 20;			--20时序内持续回血+回内伤
		          SetWarMap(ex, ey, 4, 4)
		          
		        end
	        end
	      end
	    end
			War_ShowFight(17,0,0,0,x1,y1,0);

		else
			DrawStrBoxWaitKey("未满足发动条件", C_WHITE, CC.DefaultFont)
	  	return 0
	  end
	end
	
	--蓝烟清：主角召唤独孤求败
	if pid == 0 then
		if JY.Person[pid]["体力"] >= 50 and JY.Person[pid]["内力"] >= 500 and WAR.L_DGQB_ZL == 0  then
		
			AddPersonAttrib(0, "体力", -15)
	    AddPersonAttrib(0, "内力", -500)
		
			local x, y = WE_xy(WAR.Person[WAR.CurID]["坐标X"], WAR.Person[WAR.CurID]["坐标Y"] - 1)
			NewWARPersonZJ(592, true, x, y, false, 2);
      local s = nil
      s = WAR.CurID
      WAR.CurID = WAR.PersonNum - 1
      Talk("难得如此大战，不来参加真是可惜啊~~~哈哈~~~", 592)  
      WAR.CurID = s
      
      WAR.L_DGQB_ZL = 1;
      JY.Person[592]["声望"] = JY.Person[592]["声望"] + 1;
		else
			DrawStrBoxWaitKey("未满足发动条件", C_WHITE, CC.DefaultFont)
	  	return 0
	  end
	end
	
	--蓝烟清：田伯光指令
	if pid == 29 then
		if JY.Person[pid]["体力"] >= 50 and JY.Person[pid]["内力"] >= 500 then
			
	    AddPersonAttrib(29, "内力", -500)
	    
	    if GetS(86,10,12,5) == 1 then			--浪荡
	    	AddPersonAttrib(29, "体力", -12)
				WAR.L_TBGZL = 1;
			elseif GetS(86,10,12,5) == 2 then		--戒色
				AddPersonAttrib(29, "体力", -10)
				WAR.L_TBGZL = 2;
			end
	    
			War_FightMenu();
			
		else
			DrawStrBoxWaitKey("未满足发动条件", C_WHITE, CC.DefaultFont)
	  	return 0
	  end

	end
	
	return 1
end

--战斗蓄力
function War_ActupMenu()
  local p = WAR.CurID
  local id = WAR.Person[p]["人物编号"]
  local x0, y0 = WAR.Person[p]["坐标X"], WAR.Person[p]["坐标Y"]
  
  if PersonKF(id, 95) then		--有蛤蟆功，蓄力必成功，并且下回合必出蟾震九天
  	WAR.Actup[id] = 2;
  	WAR.tmp[200 + id] = 101;		--蓝烟清：蛤蟆蓄力直接满100
  	CurIDTXDH(WAR.CurID, 87, 0, "蛤蟆蓄力成功");
  	return 1;
  elseif id == 0 and GetS(4, 5, 5, 5) == 1 then		--主角，灵犀真拳，蓄力必成功而且进入蓄力防御状态
  	WAR.Actup[id] = 2	
  elseif PersonKF(id, 103) then			--龙象，蓄力必成功
    WAR.Actup[id] = 2
  elseif JLSD(15, 85, id) then
    WAR.Actup[id] = 2
  end
  if WAR.Actup[id] ~= 2 then
    Cls()
    DrawStrBox(-1, -1, "蓄力失败", C_GOLD, CC.DefaultFont)
    ShowScreen()
    lib.Delay(500)
  else
  	CurIDTXDH(WAR.CurID, 85, 0, "蓄力成功");
    
    lib.Delay(500)
  end
  return 1
end


--战斗防御
function War_DefupMenu()
  local p = WAR.CurID
  local id = WAR.Person[p]["人物编号"]
  local x0, y0 = WAR.Person[p]["坐标X"], WAR.Person[p]["坐标Y"]
  WAR.Defup[id] = 1
  Cls()
  local hb = GetS(JY.SubScene, x0, y0, 4)

  
  if PersonKF(id, 95) then		--有蛤蟆功，防御成功后下回合必出蟾震九天
  	WAR.Actup[id] = 2;
  	WAR.tmp[200 + id] = 101;		--蓝烟清：蛤蟆蓄力直接满100
  	CurIDTXDH(WAR.CurID, 85,0, "蛤蟆蓄力成功");
  	return 1;
  end
  
  CurIDTXDH(WAR.CurID, 86,0, "防御开始");
  return 1
end

--设置人物的集气值，返回一个综合值以便循环刷新集气条
function GetJiqi()
  local num, total = 0, 0
  local function getnewmove(x, flag)
    if not flag then
      x = x * 2
    end
    if x > 160 then
      return 6 + (x - 160) / 60
    elseif x > 80 then
      return 4 + (x - 80) / 40
    elseif x > 30 then
      return 2 + (x - 30) / 25
    else
      return x / 15
    end
  end
  local function getnewmove1(a, b, flag)
    local x = (a * 2 + b) / 3
    if not flag then
      x = x * 2
    end
    if x > 5600 then
      return 8 + math.min((x - 5600) / 1200, 3)
    elseif x > 3600 then
      return 6 + (x - 3600) / 1000
    elseif x > 2000 then
      return 4 + (x - 2000) / 800
    elseif x > 800 then
      return 2 + (x - 800) / 600
    else
      return x / 400
    end
  end
  for i = 0, WAR.PersonNum - 1 do
    if not WAR.Person[i]["死亡"] then
      local id = WAR.Person[i]["人物编号"]
      local nsyxjq = math.modf(JY.Person[id]["受伤程度"] / 25)
      WAR.Person[i].TimeAdd = math.modf(getnewmove(WAR.Person[i]["轻功"], inteam(id)) + getnewmove1(JY.Person[id]["内力"], JY.Person[id]["内力最大值"], inteam(id)) - JY.Person[id]["中毒程度"] / (15+math.random(5)) - nsyxjq + JY.Person[id]["体力"] / 20 + JY.Person[id]["攻击力"]/80 + 5 + math.random(3))
      
      --葵花神功加集气速度
      if PersonKF(id,105) then
          WAR.Person[i].TimeAdd = math.modf(WAR.Person[i].TimeAdd * 1.2)
      end
      
      --东方不败、胡斐、黄药师、血刀老祖、宫本武藏 有额外10点集气速度加成
      if id == 27 or id == 1 or id == 57 or id == 97 or id == 516 then
        WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd + 10
      end
      
      --田伯光 万里独行 人越少集气越快
      if id == 29 then
        WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd + 20
        for j = 0, WAR.PersonNum - 1 do
          if WAR.Person[j]["死亡"] == false and WAR.Person[j]["我方"] == WAR.Person[i]["我方"] then
            
            if GetS(86,10,12,5) ~= 0 then		--田伯光剧情过后，集气值减少
            	WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd - 2
            else
            	WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd - 4
            end
          end
        end
        
        if WAR.L_TBGZL == 2 then	--戒色指令提高集气速度
        	WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd + 5
        end
        
        
      end
      
      --剑神集气速度加成
      --蓝烟清：连城剑法，也加成
      if GetS(4, 5, 5, 5) == 2 and id == 0 then
        local jsyx = 0
        for i = 1, 10 do
          if (JY.Person[0]["武功" .. i] == 110 or JY.Person[0]["武功" .. i] == 114 or (JY.Person[0]["武功" .. i] <= 48 and JY.Person[0]["武功" .. i] >= 27 and JY.Person[0]["武功" .. i] ~= 43)) and JY.Person[0]["武功等级" .. i] == 999 then
            jsyx = jsyx + 1
          end
        end
        WAR.Person[i].TimeAdd = math.modf(WAR.Person[i].TimeAdd * (1 + 0.05 * (jsyx)))
      end
      
      --郭靖，我方每死亡一个人，集气速度+4
      if id == 55 then
        local xz = 0
        for j = 0, WAR.PersonNum - 1 do
          if WAR.Person[j]["死亡"] == true and WAR.Person[j]["我方"] == WAR.Person[i]["我方"] then
            WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd + 4
          end
        end
      end
      
      
      --圣火三使，同时在场时，每人集气速度额外+20点
      if WAR.ZDDH == 14 and (id == 173 or id == 174 or id == 175) then
        local shz = 0
        for j = 0, WAR.PersonNum - 1 do
          if WAR.Person[j]["死亡"] == false and WAR.Person[j]["我方"] == WAR.Person[i]["我方"] then
            shz = shz + 1
          end
        end
        
        if shz == 3 then
        	WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd + 20
      	end
      end
      
      --蓝烟清：天罡北斗阵
      if WAR.ZDDH == 73 and WAR.Person[i]["我方"] == false then
				WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd + 6
      end
      
      --4MM给所有人加集气速度
      if id == 92 then
        for j = 0, WAR.PersonNum - 1 do
	        if  WAR.Person[j]["死亡"] == false and WAR.Person[j]["我方"] == WAR.Person[i]["我方"] then
	        	WAR.Person[j].TimeAdd = WAR.Person[j].TimeAdd + 5
	        end
	      end
      end
      
      --乔峰，额外集气速度+20
      if id == 50 then
        WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd + 20
      end
      
	  --brolycjw: 独孤求败，额外集气速度
      if id == 592 then
        WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd + 10 + WAR.L_DGQB_X*2
      end
      
      --其徐如林集气加成
      if WAR.FLHS2 > 20 then
        WAR.FLHS2 = 20
      end
      if id == 0 then
        WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd + WAR.FLHS2
      end
      
      --成崑 ，额外集气速度+10
      if id == 18 then
        WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd + 10
      end
      
      --血刀老祖 集气速度额外加成
      if id == 97 then
        WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd + WAR.XDLZ
      end
      
      --王重阳、一灯 重生前额外集气速度+5
      if id == 129 or id == 65 then
        WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd + WAR.WCY * 5
      end
      
      --
      if id == 553 then
        WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd + WAR.YZB2 * 4
      end
      
      --平一指，集气速度额外加成5*杀人数
      if id == 28 then
        WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd + WAR.PYZ * 5
      end
      
      --蓝烟清：brolycjw杨过黯然神伤特效 集气速度加成
      --每多10点内伤集气速度增加5
      if id == 58 and JY.Person[58]["受伤程度"] > 50 and GetS(86,11,11,5) == 2 then
				--平滑设置计算新的加成，比如内伤为55时，增加2点集气速度
      	WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd + math.floor(JY.Person[58]["受伤程度"]-50)/2;
      end
      
      
		  
		  --蓝烟清：李文秀 集气速度+5点
		  if id == 590 then
		  	WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd + 5;
		  end
		  
		  --蓝烟清：装备白马 集气速度+5点，李文秀装备白马额外+5点
		  if inteam(id) and JY.Person[id]["防具"] == 230 then
		  	WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd + 5;
		  	if id == 590 then
		  		WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd + 5;
		  	end
		  end
		  
		  --蓝烟清：水笙在场，敌方集气速度减5点
		 if id == 589  then
    	for j = 0, WAR.PersonNum - 1 do
    		if WAR.Person[j]["死亡"] == false and WAR.Person[j]["我方"] ~= WAR.Person[i]["我方"] then
    			WAR.Person[j].TimeAdd = WAR.Person[j].TimeAdd - 5;   			
    		end
    	end
    end
		  
      
      --敌人根据难度集气速度额外增加
      if not inteam(id) then
        if JY.Thing[202][WZ7] > 1 then
        	WAR.Person[i].TimeAdd = math.modf(WAR.Person[i].TimeAdd * (1 + JY.Thing[202][WZ7]/15)) + math.random(5)
        end  
      end
      
      if WAR.ZDDH == 128 and inteam(id) == false and id ~= 553 and JY.Thing[202][WZ7] > 1 then
        WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd + 10
      end
      
      --内伤减集气
      if inteam(id) then
        WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd - math.modf(JY.Person[id]["受伤程度"] / 20)
      else
      	WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd - math.modf(JY.Person[id]["受伤程度"] / 30)
      end
      
      
      --蓝烟清：被迟缓时，集气速度减5点
      if WAR.CHZ[id] ~= nil and WAR.CHZ[id] > 0 then
      	WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd - 8;
      end
      
      
      --蓝烟清：brolycjw 杨过死后，小龙女与主角同时在场时，增加集气速度
      if id == 59 and GetS(86,11,11,5) == 1 then
		  	for j = 0, WAR.PersonNum - 1 do
		      if WAR.Person[j]["人物编号"] == 0 and WAR.Person[j]["死亡"] == false and WAR.Person[j]["我方"] == WAR.Person[WAR.CurID]["我方"] then
      			local value = (GetSZ(59) + GetSZ(0) - 4)/2000;			--(小龙女实战 + 主角实战) / 2000			
      			WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd + math.floor(value*20);	--小龙女集气速度增加
      			WAR.Person[j].TimeAdd = WAR.Person[j].TimeAdd + math.floor(value*20);	--主角集气速度增加
		      	break;
		      end
		    end
		  end
      
      if WAR.Person[i].TimeAdd < 10 then
        WAR.Person[i].TimeAdd = 10
      end
      
      --木桩不集气
      if (id == 445 or id == 446) and WAR.ZDDH == 226 then
        WAR.Person[i].TimeAdd = 0
      end
      
      if WAR.Person[i].TimeAdd > 80 then
        WAR.Person[i].TimeAdd = 80
      end
      
      --宗师，被攻击下回合提升集气速度
      if id == JY.MY and GetS(53, 0, 2, 5) == 3 and WAR.tmp[8003] ~= nil then
      	WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd * (1 + 0.3*WAR.tmp[8003]);
      	if GetS(53, 0, 4, 5) == 1 then
      		WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd * (1 + 0.2*WAR.tmp[8003]);
      	end
      end
      
      
      
      num = num + 1
      total = total + WAR.Person[i].TimeAdd
    end
  end
 

  
  WAR.LifeNum = num
  return math.modf(((total) / (num) + (num) - 2))
end


--武功范围选择
function War_KfMove(movefanwei, atkfanwei,wugong)
  local kind = movefanwei[1] or 0
  local len = movefanwei[2] or 0
  local x0 = WAR.Person[WAR.CurID]["坐标X"]
  local y0 = WAR.Person[WAR.CurID]["坐标Y"]
  local x = x0
  local y = y0
  if kind ~= nil then
    if kind == 0 then
      War_CalMoveStep(WAR.CurID, len, 1)
	  elseif kind == 1 then
	    War_CalMoveStep(WAR.CurID, len * 2, 1)
	    for r = 1, len * 2 do
	      for i = 0, r do
	        local j = r - i
	        if len < i or len < j then
	          SetWarMap(x0 + i, y0 + j, 3, 255)
	          SetWarMap(x0 + i, y0 - j, 3, 255)
	          SetWarMap(x0 - i, y0 + j, 3, 255)
	          SetWarMap(x0 - i, y0 - j, 3, 255)
	        end
	      end
	    end
	  elseif kind == 2 then
	    War_CalMoveStep(WAR.CurID, len, 1)
	    for i = 1, len - 1 do
	      for j = 1, len - 1 do
	        SetWarMap(x0 + i, y0 + j, 3, 255)
	        SetWarMap(x0 - i, y0 + j, 3, 255)
	        SetWarMap(x0 + i, y0 - j, 3, 255)
	        SetWarMap(x0 - i, y0 - j, 3, 255)
	      end
	    end
	  elseif kind == 3 then
	    War_CalMoveStep(WAR.CurID, 2, 1)
	    SetWarMap(x0 + 2, y0, 3, 255)
	    SetWarMap(x0 - 2, y0, 3, 255)
	    SetWarMap(x0, y0 + 2, 3, 255)
	    SetWarMap(x0, y0 - 2, 3, 255)
	  else
	    War_CalMoveStep(WAR.CurID, 0, 1)
	  end
  end
  
  
  
  while true do
    local x2 = x
    local y2 = y
    
    WarDrawMap(1, x, y)
    WarDrawAtt(x, y, atkfanwei, 1)
    
    --判断是否有合击者
    if x ~= x0 or y ~= y0 then
	    local ZHEN_ID = -1;
	    for i = 0, WAR.PersonNum - 1 do
		    if WAR.Person[WAR.CurID]["我方"] == WAR.Person[i]["我方"] and i ~= WAR.CurID and WAR.Person[i]["死亡"] == false then
		      local nx = WAR.Person[i]["坐标X"]
		      local ny = WAR.Person[i]["坐标Y"]
		      local fid = WAR.Person[i]["人物编号"]
		      for j = 1, 10 do
			      if JY.Person[fid]["武功" .. j] == wugong then         
			        if math.abs(nx-x0)+math.abs(ny-y0)<9 then
			          local flagx, flagy = 0, 0
			          if math.abs(nx - x0) <= 1 then
			            flagx = 1
			          end
			          if math.abs(ny - y0) <= 1 then
			            flagy = 1
			          end
			          if x0 == nx then
			            flagy = 1
			          end
			          if y0 == ny then
			            flagx = 1
			          end
			          if between(x, x0, nx, flagx) and between(y, y0, ny, flagy) then
					      	local dx = nx - x0
					        local dy = ny - y0
					        local size = CC.FontSmall;
					        local rx = CC.XScale * (dx - dy) + CC.ScreenW / 2
					        local ry = CC.YScale * (dx + dy) + CC.ScreenH / 2
					        
					        local hb = GetS(JY.SubScene, dx + x0, dy + y0, 4)
					        
					        DrawString(rx - size, ry-hb-size/2, "合击者", M_Purple, size);
			            ZHEN_ID = i
			            break;
			          end
			        end
			      end
			   	end
			   	if ZHEN_ID >= 0 then
		      	break;
		    	end
		    end
	    end
    end
    
    WarShowHead(GetWarMap(x, y, 2))
    ShowScreen()

    local key, ktype, mx, my = WaitKey(1)

    if key == VK_UP then
      y2 = y - 1
    elseif key == VK_DOWN then
      y2 = y + 1
    elseif key == VK_LEFT then
      x2 = x - 1
    elseif key == VK_RIGHT then
      x2 = x + 1
    elseif (key == VK_SPACE or key == VK_RETURN) then
      return x, y

    elseif key == VK_ESCAPE or ktype == 4 then
      return nil
    elseif ktype == 2 or ktype == 3 then
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
      mx = math.modf(mx)
      my = math.modf(my)
      for i = 1, 20 do
        if mx + i > 63 or my + i > 63 then
           return;
        end
        local hb = GetS(JY.SubScene, mx + i, my + i, 4)

        if math.abs(hb - CC.YScale * i * 2) < 8 then
          mx = mx + i
          my = my + i
        end
      end
      
      x2, y2 = mx + x0, my + y0
	    if ktype == 3 and (kind < 2 or x ~= x0 or y ~= y0) then
	      return x, y					
	    end
	    
    end
    if x2 >= 0 and x2 < CC.WarWidth and y2 >= 0 and y2 < CC.WarHeight then
			if GetWarMap(x2, y2, 3) ~= nil and GetWarMap(x2, y2, 3) < 128 then
	      x = x2
	      y = y2
		  end
		end
  end
end
--WarDrawAtt 
function WarDrawAtt(x, y, fanwei, flag, cx, cy, atk)
  local x0, y0 = nil
  if cx == nil or cy == nil then
    x0 = WAR.Person[WAR.CurID]["坐标X"]
    y0 = WAR.Person[WAR.CurID]["坐标Y"]
  else
    x0, y0 = cx, cy
  end
  local kind = fanwei[1]			--攻击范围
  local len1 = fanwei[2]
  local len2 = fanwei[3]
  local len3 = fanwei[4]
  local len4 = fanwei[5]
  local xy = {}
  local num = 0
  if kind == 0 then
    num = 1
    xy[1] = {x, y}
  elseif kind == 1 then
    if not len1 then
      len1 = 0
    end
    if not len2 then
      len2 = 0
    end
    num = num + 1
    xy[num] = {x, y}
    for i = 1, len1 do
      xy[num + 1] = {x + i, y}
      xy[num + 2] = {x - i, y}
      xy[num + 3] = {x, y + i}
      xy[num + 4] = {x, y - i}
      num = num + 4
    end
    for i = 1, len2 do
      xy[num + 1] = {x + i, y + i}
      xy[num + 2] = {x - i, y - i}
      xy[num + 3] = {x - i, y + i}
      xy[num + 4] = {x + i, y - i}
      num = num + 4
    end
  elseif kind == 2 then
    for tx = x - len1, x + len1 do
      for ty = y - len1, y + len1 do
        if len1 < math.abs(tx - x) + math.abs(ty - y) then
          
        else
        	num = num + 1
        	xy[num] = {tx, ty}
        end
        
      end
    end
  elseif kind == 3 then
    if not len2 then
      len2 = len1
    end
    local dx, dy = math.abs(x - x0), math.abs(y - y0)
    if dy < dx then
      len1, len2 = len2, len1
    end
    for tx = x - len1, x + len1 do
      for ty = y - len2, y + len2 do
        num = num + 1
        xy[num] = {tx, ty}
      end
    end
  elseif kind == 5 then
    if not len1 then
      len1 = 0
    end
    if not len2 then
      len2 = 0
    end
    num = num + 1
    xy[num] = {x, y}
    for i = 1, len1 do
      xy[num + 1] = {x + i, y}
      xy[num + 2] = {x - i, y}
      xy[num + 3] = {x, y + i}
      xy[num + 4] = {x, y - i}
      num = num + 4
    end
    if len2 > 0 then
      xy[num + 1] = {x + 1, y + 1}
      xy[num + 2] = {x + 1, y - 1}
      xy[num + 3] = {x - 1, y + 1}
      xy[num + 4] = {x - 1, y - 1}
      num = num + 4
    end
    for i = 2, len2 do
      xy[num + 1] = {x + i, y + 1}
      xy[num + 2] = {x - i, y - 1}
      xy[num + 3] = {x - i, y + 1}
      xy[num + 4] = {x + i, y - 1}
      xy[num + 5] = {x + 1, y + i}
      xy[num + 6] = {x - 1, y - i}
      xy[num + 7] = {x - 1, y + i}
      xy[num + 8] = {x + 1, y - i}
      num = num + 8
    end
  elseif kind == 6 then
    if not len2 then
      len2 = len1
    end
    xy[1] = {x + 1, y}
    xy[2] = {x - 1, y}
    xy[3] = {x, y + 1}
    xy[4] = {x, y - 1}
    num = num + 4
    if len1 > 0 or len2 > 0 then
      xy[5] = {x + 1, y + 1}
      xy[6] = {x + 1, y - 1}
      xy[7] = {x - 1, y + 1}
      xy[8] = {x - 1, y - 1}
      num = num + 4
      for i = 2, len1 do
        xy[num + 1] = {x + i, y + 1}
        xy[num + 2] = {x - i, y + 1}
        xy[num + 3] = {x + i, y - 1}
        xy[num + 4] = {x - i, y - 1}
        num = num + 4
      end
      for i = 2, len2 do
        xy[num + 1] = {x + 1, y + i}
        xy[num + 2] = {x + 1, y - i}
        xy[num + 3] = {x - 1, y + i}
        xy[num + 4] = {x - 1, y - i}
        num = num + 4
      end
    end
  elseif kind == 7 then
    if not len2 then
      len2 = len1
    end
    if len1 == 0 then
      for i = y - len2, y + len2 do
        num = num + 1
        xy[num] = {x, i}
      end
    elseif len2 == 0 then
      for i = x - len1, x + len1 do
        num = num + 1
        xy[num] = {i, y}
      end
    else
      for i = x - len1, x + len1 do
        num = num + 1
        xy[num] = {i, y}
        num = num + 1
        xy[num] = {i, y + len2}
        num = num + 1
        xy[num] = {i, y - len2}
      end
      for i = 1, len2 - 1 do
        xy[num + 1] = {x, y + i}
        xy[num + 2] = {x, y - i}
        xy[num + 3] = {x - len1, y + i}
        xy[num + 4] = {x - len1, y - i}
        xy[num + 5] = {x + len1, y + i}
        xy[num + 6] = {x + len1, y - i}
        num = num + 6
      end
    end
  elseif kind == 8 then
    xy[1] = {x, y}
    num = 1
    for i = 1, len1 do
      xy[num + 1] = {x + i, y}
      xy[num + 2] = {x - i, y}
      xy[num + 3] = {x, y + i}
      xy[num + 4] = {x, y - i}
      xy[num + 5] = {x + i, y + len1}
      xy[num + 6] = {x - i, y - len1}
      xy[num + 7] = {x + len1, y - i}
      xy[num + 8] = {x - len1, y + i}
      num = num + 8
    end
  elseif kind == 9 then
    xy[1] = {x, y}
    num = 1
    for i = 1, len1 do
      xy[num + 1] = {x + i, y}
      xy[num + 2] = {x - i, y}
      xy[num + 3] = {x, y + i}
      xy[num + 4] = {x, y - i}
      xy[num + 5] = {x - i, y + len1}
      xy[num + 6] = {x + i, y - len1}
      xy[num + 7] = {x + len1, y + i}
      xy[num + 8] = {x - len1, y - i}
      num = num + 8
    end
  elseif x == x0 and y == y0 then
    return 0
  elseif kind == 10 then
    if not len2 then
      len2 = 0
    end
    if not len3 then
      len3 = 0
    end
    if not len4 then
      len4 = 0
    end
    local fx, fy = x - x0, y - y0
    if fx > 0 then
      fx = 1
    elseif fx < 0 then
      fx = -1
    end
    if fy > 0 then
      fy = 1
    elseif fy < 0 then
      fy = -1
    end
    local dx1, dy1, dx2, dy2 = -fy, fx, fy, -fx
    dx1 = -(dx1 + fx) / 2
    dx2 = -(dx2 + fx) / 2
    dy1 = -(dy1 + fy) / 2
    dy2 = -(dy2 + fy) / 2
    if dx1 > 0 then
      dx1 = 1
    elseif dx1 < 0 then
      dx1 = -1
    end
    if dx2 > 0 then
      dx2 = 1
    elseif dx2 < 0 then
      dx2 = -1
    end
    if dy1 > 0 then
      dy1 = 1
    elseif dy1 < 0 then
      dy1 = -1
    end
    if dy2 > 0 then
      dy2 = 1
    elseif dy2 < 0 then
      dy2 = -1
    end
    for i = 0, len1 - 1 do
      num = num + 1
      xy[num] = {x + i * fx, y + i * fy}
    end
    for i = 0, len2 - 1 do
      num = num + 1
      xy[num] = {x + dx1 + i * fx, y + dy1 + i * fy}
      num = num + 1
      xy[num] = {x + dx2 + i * fx, y + dy2 + i * fy}
    end
    for i = 0, len3 - 1 do
      num = num + 1
      xy[num] = {x + 2 * dx1 + i * fx, y + 2 * dy1 + i * fy}
      num = num + 1
      xy[num] = {x + 2 * dx2 + i * fx, y + 2 * dy2 + i * fy}
    end
    for i = 0, len4 - 1 do
      num = num + 1
      xy[num] = {x + 3 * dx1 + i * fx, y + 3 * dy1 + i * fy}
      num = num + 1
      xy[num] = {x + 3 * dx2 + i * fx, y + 3 * dy2 + i * fy}
    end
  elseif kind == 11 then
    local fx, fy = x - x0, y - y0
    if fx > 1 then
      fx = 1
    elseif fx < -1 then
      fx = -1
    end
    if fy > 1 then
      fy = 1
    elseif fy < -1 then
      fy = -1
    end
    local dx1, dy1, dx2, dy2 = -fy, fx, fy, -fx
    if fx ~= 0 and fy ~= 0 then
      dx1 = -(dx1 + fx) / 2
      dx2 = -(dx2 + fx) / 2
      dy1 = -(dy1 + fy) / 2
      dy2 = -(dy2 + fy) / 2
      len1 = math.modf(len1 * 0.7071)
      for i = 0, len1 do
        num = num + 1
        xy[num] = {x + i * fx, y + i * fy}
        for j = 1, 2 * i + 1 do
          num = num + 1
          xy[num] = {x + i * fx + j * (dx1), y + i * fy + j * (dy1)}
          num = num + 1
          xy[num] = {x + i * fx + j * (dx2), y + i * fy + j * (dy2)}
        end
      end
    else
      for i = 0, len1 do
        num = num + 1
        xy[num] = {x + i * fx, y + i * fy}
        for j = 1, len1 - i do
          num = num + 1
          xy[num] = {x + i * fx + j * (dx1), y + i * fy + j * (dy1)}
          num = num + 1
          xy[num] = {x + i * fx + j * (dx2), y + i * fy + j * (dy2)}
        end
      end
    end
  elseif kind == 12 then
    local fx, fy = x - x0, y - y0
    if fx > 1 then
      fx = 1
    elseif fx < -1 then
      fx = -1
    end
    if fy > 1 then
      fy = 1
    elseif fy < -1 then
      fy = -1
    end
    local dx1, dy1, dx2, dy2 = -fy, fx, fy, -fx
    if fx ~= 0 and fy ~= 0 then
      dx1 = (dx1 + fx) / 2
      dx2 = (dx2 + fx) / 2
      dy1 = (dy1 + fy) / 2
      dy2 = (dy2 + fy) / 2
      len1 = math.modf(len1 * 1.41421)
      for i = 0, len1 do
        if i <= len1 / 2 then
          num = num + 1
          xy[num] = {x + i * fx, y + i * fy}
        end
        for j = 1, len1 - i * 2 do
          num = num + 1
          xy[num] = {x + i * fx + j * (dx1), y + i * fy + j * (dy1)}
          num = num + 1
          xy[num] = {x + i * fx + j * (dx2), y + i * fy + j * (dy2)}
        end
      end
    else
      for i = 0, len1 do
        num = num + 1
        xy[num] = {x + i * fx, y + i * fy}
        for j = 1, i do
          num = num + 1
          xy[num] = {x + i * fx + j * (dx1), y + i * fy + j * (dy1)}
          num = num + 1
          xy[num] = {x + i * fx + j * (dx2), y + i * fy + j * (dy2)}
        end
      end
    end
  elseif kind == 13 then
    local fx, fy = x - x0, y - y0
    if fx > 1 then
      fx = 1
    elseif fx < -1 then
      fx = -1
    end
    if fy > 1 then
      fy = 1
    elseif fy < -1 then
      fy = -1
    end
    local xx = x + fx * len1
    local yy = y + fy * len1
    for tx = xx - len1, xx + len1 do
      for ty = yy - len1, yy + len1 do
        if len1 < math.abs(tx - xx) + math.abs(ty - yy) then
          break;
        end
        num = num + 1
        xy[num] = {tx, ty}
      end
    end
  else
    return 0
  end
  
  if flag == 1 then
    local thexy = function(nx, ny, x, y)
	    local dx, dy = nx - x, ny - y
	    local hb = lib.GetS(JY.SubScene, nx, ny, 4)
	    return CC.ScreenW / 2 + CC.XScale * (dx - dy), CC.ScreenH / 2 + CC.YScale * (dx + dy) - hb
    end
    
    
    for i = 1, num do
    	if xy[i][1] >= 0 and xy[i][1] < CC.WarWidth and xy[i][2] >= 0 and xy[i][2] < CC.WarHeight then
      	local tx, ty = thexy(xy[i][1], xy[i][2], x0, y0)
      
	      --蓝烟清：显示命中的人的点为黑色
	      if GetWarMap(xy[i][1], xy[i][2], 2) ~= nil and GetWarMap(xy[i][1], xy[i][2], 2) >= 0 and GetWarMap(xy[i][1], xy[i][2], 2) ~= WAR.CurID then
					if not inteam(WAR.Person[GetWarMap(xy[i][1], xy[i][2], 2)]["人物编号"]) and WAR.Person[WAR.CurID]["我方"] then
		      	local x0 = WAR.Person[WAR.CurID]["坐标X"];
		      	local y0 = WAR.Person[WAR.CurID]["坐标Y"];
		      	local dx = xy[i][1] - x0
		        local dy = xy[i][2] - y0
		        local size = CC.FontSmall;
		        local rx = CC.XScale * (dx - dy) + CC.ScreenW / 2
		        local ry = CC.YScale * (dx + dy) + CC.ScreenH / 2
		        
		        local hb = GetS(JY.SubScene, dx + x0, dy + y0, 4)

		        ry = ry - hb - CC.ScreenH/6;
		        
		        if ry < 1 then			--加上这个，防止看不到血的情况
		        	ry = 1;
		        end
		      	
		      	--显示选中人物的生命值
		      	local color = RGB(245, 251, 5);
		      	local hp = JY.Person[WAR.Person[GetWarMap(xy[i][1], xy[i][2], 2)]["人物编号"]]["生命"];
		      	local maxhp = JY.Person[WAR.Person[GetWarMap(xy[i][1], xy[i][2], 2)]["人物编号"]]["生命最大值"];
		      	
		      	local ns = JY.Person[WAR.Person[GetWarMap(xy[i][1], xy[i][2], 2)]["人物编号"]]["受伤程度"];
		      	local zd = JY.Person[WAR.Person[GetWarMap(xy[i][1], xy[i][2], 2)]["人物编号"]]["中毒程度"];
		      	local len = #(string.format("%d/%d",hp,maxhp));
		      	rx = rx - len*size/4;
		      	
		      	--颜色根据所受的内伤确定
		      	if ns < 33 then
				      color = RGB(236, 200, 40)
				    elseif ns < 66 then
				      color = RGB(244, 128, 32)
				    else
				      color = RGB(232, 32, 44)
				    end
		      	
		      	DrawString(rx, ry, string.format("%d",hp), color, size);
		      	DrawString(rx + #string.format("%d",hp)*size/2, ry, "/", C_GOLD, size);
		      	
		      	if zd == 0 then
				      color = RGB(252, 148, 16)
				    elseif zd < 50 then
				      color = RGB(120, 208, 88)
				    else
				      color = RGB(56, 136, 36)
				    end
				    DrawString(rx + #string.format("%d",hp)*size/2 + size/2 , ry, string.format("%d", maxhp), color, size)
		      end
		      
	      	lib.PicLoadCache(0, 0, tx, ty, 2, 200)
	      	
	      else
	      	lib.PicLoadCache(0, 0, tx, ty, 2, 112)
	      end
	      
	    end
    end

  elseif flag == 2 then
    local diwo = WAR.Person[WAR.CurID]["我方"]
    local atknum = 0
    for i = 1, num do
      if xy[i][1] >= 0 and xy[i][1] < CC.WarWidth and xy[i][2] >= 0 and xy[i][2] < CC.WarHeight then
        local id = GetWarMap(xy[i][1], xy[i][2], 2)
      
	      if id ~= -1 and id ~= WAR.CurID then
	        local xa, xb, xc = nil, nil, nil
	        if diwo ~= WAR.Person[id]["我方"] then
	          xa = 2
	        else
	          if GetS(0, 0, 0, 0) == 1 then
	            xa = -0.5
		        else
		          xa = 0
		        end
	        end
	        local hp = JY.Person[WAR.Person[id]["人物编号"]]["生命"]
	        if hp < atk / 6 then
	          xb = 2
	        elseif hp < atk / 3 then
	          xb = 1
	        else
	          xb = 0
	        end
	        local danger = JY.Person[WAR.Person[id]["人物编号"]]["内力最大值"]
	        xc = danger / 500
	        atknum = atknum + xa * math.modf(xb * (xc) + 5)
	      end
      end
    end
    return atknum
  elseif flag == 3 then
    for i = 1, num do
    	if xy[i][1] >= 0 and xy[i][1] < CC.WarWidth and xy[i][2] >= 0 and xy[i][2] < CC.WarHeight then
      	SetWarMap(xy[i][1], xy[i][2], 4, 1)
      end
    end
  end
end

PNLBD = {}
PNLBD[0] = function()
  JY.Person[1]["生命"] = 750
  JY.Person[1]["生命最大值"] = 750
  JY.Person[1]["内力"] = 2500
  JY.Person[1]["内力最大值"] = 2500
  JY.Person[1]["攻击力"] = 130
  JY.Person[1]["防御力"] = 130
  JY.Person[1]["轻功"] = 180
  JY.Person[1]["受伤程度"] = 0
  JY.Person[1]["中毒程度"] = 0
  JY.Person[1]["武功1"] = 67
  JY.Person[1]["武功等级1"] = 999
end

PNLBD[16] = function()
  JY.Person[37]["生命"] = 850
  JY.Person[37]["生命最大值"] = 850
  JY.Person[37]["内力"] = 5000
  JY.Person[37]["内力最大值"] = 5000
  JY.Person[37]["攻击力"] = 120
  JY.Person[37]["防御力"] = 170
  JY.Person[37]["轻功"] = 120
  JY.Person[37]["受伤程度"] = 0
  JY.Person[37]["中毒程度"] = 0
  JY.Person[37]["武功等级1"] = 999
  JY.Person[37]["武功等级2"] = 999
  JY.Person[37]["武功2"] = 63
end

PNLBD[34] = function()
  JY.Person[36]["生命"] = 650
  JY.Person[36]["生命最大值"] = 650
  JY.Person[36]["内力"] = 3000
  JY.Person[36]["内力最大值"] = 3000
  JY.Person[36]["攻击力"] = 180
  JY.Person[36]["防御力"] = 130
  JY.Person[36]["轻功"] = 220
  JY.Person[36]["受伤程度"] = 0
  JY.Person[36]["中毒程度"] = 0
  JY.Person[36]["武功等级1"] = 999
end

PNLBD[75] = function()
  JY.Person[58]["生命"] = 850
  JY.Person[58]["生命最大值"] = 850
  JY.Person[58]["内力"] = 5500
  JY.Person[58]["内力最大值"] = 5500
  JY.Person[58]["攻击力"] = 230
  JY.Person[58]["防御力"] = 200
  JY.Person[58]["轻功"] = 180
  JY.Person[58]["受伤程度"] = 0
  JY.Person[58]["中毒程度"] = 0
  JY.Person[58]["武功等级1"] = 999
  JY.Person[58]["武功等级2"] = 999
  JY.Person[58]["武功等级3"] = 999
  JY.Person[59]["生命"] = 750
  JY.Person[59]["生命最大值"] = 750
  JY.Person[59]["内力"] = 3500
  JY.Person[59]["内力最大值"] = 3500
  JY.Person[59]["攻击力"] = 190
  JY.Person[59]["防御力"] = 170
  JY.Person[59]["轻功"] = 220
  JY.Person[59]["受伤程度"] = 0
  JY.Person[59]["中毒程度"] = 0
  JY.Person[59]["武功等级1"] = 999
  JY.Person[59]["武功2"] = 107
  JY.Person[59]["武功等级2"] = 999
end

PNLBD[138] = function()
  JY.Person[75]["生命"] = 650
  JY.Person[75]["生命最大值"] = 650
  JY.Person[75]["内力"] = 3000
  JY.Person[75]["内力最大值"] = 3000
  JY.Person[75]["攻击力"] = 140
  JY.Person[75]["防御力"] = 120
  JY.Person[75]["轻功"] = 130
  JY.Person[75]["受伤程度"] = 0
  JY.Person[75]["中毒程度"] = 0
  JY.Person[75]["武功等级1"] = 999
end

PNLBD[165] = function()
  JY.Person[54]["生命"] = 750
  JY.Person[54]["生命最大值"] = 750
  JY.Person[54]["内力"] = 3500
  JY.Person[54]["内力最大值"] = 3500
  JY.Person[54]["攻击力"] = 180
  JY.Person[54]["防御力"] = 180
  JY.Person[54]["轻功"] = 180
  JY.Person[54]["受伤程度"] = 0
  JY.Person[54]["中毒程度"] = 0
  JY.Person[54]["武功等级1"] = 999
  JY.Person[54]["武功等级2"] = 999
end

PNLBD[170] = function()
  JY.Person[38]["生命"] = 950
  JY.Person[38]["生命最大值"] = 950
  JY.Person[38]["内力"] = 5000
  JY.Person[38]["内力最大值"] = 5000
  JY.Person[38]["攻击力"] = 200
  JY.Person[38]["防御力"] = 200
  JY.Person[38]["轻功"] = 160
  JY.Person[38]["受伤程度"] = 0
  JY.Person[38]["中毒程度"] = 0
  JY.Person[38]["武功等级1"] = 999
  JY.Person[38]["武功等级2"] = 999
end

PNLBD[197] = function()
  JY.Person[48]["生命"] = 850
  JY.Person[48]["生命最大值"] = 850
  JY.Person[48]["内力"] = 3000
  JY.Person[48]["内力最大值"] = 3000
  JY.Person[48]["攻击力"] = 150
  JY.Person[48]["防御力"] = 130
  JY.Person[48]["轻功"] = 100
  JY.Person[48]["受伤程度"] = 0
  JY.Person[48]["中毒程度"] = 0
  JY.Person[48]["武功等级1"] = 999
  JY.Person[48]["武功等级2"] = 999
  JY.Person[48]["武功2"] = 108
end

PNLBD[198] = function()
  JY.Person[51]["生命"] = 750
  JY.Person[51]["生命最大值"] = 750
  JY.Person[51]["内力"] = 3000
  JY.Person[51]["内力最大值"] = 3000
  JY.Person[51]["攻击力"] = 180
  JY.Person[51]["防御力"] = 160
  JY.Person[51]["轻功"] = 120
  JY.Person[51]["受伤程度"] = 0
  JY.Person[51]["中毒程度"] = 0
  JY.Person[51]["武功等级1"] = 999
end

--宗师,随机在一个人的周围建立凶地，吉地
function WarNewLand()

  --1吉，2凶，3大吉，4大凶
  if GetS(53, 0, 2, 5) == 3 then
    while true do
    	local p = math.random(WAR.PersonNum)-1;
    	if WAR.Person[p]["死亡"] == false then 
    		if GetWarMap(0,0,6) == -2  then
	    		local x = WAR.Person[p]["坐标X"]
	    		local y = WAR.Person[p]["坐标Y"]
	    		
	    		CleanWarMap(6,-1);
	    		
	    		--所在位置一定是
	    		SetWarMap(x, y, 6, math.random(4));
	    		
	    		local n = 5;
	    		--十本书觉醒后，增加更多的点
	    		if GetS(53, 0, 4, 5) == 1 then
	    			n = n + 3;
	    		end
	    		
	    		for j=1, n do
	    			SetWarMap(x + math.random(6), y + math.random(6), 6, math.random(4));
	    			SetWarMap(x + math.random(6), y - math.random(6), 6, math.random(4));
	    			SetWarMap(x - math.random(6), y - math.random(6), 6, math.random(4));
	    			SetWarMap(x - math.random(6), y + math.random(6), 6, math.random(4));
	    		end
	    	end
	    	break;
    	end
    end
  end
end

--战斗主函数
function WarMain(warid, isexp)
  WarLoad(warid)			--初始化战斗数据
  WarSelectTeam()			--选择我方
  WarSelectEnemy()		--选择敌人
  
  --蓝烟清：战斗时如果队友为敌方，增强实力
  for i = 0, WAR.PersonNum - 1 do	
  	local p = WAR.Person[i]["人物编号"];
  	if isteam(p) and WAR.Person[i]["我方"] == false then
  		WAR.tmp[4000 + i] = {p};
  		
  		--难度生命
  		if JY.Person[p]["生命最大值"] <= JY.Thing[202][WZ7] * 80 then
  			WAR.tmp[4000+i][2] = JY.Thing[202][WZ7] * 200 + 100 - JY.Person[p]["生命最大值"];
	    	JY.Person[p]["生命最大值"] = JY.Thing[202][WZ7] * 200 + 100
	    else
	    	WAR.tmp[4000+i][2] = JY.Thing[202][WZ7] * JY.Person[p]["生命最大值"] + 100 - JY.Person[p]["生命最大值"]
	    	JY.Person[p]["生命最大值"] = JY.Thing[202][WZ7] * JY.Person[p]["生命最大值"] + 100
	    end
	    
	    JY.Person[p]["生命"] = JY.Person[p]["生命最大值"]
      
      --难度内力
      if JY.Person[p]["内力最大值"] <= JY.Thing[202][WZ7] * 200 + 100 then
      	WAR.tmp[4000+i][3] = JY.Thing[202][WZ7] * 300 + 100 - JY.Person[p]["内力最大值"];
      	JY.Person[p]["内力最大值"] = JY.Thing[202][WZ7] * 300 + 100
      	
      elseif JY.Person[p]["内力最大值"] < CC.PersonAttribMax["内力最大值"] * 2 then
      	WAR.tmp[4000+i][3] = 600 * JY.Thing[202][WZ7];
      	JY.Person[p]["内力最大值"] = JY.Person[p]["内力最大值"] + WAR.tmp[4000+i][3]
    	end
    	
    	JY.Person[p]["内力"] = JY.Person[p]["内力最大值"]
    	
    	--攻击力
    	WAR.tmp[4000+i][4] = JY.Thing[202][WZ7]*50;
    	JY.Person[p]["攻击力"] = JY.Person[p]["攻击力"] + WAR.tmp[4000+i][4]
    	
    	--防御力
    	WAR.tmp[4000+i][5] = JY.Thing[202][WZ7]*50;
    	JY.Person[p]["防御力"] = JY.Person[p]["防御力"] + WAR.tmp[4000+i][5]
    	
    	--轻功
    	WAR.tmp[4000+i][6] = JY.Thing[202][WZ7]*40;
    	JY.Person[p]["轻功"] = JY.Person[p]["轻功"] + WAR.tmp[4000+i][6]
  	end
  end
  
  
  
  CleanMemory()
  lib.PicInit()
  lib.ShowSlow(30, 1)
  WarLoadMap(WAR.Data["地图"])	--加载战斗地图

for i = 0, CC.WarWidth-1 do
    for j = 0, CC.WarHeight-1 do
      lib.SetWarMap(i, j, 0, lib.GetS(JY.SubScene, i, j, 0))
      lib.SetWarMap(i, j, 1, lib.GetS(JY.SubScene, i, j, 1))
    end
  end
  
  --雪山落花流水战役
  if WAR.ZDDH == 42 then
    SetS(2, 24, 31, 1, 0)
    SetS(2, 30, 34, 1, 0)
    SetS(2, 27, 27, 1, 0)
  end
  
  --新华山论剑
  if WAR.ZDDH == 238 then
    for x = 24, 34 do
      for y = 24, 34 do
        lib.SetWarMap(x, y, 0, 1030)
      end
    end
    for y = 23, 35 do
      lib.SetWarMap(23, y, 1, 1174)
      lib.SetWarMap(35, y, 1, 1174)
    end
    for x = 24, 35 do
      lib.SetWarMap(x, 35, 1, 1174)
      lib.SetWarMap(x, 23, 1, 1174)
    end
    lib.SetWarMap(23, 23, 0, 1174)
    lib.SetWarMap(35, 35, 0, 1174)
    lib.SetWarMap(23, 35, 0, 1174)
    lib.SetWarMap(35, 23, 0, 1174)
    lib.SetWarMap(23, 23, 1, 2960)
    lib.SetWarMap(35, 35, 1, 2960)
    lib.SetWarMap(23, 35, 1, 2960)
    lib.SetWarMap(35, 23, 1, 2960)
  end
  
  --杀东方不败
  if WAR.ZDDH == 54 then
    lib.SetWarMap(11, 36, 1, 2)
  end
  
  --改变游戏状态
  JY.Status = GAME_WMAP
  
  --加载贴图文件

  lib.PicLoadFile(CC.WMAPPicFile[1], CC.WMAPPicFile[2], 0)
  --lib.PicLoadFile(CC.HeadPicFile[1], CC.HeadPicFile[2], 1,limitX(CC.ScreenW/6,50,110))
  --lib.PicLoadFile(CC.HeadPicFile[1], CC.HeadPicFile[2], 99, limitX(CC.ScreenW/25,12,35))

	lib.LoadPNGPath(CC.HeadPath, 1, CC.HeadNum, limitX(CC.ScreenW/800*100,0,100))
	
	lib.LoadPNGPath(CC.MHeadPath, 99, CC.HeadNum, limitX(CC.ScreenW/800*100,0,100))

  lib.PicLoadFile(CC.ThingPicFile[1], CC.ThingPicFile[2], 2)
  --lib.PicLoadFile(CC.EffectFile[1], CC.EffectFile[2], 3)

	local zdyy=0
	if math.random(2) == 1 then
	zdyy=math.random(3)+4
	else
	zdyy=math.random(4)+24
	end
	PlayMIDI(zdyy)
  --PlayMIDI(WAR.Data["音乐"])
  
  
  local first = 0          --第一次显示战斗标记
  local warStatus = nil		 --战斗状态
  
  --人物重新赋值
  --for i = 0, WAR.PersonNum - 1 do
  --  for s = 1, 80 do
  --    JY.Person[WAR.Person[i]["人物编号"]][PSX[s]] = JY.Person[WAR.Person[i]["人物编号"]][PSX[s]]
  --  end
  --end
  
  WarPersonSort()			--按轻功排序
  CleanWarMap(2, -1)
  CleanWarMap(6, -2)
  
  --Alungky: 木桩的位置挪到缓冲区赋值前面
  JY.Person[445]["姓名"] = "官兵"
  JY.Person[446]["姓名"] = "官兵"
  if WAR.ZDDH == 226 then
    JY.Person[445]["姓名"] = "为国为民"
    JY.Person[446]["姓名"] =  "侠之大者"
  end

  for i = 0, WAR.PersonNum - 1 do
  	
    if i == 0 then
      WAR.Person[i]["坐标X"], WAR.Person[i]["坐标Y"] = WE_xy(WAR.Person[i]["坐标X"], WAR.Person[i]["坐标Y"])
    else
      WAR.Person[i]["坐标X"], WAR.Person[i]["坐标Y"] = WE_xy(WAR.Person[i]["坐标X"], WAR.Person[i]["坐标Y"], i)
    end
    
    SetWarMap(WAR.Person[i]["坐标X"], WAR.Person[i]["坐标Y"], 2, i)
    
    local pid = WAR.Person[i]["人物编号"]
    lib.PicLoadFile(string.format(CC.FightPicFile[1], JY.Person[pid]["头像代号"]), string.format(CC.FightPicFile[2], JY.Person[pid]["头像代号"]), 4 + i)
    
    --Alungky 用500数组来保存头像数据
    --Alungky 用500数组来保存名字数据
    --主角的数据要特殊处理
    if pid == 0 then
    	WAR.tmp[5000+i] = 280 + GetS(4, 5, 5, 5)
      WAR.tmp[5500+i] = JY.Person[0]["姓名"]
    else
    	WAR.tmp[5000+i] = JY.Person[pid]["头像代号"]
      WAR.tmp[5500+i] = JY.Person[pid]["姓名"]
    end
  end
  local function getnewmove(x)
    if x > 150 then
      return 7 + (x - 150) / 80
    elseif x > 70 then
      return 5 + (x - 70) / 40
    elseif x > 30 then
      return 3 + (x - 30) / 20
    else
      return x / 10
    end
  end
  local function getnewmove1(a, b)
    local x = (a * 2 + b) / 3
    if x > 4000 then
      return 8 + (x - 4000) / 1000
    elseif x > 2400 then
      return 6 + (x - 2400) / 800
    elseif x > 1200 then
      return 4 + (x - 1200) / 600
    elseif x > 400 then
      return 2 + (x - 400) / 400
    else
      return x / 200
    end
  end
  local function getdelay(x, y)
    return math.modf(1.5 * (x / y + y - 3))
  end
  for i = 0, WAR.PersonNum - 1 do
    WAR.Person[i]["贴图"] = WarCalPersonPic(i)
  end
  WarSetPerson()
  WAR.CurID = 0
  WarDrawMap(0)
  lib.ShowSlow(30, 0)
  for i = 0, WAR.PersonNum - 1 do
    WAR.Person[i].Time = 800 - i * 1000 / WAR.PersonNum
    
    --令狐冲，初始满集气
    if WAR.Person[i]["人物编号"] == 35 then
      WAR.Person[i].Time = 998
    end
    
    --岳灵珊 每个剑法到极+50点初始集气
    if WAR.Person[i]["人物编号"] == 79 then
      local JF = 0
      for i = 1, 10 do
        if JY.Person[79]["武功" .. i] < 50 and JY.Person[79]["武功" .. i] > 26 and JY.Person[79]["武功等级" .. i] == 999 then
          JF = JF + 1
        end
      end
      WAR.Person[i].Time = WAR.Person[i].Time + (JF) * 50
    end
    
    if WAR.Person[i].Time > 990 then
      WAR.Person[i].Time = 990
    end
    
	--独孤求败，初始满集气
    if WAR.Person[i]["人物编号"] == 592 then
      WAR.Person[i].Time = 999
    end
	
    --血刀老祖 初始集气900
    if WAR.Person[i]["人物编号"] == 97 then
      WAR.Person[i].Time = 900
    end
    
    --太监初始集气-200
    if JY.Person[WAR.Person[i]["人物编号"]]["性别"] == 2 then
		if WAR.Person[i]["人物编号"] == 0 and GetS(86,15,15,5) == 1 then
		else
		WAR.Person[i].Time = -200
		end
    end
    
    --林平之 初始集气700
    if WAR.Person[i]["人物编号"] == 36 then
      WAR.Person[i].Time = 700
    end
    
    --李芷沅山洞，两个木桩
    if WAR.Person[i]["人物编号"] == 445 and WAR.ZDDH == 226 then
      WAR.Person[i].Time = 999
    end
    if WAR.Person[i]["人物编号"] == 446 and WAR.ZDDH == 226 then
      WAR.Person[i].Time = 900
    end
    
    --圣火神功 初始集气加200和100随机
    local id = WAR.Person[i]["人物编号"]
    if PersonKF(id, 93) then
      WAR.Person[i].Time = WAR.Person[i].Time + 200 + math.random(100)
    end
    if WAR.Person[i].Time > 990 then
      WAR.Person[i].Time = 990
    end
    
    
    WAR.Person[i]["移动步数"] = math.modf(getnewmove(WAR.Person[i]["轻功"]) - JY.Person[id]["中毒程度"] / 30 - JY.Person[id]["受伤程度"] / 30 + JY.Person[id]["体力"] / 30 - 3)
    if WAR.Person[i]["移动步数"] < 1 then
      WAR.Person[i]["移动步数"] = 1
    end
  end
  
  --东方不败，无左右
  JY.Person[27]["左右互搏"] = 0
  
  --战场上显示物品
  for a = 0, WAR.PersonNum - 1 do
    for s = 1, 4 do
      if JY.Person[WAR.Person[a]["人物编号"]]["携带物品数量" .. s] == nil or JY.Person[WAR.Person[a]["人物编号"]]["携带物品数量" .. s] < 1 then
        JY.Person[WAR.Person[a]["人物编号"]]["携带物品" .. s] = -1
        JY.Person[WAR.Person[a]["人物编号"]]["携带物品数量" .. s] = 0;
      end
    end
  end
  
  if WAR.ZDDH == 14 then
    say("Ｇ１妙风使！", 173, 0)   --妙风使
    say("Ｇ１流云使！", 174, 1)   --流云使
    say("Ｇ１辉月使！Ｈ圣火三绝阵！", 175, 5)   --辉月使！Ｈ圣火三绝阵！
    for i = 1, 10 do
      NewDrawString(-1, -1, "圣火三绝阵", C_GOLD, CC.DefaultFont+i*2)
      ShowScreen()
      if i == 10 then
        lib.Delay(300)
      else
        lib.Delay(1)
      end
    end
  end
  
  --密道成昆战，我方集气全体为0...
  if WAR.ZDDH == 237 then
    for a = 0, WAR.PersonNum - 1 do
      if WAR.Person[a]["我方"] == true then
        WAR.Person[a].Time = 0
      end
    end
  end
  
  --新华山论剑
  if WAR.ZDDH == 238 then
    for i = 1, 10 do
      NewDrawString(-1, -1, "华山论剑", C_GOLD, CC.DefaultFont+i*2)
      ShowScreen()
      if i == 10 then
        lib.Delay(300)
      else
        lib.Delay(1)
      end
    end
  end
  
  --全真七子，天罡北斗阵
  if WAR.ZDDH == 73 then
    for i = 1, 10 do
      NewDrawString(-1, -1, "天罡北斗阵", C_GOLD, CC.DefaultFont+i*2)
      ShowScreen()
      if i == 10 then
        lib.Delay(300)
      else
        lib.Delay(1)
      end
    end
  end
  
  --蓝烟清：新逆运走火，伤害、暴击率、连击率上升，七分失控
  for i = 0, WAR.PersonNum - 1 do
  	--敌人不会，已方才会走火失控
  	if inteam(WAR.Person[i]["人物编号"]) and PersonKF(WAR.Person[i]["人物编号"], 104) and PersonKF(WAR.Person[i]["人物编号"], 107) == false then
  		WAR.L_NYZH[WAR.Person[i]["人物编号"]] = 1;
  	end
  end
  
  if WAR.ZDDH == 83 then     --四帮主之战，乔峰用铁掌
      JY.Person[50]["武功1"] = 13
    end
  	
  warStatus = 0
  buzhen()
  WAR.Delay = GetJiqi()
  local startt, endt = lib.GetTime()
  
  --初始化地形
  WarNewLand()
  
  while true do
    WarDrawMap(0)
    WAR.ShowHead = 0
    DrawTimeBar()
    
    lib.GetKey()
    ShowScreen()
    if WAR.ZYHB == 1 then
      WAR.ZYHB = 2
    end
    
    
    local reget = false 
    
    
    
    for p = 0, WAR.PersonNum - 1 do

      if WAR.Person[p]["死亡"] == false and WAR.Person[p].Time > 1000 then
      	
      	
        WarDrawMap(0)
        ShowScreen()
        local keypress = lib.GetKey()
        if WAR.AutoFight == 1 and (keypress == VK_SPACE or keypress == VK_RETURN) then
          WAR.AutoFight = 0
        end
        reget = true
        local id = WAR.Person[p]["人物编号"]
        
        --宗师，在获得行动后，加集气效果取消
        if id == JY.MY then
        	WAR.tmp[8003] = nil;
        end
        
        --左右触发之后，不可移动
        if WAR.ZYHB == 2 then
          WAR.Person[p]["移动步数"] = 0
        elseif WAR.L_NOT_MOVE[WAR.Person[p]["人物编号"]] ~= nil and WAR.L_NOT_MOVE[WAR.Person[p]["人物编号"]] == 1 then
        	WAR.Person[p]["移动步数"] = 0
        	WAR.L_NOT_MOVE[WAR.Person[p]["人物编号"]] = nil
        else
        
        	--计算移动步数
          WAR.Person[p]["移动步数"] = math.modf(getnewmove(WAR.Person[p]["轻功"]) - JY.Person[id]["中毒程度"] / 50 - JY.Person[id]["受伤程度"] / 60 + JY.Person[id]["体力"] / 70 - 1)
          
          --蓝烟清：难度提升敌方的移动步数
          if WAR.Person[p]["我方"] == false then
	          if JY.Thing[202][WZ7] > 1 then			--难度2额外加1
	          	WAR.Person[p]["移动步数"] = WAR.Person[p]["移动步数"] + 1
	          end
	          if JY.Thing[202][WZ7] > 2 then		--难度3再额外加1，相当于2点
	          	WAR.Person[p]["移动步数"] = WAR.Person[p]["移动步数"] + 1
	          end
	        end
          
          
          for j = 0, WAR.PersonNum - 1 do
          
          	--小昭，敌人移步数少三格
            if WAR.Person[j]["人物编号"] == 66 and WAR.Person[j]["死亡"] == false and WAR.Person[j]["我方"] ~= WAR.Person[p]["我方"] then
              WAR.Person[p]["移动步数"] = WAR.Person[p]["移动步数"] - 3
            end
          end
          if WAR.Person[p]["移动步数"] < 1 then
            WAR.Person[p]["移动步数"] = 1
          end
          if id == 35 or id == 6 or id == 97 then
            WAR.Person[p]["移动步数"] = WAR.Person[p]["移动步数"] + 3
          end
          if id == 5 and WAR.Person[p]["移动步数"] < 8 then
            WAR.Person[p]["移动步数"] = 8
          end
        end
        
        --最大移动步数10
        if WAR.Person[p]["移动步数"] > 10 then
          WAR.Person[p]["移动步数"] = 10
        end
        
        
        WAR.ShowHead = 0
        WarDrawMap(0)
        WAR.Effect = 0
        WAR.CurID = p
        WAR.Person[p].TimeAdd = 0
        local r = nil
        local pid = WAR.Person[WAR.CurID]["人物编号"]
        WAR.Defup[pid] = nil
        if pid == 53 then
          WAR.TZ_DY = 0
        end
        
        --蓝烟清：田伯光行动后回复状态
        if pid == 29 then
        	WAR.L_TBGZL = 0;
        end
        
        --if instruct_16(pid) and WAR.Person[p]["我方"] and WAR.tmp[1000 + pid] ~= 1 then
        --蓝烟清：新逆运，七分疯狂三分清醒
        if inteam(pid) and WAR.Person[p]["我方"] then
        
        	if WAR.L_NYZH[pid] ~= nil and math.random(10) < 8 then		--新逆运
        		r = War_Auto()
          elseif WAR.AutoFight == 0 then
            r = War_Manual()
          else
            r = War_Auto()
          end
        else
          r = War_Auto()
        end
        
        
        
        --如果发动左右互搏
        if WAR.ZYHB == 1 then
          for j = 0, WAR.PersonNum - 1 do
            WAR.Person[j].Time = WAR.Person[j].Time - 15
            if WAR.Person[j].Time > 990 then
              WAR.Person[j].Time = 990
            end
          end
          WAR.Person[p].Time = 1005
          WAR.ZYYD = WAR.Person[p]["移动步数"]
          WAR.ZYHBP = p
          if WAR.XDXX > 0 then
            DrawStrBox(-1, -1, "血刀攻击吸取生命" .. WAR.XDXX, C_ORANGE, CC.DefaultFont)
            ShowScreen()
            lib.Delay(500)
            Cls()
            ShowScreen()
            WAR.XDXX = 0
          end
          WAR.QKNY = 0
          if JY.Person[129]["生命"] <= 0 and WAR.WCY < 1 then
            JY.Person[129]["生命"] = 1
          end
          if JY.Person[65]["生命"] <= 0 and WAR.WCY < 1 then
            JY.Person[65]["生命"] = 1
          end
          if WAR.ZDDH == 128 then
            for i = 0, WAR.PersonNum - 1 do
              if WAR.Person[i]["人物编号"] == 553 and JY.Person[553]["生命"] <= 0 then
                WAR.YZB = 1
                WAR.FXDS[553] = nil
                WAR.LXZT[553] = nil
              end
            end
	          if WAR.YZB == 1 then
              if WAR.YZB2 < 3 then
                WAR.YZB = 0
                WAR.YZB2 = WAR.YZB2 + 1
                say("１Ｒ负けいくざ　だが　オレうちなるとうしが　それをこばむ　これはぶもんのいちか　真田幸村　いざ　まいる", 553)
                JY.Person[553]["生命最大值"] = JY.Person[553]["生命最大值"] + 100
                JY.Person[553]["内力最大值"] = JY.Person[553]["内力最大值"] + 1000
                JY.Person[553]["生命"] = JY.Person[553]["生命最大值"]
                JY.Person[553]["内力"] = JY.Person[553]["内力最大值"]
                JY.Person[553]["中毒程度"] = 0
                JY.Person[553]["受伤程度"] = 0
                JY.Person[553]["体力"] = 100
                JY.Person[553]["攻击力"] = JY.Person[553]["攻击力"] + 100
                JY.Person[553]["防御力"] = JY.Person[553]["防御力"] + 100
                JY.Person[553]["轻功"] = JY.Person[553]["轻功"] + 80
                JY.Person[553]["武功1"] = 66
                JY.Person[553]["武功等级1"] = 999
                for j = 0, WAR.PersonNum - 1 do
                  if WAR.Person[j]["人物编号"] == 553 then
                    WAR.Person[j].Time = 980
                  end
                end
	            else
	            	if WAR.YZB3 == 0 then
	                say("６Ｒもはや　これまでか..........", 553)
	                say("２（真田幸村－－－－，Ｈ真是让人钦佩的勇士啊！！！）")
	                say("２（真田兄，一六一五年大阪城再会吧！Ｈ那时我的名字是......）")
	                WAR.YZB3 = 1
	              end
	            end
            end
          end
          
          if WAR.YJ > 0 then
            instruct_2(174, WAR.YJ)
            WAR.YJ = 0
          end
        else
	        if WAR.ZYHB == 2 then
	          WAR.ZYHB = 0
	        end
	        
	        WAR.Person[p].Time = WAR.Person[p].Time - 1000
	        if WAR.Person[p].Time < -500 then
	          WAR.Person[p].Time = -500
	        end
        
	        --血刀吸血
	        if WAR.XDXX > 0 then
	          WAR.Person[WAR.CurID]["生命点数"] = WAR.XDXX;
	          War_Show_Count(WAR.CurID, "血刀吸血");
	          WAR.XDXX = 0
	        end
        
	        --罗汉伏魔功 每回合回复生命
	        --for i = 1, 10 do
	          --if JY.Person[pid]["武功" .. i] == 96 and JY.Person[pid]["生命"] > 0 then
	           -- local LK = nil
	           -- LK = math.modf((JY.Person[pid]["生命最大值"] - JY.Person[pid]["生命"]) * JY.Person[pid]["武功等级" .. i] / 100 * 0.015)
	           -- JY.Person[pid]["生命"] = JY.Person[pid]["生命"] + LK
	           -- DrawStrBox(-1, -1, "罗汉伏魔功恢复生命" .. LK, C_ORANGE, CC.DefaultFont)
	           -- ShowScreen()
	          --  lib.Delay(400)
	          --  Cls()
	           -- ShowScreen()
			--end
	       -- end
	        
	        --紫霞神功 每回合回复内力
	        --for i = 1, 10 do
	         -- if JY.Person[pid]["武功" .. i] == 89 then
	         --   local NK = nil
	         --   NK = math.modf((JY.Person[pid]["内力最大值"] - JY.Person[pid]["内力"]) * JY.Person[pid]["武功等级" .. i] / 100 * 0.015)
	        --    JY.Person[pid]["内力"] = JY.Person[pid]["内力"] + NK
	         --   DrawStrBox(-1, -1, "紫霞神功恢复内力" .. NK, C_ORANGE, CC.DefaultFont)
	          --  ShowScreen()
	          --  lib.Delay(400)
	         --   Cls()
	         --   ShowScreen()
	        --  end
	        --end
	        
	        --混元功每回合回复体力
          if PersonKF(id, 90) then
            local TK = nil
						local NS = nil
            local ZD = 0
            TK = 6
						NS = 5 + math.modf(JY.Person[pid]["受伤程度"]/10)
            WAR.Person[WAR.CurID]["体力点数"] = AddPersonAttrib(pid, "体力", TK);
						AddPersonAttrib(pid, "受伤程度", -NS)
						War_Show_Count(WAR.CurID, "混元功回复体力");
          end
	        
	        --独孤九剑，集气+200
	        
          if PersonKF(id, 47) then
            WAR.Person[p].Time = WAR.Person[p].Time + 200
          end
	        
	        if WAR.XZZ == 1 then
	          WAR.XZZ = 0
	          WAR.Person[p].Time = WAR.Person[p].Time + 200
	        end
	        
	        if WAR.ZSF == 1 then
	          WAR.Person[p].Time = WAR.Person[p].Time + 500
	          WAR.ZSF = 0
	        end
	
	        
	        --朱九真，随机得到食材
	        if id == 81 and WAR.ZJZ == 0 and math.random(100)>80 then
	          instruct_2(210, 1)
	          WAR.ZJZ = 1
	        end
	        
	        --一灯和王重阳，避免被反死
	        if JY.Person[129]["生命"] <= 0 and WAR.WCY < 1 then
	          JY.Person[129]["生命"] = 1
	        end
	        if JY.Person[65]["生命"] <= 0 and WAR.WCY < 1 then
	          JY.Person[65]["生命"] = 1
	        end
	          
	        --小日本
	        if WAR.ZDDH == 128 then
	          for i = 0, WAR.PersonNum - 1 do
	            if WAR.Person[i]["人物编号"] == 553 and JY.Person[553]["生命"] <= 0 then
	              WAR.YZB = 1
	              WAR.FXDS[553] = nil
	              WAR.LXZT[553] = nil
	            end
	          end
	        end
	          
	        --小日本，复活三次
	        if WAR.YZB == 1 then
	          if WAR.YZB2 < 3 then
	            WAR.YZB = 0
	            WAR.YZB2 = WAR.YZB2 + 1
	            say("１Ｒ负けいくざ　だが　オレうちなるとうしが　それをこばむ　これはぶもんのいちか　真田幸村　いざ　まいる", 553)
	            JY.Person[553]["生命最大值"] = JY.Person[553]["生命最大值"] + 100
	            JY.Person[553]["内力最大值"] = JY.Person[553]["内力最大值"] + 1000
	            JY.Person[553]["生命"] = JY.Person[553]["生命最大值"]
	            JY.Person[553]["内力"] = JY.Person[553]["内力最大值"]
	            JY.Person[553]["中毒程度"] = 0
	            JY.Person[553]["受伤程度"] = 0
	            JY.Person[553]["体力"] = 100
	            JY.Person[553]["攻击力"] = JY.Person[553]["攻击力"] + 100
	            JY.Person[553]["防御力"] = JY.Person[553]["防御力"] + 100
	            JY.Person[553]["轻功"] = JY.Person[553]["轻功"] + 80
	            JY.Person[553]["武功1"] = 66
	            JY.Person[553]["武功等级1"] = 999
	            for j = 0, WAR.PersonNum - 1 do
	              if WAR.Person[j]["人物编号"] == 553 then
	                WAR.Person[j].Time = 990
	              end
	            end
	        	elseif WAR.YZB3 == 1 then
	            say("６Ｒもはや　これまでか..........", 553)
	            say("２（真田幸村－－－－，Ｈ真是让人钦佩的勇士啊！！！）")
	            say("２（真田兄，一六一五年大阪城再会吧！Ｈ那时我的名字是......）")
	            WAR.YZB3 = 1
	          end
	        end
	          
	        --主角，其疾如风，集气500
	        if WAR.FLHS1 == 1 then
	          if id == 0 then
	            WAR.Person[p].Time = WAR.Person[p].Time + 500
	          end
	          WAR.FLHS1 = 0
	        end
	        
	        ----蓝烟清：brolycjw杨过黯然神伤特效 行动后集气初始位置额外增加
	        --生命少过二分之一时每少100增加行动后集气位置加100
	        if id == 58 and JY.Person[58]["生命"] < JY.Person[58]["生命最大值"]/2  and GetS(86,11,11,5) == 2 then
	        	--计算行动后初始集气位置每100点生命，增加100点
	        	WAR.Person[p].Time = WAR.Person[p].Time +math.floor(JY.Person[58]["生命最大值"]/2 - JY.Person[58]["生命"]);
	        end
	          
	          
	        --血刀老祖
	        if id == 97 then
	          WAR.XDLZ = WAR.XDLZ + 5
	        end
	        
					--阎基偷钱
	        if WAR.YJ > 0 then
	          instruct_2(174, WAR.YJ)
	          WAR.YJ = 0
	        end
	        
	        --盲目状态恢复
	        if WAR.KHCM[pid] == 1 or WAR.KHCM[pid] == 2 then
	          WAR.KHCM[pid] = 0
	          Cls()
	          DrawStrBox(-1, -1, "盲目状态恢复", C_ORANGE, CC.DefaultFont)
	          ShowScreen()
	          lib.Delay(500)
	        end
	        
	        --蓄力，行动一次减1
	        if WAR.Actup[id] ~= nil then
	          WAR.Actup[id] = WAR.Actup[id] - 1
	        end
	        
	        if WAR.Actup[id] == 0 then
	          WAR.Actup[id] = nil
	        end
	        
	        --袁承志 免内伤
	        if id == 54 then
	          JY.Person[id]["受伤程度"] = 0
	        end
	        
	        JY.Wugong[13]["名称"] = "铁掌"
	        
	        --周伯通
	        if id == 64 then
	          WAR.ZBT = WAR.ZBT + 1
	        end
	        
	        
	        if WAR.TGN == 1 then
	          say("１哈哈哈－－－，苗人凤，你终于死于我手了！今日方解多年之恨！", 72)    --田归农杀掉苗人凤
	          JY.Person[72]["攻击力"] = JY.Person[72]["攻击力"] + 20
	          JY.Person[72]["防御力"] = JY.Person[72]["防御力"] + 20
	          JY.Person[72]["轻功"] = JY.Person[72]["轻功"] + 20
	          JY.Person[72]["武功1"] = 44
	          JY.Person[72]["武功等级1"] = 50
	          DrawStrBox(-1, -1, "田归农攻防轻能力各提升20点 学会苗家剑法", C_ORANGE, CC.DefaultFont)
	          ShowScreen()
	          lib.Delay(2000)
	          WAR.TGN = 0
	        end
	        
	        WAR.QKNY = 0
	        if WAR.LQZ[id] == 100 then
	          WAR.LQZ[id] = 0
	        end
	        
	        --杨过 吼  龙儿~~
	        if WAR.XK == 1 then
	          for j = 0, WAR.PersonNum - 1 do
	            if WAR.Person[j]["人物编号"] == 58 and 0 < JY.Person[WAR.Person[j]["人物编号"]]["生命"] and WAR.Person[j]["我方"] ~= WAR.Person[WAR.CurID]["我方"] then
	              WAR.Person[j].Time = 980
	              say("１Ｒ龙儿－－－－－－！Ｈ５啊－－－－４－－－－３－－－－２－－－－１－－－－－－－－！！！", 58)
	              WAR.XK = 2
	            end
	          end
	        end
	        
	        --发动 难知如阴
	        if WAR.FLHS5 == 1 then
	          local z = WAR.CurID
	          for j = 0, WAR.PersonNum - 1 do
	            if WAR.Person[j]["人物编号"] == 0 and 0 < JY.Person[0]["生命"] then
	              WAR.FLHS5 = 0
	              WAR.CurID = j
	            end
	          end
	          if WAR.FLHS5 == 0 and WAR.AutoFight == 0 and WAR.tmp[1000] ~= 1 then
	            WAR.Person[WAR.CurID]["移动步数"] = 6
	            War_CalMoveStep(WAR.CurID, WAR.Person[WAR.CurID]["移动步数"], 0)
	            local x, y = nil, nil
	            while 1 do
	              x, y = War_SelectMove()
	              if x ~= nil then
	                WAR.ShowHead = 0
	                War_MovePerson(x, y)
	                break;
	              end
	            end
	          end
	          WAR.FLHS5 = 0
	          WAR.CurID = z
	        end
	        
	        --圣火神功 攻击后可移动
	        if (0 < WAR.Person[p]["移动步数"] or 0 < WAR.ZYYD) and WAR.Person[p]["我方"] == true and inteam(WAR.Person[p]["人物编号"]) and WAR.AutoFight == 0 and WAR.tmp[1000 + id] ~= 1 and PersonKF(WAR.Person[p]["人物编号"], 93) and 0 < JY.Person[WAR.Person[p]["人物编号"]]["生命"] then
	          if 0 < WAR.ZYYD then
	            WAR.Person[p]["移动步数"] = WAR.ZYYD
	            War_CalMoveStep(p, WAR.ZYYD, 0)
	            WAR.ZYYD = 0
	          else
	            War_CalMoveStep(p, WAR.Person[p]["移动步数"], 0)
	          end
	          local x, y = nil, nil
	          while 1 do
	            x, y = War_SelectMove()
	            if x ~= nil then
	              WAR.ShowHead = 0
	              War_MovePerson(x, y)
	              break;
	            end 
	          end
	        end
	        
	        --雪山上杀血刀老祖后，恢复我方人物
	        if WAR.ZDDH == 7 then
	          for x = 0, WAR.PersonNum - 1 do
	            if WAR.Person[x]["人物编号"] == 97 and JY.Person[97]["生命"] <= 0 then
	              for xx = 0, WAR.PersonNum - 1 do
	                if WAR.Person[xx]["人物编号"] ~= 97 then
	                  WAR.Person[xx]["我方"] = true
	                end
	              end
	            end
	          end
	        end
	          
	        --
	        if WAR.ZDDH == 176 and 80 < JY.Person[0]["品德"] and WAR.EVENT1 == 0 and 300 < WAR.SXTJ then
	          for i = 32, 40 do
	            if GetWarMap(i, 32, 2) < 0 then
	              NewWARPersonZJ(69, true, i, 33, false, 1)
	              WAR.EVENT1 = 1
	              local s = nil
	              s = WAR.CurID
	              WAR.CurID = WAR.PersonNum - 1
	              say("１老叫化也来凑个热闹！", 69)   --老叫化也来凑个热闹
	              WAR.CurID = s
	              break;
	            end
	          end
	        end
	          
	        --杀东方不败，任老怪出现
	        if WAR.ZDDH == 54 and WAR.EVENT1 == 0 then
	          for i = 0, WAR.PersonNum - 1 do
	            if WAR.Person[i]["人物编号"] == 73 and WAR.Person[i]["我方"] == true and JY.Person[WAR.Person[i]["人物编号"]]["生命"] <= 0 then
	              for r = 31, 42 do
	                if GetWarMap(r, 27, 2) < 0 then
	                  NewWARPersonZJ(26, true, r, 27, false, 2)
	                  WAR.Person[WAR.PersonNum - 1].Time = 900
	                  WAR.EVENT1 = 1
	                  local s = nil
	                  s = WAR.CurID
	                  WAR.CurID = WAR.PersonNum - 1
	                  say("１盈盈，你先退下！为父来会会你东方阿姨，哈哈哈----", 26)   --盈盈，你先退下！为父来会会你东方阿姨，哈哈哈----
	                  WAR.CurID = s
	                  break;
	                end
	              end
	            end
		        end
	        end
	          
	          
	        if WAR.ZDDH == 54 and lib.GetWarMap(11, 36, 1) == 2 and inteam(WAR.Person[p]["人物编号"]) and WAR.Person[p]["坐标X"] == 12 and WAR.Person[p]["坐标Y"] == 36 then
	          lib.SetWarMap(11, 36, 1, 5420)
	          WarDrawMap(0)
	          say("AA")
	          say("OHMYGO", 27)
	          lib.SetWarMap(11, 36, 1, 0)
	        end
	        
	        if 500 < WAR.Person[p].Time then
	          WAR.Person[p].Time = 500
	        end
	        
	          
	        local pz = math.modf(JY.Person[0]["资质"] / 5)
	        --主角医生 大招
	        if id == 0 and GetS(4, 5, 5, 5) == 7  then
	        	if 50 < JY.Person[0]["体力"] then
	            if WAR.HTSS == 0 and GetS(53, 0, 4, 5) == 1 and JLSD(25, 50 + pz, 0) and 0 < JY.Person[0]["武功10"] then
	              CurIDTXDH(WAR.CurID, 91, 0)
	              Cls()
	              --[[
	              if JY.HEADXZ == 1 then
	                lib.PicLoadCache(91, 12, 270, -1, 1)
	              else
	                lib.PicLoadCache(91, 12, 48, 1, 1)
	              end
	              ]]
	              
	              ShowScreen()
	              lib.Delay(40)
	              for i = 12, 24 do
	                NewDrawString(-1, -1, ZJTF[7] .. TFSSJ[7], C_GOLD, 25 + i)
	                ShowScreen()
	                if i == 24 then
	                  Cls()
	                  NewDrawString(-1, -1, ZJTF[7] .. TFSSJ[7], C_GOLD, 25 + i)
	                  ShowScreen()
	                  lib.Delay(500)
	                else
	                  lib.Delay(1)
	                end
	              end
	              for j = 0, WAR.PersonNum - 1 do
	                WAR.Person[j].Time = WAR.Person[j].Time - 10
	                if 995 < WAR.Person[j].Time then
	                  WAR.Person[j].Time = 995
	                end
	              end
	              WAR.Person[WAR.CurID].Time = 1005
	              JY.Person[0]["体力"] = JY.Person[0]["体力"] - 10
	              if JLSD(45, 50, 0) then
	                WAR.HTSS = 0        
	              else
	                WAR.HTSS = 1
	              end
	            end
	          else
	          	WAR.HTSS = 0
	          end
	        end
	          
	        --成昆密道 100时序就跑
	        if WAR.ZDDH == 237 and 100 < WAR.SXTJ then
	          for i = 0, WAR.PersonNum - 1 do
	            if WAR.Person[i]["我方"] == false then
	              WAR.Person[i]["死亡"] = true
	            end
	          end
	          say("１（嗯，没功夫跟这小子纠缠了）Ｐ哈哈哈，小子，算你走运！老夫还有要事待办，这次就放你一马！", 18)  --(嗯，没功夫跟这小子纠缠了）
	        end
	          
	      	 --冰糖恋：正十五大20时序胜利
	        if WAR.ZDDH == 134 and 20 < WAR.SXTJ and GetS(87,31,32,5) == 1 then
	          for i = 0, WAR.PersonNum - 1 do
	            if WAR.Person[i]["我方"] == false then
	              WAR.Person[i]["死亡"] = true
	            end
	          end
	          TalkEx("恭喜少侠挺过20时序，成功过关。",269,0);
	        end
	
					--冰糖恋：邪十五大20时序胜利
	        if WAR.ZDDH == 133 and 20 < WAR.SXTJ and GetS(87,31,31,5) == 1 then
	          for i = 0, WAR.PersonNum - 1 do
	            if WAR.Person[i]["我方"] == false then
	              WAR.Person[i]["死亡"] = true
	            end
	          end
	          TalkEx("恭喜少侠挺过20时序，成功过关。",269,0);
	        end
	        
	        --蓝烟清：单挑，十八铜人 800时序胜利
	        if WAR.ZDDH == 217 and GetS(86,1,2,5) == 1 and 800 < WAR.SXTJ then
	        	for i = 0, WAR.PersonNum - 1 do
	            if WAR.Person[i]["我方"] == false then
	              WAR.Person[i]["死亡"] = true
	            end
	          end
	          Talk("呼呼~~终于闯过去了~~~少林十八铜人阵果然名不虚传~~",0);		--呼呼~~终于闯过去了~~~少林十八铜人阵果然名不虚传~~
	        end
	        
	        --蓝烟清：群战，十八铜人 超过500时序失败
	        if WAR.ZDDH == 217 and GetS(86,1,2,5) == 2 and 500 < WAR.SXTJ then
	        	Talk("呼呼~~好可惜，差一点就成功了。少林十八铜人阵果然名不虚传",0);		--呼呼~~好可惜，差一点就成功了。少林十八铜人阵果然名不虚传
	        	for i = 0, WAR.PersonNum - 1 do
	            if WAR.Person[i]["我方"] then
	              WAR.Person[i]["死亡"] = true
	            end
	          end
	        end
	        
          
	        --新华山论剑
	        if WAR.ZDDH == 238 then
	        	local life = 0
	        	WAR.NO1 = 114;
	          for i = 0, WAR.PersonNum - 1 do
	            if WAR.Person[i]["死亡"] == false and 0 < JY.Person[WAR.Person[i]["人物编号"]]["生命"] then
	              life = life + 1
	              if WAR.NO1 >= WAR.Person[i]["人物编号"] then
	              	WAR.NO1 = WAR.Person[i]["人物编号"]
	              end
	            end
	          end
	          
	          if 1 < life then
	            local m, n = 0, 0
	            while true do			--防止全部随机到已方
	            	if m >= 1 and n >= 1 then
	            		break;
	            	else
	            		m = 0;
	            		n = 0;
	            	end
	            	
		            for i = 0, WAR.PersonNum - 1 do
		              if WAR.Person[i]["死亡"] == false and 0 < JY.Person[WAR.Person[i]["人物编号"]]["生命"] then
		                if WAR.Person[i]["人物编号"] == 0 then
		                  WAR.Person[i]["我方"] = true
		                  	m = m + 1
			              elseif math.random(2) == 1 then
			                  WAR.Person[i]["我方"] = true
			                  m = m + 1
			              else
		                	WAR.Person[i]["我方"] = false
		                	n = n + 1
		                end
		              end
		            end
		          end
	          end
	        end
	    	end
	    end
	    
		  warStatus = War_isEnd()   --战斗是否结束？   0继续，1赢，2输
		  if 0 < warStatus then
     		break;
    	end
    	CleanMemory()
    end
    if 0 < warStatus then
     	break;
    end
    WarPersonSort(1)
    WAR.Delay = GetJiqi()
    startt = lib.GetTime()
    collectgarbage("step", 0)
  end
  local r = nil
  WAR.ShowHead = 0
  
  --蓝烟清：战斗结束，敌方队友状态回复
  for i = 0, WAR.PersonNum - 1 do	
  	if WAR.tmp[4000 + i] ~= nil then
  		local n = WAR.tmp[4000 + i];
  		JY.Person[n[1]]["生命最大值"] = JY.Person[n[1]]["生命最大值"] - n[2]
  		JY.Person[n[1]]["内力最大值"] = JY.Person[n[1]]["内力最大值"] - n[3]
  		JY.Person[n[1]]["攻击力"] = JY.Person[n[1]]["攻击力"] - n[4]
  		JY.Person[n[1]]["防御力"] = JY.Person[n[1]]["防御力"] - n[5]
  		JY.Person[n[1]]["轻功"] = JY.Person[n[1]]["轻功"] - n[6]
  	end
  end
  
  --重复战斗的也算是一个刷的福利吧
  if WAR.tmp[8002] ~= nil then
  	JY.Thing[238]["需经验"] = JY.Thing[238]["需经验"] + limitX(WAR.tmp[8002],0,40)		--一局最多40
  	
  	--限制不可以开始就刷满
  	if JY.Thing[238]["需经验"] > JY.Person[0]["声望"]*8 then
  		JY.Thing[238]["需经验"] = JY.Person[0]["声望"]*8
  	end
  	
  	if JY.Thing[238]["需经验"] > 1000 then
  		JY.Thing[238]["需经验"] = 1000;
  	end
  end
  
  --战斗结束后的奖励
  if WAR.ZDDH == 238 then
    PlayMIDI(101)
    PlayWavAtk(41)
    DrawStrBoxWaitKey("论剑结束", C_WHITE, CC.DefaultFont)
    DrawStrBoxWaitKey("武功天下第一者：" .. JY.Person[WAR.NO1]["姓名"], C_RED, CC.DefaultFont)
    if WAR.NO1 == 0 then
      r = true
    else
      r = false
    end
  elseif warStatus == 1 then   --战斗胜利
    PlayMIDI(101)
    PlayWavAtk(41)
    DrawStrBoxWaitKey("战斗胜利", C_WHITE, CC.DefaultFont)
    if WAR.ZDDH == 76 then
      DrawStrBoxWaitKey("特殊奖励：千年灵芝两枚", C_GOLD, CC.DefaultFont)
      instruct_32(14, 2)
    elseif WAR.ZDDH == 80 then
        DrawStrBoxWaitKey("特殊奖励：主角四系兵器值提升十点", C_GOLD, CC.DefaultFont)
        AddPersonAttrib(0, "拳掌功夫", 10)
        AddPersonAttrib(0, "御剑能力", 10)
        AddPersonAttrib(0, "耍刀技巧", 10)
        AddPersonAttrib(0, "特殊兵器", 10)
    elseif WAR.ZDDH == 100 then
        DrawStrBoxWaitKey("特殊奖励：获得天王保命丹两颗", C_GOLD, CC.DefaultFont)
        instruct_32(8, 2)
    elseif WAR.ZDDH == 172 then
        DrawStrBoxWaitKey("特殊奖励：获得蛤蟆功秘籍一册", C_GOLD, CC.DefaultFont)
        instruct_32(73, 1)
    elseif WAR.ZDDH == 173 then
        DrawStrBoxWaitKey("特殊奖励：获得天山雪莲两枚", C_GOLD, CC.DefaultFont)
        instruct_32(17, 2)
    elseif WAR.ZDDH == 188 then
        DrawStrBoxWaitKey("特殊奖励：主角拳掌功夫提升十点", C_GOLD, CC.DefaultFont)
        AddPersonAttrib(0, "拳掌功夫", 10)
    elseif WAR.ZDDH == 211 then
        DrawStrBoxWaitKey("特殊奖励：主角防御力和轻功各提升十点", C_GOLD, CC.DefaultFont)
        AddPersonAttrib(0, "防御力", 10)
        AddPersonAttrib(0, "轻功", 10)
    elseif WAR.ZDDH == 86 then
        instruct_2(66, 1)
	elseif WAR.ZDDH == 75 or WAR.ZDDH == 4 then
		QZXS(string.format("%s 实战增加%s点",JY.Person[0]["姓名"],50));
		SetS(5, 1, 6, 5, GetS(5, 1, 6, 5)+50);
	elseif WAR.ZDDH == 77 then
		QZXS(string.format("%s 实战增加%s点",JY.Person[0]["姓名"],30));
		SetS(5, 1, 6, 5, GetS(5, 1, 6, 5)+30);	
	elseif WAR.ZDDH > 42 and  WAR.ZDDH < 47 then
		QZXS(string.format("%s 实战增加%s点",JY.Person[0]["姓名"],20));
		SetS(5, 1, 6, 5, GetS(5, 1, 6, 5)+20);
	elseif WAR.ZDDH == 161 then
		QZXS(string.format("%s 实战增加%s点",JY.Person[0]["姓名"],70));
		SetS(5, 1, 6, 5, GetS(5, 1, 6, 5)+70);		
    end
    
    --蓝烟清：战斗胜利，可随机偷取敌人身上的物品，只偷取药品
    local thing = {};
    local tnum = 0;
    for i = 0, WAR.PersonNum - 1 do
    	if WAR.Person[i]["我方"] == false then
    		local enid = WAR.Person[i]["人物编号"];
    		for j=1, 4 do
	    		if JY.Person[enid]["携带物品数量" .. j] ~= nil and 0 < JY.Person[enid]["携带物品数量" .. j] and -1 < JY.Person[enid]["携带物品" .. j] and JY.Person[enid]["携带物品" .. j] < 26 then
						tnum = tnum + 1
						thing[tnum] = {JY.Person[enid]["携带物品" .. j], enid, j}
			    end
			  end
    	end	
    end
    if tnum > 0 then
    	local n = math.random(tnum+2);		--随机偷取
    	if thing[n] ~= nil then
    		local a = thing[n][1];		--物品ID号
    		local b = thing[n][2];		--人物的编号
    		local c = thing[n][3];		--携带的物品位置
    		
    		JY.Person[b]["携带物品数量"..c] = JY.Person[b]["携带物品数量"..c] - 1;
    		if JY.Person[b]["携带物品数量"..c] < 1 then
    			JY.Person[b]["携带物品"..c] = -1;
    		end
				DrawStrBoxWaitKey(string.format("获得战利品：%s %d个", JY.Thing[a]["名称"], 1), C_GOLD, CC.DefaultFont)
				instruct_32(a, 1);
    	end
    end
    r = true
  elseif warStatus == 2 then   --战斗失败
    DrawStrBoxWaitKey("战斗失败", C_WHITE, CC.DefaultFont)
    r = false
  end
  War_EndPersonData(isexp, warStatus)
  lib.ShowSlow(50, 1)
  if 0 <= JY.Scene[JY.SubScene]["进门音乐"] then
    PlayMIDI(JY.Scene[JY.SubScene]["进门音乐"])
  else
    PlayMIDI(0)
  end
  CleanMemory()
  lib.PicInit()
  
  lib.PicLoadFile(CC.SMAPPicFile[1], CC.SMAPPicFile[2], 0)
  --lib.PicLoadFile(CC.HeadPicFile[1], CC.HeadPicFile[2], 1, limitX(CC.ScreenW/6,50,110))
	lib.LoadPNGPath(CC.HeadPath, 1, CC.HeadNum, limitX(CC.ScreenW/6,50,130))
  lib.PicLoadFile(CC.ThingPicFile[1], CC.ThingPicFile[2], 2)
  JY.Status = GAME_SMAP
  return r
end

--黄蓉，布阵
function buzhen()
  if not inteam(56) then
    return 
  end
  if WAR.ZDDH == 238 then
    return 
  end
  say("ｎ，要布置阵型吗？", 56)
  if not DrawStrBoxYesNo(-1, -1, "要布置阵型吗", C_WHITE, CC.DefaultFont) then
    return 
  end
  for i = 0, WAR.PersonNum - 1 do
    if WAR.Person[i]["我方"] then
      WAR.CurID = i
      WAR.ShowHead = 1
      War_CalMoveStep(WAR.CurID, math.modf(JY.Person[56]["等级"] / 3 - 4), 0)
      local x, y = nil, nil
      while true do
        x, y = War_SelectMove()
        if x ~= nil then
          WAR.ShowHead = 0
          War_MovePerson(x, y)
        	break;
        end
      end
    end
  end
end

function CurIDTXDH(id, eft, MAX, str)
  local x0, y0 = WAR.Person[id]["坐标X"], WAR.Person[id]["坐标Y"]
  local hb = GetS(JY.SubScene, x0, y0, 4)

  --加载EFT
	if WAR.EFT[eft] == nil then
		lib.PicLoadFile(string.format(CC.EffectFile[1],eft), string.format(CC.EffectFile[2],eft), 70+WAR.EFTNUM);
		WAR.EFT[eft] = 70+WAR.EFTNUM;
		WAR.EFTNUM = WAR.EFTNUM + 1;
		if WAR.EFTNUM > 20 then
			WAR.EFTNUM = 0;
		end
	end
	
	local starteft, emdeft = 0, CC.Effect[eft];
	
	if MAX > 0 then
		starteft, emdeft = emdeft, starteft;
	end
  local ssid = lib.SaveSur(0, 0, CC.ScreenW, CC.ScreenH)
  for ii = starteft, emdeft do
    lib.PicLoadCache(WAR.EFT[eft], ii * 2, CC.ScreenW / 2, CC.ScreenH / 2 - hb, 2, 192)
    if str ~= nil then
      DrawString(-1, CC.ScreenH / 2 - hb, str, C_GOLD, CC.DefaultFont)
    end
    ShowScreen()
    lib.Delay(CC.Frame)
    lib.LoadSur(ssid, 0, 0)
  end
  lib.FreeSur(ssid)
  Cls()
end


--火凤燎原
function DHZFXS(s)
  for i = 1, 20 do
    NewDrawString(-1, -1, s, C_GOLD, CC.DefaultFont + i)
    ShowScreen()
    if i == 20 then
      lib.Delay(CC.Frame)
    else
      lib.Delay(1)
      Cls();
    end
  end
end


function WE_xy(x, y, id)
  if id ~= nil then
    War_CalMoveStep(id, 128, 0)
  else
    CleanWarMap(3, 0)
  end
  if GetWarMap(x, y, 3) ~= 255 and War_CanMoveXY(x, y, 0) then
    return x, y
  else
    for s = 1, 128 do
      for i = 1, s do
        local j = s - i
        if x + i < 63 and y + j < 63 and GetWarMap(x + i, y + j, 3) ~= 255 and War_CanMoveXY(x + i, y + j, 0) then
          return x + i, y + j
        end
        if x + j < 63 and y - i > 0 and GetWarMap(x + j, y - i, 3) ~= 255 and War_CanMoveXY(x + j, y - i, 0) then
          return x + j, y - i
        end
        if x - i > 0 and y - j > 0 and GetWarMap(x - i, y - j, 3) ~= 255 and War_CanMoveXY(x - i, y - j, 0) then
          return x - i, y - j
        end
        if x - j > 0 and y + i < 63 and GetWarMap(x - j, y + i, 3) ~= 255 and War_CanMoveXY(x - j, y + i, 0) then
          return x - j, y + i
        end
      end
    end
  end
  for s = 1, 128 do
    for i = 1, s do
      local j = s - i
      if x + i < 63 and y + j < 63 and War_CanMoveXY(x + i, y + j, 0) then
        return x + i, y + j
      end
      if x + j < 63 and y - i > 0 and War_CanMoveXY(x + j, y - i, 0) then
        return x + j, y - i
      end
      if x - i > 0 and y - j > 0 and War_CanMoveXY(x - i, y - j, 0) then
        return x - i, y - j
      end
      if x - j > 0 and y + i < 63 and War_CanMoveXY(x - j, y + i, 0) then
        return x - j, y + i
      end
    end
  end
  return x, y
end

--计算暗器伤害
function War_AnqiHurt(pid, emenyid, thingid)
  local num = nil
  if JY.Person[emenyid]["受伤程度"] == 0 then
    num = JY.Thing[thingid]["加生命"] / 3 - Rnd(5)
  elseif JY.Person[emenyid]["受伤程度"] <= 33 then
      num = JY.Thing[thingid]["加生命"] / 2 - Rnd(8)
  elseif JY.Person[emenyid]["受伤程度"] <= 66 then
      num = math.modf(JY.Thing[thingid]["加生命"] *2 / 3) - Rnd(12)
  else
    num = JY.Thing[thingid]["加生命"] - Rnd(16)
  end
  
  num = math.modf((num - JY.Person[pid]["暗器技巧"] * 2) / 3)
  AddPersonAttrib(emenyid, "受伤程度", math.modf(-num / 6))
  local r = AddPersonAttrib(emenyid, "生命", math.modf(num / 2))
  if (emenyid == 129 or emenyid == 65) and JY.Person[emenyid]["生命"] <= 0 then
    JY.Person[emenyid]["生命"] = 1
  end
  if emenyid == 553 and JY.Person[emenyid]["生命"] <= 0 then
    WAR.YZB = 1
  end
  if JY.Person[emenyid]["生命"] <= 0 then
    WAR.Person[WAR.CurID]["经验"] = WAR.Person[WAR.CurID]["经验"] + JY.Person[emenyid]["等级"] * 5
  end
  if JY.Thing[thingid]["加中毒解毒"] > 0 then
    num = math.modf((JY.Thing[thingid]["加中毒解毒"] + JY.Person[pid]["暗器技巧"]) / 4)
    num = num - JY.Person[emenyid]["抗毒能力"]
    num = limitX(num, 0, CC.PersonAttribMax["用毒能力"])
    AddPersonAttrib(emenyid, "中毒程度", num)
  end
  return r
end
--计算从(x,y)开始攻击最多能够击中几个敌人
function War_AutoCalMaxEnemy(x, y, wugongid, level)
  local wugongtype = JY.Wugong[wugongid]["攻击范围"]
  local movescope = JY.Wugong[wugongid]["移动范围" .. level]
  local fightscope = JY.Wugong[wugongid]["杀伤范围" .. level]
  local maxnum = 0
  local xmax, ymax = nil, nil
  if wugongtype == 0 or wugongtype == 3 then
    local movestep = War_CalMoveStep(WAR.CurID, movescope, 1)	--计算武功移动步数
    for i = 1, movescope do
      local step_num = movestep[i].num
      if step_num == 0 then
        break;
      end
      for j = 1, step_num do
        local xx = movestep[i].x[j]
        local yy = movestep[i].y[j]
        local enemynum = 0
        for n = 0, WAR.PersonNum - 1 do
          if n ~= WAR.CurID and WAR.Person[n]["死亡"] == false and WAR.Person[n]["我方"] ~= WAR.Person[WAR.CurID]["我方"] then
            local x = math.abs(WAR.Person[n]["坐标X"] - xx)
            local y = math.abs(WAR.Person[n]["坐标Y"] - yy)
          end
          if x <= fightscope and y <= fightscope then
            enemynum = enemynum + 1
          end
        end
        if maxnum < enemynum then
          maxnum = enemynum
          xmax = xx
          ymax = yy
        end
      end
    end
  elseif wugongtype == 1 then
    for direct = 0, 3 do
      local enemynum = 0
      for i = 1, movescope do
        local xnew = x + CC.DirectX[direct + 1] * i
        local ynew = y + CC.DirectY[direct + 1] * i
        if xnew >= 0 and xnew < CC.WarWidth and ynew >= 0 and ynew < CC.WarHeight then
          local id = GetWarMap(xnew, ynew, 2)
        end
        if id >= 0 and WAR.Person[WAR.CurID]["我方"] ~= WAR.Person[id]["我方"] then
          enemynum = enemynum + 1
        end
      end
      if maxnum < enemynum then
        maxnum = enemynum
        xmax = x + CC.DirectX[direct + 1]
        ymax = y + CC.DirectY[direct + 1]
      end
    end
  elseif wugongtype == 2 then
    local enemynum = 0
    for direct = 0, 3 do
      for i = 1, movescope do
        local xnew = x + CC.DirectX[direct + 1] * i
        local ynew = y + CC.DirectY[direct + 1] * i
        if xnew >= 0 and xnew < CC.WarWidth and ynew >= 0 and ynew < CC.WarHeight then
          local id = GetWarMap(xnew, ynew, 2)
        end
        if id >= 0 and WAR.Person[WAR.CurID]["我方"] ~= WAR.Person[id]["我方"] then
          enemynum = enemynum + 1
        end
      end
    end
  end
  if enemynum > 0 then
    maxnum = enemynum
    xmax = x
    ymax = y
  end
  return maxnum, xmax, ymax
end


--得到可以走到攻击到敌人的最近位置。
--scope可以攻击的范围
--返回 x,y。如果无法走到攻击位置，返回空
function War_AutoCalMaxEnemyMap(wugongid, level)
  local wugongtype = JY.Wugong[wugongid]["攻击范围"]
  local movescope = JY.Wugong[wugongid]["移动范围" .. level]
  local fightscope = JY.Wugong[wugongid]["杀伤范围" .. level]
  local x0 = WAR.Person[WAR.CurID]["坐标X"]
  local y0 = WAR.Person[WAR.CurID]["坐标Y"]
  CleanWarMap(4, 0)
  if wugongtype == 0 or wugongtype == 3 then
    for n = 0, WAR.PersonNum - 1 do
      if n ~= WAR.CurID and WAR.Person[n]["死亡"] == false and WAR.Person[n]["我方"] ~= WAR.Person[WAR.CurID]["我方"] then
        local xx = WAR.Person[n]["坐标X"]
        local yy = WAR.Person[n]["坐标Y"]
        local movestep = War_CalMoveStep(n, movescope, 1)
        for i = 1, movescope do
          local step_num = movestep[i].num
	        if step_num == 0 then
	          
	        else
	          for j = 1, step_num do
	            SetWarMap(movestep[i].x[j], movestep[i].y[j], 4, 1)
	          end
	        end
	      end
      end
    end
  elseif wugongtype == 1 or wugongtype == 2 then
    for n = 0, WAR.PersonNum - 1 do
      if n ~= WAR.CurID and WAR.Person[n]["死亡"] == false and WAR.Person[n]["我方"] ~= WAR.Person[WAR.CurID]["我方"] then
        local xx = WAR.Person[n]["坐标X"]
        local yy = WAR.Person[n]["坐标Y"]
        for direct = 0, 3 do
          for i = 1, movescope do
            local xnew = xx + CC.DirectX[direct + 1] * i
            local ynew = yy + CC.DirectY[direct + 1] * i
            if xnew >= 0 and xnew < CC.WarWidth and ynew >= 0 and ynew < CC.WarHeight then
              local v = GetWarMap(xnew, ynew, 4)
              SetWarMap(xnew, ynew, 4, v + 1)
            end
          end
        end
      end
    end
  end
end--自动医疗
function War_AutoDoctor()
  local x1 = WAR.Person[WAR.CurID]["坐标X"]
  local y1 = WAR.Person[WAR.CurID]["坐标Y"]
  War_ExecuteMenu_Sub(x1, y1, 3, -1)
end--自动吃药
--flag=2 生命，3内力；4体力  6 解毒
function War_AutoEatDrug(flag)
  local pid = WAR.Person[WAR.CurID]["人物编号"]
  local life = JY.Person[pid]["生命"]
  local maxlife = JY.Person[pid]["生命最大值"]
  local selectid = nil
  local minvalue = math.huge
  local shouldadd, maxattrib, str = nil, nil, nil
  if flag == 2 then
    maxattrib = JY.Person[pid]["生命最大值"]
    shouldadd = maxattrib - JY.Person[pid]["生命"]
    str = "加生命"
  elseif flag == 3 then
    maxattrib = JY.Person[pid]["内力最大值"]
    shouldadd = maxattrib - JY.Person[pid]["内力"]
    str = "加内力"
  elseif flag == 4 then
    maxattrib = CC.PersonAttribMax["体力"]
    shouldadd = maxattrib - JY.Person[pid]["体力"]
    str = "加体力"
  elseif flag == 6 then
    maxattrib = CC.PersonAttribMax["中毒程度"]
    shouldadd = JY.Person[pid]["中毒程度"]
    str = "加中毒解毒"
  else
    return 
  end
  local function Get_Add(thingid)
    if flag == 6 then
      return -JY.Thing[thingid][str] / 2
    else
      return JY.Thing[thingid][str]
    end
  end
  
  if inteam(pid) and WAR.Person[WAR.CurID]["我方"] == true then
    local extra = 0
    for i = 1, CC.MyThingNum do
      local thingid = JY.Base["物品" .. i]
      if thingid >= 0 then
        local add = Get_Add(thingid)
        if JY.Thing[thingid]["类型"] == 3 and add > 0 then
	        local v = shouldadd - add
	        if v < 0 then
	          extra = 1
		      elseif v < minvalue then
		        minvalue = v
		        selectid = thingid
		      end
		    end
      end
    end
    if extra == 1 then
      minvalue = math.huge
      for i = 1, CC.MyThingNum do
        local thingid = JY.Base["物品" .. i]
        if thingid >= 0 then
          local add = Get_Add(thingid)
          if JY.Thing[thingid]["类型"] == 3 and add > 0 then
	          local v = add - shouldadd
	          if v >= 0 and v < minvalue then
		          minvalue = v
		          selectid = thingid
		        end
	        end
        end
      end
    end
    if UseThingEffect(selectid, pid) == 1 then
      instruct_32(selectid, -1)
    end
  else
    local extra = 0
    for i = 1, 4 do
      local thingid = JY.Person[pid]["携带物品" .. i]
      local tids = JY.Person[pid]["携带物品数量" .. i]
      if thingid >= 0 and tids > 0 then
        local add = Get_Add(thingid)
        if JY.Thing[thingid]["类型"] == 3 and add > 0 then
	        local v = shouldadd - add
	        if v < 0 then		--可以加满生命, 用其他方法找合适药品
	          extra = 1
		      elseif v < minvalue then
		        minvalue = v
		        selectid = thingid
		      end
		    end
      end
    end
    if extra == 1 then
      minvalue = math.huge
      for i = 1, 4 do
        local thingid = JY.Person[pid]["携带物品" .. i]
        local tids = JY.Person[pid]["携带物品数量" .. i]
        if thingid >= 0 and tids > 0 then
          local add = Get_Add(thingid)
          if JY.Thing[thingid]["类型"] == 3 and add > 0 then
	          local v = add - shouldadd
	          if v >= 0 and v < minvalue then
		          minvalue = v
		          selectid = thingid
		        end
	        end
        end 
      end
    end
  end
  if UseThingEffect(selectid, pid) == 1 then
    instruct_41(pid, selectid, -1)
  end
  lib.Delay(500)
end
--自动逃跑
function War_AutoEscape()
  local pid = WAR.Person[WAR.CurID]["人物编号"]
  if JY.Person[pid]["体力"] <= 5 then
    return 
  end
  local x, y = nil, nil
  War_CalMoveStep(WAR.CurID, WAR.Person[WAR.CurID]["移动步数"], 0)		 --计算移动步数
  WarDrawMap(1)
  ShowScreen()
  local array = {}
  local num = 0
  
  for i = 0, CC.WarWidth - 1 do
    for j = 0, CC.WarHeight - 1 do
      if GetWarMap(i, j, 3) < 128 then
        local minDest = math.huge
        for k = 0, WAR.PersonNum - 1 do
          if WAR.Person[WAR.CurID]["我方"] ~= WAR.Person[k]["我方"] and WAR.Person[k]["死亡"] == false then
            local dx = math.abs(i - WAR.Person[k]["坐标X"])
            local dy = math.abs(j - WAR.Person[k]["坐标Y"])
	          if dx + dy < minDest then		--计算当前距离敌人最近的位置
	            minDest = dx + dy
	          end
          end
        end
        num = num + 1
        array[num] = {}
        array[num].x = i
        array[num].y = j
        array[num].p = minDest
      end
    end
  end
  
  for i = 1, num - 1 do
    for j = i, num do
      if array[i].p < array[j].p then
        array[i], array[j] = array[j], array[i]
      end
    end
  end
  for i = 2, num do
    if array[i].p < array[1].p / 2 then
      num = i - 1
      break;
    end
  end
  for i = 1, num do
    array[i].p = array[i].p * 5 + GetMovePoint(array[i].x, array[i].y, 1)
  end
  for i = 1, num - 1 do
    for j = i, num do
      if array[i].p < array[j].p then
        array[i], array[j] = array[j], array[i]
      end
    end
  end
  x = array[1].x
  y = array[1].y

  War_CalMoveStep(WAR.CurID, WAR.Person[WAR.CurID]["移动步数"], 0)
  War_MovePerson(x, y)	--移动到相应的位置
end
--自动执行战斗，此时的位置一定可以打到敌人
function War_AutoExecuteFight(wugongnum)
  local pid = WAR.Person[WAR.CurID]["人物编号"]
  local x0 = WAR.Person[WAR.CurID]["坐标X"]
  local y0 = WAR.Person[WAR.CurID]["坐标Y"]
  local wugongid = JY.Person[pid]["武功" .. wugongnum]
  local level = math.modf(JY.Person[pid]["武功等级" .. wugongnum] / 100) + 1
  local maxnum, x, y = War_AutoCalMaxEnemy(x0, y0, wugongid, level)
  if x ~= nil then
    War_Fight_Sub(WAR.CurID, wugongnum, x, y)
    WAR.Person[WAR.CurID].Action = {"atk", x - WAR.Person[WAR.CurID]["坐标X"], y - WAR.Person[WAR.CurID]["坐标Y"]}
  end
end--自动战斗
function War_AutoMenu()
  WAR.AutoFight = 1
  WAR.ShowHead = 0
  Cls()
  War_Auto()
  return 1
end

--计算可移动步数
--id 战斗人id，
--stepmax 最大步数，
--flag=0  移动，物品不能绕过，1 武功，用毒医疗等，不考虑挡路。
function War_CalMoveStep(id, stepmax, flag)
  CleanWarMap(3, 255)
  local x = WAR.Person[id]["坐标X"]
  local y = WAR.Person[id]["坐标Y"]
  local steparray = {}
  for i = 0, stepmax do
    steparray[i] = {}
    steparray[i].bushu = {}
    steparray[i].x = {}
    steparray[i].y = {}
  end
  SetWarMap(x, y, 3, 0)
  steparray[0].num = 1
  steparray[0].bushu[1] = stepmax
  steparray[0].x[1] = x
  steparray[0].y[1] = y
  War_FindNextStep(steparray, 0, flag, id)
  return steparray
end
--判断x,y是否为可移动位置
function War_CanMoveXY(x, y, flag)
  if GetWarMap(x, y, 1) > 0 then
    return false
  end
  if flag == 0 then
    if CC.WarWater[GetWarMap(x, y, 0)] ~= nil then
      return false
    end
    if GetWarMap(x, y, 2) >= 0 then
    	return false
  	end
  end
  return true
end--解毒菜单
function War_DecPoisonMenu()
  WAR.ShowHead = 0
  local r = War_ExecuteMenu(2)
  WAR.ShowHead = 1
  Cls()
  return r
end

--判断攻击后面对的方向
function War_Direct(x1, y1, x2, y2)
  local x = x2 - x1
  local y = y2 - y1
  if x == 0 and y == 0 then
    return WAR.Person[WAR.CurID]["人方向"]
  end
  if math.abs(x) < math.abs(y) then
    if y > 0 then
      return 3
    else
      return 0
    end
  else 
    if x > 0 then
    	return 1
  	else
    	return 2
    end
  end
end

--医疗菜单
function War_DoctorMenu()
  WAR.ShowHead = 0
  local r = War_ExecuteMenu(3)
  WAR.ShowHead = 1
  Cls()
  return r
end---执行医疗，解毒用毒
---flag=1 用毒， 2 解毒，3 医疗 4 暗器
---thingid 暗器物品id
function War_ExecuteMenu(flag, thingid)
  local pid = WAR.Person[WAR.CurID]["人物编号"]
  local step = nil
  if flag == 1 then
    step = math.modf(JY.Person[pid]["用毒能力"] / 40)
  elseif flag == 2 then
    step = math.modf(JY.Person[pid]["解毒能力"] / 40)
  elseif flag == 3 then
    step = math.modf(JY.Person[pid]["医疗能力"] / 40)
  elseif flag == 4 then
    step = math.modf(JY.Person[pid]["暗器技巧"] / 15) + 1
  end
  War_CalMoveStep(WAR.CurID, step, 1)
  local x1, y1 = War_SelectMove()
  if x1 == nil then
    lib.GetKey()
    Cls()
    return 0
  else
    return War_ExecuteMenu_Sub(x1, y1, flag, thingid)
  end
end
--War_FightSelectType 
function War_FightSelectType(movefanwei, atkfanwei, x, y,wugong)
  local x0 = WAR.Person[WAR.CurID]["坐标X"]
  local y0 = WAR.Person[WAR.CurID]["坐标Y"]
  if x == nil and y == nil then
    x, y = War_KfMove(movefanwei, atkfanwei,wugong)
    if x == nil then
      lib.GetKey()
      Cls()
      return 
    end
  else
    WarDrawAtt(x, y, atkfanwei, 1)
    ShowScreen()
    lib.Delay(200)
  end
  if not War_Direct(x0, y0, x, y) then
    WAR.Person[WAR.CurID]["人方向"] = WAR.Person[WAR.CurID]["人方向"]
  else
  	WAR.Person[WAR.CurID]["人方向"] = War_Direct(x0, y0, x, y)
  end
  SetWarMap(x, y, 4, 1)
  WAR.EffectXY = {}
  return x, y
end

--设置下一步可移动的坐标
function War_FindNextStep(steparray, step, flag, id)
  local num = 0
  local step1 = step + 1
  
  local fujinnum = function(tx, ty)
    if flag ~= 0 or id == nil then
      return 0
    end
    local tnum = 0
    local wofang = WAR.Person[id]["我方"]
    local tv = nil
    tv = GetWarMap(tx + 1, ty, 2)
    if tv ~= -1 and WAR.Person[tv]["我方"] ~= wofang then
      tnum = 9999
    end
    tv = GetWarMap(tx - 1, ty, 2)
    if tv ~= -1 and WAR.Person[tv]["我方"] ~= wofang then
      tnum = 999
    end
    tv = GetWarMap(tx, ty + 1, 2)
    if tv ~= -1 and WAR.Person[tv]["我方"] ~= wofang then
      tnum = 999
    end
    tv = GetWarMap(tx, ty - 1, 2)
    if tv ~= -1 and WAR.Person[tv]["我方"] ~= wofang then
      tnum = 999
    end
    return tnum
  end
  
  for i = 1, steparray[step].num do
    if steparray[step].bushu[i] > 0 then
      steparray[step].bushu[i] = steparray[step].bushu[i] - 1
      local x = steparray[step].x[i]
      local y = steparray[step].y[i]
      if x + 1 < CC.WarWidth - 1 then
        local v = GetWarMap(x + 1, y, 3)
        if v == 255 and War_CanMoveXY(x + 1, y, flag) == true then
	        num = num + 1
	        steparray[step1].x[num] = x + 1
	        steparray[step1].y[num] = y
	        SetWarMap(x + 1, y, 3, step1)
	        steparray[step1].bushu[num] = steparray[step].bushu[i] - fujinnum(x + 1, y)
      	end
      end
      
      if x - 1 > 0 then
        local v = GetWarMap(x - 1, y, 3)
        if v == 255 and War_CanMoveXY(x - 1, y, flag) == true then
	        num = num + 1
	        steparray[step1].x[num] = x - 1
	        steparray[step1].y[num] = y
	        SetWarMap(x - 1, y, 3, step1)
	        steparray[step1].bushu[num] = steparray[step].bushu[i] - fujinnum(x - 1, y)
	      end
      end
      
      if y + 1 < CC.WarHeight - 1 then
        local v = GetWarMap(x, y + 1, 3)
        if v == 255 and War_CanMoveXY(x, y + 1, flag) == true then
	        num = num + 1
	        steparray[step1].x[num] = x
	        steparray[step1].y[num] = y + 1
	        SetWarMap(x, y + 1, 3, step1)
	        steparray[step1].bushu[num] = steparray[step].bushu[i] - fujinnum(x, y + 1)
	      end
      end
      
      if y - 1 > 0 then
	      local v = GetWarMap(x, y - 1, 3)
	      if v == 255 and War_CanMoveXY(x, y - 1, flag) == true then
		      num = num + 1
		      steparray[step1].x[num] = x
		      steparray[step1].y[num] = y - 1
		      SetWarMap(x, y - 1, 3, step1)
		      steparray[step1].bushu[num] = steparray[step].bushu[i] - fujinnum(x, y - 1)
	    	end
    	end
    end
  end
  if num == 0 then
    return 
  end
  steparray[step1].num = num
  War_FindNextStep(steparray, step1, flag, id)
end
--判断是否能打到敌人
function War_GetCanFightEnemyXY()
  local num, x, y = nil, nil, nil
  num, x, y = War_realjl(WAR.CurID)
  if num == -1 then
    return 
  end
  return x, y
end--移动
function War_MoveMenu()
  if WAR.Person[WAR.CurID]["人物编号"] ~= -1 then
    WAR.ShowHead = 0
    if WAR.Person[WAR.CurID]["移动步数"] <= 0 then
      return 0
    end
    War_CalMoveStep(WAR.CurID, WAR.Person[WAR.CurID]["移动步数"], 0)
    local r = nil
    local x, y = War_SelectMove()
    if x ~= nil then
      War_MovePerson(x, y, 1)
      r = 1
    else
      r = 0
      WAR.ShowHead = 1
      Cls()
    end
    lib.GetKey()
    return r
  else
    local ydd = {}
    local n = 1
    for i = 0, WAR.PersonNum - 1 do
      if WAR.Person[i]["我方"] ~= WAR.Person[WAR.CurID]["我方"] and WAR.Person[i]["死亡"] == false then
        ydd[n] = i
        n = n + 1
      end
    end
    local dx = ydd[math.random(n - 1)]
    local DX = WAR.Person[dx]["坐标X"]
    local DY = WAR.Person[dx]["坐标Y"]
    local YDX = {DX + 1, DX - 1, DX}
    local YDY = {DY + 1, DY - 1, DY}
    local ZX = YDX[math.random(3)]
    local ZY = YDY[math.random(3)]
    if not SceneCanPass(ZX, ZY) or GetWarMap(ZX, ZY, 2) < 0 then
      SetWarMap(WAR.Person[WAR.CurID]["坐标X"], WAR.Person[WAR.CurID]["坐标Y"], 2, -1)
      SetWarMap(WAR.Person[WAR.CurID]["坐标X"], WAR.Person[WAR.CurID]["坐标Y"], 5, -1)
      WAR.Person[WAR.CurID]["坐标X"] = ZX
      WAR.Person[WAR.CurID]["坐标Y"] = ZY
      SetWarMap(WAR.Person[WAR.CurID]["坐标X"], WAR.Person[WAR.CurID]["坐标Y"], 2, WAR.CurID)
      SetWarMap(WAR.Person[WAR.CurID]["坐标X"], WAR.Person[WAR.CurID]["坐标Y"], 5, WAR.Person[WAR.CurID]["贴图"])
    end
  end
  return 1
end--人物移动
function War_MovePerson(x, y, flag)
  local x1 = x
  local y1 = y
  if not flag then
    flag = 0
  end
  local movenum = GetWarMap(x, y, 3)
  local movetable = {}
  for i = movenum, 1, -1 do
    movetable[i] = {}
    movetable[i].x = x
    movetable[i].y = y
    if GetWarMap(x - 1, y, 3) == i - 1 then
      x = x - 1
      movetable[i].direct = 1
    elseif GetWarMap(x + 1, y, 3) == i - 1 then
      x = x + 1
      movetable[i].direct = 2
    elseif GetWarMap(x, y - 1, 3) == i - 1 then
      y = y - 1
      movetable[i].direct = 3
    elseif GetWarMap(x, y + 1, 3) == i - 1 then
      y = y + 1
      movetable[i].direct = 0
    end
  end
  movetable.num = movenum
  movetable.now = 0
  WAR.Person[WAR.CurID].Move = movetable
  if WAR.Person[WAR.CurID]["移动步数"] < movenum then
    movenum = WAR.Person[WAR.CurID]["移动步数"]
    WAR.Person[WAR.CurID]["移动步数"] = 0
  else
    WAR.Person[WAR.CurID]["移动步数"] = WAR.Person[WAR.CurID]["移动步数"] - movenum
  end
  for i = 1, movenum do
    local t1 = lib.GetTime()
    SetWarMap(WAR.Person[WAR.CurID]["坐标X"], WAR.Person[WAR.CurID]["坐标Y"], 2, -1)
    SetWarMap(WAR.Person[WAR.CurID]["坐标X"], WAR.Person[WAR.CurID]["坐标Y"], 5, -1)
    WAR.Person[WAR.CurID]["坐标X"] = movetable[i].x
    WAR.Person[WAR.CurID]["坐标Y"] = movetable[i].y
    WAR.Person[WAR.CurID]["人方向"] = movetable[i].direct
    WAR.Person[WAR.CurID]["贴图"] = WarCalPersonPic(WAR.CurID)
    SetWarMap(WAR.Person[WAR.CurID]["坐标X"], WAR.Person[WAR.CurID]["坐标Y"], 2, WAR.CurID)
    SetWarMap(WAR.Person[WAR.CurID]["坐标X"], WAR.Person[WAR.CurID]["坐标Y"], 5, WAR.Person[WAR.CurID]["贴图"])
    WarDrawMap(0)
    ShowScreen()
    local t2 = lib.GetTime()
    if i < movenum and t2 - t1 < 2 * CC.Frame then
      lib.Delay(2 * CC.Frame - (t2 - t1))
    end
  end
end
---用毒菜单
function War_PoisonMenu()
  WAR.ShowHead = 0
  local r = War_ExecuteMenu(1)
  WAR.ShowHead = 1
  Cls()
  return r
end
--战斗休息
function War_RestMenu()
	if WAR.CurID and WAR.CurID >= 0  then
	  local pid = WAR.Person[WAR.CurID]["人物编号"]
	  if WAR.tmp[1000 + pid] == 1 then
	    return 1
	  end
	  local vv = math.modf(JY.Person[pid]["体力"] / 100 - JY.Person[pid]["受伤程度"] / 50 - JY.Person[pid]["中毒程度"] / 50) + 2
	  if WAR.Person[WAR.CurID]["移动步数"] > 0 then
	    vv = vv + 2
	  end
	  if inteam(pid) then
	    vv = vv + math.random(3)
	  else
	    vv = vv + 6
	  end
	  vv = (vv) / 120
	  local v = 3 + Rnd(3)
	  AddPersonAttrib(pid, "体力", v)
	  if JY.Person[pid]["体力"] > 0 then
	    v = 3 + math.modf(JY.Person[pid]["生命最大值"] * (vv))
	    AddPersonAttrib(pid, "生命", v)
	    v = 3 + math.modf(JY.Person[pid]["内力最大值"] * (vv))
	    AddPersonAttrib(pid, "内力", v)
	  end
	  
	  --高难度，敌人休息会自动蓄力
	  if JY.Thing[202][WZ7] > 1 and not inteam(pid) then
	    if math.modf(JY.Person[pid]["生命最大值"] / 2) < JY.Person[pid]["生命"] then
	      return War_ActupMenu()
	    else
	      return War_DefupMenu()
	    end
	  else
	    return 1
	  end
	end
end--战斗查看状态
function War_StatusMenu()
  WAR.ShowHead = 0
  Menu_Status()
  WAR.ShowHead = 1
  Cls()
end

--战斗物品菜单
function War_ThingMenu()
  WAR.ShowHead = 0
  local thing = {}
  local thingnum = {}
  for i = 0, CC.MyThingNum - 1 do
    thing[i] = -1
    thingnum[i] = 0
  end
  local num = 0
  for i = 0, CC.MyThingNum - 1 do
    local id = JY.Base["物品" .. i + 1]
    if id >= 0 and (JY.Thing[id]["类型"] == 3 or JY.Thing[id]["类型"] == 4) then
      thing[num] = id
      thingnum[num] = JY.Base["物品数量" .. i + 1]
      num = num + 1
    end
  end
  local r = SelectThing(thing, thingnum)
  Cls()
  local rr = 0
  if r >= 0 and UseThing(r) == 1 then
    rr = 1
  end
  WAR.ShowHead = 1
  Cls()
  return rr
end

function War_UseThing(tid)
	
	
end

--自动战斗判断是否能医疗
function War_ThinkDoctor()
  local pid = WAR.Person[WAR.CurID]["人物编号"]
  if JY.Person[pid]["体力"] < 50 or JY.Person[pid]["医疗能力"] < 20 then
    return -1
  end
  if JY.Person[pid]["医疗能力"] + 20 < JY.Person[pid]["受伤程度"] then
    return -1
  end
  local rate = -1
  local v = JY.Person[pid]["生命最大值"] - JY.Person[pid]["生命"]
  if JY.Person[pid]["医疗能力"] < v / 4 then
    rate = 30
  elseif JY.Person[pid]["医疗能力"] < v / 3 then
      rate = 50
  elseif JY.Person[pid]["医疗能力"] < v / 2 then
      rate = 70
  else
    rate = 90
  end
  if Rnd(100) < rate then
    return 5
  end
  return -1
end--能否吃药增加参数
--flag=2 生命，3内力；4体力  6 解毒
function War_ThinkDrug(flag)
  local pid = WAR.Person[WAR.CurID]["人物编号"]
  local str = nil
  local r = -1
  if flag == 2 then
    str = "加生命"
  elseif flag == 3 then
    str = "加内力"
  elseif flag == 4 then
    str = "加体力"
  elseif flag == 6 then
    str = "加中毒解毒"
  else
    return r
  end
  local function Get_Add(thingid)
    if flag == 6 then
      return -JY.Thing[thingid][str]
    else
      return JY.Thing[thingid][str]
    end
  end
  
  --身上是否有药品
  if inteam(pid) and WAR.Person[WAR.CurID]["我方"] == true then
    for i = 1, CC.MyThingNum do
      local thingid = JY.Base["物品" .. i]
      if thingid >= 0 and JY.Thing[thingid]["类型"] == 3 and Get_Add(thingid) > 0 then
        r = flag
        break;
      end
    end
  else
    for i = 1, 4 do
      local thingid = JY.Person[pid]["携带物品" .. i]
      if thingid >= 0 and JY.Thing[thingid]["类型"] == 3 and Get_Add(thingid) > 0 then
        r = flag
        break;
      end
    end
  end
  return r
end--使用暗器
function War_UseAnqi(id)
  return War_ExecuteMenu(4, id)
end

function WarLoad(warid)
  WarSetGlobal()
  local data = Byte.create(CC.WarDataSize)
  Byte.loadfile(data, CC.WarFile, warid * CC.WarDataSize, CC.WarDataSize)
  LoadData(WAR.Data, CC.WarData_S, data)
  WAR.ZDDH = warid
end
--加载战斗地图
function WarLoadMap(mapid)
  lib.Debug(string.format("load war map %d", mapid))
  lib.LoadWarMap(CC.WarMapFile[1], CC.WarMapFile[2], mapid, 7, CC.WarWidth, CC.WarHeight)
end

function GetWarMap(x, y, level)
  if x > 63 or x < 0 or y > 63 or y < 0 then
    return 
  end
  return lib.GetWarMap(x, y, level)
end

function SetWarMap(x, y, level, v)
  if x > 63 or x < 0 or y > 63 or y < 0 then
    return 
  end
  lib.SetWarMap(x, y, level, v)
end

function CleanWarMap(level, v)
  lib.CleanWarMap(level, v)
end
--设置人物贴图
function WarSetPerson()
  CleanWarMap(2, -1)
  CleanWarMap(5, -1)
  for i = 0, WAR.PersonNum - 1 do
    if WAR.Person[i]["死亡"] == false then
      SetWarMap(WAR.Person[i]["坐标X"], WAR.Person[i]["坐标Y"], 2, i)
      SetWarMap(WAR.Person[i]["坐标X"], WAR.Person[i]["坐标Y"], 5, WAR.Person[i]["贴图"])
    end
  end
end


--显示武功动画，人物受伤动画，音效等
function War_ShowFight(pid, wugong, wugongtype, level, x, y, eft, ZHEN_ID)
  if not ZHEN_ID then
    ZHEN_ID = -1
  end
  
  if wugongtype > 4 then
		wugongtype = math.random(4);
	end
  
  local x0 = WAR.Person[WAR.CurID]["坐标X"]
  local y0 = WAR.Person[WAR.CurID]["坐标Y"]
  
  --令狐冲，扫地老僧  随机动画
  if (wugong == 47 and pid ~= 592) then
    eft = math.random(100)
  end
  
	if pid == 592 then
		if WAR.L_DGQB_X < 3 then
			eft = 24
		elseif WAR.L_DGQB_X < 5 then
			eft = 48
		elseif WAR.L_DGQB_X < 7 then
			eft = 10
		elseif WAR.L_DGQB_X < 9 then
			eft = 46
		elseif WAR.L_DGQB_X < 10 then
			eft = 62
		else
			eft = 84
		end
	end
	
	local ex, ey = -1, -1;
	
	--测试动画
	--eft = 110;
	
	if pid == 0 and GetS(53, 0, 4, 5) == 1 and JLSD(0,30,pid)  then
		eft = 110;
	end
	
	--指定XY，那么只显示在一个点显示动画
	if eft == 110 then
		ex, ey = x, y;
	end
	

	
	--加载EFT
	if WAR.EFT[eft] == nil then
		lib.PicLoadFile(string.format(CC.EffectFile[1],eft), string.format(CC.EffectFile[2],eft), 70+WAR.EFTNUM);
		WAR.EFT[eft] = 70+WAR.EFTNUM;
		WAR.EFTNUM = WAR.EFTNUM + 1;
		if WAR.EFTNUM > 20 then
			WAR.EFTNUM = 0;
		end
	end
	
	if WAR.Person[WAR.CurID]["特效动画"] ~= -1 then
		local txdh = WAR.Person[WAR.CurID]["特效动画"];
		if WAR.EFT[txdh] == nil then
			lib.PicLoadFile(string.format(CC.EffectFile[1],txdh), string.format(CC.EffectFile[2],txdh), 70+WAR.EFTNUM);
			WAR.EFT[txdh] = 70+WAR.EFTNUM;
			WAR.EFTNUM = WAR.EFTNUM + 1;
			if WAR.EFTNUM > 20 then
				WAR.EFTNUM = 0;
			end
		end
	end
  
  
  if wugong == 49 then
	wugongtype = 1
  end
  
  --合击动画
  local ZHEN_pid, ZHEN_type, ZHEN_startframe, ZHEN_fightframe = nil, nil, nil, nil
  if ZHEN_ID >= 0 then
    ZHEN_pid = WAR.Person[ZHEN_ID]["人物编号"]
    ZHEN_type = wugongtype
    ZHEN_startframe = 0
    ZHEN_fightframe = 0
  end
  
  local fightdelay, fightframe, sounddelay = nil, nil, nil
  if wugongtype >= 0 then
    fightdelay = JY.Person[pid]["出招动画延迟" .. wugongtype + 1]
    fightframe = JY.Person[pid]["出招动画帧数" .. wugongtype + 1]
    sounddelay = JY.Person[pid]["武功音效延迟" .. wugongtype + 1]
  else
    fightdelay = 0
    fightframe = -1
    sounddelay = -1
  end
  
  if fightdelay == 0 or fightframe == 0 then
    for i = 1, 5 do
      if JY.Person[pid]["出招动画帧数" .. i] ~= 0 then
        fightdelay = JY.Person[pid]["出招动画延迟" .. i]
        fightframe = JY.Person[pid]["出招动画帧数" .. i]
        sounddelay = JY.Person[pid]["武功音效延迟" .. i]
        wugongtype = i - 1
      end
    end
  end
  
  if ZHEN_ID >= 0 then
    if JY.Person[ZHEN_pid]["出招动画帧数" .. ZHEN_type + 1] == 0 then
      for i = 1, 5 do
        if JY.Person[ZHEN_pid]["出招动画帧数" .. i] ~= 0 then
          ZHEN_type = i - 1
          ZHEN_fightframe = JY.Person[ZHEN_pid]["出招动画帧数" .. i]
        end
      end
    else
    	ZHEN_fightframe = JY.Person[ZHEN_pid]["出招动画帧数" .. ZHEN_type + 1]
    end
  end
  
  
  local framenum = fightdelay + CC.Effect[eft]
  local startframe = 0
  if wugongtype >= 0 then
    for i = 0, wugongtype - 1 do
      startframe = startframe + 4 * JY.Person[pid]["出招动画帧数" .. i + 1]
    end
  end
  if ZHEN_ID >= 0 and ZHEN_type >= 0 then
    for i = 0, ZHEN_type - 1 do
      ZHEN_startframe = ZHEN_startframe + 4 * JY.Person[ZHEN_pid]["出招动画帧数" .. i + 1]
    end
  end
  
  
  local fastdraw = nil
  
  --[[
  if CONFIG.FastShowScreen == 0 or CC.AutoWarShowHead == 1 then
    fastdraw = 0
  else
    fastdraw = 1
  end
  ]]
  
  
  local starteft = 0

  WAR.Person[WAR.CurID]["贴图类型"] = 0
  WAR.Person[WAR.CurID]["贴图"] = WarCalPersonPic(WAR.CurID)
  if ZHEN_ID >= 0 then
    WAR.Person[ZHEN_ID]["贴图类型"] = 0
    WAR.Person[ZHEN_ID]["贴图"] = WarCalPersonPic(ZHEN_ID)
  end  
  
  
  local oldpic = WAR.Person[WAR.CurID]["贴图"] / 2		--当前贴图的位置
  local oldpic_type = 0
  local oldeft = -1
  local kfname = JY.Wugong[wugong]["名称"]
  local showsize = CC.FontBig
  local showx = CC.ScreenW / 2 - showsize * string.len(kfname) / 4
  local hb = GetS(JY.SubScene, x0, y0, 4)

  
  --显示武功，放到特效文字0
  if wugong ~= 0 then
    if WAR.LHQ_BNZ == 1 then     --般若掌
      kfname = "般若掌"
    end
    if WAR.JGZ_DMZ == 1 then     --达摩掌
      kfname = "达摩掌"
    end
  end
  
  if ZHEN_ID >= 0 then          --合击
  	kfname = "双人合击·"..kfname
  end
  
  --特效文字0和武功名称显示
	if wugong > 0 then				--使用武功时才显示
	  for i=5, 10 do
		  if WAR.Person[WAR.CurID]["特效文字0"] ~= nil then
		  	local n, strs = Split(WAR.Person[WAR.CurID]["特效文字0"], "·");
		  	local len = string.len(WAR.Person[WAR.CurID]["特效文字0"]);
		  	local color = RGB(255,40,10);
		  	local off = 0;
		  	for j=1, n do
		  		if strs[j] == "连击" then
		  			color = M_DeepSkyBlue;
		  		elseif strs[j] == "左右互搏" then
			  		color = M_DarkOrange
		  		else
		  			color = RGB(255,40,10);
		  		end
		  		if j > 1 then
		  			strs[j] = "·"..strs[j];
		  		end
		  		KungfuString(strs[j], CC.ScreenW / 2 - (n-1)*len*(CC.DefaultFont+i/2)/8 + off, CC.ScreenH / 4  - hb     , color, CC.DefaultFont+i/2, CC.FontName, 0)
		  		off = off + string.len(strs[j])*(CC.DefaultFont+i/2)/4 + (CC.DefaultFont+i/2)*3/2;
		  	end
			end
			--武功显示
			KungfuString(kfname, CC.ScreenW / 2 -#kfname/2, CC.ScreenH / 3 - hb  , C_GOLD, CC.FontBig+i, CC.FontName, 0)
		  ShowScreen()
		  
		  lib.Delay(2)
		  if i == 10 then
			  lib.Delay(300)
		  end
		  Cls()
		end
	end
  
  --显示攻击动画
  for i = 0, framenum - 1 do
    local tstart = lib.GetTime()
    local mytype = nil
    if fightframe > 0 then
      WAR.Person[WAR.CurID]["贴图类型"] = 1
      mytype = 4 + WAR.CurID
      if i < fightframe then
        WAR.Person[WAR.CurID]["贴图"] = (startframe + WAR.Person[WAR.CurID]["人方向"] * fightframe + i) * 2
      end
    else
      WAR.Person[WAR.CurID]["贴图类型"] = 0
      WAR.Person[WAR.CurID]["贴图"] = WarCalPersonPic(WAR.CurID)
      mytype = 0
    end
    
    if ZHEN_ID >= 0 then
      if ZHEN_fightframe > 0 then
        WAR.Person[ZHEN_ID]["贴图类型"] = 1
        if i < ZHEN_fightframe and i < framenum - 1 then
          WAR.Person[ZHEN_ID]["贴图"] = (ZHEN_startframe + WAR.Person[ZHEN_ID]["人方向"] * ZHEN_fightframe + i) * 2
        else
          WAR.Person[ZHEN_ID]["贴图"] = WarCalPersonPic(ZHEN_ID)
        end
      else
        WAR.Person[ZHEN_ID]["贴图类型"] = 0
        WAR.Person[ZHEN_ID]["贴图"] = WarCalPersonPic(ZHEN_ID)
      end
      SetWarMap(WAR.Person[ZHEN_ID]["坐标X"], WAR.Person[ZHEN_ID]["坐标Y"], 5, WAR.Person[ZHEN_ID]["贴图"])
    end
    
    if i == sounddelay then
      PlayWavAtk(JY.Wugong[wugong]["出招音效"])		--
    end
    
    if i == fightdelay then
      PlayWavE(eft)
    end
    
    if i == 1 and WAR.SSFwav == 1 then
      WAR.SSFwav = 0
    end
    if i == 1 and WAR.LMSJwav == 1 then
      PlayWavAtk(31)
      WAR.LMSJwav = 0
    end
    
    local pic = WAR.Person[WAR.CurID]["贴图"] / 2
    if fastdraw == 1 then
      local rr = ClipRect(Cal_PicClip(0, 0, oldpic, oldpic_type, 0, 0, pic, mytype))
      if rr ~= nil then
        lib.SetClip(rr.x1, rr.y1, rr.x2, rr.y2)
      end
    else
      lib.SetClip(0, 0, 0, 0)
    end
    oldpic = pic
    oldpic_type = mytype
    
    
    if i < fightdelay then
      WarDrawMap(4, pic * 2, mytype, -1)
  		
      if i == 1 and WAR.Person[WAR.CurID]["特效动画"] ~= -1 then
        local theeft = WAR.Person[WAR.CurID]["特效动画"]
        local sf = 0
		--[[
        for ii = 0, theeft - 1 do
          sf = sf + CC.Effect[ii]
        end
		]]
        local ssid = lib.SaveSur(CC.ScreenW/2 - 5 * CC.XScale, CC.ScreenH/2 - hb - 18 * CC.YScale, CC.ScreenW/2 + 5 * CC.XScale, CC.ScreenH/2 - hb + 5 * CC.YScale)
       
        for ii = 1, CC.Effect[theeft] do
          --lib.PicLoadCache(3, (sf+ii) * 2, CC.ScreenW/2 , CC.ScreenH/2  - hb, 2, 192)
          lib.PicLoadCache(WAR.EFT[theeft], (sf+ii) * 2, CC.ScreenW/2 , CC.ScreenH/2  - hb, 2, 192)
          
          if WAR.Person[WAR.CurID]["特效文字1"] ~= nil then
            KungfuString(WAR.Person[WAR.CurID]["特效文字1"], CC.ScreenW / 2, CC.ScreenH / 2 - hb, C_RED, CC.Fontsmall, CC.FontName, 3)
          end
          if WAR.Person[WAR.CurID]["特效文字2"] ~= nil then
            KungfuString(WAR.Person[WAR.CurID]["特效文字2"], CC.ScreenW / 2, CC.ScreenH / 2 - hb, C_GOLD, CC.Fontsmall, CC.FontName, 2)
          end
          if WAR.Person[WAR.CurID]["特效文字3"] ~= nil then
            KungfuString(WAR.Person[WAR.CurID]["特效文字3"], CC.ScreenW / 2, CC.ScreenH / 2 - hb, C_WHITE, CC.Fontsmall, CC.FontName, 1)
          end
          ShowScreen()
          lib.Delay(30)
          lib.LoadSur(ssid, CC.ScreenW/2 - 5 * CC.XScale, CC.ScreenH/2 - hb - 18 * CC.YScale)
		  
        end
        lib.FreeSur(ssid)
        WAR.Person[WAR.CurID]["特效动画"] = -1
      else
        if WAR.Person[WAR.CurID]["特效文字1"] ~= nil or WAR.Person[WAR.CurID]["特效文字2"] ~= nil or WAR.Person[WAR.CurID]["特效文字3"] ~= nil then
          KungfuString(WAR.Person[WAR.CurID]["特效文字1"], CC.ScreenW / 2, CC.ScreenH / 2 - hb, C_RED, CC.Fontsmall, CC.FontName, 3)
          KungfuString(WAR.Person[WAR.CurID]["特效文字2"], CC.ScreenW / 2, CC.ScreenH / 2 - hb, C_GOLD, CC.Fontsmall, CC.FontName, 2)
          KungfuString(WAR.Person[WAR.CurID]["特效文字3"], CC.ScreenW / 2, CC.ScreenH / 2 - hb, C_WHITE, CC.Fontsmall, CC.FontName, 1)
          lib.Delay(30)
        end
      end
    else
      starteft = starteft + 1
      
      if fastdraw == 1 then
        local clip1 = {}
        clip1 = Cal_PicClip(WAR.EffectXY[1][1] - x0, WAR.EffectXY[1][2] - y0, oldeft, 3, WAR.EffectXY[1][1] - x0, WAR.EffectXY[1][2] - y0, starteft, 3)
        local clip2 = {}
        clip2 = Cal_PicClip(WAR.EffectXY[2][1] - x0, WAR.EffectXY[2][2] - y0, oldeft, 3, WAR.EffectXY[2][1] - x0, WAR.EffectXY[2][2] - y0, starteft, 3)
        local clip = ClipRect(MergeRect(clip1, clip2))
        if clip ~= nil then
          local area = (clip.x2 - clip.x1) * (clip.y2 - clip.y1)
          if area < CC.ScreenW * CC.ScreenH / 2 then
            WarDrawMap(4, pic * 2, mytype, (starteft) * 2,nil, WAR.EFT[eft],ex,ey)
            lib.SetClip(clip.x1, clip.y1, clip.x2, clip.y2)
            WarDrawMap(4, pic * 2, mytype, (starteft) * 2,nil, WAR.EFT[eft],ex,ey)
          else
            lib.SetClip(0, 0, CC.ScreenW, CC.ScreenH)
            WarDrawMap(4, pic * 2, mytype, (starteft) * 2,nil, WAR.EFT[eft],ex,ey)
          end
        else
          WarDrawMap(4, pic * 2, mytype, (starteft) * 2, nil, WAR.EFT[eft],ex,ey)
        end
      else
        lib.SetClip(0, 0, 0, 0)
        
        --if wugong == 
        WarDrawMap(4, pic * 2, mytype, (starteft) * 2, nil,WAR.EFT[eft],ex,ey)
      end
      oldeft = starteft
      
      local estart = lib.GetTime()
      if CC.Frame - (estart - tstart) > 0 then
      	lib.Delay(CC.Frame - (estart - tstart));
      end
    end

    ShowScreen(fastdraw)
    lib.SetClip(0, 0, 0, 0)
    local tend = lib.GetTime()
    if CC.Frame - (tend - tstart) > 0 then
    	lib.Delay(CC.Frame - (tend - tstart));
    end
	lib.GetKey();
  end
  
  lib.SetClip(0, 0, 0, 0)
  WAR.Person[WAR.CurID]["贴图类型"] = 0
  WAR.Person[WAR.CurID]["贴图"] = WarCalPersonPic(WAR.CurID)
  
  --宗师，击退显示改变贴图位置
  if pid == 0 and GetS(53, 0, 2, 5) == 3 then
	  for i = 0, WAR.PersonNum - 1 do
	  	if WAR.tmp[6000+i] ~= nil then
	  		local v = GetWarMap(WAR.Person[i]["坐标X"], WAR.Person[i]["坐标Y"], 4);
	  		SetWarMap(WAR.Person[i]["坐标X"], WAR.Person[i]["坐标Y"], 4, -1)
	  		WAR.Person[i]["坐标X"] = WAR.tmp[6000+i][1]
	  		WAR.Person[i]["坐标Y"] = WAR.tmp[6000+i][2]
	  		SetWarMap(WAR.Person[i]["坐标X"], WAR.Person[i]["坐标Y"], 4, v)
	  	end
	  	WAR.tmp[6000+i] = nil;
	  end
  end
  
  WarSetPerson()
  WarDrawMap(0)
  ShowScreen()
  lib.Delay(200)
  WarDrawMap(2)
  ShowScreen()
  lib.Delay(200)
  WarDrawMap(0)
  ShowScreen()
  
  --计算攻击到的人
  local HitXY = {}
  local HitXYNum = 0
  local hnum = 10;		--HitXY的长度个数
  for i = 0, WAR.PersonNum - 1 do
    local x1 = WAR.Person[i]["坐标X"]
    local y1 = WAR.Person[i]["坐标Y"]
    if WAR.Person[i]["死亡"] == false and GetWarMap(x1, y1, 4) > 1 then
      SetWarMap(x1, y1, 4, 1)
      --local n = WAR.Person[i]["点数"]
      local hp = WAR.Person[i]["生命点数"];
      local mp = WAR.Person[i]["内力点数"];
      local tl = WAR.Person[i]["体力点数"];
      local ed = WAR.Person[i]["中毒点数"];
      local dd = WAR.Person[i]["解毒点数"];
      local ns = WAR.Person[i]["内伤点数"];
      
      HitXY[HitXYNum] = {x1, y1, nil, nil, nil, nil, nil, nil, nil, nil, nil};		--x, y, 生命, 内力, 体力, 封穴, 流血, 中毒, 解毒, 内伤

			if hp ~= nil then
	      if hp == 0 then			--显示受到的生命
	      	HitXY[HitXYNum][3] = "miss";
	      elseif hp > 0 then
	      	HitXY[HitXYNum][3] = "+"..hp;
	      else
	      	HitXY[HitXYNum][3] = ""..hp;
	      end
	    end
      
      
      if mp ~= nil then			--显示内力变化
      	if mp > 0 then
      		HitXY[HitXYNum][4] = "+"..mp;
      	elseif mp ==  0 then
      		HitXY[HitXYNum][4] = nil;			--变化为0时不显示
      	else
      		HitXY[HitXYNum][4] = ""..mp;
      	end
      end
      
      if tl ~= nil then			--显示体力变化
      	if tl > 0 then
      		HitXY[HitXYNum][5] = "体+"..tl;
      	elseif tl == 0 then
      		HitXY[HitXYNum][5] = nil;
      	else
      		HitXY[HitXYNum][5] = "体"..tl;
      	end
      end
      
      if WAR.FXXS[WAR.Person[i]["人物编号"]] == 1 then			--显示是否封穴
       	HitXY[HitXYNum][6] = "封穴";
       	WAR.FXXS[WAR.Person[i]["人物编号"]] = 0
      end
      
      if WAR.LXXS[WAR.Person[i]["人物编号"]] == 1 then		--显示是否被流血
      	HitXY[HitXYNum][7] = "流血"
        WAR.LXXS[WAR.Person[i]["人物编号"]] = 0
      end
      
      
      if ed ~= nil then				--显示中毒
      	if ed == 0 then
      		HitXY[HitXYNum][8] = nil;
      	else
      		HitXY[HitXYNum][8] = ""..ed;
      	end
      end
      
      if dd ~= nil then			--显示解毒
      	if dd  == 0 then
      		HitXY[HitXYNum][9] = nil;
      	else
      		HitXY[HitXYNum][9] = ""..dd;
      	end
      end
      
      if ns ~= nil then		--显示内伤
      	if ns == 0 then
      		HitXY[HitXYNum][10] = nil;
      	elseif ns > 0 then
      		HitXY[HitXYNum][10] = ns;
      	else
      		--HitXY[HitXYNum][10] = "内伤↓ "
      	end
      end
      
      HitXYNum = HitXYNum + 1
    end
    
    --偷东西，斗转 - -
    if WAR.TD > -1 then
      if WAR.TD == 118 then
        say("１哈哈哈－－－，想偷偶的斗转星移？没门儿！要想得斗转下次就乖乖跟偶合作吧！", 51)
      else
        instruct_2(WAR.TD, 1)
      end
      WAR.TD = -1
    end
  end
  
  
  local TP = 0
  local TPXS = {}
  for i = 0, WAR.PersonNum - 1 do
    if WAR.Person[i]["特效动画"] ~= -1 then
      TP = TP + 1
      TPXS[i] = TP
    end
  end
  if TP ~= 0 then
    TP = math.modf(20 / (TP))
  end
  
  local minx = 0;
  local maxx = CC.ScreenW;
  local miny = 0;
  local maxy = CC.ScreenH;
  --[[
  if ex < 0 and ey < 0 then
	  for i = 0, WAR.PersonNum - 1 do
	  	if WAR.Person[i]["死亡"] == false  then
	  		local dx = WAR.Person[i]["坐标X"] - x
	      local dy = WAR.Person[i]["坐标Y"] - y
	      local rx = CC.XScale * (dx - dy) + CC.ScreenW / 2
	      local ry = CC.YScale * (dx + dy) + CC.ScreenH / 2 - hb
	      
	      if rx > 0 and rx < minx then
	      	minx = rx;
	      end
	      if rx > 0 and rx > maxx and rx <= CC.ScreenW then
	      	maxx = rx;
	      end
	      
	      if ry > 0 and ry < miny then
	      	miny = ry;
	      end
	      if ry > 0 and ry > maxy and ry <= CC.ScreenH then
	      	maxy = ry;
	      end
	  	end
	  end
	else
		minx = 0;
	  maxx = CC.ScreenW;
	  miny = 0;
	  maxy = CC.ScreenH;
  end
 ]]
 
	--minx = limitX(minx - 10 * CC.XScale, 0, CC.ScreenW);
  --maxx = limitX(maxx + 10 * CC.XScale, 0, CC.ScreenW);
  --miny = limitX(miny - 18 * CC.YScale, 0, CC.ScreenH);
 -- maxy = limitX(maxy + 5 * CC.YScale, 0, CC.ScreenH);
  
  local sssid = lib.SaveSur(minx, miny, maxx, maxy)
  --显示特效文字
  for ii = 1, 20 do
    local yanshi = false
    local yanshi2 = false		--无动画时的延迟
    for i = 0, WAR.PersonNum - 1 do
    	if WAR.Person[i]["死亡"] == false then
	      local theeft = WAR.Person[i]["特效动画"]
	      if theeft ~= -1 and ii < CC.Effect[theeft] then
			if WAR.EFT[theeft] == nil then
				lib.PicLoadFile(string.format(CC.EffectFile[1],theeft), string.format(CC.EffectFile[2],theeft), 70+WAR.EFTNUM);
				WAR.EFT[theeft] = 70+WAR.EFTNUM;
				WAR.EFTNUM = WAR.EFTNUM + 1;
				if WAR.EFTNUM > 20 then
					WAR.EFTNUM = 0;
				end
			end
			
	        local dx = WAR.Person[i]["坐标X"] - x0
	        local dy = WAR.Person[i]["坐标Y"] - y0
	        local rx = CC.XScale * (dx - dy) + CC.ScreenW / 2
	        local ry = CC.YScale * (dx + dy) + CC.ScreenH / 2
	        
	        local hb = GetS(JY.SubScene, dx + x0, dy + y0, 4)

	        ry = ry - hb
			starteft = ii
			if starteft <= CC.Effect[theeft] then
				lib.PicLoadCache(WAR.EFT[theeft], (starteft) * 2, rx, ry, 2, 192)
			end
	        if ii < TPXS[i] * TP and (TPXS[i] - 1) * TP < ii then	
		        KungfuString(WAR.Person[i]["特效文字1"], rx, ry, C_WHITE, CC.Fontsmall, CC.FontName, 1)
		        KungfuString(WAR.Person[i]["特效文字2"], rx, ry, C_GOLD, CC.Fontsmall, CC.FontName, 2)
		        KungfuString(WAR.Person[i]["特效文字3"], rx, ry, C_RED, CC.Fontsmall, CC.FontName, 3)
		        KungfuString(WAR.Person[i]["特效文字0"], rx, ry, C_WHITE, CC.Fontsmall, CC.FontName, 4)
		        yanshi = true
	      	end
	      else
	      	--蓝烟清： 修正无动画时不显示文字的BUG
	      	if i~= WAR.CurID and theeft == -1 and ((WAR.Person[i]["特效文字1"] ~= nil and WAR.Person[i]["特效文字1"] ~= "  ") or (WAR.Person[i]["特效文字2"] ~= nil and WAR.Person[i]["特效文字2"] ~= "  ")  or (WAR.Person[i]["特效文字3"] ~= nil and WAR.Person[i]["特效文字3"] ~= "  ") ) then
	          local dx = WAR.Person[i]["坐标X"] - x0
	        	local dy = WAR.Person[i]["坐标Y"] - y0
	        	local rx = CC.XScale * (dx - dy) + CC.ScreenW / 2
	        	local ry = CC.YScale * (dx + dy) + CC.ScreenH / 2
		        local hb = GetS(JY.SubScene, dx + x0, dy + y0, 4)

		        ry = ry - hb
		        
	          KungfuString(WAR.Person[i]["特效文字1"], rx, ry, C_WHITE, CC.Fontsmall, CC.FontName, 1)
		        KungfuString(WAR.Person[i]["特效文字2"], rx, ry, C_GOLD, CC.Fontsmall, CC.FontName, 2)
		        KungfuString(WAR.Person[i]["特效文字3"], rx, ry, C_RED, CC.Fontsmall, CC.FontName, 3)
		        KungfuString(WAR.Person[i]["特效文字0"], rx, ry, C_WHITE, CC.Fontsmall, CC.FontName, 4)
	          yanshi2 = true
		      end
	      end
	    end
    end
    if yanshi then
      lib.ShowSurface(0)
      lib.LoadSur(sssid, minx, miny)
      lib.Delay(30)
    elseif yanshi2 then
      lib.ShowSurface(0)
      lib.LoadSur(sssid, minx, miny)
      lib.Delay(1)
    end
  end
  lib.FreeSur(sssid)
  
  
  --显示受伤点数
  if HitXYNum > 0 then
    local clips = {}
    for i = 0, HitXYNum - 1 do
      local dx = HitXY[i][1] - x0
      local dy = HitXY[i][2] - y0
      local hb = GetS(JY.SubScene, HitXY[i][1], HitXY[i][2], 4)		--点数效果存在战场的第四层数据
      

      
      local ll = 4;
      for y=3, hnum do
      	if HitXY[i][y] ~= nil then
      		ll = string.len(HitXY[i][y]);
      		break;
      	end
      end
      local w = ll * CC.DefaultFont / 2 + 1
      clips[i] = {x1 = CC.XScale * (dx - dy) + CC.ScreenW / 2, y1 = CC.YScale * (dx + dy) + CC.ScreenH / 2 - hb, x2 = CC.XScale * (dx - dy) + CC.ScreenW / 2 + w, y2 = CC.YScale * (dx + dy) + CC.ScreenH / 2 + CC.DefaultFont + 1}
    end
    
    local clip = clips[0]
    for i = 1, HitXYNum - 1 do
      clip = MergeRect(clip, clips[i])
    end
    
    local area = (clip.x2 - clip.x1) * (clip.y2 - clip.y1)		--绘画的范围
    local surid = lib.SaveSur(minx, miny, maxx, maxy)		--绘画句柄
    
    --显示点数
    for y = 3, hnum-1 do
    	local flag = false;
      for i = 5, 15 do
        local tstart = lib.GetTime()
        local y_off = i * 2 + CC.DefaultFont + CC.RowPixel
        
        
        if fastdraw == 1 and area < CC.ScreenW * CC.ScreenH / 2 then
          local tmpclip = {x1 = clip.x1, y1 = clip.y1 - y_off, x2 = clip.x2, y2 = clip.y2 - y_off}
          tmpclip = ClipRect(tmpclip)
          if tmpclip ~= nil then
            lib.SetClip(tmpclip.x1, tmpclip.y1, tmpclip.x2, tmpclip.y2)
            WarDrawMap(0)
            for j = 0, HitXYNum - 1 do
            	if HitXY[j][y] ~= nil then
            		local c = y - 1;
            		if y == 3 and string.sub(HitXY[j][y],1,1) == "-" then
	          			local cr = 250;
	          			local cg = 250;
	          			local cb = 30;
	          			if HitXY[j][10] ~= nil and HitXY[j][10] > 0 then
	          				cg = cg - HitXY[j][10]

	          			end
	          			DrawString(clips[j].x1 - string.len(HitXY[j][y])*CC.DefaultFont/4, clips[j].y1 - y_off, HitXY[j][y], RGB(cr, cg, cb), CC.DefaultFont)
	          		else
	          			DrawString(clips[j].x1 - string.len(HitXY[j][y])*CC.DefaultFont/4, clips[j].y1 - y_off, HitXY[j][y], WAR.L_EffectColor[c], CC.DefaultFont)
	          		end
            		flag = true;
            	end 
            end
          end
        else
          lib.SetClip(0, 0, CC.ScreenW, CC.ScreenH)
          lib.LoadSur(surid, minx, miny)
          for j = 0, HitXYNum - 1 do
          	if HitXY[j][y] ~= nil then   		
          		local c = y - 1;
          		if y == 3 and string.sub(HitXY[j][y],1,1) == "-" then
          			local cr = 250;
          			local cg = 250;
          			local cb = 30;
          			if HitXY[j][10] ~= nil then
          				cg = cg - HitXY[j][10]
          			end
          			DrawString(clips[j].x1 - string.len(HitXY[j][y])*CC.DefaultFont/4, clips[j].y1 - y_off, HitXY[j][y], RGB(cr, cg, cb), CC.DefaultFont)
          		else
          			DrawString(clips[j].x1 - string.len(HitXY[j][y])*CC.DefaultFont/4, clips[j].y1 - y_off, HitXY[j][y], WAR.L_EffectColor[c], CC.DefaultFont)
          		end
          		
          		flag = true;
          	end
          end
        end
        if flag then
	        ShowScreen(1)
	        lib.SetClip(0, 0, 0, 0)
	        local tend = lib.GetTime()
	        if tend - tstart < CC.Frame then
	          lib.Delay(CC.Frame - (tend - tstart))
	        end
	      end
      end
    end
    lib.FreeSur(surid)
  end
  

  --清除点数
  for i = 0, HitXYNum - 1 do
    local id = GetWarMap(HitXY[i][1], HitXY[i][2], 2);
    WAR.Person[id]["生命点数"] = nil;
    WAR.Person[id]["内力点数"] = nil;
    WAR.Person[id]["体力点数"] = nil;
    WAR.Person[id]["中毒点数"] = nil;
    WAR.Person[id]["解毒点数"] = nil;
    WAR.Person[id]["内伤点数"] = nil;
  end
  
  --清除特效文字
  for i = 0, WAR.PersonNum - 1 do
    WAR.Person[i]["特效动画"] = -1
    WAR.Person[i]["特效文字0"] = nil
    WAR.Person[i]["特效文字1"] = nil
    WAR.Person[i]["特效文字2"] = nil
    WAR.Person[i]["特效文字3"] = nil

  end
  lib.SetClip(0, 0, 0, 0)
  WarDrawMap(0)
  ShowScreen()
end


---执行医疗，解毒用毒暗器的子函数，自动医疗也可调用
function War_ExecuteMenu_Sub(x1, y1, flag, thingid)
  local pid = WAR.Person[WAR.CurID]["人物编号"]
  local x0 = WAR.Person[WAR.CurID]["坐标X"]
  local y0 = WAR.Person[WAR.CurID]["坐标Y"]
  CleanWarMap(4, 0)
  WAR.Person[WAR.CurID]["人方向"] = War_Direct(x0, y0, x1, y1)
  SetWarMap(x1, y1, 4, 1)
  local emeny = GetWarMap(x1, y1, 2)
  if emeny >= 0 then
	  if flag == 1 and WAR.Person[WAR.CurID]["我方"] ~= WAR.Person[emeny]["我方"] then
	    WAR.Person[emeny]["中毒点数"] = War_PoisonHurt(pid, WAR.Person[emeny]["人物编号"])
	    SetWarMap(x1, y1, 4, 5)
	    WAR.Effect = 5
	  elseif flag == 2 and WAR.Person[WAR.CurID]["我方"] == WAR.Person[emeny]["我方"] then
	    WAR.Person[emeny]["解毒点数"] = ExecDecPoison(pid, WAR.Person[emeny]["人物编号"])
	    SetWarMap(x1, y1, 4, 6)
	    WAR.Effect = 6
	  elseif flag == 3 then
	    if WAR.Person[WAR.CurID]["人物编号"] == 0 and GetS(4, 5, 5, 5) == 7 then
	      
	    elseif WAR.Person[WAR.CurID]["我方"] == WAR.Person[emeny]["我方"] then
	      WAR.Person[emeny]["生命点数"] = ExecDoctor(pid, WAR.Person[emeny]["人物编号"])
	      SetWarMap(x1, y1, 4, 4)
	      WAR.Effect = 4
	    end
	  elseif flag == 4 and WAR.Person[WAR.CurID]["我方"] ~= WAR.Person[emeny]["我方"] then
	    WAR.Person[emeny]["生命点数"] = War_AnqiHurt(pid, WAR.Person[emeny]["人物编号"], thingid)
	    SetWarMap(x1, y1, 4, 2)
	    WAR.Effect = 2
	  end
  end
  --主角医生方阵医疗
  if flag == 3 and WAR.Person[WAR.CurID]["人物编号"] == 0 and GetS(4, 5, 5, 5) == 7 then
    for ex = x1 - 3, x1 + 3 do
      for ey = y1 - 3, y1 + 3 do
        SetWarMap(ex, ey, 4, 1)
        if GetWarMap(ex, ey, 2) ~= nil and GetWarMap(ex, ey, 2) > -1 then
          local ep = GetWarMap(ex, ey, 2)
          if WAR.Person[WAR.CurID]["我方"] == WAR.Person[ep]["我方"] then
	          WAR.Person[ep]["生命点数"] = ExecDoctor(pid, WAR.Person[ep]["人物编号"])
	          SetWarMap(ex, ey, 4, 4)
	          WAR.Effect = 4
	        end
        end        
      end
    end
  end
  WAR.EffectXY = {}
  WAR.EffectXY[1] = {x1, y1}
  WAR.EffectXY[2] = {x1, y1}
  if flag == 1 then
    War_ShowFight(pid, 0, 0, 0, x1, y1, 30)
  elseif flag == 2 then
    War_ShowFight(pid, 0, 0, 0, x1, y1, 36)
  elseif flag == 3 then
    War_ShowFight(pid, 0, 0, 0, x1, y1, 0)
  elseif flag == 4 and emeny >= 0 then
    War_ShowFight(pid, 0, -1, 0, x1, y1, JY.Thing[thingid]["暗器动画编号"])
  end
  for i = 0, WAR.PersonNum - 1 do
    WAR.Person[i]["点数"] = 0
  end
  if flag == 4 then
    if emeny >= 0 then
      instruct_32(thingid, -1)
      return 1
    else
      return 0
    end
  else
    WAR.Person[WAR.CurID]["经验"] = WAR.Person[WAR.CurID]["经验"] + 1
    AddPersonAttrib(pid, "体力", -2)
  end
  
  if inteam(pid) then
    AddPersonAttrib(pid, "体力", -4)
  end
  return 1
end

--绘画动态集气条
function DrawTimeBar2()
   local x1, x2, y =  CC.ScreenW * 5 / 8, CC.ScreenW * 7 / 8, CC.ScreenH/10
  local draw = false
  --这三个是固定的，只需要加载一次就可以了
  DrawBox_1(x1 - 3, y, x2 + 3, y + 3, C_ORANGE)
  DrawBox_1(x1 - (x2 - x1) / 2, y, x1 - 3, y + 3, C_RED)
  DrawString(x2 + 10, y - 23, "时序", C_WHITE, CC.FontSmall)
   local surid = lib.SaveSur(x1 - (10 + (x2 - x1) / 2), 0, x2 + 10 + 20 + 30, y * 2 + 18 + 25)
  
  while true do
  	draw = false
	  for i = 0, WAR.PersonNum - 1 do
	  	local pid = WAR.Person[i]["人物编号"];
	    if WAR.Person[i]["死亡"] == false then
	    	if WAR.Person[i].TimeAdd < 0 then
		      draw = true
		      WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd + 20
		      if WAR.Person[i].TimeAdd > 0 then
		      	WAR.Person[i].TimeAdd = 0;
		      end
		      if WAR.Person[i].Time > -500 then
		        WAR.Person[i].Time = WAR.Person[i].Time - 20
			    else
			      if JY.Person[pid]["受伤程度"] < 100 then
			        if inteam(pid) then
			        	AddPersonAttrib(pid, "受伤程度", Rnd(4) + 2)		--我方被减集气时受到的内伤
			        else
			        	AddPersonAttrib(pid, "受伤程度", Rnd(3) + 1)		--敌方内伤
			        end     
			      end
			    end	
				  if WAR.Person[i].Time < -200 and PersonKF(pid, 100) then	--练了先天功后，当集气被杀到-200，内伤直接清0
				     JY.Person[pid]["受伤程度"] = 0;	
				  end
			  --蓝烟清：增加被打中反加集气绘画
			  elseif WAR.Person[i].TimeAdd > 0 then
			  	draw = true
			  	WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd - 20
			  	WAR.Person[i].Time = WAR.Person[i].Time + 20
			  	if WAR.Person[i].Time > 995 then
			  		WAR.Person[i].Time = 995;
			  	end
			  end
		  end
	 	end
	 	
	 	if draw then
	    lib.LoadSur(surid, x1 - (10 + (x2 - x1) / 2), 0)
	    DrawTimeBar_sub(x1, x2, y, 1)
	    ShowScreen()
	    lib.Delay(8)
	  else
	  	break;
  	end
  end
	lib.Delay(100)
	lib.FreeSur(surid)
end

--绘制集气条
function DrawTimeBar()
	
  local x1,x2,y = CC.ScreenW * 5 / 8, CC.ScreenW * 7 / 8, CC.ScreenH/10
  local xunhuan = true
  
  --这三个是固定的，只需要加载一次就可以了
  DrawBox_1(x1 - 3, y, x2 + 3, y + 3, C_ORANGE)
  DrawBox_1(x1 - (x2 - x1) / 2, y, x1 - 3, y + 3, C_RED)
  DrawString(x2 + 10, y - 23, "时序", C_WHITE, CC.FontSmall)
  
	lib.SetClip(x1 - (x2-x1)/2, 0, CC.ScreenW, CC.ScreenH/4)
	local surid = lib.SaveSur( x1 - (x2-x1)/2, 0, CC.ScreenW, CC.ScreenH/4)
  while xunhuan do
    for i = 0, WAR.PersonNum - 1 do
      if WAR.Person[i]["死亡"] == false then
      	local jqid = WAR.Person[i]["人物编号"]
        if WAR.FXDS[WAR.Person[i]["人物编号"]] == nil then
        	--如果没学逆运，正常集气
          if PersonKF(jqid, 104) == false then
            WAR.Person[i].Time = WAR.Person[i].Time + WAR.Person[i].TimeAdd
            if WAR.LQZ[jqid] == 100 then
              WAR.Person[i].Time = WAR.Person[i].Time + WAR.Person[i].TimeAdd
            end
          else
          	--如果没学九阴，集气絮乱
            if PersonKF(jqid, 107) == false then
            
            	local jq = 0;
            	--蓝烟清：逆运集气速度变化
            	if WAR.L_NYZH[WAR.Person[i]["人物编号"]] == nil then
	            	jq = math.random(WAR.Person[i].TimeAdd) + 1
	            	
	            	WAR.Person[i].Time = WAR.Person[i].Time + jq
	          
	            	
	            elseif WAR.L_NYZH[WAR.Person[i]["人物编号"]] == 1 then		--新逆运走火集气变化
	            	jq = math.random(math.floor(WAR.Person[i].TimeAdd/3),WAR.Person[i].TimeAdd*2)
	            	WAR.Person[i].Time = WAR.Person[i].Time + jq
	            end
	            
	            --絮乱状态下额外的集气加成，两次判断
	            if math.random(10) == 8 or math.random(10) == 8 then
		            if jqid == 60 then
		              if JY.Thing[202][WZ7] == 1 then
		                WAR.Person[i].Time = WAR.Person[i].Time + 50
		                jq = jq + 50;
		              else
		                WAR.Person[i].Time = WAR.Person[i].Time + 80
		                jq = jq + 80;
		              end
		            else
		              WAR.Person[i].Time = WAR.Person[i].Time + 30
		              jq = jq + 30;
		            end
		          end
		         
            
	            if JY.Person[WAR.Person[i]["人物编号"]]["体力"] < 20 then
	              WAR.tmp[1000 + jqid] = nil
	            end
	          else		--如果学了九阴，正常集气
	          	
	            WAR.Person[i].Time = WAR.Person[i].Time + WAR.Person[i].TimeAdd  
	            if WAR.LQZ[jqid] == 100 then
	              WAR.Person[i].Time = WAR.Person[i].Time + WAR.Person[i].TimeAdd
	            end
	          end
	        end
        else
          WAR.FXDS[WAR.Person[i]["人物编号"]] = WAR.FXDS[WAR.Person[i]["人物编号"]] - 1
          
          --易筋经 封穴回复加倍
          if PersonKF(jqid, 108) then
            WAR.FXDS[jqid] = WAR.FXDS[jqid] - 1
          end
          
          --brolycjw: 九阳5时序解除封穴
					if PersonKF(jqid, 106) and (JY.Person[jqid]["内力性质"] == 1 or (jqid == JY.MY and GetS(4, 5, 5, 5) == 5)) then
						if WAR.JYFX[jqid] == nil then
							WAR.JYFX[jqid] = 1;
						elseif WAR.JYFX[jqid] < 5 then
							WAR.JYFX[jqid] = WAR.JYFX[jqid] + 1;
						else
							WAR.JYFX[jqid] = nil;
							WAR.FXDS[jqid] = 0;
						end
					end
					
          if WAR.LQZ[jqid] == 100 then
            WAR.FXDS[jqid] = WAR.FXDS[jqid] - 1
          end
          if WAR.FXDS[WAR.Person[i]["人物编号"]] < 1 then
          	WAR.FXDS[WAR.Person[i]["人物编号"]] = nil
					end
        end  
        
        --九阳神功回内
        if PersonKF(jqid, 106) and (JY.Person[jqid]["内力性质"] == 1 or (jqid == 0 and GetS(4, 5, 5, 5) == 5)) then
          JY.Person[jqid]["内力"] = JY.Person[jqid]["内力"] + 6 + math.random(2)
        end
        
        --九阴神功回血
        if PersonKF(jqid, 107) and (JY.Person[jqid]["内力性质"] == 0 or (jqid == 0 and GetS(4, 5, 5, 5) == 5)) then
          JY.Person[jqid]["生命"] = JY.Person[jqid]["生命"] + 2
        end
		
				--brolycjw: 先天功回血回内
        if PersonKF(jqid, 100) then
          JY.Person[jqid]["内力"] = JY.Person[jqid]["内力"] + 2 + math.random(1)
          JY.Person[jqid]["生命"] = JY.Person[jqid]["生命"] + 1
        end
          
        if WAR.LXZT[jqid] ~= nil then
          if inteam(jqid) then
            JY.Person[jqid]["生命"] = JY.Person[jqid]["生命"] - math.random(3) - math.modf(JY.Person[jqid]["受伤程度"] / 15)
          else
            JY.Person[jqid]["生命"] = JY.Person[jqid]["生命"] - 1 - math.modf(JY.Person[jqid]["受伤程度"] / 51)
          end
          if JY.Person[jqid]["生命"] < 1 then
            JY.Person[jqid]["生命"] = 1
          end
          WAR.LXZT[jqid] = WAR.LXZT[jqid] - 1
          if PersonKF(jqid, 108) then	--brolycjw: 易筋经回流血
            WAR.LXZT[jqid] = WAR.LXZT[jqid] - 1
          end
          if WAR.LXZT[jqid] < 1 then
          	WAR.LXZT[jqid] = nil
        	end
        end
        
        --brolycjw: 易筋经,九阴阳 回复内伤
        if (JY.Person[jqid]["受伤程度"] > 0 and PersonKF(jqid, 108)) or (JY.Person[jqid]["受伤程度"] > 25 and PersonKF(jqid, 106)) or (JY.Person[jqid]["受伤程度"] > 50 and PersonKF(jqid, 107)) then
	        if JY.Person[jqid]["受伤程度"] > 70 and math.random(100)>60 then
						JY.Person[jqid]["受伤程度"] = JY.Person[jqid]["受伤程度"] - 1
	        elseif JY.Person[jqid]["受伤程度"] > 40 and math.random(100)>30 then
						JY.Person[jqid]["受伤程度"] = JY.Person[jqid]["受伤程度"] - 1
	        else
						JY.Person[jqid]["受伤程度"] = JY.Person[jqid]["受伤程度"] - 1
					end
				end


				--纯阳  回复中毒
        if JY.Person[jqid]["中毒程度"] > 0 and PersonKF(jqid, 99)  then
        	if JY.Person[jqid]["中毒程度"] > 70 and math.random(100)>60 then
          	JY.Person[jqid]["中毒程度"] = JY.Person[jqid]["中毒程度"] - 1
          elseif JY.Person[jqid]["中毒程度"] > 40 and math.random(100)>60 then
          	JY.Person[jqid]["中毒程度"] = JY.Person[jqid]["中毒程度"] - 1
          else
          	JY.Person[jqid]["中毒程度"] = JY.Person[jqid]["中毒程度"] - 1
          end
        end
				
				
				--蓝烟清：狄云 领悟神照经真髓，时序回血、回内、减内伤、清除
				if jqid == 37 and GetS(86, 8, 10, 5) == 2 then
					--时序清毒
					if JY.Person[jqid]["中毒程度"] > 70 and math.random(100)>60 then
          	JY.Person[jqid]["中毒程度"] = JY.Person[jqid]["中毒程度"] - 1
          elseif JY.Person[jqid]["中毒程度"] > 40 and math.random(100)>30 then
          	JY.Person[jqid]["中毒程度"] = JY.Person[jqid]["中毒程度"] - 1
          else
          	JY.Person[jqid]["中毒程度"] = JY.Person[jqid]["中毒程度"] - 1
          end
          
          --时序减内伤
          if JY.Person[jqid]["受伤程度"] > 70 and math.random(100)>60 then
	          JY.Person[jqid]["受伤程度"] = JY.Person[jqid]["受伤程度"] - 1
	        elseif JY.Person[jqid]["受伤程度"] > 40 and math.random(100)>30 then
	          JY.Person[jqid]["受伤程度"] = JY.Person[jqid]["受伤程度"] - 1
	        else
	        	JY.Person[jqid]["受伤程度"] = JY.Person[jqid]["受伤程度"] - 1
					end
					
					--时序回内
					JY.Person[jqid]["内力"] = JY.Person[jqid]["内力"] + 3 + math.random(2)
					
					--时序回血
					JY.Person[jqid]["生命"] = JY.Person[jqid]["生命"] + 1 + math.random(1)
				end
				
				--蓝烟清：迟缓值回复
				if WAR.CHZ[jqid] ~= nil then
					WAR.CHZ[jqid] = WAR.CHZ[jqid] - 1;
					if WAR.CHZ[jqid] < 1 then
						WAR.CHZ[jqid] = nil;
					end
				end

        
        --蓝烟清：王难姑指令，按时序中毒，按百分比减血
	      if WAR.L_WNGZL[jqid] ~= nil and WAR.L_WNGZL[jqid] > 0 then
	      	
	      	JY.Person[jqid]["中毒程度"] = JY.Person[jqid]["中毒程度"] + 1
		    	JY.Person[jqid]["生命"] = JY.Person[jqid]["生命"] - math.modf(JY.Person[jqid]["生命"]/120);
		    	WAR.L_WNGZL[jqid] = WAR.L_WNGZL[jqid] -1;
		    	
		    	if WAR.L_WNGZL[jqid] <= 0 then
		    		WAR.L_WNGZL[jqid] = nil;
		    	end
		    end
		    
		    --brolycjw：胡青牛指令，按时序回血回内伤，按百分比回血
	      if WAR.L_HQNZL[jqid] ~= nil and WAR.L_HQNZL[jqid] > 0 then
	      	JY.Person[jqid]["生命"] = JY.Person[jqid]["生命"] + 1 + math.modf((JY.Person[jqid]["生命最大值"]-JY.Person[jqid]["生命"])/40);
					if JY.Person[jqid]["受伤程度"] > 50 then
						JY.Person[jqid]["受伤程度"] = JY.Person[jqid]["受伤程度"] - 2;
					else
						JY.Person[jqid]["受伤程度"] = JY.Person[jqid]["受伤程度"] - 1;
					end
		    	WAR.L_HQNZL[jqid] = WAR.L_HQNZL[jqid] -1;
		    	if WAR.L_HQNZL[jqid] <= 0 then
		    		WAR.L_HQNZL[jqid] = nil;
		    	end
		  	end
     
        if WAR.Person[i].Time >= 1000 then
          if WAR.ZYHB == 1 then
            if i ~= WAR.ZYHBP then
              WAR.Person[i].Time = 990
            else
            	WAR.Person[i].Time = 1001
            end
          end
          xunhuan = false
	      end
	    end
    end
		DrawTimeBar_sub(x1, x2, nil, 0)
		ShowScreen(1)
		WAR.SXTJ = WAR.SXTJ + 1
		
	  --集气过程中按键有效
	  local keypress = lib.GetKey()
		if (keypress == VK_SPACE or keypress == VK_RETURN) then
			if WAR.AutoFight == 1 then 
				WAR.AutoFight = 0
			end
	  elseif keypress == VK_ESCAPE then
	    if DrawStrBoxYesNo(-1, -1, "是否退出游戏", C_WHITE, CC.DefaultFont) == true then
	      JY.Status = x
	    end
	    Cls()
			lib.SetClip(x1 - (x2-x1)/2, 0, CC.ScreenW, CC.ScreenH/4)
	  end
	  
		lib.LoadSur(surid, x1 - ((x2 - x1) / 2), 0)
  end
  for i = 0, WAR.PersonNum - 1 do
    if WAR.Person[i]["死亡"] == false then
      WAR.Person[i].TimeAdd = 0
    	local jqid=WAR.Person[i]["人物编号"]
			--主角医生回生，减内伤，减中毒
	    if jqid == JY.MY and GetS(4, 5, 5, 5) == 7 then
	      JY.Person[jqid]["生命"] = JY.Person[jqid]["生命"]+limitX(WAR.SXTJ/100,0,100) + math.random(10);
	      JY.Person[jqid]["中毒程度"] = JY.Person[jqid]["中毒程度"] - 5 - math.random(5);
	    end
	    
	    --判断是否在正常数据范围之内
	  	if JY.Person[jqid]["中毒程度"] < 0 then
				JY.Person[jqid]["中毒程度"] = 0;
			end
			if JY.Person[jqid]["受伤程度"] < 0 then
				JY.Person[jqid]["受伤程度"] = 0;
			end
			if JY.Person[jqid]["内力最大值"] < JY.Person[jqid]["内力"] then
	      JY.Person[jqid]["内力"] = JY.Person[jqid]["内力最大值"]
	    end
			if JY.Person[jqid]["生命最大值"] < JY.Person[jqid]["生命"] then
	      JY.Person[jqid]["生命"] = JY.Person[jqid]["生命最大值"]
	    end
  	end
  end
  WAR.ZYHBP = -1
  lib.SetClip(0, 0, 0, 0)
  lib.FreeSur(surid)
end
--绘画整体集气条
function DrawTimeBar_sub(x1, x2, y, flag)
  
  if not x2 then
    x2 = CC.ScreenW * 7 / 8
  end
  if not y then
    y = CC.ScreenH/10
  end
  if not x1 then
    x1 = CC.ScreenW * 5 / 8
    DrawBox_1(x1 - 3, y, x2 + 3, y + 3, C_ORANGE)
  	DrawBox_1(x1 - (x2 - x1) / 2, y, x1 - 3, y + 3, C_RED)
  	DrawString(x2 + 10, y - 23, "时序", C_WHITE, CC.FontSmall)
  end
  

  for i = 0, WAR.PersonNum - 1 do
    if not WAR.Person[i]["死亡"] then
      local cx = x1 + math.modf(WAR.Person[i].Time*(x2 - x1)/1000)
      local headid = WAR.tmp[5000+i];
      if headid == nil then
      	headid = JY.Person[WAR.Person[i]["人物编号"]]["头像代号"]
      end
      local w, h = limitX(CC.ScreenW/25,12,35),limitX(CC.ScreenW/25,12,35)
      if WAR.Person[i]["我方"] then
				lib.LoadPNG(99, headid*2, cx - w / 2, y - h - 4, 1, 0)
     	else
				lib.LoadPNG(99, headid*2, cx - w / 2, y + 6, 1, 0)
	  	end
    end
	end
	DrawString(x2 + 10, y - 3, WAR.SXTJ, C_GOLD, CC.Fontsmall)
end

--绘画集气条上的名字
function drawname(x, y, name, size)
  x = x - math.modf(size / 2)
  local namelen = string.len(name) / 2
  local zi = {}
  for i = 1, namelen do
    zi[i] = string.sub(name, i * 2 - 1, i * 2)
    DrawString(x, y, zi[i], C_WHITE, size)
    y = y + size
  end
end

--判断两人之间的距离
function RealJL(id1, id2, len)
  if not len then
    len = 1
  end
  local x1, y1 = WAR.Person[id1]["坐标X"], WAR.Person[id1]["坐标Y"]
  local x2, y2 = WAR.Person[id2]["坐标X"], WAR.Person[id2]["坐标Y"]
  local s = math.abs(x1 - x2) + math.abs(y1 - y2)
  if len == nil then
    return s
  end
  if s <= len then
    return true
  else
    return false
  end
end

--计算武功范围
function refw(wugong, level)
  local m1, m2, a1, a2, a3, a4, a5 = nil, nil, nil, nil, nil, nil, nil
  if JY.Wugong[wugong]["攻击范围"] == -1 then
    return JY.Wugong[wugong]["加内力1"], JY.Wugong[wugong]["加内力2"], JY.Wugong[wugong]["未知1"], JY.Wugong[wugong]["未知2"], JY.Wugong[wugong]["未知3"], JY.Wugong[wugong]["未知4"], JY.Wugong[wugong]["未知5"]
  end
  local fightscope = JY.Wugong[wugong]["攻击范围"]
  local kfkind = JY.Wugong[wugong]["武功类型"]
  local pid = WAR.Person[WAR.CurID]["人物编号"]
  if fightscope == 0 then
    if level > 10 then
      m1 = 1
      m2 = JY.Wugong[wugong]["移动范围" .. 10]
      a1 = 1
      a2 = 3
      a3 = 3
    else
      m1 = 0
      m2 = JY.Wugong[wugong]["移动范围" .. level]
      a1 = 1
      a2 = math.modf(level / 5)
      a3 = math.modf(level / 8)
    end
  elseif fightscope == 1 then
    if kfkind == 1 then
      a1 = 12
      if level > 10 then
        m1 = 3
        m2 = 1
        a2 = JY.Wugong[wugong]["移动范围" .. 10] - 1
      else
        m1 = 2
        m2 = 1
        a2 = JY.Wugong[wugong]["移动范围" .. level] - 1
      end
    elseif kfkind == 2 then
      a1 = 10
      if level > 10 then
        m1 = 3
        m2 = 1
        a2 = JY.Wugong[wugong]["移动范围" .. 10]
        a3 = a2 - 1
        a4 = a3 - 1
      else
        m1 = 2
        m2 = 1
        a2 = JY.Wugong[wugong]["移动范围" .. level]
      end
      if level > 7 then
        a3 = a2 - 1
      end
    elseif kfkind == 3 then
      a1 = 11
      if level > 10 then
        m1 = 3
        m2 = 1
        a2 = JY.Wugong[wugong]["移动范围" .. 10] - 1
      else
        m1 = 2
        m2 = 1
        a2 = JY.Wugong[wugong]["移动范围" .. level] - 1
      end
    elseif kfkind == 4 then
      m1 = 2
      if level > 10 then
        m2 = JY.Wugong[wugong]["移动范围" .. 10] - 1
        a1 = 7
        a2 = 1 + math.modf(level / 3)
        a3 = a2
	    else
	      m2 = JY.Wugong[wugong]["移动范围" .. level] - 1
	      a1 = 1
	      a2 = 1 + math.modf(level / 3)
	    end
	  else
	  	a1 = 11
      if level > 10 then
        m1 = 3
        m2 = 1
        a2 = JY.Wugong[wugong]["移动范围" .. 10] - 1
      else
        m1 = 2
        m2 = 1
        a2 = JY.Wugong[wugong]["移动范围" .. level] - 1
      end
	  end
  elseif fightscope == 2 then
    m1 = 0
    m2 = 0
    if kfkind == 3 then
      if level > 10 then
        a1 = 6
        a2 = JY.Wugong[wugong]["移动范围" .. 10]
      else
        a1 = 8
        a2 = JY.Wugong[wugong]["移动范围" .. level]
      end
    elseif level > 10 then
      if kfkind == 1 then
        a1 = 5
        a2 = JY.Wugong[wugong]["移动范围" .. 10] - 1
        a3 = a2 - 3
      elseif kfkind == 2 then
        a1 = 1
        a2 = JY.Wugong[wugong]["移动范围" .. 10] - 1
        a3 = a2
      else
        a1 = 2
        a2 = 1 + math.modf(JY.Wugong[wugong]["移动范围" .. 10] / 2)
      end
    else
      a1 = 1
      a2 = JY.Wugong[wugong]["移动范围" .. level]
      a3 = 0
    end
  elseif fightscope == 3 then
    m1 = 0
    a1 = 3
    if level > 10 then
      m2 = JY.Wugong[wugong]["移动范围" .. 10] + 1
      a2 = JY.Wugong[wugong]["杀伤范围" .. 10]
      a3 = a2
    else
    	m2 = JY.Wugong[wugong]["移动范围" .. level]
    	a2 = JY.Wugong[wugong]["杀伤范围" .. level]
    end
  
  end
  return m1, m2, a1, a2, a3, a4, a5
end

--判断人物是否为队友，不管在不在队
function isteam(p)
	local r = false
  for i,v in pairs(CC.PersonExit) do
    if v[1] == p then
      r = true
      break;
    end
  end
  if p == 0 then
    r = true
  end
  
	return r;
end

--判断人物是否有某种武功
function PersonKF(p, kf)
  for i = 1, 10 do
	if JY.Person[p]["武功" .. i] <= 0 then
		return false;
    elseif JY.Person[p]["武功" .. i] == kf then
      return true
    end
  end
  return false
end

--判断人物是否有某种武功，并且等级为极
function PersonKFJ(p, kf)
	for i = 1, 10 do
		if JY.Person[p]["武功" .. i] == -1 then
			return false;
		elseif JY.Person[p]["武功" .. i] == kf and JY.Person[p]["武功等级" .. i] == 999 then
		  return true
		end
  end
  return false
end

--判断触发机率
function myrandom(p, pp)
  for i = 0, WAR.PersonNum - 1 do
    local pid = WAR.Person[i]["人物编号"]
    if WAR.Person[i]["死亡"] == false and pid == 76 and inteam(pp) then
      p = p + 5		--王语嫣+5点
    end
  end
  for i = 1, 10 do
    if JY.Person[pp]["武功" .. i] == 102 then
      p = p + (math.modf(JY.Person[pp]["武功等级" .. i] / 100) + 1)     --太玄神功+10点
    end
  end
  p = math.modf(p + JY.Person[pp]["生命最大值"] * 4 / (JY.Person[pp]["生命"] + 20) + JY.Person[pp]["体力"] / 20)		--生命值越低，机率越高

  --石破天+20点
  if pp == 38 then
    p = p + 20
  end

  --旧版逆运走火+40点
  if WAR.tmp[1000 + pp] == 1 then
    p = p + 40
  end

  --满实战+20点
  
  local jp = math.modf(GetSZ(pp) / 25 + 1)
  if jp > 20 then
    jp = 20
  end
  p = p + jp
      
  
  --内力值最多+20点
  p = p + limitX(math.modf(JY.Person[pp]["内力"] / 500), 0, 20)


  local times = 1
  if inteam(pp) then
    if JY.Person[pp]["资质"] < math.random(120) - 10 then
      times = 2
    end
  else
    times = 3
    p = p + 40
  end

  
  for i = 1, times do
    local bd = math.random(120) + 10
    if bd <= p then
      return true
    end
  end
  return false
end


--自动选择敌人
function War_AutoSelectEnemy()
  local enemyid = War_AutoSelectEnemy_near()
  WAR.Person[WAR.CurID]["自动选择对手"] = enemyid
  return enemyid
end

--选择最近敌人
function War_AutoSelectEnemy_near()
  War_CalMoveStep(WAR.CurID, 100, 1)			--标记每个位置的步数
  local maxDest = math.huge
  local nearid = -1
  for i = 0, WAR.PersonNum - 1 do		--查找最近步数的敌人
    if WAR.Person[WAR.CurID]["我方"] ~= WAR.Person[i]["我方"] and WAR.Person[i]["死亡"] == false then
      local step = GetWarMap(WAR.Person[i]["坐标X"], WAR.Person[i]["坐标Y"], 3)
      if step < maxDest then
	      nearid = i
	      maxDest = step
    	end
    end
  end
  return nearid
end

--战斗中加入新人物
function NewWARPersonZJ(id, dw, x, y, life, fx)
  WAR.Person[WAR.PersonNum]["人物编号"] = id
  WAR.Person[WAR.PersonNum]["我方"] = dw
  WAR.Person[WAR.PersonNum]["坐标X"] = x
  WAR.Person[WAR.PersonNum]["坐标Y"] = y
  WAR.Person[WAR.PersonNum]["死亡"] = life
  WAR.Person[WAR.PersonNum]["人方向"] = fx
  WAR.Person[WAR.PersonNum]["贴图"] = WarCalPersonPic(WAR.PersonNum)
  lib.PicLoadFile(string.format(CC.FightPicFile[1], JY.Person[id]["头像代号"]), string.format(CC.FightPicFile[2], JY.Person[id]["头像代号"]), 4 + WAR.PersonNum)
  SetWarMap(x, y, 2, WAR.PersonNum)
  SetWarMap(x, y, 5, WAR.Person[WAR.PersonNum]["贴图"])
  WAR.PersonNum = WAR.PersonNum + 1
end


 function between(num_1, num_2, num_3, flag)
    if not flag then
      flag = 0
    end
    if num_3 < num_2 then
      num_2, num_3 = num_3, num_2
    end
    if flag == 0 and num_2 < num_1 and num_1 < num_3 then
      return true
    elseif flag == 1 and num_2 <= num_1 and num_1 <= num_3 then
      return true
    else
      return false
    end
  end