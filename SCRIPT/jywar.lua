function War_Contact(id, txwz, str)
		if WAR.Person[id][txwz] ~= nil then
			WAR.Person[id][txwz] = WAR.Person[id][txwz] .. "+".. str
			else
			WAR.Person[id][txwz] = str
		end
end

--��������֮���ʵ�ʾ���
function War_realjl(ida, idb)
  if ida == nil then
    ida = WAR.CurID
  end
  CleanWarMap(3, 255)
  local x = WAR.Person[ida]["����X"]
  local y = WAR.Person[ida]["����Y"]
  local steparray = {}
  steparray[0] = {}
  steparray[0].bushu = {}
  steparray[0].x = {}
  steparray[0].y = {}
  SetWarMap(x, y, 3, 0)
  steparray[0].num = 1
  steparray[0].bushu[1] = 0		--�����ƶ��Ĳ���
  steparray[0].x[1] = x
  steparray[0].y[1] = y
  return War_FindNextStep1(steparray, 0, ida, idb)
end

function unnamed(kfid)
  local pid = WAR.Person[WAR.CurID]["������"]
  local kungfuid = JY.Person[pid]["�书" .. kfid]
  local kungfulv = JY.Person[pid]["�书�ȼ�" .. kfid]
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
  local kungfuatk = JY.Wugong[kungfuid]["������" .. kungfulv]
  local atkarray = {}
  local num = 0
  CleanWarMap(4, -1)
  local movearray = War_CalMoveStep(WAR.CurID, WAR.Person[WAR.CurID]["�ƶ�����"], 0)
  WarDrawMap(1)
  ShowScreen()
  for i = 0, WAR.Person[WAR.CurID]["�ƶ�����"] do
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
    
    War_CalMoveStep(WAR.CurID, WAR.Person[WAR.CurID]["�ƶ�����"], 0)
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
  local enemyid=War_AutoSelectEnemy()   --ѡ���������

	War_CalMoveStep(WAR.CurID,100,0);   --�����ƶ����� �������100��

	for i=0,CC.WarWidth-1 do
     for j=0,CC.WarHeight-1 do
				local dest=GetWarMap(i,j,3);
        if dest <128 then
          local dx=math.abs(i-WAR.Person[enemyid]["����X"])
          local dy=math.abs(j-WAR.Person[enemyid]["����Y"])
          if minDest>(dx+dy) then        --��ʱx,y�Ǿ�����˵����·������Ȼ���ܱ�Χס
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

	if minDest<math.huge then   --��·����
	    while true do    --��Ŀ��λ�÷����ҵ������ƶ���λ�ã���Ϊ�ƶ��Ĵ���
				local i=GetWarMap(x,y,3);
			if i<=WAR.Person[WAR.CurID]["�ƶ�����"] then
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
	  War_MovePerson(x,y);    --�ƶ�����Ӧ��λ��
  end
end



function GetMovePoint(x, y, flag)
  local point = 0
  local wofang = WAR.Person[WAR.CurID]["�ҷ�"]
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
			      if WAR.Person[v]["�ҷ�"] == wofang then
			        point = point + i * 2 - 19
			      elseif WAR.Person[v]["�ҷ�"] ~= wofang then
			      
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


--ս��������������
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



function War_FindNextStep1(steparray,step,id,idb)      --������һ�����ƶ�������
 --������ĺ�������   
	local num=0;
	local step1=step+1;
	
	    steparray[step1]={};
		steparray[step1].bushu={};
        steparray[step1].x={};
        steparray[step1].y={};
	
	local function fujinnum(tx,ty)
		local tnum=0
		local wofang=WAR.Person[id]["�ҷ�"]
		local tv;
		tv=GetWarMap(tx+1,ty,2);
		if idb==nil then
			if tv~=-1 then
				if WAR.Person[tv]["�ҷ�"]~=wofang then
					return -1
				end
			end
		elseif tv==idb then
			return -1
		end
		if tv~=-1 then
			if WAR.Person[tv]["�ҷ�"]~=wofang then
				tnum=tnum+1
			end
		end
		tv=GetWarMap(tx-1,ty,2);
		if idb==nil then
			if tv~=-1 then
				if WAR.Person[tv]["�ҷ�"]~=wofang then
					return -1
				end
			end
		elseif tv==idb then
			return -1
		end
		if tv~=-1 then
			if WAR.Person[tv]["�ҷ�"]~=wofang then
				tnum=tnum+1
			end
		end
		tv=GetWarMap(tx,ty+1,2);
		if idb==nil then
			if tv~=-1 then
				if WAR.Person[tv]["�ҷ�"]~=wofang then
					return -1
				end
			end
		elseif tv==idb then
			return -1
		end
		if tv~=-1 then
			if WAR.Person[tv]["�ҷ�"]~=wofang then
				tnum=tnum+1
			end
		end
		tv=GetWarMap(tx,ty-1,2);
		if idb==nil then
			if tv~=-1 then
				if WAR.Person[tv]["�ҷ�"]~=wofang then
					return -1
				end
			end
		elseif tv==idb then
			return -1
		end
		if tv~=-1 then
			if WAR.Person[tv]["�ҷ�"]~=wofang then
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
	    if x+1<CC.WarWidth-1 then                        --��ǰ���������ڸ�
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

	    if x-1>0 then                        --��ǰ���������ڸ�
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

	    if y+1<CC.WarHeight-1 then                        --��ǰ���������ڸ�
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

	    if y-1>0 then                        --��ǰ���������ڸ�
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
--������Ʒ
function War_PersonTrainDrug(pid)
  local p = JY.Person[pid]
  local thingid = p["������Ʒ"]
  if thingid < 0 then
    return 
  end
  if JY.Thing[thingid]["������Ʒ�辭��"] <= 0 then
    return 
  end
  local needpoint = (7 - math.modf(p["����"] / 15)) * JY.Thing[thingid]["������Ʒ�辭��"]
  if p["��Ʒ��������"] < needpoint then
    return 
  end
  
  local haveMaterial = 0
  local MaterialNum = -1
  for i = 1, CC.MyThingNum do
    if JY.Base["��Ʒ" .. i] == JY.Thing[thingid]["�����"] then
      haveMaterial = 1
      MaterialNum = JY.Base["��Ʒ����" .. i]
    end
  end
  
  --�����㹻
  if haveMaterial == 1 then
    local enough = {}
    local canMake = 0
    for i = 1, 5 do
      if JY.Thing[thingid]["������Ʒ" .. i] >= 0 and JY.Thing[thingid]["��Ҫ��Ʒ����" .. i] <= MaterialNum then
        canMake = 1
        enough[i] = 1
      else
        enough[i] = 0
      end
    end

  
	  --��������
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
	    
	    local newThingID = JY.Thing[thingid]["������Ʒ" .. makeID]
	    DrawStrBoxWaitKey(string.format("%s ����� %s", p["����"], JY.Thing[newThingID]["����"]), C_WHITE, CC.DefaultFont)
	    if instruct_18(newThingID) == true then
	      instruct_32(newThingID, 1)
	    else
	      instruct_32(newThingID, 1)
	    end
	    instruct_32(JY.Thing[thingid]["�����"], -JY.Thing[thingid]["��Ҫ��Ʒ����" .. makeID])
	    p["��Ʒ��������"] = 0
	  end
	end
end--��������ж�����
--pid ʹ���ˣ�
--enemyid  �ж���
function War_PoisonHurt(pid, enemyid)
  local vv = math.modf((JY.Person[pid]["�ö�����"] - JY.Person[enemyid]["��������"]) / 4)
  if JY.Status == GAME_WMAP then
    for i,v in pairs(CC.AddPoi) do
      if v[1] == pid then
        for wid = 0, WAR.PersonNum - 1 do
          if WAR.Person[wid]["������"] == v[2] and WAR.Person[wid]["����"] == false then
            vv = vv + v[3] / 4
          end
        end
      end
    end
  end
  vv = vv - JY.Person[enemyid]["����"] / 200
  for i = 1, 10 do
    if JY.Person[enemyid]["�书" .. i] == 108 then
      vv = 0
    end
  end
  vv = math.modf(vv)
  if vv < 0 then
    vv = 0
  end
  return AddPersonAttrib(enemyid, "�ж��̶�", vv)
end


--���ﰴ�Ṧ��������
function WarPersonSort(flag)
  for i = 0, WAR.PersonNum - 1 do
    local id = WAR.Person[i]["������"]
    local add = 0
    if JY.Person[id]["����"] > -1 then
      add = add + JY.Thing[JY.Person[id]["����"]]["���Ṧ"]
    end
    if JY.Person[id]["����"] > -1 then
      add = add + JY.Thing[JY.Person[id]["����"]]["���Ṧ"]
    end
    WAR.Person[i]["�Ṧ"] = JY.Person[id]["�Ṧ"] + (add)
    if WAR.Person[i]["�ҷ�"] then
      
    else
	    if GetS(0, 0, 0, 0) == 1 then
	      WAR.Person[i]["�Ṧ"] = WAR.Person[i]["�Ṧ"] + math.modf(JY.Person[id]["�������ֵ"] / 50) + JY.Person[id]["�ȼ�"]
	    else
	      WAR.Person[i]["�Ṧ"] = WAR.Person[i]["�Ṧ"] + math.modf(JY.Person[id]["�������ֵ"] / 100)
	    end
	  end
    for ii,v in pairs(CC.AddSpd) do
      if v[1] == id then
        for wid = 0, WAR.PersonNum - 1 do
          if WAR.Person[wid]["������"] == v[2] and WAR.Person[wid]["����"] == false then
            WAR.Person[i]["�Ṧ"] = WAR.Person[i]["�Ṧ"] + v[3]
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
      if WAR.Person[maxid]["�Ṧ"] < WAR.Person[j]["�Ṧ"] then
        maxid = j;
      end
    end
    WAR.Person[maxid], WAR.Person[i] = WAR.Person[i], WAR.Person[maxid]
  end
end

--��ʾ�ǹ���ʱ�ĵ���
function War_Show_Count(id, str)

	local pid = WAR.Person[id]["������"];
	local x = WAR.Person[id]["����X"];
	local y = WAR.Person[id]["����Y"];
	
	local hp = WAR.Person[id]["��������"];
  local mp = WAR.Person[id]["��������"];
  local tl = WAR.Person[id]["��������"];
  local ed = WAR.Person[id]["�ж�����"];
  local dd = WAR.Person[id]["�ⶾ����"];
  local ns = WAR.Person[id]["���˵���"];
  
  local show = {x, y, nil, nil, nil, nil, nil, nil, nil, nil, nil};		--x, y, ����, ����, ����, ��Ѩ, ��Ѫ, �ж�, �ⶾ, ����
	
	if hp ~= nil and hp ~= 0 then		--��ʾ����
		if hp > 0 then
    	show[3] = "��+"..hp;
    else
    	show[3] = "��"..hp;
    end
	end
	
	if mp ~= nil and mp ~= 0 then		--��ʾ����
		if mp > 0 then
    	show[4] = "��+"..mp;
    else
    	show[4] = "��"..mp;
    end
	end
	
	if tl ~= nil and tl ~= 0 then		--��ʾ����
		if tl > 0 then
    	show[5] = "��+"..tl;
    else
    	show[5] = "��"..tl;
    end
	end
	
	
	if ed ~= nil and ed ~= 0 then		--��ʾ�ж�
    show[8] = "��+"..ed;
	end
	
	if dd ~= nil and dd ~= 0 then		--��ʾ�ⶾ
    show[9] = "��-"..dd;
	end
	
	if ns ~= nil and ns ~= 0 then		--��ʾ����
		if ns > 0 then
    	show[10] = ns;
    else
    	--show[10] = "���ˡ� ";
    end
	end
	
	--��¼�ĸ�λ�����е���
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
  
  local ll = string.len(show[showValue[1]]);	--����
	
	local w = ll * CC.DefaultFont / 2 + 1
  local clip = {x1 = CC.ScreenW / 2 - w/2 - CC.XScale/2, y1 = CC.YScale + CC.ScreenH / 2 - hb, x2 = CC.XScale + CC.ScreenW / 2 + w, y2 = CC.YScale + CC.ScreenH / 2 + CC.DefaultFont + 1}
	local area = (clip.x2 - clip.x1) * (clip.y2 - clip.y1) + CC.DefaultFont*4		--�滭�ķ�Χ
  local surid = lib.SaveSur(0, 0, CC.ScreenW, CC.ScreenH)		--�滭���
  
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
        
        --��ʾ����
        if str ~= nil then
       		DrawString(clip.x1 - #str*CC.Fontsmall/5, clip.y1 - y_off  - CC.DefaultFont*4, str, C_WHITE, CC.Fontsmall);
       	end
        
        for j=1, showNum do
        	local c = showValue[j] - 1;
        	if showValue[j] == 3 and string.sub(show[3],1,1) == "-" then		--������������ʾΪ��ɫ
        		c = 1;
        	end
        	DrawString(clip.x1, clip.y1 - y_off - (showNum-j+1)*CC.DefaultFont, show[showValue[j]], WAR.L_EffectColor[c], CC.DefaultFont); 	
        end       
      end
    else
    	lib.SetClip(0, 0, CC.ScreenW, CC.ScreenH)
      lib.LoadSur(surid, 0, 0)
      --��ʾ����
      if str ~= nil then
     		DrawString(clip.x1 - #str*CC.Fontsmall/5, clip.y1 - y_off - CC.DefaultFont*4, str, C_WHITE, CC.Fontsmall);
     	end
      for j=1, showNum do
      	local c = showValue[j] - 1;
      	if showValue[j] == 3 and (string.sub(show[3],1,1) == "-" or string.sub(show[3],2,2) == "-") then		--������������ʾΪ��ɫ
      		c = 1;
      	end
      	DrawString(clip.x1, clip.y1 - y_off - (showNum-j+1)*CC.DefaultFont, show[showValue[j]], WAR.L_EffectColor[c], CC.DefaultFont); 	
      end 
  	end
  	
  	ShowScreen(1)
    lib.SetClip(0, 0, 0, 0)		--���
    local tend = lib.GetTime()
    if tend - tstart < CC.Frame then
      lib.Delay(CC.Frame - (tend - tstart))
    end
  end
  
  lib.SetClip(0, 0, 0, 0)		--���
  WAR.Person[id]["��������"] = nil;
  WAR.Person[id]["��������"] = nil;
  WAR.Person[id]["��������"] = nil;
  WAR.Person[id]["�ж�����"] = nil;
  WAR.Person[id]["�ⶾ����"] = nil;
  WAR.Person[id]["���˵���"] = nil;
  
  lib.FreeSur(surid)
end


--ҩƷʹ��ʵ��Ч��
--id ��Ʒid��
--personid ʹ����id
--����ֵ��0 ʹ��û��Ч������Ʒ����Ӧ�ò��䡣1 ʹ����Ч������ʹ�ú���Ʒ����Ӧ��-1
function UseThingEffect(id, personid)
  local str = {}
  str[0] = string.format("ʹ�� %s", JY.Thing[id]["����"])
  local strnum = 1
  local addvalue = nil
  if JY.Thing[id]["������"] > 0 then
    local add = JY.Thing[id]["������"] - math.modf(JY.Thing[id]["������"] * JY.Person[personid]["���˳̶�"] / 200) + Rnd(5)
    
    --����ţ�ڶӣ���ҩЧ��Ϊ1.3��
    if JY.Status == GAME_WMAP and inteam(personid) and inteam(16) then
      for w = 0, WAR.PersonNum - 1 do
        if WAR.Person[w]["������"] == 16 and WAR.Person[w]["����"] == false and WAR.Person[w]["�ҷ�"] then
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
	      WAR.Person[WAR.CurID]["���˵���"] = AddPersonAttrib(personid, "���˳̶�", -math.modf(add / 10))
	    else
	      WAR.Person[WAR.CurID]["���˵���"] = AddPersonAttrib(personid, "���˳̶�", -math.modf(add / 4))
	    end
	  end
	  --���˳�ҩЧ���ӱ�
	  if not inteam(personid) then
	  	add = add * 2;
	  end
    addvalue, str[strnum] = AddPersonAttrib(personid, "����", add)
    
    --�����壺��ʾ��������
    if JY.Status == GAME_WMAP then
    	WAR.Person[WAR.CurID]["��������"] = addvalue;
    end

    if addvalue ~= 0 then
    	strnum = strnum + 1
  	end
  end
  
  local function ThingAddAttrib(s)
    if JY.Thing[id]["��" .. s] ~= 0 then
      addvalue, str[strnum] = AddPersonAttrib(personid, s, JY.Thing[id]["��" .. s])
      if addvalue ~= 0 then
      	strnum = strnum + 1
    	end
    	
    	--�����壺��ʾ��������������
    	if JY.Status == GAME_WMAP then
  			if s == "����" then
  				WAR.Person[WAR.CurID]["��������"] = addvalue;
  			elseif s == "����" then
  				WAR.Person[WAR.CurID]["��������"] = addvalue;
  			end
  		end
    end
    
  end
  
  
  ThingAddAttrib("�������ֵ")
  
  if JY.Thing[id]["���ж��ⶾ"] < 0 then
    addvalue, str[strnum] = AddPersonAttrib(personid, "�ж��̶�", math.modf(JY.Thing[id]["���ж��ⶾ"] / 2))
  	if addvalue ~= 0 then
    	strnum = strnum + 1
 		end
 		
 		--�����壺��ʾ�нⶾ����
    if JY.Status == GAME_WMAP then
	 		if addvalue < 0 then
	 			WAR.Person[WAR.CurID]["�ⶾ����"] = -addvalue;
	 		elseif addvalue > 0 then
	 			WAR.Person[WAR.CurID]["�ж�����"] = addvalue;
	 		end
	 	end
  end
  
  ThingAddAttrib("����")
  
  if JY.Thing[id]["�ı���������"] == 2 then
    str[strnum] = "������·��Ϊ������һ"
    strnum = strnum + 1
  end

  ThingAddAttrib("����")
  ThingAddAttrib("�������ֵ")
  ThingAddAttrib("������")
  ThingAddAttrib("������")
  ThingAddAttrib("�Ṧ")
  ThingAddAttrib("ҽ������")
  ThingAddAttrib("�ö�����")
  ThingAddAttrib("�ⶾ����")
  ThingAddAttrib("��������")
  ThingAddAttrib("ȭ�ƹ���")
  ThingAddAttrib("��������")
  ThingAddAttrib("ˣ������")
  ThingAddAttrib("�������")
  ThingAddAttrib("��������")
  ThingAddAttrib("��ѧ��ʶ")
  ThingAddAttrib("��������")
  
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
	  
	  	--��ʾʹ����Ʒ����
	  	DrawString(CC.MainMenuX, CC.ScreenH-(strnum+2)*CC.Fontsmall, JY.Person[WAR.Person[WAR.CurID]["������"]]["����"].." "..str[0], C_WHITE, CC.Fontsmall);
	  	for i=1, strnum-1 do 
	  		DrawString(CC.MainMenuX, CC.ScreenH + (i-strnum-2)*CC.Fontsmall, str[i], C_WHITE, CC.Fontsmall);
	  	end
	  	
	  	ShowScreen()
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

--����ҽ����
--id1 ҽ��id2, ����id2�������ӵ���
function ExecDoctor(id1, id2)
  if JY.Person[id1]["����"] < 50 then
    return 0
  end
  local add = JY.Person[id1]["ҽ������"]
  local value = JY.Person[id2]["���˳̶�"]
  if add + 20 < value then
    return 0
  end
  
  -- ƽһָ��ҽ������ɱ�����й�
  if id1 == 28 and JY.Status == GAME_WMAP then
    add = math.modf(JY.Person[id1]["ҽ������"] * (1 + WAR.PYZ / 10))
  end
  
  --ս��״̬��ҽ��
  --�����ضԺ���ж���120�㣬����ţ�����ѹû��Ӷ���50
  if JY.Status == GAME_WMAP then
    for i,v in pairs(CC.AddDoc) do
      if v[1] == id1 then
        for wid = 0, WAR.PersonNum - 1 do
          if WAR.Person[wid]["������"] == v[2] and WAR.Person[wid]["����"] == false then
            add = add + v[3]
          end
        end
      end
    end
  end
  
  add = add - (add) * value / 200
  add = math.modf(add) + Rnd(5)
  
  local n = AddPersonAttrib(id2, "���˳̶�", -math.modf((add) / 10))
  --�����壺ҽ��ʱ��ʾ���˼���
  if JY.Status == GAME_WMAP then
	  local p = -1;
	  for wid = 0, WAR.PersonNum - 1 do
	    if WAR.Person[wid]["������"] == id2 and WAR.Person[wid]["����"] == false then
	      p = wid;
	      break;
	    end
	  end
	  WAR.Person[p]["���˵���"] = n;
	end
  
  
  return AddPersonAttrib(id2, "����", add)
end


--��������
function baseRandom(p)
	local jl = 0;

	--������+10��
	for i = 0, WAR.PersonNum - 1 do
    local pid = WAR.Person[i]["������"]
    if WAR.Person[i]["����"] == false and WAR.Person[i]["�ҷ�"] and pid == 76 and inteam(p) then
      jl = jl + 10	
    end
  end

	--����ֵ���+10��
	jl = jl + limitX(math.modf(JY.Person[p]["����"] / 800), 0, 12);
	
	--����ֵ���+20��
	jl = jl + math.modf(JY.Person[p]["�������ֵ"] * 2 / (JY.Person[p]["����"] + 100))
	
	--ʵս�ӳ�
  --��ʵս+20��
  
  local jp = math.modf(GetSZ(p) / 25 + 1)
  if jp > 20 then
    jp = 20
  end
  jl = jl + jp

 
  
  --ʯ����+10��
  if p == 38 then
    jl = jl + 10
  end
  
  for i = 1, 10 do
    if JY.Person[p]["�书" .. i] == 102 then
      jl = jl + (math.modf(JY.Person[p]["�书�ȼ�" .. i] / 100) + 1)     --̫����+10��
      break;
    end
  end
  
  --���������ӻ���
  if WAR.L_NYZH[p] ~= nil then
  	jl = jl + 20;
  end
  
  if not inteam(p) then		--���˶���Ļ���
  	jl = jl + 10;
  end
  
  return jl;
end

--��������Ĺ������������
--jl ��ʼ����
--p ������
function atkRandom(jl, p)
	
	local atk = JY.Person[p]["������"];
	--���ѹ������ӳ�
  for i,v in pairs(CC.AddAtk) do
    if v[1] == p then
      for wid = 0, WAR.PersonNum - 1 do
        if WAR.Person[wid]["������"] == v[2] and WAR.Person[wid]["����"] == false then
          atk = atk + v[3]
        end
      end
    end
  end
	
	--װ�������ӳ�
	if JY.Person[p]["����"] >= 0 then
  	atk = JY.Thing[JY.Person[p]["����"]]["�ӹ�����"];
  end
  if JY.Person[p]["����"] >= 0 then
    atk = JY.Thing[JY.Person[p]["����"]]["�ӹ�����"];
  end
  
  --�������ӳɻ���
  jl = jl + limitX(math.modf(atk / 15), 0, 40);
  
  --�������Ļ�������
  jl = jl + baseRandom(p);
  
  
  
  
  
  return jl > math.random(110);
end


--��������ķ������������
--jl ��ʼ����
--p ������
function defRandom(jl, p)
	
	local def = JY.Person[p]["������"];
	--���ѷ������ӳ�
  for i,v in pairs(CC.AddDef) do
    if v[1] == p then
      for wid = 0, WAR.PersonNum - 1 do
        if WAR.Person[wid]["������"] == v[2] and WAR.Person[wid]["����"] == false then
          def = def + v[3]
        end
      end
    end
  end
	
	--װ�������ӳ�
	if JY.Person[p]["����"] >= 0 then
  	def = JY.Thing[JY.Person[p]["����"]]["�ӷ�����"];
  end
  if JY.Person[p]["����"] >= 0 then
    def = JY.Thing[JY.Person[p]["����"]]["�ӷ�����"];
  end
  
  --�������ӳɻ���
  jl = jl + limitX(math.modf(def / 12), 0, 40);
  
  --�������Ļ�������
  jl = jl + baseRandom(p);
  
  return jl > math.random(100);
end
	
--����������Ṧ�������
--jl ��ʼ����
--p ������
function spdRandom(jl, p)
	
	local spd = JY.Person[p]["�Ṧ"];
	--�����Ṧ�ӳ�
  for i,v in pairs(CC.AddSpd) do
    if v[1] == p then
      for wid = 0, WAR.PersonNum - 1 do
        if WAR.Person[wid]["������"] == v[2] and WAR.Person[wid]["����"] == false then
          spd = spd + v[3]
        end
      end
    end
  end
	
	--װ���Ṧ�ӳ�
	if JY.Person[p]["����"] >= 0 then
  	spd = JY.Thing[JY.Person[p]["����"]]["���Ṧ"];
  end
  if JY.Person[p]["����"] >= 0 then
    spd = JY.Thing[JY.Person[p]["����"]]["���Ṧ"];
  end
  
  --�Ṧ�ӳɻ���
  jl = jl + limitX(math.modf(spd / 15), 0, 40);
  
  --�������Ļ�������
  jl = jl + baseRandom(p);
  
  return jl > math.random(110);
end

--��������Ĺ��������������������
--jl ��ʼ����
--p ������
--��������ķ������������
--jl ��ʼ����
--p ������
function atkdefRandom(jl, p)

	local atk = JY.Person[p]["������"];
	--���ѹ������ӳ�
  for i,v in pairs(CC.AddAtk) do
    if v[1] == p then
      for wid = 0, WAR.PersonNum - 1 do
        if WAR.Person[wid]["������"] == v[2] and WAR.Person[wid]["����"] == false then
          atk = atk + v[3]
        end
      end
    end
  end
	
	--װ�������ӳ�
	if JY.Person[p]["����"] >= 0 then
  	atk = JY.Thing[JY.Person[p]["����"]]["�ӹ�����"];
  end
  if JY.Person[p]["����"] >= 0 then
    atk = JY.Thing[JY.Person[p]["����"]]["�ӹ�����"];
  end
  
  --�������ӳɻ���
  local jl1 =  limitX(math.modf(atk / 15), 0, 40);
	
	local def = JY.Person[p]["������"];
	--���ѷ������ӳ�
  for i,v in pairs(CC.AddDef) do
    if v[1] == p then
      for wid = 0, WAR.PersonNum - 1 do
        if WAR.Person[wid]["������"] == v[2] and WAR.Person[wid]["����"] == false then
          def = def + v[3]
        end
      end
    end
  end
	
	--װ�������ӳ�
	if JY.Person[p]["����"] >= 0 then
  	def = JY.Thing[JY.Person[p]["����"]]["�ӷ�����"];
  end
  if JY.Person[p]["����"] >= 0 then
    def = JY.Thing[JY.Person[p]["����"]]["�ӷ�����"];
  end
  
  --�������ӳɻ���
  local jl2 = limitX(math.modf(def / 15), 0, 40);
  
  --�������
  jl = jl + math.modf((jl1+jl2)/2) + baseRandom(p);
  
  return jl > math.random(110);
end


--�����书�˺�
function War_WugongHurtLife(enemyid, wugong, level, ang, x, y)

  local pid = WAR.Person[WAR.CurID]["������"]
  local eid = WAR.Person[enemyid]["������"]
  local dng = 0
  local WGLX = JY.Wugong[wugong]["�书����"]
  
  --�Ƿ�Ϊ�Լ���
  local function DWPD()
    if WAR.Person[enemyid]["�ҷ�"] ~= WAR.Person[WAR.CurID]["�ҷ�"] then
      return true
    else
      return false
    end
  end
  
  local mywuxue = 0
  local emenywuxue = 0
  for i = 0, WAR.PersonNum - 1 do
    local id = WAR.Person[i]["������"]
    
    --��ѧ��ʶ����....
    if WAR.Person[i]["����"] == false and JY.Person[id]["��ѧ��ʶ"] > 10 then
      if WAR.Person[WAR.CurID]["�ҷ�"] == WAR.Person[i]["�ҷ�"] and mywuxue < JY.Person[id]["��ѧ��ʶ"] then
        mywuxue = JY.Person[id]["��ѧ��ʶ"]
      end
      if WAR.Person[enemyid]["�ҷ�"] == WAR.Person[i]["�ҷ�"] and emenywuxue < JY.Person[id]["��ѧ��ʶ"] then
      	emenywuxue = JY.Person[id]["��ѧ��ʶ"]
    	end
    end
    
    if emenywuxue < 50 then
      emenywuxue = 50
    end
  end
  
  --����ʵ��ʹ���书�ȼ�
  while true do
  	if JY.Person[pid]["����"] < math.modf((level + 1) / 2) * JY.Wugong[wugong]["������������"] then
   		level = level - 1
  	else
  		break;
  	end
  end

	--��ֹ�������һ���ʱ��һ�ι�����ϣ��ڶ��ι���û�������������
	if level <= 0 then
	  level = 1
	end
	
	
	
	--�����壺���ڹ����崥��
	local ht = {};		
	local num = 0;	--��ǰѧ�˶��ٸ������ڹ�
	for i = 1, 10 do
		local kfid = JY.Person[eid]["�书" .. i]
		
		--��󡹦��Ǭ����Ų�ơ��˻����Ϲ��� ���ȸ߻��ʴ�������
		if (kfid == 95 or kfid == 97 or kfid == 101) and WAR.Person[enemyid]["�ҷ�"] ~= WAR.Person[WAR.CurID]["�ҷ�"] then
			num = num + 1;
			ht[num] = {kfid,i};
		end
	end
	
	--�����ڹ����ȷ���
	if num > 0 then
		--�����ж���15%�Ļ��ʴ��������ڹ�����
		if defRandom(30, eid) or  (eid == 0 and GetS(4, 5, 5, 5) == 6 and JLSD(50, 75, 0)) then
			local n = math.random(num);
			local kfid = ht[n][1];
		
			local lv = math.modf(JY.Person[eid]["�书�ȼ�" .. ht[n][2]] / 100) + 1
			local wl = JY.Wugong[kfid]["������" .. lv];
			dng = wl;
			WAR.Person[enemyid]["��Ч����2"] = JY.Wugong[kfid]["����"] .. "����"
	  	WAR.Person[enemyid]["��Ч����"] = math.fmod(kfid, 10) + 85
	  	WAR.NGHT = kfid;
		end
	end
	
	--���û�д����ڹ������������ж���ͨ�ڹ�����
	if WAR.NGHT == 0 then
		for i = 1, 10 do
			local kfid = JY.Person[eid]["�书" .. i]
			--��󡹦��Ǭ����Ų�ơ��˻����Ϲ����׽�������񹦡�̫���񹦡������񹦣����ڻ����������������
			if kfid > 88 and kfid < 109 and kfid ~= 97 and kfid ~= 95 and kfid ~= 101 and kfid ~= 108 and kfid ~= 107 and kfid ~= 106 and kfid ~= 105 and kfid ~= 102 and WAR.Person[enemyid]["�ҷ�"] ~= WAR.Person[WAR.CurID]["�ҷ�"] then
				
					if defRandom(30, eid) or (eid == 0 and GetS(4, 5, 5, 5) == 6 and JLSD(50, 75, 0)) then
						
						local lv = math.modf(JY.Person[eid]["�书�ȼ�" .. i] / 100) + 1
						local wl = JY.Wugong[kfid]["������" .. lv]
						if dng < wl then
							dng = wl;
							WAR.Person[enemyid]["��Ч����2"] = JY.Wugong[kfid]["����"] .. "����"
				  		WAR.Person[enemyid]["��Ч����"] = math.fmod(kfid, 10) + 85
				  		WAR.NGHT = kfid;
						end
					end
			end
		end
	end
	
	--�񹦻��壬���⻤��
	ht = {};		
	num = 0;	--��ǰѧ�˶�����
	for i = 1, 10 do
		local kfid = JY.Person[eid]["�书" .. i]
		
		--�׽��̫���񹦡������񹦡������񹦣����ڻ����
		if (kfid == 108 or kfid == 102 or kfid == 105 or (kfid == 106 and (JY.Person[eid]["��������"] == 1 or  (eid == 0 and GetS(4, 5, 5, 5) == 5)))) and WAR.Person[enemyid]["�ҷ�"] ~= WAR.Person[WAR.CurID]["�ҷ�"] then
			num = num + 1;
			ht[num] = {kfid,i};
		end
	end
	
	--���ѧ����
	if num > 0 then

		local n = math.random(num);
		local kfid = ht[n][1];
		local lv = math.modf(JY.Person[eid]["�书�ȼ�" .. ht[n][2]] / 100) + 1
		local wl = JY.Wugong[kfid]["������" .. lv]
		
		--�׽�񹦻��壬������������
		if kfid == 108 and atkdefRandom(30,eid) then
			dng = dng + math.modf(wl/2) + 1000;	--��������
			WAR.L_SGHT = kfid;
			if WAR.Person[enemyid]["��Ч����1"] ~= nil then
				WAR.Person[enemyid]["��Ч����1"] = WAR.Person[enemyid]["��Ч����1"] .."+�׽�񹦻���";
			else
				WAR.Person[enemyid]["��Ч����1"] = JY.Wugong[kfid]["����"] .. "�񹦻���";
			end
			WAR.Person[enemyid]["��Ч����"] = 79

		--̫���񹦣��л��ʰ�ɱ����תΪ����ֵ
		elseif kfid == 102 and (JLSD(30,70,eid) or (eid == 38 and  JLSD(40,60,eid))) then
			WAR.L_SGHT = kfid;
			if WAR.Person[enemyid]["��Ч����1"] ~= nil then
				WAR.Person[enemyid]["��Ч����1"] = WAR.Person[enemyid]["��Ч����1"] .."+̫���񹦻���";
			else
				WAR.Person[enemyid]["��Ч����1"] = "̫���񹦻���";
			end
			WAR.Person[enemyid]["��Ч����"] = 63
		
		--�����񹦣��л��ʷ����������Σ���ƽ֮�ж��⼸�ʣ�������֮��
		elseif kfid == 105 and (JLSD(30,55,eid) or (eid == 36 and  JLSD(40,60,eid))) and eid ~= 27 then
			WAR.L_SGHT = kfid;
			if WAR.Person[enemyid]["��Ч����1"] ~= nil then
				WAR.Person[enemyid]["��Ч����1"] = WAR.Person[enemyid]["��Ч����1"] .."+��������";
			else
				WAR.Person[enemyid]["��Ч����1"] = "��������";
			end
		
		--�����񹦣��������40%���˺������ڻ��������Ч
		elseif (kfid == 106 and defRandom(30, eid)) then
			WAR.L_SGHT = kfid;
			dng = dng + 1000;
			if WAR.Person[enemyid]["��Ч����1"] ~= nil then
				WAR.Person[enemyid]["��Ч����1"] = WAR.Person[enemyid]["��Ч����1"] .."+�����񹦻���";
			else
				WAR.Person[enemyid]["��Ч����1"] = "�����񹦻���";
			end
			WAR.Person[enemyid]["��Ч����"] = 7
		end

	end
	
	--����״̬
	if WAR.Defup[eid] == 1 then
	  if WAR.Person[enemyid]["��Ч����3"] ~= nil then
	    WAR.Person[enemyid]["��Ч����3"] = WAR.Person[enemyid]["��Ч����3"] .. "+����״̬"
	  else
	    WAR.Person[enemyid]["��Ч����3"] = "����״̬"
	  end
	  if PersonKF(eid, 101) then     --��������+1000
	    dng = dng + 1000
		else
	  	dng = dng + 500
	  end
	end
	
	
	--����֮��
  --����ѡ��֪��
  --����ƽ��
  --�������ӻ��ʣ���Ϊ����û�д��бȽ���
  if eid==JY.MY and GetS(53, 0, 2, 5) == 1 and GetS(53, 0, 3, 5) == 1  then
  	local rate = limitX(math.modf(JY.Person[eid]["����"]/5 + (100-JY.Person[eid]["����"])/10 + GetSZ(eid)/50 + JY.Person[eid]["������"]/40 + JY.Person[eid]["��ѧ��ʶ"]/10),0,100);
  	local low = 25;
  	
  	--ʮ������ѣ����ӻ���
  	if GetS(53, 0, 4, 5) == 1 then
  		low = 15;
  	end
  	
  	local t = 0;
  	if JLSD(low, rate, eid) or (GetS(4, 5, 5, 5) == 6 and JLSD(low/3, rate/2, eid)) then
  		t = math.random(3)
  	end
  	
  	if t == 1 then
  		WAR.Person[enemyid]["��Ч����"] = 6
	    if WAR.Person[enemyid]["��Ч����2"] ~= nil then
	    	WAR.Person[enemyid]["��Ч����2"] = WAR.Person[enemyid]["��Ч����2"] .."+"..FLHSYL[2]
	    else
	    	WAR.Person[enemyid]["��Ч����2"] = FLHSYL[2]		--��������
	    end
	    WAR.FLHS2 = WAR.FLHS2 + 2
  	elseif t == 2 then
  		WAR.Person[enemyid]["��Ч����"] = 6
		  if WAR.Person[enemyid]["��Ч����2"] ~= nil then
	    	WAR.Person[enemyid]["��Ч����2"] = WAR.Person[enemyid]["��Ч����2"] .."+"..FLHSYL[4]		--������ɽ
	    else
	    	WAR.Person[enemyid]["��Ч����2"] = FLHSYL[4]		--������ɽ
	    end
		  WAR.FLHS4 = 1
  	elseif t == 3 and WAR.Person[enemyid]["�ҷ�"] ~= WAR.Person[WAR.CurID]["�ҷ�"] then
  		WAR.Person[enemyid]["��Ч����"] = 6
	    if WAR.Person[enemyid]["��Ч����2"] ~= nil then
	    	WAR.Person[enemyid]["��Ч����2"] = WAR.Person[enemyid]["��Ч����2"] .."+"..FLHSYL[5]		--��֪����
	    else
	    	WAR.Person[enemyid]["��Ч����2"] = FLHSYL[5]		--��֪����
	    end
	    WAR.ACT = 10
	    WAR.ZYHB = 0
	    WAR.FLHS5 = 1
  	end
  end
	
	--���޼� �����񹦻���
	if eid == 9 and WAR.Person[enemyid]["��Ч����2"] == nil and PersonKF(9, 106) then
	  WAR.Person[enemyid]["��Ч����"] = math.fmod(106, 10) + 85
	  WAR.Person[enemyid]["��Ч����2"] = "�����񹦻���"
	  dng = dng + 1000
	end
	
	--�Ƿ� ����������
	if eid == 50 and WAR.Person[enemyid]["��Ч����2"] == nil then
	  WAR.Person[enemyid]["��Ч����"] = 53
	  WAR.Person[enemyid]["��Ч����2"] = "����������"
	  dng = dng + 1500
	end
	
	--�Ħ��  С���๦����
	if eid == 103 then
	  WAR.Person[enemyid]["��Ч����"] = math.fmod(98, 10) + 85
	  WAR.Person[enemyid]["��Ч����2"] = "С���๦����"
	  dng = dng + 1000
	end
	
	--�ɍ� ��Ԫ����������
	if eid == 18 then
	  WAR.Person[enemyid]["��Ч����2"] = "��Ԫ����������"
	  WAR.Person[enemyid]["��Ч����"] = math.fmod(106, 10) + 85
	  dng = dng + 1200
	end
	
	--brolycjw: �ܲ�ͨ
    if eid == 64 then
      WAR.Person[enemyid]["��Ч����"] = 66
      WAR.Person[enemyid]["��Ч����2"] = "�����񹦻���"
      dng = dng + 1500
    end
	
	--brolycjw: ���߹�
    if eid == 69 and WAR.ZDDH ~= 188 then
      WAR.Person[enemyid]["��Ч����"] = 67
      WAR.Person[enemyid]["��Ч����2"] = "��������"
      dng = dng + 1500
    end
 
	--brolycjw: ��ҩʦ
    if eid == 57 then
      WAR.Person[enemyid]["��Ч����"] = 95
      WAR.Person[enemyid]["��Ч����2"] = "���Ű���"
      dng = dng + 1500
    end
	
	--brolycjw: л�̿�
    if eid == 164 then
      WAR.Person[enemyid]["��Ч����"] = 23
      WAR.Person[enemyid]["��Ч����2"] = "Ħ���ʿ"
      dng = dng + 1500
    end
	
		--brolycjw: �������
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
	
	--������  ���¡�ͬ��
	if eid == 26 then
	  WAR.Person[enemyid]["��Ч����"] = 6
	  WAR.Person[enemyid]["��Ч����2"] = "���¡�ͬ��"
	  dng = dng + 1200
	end
	
	--��ڤ��
	if (PersonKF(eid, 85) or T1LEQ(eid)) and JLSD(30, 70, eid) or eid == 118 then
	  if WAR.Person[enemyid]["��Ч����"] == -1 then
	    WAR.Person[enemyid]["��Ч����"] = 85
	  end
	  if WAR.Person[enemyid]["��Ч����2"] == nil then
	    WAR.Person[enemyid]["��Ч����2"] = "��ڤ����"
	  else
	    WAR.Person[enemyid]["��Ч����2"] = WAR.Person[enemyid]["��Ч����2"] .. "+" .. "��ڤ����"
	    dng = dng + 800
	  end
	  WAR.B_BMJQ = 1;
	end
	
	--��ת����
  for i = 1, 10 do
    local kfid = JY.Person[eid]["�书" .. i]
    if kfid == 43 and JY.Person[eid]["����"] > 10 and WAR.Person[enemyid]["�����书"] == -1 and WAR.Person[enemyid]["�ҷ�"] ~= WAR.Person[WAR.CurID]["�ҷ�"] and ((not JLSD(30, 70, eid)) or (eid == 51 and JLSD(20, 80, eid)) or (WAR.tmp[1000 + eid] == 1 and JLSD(30, 70, eid))) then
      local p = JY.Person[eid]
      local dzlv = p["ȭ�ƹ���"] + p["��������"] + p["ˣ������"] + p["�������"]
      local dzwz = nil
      if dzlv >= 300 or eid == 51 then      
        dzwz = "��ϲ���"			--��ϲ���
        WAR.DZXYLV[eid] = 3
      elseif dzlv >= 220 then
        dzwz = "��ת����"			--��ת����
        WAR.DZXYLV[eid] = 2
      else
        dzwz = "�����Ƴ�"			--�����Ƴ�
        WAR.DZXYLV[eid] = 1
      end
      if WAR.Person[enemyid]["��Ч����2"] ~= nil then
        WAR.Person[enemyid]["��Ч����2"] = WAR.Person[enemyid]["��Ч����2"] .. "+" .. dzwz
      else
        WAR.Person[enemyid]["��Ч����2"] = dzwz
      end
      if WAR.Person[enemyid]["��Ч����"] == nil then
        WAR.Person[enemyid]["��Ч����"] = math.fmod(kfid, 10) + 85
      end
      WAR.Person[enemyid]["�����书"] = wugong
      JY.Person[eid]["����"] = JY.Person[eid]["����"] - 3
      break;
    end
  end
  
  --�����ܵ����˺�
  local hurt = nil
  if level > 10 then
    hurt = JY.Wugong[wugong]["������" .. 10] / 3
    level = 10
  else
    hurt = JY.Wugong[wugong]["������" .. level] / 4
  end
  
  
  --��ϵ�����鵶��������˺�(����ʮ��
  if wugong == 64 and pid == 0 and GetS(4, 5, 5, 5) == 3 then
    hurt = hurt + math.modf(GetS(14, 3, 1, 4) / 3 + 1)
  end
  
  --����װ���˺��ӳ�
  for i,v in ipairs(CC.ExtraOffense) do
    if v[1] == JY.Person[pid]["����"] and v[2] == wugong then
      hurt = hurt + v[3] / 4
    end
  end
  
  --̫��ȭ����������
  if wugong == 16 and WAR.tmp[3000 + pid] ~= nil and WAR.tmp[3000 + pid] > 0 then
    if WAR.tmp[3000 + pid] > 200 then
      WAR.tmp[3000 + pid] = 200
    end
    hurt = hurt + WAR.tmp[3000 + pid]
    WAR.tmp[3000 + pid] = 0
  end
  
  --
  local atk = JY.Person[pid]["������"]
  local def = JY.Person[eid]["������"]
  if JY.Status == GAME_WMAP then
  
  	--���ѹ������ӳ�
    for i,v in pairs(CC.AddAtk) do
      if v[1] == pid then
        for wid = 0, WAR.PersonNum - 1 do
          if WAR.Person[wid]["������"] == v[2] and WAR.Person[wid]["����"] == false then
            atk = atk + v[3]
          end
        end
      end
    end
    
    --���ѷ������ӳ�
    for i,v in pairs(CC.AddDef) do
      if v[1] == eid then
        for wid = 0, WAR.PersonNum - 1 do
          if WAR.Person[wid]["������"] == v[2] and WAR.Person[wid]["����"] == false then
            def = def + v[3]
          end
        end
      end
    end
  end
  
  local function getnl(id)
    return (JY.Person[id]["����"] * 2 + JY.Person[id]["�������ֵ"]) / 3
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
  
  --�����壺���ʹ�õĲ������𽣷����ͷ����𽣷��ļӳ�
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
  
  --�����˺�����
  if JY.Person[pid]["����"] >= 0 then
    hurt = hurt + myrnd(JY.Thing[JY.Person[pid]["����"]]["�ӹ�����"])
  end
  if JY.Person[pid]["����"] >= 0 then
    hurt = hurt + myrnd(JY.Thing[JY.Person[pid]["����"]]["�ӹ�����"])
  end
  if JY.Person[eid]["����"] >= 0 then
    hurt = hurt - myrnd(JY.Thing[JY.Person[eid]["����"]]["�ӷ�����"])
  end
  if JY.Person[eid]["����"] >= 0 then
    hurt = hurt - myrnd(JY.Thing[JY.Person[eid]["����"]]["�ӷ�����"])
  end
  
  --�������������˺�����
  hurt = hurt - (def) / 12
  hurt = hurt - (dng) / 30 + JY.Person[pid]["����"] / 5 - JY.Person[eid]["����"] / 5 + JY.Person[eid]["���˳̶�"] / 3 - JY.Person[pid]["���˳̶�"] / 3 + JY.Person[eid]["�ж��̶�"] / 2 - JY.Person[pid]["�ж��̶�"] / 2
  
  --�����˺�����
  if inteam(pid) then
    local offset = math.abs(WAR.Person[WAR.CurID]["����X"] - WAR.Person[enemyid]["����X"]) + math.abs(WAR.Person[WAR.CurID]["����Y"] - WAR.Person[enemyid]["����Y"])
    if offset < 10 then
      hurt = (hurt) * (100 - (offset - 1) * 3) / 100
    end
  else
    hurt = hurt * 2 / 3
  end
  
  --����
  if WAR.BJ == 1 then
    local SLWX = 0
    for i = 1, 10 do
      if JY.Person[eid]["�书" .. i] == 106 or JY.Person[eid]["�书" .. i] == 107 then
        SLWX = SLWX + 1
      end
    end
    
    if JY.Person[eid]["��������"] == 2 or eid == 0 and GetS(4, 5, 5, 5) == 5 then
      SLWX = SLWX + 1
    end
    if SLWX == 3 then
      WAR.Person[enemyid]["��Ч����"] = 6
      if WAR.Person[enemyid]["��Ч����2"] ~= nil then
        WAR.Person[enemyid]["��Ч����2"] = WAR.Person[enemyid]["��Ч����2"] .. "+ɭ������"    --ɭ������
	    else
	      WAR.Person[enemyid]["��Ч����2"] = "ɭ������"
	    end
    --������ �����˺��ӱ�
    elseif pid == 44 or pid == 98 or pid == 99 or pid == 100 then
    	hurt = hurt * 2
	  else
	    hurt = math.modf(hurt * 1.5)
	  end
  end
  
  --�����壺��ɽ�������˺��ӳ�
  if WAR.L_NSDF[eid] ~= nil then
  	hurt = hurt * 2;
  	ang = ang * 2;
  	WAR.L_NSDF[eid] = nil;
  end

	--�����壺��ɽ��������
	if WAR.L_NSDFCC == 1 and DWPD() then
		WAR.L_NSDF[eid] = 1;
	end 
	
	--�����壺ȼľ��������ͨ�ڹ��������������˺�
	if wugong == 65 and WAR.NGJL > 0 then
		hurt  = hurt + math.modf(JY.Wugong[WAR.NGJL]["������10"]/12);
	end
  

  --�Ƿ�
  if pid == 50 then
    hurt = math.modf(hurt * 1.5)
  end
  
  --лѷ
  if eid == 13 then
    hurt = math.modf(hurt * 0.6)
  end
  
  --����
  if pid == 37 and JY.Person[0]["Ʒ��"] > 70 then
    hurt = math.modf((1 + (JY.Person[0]["Ʒ��"] - 70) / 100) * hurt)
  end
  
  --��Ӣ
  if pid == 63 and JY.Person[pid]["����"] < math.modf(JY.Person[pid]["�������ֵ"] / 2) then
    hurt = math.modf(hurt * 1.2)
  end
  
  --brolycjw: ������
  if pid == 39 then
    hurt = math.modf(hurt * 1.2)
  end
  
 --brolycjw: ľ����
  if eid == 40 then
    hurt = math.modf(hurt * 0.8)
  end
  
  --�����ϱ�
  if WAR.DJGZ == 1 then
    hurt = math.modf(hurt * 1.3)
  end
  
  --÷���繥��
  if WAR.MCF == 1 then
    hurt = math.modf(hurt * 2)
  end
  
  --����ˣ������֣�����
  if WAR.TFH == 1 then
    hurt = math.modf(hurt * 1.2)
  end
  
  --�����࣬ʹ�����𽣷�
  if WAR.WQQ == 1 then
    hurt = math.modf(hurt * (1 + math.random(200) / 100))
  end
  
  --�ܲ�ͨ
  if pid == 64 then
    hurt = math.modf(hurt * (1 + WAR.ZBT / 10))
  end
  
  --ȭϵ����
  if WAR.LXZQ == 1 then
    hurt = math.modf(hurt * 1.3)
  end
  
  --������ ��Ů�Ĺ����ӳ�
  if pid == 82 then
    local s = 0
    for j = 0, WAR.PersonNum - 1 do
      if WAR.Person[j]["����"] == false and WAR.Person[j]["�ҷ�"] == WAR.Person[WAR.CurID]["�ҷ�"] and JY.Person[WAR.Person[j]["������"]]["�Ա�"] == 1 then
        s = s + 1
      end
    end
    hurt = math.modf(hurt * (1 + (s) / 3))
  end
  
  
  --����ȭϵ��ѧȭ���˺��ӳ�
  if GetS(4, 5, 5, 5) == 1 and pid == 0 then
    local lxzq = 0
    for i = 1, 10 do
      if (JY.Person[0]["�书" .. i] == 109 or JY.Person[0]["�书" .. i] == 49 or (JY.Person[0]["�书" .. i] <= 26 and JY.Person[0]["�书" .. i] > 0)) and JY.Person[0]["�书�ȼ�" .. i] == 999 then
        lxzq = lxzq + 1
      end
    end
    hurt = math.modf(hurt * (1 + 0.05 * (lxzq)))
  end
  
  --���ǵ�ϵ�������ӳ�
  if GetS(4, 5, 5, 5) == 3 and eid == 0 then
    local askd = 0
    for i = 1, 10 do
      if (JY.Person[0]["�书" .. i] == 111 or (JY.Person[0]["�书" .. i] <= 67 and JY.Person[0]["�书" .. i] >= 50)) and JY.Person[0]["�书�ȼ�" .. i] == 999 then
        askd = askd + 1
      end
    end
    hurt = math.modf(hurt * (1 - 0.05 * (askd)))
  end
  
  --�����ᣬ��������ɺ�书�����ӳ�
  if (WAR.ZDDH == 118 and pid ~= 5) or pid == 79 then
    local JF = 0
    for i = 1, 10 do
      if JY.Person[79]["�书" .. i] < 50 and JY.Person[79]["�书" .. i] > 26 and JY.Person[79]["�书�ȼ�" .. i] == 999 then
        JF = JF + 1
      end
    end
    hurt = math.modf(hurt * (1 + 0.05 * (JF)))
  end
  
  --�����ͻ���ͩ ��ս��ʱ���˺�����10%
  if not inteam(pid) then
    for j = 0, WAR.PersonNum - 1 do
      if (WAR.Person[j]["������"] == 87 or WAR.Person[j]["������"] == 74) and WAR.Person[j]["����"] == false and WAR.Person[j]["�ҷ�"] ~= WAR.Person[WAR.CurID]["�ҷ�"] then
        hurt = math.modf(hurt * 0.9)
      end
    end
  end
  
  --���� �ѷ������˺����10%
  if inteam(pid) then
    for j = 0, WAR.PersonNum - 1 do
      if (WAR.Person[j]["������"] == 86 or WAR.Person[j]["������"] == 80) and WAR.Person[j]["����"] == false and WAR.Person[j]["�ҷ�"] == WAR.Person[WAR.CurID]["�ҷ�"] then
        hurt = math.modf(hurt * 1.1)
      end
    end
  end
  
  --��������������˺�
  --��
  if WAR.L_MJJF == 1 then
  	hurt = hurt + 50;	
  	if JY.Person[pid]["����"] == 37 then
  		hurt = hurt + 50;
  	end
  end
  
  
	--�����壺��̫�����������ĵ��ˣ�����ʱ���������ӱ�
  if WAR.L_SGJL == 102 then
  	if WAR.Person[WAR.CurID]["�ҷ�"] ~= WAR.Person[enemyid]["�ҷ�"] then
  		WAR.L_TXSG[eid] = 1;
  	end
  end
  
  --�����壺����������ʹ����צ�ֹ����ĵ��ˣ��»غϲ����ƶ�
  if wugong == 20 and JY.Person[pid]["��������"] == 1 and WAR.Person[WAR.CurID]["�ҷ�"] ~= WAR.Person[enemyid]["�ҷ�"] then
  	WAR.L_NOT_MOVE[eid] = 1;
  end
  
  --�����壺����������ʹ��ӥצ�������ĵ��ˣ��»غϲ����ƶ�
  if wugong == 4 and JY.Person[pid]["��������"] == 0 and WAR.Person[WAR.CurID]["�ҷ�"] ~= WAR.Person[enemyid]["�ҷ�"] then
  	WAR.L_NOT_MOVE[eid] = 1;
  end
 
  --�����壺��ϼ��ʹ�ý�ϵ�书�˺��ӳ�
  if WAR.L_ZXSG == 2 then
  	hurt = math.modf(hurt*1.1);
  end
  
  --�����壺�ﲮ�⣬ʹ�ý�ɫָ�������˺�����������
  if eid == 29 and WAR.L_TBGZL == 2 then
  	if WAR.Person[enemyid]["��Ч����2"] ~= nil then
  		WAR.Person[enemyid]["��Ч����2"] = WAR.Person[enemyid]["��Ч����2"] .. "�����ɲ���"
  	else
  		WAR.Person[enemyid]["��Ч����2"] = "���ɲ���"
  	end
  	hurt = math.modf(hurt*0.9);
  	dng = dng + 500;
  end
  
  --���������߶�����ƺ���Ч  ��Ϊ70%�Ļ����϶�30��
  if pid == 138 then
    if JLSD(25, 95, 138) then
    	AddPersonAttrib(eid,"�ж��̶�", 30);
    	WAR.Person[WAR.CurID]["��Ч����3"] = RWWH[138];  	
		end
  end
  
  --С�ձ� �����˺����
  if WAR.BSMT == 1 then
    hurt = math.modf(hurt + 100 + math.random(50))
  end
  
  --��ת�����˺���ɱ��������
  if WAR.DZXYLV[pid] ~= nil and WAR.DZXYLV[pid] > 10 then
    hurt = math.modf(hurt * WAR.DZXYLV[pid] / 100)
    ang = ang + WAR.DZXYLV[pid] * 10
  end
  
  --�����߻�
  if WAR.tmp[1000 + pid] == 1 and inteam(pid) then
    hurt = math.modf(hurt * 1.4)
  end
  
  --��ʦ�����˵���
  if WAR.ZSJT == 1 and pid == JY.MY and GetS(53, 0, 2, 5) == 3 and WAR.Person[enemyid]["�ҷ�"] ~= WAR.Person[WAR.CurID]["�ҷ�"] and (JY.Person[pid]["����"] > JY.Person[eid]["����"] or math.random(100)>50) then
    local x1 = WAR.Person[enemyid]["����X"] - x
  	local y1 = WAR.Person[enemyid]["����Y"] - y
  	
  	local x2, y2 = WAR.Person[enemyid]["����X"], WAR.Person[enemyid]["����Y"];
    
    
		if x1 > 0 then
			x2 = WAR.Person[enemyid]["����X"] + 1
		elseif x1 < 0 then
			x2 = WAR.Person[enemyid]["����X"] - 1
		end
		
		if y1 > 0 then
			y2 = WAR.Person[enemyid]["����Y"] + 1
		elseif y1 < 0 then
			y2 = WAR.Person[enemyid]["����Y"] - 1
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
  

  --�����ˣ������˺�����
  if inteam(pid) then
    hurt = math.modf(hurt * (1 - JY.Person[pid]["���˳̶�"] * 0.002))
  end
  
  --���ˣ��������˺����
  if inteam(eid) then
    hurt = math.modf(hurt * (1 + JY.Person[pid]["���˳̶�"] * 0.0015))
  end
  
  --������
  if pid == 5 and WAR.ZDDH > 220 then
    hurt = math.modf(hurt * 1.1)
  end
  
  --�����ᣬ����Ϊ��
  if WAR.ZSF2 == 1 then
    hurt = math.modf(hurt * 1.2)
  end
  
  --ŷ����  �����˺�����
  if pid == 60 and WAR.ZDDH == 171 then
    hurt = math.modf(hurt * 0.75)
  end
  
  --ŷ����  �����˺����
  if eid == 60 and WAR.ZDDH == 171 then
    hurt = math.modf(hurt * 1.2)
  end
  

  
  --����ʥʹ ʥ����
  if WAR.ZDDH == 14 and (pid == 173 or pid == 174 or pid == 175) then
    local shz = 0
    for j = 0, WAR.PersonNum - 1 do
      if WAR.Person[j]["����"] == false and WAR.Person[j]["�ҷ�"] == WAR.Person[WAR.CurID]["�ҷ�"] then
        shz = shz + 1
      end
    end
    if shz == 3 then
    	hurt = math.modf(hurt * 1.5)
    	ang = ang + 1000
 		end
  end
  
  --��˹��ʥʹ
  if WAR.ZDDH == 14 and (eid == 173 or eid == 174 or eid == 175) then
    local shz = 0
    for j = 0, WAR.PersonNum - 1 do
      if WAR.Person[j]["����"] == false and WAR.Person[j]["�ҷ�"] == WAR.Person[enemyid]["�ҷ�"] then
        shz = shz + 1
      end
    end
    if shz == 3 then
    	hurt = math.modf(hurt * 0.5)
    	dng = dng + 1000
  	end
  end
  
  
  --ȫ�����ӣ�������������˺�������
  if WAR.ZDDH == 73 then
    local num = 0
    for j = 0, WAR.PersonNum - 1 do
      if WAR.Person[j]["����"] == false and WAR.Person[j]["�ҷ�"] == WAR.Person[WAR.CurID]["�ҷ�"] and WAR.Person[WAR.CurID]["�ҷ�"] == false then
        num = num + 1
      end
    end
    for n=1, num do
    	hurt = math.modf(hurt * (1+0.04))
    	ang = ang + 100
    end
  end
  
  --ȫ�����ӣ�������󣬼����˺�����������
  if WAR.ZDDH == 73 then
    local num = 0
    for j = 0, WAR.PersonNum - 1 do
      if WAR.Person[j]["����"] == false and WAR.Person[j]["�ҷ�"] == WAR.Person[enemyid]["�ҷ�"] and WAR.Person[enemyid]["�ҷ�"] == false then
        num = num + 1
      end
    end
    for n=1, num do
    	hurt = math.modf(hurt * (1-0.03))
    	dng = dng + 100
    end
  end
  
  --��������
  if WAR.HDWZ == 1 then
    hurt = math.modf(hurt + 50)
    JY.Person[eid]["�ж��̶�"] = JY.Person[eid]["�ж��̶�"] + 15
	  if JY.Person[eid]["�ж��̶�"] > 100 then
	    JY.Person[eid]["�ж��̶�"] = 100
	  end
	end
	
	--ɨ����ɮ �˺�����40%
  if eid == 114 then
    hurt = math.modf(hurt * 0.7)
  end
  
  
  local defadd = 0
  local wgtype = JY.Wugong[wugong]["�书����"];
  if wgtype == 5 then
    wgtype = math.random(4)
  end
  if wgtype == 1 then
    defadd = JY.Person[eid]["ȭ�ƹ���"]
  elseif wgtype == 2 then
    defadd = JY.Person[eid]["��������"]
  elseif wgtype == 3 then
    defadd = JY.Person[eid]["ˣ������"]
  elseif wgtype == 4 then
    defadd = JY.Person[eid]["�������"]
  end
  
  hurt = math.modf(hurt * limitX(1.2 - defadd / 240, 0.2, 1.2))
  if eid == 35 and GetS(10, 1, 1, 0) == 1 and JLSD(15, 85, eid) and WAR.Person[enemyid]["�ҷ�"] ~= WAR.Person[WAR.CurID]["�ҷ�"] then
    if JY.Wugong[wugong]["�书����"] == 1 then
      WAR.Person[enemyid]["��Ч����3"] = "�ش�������ʽ"
    elseif JY.Wugong[wugong]["�书����"] == 2 then
      WAR.Person[enemyid]["��Ч����3"] = "�ش����ƽ�ʽ"
    elseif JY.Wugong[wugong]["�书����"] == 3 then
      WAR.Person[enemyid]["��Ч����3"] = "�ش����Ƶ�ʽ"
    elseif JY.Wugong[wugong]["�书����"] == 4 then
      WAR.Person[enemyid]["��Ч����3"] = "�ش����ƹ�ʽ"
    elseif JY.Wugong[wugong]["�书����"] == 5 then
      WAR.Person[enemyid]["��Ч����3"] = "�ش�������ʽ"
    end
    WAR.Person[enemyid]["��Ч����"] = 83
    hurt = math.modf(hurt * (4 + math.random(3)) / 10)
  end
  
  --�Ƿ� �ܵ��˺�����
  if eid == 50 then
    hurt = math.modf(hurt * 0.9)
    local minhurt = math.modf(hurt / 2)
    hurt = math.modf(hurt * JY.Person[eid]["����"] / JY.Person[eid]["�������ֵ"])
    if hurt < minhurt then
    	hurt = minhurt
  	end
  end
  
  --��������
  if WAR.Actup[pid] ~= nil and WAR.DZXY ~= 1 then
    if PersonKF(pid, 103) then         --������
      hurt = math.modf(hurt * 1.4)
    else
    	hurt = math.modf(hurt * 1.25)
    end
  end


	  
  	--brolycjw: �޺���ħ�񹦼���ʱɱ�����˺�����, �ܵ�ǰ�������书��������Ӱ��
	if WAR.NGJL == 96 then
		local nlmod = JY.Person[pid]["����"]/4000
		local wgmod = JY.Wugong[wugong]["������������"]/200
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
	
	--�����壺�������˺����30%
	if WAR.L_NYZH[pid] ~= nil then
		hurt = math.modf(hurt * 1.3);
	end
	
	--�����壺���ڹ����壬�����ڹ�
  --��󡹦�����������������������+1000��
  if WAR.NGHT == 95 then
  	
  	if WAR.tmp[200 + eid] == nil or WAR.tmp[200 + eid] == 0 then
  		WAR.tmp[200 + eid] = 50;
  	else
  		WAR.tmp[200 + eid] = WAR.tmp[200 + eid] + 35;
  	end
  	
  	WAR.Person[enemyid]["��Ч����2"] = WAR.Person[enemyid]["��Ч����2"] .. "���������";
  	dng = dng + 1000;
  	if WAR.tmp[200 + eid] >= 100 then
  		dng = dng + 1000;
  	end
  end
  

  --�����񹦼�������������40%���˺�
  if WAR.L_SGJL == 107 then
  	hurt = math.modf(hurt*1.4);
  	ang = math.modf(ang * 1.3)
  end
	
	
  --����״̬
  if WAR.Defup[eid] == 1 then
    if PersonKF(eid, 101) then
      hurt = math.modf(hurt * 0.6)
    else
    	hurt = math.modf(hurt * 0.75)
    end
  end
  
  --��������ʱ������20%���˺�
  if WAR.Actup[eid] ~= nil and PersonKF(eid, 103) then
     hurt = math.modf(hurt * 0.8)
  end
  
  --�����壺���������������˺�
  if WAR.L_WYJFA > 0 then
  	hurt = math.modf(hurt * 1.2)
  end
  
  --��ʦ�����׵ؼӳ�
  local jxjc = GetWarMap(WAR.Person[enemyid]["����X"], WAR.Person[enemyid]["����Y"],6);
  if jxjc == 1 then		 --��
  	hurt = math.modf(hurt * 0.8)
  	dng = math.modf(dng*1.2);
  elseif jxjc == 2 then		--��
  	hurt = math.modf(hurt * 1.2)
  	ang = math.modf(ang * 1.2)
  elseif jxjc == 3 then		--��
  	hurt = math.modf(hurt * 0.5)
  	dng = math.modf(dng*1.5);
  elseif jxjc == 4 and WAR.Person[enemyid]["�ҷ�"] == false then		--���ף��ҷ������ܴ���
  	hurt = math.modf(hurt * 1.4)
  	ang = math.modf(ang * 1.4)
  end
  
  
  
  --��ʦ ���Ѻ󱻹����л���ת�����׵�
	if GetS(53, 0, 2, 5) == 3 and GetS(53, 0, 4, 5) == 1 and jxjc ~= 3 and WAR.Person[enemyid]["�ҷ�"] and math.random(100)>50 then
		WAR.Person[enemyid]["��Ч����2"] = "����Ϊ��";
		if math.random(10) > 3 then
			SetWarMap(WAR.Person[enemyid]["����X"], WAR.Person[enemyid]["����Y"],6, 1)
		else
			SetWarMap(WAR.Person[enemyid]["����X"], WAR.Person[enemyid]["����Y"],6, 3)
		end
	end
  
  
  --�������˺�����
  --���ǽ���������
  if WAR.ACT > 1 and pid ~= 27 and wugong ~= 114 then
    hurt = math.modf(hurt * 0.7)
    ang = math.modf((ang) * 0.7)
  end
  
  
  local hurt2 = 0
  local hurt2js = 0
  --�Ѷ��ж�
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
  
  --�Ѷ����������˺�
  if not inteam(pid) and JY.Thing[202][WZ7] > 2 then
    hurt = math.modf(hurt * (1 + JY.Thing[202][WZ7]/40))
  end
  
  --��ʦ��������ʱ���л��ʷ���������Ч
  if eid==JY.MY and GetS(53, 0, 2, 5) == 3 then 
  	local rate = 30 + JY.Person[eid]["����"]/10 + JY.Person[eid]["��ѧ��ʶ"]/5 + GetSZ(eid)/100;
  	if GetS(53, 0, 4, 5) == 1 then
  		rate = rate + 10;
  	end
  	if rate > math.random(100) then
  		WAR.Person[enemyid]["��Ч����"] = 90
  		
  		if GetS(53, 0, 4, 5) == 1 and math.random(100) > 40 then
  			WAR.Person[enemyid]["��Ч����2"] = "��-���в���"
  			hurt = math.modf(hurt*(0.2 - Rnd(1)/10));
  			ang = math.modf(ang*(0.2 - Rnd(1)/10));
  		else
  			WAR.Person[enemyid]["��Ч����2"] = "���в���"
  			hurt = math.modf(hurt * (0.6-math.random(3)/10))
  			dng = math.modf(dng*(2 + math.random(5)/10));
  		end
  	end
  end
  
  --�����壺������Ϭ��ȭ ����״̬��ÿ��ȭ���������������ܵ���5%�˺���10%����
  if WAR.Actup[eid] ~= nil and eid == 0 and GetS(4, 5, 5, 5) == 1 then
  	local lxzq = 0
    for i = 1, 10 do
      if (JY.Person[0]["�书" .. i] == 109 or JY.Person[0]["�书" .. i] == 49  or (JY.Person[0]["�书" .. i] <= 26 and JY.Person[0]["�书" .. i] > 0)) and JY.Person[0]["�书�ȼ�" .. i] == 999 then
        lxzq = lxzq + 1
      end
    end
    hurt = math.modf(hurt * (1 - 0.05 * (lxzq)));
    ang = math.modf(ang * (1 - 0.1 * (lxzq)));
    if WAR.Person[enemyid]["��Ч����2"] ~= nil then
    	WAR.Person[enemyid]["��Ч����2"] = WAR.Person[enemyid]["��Ч����2"] .. "+��ȭ��������"
    else
    	WAR.Person[enemyid]["��Ч����2"] = "��ȭ��������"
    end
  end
  
  --�˻����Ϲ���������һ���˺��������˺�,����б�ڤ�����������������һ��
  if WAR.NGHT == 101 and WAR.B_BMJQ == 1 then
		
		hurt = math.modf(hurt/2);
  	WAR.Person[enemyid]["��������"] = (WAR.Person[enemyid]["��������"] or 0)+hurt;
  	AddPersonAttrib(eid, "����", hurt);
  elseif WAR.NGHT == 101 then
  	if JY.Person[eid]["����"] < math.modf(hurt/2) then
  		hurt = math.modf(hurt-JY.Person[eid]["����"] - hurt/4);
  	else
  		hurt = math.modf(hurt/2);
  	end
  	WAR.Person[enemyid]["��������"] = (WAR.Person[enemyid]["��������"] or 0)-2*hurt;
  	AddPersonAttrib(eid, "����", -2*hurt);
  end
  
  --��������
  if eid == JY.MY and GetS(53, 0, 2, 5) == 2 then
  	local rate = JY.Thing[238]["�辭��"]/30 + JY.Person[eid]["����"]/15 + JY.Person[eid]["��ѧ��ʶ"]/20 + JY.Person[eid]["����"]/1000 + JY.Person[eid]["������"]/100 + GetSZ(eid)/100
  	
  	--�����ڻ�������ʱ���ӻ���
  	if JLSD(0,rate,eid) or (GetS(4, 5, 5, 5) == 6 and GetS(53, 0, 5, 5) == 1 and JLSD(0,30,eid)) then
  		local t = math.random(2);
  		
  		--����ʱ���Ӿ���
  		if WAR.tmp[8002] == nil then
  			WAR.tmp[8002] = 0;
	  	end
	  	WAR.tmp[8002] = WAR.tmp[8002] + math.random(3);
  		
  		if t == 1 then
  			hurt = math.modf(hurt * 0.3)
  			dng = math.modf(dng * 0.6);
  			WAR.Person[enemyid]["��Ч����2"] = "�����ػ�"	
	    	WAR.Person[enemyid]["��Ч����"] = 88
	    	
	    	for j = 0, WAR.PersonNum - 1 do
          if WAR.Person[j]["����"] == false and WAR.Person[j]["�ҷ�"] == WAR.Person[enemyid]["�ҷ�"] then
            WAR.Person[j].Time = WAR.Person[j].Time + 100
          end
          if WAR.Person[j].Time > 980 then
            WAR.Person[j].Time = 980
          end
        end
  		else
  			hurt = math.modf(hurt * 0.6)
  			dng = math.modf(dng * 0.3);
  			WAR.Person[enemyid]["��Ч����2"] = "�����ȼ�"	
	    	WAR.Person[enemyid]["��Ч����"] = 89
	    	
	    	WAR.FLHS2 = WAR.FLHS2 + 3
  		end
  	end
  	
  	if GetS(53, 0, 5, 5) == 1 and JLSD(0,rate/2,eid) then
  		hurt = 0
	    WAR.Person[enemyid]["��Ч����2"] = "��������"
	    WAR.Person[enemyid]["��Ч����"] = 87
	    WAR.ACT = 10
		  WAR.ZYHB = 0
  	end
  	
  	
  	
  end
  
  
  if WAR.LHQ_BNZ == 1 then		--������ �˺�+50
    hurt = hurt + 50
  end
  if WAR.JGZ_DMZ == 1 then		--��Ħ�� �˺�+100
    hurt = hurt + 100
  end
  
  --�����壺������ܹ���ʱ������X�仯
	 if pid == 592 then
		 if WAR.L_DGQB_X < 8 then
			hurt = math.modf(hurt*(WAR.L_DGQB_X/5));
		 else
			hurt = math.modf(hurt*(1 + WAR.L_DGQB_X/10));
		 end
	 end
  
  --�����壺����ȭ���������˵�Ŀ����ɶ����˺�������Ŀ���������ӣ������˺�Ҳ��֮���ӡ������˺����ܵ�����Ӱ�죬���Լ�����ֵ����4000ʱ�����л����ܵ����ˡ�
  if wugong == 23 then
  	if JY.Person[eid]["���˳̶�"] > 0 then
  		hurt = hurt + math.modf(JY.Person[eid]["���˳̶�"]*3/2);
  		if JY.Person[pid]["����"] < 4000 and JLSD(0, math.modf(4000-JY.Person[pid]["����"])) then
  			AddPersonAttrib(pid, "���˳̶�", 10);
  		end
  	end
  end
  
  
  --Ǭ����Ų�Ʒ����������˺��������ܵ����˺�
  if WAR.NGHT == 97 then
    WAR.fthurt = 0
    
    
    local nydx = {}
    local nynum = 1
    for i = 0, WAR.PersonNum - 1 do
      if WAR.Person[i]["�ҷ�"] ~= WAR.Person[enemyid]["�ҷ�"] and WAR.Person[i]["����"] == false then
        nydx[nynum] = i
        nynum = nynum + 1
      end
    end
    
    local nyft = nydx[math.random(nynum - 1)]
    local nyft2 = nydx[math.random(nynum - 1)]
    
    --�������˺��������ߵ�����ֵ�ж�
    local nl = limitX(math.modf((JY.Person[eid]["����"] - JY.Person[WAR.Person[nyft]["������"]]["����"])/100), 0, 30);
    local jl = 30 - nl;
    local h = 0;
    
    --���޼ɱط�����������ɫ�л��ʷ�����������ʱֻ����20%�˺�
    if (jl > math.random(100) or  WAR.L_QKDNY[WAR.Person[nyft]["������"]] ~= nil) and eid ~= 9  then
    	hurt = math.modf((hurt) * 0.6)
    	if WAR.Person[nyft]["��Ч����"] == -1 then
    		WAR.Person[nyft]["��Ч����"] = 85;
    	end
    	WAR.Person[nyft]["��Ч����2"] = "��������"
    else
    	if eid == 9 then		--���޼ɷ�һ���˺�
      	WAR.fthurt = math.modf(hurt*0.7)			
      	hurt = math.modf(hurt*0.5)
    	else
    		WAR.fthurt = math.modf(hurt*0.5)
    		hurt = math.modf(hurt*0.7)
    	end
    	h = math.modf(WAR.fthurt / 2 + Rnd(10));		--�������˺�
    	SetWarMap(WAR.Person[nyft]["����X"], WAR.Person[nyft]["����Y"], 4, 2);	--�����߱�ʶΪ������
    	
    	WAR.L_QKDNY[WAR.Person[nyft]["������"]] = 1;
    end
    	

    WAR.Person[nyft]["��������"] = (WAR.Person[nyft]["��������"] or 0) - h;
    JY.Person[WAR.Person[nyft]["������"]]["����"] = JY.Person[WAR.Person[nyft]["������"]]["����"] - h
    if JY.Person[WAR.Person[nyft]["������"]]["����"] < 1 then
      JY.Person[WAR.Person[nyft]["������"]]["����"] = 1
    end
    
    
    WAR.Person[enemyid]["��Ч����2"] = WAR.Person[enemyid]["��Ч����2"] .."��".. "����"
      
    --���޼ɣ����Է���������
    if eid == 9 and nyft ~= nyft2 then
    	WAR.Person[nyft2]["��������"] = (WAR.Person[nyft2]["��������"] or 0) - h;
      JY.Person[WAR.Person[nyft2]["������"]]["����"] = JY.Person[WAR.Person[nyft2]["������"]]["����"] - h;
      if JY.Person[WAR.Person[nyft2]["������"]]["����"] < 1 then
        JY.Person[WAR.Person[nyft2]["������"]]["����"] = 1
      end
      WAR.Person[enemyid]["��Ч����2"] = WAR.Person[enemyid]["��Ч����2"] .. "��˫"
      SetWarMap(WAR.Person[nyft2]["����X"], WAR.Person[nyft2]["����Y"], 4, 2);	--�����߱�ʶΪ������
    end
    
  end
  
  
  --����Ŀ���˺�Ϊ0
  if (WAR.KHCM[pid] == 1 and JLSD(30,70,pid)) or WAR.KHCM[pid] == 2 then
    hurt = 0
  end
  
  --brolycjw: ��������
  if (eid == 27 and JLSD(20, 80, eid)) or WAR.L_SGHT == 105 then
    hurt = math.modf(hurt / 2)
    ang = 0
    WAR.Person[enemyid]["��Ч����2"] = "��������"		--��������
    WAR.Person[enemyid]["��Ч����"] = math.fmod(105, 10) + 85
  end
  
  --��ǧ��
  if eid == 88 and JLSD(35, 65, eid) then
    hurt = 0
    WAR.Person[enemyid]["��Ч����2"] = "�������ٲ�"	--�������ٲ�
    WAR.Person[enemyid]["��Ч����"] = 89
  end

	--���� ָ��
  if eid == 53  then
  	if WAR.TZ_DY == 1 and JLSD(10, 90, eid) then
	    hurt = 0
	    WAR.Person[enemyid]["��Ч����2"] = "�貨΢��"		--�貨΢��
	    WAR.Person[enemyid]["��Ч����"] = 88
	  elseif JLSD(30, 60, eid) then
	    hurt = 0
	    WAR.Person[enemyid]["��Ч����2"] = "�貨΢��"
	    WAR.Person[enemyid]["��Ч����"] = 88
	  end
  end
 

  --���� ��ϵ
  if GetS(4, 5, 5, 5) == 4 and eid == 0 then
    local gctj = 0
    for i = 1, 10 do
      if (JY.Person[0]["�书" .. i] == 112 or (JY.Person[0]["�书" .. i] <= 86 and JY.Person[0]["�书" .. i] >= 68 and JY.Person[0]["�书" .. i] ~= 85)) and JY.Person[0]["�书�ȼ�" .. i] == 999 then
        gctj = gctj + 1
      end
    end
    local tjsf = 10 + (gctj) * 5
    if JLSD(30, 30 + tjsf, eid) then
	    hurt = 0
	    WAR.Person[enemyid]["��Ч����3"] = "�����"		--�����
	    WAR.Person[enemyid]["��Ч����"] = 88
  	end
  end
  
  --�����壺�ﲮ�� 
  if eid == 29 and WAR.L_TBGZL == 1 and JLSD(30,60,pid) then
  	hurt = 0
	  WAR.Person[enemyid]["��Ч����2"] = "��ɧ������"
	  WAR.Person[enemyid]["��Ч����"] = 88
  end
  
  --���� ������ɽ
  if eid == JY.MY and WAR.FLHS4 > 0 and hurt > 0 then
    hurt = 10
  end
  
  --�����
  if eid == JY.MY and WAR.JSTG > 0 then
    if hurt <= WAR.JSTG then
      WAR.JSTG = WAR.JSTG - hurt
      hurt = 5 + Rnd(6)
      ang = math.modf(ang / 2)
    else
      hurt = hurt - WAR.JSTG
      WAR.JSTG = 0
    end
    if WAR.Person[enemyid]["��Ч����3"] == nil then
      WAR.Person[enemyid]["��Ч����3"] = "�����"		--�����
    else
      WAR.Person[enemyid]["��Ч����3"] = WAR.Person[enemyid]["��Ч����3"] .. "+�����"
    end
    WAR.Person[enemyid]["��Ч����"] = 6
  end
  
  for i = 1, 10 do
    local kfid = JY.Person[eid]["�书" .. i]
  	--�����߻���ͨ��ɫ�����߻�
    if kfid == 104 then
		  if WAR.tmp[1000 + eid] ~= 1 and WAR.ZDDH ~= 171 and eid == 60 then
			  if JY.Person[eid]["����"] > 50 then
			    WAR.Person[enemyid]["��Ч����"] = math.fmod(wugong, 10) + 85
			    if eid == 60 then
			      WAR.Person[enemyid]["��Ч����1"] = "��--���˽����߻���ħ"		--��--���˽����߻���ħ
			    else
			    	WAR.Person[enemyid]["��Ч����1"] = JY.Wugong[kfid]["����"] .. "�߻���ħ"
			    end
			    WAR.tmp[1000 + eid] = 1
			  end
			end
		end
	end

	--���޼� �����񹦷���
  if eid == 9 and WAR.Person[enemyid]["��Ч����1"] == nil and WAR.Person[enemyid]["�ҷ�"] ~= WAR.Person[WAR.CurID]["�ҷ�"] and hurt > 10 and PersonKF(9, 106) then
    WAR.Person[enemyid]["��Ч����"] = math.fmod(97, 10) + 85
    WAR.Person[enemyid]["��Ч����1"] = "�����񹦷���"
    SetWarMap(WAR.Person[WAR.CurID]["����X"], WAR.Person[WAR.CurID]["����Y"], 4, 2)
    local selfhurt = math.modf(hurt * 0.3)
    JY.Person[pid]["����"] = JY.Person[pid]["����"] - math.modf(selfhurt / 2)
    WAR.Person[WAR.CurID]["��������"] = (WAR.Person[WAR.CurID]["��������"] or 0)-math.modf(selfhurt / 2)
  end
  
  --�����壺װ�����o�׷���ȭϵ�书20%�˺�����ȭϵ�����10%��������
  if WAR.Person[enemyid]["�ҷ�"] and JY.Person[eid]["����"] == 58 then
  	if (wugong >= 1 and wugong <= 26) or wugong == 109 then		--ȭϵ�书
  		local selfhurt = 20
  		if WAR.Person[enemyid]["��Ч����1"] ~= nil then
  			WAR.Person[enemyid]["��Ч����1"] = WAR.Person[enemyid]["��Ч����1"] .. "+" ..JY.Thing[58]["����"].."����"
  		else
  			WAR.Person[enemyid]["��Ч����1"] = JY.Thing[58]["����"].."����"
  		end
  		if WAR.Person[enemyid]["��Ч����"] == -1 then
      	WAR.Person[enemyid]["��Ч����"] = math.fmod(97, 10) + 85
      end
      SetWarMap(WAR.Person[WAR.CurID]["����X"], WAR.Person[WAR.CurID]["����Y"], 4, 2)
      JY.Person[pid]["����"] = JY.Person[pid]["����"] - selfhurt;
      if JY.Person[pid]["����"] <= 0 then		--������
      	JY.Person[pid]["����"] = 1;
      end
    	WAR.Person[WAR.CurID]["��������"] = (WAR.Person[WAR.CurID]["��������"] or 0)-selfhurt
  	else
  		hurt = hurt - 20
  	end
  end
  


	
 	 --brolycjw: ʯ������ʯ���񱻹���ʱ�˺���ɢ
	if eid == 591 and WAR.Person[enemyid]["�ҷ�"] ~= WAR.Person[WAR.CurID]["�ҷ�"] and hurt > 10 then
		for j = 0, WAR.PersonNum - 1 do
			if WAR.Person[j]["������"] == 38 and WAR.Person[j]["����"] == false and WAR.Person[j]["�ҷ�"] == WAR.Person[enemyid]["�ҷ�"] then
				hurt = math.modf(hurt*0.5)
				JY.Person[38]["����"] = JY.Person[38]["����"] - hurt	
				WAR.Person[enemyid]["��Ч����3"] = "����ͬ����"
				WAR.Person[j]["��������"] = (WAR.Person[j]["��������"] or 0)-hurt;
				SetWarMap(WAR.Person[j]["����X"], WAR.Person[j]["����Y"], 4, 2);
			end
		end
	end	  
	if eid == 38 and WAR.Person[enemyid]["�ҷ�"] ~= WAR.Person[WAR.CurID]["�ҷ�"] and hurt > 10 then
		for j = 0, WAR.PersonNum - 1 do
			if WAR.Person[j]["������"] == 591 and WAR.Person[j]["����"] == false and WAR.Person[j]["�ҷ�"] == WAR.Person[enemyid]["�ҷ�"] then
				hurt = math.modf(hurt*0.5)
				JY.Person[591]["����"] = JY.Person[591]["����"] - hurt	
				WAR.Person[enemyid]["��Ч����3"] = "����ͬ����"
				WAR.Person[j]["��������"] = (WAR.Person[j]["��������"] or 0)-hurt;
				SetWarMap(WAR.Person[j]["����X"], WAR.Person[j]["����Y"], 4, 2);
			end
		end
	end
	
	
	--�����壺���ڹ��������񹦻��壬�˺�����40%
	if WAR.L_SGHT == 106 then
		hurt = math.modf(hurt*0.6);
		ang = math.modf(ang*0.5);
	end
	
	--�����壺������ܣ�������ʱ�����ж�
	if eid == 592 then
	
		local wgtype = JY.Wugong[wugong]["�书����"];
		
		--brolycjw: �ڹ�����
		if wugong > 88 and wugong < 109 then
			wgtype = 5;
		end
		
		--�ظ�ʹ����ͬ���书����ʱ��������Ч
		if wgtype == WAR.L_DGQB_DEF then
			hurt = 0;
			ang = 0;
			WAR.L_DGQB_X = WAR.L_DGQB_X + 1;
			
		--ȭ����������������  ��������������  ������ȭ������ �ط����ڹ��������ڹ��������ٸ������书��ʱ�˺���ɱ����Ϊ1.5��
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
		
		--brolycjw: �ı��������
		if wgtype > 0 then 
			WAR.L_DGQB_DEF = wgtype;
		end
		
		--������Ч����������
		WAR.ACT = 10;
		if WAR.L_DGQB_X <= 0 then
			WAR.L_DGQB_X = 1;
		end
		if WAR.Person[enemyid]["��Ч����2"] ~= nil then
			WAR.Person[enemyid]["��Ч����2"] = WAR.Person[enemyid]["��Ч����2"] .. "+" ..WAR.L_DGQB_DEF_STR[WAR.L_DGQB_DEF]
		else
			WAR.Person[enemyid]["��Ч����2"] = WAR.L_DGQB_DEF_STR[WAR.L_DGQB_DEF]
		end
		
		WAR.Person[enemyid]["��Ч����"] = 96
	end
	 
	 
  
  --����
  if JY.Person[pid]["����"] <= 0 then
    JY.Person[pid]["����"] = 0
  end
  
  
  --�����壺װ�����콣������Ѫ����20%���ʷ�Ѩ
  if JY.Person[pid]["����"] == 37 then
  	WAR.L_YTJ1 = 1;
  	if JLSD(50,70,pid) then
  		WAR.L_YTJ2 = 1;
  	end
  end
  

  
  --���Լ���
  if WAR.Person[WAR.CurID]["�ҷ�"] == WAR.Person[enemyid]["�ҷ�"]  then
    if WAR.Person[WAR.CurID]["�ҷ�"] then
    
    	if WAR.L_NYZH[pid] ~= nil then			--�����壺�������߻𣬴��ѷ��˺����
      	hurt = math.modf(hurt * 0.8) + Rnd(3)
      else
      	hurt = math.modf(hurt * 0.5) + Rnd(3)
      end
    else
    	hurt = math.modf((hurt) * 0.2) + Rnd(3)
    end
  end
  
	--������ܣ�����ʱ�������
 	if WAR.L_DGQB_X >= 10 and pid == 592 then
		if JY.Person[eid]["����"] >= 500 then
			hurt = JY.Person[eid]["����"] - 1;
			JY.Person[eid]["����"] = 1;
		else
			hurt = JY.Person[eid]["����"];
			JY.Person[eid]["����"] = 0;	
		end
	else
		JY.Person[eid]["����"] = JY.Person[eid]["����"] - (hurt)
	end

  
  --̫ȭ������������
  for i = 1, 10 do
    local kfid = JY.Person[eid]["�书" .. i]
    if kfid == 16 then
      if WAR.tmp[3000 + eid] == nil then
        WAR.tmp[3000 + eid] = 0
      end
      WAR.tmp[3000 + eid] = hurt;
      break;
    end
  end
  
  --��ȡ�þ���
  WAR.Person[WAR.CurID]["����"] = WAR.Person[WAR.CurID]["����"] + math.modf((hurt) / 5)
  
  --��������
  if JY.Person[eid]["����"] <= 0 then
    for i = 1, 10 do
      local kfid = JY.Person[eid]["�书" .. i]
      if kfid == 94 and WAR.tmp[2000 + eid] == nil then
        WAR.Person[enemyid]["��Ч����"] = math.fmod(kfid, 10) + 85
        WAR.Person[enemyid]["��Ч����1"] = JY.Wugong[kfid]["����"] .. "��������"
        local lv = math.modf(JY.Person[eid]["�书�ȼ�" .. i] / 100) + 1
        if eid == 37 then
          JY.Person[eid]["����"] = JY.Person[eid]["�������ֵ"]
        else
          JY.Person[eid]["����"] = math.modf(JY.Person[eid]["�������ֵ"] * (1 + lv) / 25)
        end
        JY.Person[eid]["����"] = math.modf((JY.Person[eid]["����"] + JY.Person[eid]["�������ֵ"]) / 2)
        JY.Person[eid]["����"] = math.modf((JY.Person[eid]["����"] + 50) / 2)
        JY.Person[eid]["�ж��̶�"] = math.modf(JY.Person[eid]["�ж��̶�"] / 2)
        JY.Person[eid]["���˳̶�"] = math.modf(JY.Person[eid]["���˳̶�"] / 2)
        WAR.Person[enemyid].Time = WAR.Person[enemyid].Time + 500
        if eid == 37 then
          WAR.Person[enemyid].Time = 990
          WAR.DYSZ = 1
        end
        if WAR.Person[enemyid].Time > 990 then
          WAR.Person[enemyid].Time = 990
        end
        --ʮ��֮һ�Ļ��ʡ������ٴ�����
		    if math.random(10) ~= 8 then		
		      WAR.tmp[2000 + eid] = 1
		    end
      end
    end
    
  end
  
  --��������һ�ƣ�����
  if JY.Person[eid]["����"] <= 0 and (eid == 129 or eid == 65) and WAR.WCY < 1 then
    WAR.Person[enemyid]["��Ч����"] = 19
    WAR.Person[enemyid]["��Ч����1"] = "����һ�� ��������"
    WAR.WCY = WAR.WCY + 1
    JY.Person[eid]["����"] = JY.Person[eid]["�������ֵ"]
    JY.Person[eid]["����"] = JY.Person[eid]["�������ֵ"]
    JY.Person[eid]["�ж��̶�"] = 0
    JY.Person[eid]["���˳̶�"] = 0
    JY.Person[eid]["����"] = 100
    WAR.Person[enemyid].Time = 980
  end
  
  --ѦĽ�� ����һ����
  if JY.Person[eid]["����"] <= 0 and WAR.XMH == 0 then
    for i = 0, WAR.PersonNum - 1 do
      if WAR.Person[i]["������"] == 45 and WAR.Person[i]["����"] == false and WAR.Person[i]["�ҷ�"] == WAR.Person[enemyid]["�ҷ�"] then
        WAR.Person[enemyid]["��Ч����"] = 89
        WAR.Person[enemyid]["��Ч����1"] = "������ ����"		--������ ����
        JY.Person[eid]["����"] = JY.Person[eid]["�������ֵ"]
        JY.Person[eid]["����"] = JY.Person[eid]["�������ֵ"]
        JY.Person[eid]["�ж��̶�"] = 0
        JY.Person[eid]["���˳̶�"] = 0
        JY.Person[eid]["����"] = 100
        WAR.FXDS[eid] = nil
        WAR.LXZT[eid] = nil
        WAR.XMH = 1
        break;
      end
    end
  end
  
  --С�ձ�
  if eid == 553 and JY.Person[eid]["����"] <= 0 then
    WAR.YZB = 1
  end
  
  
  if JY.Person[eid]["����"] <= 0 then
    JY.Person[eid]["����"] = 0
    WAR.Person[WAR.CurID]["����"] = WAR.Person[WAR.CurID]["����"] + JY.Person[eid]["�ȼ�"] * 5
    WAR.Person[enemyid]["�����书"] = -1
  end
  
  --�����Ƿ��Ʒ���dngΪ0��ʾ���Ʒ�
  ang = ang - dng
  if 0 < ang then
    dng = 0
  else
    dng = -ang
    ang = 0
  end
  
  --ɨ��  ��ɱ��
  if eid == 114 then
    WAR.Person[enemyid]["��Ч����2"] = "��ض���"	--��ض���
    WAR.Person[enemyid]["��Ч����"] = 39
    dng = 1
  end
  
  --�˺�С��20 �����ˣ���ɱ�� 
  if hurt < 20 then
    dng = 1
  end
  
  --���Ƹ����һ�غϣ������ˣ���ɱ�� 
  if eid == 37 and WAR.DYSZ == 1 then
    dng = 1
    WAR.DYSZ = 0
  end
  
  --������ɽ �����ˣ���ɱ�� 
  if eid == 0 and 0 < WAR.FLHS4 then
    dng = 1
  end
  
  --̫�����壬�������ˣ���ɱ�� 
  for i = 1, 10 do
    if (JY.Person[eid]["�书" .. i] == 16 or JY.Person[eid]["�书" .. i] == 46) and JY.Person[eid]["�书�ȼ�" .. i] == 999 then
      WAR.TJAY = WAR.TJAY + 1
    end
  end
  if WAR.TJAY == 2 and JLSD(10, 45 + math.modf(JY.Person[eid]["����"] / 2.5), eid) then
    dng = 1
    if WAR.Person[enemyid]["��Ч����2"] ~= nil and WAR.Person[enemyid]["��Ч����2"] ~= " " then
      WAR.Person[enemyid]["��Ч����2"] = WAR.Person[enemyid]["��Ч����2"] .. "+̫������"
    else
      WAR.Person[enemyid]["��Ч����2"] = "̫������--������ǧ��"
    end
    WAR.Person[enemyid]["��Ч����"] = 21
    
    --�������˺�����50%
	  if eid == 5 then
	    WAR.Person[enemyid]["��Ч����3"] = "�޸�����"
	    WAR.Person[enemyid]["��Ч����"] = 21
	    hurt = math.modf(hurt * 0.5)
	    WAR.Person[enemyid].TimeAdd = WAR.Person[enemyid].TimeAdd + hurt
	  else
	  	hurt = math.modf(hurt * 0.8)
	  end
  end
  
  
  WAR.TJAY = 0
  
  --��ϵ���� ֱ���Ʒ�
  if WAR.ASKD == 1 then
    dng = 0
  end
  
  
  --�����壺ʨ�𹦼��� �Ե�����ɳٻ�
  if WAR.NGJL == 92 then
  	local n = math.modf((JY.Person[pid]["����"]*2 - JY.Person[eid]["����"])/1000);
  	WAR.CHZ[eid] = 10 + limitX(n,0,10);
  	
  	--�ڹ�������С����ֱ���Ʒ�
  	if JLSD(0,15,pid) then
  		dng = 0
  	end
  end
  
  
  --�Ʒ������˼���
  --�������������������
  if (WAR.NGJL == 103 or dng == 0) and hurt > 0 and WAR.Person[WAR.CurID]["�ҷ�"] ~= WAR.Person[enemyid]["�ҷ�"]  then
  	local n = 0;		--���˵���ֵ
    if inteam(eid) then		--�������˼���
      if pid == 80 then				--�����ع��������˼ӱ�
        	n = myrnd((hurt) * 2 / 8);
	    else
      		n = myrnd((hurt) / 8);
    	end
   	else
   		--����з�����
	  	if pid == 80 then			--�����ع��������˼ӱ�
		      n = myrnd((hurt) * 2 / 16);
		  else
		    n = myrnd((hurt) / 16);
		  end
  	end
  	
  	--���칦���˼���
  	if PersonKF(eid, 100) then
  		n = math.modf(n/2);
  	end
  	
  	
  	--̫���񹦣����ܵ�������תΪ�ظ�����
    if WAR.L_SGHT == 102 then
    	WAR.Person[enemyid]["���˵���"] = (WAR.Person[enemyid]["���˵���"] or 0) - n;
  		AddPersonAttrib(eid, "���˳̶�", -n);
    else
    	WAR.Person[enemyid]["���˵���"] = (WAR.Person[enemyid]["���˵���"] or 0) + n;
  		AddPersonAttrib(eid, "���˳̶�", n);
    end
  end
  
  --�Ʒ�ɱ��������
  if dng == 0 and hurt > 0 and WAR.Person[WAR.CurID]["�ҷ�"] ~= WAR.Person[enemyid]["�ҷ�"] then
    local killsq = limitX(9-JY.Thing[202][WZ7],1) -- �Ѷ��ж�
    
    local killjq = 0
    if inteam(eid) then  
    	killjq = math.modf(ang / killsq)
    else
    	killjq = math.modf(ang / 8)
    end
    
    
    
    --���˺�����ɱ����
    local spdhurt = 0
    if inteam(eid) then
      spdhurt = math.modf((hurt) * 0.7)
    end
    for i = 1, 10 do
      if JY.Person[pid]["�书" .. i] == 103 then			--����
        spdhurt = math.modf((hurt) * 2 / 5)
      end
    end
    for i = 1, 10 do
      if JY.Person[eid]["�书" .. i] == 101 then			--���ѧ�˰��������˺�ɱ����
        spdhurt = 0
      end
    end
    killjq = killjq + spdhurt
    
    --̫���񹦣��ѱ�ɱ�ļ���תΪ�Լ��ļ���ֵ
    if WAR.L_SGHT == 102 then
    	WAR.Person[enemyid].TimeAdd = WAR.Person[enemyid].TimeAdd + killjq;
    else
    	WAR.Person[enemyid].TimeAdd = WAR.Person[enemyid].TimeAdd - killjq;
    	if WAR.L_SGHT == 106 and JLSD(0,70,eid)  then		--�����񹦻��壬�л��ʻظ���ɱ������Ѫ��
    		WAR.Person[enemyid]["��������"] = (WAR.Person[enemyid]["��������"] or 0) + AddPersonAttrib(eid, "����", math.modf((hurt+killjq)*(0.4+math.random(4)/10)));
    		WAR.Person[enemyid]["��������"] = (WAR.Person[enemyid]["��������"] or 0) + AddPersonAttrib(eid, "����", 3);
    	end
    end
  end
  
  --С��Ů�����������
  if eid == 59 and JY.Person[eid]["����"] <= 0 then
    WAR.XK = 1
    WAR.XK2 = WAR.Person[enemyid]["�ҷ�"]
  end
  
  --ŷ����  �����ж�+30
  if pid == 60 then
    WAR.Person[enemyid]["�ж�����"] = (WAR.Person[enemyid]["�ж�����"] or 0) + AddPersonAttrib(eid, "�ж��̶�", 30)
  end
  
  
  --͵����
  if WAR.TD == -2 then
    local i = nil
    i = math.random(4)
    if 0 < JY.Person[eid]["Я����Ʒ����" .. i] and -1 < JY.Person[eid]["Я����Ʒ" .. i] and WAR.Person[WAR.CurID]["�ҷ�"] ~= WAR.Person[enemyid]["�ҷ�"] then
      JY.Person[eid]["Я����Ʒ����" .. i] = JY.Person[eid]["Я����Ʒ����" .. i] - 1
      WAR.TD = JY.Person[eid]["Я����Ʒ" .. i]
    end
    if JY.Person[eid]["Я����Ʒ����" .. i] < 1 then
      JY.Person[eid]["Я����Ʒ" .. i] = -1
    end
  else
    WAR.TD = -1
  end
  
  --Ѫ����Ѫ
  if WAR.XDDF == 1 then
  	WAR.Person[WAR.CurID]["��������"] = (WAR.Person[WAR.CurID]["��������"] or 0) + AddPersonAttrib(pid, "����", math.modf((hurt) * 0.1));
    
    WAR.XDXX = WAR.XDXX + math.modf((hurt) * 0.1)
  end
  
  --����ʯ ������������+50
  if eid == 85 and 0 < JY.Person[eid]["����"] then
    WAR.Person[enemyid]["��������"] = (WAR.Person[enemyid]["��������"] or 0) + AddPersonAttrib(eid, "����", 50);
  end
  
  --������� ������������+150
  if eid == 516 and 0 < JY.Person[eid]["����"] then
    WAR.Person[enemyid]["��������"] = (WAR.Person[enemyid]["��������"] or 0) + AddPersonAttrib(pid, "����", 50);
  end
  
  --����ͩ ɱ����
  if WAR.HQT == 1 then
  	WAR.Person[enemyid]["��������"] = (WAR.Person[enemyid]["��������"] or 0) + AddPersonAttrib(eid, "����", -15);
  end
  
  
  --��Ӣ ɱ����
  if WAR.CY == 1 then
    WAR.Person[enemyid]["��������"] = (WAR.Person[enemyid]["��������"] or 0) + AddPersonAttrib(eid, "����", -300);
  end
  
  --���ũ �����𽣷�ɱ�����˷�
  if WAR.Data["����"] == 0 and pid == 72 and eid == 3 and JY.Person[eid]["����"] <= 0 and JY.Person[72]["�书1"] == 28 then
    WAR.TGN = 1
  end
  
  --�ֻ�͵Ǯ
  if eid ~= 445 and eid ~= 446 and eid < 578 and eid ~= 64 and WAR.ZDDH ~= 17 and pid == 4 and JY.Person[eid]["����"] <= 0 and inteam(pid) and WAR.Person[enemyid]["�ҷ�"] ~= WAR.Person[WAR.CurID]["�ҷ�"] and not inteam(eid) then
    WAR.YJ = WAR.YJ + math.random(15) + 25
  end
  
  --���ũ���ֻ��ļӳɣ��ж�+5 + ���15
  if pid == 72 then
    for j = 0, WAR.PersonNum - 1 do
      if WAR.Person[j]["������"] == 4 and WAR.Person[j]["����"] == false and WAR.Person[j]["�ҷ�"] == WAR.Person[WAR.CurID]["�ҷ�"] then
        WAR.Person[enemyid]["�ж�����"] = AddPersonAttrib(eid, "�ж��̶�", JY.Person[eid]["�ж��̶�"] + 5 + math.random(15));
      end
    end
  end
  
  --������Ŀ��40%����MISS 
  if WAR.KHBX == 1 and 0 < hurt and (WAR.KHCM[eid] == nil or WAR.KHCM[eid] == 0)  then
    WAR.KHCM[eid] = 1
  end
  
  --��а��Ŀ��100%MISS
  if WAR.KHBX == 2 and 0 < hurt  then
    WAR.KHCM[eid] = 2
  end
  
  --�������� ��ɱ
  if WAR.GBWZ == 1 and math.random(10) < 6 and WAR.Person[enemyid]["�ҷ�"] ~= WAR.Person[WAR.CurID]["�ҷ�"] then
  	WAR.Person[enemyid]["��������"] = -JY.Person[eid]["����"];
    JY.Person[eid]["����"] = 0
  end
  
  if not inteam(pid) then
    local gfxp = {114, 26, 129, 65, 18, 39, 70, 98, 57, 185}
    for g = 1, 10 do
      if pid == gfxp[g] and JLSD(30, 70, pid) then
        WAR.BFX = 1
      end
    end
  end
  
  --��Ѩ����
  if WAR.LXZQ == 1 and JLSD(25, 75, pid) then
    WAR.BFX = 1
  end
  
  --�����壺װ�����콣��20%���ʷ�Ѩ
  --̫���񹦻��壬���Ѩ
  --�Ƿ����Ѩ
  --��ʦ��50%�������ӷ�Ѩ
  if PersonKF(eid, 104) == false and WAR.L_SGHT ~= 102 and eid ~= 50  and (100 < hurt and (JLSD(30, 75, pid) or WAR.GCTJ == 1 or WAR.BFX == 1) and (WGLX == 1 or WGLX == 4 or JLSD(35, 70, pid) or WAR.BFX == 1) or  WAR.L_YTJ2 == 1 or (wugong == 19 and JLSD(30,80,pid) and JY.Person[pid]["��������"] == 0) or (wugong == 17 and JLSD(30,80,pid) and JY.Person[pid]["��������"] == 1) or WAR.L_WYJFA == 33 or (pid==JY.MY and GetS(53, 0, 2, 5) == 3  and 50 > math.random(100))) then
    
    
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
  
  --��Ѫ����
  if WAR.ASKD == 1 and JLSD(25, 75, pid) then
    WAR.BLX = 1
  end
  
  --�����壺װ�����콣����Ѫ    ������������Ѫ
  --�����������������Ѫ
  --�Ƿ�����Ѫ
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
  
  --�����壺ˮ�Ϲ����ٻ�����
  --������������Ҳ����ɳٻ�
  --�������ƺ�ѩɽ��������Ե�����ɳٻ�
  if (WAR.L_SSBD == 1 or WAR.L_LXXL == 1 or wugong == 5 or wugong == 35 or WAR.L_WYJFA == 31) and hurt > 0 and WAR.Person[enemyid]["�ҷ�"] ~= WAR.Person[WAR.CurID]["�ҷ�"] then
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

	--ŭ��ֵ����
	--�����壺�������߻𣬲��ᱩ��
  if WAR.L_NYZH[eid] == nil and 0 < JY.Person[eid]["����"] and hurt > 0 and (WAR.LQZ[eid] == nil or WAR.LQZ[eid] < 100) and DWPD() and WAR.DZXY ~= 1 and WAR.ASKD ~= 1 then
    local minlqzj = math.modf((hurt) / 3 * 0.2 + 1)
    local lqzj = math.random(math.modf((hurt) / 3) + 1)
    if lqzj < minlqzj then
      lqzj = minlqzj
    end
    
    --�����Ѷ��¶������ӵ�ŭ��ֵ
    if WAR.Person[enemyid]["�ҷ�"] == false then
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
    
    --̫���񹦼���ʱ����ɱŭ��ֵ
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
    
    --ŭ������
	  if WAR.LQZ[eid] ~=  nil and 100 < WAR.LQZ[eid] then
	    WAR.LQZ[eid] = 100
	    WAR.Person[enemyid]["��Ч����"] = 6
	    if WAR.Person[enemyid]["��Ч����3"] ~= nil then
	      WAR.Person[enemyid]["��Ч����3"] = WAR.Person[enemyid]["��Ч����3"] .. "+ŭ������"
	    else
	    	WAR.Person[enemyid]["��Ч����3"] = "ŭ������"
	  	end
	  end
  end
  
  
  
  if WAR.ASKD == 1 and DWPD() then
    WAR.LQZ[eid] = 0
  end
  
  --Ѫ������ �Ի󣬼���Ϊ40%
  if pid == 97 and math.random(10) < 4 and WAR.Person[enemyid]["�ҷ�"] ~= WAR.Person[WAR.CurID]["�ҷ�"] then
    WAR.Person[enemyid]["�ҷ�"] = WAR.Person[WAR.CurID]["�ҷ�"]
  end
  
  --����ѡ����Ż��������л����Ի�
  if pid == JY.MY and GetS(53, 0, 2, 5) == 2 and WAR.Person[enemyid]["�ҷ�"] ~= WAR.Person[WAR.CurID]["�ҷ�"] and (JY.Person[eid]["�������ֵ"]-600 * JY.Thing[202][WZ7]) < 1000 then
    local rate = (JY.Person[pid]["����"] - 2*JY.Person[eid]["����"])/10 + (JY.Person[pid]["����"] - 3*JY.Person[eid]["����"])/600 + JY.Person[pid]["����"]/20 + JY.Thing[238]["�辭��"]/50 ;
    if JLSD(0,rate,pid) or (GetS(53, 0, 4, 5) == 1 and JLSD(0,10,pid)) then
    	if JLSD(0,30-JY.Thing[202][WZ7]*5,pid)  then
    		say("$$Ǯ~~~~Ǯ~~~",WAR.tmp[5000+enemyid],0,WAR.tmp[5500+enemyid]);
    		WAR.Person[enemyid]["�ҷ�"] = WAR.Person[WAR.CurID]["�ҷ�"]
    	elseif JLSD(0,30,pid) then
    		say("������ӵ�~~~�������~~~",WAR.tmp[5000+enemyid],0,WAR.tmp[5500+enemyid]);
    	end
    end
    
    
  end
  
  --�ɲ��� ������� ��ɱ
  if WAR.ZDDH == 205 and eid == 141 then
  	WAR.Person[enemyid]["��������"] = -JY.Person[eid]["����"];
    JY.Person[eid]["����"] = 0
  end
  
  --��̹֮ �϶�
  if pid == 48 then
    local d = math.modf((340 - JY.Person[eid]["��������"] - JY.Person[eid]["����"] / 50) / 4)
    if d < 0 then
      d = 0
    end
    WAR.Person[enemyid]["�ж�����"] = (WAR.Person[enemyid]["�ж�����"] or 0) + AddPersonAttrib(eid, "�ж��̶�", d);
  end
  
  --�����壺���ƣ��߻�����ɹ̶�����20��
  if wugong == 13 and JLSD(30, 90, pid) then
  	AddPersonAttrib(eid, "���˳̶�", 20);
  end
  
  --�����壺��ڤ���ƣ��������ڣ��л���������˺������϶�10��
  if wugong == 21 and JY.Person[pid]["��������"] == 0 then
  	local jl = 40;
  	for i=1, 10 do
  		if JY.Person[pid]["�书"..i] == 3 or JY.Person[pid]["�书"..i] == 5 then
  			jl = jl + 15;
  		end
  	end
  	if JLSD(10, 10+jl) then
  		AddPersonAttrib(eid, "���˳̶�", 10);
  		WAR.Person[enemyid]["�ж�����"] = (WAR.Person[enemyid]["�ж�����"] or 0) + AddPersonAttrib(eid, "�ж��̶�", 10);
  	end
  end
  
  
  --Ǭ�������˺�
  if eid == -1 then
	  local x, y = nil, nil
	  while true do
		  x = math.random(63)
		  y = math.random(63)
		  if not SceneCanPass(x, y) or GetWarMap(x, y, 2) < 0 then
		    SetWarMap(WAR.Person[enemyid]["����X"], WAR.Person[enemyid]["����Y"], 2, -1)
		    SetWarMap(WAR.Person[enemyid]["����X"], WAR.Person[enemyid]["����Y"], 5, -1)
		    WAR.Person[enemyid]["����X"] = x
		    WAR.Person[enemyid]["����Y"] = y
		    SetWarMap(WAR.Person[enemyid]["����X"], WAR.Person[enemyid]["����Y"], 2, enemyid)
		    SetWarMap(WAR.Person[enemyid]["����X"], WAR.Person[enemyid]["����Y"], 5, WAR.Person[enemyid]["��ͼ"])
		    break;
		  end
		end
  end
  
  --�ж��Ƿ���Լ�ʵս
  if JY.Person[eid]["����"] <= 0 and inteam(pid) and DWPD() and WAR.SZJPYX[eid] == nil then
    
    --�����ս����������ջɱŷ���ˡ�������������ȫ����������������������������   ����ʵս
    local wxzd = {17, 67, 226, 220, 224, 219, 79}
    local wx = 0
    for i = 1, 7 do
      if WAR.ZDDH == wxzd[i] then
        wx = 1
      end
    end
    
    --ؤ���ſ�
    if WAR.ZDDH == 82 and GetS(10, 0, 18, 0) == 1 then
      wx = 1
    end
    --ľ����
    if WAR.ZDDH == 214 and GetS(10, 0, 19, 0) == 1 then
      wx = 1
    end
    
    --����ɼ�ʵս
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
  
  --ƽһָɱ��
  if JY.Person[eid]["����"] <= 0 and pid == 28 then
    WAR.PYZ = WAR.PYZ + 1
    if 10 < WAR.PYZ then
    	WAR.PYZ = 10
  	end
  end
  
  
  --��ڤ�񹦺����Ǵ󷨣�����������
  if (WAR.BMXH == 1 or WAR.BMXH == 2) and 0 < hurt and DWPD() and wugong ~= 92 then
    local xnl = nil
    xnl = math.modf(JY.Person[eid]["����"] / 12 + math.random(10))	--brolycjw: ��
    WAR.Person[enemyid]["��������"] = (WAR.Person[enemyid]["��������"] or 0) + AddPersonAttrib(eid, "����", -xnl);
    WAR.Person[WAR.CurID]["��������"] = (WAR.Person[WAR.CurID]["��������"] or 0) + AddPersonAttrib(pid, "����", math.modf(xnl + 1))
    AddPersonAttrib(pid, "�������ֵ", math.modf(xnl * 2 / 3 + 10))
  end
  
  
  
  --������ �϶� ������
  if WAR.BMXH == 3 and 0 < hurt and DWPD() then
    local xnl = nil
    xnl = math.modf(JY.Person[eid]["����"] / 20 + 2)
    
    WAR.Person[enemyid]["��������"] = AddPersonAttrib(eid, "����", -xnl);
    WAR.Person[enemyid]["�ж�����"] = AddPersonAttrib(eid, "�ж��̶�", 20)
  end
  
  --���Ǵ� ������
  if WAR.BMXH == 2 and 0 < hurt and DWPD() then
    local xt1 = Rnd(3) + 2
    local xt2 = Rnd(5) + 6
    local xt3 = 2 + Rnd(2)
    local n = AddPersonAttrib(eid, "����", -xt1)
    local m = AddPersonAttrib(pid, "����", xt3)
    
    --������ ����������
    if pid == 26 then
    	n = n + AddPersonAttrib(eid, "����", -xt2)
    	m = m + AddPersonAttrib(pid, "����", xt2)
  	end
  	
  	WAR.Person[enemyid]["��������"] = (WAR.Person[enemyid]["��������"] or 0) + n;
  	WAR.Person[WAR.CurID]["��������"] = (WAR.Person[WAR.CurID]["��������"] or 0) + m;
  end
  
  --������
  if wugong == 64 and pid == 0 and GetS(4, 5, 5, 5) == 3 and 0 < hurt and WAR.XXCC == 0 then
    for i = 1, 10 do
      if JY.Person[0]["�书" .. i] == 64 and JY.Person[0]["�书�ȼ�" .. i] == 999 then
        SetS(14, 3, 1, 4, GetS(14, 3, 1, 4) + 5 + math.random(5))
        if 600 < GetS(14, 3, 1, 4) then
          SetS(14, 3, 1, 4, 600)
        end
        if JY.Person[0]["ˣ������"] * 10 - 900 < GetS(14, 3, 1, 4) then
          SetS(14, 3, 1, 4, limitX(JY.Person[0]["ˣ������"] * 10 - 900,0))
        end
        WAR.XXCC = 1
      end
    end
  end
  
  --�����壺���𽣷���ÿ�ι������ۼ�
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
  
  --�����壺���ƽ�����ÿ�ι������ۼӣ�����ۼ����
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
  
  --�ж�����
  local poisonnum = math.modf(level * JY.Wugong[wugong]["�����ж�����"] + 5 * JY.Person[pid]["��������"])
  if JY.Person[eid]["��������"] < poisonnum and dng == 0 and pid ~= 48 and WAR.Person[WAR.CurID]["�ҷ�"] ~= WAR.Person[enemyid]["�ҷ�"] then
  	if WAR.Person[enemyid]["�ҷ�"] then
  		poisonnum = math.modf(poisonnum / 10 - JY.Person[eid]["��������"]/10 - JY.Person[eid]["����"] / 200)
  	else
  		poisonnum = math.modf(poisonnum / 15 - JY.Person[eid]["��������"]/5 - JY.Person[eid]["����"] / 150)
  	end
    if poisonnum < 0 then
      poisonnum = 0
    end
    WAR.Person[enemyid]["�ж�����"] = (WAR.Person[enemyid]["�ж�����"] or 0) + AddPersonAttrib(eid, "�ж��̶�", myrnd(poisonnum))
    --Alungky: ȡ���ж���С����
    WAR.Person[enemyid]["�ж�����"] = math.modf(WAR.Person[enemyid]["�ж�����"]);
  end
  
  --�����壺����������ʱ�ж�40��
  if WAR.L_CZJT == 1 then
  	
  	local n = 30;		--���30��
  	n = n + math.modf((WAR.tmp[200 + pid]-100)/10);		--����100֮��ÿ10������ֵ����1���ж�
  	WAR.tmp[200 + pid] = 0
  	
  	--���ѧ�˰���ѩɽ�ƣ��϶�Ч���ӱ�
  	if PersonKFJ(pid, 9) then
  		n = n + math.modf(n/2);
  		
  	end
  	
  	WAR.Person[enemyid]["�ж�����"] = (WAR.Person[enemyid]["�ж�����"] or 0 ) + AddPersonAttrib(eid, "�ж��̶�", n);
  end
  
  WAR.NGHT = 0
  WAR.FLHS4 = 0
  
  WAR.L_SGHT = 0;

  
  if WAR.Person[enemyid]["��Ч����2"] == nil then
    WAR.Person[enemyid]["��Ч����2"] = "  "
  end
  if DWPD() == false then
    WAR.Person[enemyid]["��Ч����"] = -1
    WAR.Person[enemyid]["��Ч����0"] = nil
    WAR.Person[enemyid]["��Ч����1"] = nil
    WAR.Person[enemyid]["��Ч����2"] = nil
    WAR.Person[enemyid]["��Ч����3"] = nil
  end
  
  
  --�������Ӿ���
  if eid == JY.MY and GetS(53, 0, 2, 5) == 2 and WAR.Person[enemyid]["�ҷ�"] ~= WAR.Person[WAR.CurID]["�ҷ�"] then
  	if WAR.tmp[8002] == nil then
  		WAR.tmp[8002] = 0;
  	end
  	WAR.tmp[8002] = WAR.tmp[8002] + math.modf(hurt/100) + limitX(-WAR.Person[enemyid].TimeAdd/100,0,3);
  end
  
  --��ʦ��������ʱ���»غ����������ٶ�
  if eid == JY.MY and GetS(53, 0, 2, 5) == 3 and WAR.Person[enemyid]["�ҷ�"] ~= WAR.Person[WAR.CurID]["�ҷ�"] and hurt > 0 then
  	local rate = limitX(hurt/10,0,40) + JY.Person[eid]["��ѧ��ʶ"]/5 + JY.Person[eid]["����"]/10 + JY.Person[eid]["����"]/400;
  	if rate > math.random(100) or 30 > math.random(100) then
  		if WAR.tmp[8003] == nil then
  			WAR.tmp[8003] = 1;
  		elseif GetS(53, 0, 4, 5) == 1 then
  			WAR.tmp[8003] = WAR.tmp[8003]+1;
  		end
  		WAR.Person[enemyid]["��Ч����"] = 90;
  		WAR.Person[enemyid]["��Ч����2"] = "�Ż�����";
  		
  	end
  end
  
  
  return limitX(hurt, 0, hurt);
end

--�滭ս����ͼ
function WarDrawMap(flag, v1, v2, v3, v4, v5, ex, ey)
  local x = WAR.Person[WAR.CurID]["����X"]
  local y = WAR.Person[WAR.CurID]["����Y"]
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

--�з�ս������
function WarSelectEnemy()


  if PNLBD[WAR.ZDDH] ~= nil then
    PNLBD[WAR.ZDDH]()
  end
  
  
  --�ձ�ս����  
  for i = 1, 20 do
    if WAR.Data["����" .. i] > 0 then
    	if WAR.ZDDH == 137 then
    		if GetS(86, 10, 10, 5) == 1 then			--�����壺ɱ����
    			WAR.Data["����" .. i] = 9999;
    		elseif GetS(86, 10, 10, 5) == 2 then	--�����壺ɱ�ݳ���
    			WAR.Data["����" .. i] = 9999;
    		end
    	end
    	
    	if WAR.ZDDH == 226 and GetS(86, 1, 9, 5) == 1 then		--��������ĳ���ս�������
    		if GetS(86, 2, 1, 5) == 3 then				--��������Ƿ�
    			WAR.Data["����1"] = 5;
    			WAR.Data["����2"] = 50;
    		elseif GetS(86, 2, 2, 5) == 3 then		--������Ͷ�������
    			WAR.Data["����1"] = 5;
    			WAR.Data["����2"] = 27;
    		elseif GetS(86, 2, 3, 5) == 3 then		--�������ɨ����ɮ
    			WAR.Data["����1"] = 5;
    			WAR.Data["����2"] = 114;
    		elseif GetS(86, 2, 4, 5) == 3 then		--�Ƿ�Ͷ�������
    			WAR.Data["����1"] = 50;
    			WAR.Data["����2"] = 27;
    		elseif GetS(86, 2, 5, 5) == 3 then		--�Ƿ��ɨ����ɮ
    			WAR.Data["����1"] = 50;
    			WAR.Data["����2"] = 114;
    		elseif GetS(86, 2, 6, 5) == 3 then		--�������ܺ�ɨ����ɮ
    			WAR.Data["����1"] = 27;
    			WAR.Data["����2"] = 114;
    		elseif GetS(86, 2, 7, 5) == 3 then		--�����ᡢ�������ܺ�ɨ����ɮ
    			WAR.Data["����1"] = 5;
    			WAR.Data["����2"] = 27;
    			WAR.Data["����3"] = 114;
    		elseif GetS(86, 2, 8, 5) == 3 then		--�����ᡢ�Ƿ��ɨ����ɮ
    			WAR.Data["����1"] = 5;
    			WAR.Data["����2"] = 50;
    			WAR.Data["����3"] = 114;
    		elseif GetS(86, 2, 9, 5) == 3 then		--�����ᡢ�Ƿ�Ͷ�������
    			WAR.Data["����1"] = 5;
    			WAR.Data["����2"] = 50;
    			WAR.Data["����3"] = 27;
    		elseif GetS(86, 2, 10, 5) == 3 then		--�Ƿ塢�������ܺ�ɨ����ɮ
    			WAR.Data["����1"] = 50;
    			WAR.Data["����2"] = 27;
    			WAR.Data["����3"] = 114;
    		end
    		
    		WAR.Data["�з�X1"] = 45;
				WAR.Data["�з�Y1"] = 36;
				WAR.Data["�з�X2"] = 45;
				WAR.Data["�з�Y2"] = 28;
				WAR.Data["�з�X3"] = 52;
				WAR.Data["�з�Y3"] = 28;
				WAR.Data["�з�X4"] = 52;
				WAR.Data["�з�Y4"] = 36;
    	end
    	
		if WAR.ZDDH == 226 and GetS(86,20,20,5) == 3 then		--brolycjw��սŷ�����Ħ��		
				WAR.Data["����1"] = 60;
				WAR.Data["����2"] = 103;
				SetS(86,20,20,5,0);	--��ʱ���
		end
		
		if WAR.ZDDH == 79 then
    		if GetS(86, 11, 12, 5) == 1 then			--brolycjw��ɱ����
    			WAR.Data["����1"] = 62;
					WAR.Data["�з�X1"] = 21
					WAR.Data["�з�Y1"] = 30
				elseif GetS(86,15,2,5) > 0 then
	    		if GetS(86,15,2,5) == 1 then			--���ѳ�����ս
						local enemy = {3,184,67,98,118,164}
						local pick = math.random(6)
						WAR.Data["����1"] = enemy[pick]
					elseif GetS(86,15,2,5) == 2 then			--�����м���ս
						local enemy = {62,65,71,103,69,6}
						local pick = math.random(6)
						WAR.Data["����1"] = enemy[pick]
					elseif GetS(86,15,2,5) == 3 then			--���Ѹ߼���ս
						local enemy = {129,64,26,60,57}
						local pick = math.random(5)
						WAR.Data["����1"] = enemy[pick]
					elseif GetS(86,15,2,5) == 4 then			--��������ս
						local enemy = {5,27,50,114}
						local pick = math.random(4)
						WAR.Data["����1"] = enemy[pick]			
					end
					
					WAR.Data["�з�X1"] = 45;
					WAR.Data["�з�Y1"] = 15;
				end
    	end
    	
    if WAR.ZDDH == 185 then				--brolycjw��ս
			WAR.Data["����14"] = 65;
			WAR.Data["�з�X14"] = 44
			WAR.Data["�з�Y14"] = 22
			WAR.Data["����15"] = 55;
			WAR.Data["����16"] = 56;
			WAR.Data["�з�X15"] = 44
			WAR.Data["�з�Y15"] = 23
			WAR.Data["�з�X16"] = 44
			WAR.Data["�з�Y16"] = 24			
		end
		if WAR.ZDDH == 170 then
			if GetS(86,20,20,5) == 1 then			--brolycjw��սл�̿�
    			WAR.Data["����1"] = 164;
				for i = 2, 5 do
					WAR.Data["����".. i] = -1;
				end
			elseif GetS(86,20,20,5) == 2 then			--brolycjw��ս��ľ����
    			WAR.Data["����3"] = 38;
				WAR.Data["����4"] = -1;
				WAR.Data["����5"] = -1;
			else
				WAR.Data["����5"] = -1;
			end
		end
    	if WAR.ZDDH == 92 and GetS(87,31,33,5) == 1 then		--�������������´ﺣ
     		for i=2,5 do	
	 				WAR.Data["����" .. i] = -1;
     		end
			end
			
			--�������������߶�����
			if WAR.ZDDH == 91 and GetS(87,31,34,5) == 1 then
				WAR.Data["����1"] = 138
		    for i=2,12 do
			 		WAR.Data["����" .. i] = -1;
		    end
			end

			if WAR.ZDDH == 20 and GetS(87,31,35,5) == 1 then
   		 	WAR.Data["����1"] = 9999;--��ʱ�������ݴ�����ħ 
   		end
   		
			if WAR.ZDDH == 20 and GetS(87,31,35,5) == 2 then
				WAR.Data["����1"] = 92
			end

			
			--�����壺���°�ʮ��ͭ�˵�λ�ã�����ʱ��λ��
			if WAR.ZDDH == 217 and GetS(86,1,2,5) == 1 then
				--������ͭ�˷����ſ�λ��
				WAR.Data["�з�X16"] = 40
				WAR.Data["�з�Y16"] = 40
				
				WAR.Data["�з�X17"] = 40
				WAR.Data["�з�Y17"] = 38
				
				WAR.Data["�з�X18"] = 40
				WAR.Data["�з�Y18"] = 42
			end
			
			--�����壺���°�ʮ��ͭ�˵�λ�ã�Ⱥսʱ��λ��
			if WAR.ZDDH == 217 and GetS(86,1,2,5) == 2 then
				for i=1,9 do
					WAR.Data["�з�X" .. i] = 22
					WAR.Data["�з�Y" .. i] = 32 + i;
				end
				
				for i=10, 18 do
					WAR.Data["�з�X" .. i] = 27
					WAR.Data["�з�Y" .. i] = 32 + (i-9);
				end
			end
			
			
			
			
			
			--�����壺�Ѷ�3���з�С���书�ȼ����Ϊ��
			if JY.Thing[202][WZ7] > 2 then
				if JY.Person[WAR.Data["����" .. i]]["�书�ȼ�1"] ~= 999 then
					if math.random(1) then
						JY.Person[WAR.Data["����" .. i]]["�书�ȼ�1"] = 999;
					end
				end
			end
			
    	WAR.Person[WAR.PersonNum]["������"] = WAR.Data["����" .. i]
      WAR.Person[WAR.PersonNum]["�ҷ�"] = false
      WAR.Person[WAR.PersonNum]["����X"] = WAR.Data["�з�X" .. i]
      WAR.Person[WAR.PersonNum]["����Y"] = WAR.Data["�з�Y" .. i]
      WAR.Person[WAR.PersonNum]["����"] = false
      WAR.Person[WAR.PersonNum]["�˷���"] = 1
      WAR.PersonNum = WAR.PersonNum + 1
    end
  end
end--ս������ѡ��
function WarSelectTeam()
  WAR.PersonNum = 0
  
  
  --brolycjw���Զ����Զ�ѡ���ս��
  --������֮�󣬻�ֱ��ս������������ѡ�����
  if WAR.ZDDH == 79 then				--ս�����
	if GetS(86, 11, 12, 5) == 1 then			--brolycjw��ɱ����
		WAR.Data["�Զ�ѡ���ս��1"] = 0;
		WAR.Data["�ҷ�X1"] = 22
		WAR.Data["�ҷ�Y1"] = 38
		
		WAR.Data["�Զ�ѡ���ս��2"] = 59;
		WAR.Data["�ҷ�X2"] = 23
		WAR.Data["�ҷ�Y2"] = 38

	elseif GetS(86,15,2,5) > 0 then
		WAR.Data["�Զ�ѡ���ս��1"] = GetS(86,15,1,5);
	end
  end
  
  --�������������´ﺣ
	if WAR.ZDDH == 92 and GetS(87,31,33,5) == 1 then
	  	WAR.Data["�Զ�ѡ���ս��1"] = 0;
	  	WAR.Data["�ҷ�X1"] = 43
	  	WAR.Data["�ҷ�Y1"] = 25
	end
	
	--�������������߶�����
	if WAR.ZDDH == 91 and GetS(87,31,34,5) == 1 then
  	WAR.Data["�Զ�ѡ���ս��1"] = 0;
  	WAR.Data["�ҷ�X1"] = 21
  	WAR.Data["�ҷ�Y1"] = 28
	end
	
	
	--�����壺���°�ʮ��ͭ�ˣ�Ⱥս���ҷ���λ��
	if WAR.ZDDH == 217 and GetS(86,1,2,5) == 2 then
		for i=1, 6 do
			WAR.Data["�ҷ�X" .. i] = 25;
			if i < 4 then
				WAR.Data["�ҷ�Y" .. i] = 38 - i
			else
				WAR.Data["�ҷ�Y" .. i] = 38 + (i-4)
			end
		end
	end
	
	--��ս�����ҷ�λ��
	if WAR.ZDDH == 226 and GetS(86, 1, 9, 5) == 1 then
		for i=1, 6 do
			WAR.Data["�ҷ�X" .. i] = 48;
			if i < 4 then
				WAR.Data["�ҷ�Y" .. i] = 34 - i;
			else
				WAR.Data["�ҷ�Y" .. i] = 34 + (i-4)
			end
		end
	end
	
	--������ս���ҷ�λ��
	if WAR.ZDDH == 79 then
		if GetS(86,15,2,5) > 0 then
			WAR.Data["�ҷ�X1"] = 51;
			WAR.Data["�ҷ�Y1"] = 15;
		end
		
	end

  
  for i = 1, 6 do
    local id = WAR.Data["�Զ�ѡ���ս��" .. i]
    if id >= 0 then
      WAR.Person[WAR.PersonNum]["������"] = id
      WAR.Person[WAR.PersonNum]["�ҷ�"] = true
      WAR.Person[WAR.PersonNum]["����X"] = WAR.Data["�ҷ�X" .. i]
      WAR.Person[WAR.PersonNum]["����Y"] = WAR.Data["�ҷ�Y" .. i]
      WAR.Person[WAR.PersonNum]["����"] = false
      WAR.Person[WAR.PersonNum]["�˷���"] = 2
      WAR.PersonNum = WAR.PersonNum + 1
    end
  end
  
  --�����壺Ⱥսʮ��ͭ��ս
  if WAR.ZDDH == 217 and GetS(86,1,2,5) == 2 then
  	WAR.PersonNum = 0;
  end
  
  if WAR.PersonNum > 0 and WAR.ZDDH ~= 235 then
    return 
  end
  
  for i = 1, CC.TeamNum do
    WAR.SelectPerson[i] = 0
    local id = JY.Base["����" .. i]
    if id >= 0 then
      for j = 1, 6 do
        if WAR.Data["�ֶ�ѡ���ս��" .. j] == id then
          WAR.SelectPerson[i] = 1
        end
      end
    end
  end
  
  
  local menu = {}
  for i = 1, CC.TeamNum do
    menu[i] = {"", WarSelectMenu, 0}
    local id = JY.Base["����" .. i]
    if id >= 0 then
      menu[i][3] = 1
      local s = JY.Person[id]["����"]
      if WAR.SelectPerson[i] == 1 then
        menu[i][1] = "*" .. s
      else
     		menu[i][1] = " " .. s
      end
    end
  end
  
  menu[CC.TeamNum + 1] = {" ����", nil, 1}
  
  while true do
    Cls()
    local x = (CC.ScreenW - 7 * CC.DefaultFont - 2 * CC.MenuBorderPixel) / 2
    DrawStrBox(x, 10, "��ѡ���ս����", C_WHITE, CC.DefaultFont)
    local r = ShowMenu(menu, CC.TeamNum + 1, 0, x, 10 + CC.SingleLineHeight, 0, 0, 1, 0, CC.DefaultFont, C_ORANGE, C_WHITE)
    Cls()
    for i = 1, 6 do
      if WAR.SelectPerson[i] > 0 then
        WAR.Person[WAR.PersonNum]["������"] = JY.Base["����" .. i]
        WAR.Person[WAR.PersonNum]["�ҷ�"] = true
        WAR.Person[WAR.PersonNum]["����X"] = WAR.Data["�ҷ�X" .. i]
        WAR.Person[WAR.PersonNum]["����Y"] = WAR.Data["�ҷ�Y" .. i]
        WAR.Person[WAR.PersonNum]["����"] = false
        WAR.Person[WAR.PersonNum]["�˷���"] = 2
        WAR.PersonNum = WAR.PersonNum + 1
      end
    end
    if WAR.PersonNum > 0 then
      break;
    end
  end
end




--����ս��������ͼ
function WarCalPersonPic(id)
  local n = 5106
  n = n + JY.Person[WAR.Person[id]["������"]]["ͷ�����"] * 8 + WAR.Person[id]["�˷���"] * 2
  return n
end
--�ѷ�ս��ʱѡ������Ĳ˵�
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
-- ս���Ƿ����
function War_isEnd()
  for i = 0, WAR.PersonNum - 1 do
    if JY.Person[WAR.Person[i]["������"]]["����"] <= 0 then
      WAR.Person[i]["����"] = true
    end
  end
  WarSetPerson()
  Cls()
  ShowScreen()
  local myNum = 0
  local EmenyNum = 0
  for i = 0, WAR.PersonNum - 1 do
    if WAR.Person[i]["����"] == false then
      if WAR.Person[i]["�ҷ�"] == true then
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

--����ս��ȫ�ֱ���
function WarSetGlobal()
  WAR = {}
  WAR.Data = {}
  WAR.SelectPerson = {}
  WAR.Person = {}
  for i = 0, 30 do
    WAR.Person[i] = {}
    WAR.Person[i]["������"] = -1
    WAR.Person[i]["�ҷ�"] = true
    WAR.Person[i]["����X"] = -1
    WAR.Person[i]["����Y"] = -1
    WAR.Person[i]["����"] = true
    WAR.Person[i]["�˷���"] = -1
    WAR.Person[i]["��ͼ"] = -1
    WAR.Person[i]["��ͼ����"] = 0
    WAR.Person[i]["�Ṧ"] = 0
    WAR.Person[i]["�ƶ�����"] = 0
    WAR.Person[i]["����"] = 0
    WAR.Person[i]["�Զ�ѡ�����"] = -1
    WAR.Person[i].Move = {}
    WAR.Person[i].Action = {}
    WAR.Person[i].Time = 0
    WAR.Person[i].TimeAdd = 0
    WAR.Person[i].SpdAdd = 0
    WAR.Person[i].Point = 0
    WAR.Person[i]["��Ч����"] = -1
    WAR.Person[i]["�����书"] = -1
    WAR.Person[i]["��Ч����1"] = nil
    WAR.Person[i]["��Ч����2"] = nil
    WAR.Person[i]["��Ч����3"] = nil
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
  WAR.CHZ = {}		--�Զ���ٻ�ֵ
  WAR.LXXS = {}
  WAR.SZJPYX = {}
  WAR.TZ_DY = 0
  WAR.TZ_XZ = 0
  WAR.TZ_XZ_SSH = {}
  WAR.BFX = 0
  WAR.BLX = 0

  
  WAR.JYFX = {}			--brolycjw: ������Ѩ
  WAR.L_TLD = 0;		--װ����������Ч��1��Ѫ
  WAR.L_YTJ1 = 0;		--װ�����콣��Ч��1��Ѫ
  WAR.L_YTJ2 = 0;		--װ�����콣��Ч��1��Ѩ
  WAR.L_LWX = 0;		--��������ɫָ�һ��ս������һ��
  
  WAR.L_SSBD = 0;		--ˮ���Ƿ񷢶�����������Ч
  WAR.L_SGHT = 0;		--�Ƿ����񹦻���
  WAR.L_SGJL = 0;		--�Ƿ����񹦼���
  WAR.L_LXXL = 0;		--����������������ɳٻ�
  WAR.B_BMJQ = 0;		--��ڤ��������
  
  WAR.L_EffectColor = {}		--�Զ����ս����ɫ��ʾ
  WAR.L_EffectColor[1] = RGB(255, 10, 10);		--��ʾ��������
  WAR.L_EffectColor[2] = RGB(247, 212, 215);		--��ʾ��������
  WAR.L_EffectColor[3] = RGB(0, 102, 153);		--��ʾ�������ٺ�����
  WAR.L_EffectColor[4] = RGB(197, 207, 125);		--��ʾ�������ٺ�����
  WAR.L_EffectColor[5] = RGB(255, 236, 150);		--��ʾ��Ѩ
  WAR.L_EffectColor[6] = RGB(255, 236, 150);		--��ʾ��Ѫ
  WAR.L_EffectColor[7] = RGB(51, 204, 102);		--��ʾ�ж�
  WAR.L_EffectColor[8] = RGB(174, 239, 220);		--��ʾ�ⶾ
  WAR.L_EffectColor[9] = RGB(255, 10, 10);		--��ʾ���˼��ٺ�����
  
  WAR.L_ZXSG = 0;	 --�Ƿ���������ϼ��
  WAR.L_CZJT = 0;	--�Ƿ񷢶�������
  WAR.L_NYZH = {};		--�Ƿ񴥷������߻�
  WAR.L_WNGZL = {};		--���ѹ�ָ������ж���Ѫ
  WAR.L_HQNZL = {};		--����ţָ�������Ѫ������
  
  WAR.L_TXSG = {};	--��¼��̫���񹦼����������ĵ���
  WAR.L_NOT_MOVE = {};		--��¼�����ƶ�����
  WAR.L_LZJF_ATK = {};		--���𽣷���ÿ�ι����ۼ�50�㹥������������300�㣬���ʹ�������书�ӳɹ��������ҹ����ۼӹ�0
  WAR.L_LZJFCC = 0			--�Ƿ��Ѿ��ۼӹ����𽣷�
  
  WAR.L_RYJF = {};		--���ƽ�����ÿ�ι���������3�������ʣ�200��ɱ�����������ۼ�5�Ρ�ʹ�������书���ͷ��ۼ�ֵ
  WAR.L_RYJFCC = 0;		--�Ƿ��Ѿ��ۼӹ����ƽ���
  WAR.L_QKDNY = {};		--�趨���������ʱ��Ǭ��ֻ�ܱ���һ��
  WAR.L_MJJF = 0;			--���������ʽ
  WAR.L_WYJFA = 0;		--��������
  WAR.L_NSDF = {};		--��ɽ�������л���ʹ�������ĵ�λ�»غ��ܵ���ɱ�������˺��ӱ�
  WAR.L_NSDFCC = 0;		--��ɽ�����Ƿ񴥷���Ч
  
  
  WAR.L_DGQB_X = 1;		--������ܱ�������X
  WAR.L_DGQB_DEF = 0;		--��ʼû�У�1��ȭ������2����������3����������4���ع���
  WAR.L_DGQB_ZS = {"����һʽ", "���¶�ʽ", "������ʽ", "������ʽ", "������ʽ", "������ʽ","������ʽ", "���°�ʽ", "���¾�ʽ", "���¼��⡤����ʤ����"};
  WAR.L_DGQB_DEF_STR = {"����ʽ", "�ƽ�ʽ", "�Ƶ�ʽ", "����ʽ", "����ʽ"}
  
  WAR.L_DGQB_ZL = 0;		--�ٻ�������ܣ�һ��ս��ֻ��һ��

	WAR.EFT = {}
	WAR.EFTNUM = 0;
  
  --��ʦ���˿���
  WAR.ZSJT = 1;		--Ĭ�ϴ�
	
end


--��ʾ�����ս����Ϣ������ͷ��������������
function WarShowHead(id)
  if not id then
    id = WAR.CurID
  end
  if id < 0 then
    return 
  end
  local pid = WAR.Person[id]["������"]
  local p = JY.Person[pid]
  local h = CC.DefaultFont
  local width = CC.Fontsmall*10 + 2 * CC.MenuBorderPixel
  local height = (CC.Fontsmall+CC.RowPixel)*11  + 2 * CC.MenuBorderPixel
  local x1, y1 = nil, nil
  local i = 1
  if WAR.Person[id]["�ҷ�"] == true then
    x1 = CC.ScreenW - width - 10
    y1 = CC.ScreenH - height - CC.ScreenH/6
    DrawBox(x1, y1, x1 + width, y1 + height + CC.ScreenH/6, C_WHITE)
  else
    x1 = 10
    y1 = 10
    DrawBox(x1, y1, x1 + width, y1 + height + 30, C_WHITE)
  end
  
  --local headw, headh = lib.PicGetXY(1, p["ͷ�����"] * 2)
	local headw, headh = lib.GetPNGXY(1, p["ͷ�����"])
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
    --lib.PicLoadCache(1, p["ͷ�����"] * 2, x1 + 5 + headx, y1 + 5 + heady, 1)
		lib.LoadPNG(1, p["ͷ�����"]*2, x1 + 5 + headx, y1 + 5 + heady, 1)
  end
  x1 = x1 + CC.RowPixel
  y1 = y1 + CC.RowPixel + CC.ScreenH/6 + h
  local color = nil
  if p["���˳̶�"] < p["�ж��̶�"] then
    if p["�ж��̶�"] == 0 then
      color = RGB(252, 148, 16)
    elseif p["�ж��̶�"] < 50 then
      color = RGB(120, 208, 88)
    else
      color = RGB(56, 136, 36)
    end
  elseif p["���˳̶�"] < 33 then
    color = RGB(236, 200, 40)
  elseif p["���˳̶�"] < 66 then
    color = RGB(244, 128, 32)
  else
    color = RGB(232, 32, 44)
  end
  MyDrawString(x1, x1 + width, y1 + CC.RowPixel, p["����"], color, CC.DefaultFont)
  y1 = y1 + CC.DefaultFont + CC.RowPixel
  
  
  
  DrawString(x1 + 3, y1 + CC.RowPixel, "��:", C_ORANGE, CC.Fontsmall)
  DrawString(x1 + 3, y1 + CC.RowPixel + CC.RowPixel + CC.Fontsmall, "��:", C_ORANGE, CC.Fontsmall)
  DrawString(x1 + 3, y1 + CC.RowPixel + 2*(CC.RowPixel + CC.Fontsmall), "��:", C_ORANGE, CC.Fontsmall)
  DrawString(x1 + 3, y1 + CC.RowPixel + 3*(CC.RowPixel + CC.Fontsmall), "��:", C_ORANGE, CC.Fontsmall)
  DrawString(x1 + 3, y1 + CC.RowPixel + 4*(CC.RowPixel + CC.Fontsmall), "��:", C_ORANGE, CC.Fontsmall)
  

  --��ɫ��
  local pcx = x1 + 3 + 2*CC.Fontsmall - CC.RowPixel;
  local pcy = y1 + CC.RowPixel
  
  --������
  lib.LoadPNG(1, 325 * 2 , pcx  , pcy, 1)
  local pcw, pch = lib.GetPNGXY(1, 324 * 2);
  lib.SetClip(pcx, pcy, pcx + (p["����"]/p["�������ֵ"])*pcw, pcy + pch)
  lib.LoadPNG(1, 324 * 2 , pcx  , pcy, 1,0,0,0,(p["����"]/p["�������ֵ"])*pcw,pch)
  pcy = pcy + CC.RowPixel + CC.Fontsmall
  lib.SetClip(0,0,0,0)
  
  
  --������
  lib.LoadPNG(1, 325 * 2 , pcx  , pcy, 1)
  local pcw, pch = lib.GetPNGXY(1, 323 * 2);
  lib.SetClip(pcx, pcy, pcx + (p["����"]/p["�������ֵ"])*pcw, pcy + pch)
  lib.LoadPNG(1, 323 * 2 , pcx  , pcy, 1,0,0,0,(p["����"]/p["�������ֵ"])*pcw,pch)
  pcy = pcy + CC.RowPixel + CC.Fontsmall
  lib.SetClip(0,0,0,0)
  
  --������
  lib.LoadPNG(1, 325 * 2 , pcx  , pcy, 1)
  local pcw, pch = lib.GetPNGXY(1, 326 * 2);
  lib.SetClip(pcx, pcy, pcx + (p["����"]/100)*pcw, pcy + pch)
  lib.LoadPNG(1, 326 * 2 , pcx  , pcy, 1,0,0,0,(p["����"]/100)*pcw,pch)
  pcy = pcy + CC.RowPixel + CC.Fontsmall
  lib.SetClip(0,0,0,0)
  
  --ŭ����
  lib.LoadPNG(1, 325 * 2 , pcx  , pcy, 1)
  local pcw, pch = lib.GetPNGXY(1, 324 * 2);
  lib.SetClip(pcx, pcy, pcx + ((WAR.LQZ[pid] or 0)/100)*pcw, pcy + pch)
  lib.LoadPNG(1, 324 * 2 , pcx  , pcy, 1,0,0,0,((WAR.LQZ[pid] or 0)/100)*pcw,pch)
  pcy = pcy + CC.RowPixel + CC.Fontsmall
  lib.SetClip(0,0,0,0)
  
  --�ж���
  lib.LoadPNG(1, 325 * 2 , pcx  , pcy, 1)
  local pcw, pch = lib.GetPNGXY(1, 322 * 2);
  lib.SetClip(pcx, pcy, pcx + (p["�ж��̶�"]/100)*pcw, pcy + pch)
  lib.LoadPNG(1, 322 * 2 , pcx  , pcy, 1,0,0,0,(p["�ж��̶�"]/100)*pcw,pch)
  
  lib.SetClip(0,0,0,0)
  
  local lifexs = p["����"].."/"..p["�������ֵ"]
  local nlxs = p["����"].."/"..p["�������ֵ"]
  local tlxs = p["����"].."/100"
  local lqzxs = WAR.LQZ[pid] or 0;
  local zdxs = p["�ж��̶�"]
  
  --�ѷ�����ʾ��
  local nsxs = p["���˳̶�"];		--����
  local fxxs = WAR.FXDS[pid] or 0;		--��Ѩ
  local lxxs = WAR.LXZT[pid] or 0;		--��Ѫ
  local chxs = WAR.CHZ[pid] or 0;		--�ٻ�
  
  if p["���˳̶�"] < 33 then
      color = RGB(236, 200, 40)
    elseif p["���˳̶�"] < 66 then
      color = RGB(244, 128, 32)
    else
      color = RGB(232, 32, 44)
    end
  
  DrawString(x1 + 3 + 2*CC.Fontsmall, y1 + CC.RowPixel, lifexs, color, CC.Fontsmall)
  
  	if p["��������"] == 0 then
      color = RGB(208, 152, 208)
    elseif p["��������"] == 1 then
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
  
  DrawString(x1 + 3 + 3*CC.Fontsmall, y1 + CC.RowPixel + 4*(CC.RowPixel + CC.Fontsmall), zdxs, RGB(120, 208, 88), CC.Fontsmall)		--�ж�
  
  y1 = y1 + 5*(CC.RowPixel + CC.Fontsmall)
  if WAR.Person[id]["�ҷ�"] then
  	
  	local myx1 = 3;
  	local myy1 = 0;
  	DrawString(x1 + myx1, y1, "����:", C_ORANGE, CC.Fontsmall)
  	DrawString(x1 + CC.Fontsmall*5/2 + myx1, y1, nsxs, M_DarkSlateGray, CC.Fontsmall)		--����
  	myx1 = myx1 + CC.Fontsmall * 5;
  	
  	DrawString(x1 + myx1, y1, "��Ѫ:", C_ORANGE, CC.Fontsmall)
  	DrawString(x1 + myx1 + CC.Fontsmall*2 + 10, y1, lxxs, M_DarkRed, CC.Fontsmall)		--��Ѫ

		myx1 = 3;
		myy1 = CC.RowPixel + CC.Fontsmall;
  	DrawString(x1 + myx1, y1  + myy1, "��Ѩ:", C_ORANGE, CC.Fontsmall)
  	DrawString(x1 + CC.Fontsmall*5/2, y1 + myy1, fxxs, C_GOLD, CC.Fontsmall)		--��Ѩ
  	myx1 = myx1 + CC.Fontsmall * 5;
  	
		DrawString(x1 + myx1, y1  + myy1, "�ٻ�:", C_ORANGE, CC.Fontsmall)
  	DrawString(x1 + myx1 + CC.Fontsmall*5/2, y1 + myy1, lxxs, M_RoyalBlue, CC.Fontsmall)		--�ٻ�
  	
  	y1 = y1 + myy1
  	myx1 = 3;
		myy1 = CC.RowPixel + CC.Fontsmall;
		--���ѹ������ӳ�
		local atk = 0;
	  for i,v in pairs(CC.AddAtk) do
	    if v[1] == pid then
	      for wid = 0, WAR.PersonNum - 1 do
	        if WAR.Person[wid]["������"] == v[2] and WAR.Person[wid]["����"] == false then
	          atk = atk + v[3]
	        end
	      end
	    end
	  end
	  
	  --���ѷ������ӳ�
	  local def = 0;
	  for i,v in pairs(CC.AddDef) do
	    if v[1] == pid then
	      for wid = 0, WAR.PersonNum - 1 do
	        if WAR.Person[wid]["������"] == v[2] and WAR.Person[wid]["����"] == false then
	          def = def + v[3]
	        end
	      end
	    end
	  end
	  
	  --�����Ṧ�ӳ�
	  local spd = 0;
	  for i,v in pairs(CC.AddSpd) do
	    if v[1] == pid then
	      for wid = 0, WAR.PersonNum - 1 do
	        if WAR.Person[wid]["������"] == v[2] and WAR.Person[wid]["����"] == false then
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
  	DrawString(x1 + 3, y1 + myy1, "��:"..atk, ac, CC.Fontsmall)		--���Ѽӳ�
  	DrawString(x1 + CC.Fontsmall*7/2, y1 + myy1, "��:"..def, dc, CC.Fontsmall)		--���Ѽӳ�
  	DrawString(x1 + CC.Fontsmall*13/2, y1 + myy1, "��:"..spd, sc, CC.Fontsmall)		--���Ѽӳ�
  end
  
  
  if WAR.Person[id]["�ҷ�"] == false then
	y1 = y1 + 2*(CC.RowPixel + CC.Fontsmall)
    DrawBox(x1 - 5, y1, x1 + width - 5, y1 + CC.DefaultFont*6, C_WHITE)
    local hl = 1
    for i = 1, 4 do
      local wp = p["Я����Ʒ" .. i]
      local wps = p["Я����Ʒ����" .. i]
      if wp >= 0 then
        local wpm = JY.Thing[wp]["����"]
        DrawString(x1, y1 + hl * (CC.DefaultFont+CC.RowPixel), wpm .. wps, C_ORANGE, CC.DefaultFont)
        hl = hl + 1
      end
    end
  end
end

--�Զ�ѡ����ʵ��书
function War_AutoSelectWugong()
  local pid = WAR.Person[WAR.CurID]["������"]
  local probability = {}
  local wugongnum = 10
  for i = 1, 10 do
    local wugongid = JY.Person[pid]["�书" .. i]
    if wugongid > 0 then
      if JY.Wugong[wugongid]["�˺�����"] == 0 then
      
      	--ѡ��ɱ�������书������������������������С��������Է���һ�����书��
        if JY.Wugong[wugongid]["������������"] <= JY.Person[pid]["����"] then
          local level = math.modf(JY.Person[pid]["�书�ȼ�" .. i] / 100) + 1
          probability[i] = (JY.Person[pid]["������"] * 3 + JY.Wugong[wugongid]["������" .. level]) / 2
        else
          probability[i] = 0
        end
        
        --�ڹ�����
        if inteam(pid) and WAR.Person[WAR.CurID]["�ҷ�"] then
        	--�����壺�������߻�״̬�¿���ʹ�������񹦹���
          if wugongid > 88 and wugongid<109 then
          	if WAR.L_NYZH[pid] ~= nil and wugongid == 104 then
          	
          	elseif wugongid == 105 and pid == 36 then		--��ƽ֮ ��ʾ������
          	
          	elseif wugongid == 102 and pid == 38 then		--ʯ���� ��ʾ̫����
          	
          	elseif wugongid == 106 and pid == 9 then		--���޼� ��ʾ������
          	
          	elseif wugongid == 94 and pid == 37 then		----���� ��ʾ����
          		
            elseif (pid == 0 and GetS(4, 5, 5, 5) == 5) or pid == 48 then			--��ſ���ʹ���ڹ�
            	
            else
            	probability[i] = 0
            end
          end
        end
        
        --�������ɹ���
        if wugongid == 85 or wugongid == 87 or wugongid == 88  then
          probability[i] = 0
        end
        
        --��ת����
        if wugongid == 43 and inteam(pid) and pid ~= 51 then
          if pid == 0 and GetS(4, 5, 5, 5) == 5 then
          	probability[i] = 0
          else
          	probability[i] = 0
          end
        end
        
        --�����᲻�ô���ô
        if wugongid == 99 and pid == 5 then
          probability[i] = 0
        end
        
        --��bԪ������ʹ���ڹ�����
        if pid == 92 and wugongid > 84 and wugongid < 109 then
          probability[i] = 0
        end

      else
        probability[i] = 10		 --��С�ĸ���ѡ��ɱ����
      end
    else
      wugongnum = i - 1
      break;
    end
	  
  end
  
  if wugongnum ==  0 then			--���û���书��ֱ�ӷ���-1
  	return -1;
  end

	local maxoffense = 0		--������󹥻���
	for i = 1, wugongnum do
	  if maxoffense < probability[i] then
	    maxoffense = probability[i]
	  end
	end
	
	local mynum = 0			--�����ҷ��͵��˸���
	local enemynum = 0
	for i = 0, WAR.PersonNum - 1 do
	  if WAR.Person[i]["����"] == false then
	    if WAR.Person[i]["�ҷ�"] == WAR.Person[WAR.CurID]["�ҷ�"] then
	      mynum = mynum + 1
	    else
	    	enemynum = enemynum + 1
	    end
	  end
	end
	
	
	local factor = 0		--��������Ӱ�����ӣ����˶��������ȹ��������书��ѡ���������
	if mynum < enemynum then
	  factor = 2
	else
	  factor = 1
	end
	
	for i = 1, wugongnum do		--������������Ч��
	  local wugongid = JY.Person[pid]["�书" .. i]
	  if probability[i] > 0 then
	    if probability[i] < maxoffense*3/4 then		--ȥ��������С���书
	      probability[i] = 0
	    else
		    local extranum = 0			--�书������ϵĹ�����
		    for j,v in ipairs(CC.ExtraOffense) do
		      if v[1] == JY.Person[pid]["����"] and v[2] == wugongid then
		        extranum = v[3]
		        break;
		      end
		    end
		    local level = math.modf(JY.Person[pid]["�书�ȼ�" .. i] / 100) + 1
		    probability[i] = probability[i] + JY.Wugong[wugongid]["�ƶ���Χ".. level]  * factor*10
		    if JY.Wugong[wugongid]["ɱ�˷�Χ" .. level] > 0 then
		    	probability[i] = probability[i] + JY.Wugong[wugongid]["ɱ�˷�Χ" .. level]* factor*10
		    end
	    end
	  end
	end
	
	local s = {}		--���ո��������ۼ�
	local maxnum = 0
	for i = 1, wugongnum do
	  s[i] = maxnum
	  maxnum = maxnum + probability[i]
	end
	s[wugongnum + 1] = maxnum
	if maxnum == 0 then		--û�п���ѡ����书
	  return -1
	end
	
	local v = Rnd(maxnum)		 --���������
	local selectid = 0
	for i = 1, wugongnum do		--���ݲ������������Ѱ�������ĸ��书����
	  if s[i] <= v and v < s[i + 1] then
	    selectid = i
  	end
	end
	return selectid
end


--ս���书ѡ��˵�
function War_FightMenu()
  local pid = WAR.Person[WAR.CurID]["������"]
  local numwugong = 0
  local menu = {}
  for i = 1, 10 do
    local tmp = JY.Person[pid]["�书" .. i]
    if tmp > 0 then
      if JY.WGLVXS == 1 then
        menu[i] = {JY.Wugong[tmp]["����"] .. "��" .. JY.Person[pid]["�书�ȼ�" .. i], nil, 1}
      else
        menu[i] = {JY.Wugong[tmp]["����"], nil, 1}
      end
      
      --�����ٲ���ʾ
      if JY.Person[pid]["����"] < JY.Wugong[tmp]["������������"] then
        menu[i][3] = 0
      end
      
      --��ڤ�񹦡������󷨡����Ǵ󷨡���ת���Ʋ���ʾ
      if tmp == 85 or tmp == 87 or tmp == 88 or tmp == 43 then
        menu[i][3] = 0
      end
      
      --���������̹֮���ڹ��书����ʾ
      if pid ~= 48 and tmp > 88 and tmp < 109 then
        menu[i][3] = 0
      end
      
      --�������������ڹ��书��ʾ
      if pid == 0 and GetS(4, 5, 5, 5) == 5 and tmp > 88 and tmp < 109 then
        menu[i][3] = 1
      end
      
      --��ƽ֮ ��ʾ������
      if tmp == 105 and pid == 36 then
        menu[i][3] = 1
      end
       
      --ʯ���� ��ʾ̫����
      if tmp == 102 and pid == 38 then
        menu[i][3] = 1
      end
      
      --���޼� ��ʾ������
      if tmp == 106 and pid == 9 then
        menu[i][3] = 1
      end
      
      --���� ��ʾ����
      if tmp == 94 and pid == 37 then
        menu[i][3] = 1
      end
      
      --Ľ�ݸ� ��ʾ��ת����
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

--�Զ�ս��ʱ ��˼��
function War_Think()
  local pid = WAR.Person[WAR.CurID]["������"]
  local r = -1
  if JY.Person[pid]["����"] < 10 then
    r = War_ThinkDrug(4)
    if r >= 0 then
      return r
    end
    return 0
  end
  if JY.Person[pid]["����"] < 20 or JY.Person[pid]["���˳̶�"] > 50 then
    r = War_ThinkDrug(2)
	    if r >= 0 then
	    return r
  	end
  end
  
  local rate = -1
  if JY.Person[pid]["����"] < JY.Person[pid]["�������ֵ"] / 5 then
    rate = 90
  elseif JY.Person[pid]["����"] < JY.Person[pid]["�������ֵ"] / 4 then
      rate = 70
  elseif JY.Person[pid]["����"] < JY.Person[pid]["�������ֵ"] / 3 then
      rate = 50
  elseif JY.Person[pid]["����"] < JY.Person[pid]["�������ֵ"] / 2 then
      rate = 25
  end
  
  --����ʱ������ҩ
  if Rnd(100) < rate and WAR.LQZ[pid] ~= nil and WAR.LQZ[pid] ~= 100 then
    r = War_ThinkDrug(2)
    if r >= 0 then				--�����ҩ��ҩ
      return r
    else
    	r = War_ThinkDoctor()		--���û��ҩ������ҽ��
  		if r >= 0 then
    		return r
  		end
    end
  end

  --��������
  rate = -1
  if JY.Person[pid]["����"] < JY.Person[pid]["�������ֵ"] / 6 then
  	rate = 100
  elseif JY.Person[pid]["����"] < JY.Person[pid]["�������ֵ"] / 5 then
    rate = 75
  elseif JY.Person[pid]["����"] < JY.Person[pid]["�������ֵ"] / 4 then
    rate = 50
  end
  
  --�������������Ѫ�����ٳ�ҩ�Ļ���
 	if JY.Person[pid]["����"] == JY.Person[pid]["�������ֵ"] then
 		rate = rate - 50;
 	end
  
  if Rnd(100) < rate then
    r = War_ThinkDrug(3)
    if r >= 0 then
    	return r
  	end
  end
  
  
  rate = -1
  if CC.PersonAttribMax["�ж��̶�"] * 3 / 4 < JY.Person[pid]["�ж��̶�"] then
    rate = 60
  else
    if CC.PersonAttribMax["�ж��̶�"] / 2 < JY.Person[pid]["�ж��̶�"] then
      rate = 30
    end
  end
  
  --��Ѫ���£��ųԽⶾҩ
  if Rnd(100) < rate and JY.Person[pid]["����"] < JY.Person[pid]["�������ֵ"] / 2 then
    r = War_ThinkDrug(6)
    if r >= 0 then
    	return r
  	end
  end
  
  
  local minNeili = War_GetMinNeiLi(pid)
  if minNeili <= JY.Person[pid]["����"] then
    r = 1
  else
    r = 0
  end
  return r
end
--�Զ�����
function War_AutoFight()
  local wugongnum = War_AutoSelectWugong()
  if wugongnum <= 0 then
    War_AutoEscape()
    War_RestMenu()
    return 
  end
  unnamed(wugongnum)
end

--�Զ�ս��
function War_Auto()
  local pid = WAR.Person[WAR.CurID]["������"]
  WAR.ShowHead = 1
  WarDrawMap(0)
  ShowScreen()
  lib.Delay(CC.WarAutoDelay)
  WAR.ShowHead = 0
  if CC.AutoWarShowHead == 1 then
    WAR.ShowHead = 1
  end
  local autotype = War_Think()
  if WAR.Person[WAR.CurID]["�ҷ�"] or WAR.ZDDH == 238 then
    if JY.Person[pid]["����"] > 50 and JY.Person[pid]["����"] > 10 then
      autotype = 1
    else
    	autotype = 0
  	end
  end
  
  --�����壺�������߻��״̬�£���20%�Ļ��ʻ���Ϣһ��
  if autotype == 1 and inteam(pid) and JLSD(30, 45, pid) and WAR.L_NYZH[pid] ~= nil then
  	if JY.Person[pid]["����"] < JY.Person[pid]["�������ֵ"]*0.15 and JLSD(0, 50, pid) then
    	
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
    CurIDTXDH(WAR.CurID, 89,1, "��Ϣһ��")
    War_RestMenu()
  end
  return 0
end

--��������
function War_AddPersonLVUP(pid)
  local tmplevel = JY.Person[pid]["�ȼ�"]
  if CC.Level <= tmplevel then
    return false
  end
  if JY.Person[pid]["����"] < CC.Exp[tmplevel] then
    return false
  end
  while CC.Exp[tmplevel] <= JY.Person[pid]["����"] do
    tmplevel = tmplevel + 1
    if CC.Level <= tmplevel then
    	break;
    end
  end
  
  DrawStrBoxWaitKey(string.format("%s ������", JY.Person[pid]["����"]), C_WHITE, CC.DefaultFont)
  --���������ĵȼ�
	local leveladd = tmplevel - JY.Person[pid]["�ȼ�"]
	
	JY.Person[pid]["�ȼ�"] = JY.Person[pid]["�ȼ�"] + leveladd
	
	--�����������
	AddPersonAttrib(pid, "�������ֵ", (JY.Person[pid]["��������"] + Rnd(2) + 2) * leveladd * 4)
	
	JY.Person[pid]["����"] = JY.Person[pid]["�������ֵ"]
	JY.Person[pid]["����"] = CC.PersonAttribMax["����"]
	JY.Person[pid]["���˳̶�"] = 0
	JY.Person[pid]["�ж��̶�"] = 0
	
	--���Ե����ʼӳ�
	local function cleveradd()
	  local ca, rndnum = nil, nil
	  if CC.Debug then
	    rndnum = math.random(1)
	  else
	    rndnum = math.random(1)
	  end
	  ca = JY.Person[pid]["����"] / (rndnum + 4)
	  return ca
	end

	
	local theadd = cleveradd()
	--�������������١�����
	--���������ĳɳ�
	AddPersonAttrib(pid, "�������ֵ", math.modf(leveladd * ((16 - JY.Person[pid]["��������"]) * 7 + 210 / (theadd + 1))))
	
	--�������ÿ�������50
	if pid == 0 and GetS(4, 5, 5, 5) == 5 then
	  AddPersonAttrib(pid, "�������ֵ", 50 * leveladd)
	end
	JY.Person[pid]["����"] = JY.Person[pid]["�������ֵ"]
	
	--ѭ�������ȼ����ۼ�����
	for i = 1, leveladd do
	  local ups = math.modf((JY.Person[pid]["����"] - 1) / 15) + 1
	  
	  --����� ���˻ظ�ǰ��ÿ��3��
	  if pid == 35 and GetD(82, 1, 0) == 1 then
	    ups = 3
	  end
	  
	  --���� 20��֮��ÿ��6��
	  if pid == 55 and JY.Person[pid]["�ȼ�"] > 20 then
	    ups = 6
	  end
	  
	  --����ߣ�ÿ��8��
	  if T1LEQ(pid) then
	    ups = 8
	  end
	  
	  --�Ѷȶ���ӳ�
	  ups = ups + JY.Thing[202][WZ7]  
	  
	  AddPersonAttrib(pid, "������", ups)
	  AddPersonAttrib(pid, "������", ups)
	  AddPersonAttrib(pid, "�Ṧ", ups)
	  
	  
	  --�޸�ҽ�ơ��ö����ⶾ��������ȼ��ҹ�������
	  if JY.Person[pid]["ҽ������"] >= 20 then
  		AddPersonAttrib(pid, "ҽ������", math.random(2))
		end
		if JY.Person[pid]["�ö�����"] >= 20 then
  		AddPersonAttrib(pid, "�ö�����", math.random(2))
		end
		if JY.Person[pid]["�ⶾ����"] >= 20 then
  		AddPersonAttrib(pid, "�ⶾ����", math.random(2))
		end
		
		--�¼��� ��������Χ
		if pid == 75 then
		  if JY.Person[pid]["ȭ�ƹ���"] >= 0 then
		    AddPersonAttrib(pid, "ȭ�ƹ���", math.random(3))
		  end
		  if JY.Person[pid]["��������"] >= 0 then
		    AddPersonAttrib(pid, "��������", (7 + math.random(0,1)))
		  end
		  if JY.Person[pid]["ˣ������"] >= 0 then
		    AddPersonAttrib(pid, "ˣ������", (7 + math.random(0,1)))
		  end
		  if JY.Person[pid]["�������"] >= 0 then
		  	AddPersonAttrib(pid, "�������", (7 + math.random(0,1)))
			end
		end
		
		--����ÿ�����
		if JY.Person[pid]["��������"] >= 20 then
		  AddPersonAttrib(pid, "��������", math.random(2))
		end
	end

	local ey = 1;  --ÿ�����������
	ey = ey + JY.Thing[202][WZ7] - 1;
  
  local n = ey*leveladd;		--��������������

	--�Ѷ�һ ����������
	if JY.Thing[202][WZ7] == 1 then
		local a = math.random(n+1)-1;
		local b = limitX(math.random(n+1-a)-1,0,n);
		local c = limitX(math.random(n+1-a-b)-1,0,n);
	  AddPersonAttrib(pid,"������",a);
	  AddPersonAttrib(pid,"������",b);
	  AddPersonAttrib(pid,"�Ṧ",c);
	  
	--���Ѷ����ɷ���
	else
		local gj = JY.Person[pid]["������"];
	  local fy = JY.Person[pid]["������"];
	  local qg = JY.Person[pid]["�Ṧ"];
	  local tmpN = n;
		repeat
	  	Cls();
	  	
			local title = JY.Person[pid]["����"].." ������������";
			local str = string.format("ʣ��Ķ����������������%d ��*������%d*������%d*�Ṧ��%d",tmpN, gj, fy, qg);
			local btn = {"�ӹ�","�ӷ�","����","����","ȷ��"};
			local num = #btn;
			local r = JYMsgBox(title,str,btn,num);
			Cls();
			if tmpN == 0 and r < 4 then
				DrawStrBoxWaitKey("�Բ����Ѿ�û�пɷ����������ѡ��ȷ���������á�", C_WHITE, CC.DefaultFont)
			else
				if r ==  1 then			--���빥����
			    local r = InputNum("���������Ĺ���������", 1, tmpN, 1)
			    
			    if r ~= nil then
			    	gj =  gj + r
			    	tmpN = tmpN-r
			    end
	
				elseif r ==  2 then		--���������
			    local r = InputNum("���������ķ���������", 1, tmpN, 1)
			    
			    if r ~= nil then
			    	fy =  fy + r
			    	tmpN = tmpN-r
			    end
		
				elseif r ==  3 then		--�����Ṧ
			    local r = InputNum("�����������Ṧ����", 1, tmpN, 1)
			    
			    if r ~= nil then
			    	qg =  qg + r
			    	tmpN = tmpN-r
			    end
				elseif r == 4 then
					gj = JY.Person[pid]["������"];
		  	  fy = JY.Person[pid]["������"];
		  		qg = JY.Person[pid]["�Ṧ"];
		  	  tmpN = n;
				elseif r == 5 then
					if tmpN > 0 then
						DrawStrBoxWaitKey("�Բ���"..JY.Person[pid]["����"].."����ʣ��ĵ���û��!", C_WHITE, CC.DefaultFont)
					else
						JY.Person[pid]["������"] = gj;
						JY.Person[pid]["������"] = fy;
						JY.Person[pid]["�Ṧ"] = qg;
						n = 0;
					end
				end
			end
	 	until n == 0
	end
	
	return true
end



--ս������������
--isexp ����ֵ
--warStatus ս��״̬
function War_EndPersonData(isexp, warStatus)
  for i = 0, WAR.PersonNum - 1 do
    local pid = WAR.Person[i]["������"]
    
    --�з��ظ���״̬
    if not instruct_16(pid) then
      JY.Person[pid]["����"] = JY.Person[pid]["�������ֵ"]
      JY.Person[pid]["����"] = JY.Person[pid]["�������ֵ"]
      JY.Person[pid]["����"] = CC.PersonAttribMax["����"]
      JY.Person[pid]["���˳̶�"] = 0
      JY.Person[pid]["�ж��̶�"] = 0
    end
  end
  
  
  for i = 0, WAR.PersonNum - 1 do
    local pid = WAR.Person[i]["������"]
    if instruct_16(pid) then
      if warStatus == 1 then
        JY.Person[pid]["����"] = JY.Person[pid]["����"] + math.modf((JY.Person[pid]["�������ֵ"] - JY.Person[pid]["����"]) * 0.3)
        JY.Person[pid]["����"] = JY.Person[pid]["����"] + math.modf((JY.Person[pid]["�������ֵ"] - JY.Person[pid]["����"]) * 0.3)
        JY.Person[pid]["����"] = JY.Person[pid]["����"] + math.modf((100 - JY.Person[pid]["����"]) * 0.3)
        JY.Person[pid]["���˳̶�"] = math.modf(JY.Person[pid]["���˳̶�"] / 2)
        JY.Person[pid]["�ж��̶�"] = math.modf(JY.Person[pid]["�ж��̶�"] / 2)
      else
	      if JY.Person[pid]["����"] < JY.Person[pid]["�������ֵ"] / 4 then
	        JY.Person[pid]["����"] = math.modf(JY.Person[pid]["�������ֵ"] / 4)
	      end
      end  
    end
    if JY.Person[pid]["����"] < 10 then
      JY.Person[pid]["����"] = 10
    end
  end
  
  --�Ƿ��书�ظ�
  JY.Person[50]["�书1"] = 26
  JY.Wugong[13]["����"] = "����"
  
  --��ؤ�����
  if WAR.ZDDH == 82 then
    SetS(10, 0, 18, 0, 1)
  end
  
  --ʮ��ͭ�ˣ�ս��ʤ��
  if WAR.ZDDH == 217 and warStatus == 1 then
    SetS(10, 0, 16, 0, 1)
  end
  
  --÷ׯ ͺ����ս����
  if WAR.ZDDH == 44 then
    instruct_3(55, 6, 1, 0, 0, 0, 0, -2, -2, -2, 0, -2, -2)
    instruct_3(55, 7, 1, 0, 0, 0, 0, -2, -2, -2, 0, -2, -2)
  end
  
  --÷ׯ �ڰ���ս��
  if WAR.ZDDH == 45 then
    instruct_3(55, 9, 1, 0, 0, 0, 0, -2, -2, -2, 0, -2, -2)
  end
  
  --÷ׯ ���ӹ�ս��
  if WAR.ZDDH == 46 then
    instruct_3(55, 13, 0, 0, 0, 0, 0, -2, -2, -2, 0, -2, -2)
  end
  
  
  --ս��ʧ�ܣ������޾���
  if warStatus == 2 and isexp == 0 then
    return 
  end
  
  --ͳ�ƻ������
  local liveNum = 0
  for i = 0, WAR.PersonNum - 1 do
    if WAR.Person[i]["�ҷ�"] == true and JY.Person[WAR.Person[i]["������"]]["����"] > 0 then
      liveNum = liveNum + 1
    end
  end
  
  --���侭��
  local canyu = false
  if warStatus == 1 then
    if WAR.Data["����"] < 1000 then
      WAR.Data["����"] = 1000
    end
    for i = 0, WAR.PersonNum - 1 do
      local pid = WAR.Person[i]["������"]
      if WAR.Person[i]["�ҷ�"] == true and inteam(pid) and JY.Person[pid]["����"] > 0 then
        if pid == 0 then
          canyu = true
        end
        for ii = 1, 10 do
          if JY.Person[pid]["�书" .. ii] == 98 then
            WAR.Person[i]["����"] = WAR.Person[i]["����"] + math.modf(WAR.Data["����"] * 1.5 / (liveNum))
          end
        end
        WAR.Person[i]["����"] = WAR.Person[i]["����"] + math.modf(WAR.Data["����"] / (liveNum))
      end
    end
  end
  
  --�����㾭��
  for i = 0, WAR.PersonNum - 1 do
    local pid = WAR.Person[i]["������"]
    AddPersonAttrib(pid, "��Ʒ��������", math.modf(WAR.Person[i]["����"] * 8 / 10))
    AddPersonAttrib(pid, "��������", math.modf(WAR.Person[i]["����"] * 8 / 10))
    if JY.Person[pid]["��������"] < 0 then
      JY.Person[pid]["��������"] = 0
    end
    War_PersonTrainBook(pid)     --�����ؼ�
    War_PersonTrainDrug(pid)		 --����ҩƷ
  end
  
  
  --�ѵȼ����������ؼ��ĺ���
  for i = 0, WAR.PersonNum - 1 do
  	local pid = WAR.Person[i]["������"]
	  if WAR.Person[i]["�ҷ�"] == true and inteam(pid) then
  		AddPersonAttrib(pid, "����", math.modf(WAR.Person[i]["����"] / 2))
      DrawStrBoxWaitKey(string.format("%s ��þ������ %d", JY.Person[pid]["����"], WAR.Person[i]["����"]), C_WHITE, CC.DefaultFont)
      War_AddPersonLVUP(pid)
    else
      AddPersonAttrib(pid, "����", WAR.Person[i]["����"])
    end
	end
  
  --�������
  if WAR.ZDDH == 48 then
    SetS(57, 52, 29, 1, 0)
    SetS(57, 52, 30, 1, 0)
    
  -- һ�ƾӣ�ŷ���棬��ǧ��
  elseif WAR.ZDDH == 175 then
      instruct_3(32, 12, 1, 0, 0, 0, 0, 0, 0, 0, -2, -2, -2)
      
  --
  elseif WAR.ZDDH == 82 then
      SetS(10, 0, 18, 0, 1)
      
  --�ƴ���
  elseif WAR.ZDDH == 214 then
      SetS(10, 0, 19, 0, 1)
  end
  
  --ʮ��ͭ��ս��ʤ��
  if WAR.ZDDH == 217 and warStatus == 1 then
    SetS(65, 1, 1, 5, 517)
  end
end
--ִ��ս�����Զ����ֶ�ս��������
--idս��������
--wugongnum ʹ�õ��书��λ��
--x,yΪս����������
function War_Fight_Sub(id, wugongnum, x, y)
	
  local pid = WAR.Person[id]["������"]
  local wugong = 0
  if wugongnum < 100 then
    wugong = JY.Person[pid]["�书" .. wugongnum]
  else
    wugong = wugongnum - 100
    wugongnum = 1
	  for i = 1, 10 do
	    if JY.Person[pid]["�书" .. i] == 43 then   --���ѧϰ�ж�ת����
	      wugongnum = i     --��¼��ת�书λ��
	  		break;
	    end
	  end
	  x = WAR.Person[WAR.CurID]["����X"] - x
	  y = WAR.Person[WAR.CurID]["����Y"] - y
	  WarDrawMap(0)   
	  local fj = nil
	  if WAR.DZXYLV[pid] == 110 then    --��ת������ʾ������
	    fj = string.format("%s������ϲ��̷���", JY.Person[pid]["����"])
	  elseif WAR.DZXYLV[pid] == 85 then
	      fj = string.format("%s������ת���Ʒ���", JY.Person[pid]["����"])
	  elseif WAR.DZXYLV[pid] == 60 then
	      fj = string.format("%s���������Ƴ�����", JY.Person[pid]["����"])
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
	
	
	--�����壺������ϼ�񹦣����ӽ�ϵ�书���˺��͹�����Χ
  if PersonKF(pid, 89) then
  	if (wugong == 110 or wugong == 114 or (wugong <= 48 and wugong >= 27)) and JY.Person[pid]["�书�ȼ�" .. wugongnum] == 999 then
  		JY.Wugong[wugong]["�ƶ���Χ10"] = JY.Wugong[wugong]["�ƶ���Χ10"]+2;
  		JY.Wugong[wugong]["ɱ�˷�Χ10"] = JY.Wugong[wugong]["ɱ�˷�Χ10"]+2;
  		
  		WAR.L_ZXSG = 1;		--��������ϼ�񹦣���������֮��Χ���뻹ԭ
  	end
  end
	
  WAR.WGWL = JY.Wugong[wugong]["������10"]
  local fightscope = JY.Wugong[wugong]["������Χ"]
  local kfkind = JY.Wugong[wugong]["�书����"]
  local level = JY.Person[pid]["�书�ȼ�" .. wugongnum]   --�ж��书�Ƿ�Ϊ��

  if level == 999 then
    level = 11
  else
    level = math.modf(level / 100) + 1
  end
  WAR.ShowHead = 0
  local m1, m2, a1, a2, a3, a4, a5 = refw(wugong, level)  --��ȡ�书�ķ�Χ
  local movefanwei = {m1, m2}   --���ƶ��ķ�Χ
  local atkfanwei = {a1, a2, a3, a4, a5}   --������Χ
  if WAR.SQFJ == 1 then   
    
  else
  	x, y = War_FightSelectType(movefanwei, atkfanwei, x, y,wugong)
  end
  
  --�����壺��ϼ�񹦽�ϵ������Χ�ظ�
  if WAR.L_ZXSG == 1 then
  	JY.Wugong[wugong]["�ƶ���Χ10"] = JY.Wugong[wugong]["�ƶ���Χ10"]-2;
  	JY.Wugong[wugong]["ɱ�˷�Χ10"] = JY.Wugong[wugong]["ɱ�˷�Χ10"]-2;
  	WAR.L_ZXSG = 2;
  end
  
  if x == nil then
  	WAR.L_ZXSG = 0;		--��ֹ����ѡ���书��ȡ�������
    return 0
  end
  
  --�����壺ʹ��С���๦����������仯�书
  if wugong == 98 then
  	local kfvl = 0;
  	while (kfvl < 800 or kfvl > 1100) do
  		wugong = math.random(JY.WugongNum - 1);
  		kfvl = JY.Wugong[wugong]["������10"];
  	end
  end
  
  
  
  --�жϺϻ�
  local ZHEN_ID = -1
  local x0, y0 = WAR.Person[WAR.CurID]["����X"], WAR.Person[WAR.CurID]["����Y"]
  for i = 0, WAR.PersonNum - 1 do
    if WAR.Person[WAR.CurID]["�ҷ�"] == WAR.Person[i]["�ҷ�"] and i ~= WAR.CurID and WAR.Person[i]["����"] == false and WAR.SQFJ ~= 1 then
      local nx = WAR.Person[i]["����X"]
      local ny = WAR.Person[i]["����Y"]
      local fid = WAR.Person[i]["������"]
      for j = 1, 10 do
	      if JY.Person[fid]["�书" .. j] == wugong then         
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
	            WAR.Person[i]["�˷���"] = 3 - War_Direct(x0, y0, x, y)
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
  
  
     
  local fightnum = 1  --��������
  
  
  --�ж�����
  if JY.Person[pid]["���һ���"] == 1  and WAR.ZYHB == 0 then
  	--�ж�����
	  local zyjl = 75 - JY.Person[pid]["����"]
	  if zyjl < 0 then
	    zyjl = 0
	  end
	  if pid == 64 then
	    zyjl = 100
	  end
	  if pid == 59 then
	    zyjl = 70
	  end
	  
	  --��������֮��ѡ��֪��
	  --����֮���������ҵĻ���
	  if pid == JY.MY and GetS(53, 0, 2, 5) == 1 and GetS(53, 0, 3, 5) == 1 then
	  	zyjl = zyjl + math.modf(JY.Person[pid]["����"]/8) + JY.Thing[202][WZ7]*2
	  end
  
  	if JLSD(0, zyjl, pid)  and WAR.DZXY == 0 and WAR.SQFJ ~= 1 then
	    WAR.ZYHB = 1
	
	    --�ĵ���Ч����0��ʾ
	    if WAR.Person[WAR.CurID]["��Ч����0"] ~= nil then
	    	WAR.Person[WAR.CurID]["��Ч����0"] = WAR.Person[WAR.CurID]["��Ч����0"] .."�����һ���";
	    else
	    	WAR.Person[WAR.CurID]["��Ч����0"] = "���һ���";
	    end
	  end
    
  end
      
  --�ж�����
  local LJ1 = math.modf(JY.Person[pid]["�Ṧ"] / 18)
  local LJ2 = math.modf((JY.Person[pid]["�������ֵ"] + JY.Person[pid]["����"]) / 1000)
  local LJ3 = math.modf(JY.Person[pid]["����"] / 10)
  local LJ = 0
  LJ = LJ1 + LJ2 + LJ3
  if WAR.Person[id]["�ҷ�"] then
    
  else
  	LJ = LJ + 20    --��������+20
  end
  
  for i = 1, 10 do
    if JY.Person[pid]["�书" .. i] == 47 then    --���¾Ž�����+10
      LJ = LJ + 10
    end
  end
  
  --�����壺�������߻��������10��
  if WAR.L_NYZH[pid] ~= nil then
  	LJ = LJ + 10
  end
  
  --local ljup = {10, 15, 42, 31, 54, 60, 68, 76, 79}   --�����书��ÿ������+5
  local ljup = {10, 15, 42, 31, 54, 60, 68, 76, 79,114}   --�����书��ÿ������+5�������壺114���ǽ���
  local up = 0
  for i = 1, 10 do
    if JY.Person[pid]["�书" .. i] > 0 then
      for ii = 1, 9 do
        if JY.Person[pid]["�书" .. i] == ljup[ii] then
          LJ = LJ + 5
          up = up + 1
        end
      end
    else
    	break;
    end
  end
      
  if T1LEQ(pid) then   --����ߣ�����+20
    LJ = LJ + 20
  end
      
  if pid == 59 then     --С��Ů������+10
    LJ = LJ + 10
  end

  
  local jp = math.modf(GetSZ(pid) / 25 + 1)   --ʵս������
  if jp > 20 then
    jp = 20
  end
  LJ = LJ + jp

  
  --�����壺���ƽ������ۼ�����
  if WAR.L_RYJF[pid] ~= nil then
  	LJ = LJ + 3*WAR.L_RYJF[pid];
  end
  
  if LJ > 100 then
    LJ = 100
  end
  if LJ < 10 then
    LJ = 10
  end
    
  local jl = math.random(200)    --�ж���������
  if jl > 60 and jl < 60 + LJ then
    fightnum = 2
  end
  if inteam(pid) and JLSD(50, 55, pid) then  --��5%�Ļ������ж�
    fightnum = 2
  end
  
  --brolycjw: ������ܵ�����
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
  --�������ǧ�𡢺�������ɍ�������� ����20%�Ķ��ι�������
  if (pid < 200 and (pid == 6 or pid == 67 or pid == 71 or pid == 18 or pid == 189) and fightnum ~= 2 and math.random(10) < 8) then
    fightnum = 2
  end
    
  if pid == 50 then   --�Ƿ�
    if WAR.ZDDH == 83 and WAR.FS == 0 then   --���İ���ʱ���Ƿ�
      say("����������Щ�����˴�������Ҳ�����ף�Ҳ�գ���ս���ԣ�̫�泤ȭ��������������ɣ���", 50)
      WAR.FS = 1
    end
    JY.Wugong[13]["����"] = "̫�泤ȭ"
    if JLSD(40, 70, pid) then   --����(70-40+10)%�Ķ��ι�������
      fightnum = 2
    end
    
    --����Ƿ��õ��ǽ�������ô��(55-45+10)%�Ļ�����������ŭ������ʱ������
    if JY.Person[pid]["�书" .. wugongnum] == 26 and (JLSD(45, 55, pid) or WAR.LQZ[pid] == 100) then
      fightnum = 3
      WAR.FS = 1
      for i = 1, 10 do
        DrawStrBox(-1, 24, "����������", C_ORANGE, 20 + i)   -- ����������������
        ShowScreen()
        lib.Delay(1)
      end
    end
    if JY.Person[pid]["����"] < math.modf(JY.Person[pid]["�������ֵ"] / 3) then    --���ķ�����������
    	JY.Person[pid]["����"] = math.modf(JY.Person[pid]["�������ֵ"] / 3)
    	
  	end
  end
    
  --�������ܣ�������
  if pid == 27 then
    fightnum = 3
  end
  
  --����壬����֮������(85-15)%������
  if pid == 35 and GetS(10, 1, 1, 0) == 1 and JLSD(15, 85, pid) then
    fightnum = 2
  end
  
  --С��Ů�����ʹ����Ů���Ľ�������
  if pid == 59 and JY.Person[pid]["�书" .. wugongnum] == 42 then
    fightnum = 2
  end
  
  --ŷ���棬�������һ����ʮ��аս���� WAR.tmp[1060]��û����
  if pid == 60 and WAR.tmp[1060] == 1 and (WAR.ZDDH == 176 or WAR.ZDDH == 133) then
    fightnum = 2
  end
  
  --�����ܵ���������(70-30+10)%�Ļ��ʱ�ɲ�����
  if WAR.ZDDH == 237 and pid == 18 and JLSD(30, 70, pid) then
    fightnum = 1
  end
  
  --�������书
  local glj = {7, 2, 34, 37, 55, 57, 70, 77}
  for i = 1, 8 do
    if JY.Person[pid]["�书" .. wugongnum] == glj[i] and JLSD(25, 75, pid) then
      fightnum = 2
      break;
    end
  end
    
  --�����У�ɱ�������̣�ֻ�ܵ���������
  if WAR.ZDDH == 54 and pid == 26 then
    fightnum = 1
  end
  
  --�����壺 brolycjwа�ߣ�С��Ů���������Ȼ�������������󷢳���Ȼ���� ��������
  if pid == 58 and JY.Person[pid]["�书" .. wugongnum] == 25 and JY.Person[pid]["�书�ȼ�" .. wugongnum] == 999 and GetS(86,11,11,5) == 2 then
  	local jl = 10;		--Ĭ�Ϸ�������Ϊ10%
  	if JY.Person[58]["���˳̶�"] > 50 then		--���˴���50ʱ�� ÿ����10�㼫������10%�����Ҽ����ٶ�����5
  		jl = jl + (JY.Person[58]["���˳̶�"]-50);		--ƽ�����ã���������Ϊ55ʱ������5%�Ļ���    		
  	end    
  	if JY.Person[58]["����"] < JY.Person[58]["�������ֵ"]/2 then		--�������ڶ���֮һʱ��ÿ��һ����������������10%
  		jl = jl + math.ceil((JY.Person[58]["�������ֵ"]/2 - JY.Person[58]["����"])/10);	  		
  	end
  
  	if jl > Rnd(100) then			--�жϼ��ⴥ�� ����
  		fightnum = 3;
  	end	
  end
  
  --�����壺װ�����佣ʱʹ��̫������������
  if JY.Person[pid]["����"] == 236  and  JY.Person[pid]["�书" .. wugongnum] == 46 then
  	fightnum = 2;
  end
  
  --�����壺��������
  if wugong == 30 or wugong == 31 or wugong == 32 or wugong == 33 or wugong == 34 then
  	local n = 0;
  	for i=1, 10 do
  		if (JY.Person[pid]["�书"..i] == 30 or JY.Person[pid]["�书"..i] == 31 or JY.Person[pid]["�书"..i] == 32 or JY.Person[pid]["�书"..i] == 33 or JY.Person[pid]["�书"..i] == 34) and JY.Person[pid]["�书�ȼ�"..i] == 999 then
  			n = n + 1
  		end
  	end
  	if n == 5 then		--70%�Ļ��ʴ���
  		--�򻨽���  ����Ѫ+����
  		--̩ɽʮ����   �ٻ�+����
  		--����ʮ��ʽ  ����Ѫ+����
  		--��������  �ط�Ѩ
  		--̫�������  ������
  		if JLSD(20, 90, pid) then
  			WAR.L_WYJFA = wugong;
  		else
  			WAR.L_WYJFA = -1;
  		end
  	end
  end
  
  --�彣̫����������
  if WAR.L_WYJFA == 34 and fightnum < 2 then
  	fightnum = 2;
  end
  
  --��������֮��ѡ��֪��
	--����֮��������������
	if pid == JY.MY and GetS(53, 0, 2, 5) == 1 and GetS(53, 0, 3, 5) == 1 then
  	if JLSD(0,JY.Person[pid]["����"]/10,pid)  then
  		fightnum = fightnum + 1
  	elseif JY.Person[pid]["���һ���"] == 0 and JLSD(0,JY.Person[pid]["����"]/4,pid)  then
  		fightnum = fightnum + 1
  	end
  end
  
  --���Ż�������
  --�����Է���Ϊ�����ڼ���֮����н�����Ч�����һ���Ҳ�Ƚϵ�
  if pid == JY.MY and GetS(53, 0, 2, 5) == 2 and GetS(53, 0, 5, 5) == 1 then
  	local rate = JY.Thing[238]["�辭��"]/100 + JY.Person[pid]["����"]/20
  	--�����ڻ�������ʱ���ӻ���
  	if JLSD(0,rate,pid) or (GetS(4, 5, 5, 5) == 6 and JLSD(0,15,pid)) then
  		fightnum = fightnum + 1
  	end
	end
	
	--��ʦ����������
	if pid == JY.MY and GetS(53, 0, 2, 5) == 3 then
		if JLSD(0,JY.Person[pid]["����"]/10,pid) or JLSD(0,JY.Person[pid]["����"]/200,pid) then
  		fightnum = fightnum + 1
  	elseif JY.Person[pid]["���һ���"] == 0 and JLSD(0,JY.Person[pid]["����"]/4,pid)  then
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
    if WAR.L_YTJ1 == 1 then	--װ�����콣��Ч��1��Ѫ
      WAR.L_YTJ1 = 0;	
    end
    if WAR.L_YTJ2 == 1 then	--װ�����콣��Ч��1��Ѩ
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
    
    WAR.L_CZJT = 0;			--������ Ĭ��Ϊ0
    WAR.L_TLD = 0		--װ����������Ч����Ѫ
    WAR.L_SSBD = 0;	--ˮ�Ϲ�����Ч���ٻ�
    WAR.L_SGJL = 0;	--�񹦼�����Ĭ��Ϊ0
    WAR.L_LXXL = 0;	--�����������������������ɳٻ�
    WAR.L_LZJFCC = 0		--���𽣷������Ƿ���Ч
    WAR.L_RYJFCC = 0		--���ƽ��������Ƿ���Ч
    
    WAR.L_QKDNY = {}	--���¼���Ǭ����Ų���Ƿ񱻷�����
    
    WAR.L_MJJF = 0;		--���������ʽ
    WAR.L_NSDFCC = 0;	--��ɽ�����Ƿ񴥷�
    
    
    WarDrawAtt(x, y, atkfanwei, 3)
    if ZHEN_ID >= 0 then
      local tmp_id = WAR.CurID
      WAR.CurID = ZHEN_ID
      WarDrawAtt(WAR.Person[ZHEN_ID]["����X"] + x0 - x, WAR.Person[ZHEN_ID]["����Y"] + y0 - y, atkfanwei, 3)
      WAR.CurID = tmp_id
    end
    if WAR.SQFJ == 1 then
      CleanWarMap(4, 0)
      for i = 0, WAR.PersonNum - 1 do
        if WAR.Person[i]["�ҷ�"] ~= WAR.Person[WAR.CurID]["�ҷ�"] and WAR.Person[i]["����"] == false then
          SetWarMap(WAR.Person[i]["����X"], WAR.Person[i]["����Y"], 4, 1)
        end
      end
    end
      
    --�жϹ�����������1
    if WAR.ACT > 1 then   
      local A = WAR.ACT.."����"    --��ʾ����
      if pid == 27 then
        A = "��������"    --��ʾ��������
      end
      
      --�ĵ���Ч����0��ʾ
      if WAR.Person[WAR.CurID]["��Ч����0"] ~= nil then
      	WAR.Person[WAR.CurID]["��Ч����0"] = WAR.Person[WAR.CurID]["��Ч����0"] .."��".. A
      else
      	WAR.Person[WAR.CurID]["��Ч����0"] = A;
      end
      
    end
      
    --���㱩��
    local BJ1 = math.modf(JY.Person[pid]["������"] / 18)
    local BJ2 = math.modf((JY.Person[pid]["�������ֵ"] + JY.Person[pid]["����"]) / 1000)
    local BJ3 = math.modf(JY.Person[pid]["����"] / 10)
    local BJ = 0
    BJ = BJ1 + BJ2 + BJ3
    if WAR.Person[id]["�ҷ�"] then
     
    else
    	BJ = BJ + 20     --����+20��
    end
    
    --�����Ѫ�������ķ�֮һʱ�������ʶ����ж� (80-10)%   ����ǵ���+10%
    if pid == 58 and JY.Person[pid]["����"] < JY.Person[pid]["�������ֵ"] / 4 and JLSD(10, 80, pid) then
      WAR.BJ = 1
    --�����Ѫ�����ڶ���֮һ�������ʶ����ж� (75-25)% ����ǵ���+10%
    elseif pid == 58 and JY.Person[pid]["����"] < JY.Person[pid]["�������ֵ"] / 2 and JLSD(25, 75, pid) then
      WAR.BJ = 1
    end
    
    --Ԭ��־�������� 30
    if pid == 54 then
      BJ = BJ + 30
    end
    
    --�ӱ������书
    local bjup = {18, 22, 39, 40, 56, 65, 71, 78, 74, 61}
    local up = 0
    for i = 1, 10 do
      if JY.Person[pid]["�书" .. i] > 0 then
        for ii = 1, 9 do
          if JY.Person[pid]["�书" .. i] == bjup[ii] then
            BJ = BJ + 5
            up = up + 1
          end
        end
      else
      	break;
      end
    end
    
    local jp = math.modf(GetSZ(pid) / 25 + 1)   --ʵս�ӳ�
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
    
    --�߱����ĵ��ˣ�Ѫ�����桢��ǧ�𡢺�����������С������ӡ������
    if (pid == 97 or pid == 67 or pid == 71 or pid == 26 or pid == 184 or pid == 189) and WAR.BJ ~= 1 and math.random(10) < 8 then
      WAR.BJ = 1
    end
    
    --���塢������ر���
    if pid == 50 or pid == 6 then
      WAR.BJ = 1
    end
    
    --��̹֮���а���Ϊ���ѱر���
    if pid == 48 then
      for j = 0, WAR.PersonNum - 1 do
        if WAR.Person[j]["������"] == 47 and WAR.Person[j]["����"] == false and WAR.Person[j]["�ҷ�"] == WAR.Person[WAR.CurID]["�ҷ�"] then
          WAR.BJ = 1
          break;
        end
      end
    end
    
    --���л�  ���޵��� �ر���
    if pid == 77 and JY.Person[pid]["�书" .. wugongnum] == 62 then
      WAR.BJ = 1
    end
    
    --ŷ���� ����״̬�±ر���
    if pid == 60 and WAR.tmp[1060] == 1 then
      WAR.BJ = 1
    end
    
    --�߱����书
    local gbj = {11, 13, 28, 33, 58, 59, 72, 75}
    for i = 1, 8 do
      if JY.Person[pid]["�书" .. wugongnum] == gbj[i] and JLSD(20, 75, pid) then
        WAR.BJ = 1
        break;
      end
    end
    
    --ŭ��ֵ100���ر���
    if WAR.LQZ[pid] == 100 and WAR.DZXY ~= 1 and WAR.SQFJ ~= 1 then
      WAR.BJ = 1
    end
    
    --�����壺װ��������������������ر�������������������40%������
    if JY.Person[pid]["����"] == 36 then
    	if wugong == 45 then
    		WAR.BJ = 1
    	elseif (wugong==114 or wugong==110 or (wugong>=27 and wugong<=49)) and JLSD(35, 75, pid) then
    		WAR.BJ = 1
    	end
    end
    
    --�����壺װ����������ʹ�õȼ�Ϊ���ĵ������40%�����ʣ��������������50%���ʴ����ɱ���������������Ѫ��ɱ���������书�����й�
	  if JY.Person[pid]["����"] == 43 then
	  	if (wugong==111 or (wugong>=50 and wugong<=67)) and JY.Person[pid]["�书�ȼ�" .. wugongnum] == 999 then
	  	 	if JLSD(35, 75, pid) then	
    			WAR.BJ = 1
    		end
    		
    		if WAR.BJ == 1 and JLSD(25, 75, pid) then
    			WAR.L_TLD = 1;
    		end
    	end
	  end
	  
	  --�����壺�������߻𱩻������20%
	  if WAR.L_NYZH[pid] ~= nil and JLSD(55, 75, pid) then
	  	WAR.BJ = 1;
	  end
	  
	  --�����壺������������������ �ر���
	  if (WAR.L_WYJFA == 30 or WAR.L_WYJFA == 31 or WAR.L_WYJFA == 32) then
	  	WAR.BJ = 1;
	  end
	  
	  local ng = 0

    
    if WAR.BJ == 1 then
      WAR.Person[id]["��Ч����"] = 89   --������Ч����
      if pid == 50 then    --�Ƿ�
        local r = nil
        r = math.random(3)
        if r == 1 then
        	War_Contact(id,"��Ч����1","�̵����ۼ� �������� ��Ӣ��ŭ");
        elseif r == 2 then
          WAR.Person[id]["��Ч����1"] = "����ǧ��������"  --����ǧ��������
        elseif r == 3 then
          WAR.Person[id]["��Ч����1"] = "��������  ����Ӣ����"  --��������  ����Ӣ����
        end
      elseif pid == 27 then   --��������
        WAR.Person[id]["��Ч����2"] = "�ճ�����  Ψ�Ҳ���"    --�ճ�����  Ψ�Ҳ���
      else
        WAR.Person[id]["��Ч����2"] = "��������"    --��������
      end
      
      --�ĳ���Ч����0��ʾ
      if WAR.Person[WAR.CurID]["��Ч����0"] ~= nil then
      	WAR.Person[WAR.CurID]["��Ч����0"] = WAR.Person[WAR.CurID]["��Ч����0"] .."��".. "����"
      else
      	WAR.Person[WAR.CurID]["��Ч����0"] = "����";
      end

    end
      
    
    
    --�����죬�����жϣ���Ӱ�����
    --��ת��ˮ���ķ���������
    if WAR.DZXY == 0 and WAR.SQFJ ~= 1 then
	    for i = 1, 10 do
	      local kfid = JY.Person[pid]["�书" .. i]
	      if kfid == 95 then    --��󡹦��Ч
	        if WAR.tmp[200 + pid] == nil then
	          WAR.tmp[200 + pid] = 0
	      	elseif WAR.tmp[200 + pid] > 100 then
	          ng = WAR.tmp[200 + pid] * 10 + 1500
	          
	          --����ѩɽ�� ����ɱ����
	          if PersonKFJ(pid, 9) then
	          	ng = ng + ng/2;
	          	War_Contact(id,"��Ч����2",JY.Wugong[kfid]["����"] .. "����������");
	          else
	          	War_Contact(id,"��Ч����2",JY.Wugong[kfid]["����"] .. "��������");
	          end

	          WAR.Person[id]["��Ч����"] = math.fmod(kfid, 10) + 85
	          WAR.L_CZJT = 1;		--���������죬�����϶�
	          break;
	        end
	      end
	    end
	  end
    
    --�����壺���ڹ���������
		local atkjl = {};		
		local num = 0;	--��ǰѧ�˶��ٸ������ڹ�
		for i = 1, 10 do
			local kfid = JY.Person[pid]["�书" .. i]
			
			--�޺���ħ����ʨ�𹦡������������ ���ȸ߻��ʴ�������
			if kfid == 96 or kfid == 92 or kfid == 103 then
				num = num + 1;
				atkjl[num] = {kfid,i};
			end
		end
		
		--�����жϽ������ڹ�����
		if num > 0 then
			if atkRandom(30, pid) or  (pid == 0 and GetS(4, 5, 5, 5) == 6 and JLSD(30, 55, pid)) then
				local n = math.random(num);
				local kfid = atkjl[n][1];
				local lv = math.modf(JY.Person[pid]["�书�ȼ�" .. atkjl[n][2]] / 100) + 1
				local wl = JY.Wugong[kfid]["������" .. lv];
				ng = ng + wl;
				War_Contact(id,"��Ч����2",JY.Wugong[kfid]["����"] .. "����");
		  	WAR.Person[id]["��Ч����"] = math.fmod(kfid, 10) + 85
		  	WAR.NGJL = kfid
			end
		end
		
		--���û�м������ټ����ж���ͨ�ڹ�
		if WAR.NGJL < 0 then
	    for i = 1, 10 do
	      local kfid = JY.Person[pid]["�书" .. i]
	      if kfid < 0 then
	      	break;
	      end
	      if kfid > 88 and kfid < 109 and kfid ~= 108 and kfid ~= 107 and kfid ~= 106 and kfid ~= 105 and kfid ~= 102 then     --�ڹ���Χ
		      
		      --���߶������ӻ���
		      if atkRandom(30, pid) or (pid == 0 and GetS(4, 5, 5, 5) == 6 and JLSD(30, 55, pid)) then
			      local lv = math.modf(JY.Person[pid]["�书�ȼ�" .. i] / 100) + 1
			      local wl = JY.Wugong[kfid]["������" .. lv]
			      if ng < wl then
			        ng = wl
			        WAR.Person[id]["��Ч����"] = math.fmod(kfid, 10) + 85
			        War_Contact(id,"��Ч����2",JY.Wugong[kfid]["����"] .. "����");
			        WAR.NGJL = kfid
			      end
			    end
		    end
	    end
	  end
    
    --�����壺���ڹ����񹦼����� ������Ҫ�������������
    local num = 0;
    local sg = {};
    for i = 1, 10 do
      local kfid = JY.Person[pid]["�书" .. i]
      if kfid < 0 then
	      	break;
	      end
      if kfid == 108 or (kfid == 107 and ((JY.Person[pid]["��������"]==0 or (pid==0 and GetS(4, 5, 5, 5) == 5)) or pid == 55)) or kfid == 105 or kfid == 102 then
      	num = num + 1;
      	sg[num] = {kfid, i};
      end
    end
    
    --�����Ƿ񴥷��񹦼���
    if num > 0 then
    	local n =  math.random(num);
    	local kfid = sg[n][1];
    	local lv = math.modf(JY.Person[pid]["�书�ȼ�" .. sg[n][2]] / 100) + 1
	    local wl = JY.Wugong[kfid]["������" .. lv]
    	
    	--�׽�񹦼�������������ɱ����
    	if kfid == 108 and atkdefRandom(20,pid) then
    		WAR.L_SGJL = kfid;
    		ng = ng + math.modf(wl/2) + 300;		--��������ɱ����
    		if WAR.Person[id]["��Ч����1"] ~= nil then
    			WAR.Person[id]["��Ч����1"] = WAR.Person[id]["��Ч����1"] .."+�׽��";
    		else
    			WAR.Person[id]["��Ч����1"] = "�׽��";
    		end
				WAR.Person[id]["��Ч����"] = 79
    	
    	--�����񹦼������˺���������40%
    	elseif kfid == 107 and atkRandom(25, pid) then
    		WAR.L_SGJL = kfid;
    		ng = ng + 500;
    		if WAR.Person[id]["��Ч����1"] ~= nil then
    			WAR.Person[id]["��Ч����1"] = WAR.Person[id]["��Ч����1"] .."+������";
    		else
    			WAR.Person[id]["��Ч����1"] = "������";
    		end
				WAR.Person[id]["��Ч����"] = 66

    	--�����񹦼���������ɴ�Ŀ
    	elseif kfid == 105 and (JLSD(30,60,pid) or (pid == 36 and  JLSD(40,60,pid))) then
    		WAR.L_SGJL = kfid;
    		if WAR.Person[id]["��Ч����1"] ~= nil then
    			WAR.Person[id]["��Ч����1"] = WAR.Person[id]["��Ч����1"] .."+������";
    		else
    			WAR.Person[id]["��Ч����1"] = "������";
    		end
				WAR.Person[id]["��Ч����"] = 44

    	--̫���񹦼�����ɱŭ��ֵ����ʹ�������ĵ������ӱ�
    	elseif kfid == 102 and (JLSD(30,60,pid)  or (pid == 38 and JLSD(40,60,pid))) then
    		WAR.L_SGJL = kfid;
    		if WAR.Person[id]["��Ч����1"] ~= nil then
    			WAR.Person[id]["��Ч����1"] = WAR.Person[id]["��Ч����1"] .."+̫����";
    		else
    			WAR.Person[id]["��Ч����1"] = "̫����";
    		end
				WAR.Person[id]["��Ч����"] = 63
    	end
  
    end
    
    --�����壺ʨ������Ч
    if wugong == 92 then
    	if WAR.Person[id]["��Ч����"] == -1 then
    		WAR.Person[id]["��Ч����"] = math.fmod(92, 10) + 85
    	end
    	
    	local nl = JY.Person[pid]["����"];
    	local f = 0;
    	
    	for j = 0, WAR.PersonNum - 1 do
        if WAR.Person[j]["�ҷ�"] ~= WAR.Person[WAR.CurID]["�ҷ�"] and WAR.Person[j]["����"] == false and JY.Person[WAR.Person[j]["������"]]["����"] < math.modf(nl*2/3) then
          f = 1;
          if pid == 13 then
          	WAR.Person[j].TimeAdd = WAR.Person[j].TimeAdd - 200    --лѷ�ã���200
          else
          	WAR.Person[j].TimeAdd = WAR.Person[j].TimeAdd - 100   --��ͨ��ɫ�ã�ȫ��������100
          end
        end
        
      end
      
      if f == 1 then
      	if WAR.Person[id]["��Ч����2"] == nil then
    			WAR.Person[id]["��Ч����2"] = "ս��"
    		else
    			WAR.Person[id]["��Ч����2"] = WAR.Person[id]["��Ч����2"] .. "+ս��";
    		end
      end

    end
		--�����壺ʨ�𹦼���
    if WAR.NGJL == 92 then
    	ng = ng + 1000 + JY.Person[pid]["����"]/5
    end
  
    --����������Ч
    if PersonKF(pid, 105) and WAR.Person[id]["��Ч����2"] == nil and math.random(10) < 6 then
      WAR.Person[id]["��Ч����"] = math.fmod(105, 10) + 85
      WAR.Person[id]["��Ч����2"] = "�����񹦼���"
      WAR.NGJL = 105
      ng = ng + 1000
    end
    
    --����֮��
    --����ѡ��֪��
    --���Ŷ�Ϊ��������ʴ����伲��磬С�������
    --�����������Ļ��ʣ���Ϊ����û�д��бȽ���
    if pid==JY.MY and GetS(53, 0, 2, 5) == 1 and GetS(53, 0, 3, 5) == 1 then
    	local rate = limitX(math.modf(JY.Person[pid]["����"]/4 + (100-JY.Person[pid]["����"])/10 + GetSZ(pid)/40 + JY.Person[pid]["������"]/50 + JY.Person[pid]["��ѧ��ʶ"]/10),0,100);
    	local low = 25;
    	
    	if GetS(53, 0, 4, 5) == 1 then
    		low = 15;
    	end
    	
    	if JLSD(low, rate, pid) then
    		WAR.Person[id]["��Ч����"] = 6
        if WAR.Person[id]["��Ч����2"] ~= nil then
        	WAR.Person[id]["��Ч����2"] = WAR.Person[id]["��Ч����2"] .. "+"..FLHSYL[1];
        else
        	WAR.Person[id]["��Ч����2"] = FLHSYL[1]    --�伲���
        end
        WAR.FLHS1 = 1
        for j = 0, WAR.PersonNum - 1 do
          if WAR.Person[j]["����"] == false and WAR.Person[j]["�ҷ�"] == WAR.Person[WAR.CurID]["�ҷ�"] then
            WAR.Person[j].Time = WAR.Person[j].Time + 100
          end
          if WAR.Person[j].Time > 980 then
            WAR.Person[j].Time = 980
          end
        end
      elseif JLSD(low/2, rate*3/4, pid) or (GetS(4, 5, 5, 5) == 6 and  JLSD(low, rate, pid)) then
      	WAR.Person[id]["��Ч����"] = 6
	      if WAR.Person[id]["��Ч����2"] ~= nil then
        	WAR.Person[id]["��Ч����2"] = WAR.Person[id]["��Ч����2"] .. "+"..FLHSYL[3]    --�������
        else
        	WAR.Person[id]["��Ч����2"] = FLHSYL[3]    --�������
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
    
    --���ѧ�ᱱڤ�񹦻��߽�ɫ�������
    if (PersonKF(pid, 85) or T1LEQ(pid)) and JLSD(25, 75, pid) or pid == 118 then
      if WAR.Person[id]["��Ч����"] == -1 then
        WAR.Person[id]["��Ч����"] = math.fmod(85, 10) + 85
      end
      if WAR.Person[id]["��Ч����2"] == nil then
        WAR.Person[id]["��Ч����2"] = "��ڤ��"
      else
        WAR.Person[id]["��Ч����2"] = WAR.Person[id]["��Ч����2"] .. "+" .. "��ڤ��"
      end
      WAR.BMXH = 1
      
      --��ڤ������
      for w = 1, 10 do
        if JY.Person[pid]["�书" .. w] == 85 then
          JY.Person[pid]["�书�ȼ�" .. w] = JY.Person[pid]["�书�ȼ�" .. w] + 10
        end
        if JY.Person[pid]["�书�ȼ�" .. w] > 999 then
          JY.Person[pid]["�书�ȼ�" .. w] = 999
        end
      end
    end
      
    --���Ǵ󷨣������бش������뱱ڤ����ͬʱ����
    if (PersonKF(pid, 88) and JLSD(25, 75, pid) and WAR.BMXH == 0) or pid == 26 then
      if WAR.Person[id]["��Ч����"] == -1 then
        WAR.Person[id]["��Ч����"] = math.fmod(88, 10) + 85
      end
      if WAR.Person[id]["��Ч����2"] == nil then
        WAR.Person[id]["��Ч����2"] = "���Ǵ�"
      else
        WAR.Person[id]["��Ч����2"] = WAR.Person[id]["��Ч����2"] .. "+" .. "���Ǵ�"
      end
      WAR.BMXH = 2
      
      --���Ǵ�����
      for w = 1, 10 do
      	if JY.Person[pid]["�书" .. w] < 0 then
      		break;
      	end
        if JY.Person[pid]["�书" .. w] == 88 then
          JY.Person[pid]["�书�ȼ�" .. w] = JY.Person[pid]["�书�ȼ�" .. w] + 10
          if JY.Person[pid]["�书�ȼ�" .. w] > 999 then
          	JY.Person[pid]["�书�ȼ�" .. w] = 999
        	end
        	break;
        end
        
      end
    end
    
    --������
    if PersonKF(pid, 87) and JLSD(25, 75, pid) and WAR.BMXH == 0 then
      if WAR.Person[id]["��Ч����"] == -1 then
        WAR.Person[id]["��Ч����"] = math.fmod(87, 10) + 85
      end
      if WAR.Person[id]["��Ч����2"] == nil then
        WAR.Person[id]["��Ч����2"] = "������"
      else
        WAR.Person[id]["��Ч����2"] = WAR.Person[id]["��Ч����2"] .. "+" .. "������"
      end
      WAR.BMXH = 3
      
      --����������
      for w = 1, 10 do
      	if JY.Person[pid]["�书" .. w] < 0 then
      		break;
      	end
        if JY.Person[pid]["�书" .. w] == 87 then
          JY.Person[pid]["�书�ȼ�" .. w] = JY.Person[pid]["�书�ȼ�" .. w] + 10
          if JY.Person[pid]["�书�ȼ�" .. w] > 999 then
          	JY.Person[pid]["�书�ȼ�" .. w] = 999
        	end
        	break;
        end
        
      end
    end
      
    --�Ƿ�
    if pid == 50 and WAR.Person[id]["��Ч����2"] == nil then
      WAR.Person[id]["��Ч����"] = 53
      WAR.Person[id]["��Ч����2"] = "����������"   --����������
      ng = ng + 1500
    end
    
    --�Ħ��
    if pid == 103 then
      WAR.Person[id]["��Ч����"] = math.fmod(98, 10) + 85
      WAR.Person[id]["��Ч����2"] = "С���๦����"  --С���๦����
      ng = ng + 1000
    end
    
    --brolycjw: �ܲ�ͨ
    if pid == 64 then
      WAR.Person[id]["��Ч����"] = 66
      WAR.Person[id]["��Ч����2"] = "�����񹦼���"
      ng = ng + 1000
    end
	
	--brolycjw: ���߹�
    if pid == 69 and WAR.ZDDH ~= 188 then
      WAR.Person[id]["��Ч����"] = 67
      WAR.Person[id]["��Ч����2"] = "��������"
      ng = ng + 1000
    end
 
	--brolycjw: ��ҩʦ
    if pid == 57 then
      WAR.Person[id]["��Ч����"] = 95
      WAR.Person[id]["��Ч����2"] = "���Ű���"
      ng = ng + 1000
    end
	
	--brolycjw: л�̿�
    if pid == 164 then
      WAR.Person[id]["��Ч����"] = 23
      WAR.Person[id]["��Ч����2"] = "Ħ���ʿ"
      ng = ng + 1000
    end
	
	--brolycjw: �������
    if pid == 592 then
		if WAR.L_DGQB_X < 3 then
			WAR.Person[id]["��Ч����"] = 24
			WAR.Person[id]["��Ч����2"] = "����"
			ng = ng + 1200
		elseif WAR.L_DGQB_X < 5 then
			WAR.Person[id]["��Ч����"] = 48
			WAR.Person[id]["��Ч����2"] = "��"
			ng = ng + 1400		
		elseif WAR.L_DGQB_X < 7 then
			WAR.Person[id]["��Ч����"] = 10
			WAR.Person[id]["��Ч����2"] = "�ؽ�"
			ng = ng + 1600	
		elseif WAR.L_DGQB_X < 9 then
			WAR.Person[id]["��Ч����"] = 46
			WAR.Person[id]["��Ч����2"] = "ľ��"
			ng = ng + 1800				
		else
			WAR.Person[id]["��Ч����2"] = "�޽�"
			ng = ng + 2000		
		end
    end
    
    --����ڹ�Ϊ�����������������
    if pid == 0 and GetS(4, 5, 5, 5) == 5 and JY.Person[pid]["�书" .. wugongnum] > 88 and JY.Person[pid]["�书" .. wugongnum] < 109 then
      if JY.Person[pid]["�书�ȼ�" .. wugongnum] == 999 and JLSD(25, 75, pid) then
        WAR.Person[id]["��Ч����3"] = "���������" .. JY.Wugong[JY.Person[pid]["�书" .. wugongnum]]["����"]
        ng = ng + JY.Wugong[JY.Person[pid]["�书" .. wugongnum]]["������10"]
      end
      if JY.Person[pid]["�书�ȼ�" .. wugongnum] == 999 then
     	 	WAR.WS = 1
    	end
    end
    

    --���޼�
    if pid == 9 and WAR.Person[id]["��Ч����2"] == nil and PersonKF(pid, 106) then
      local z = math.random(2)
      if z == 1 then
        WAR.Person[id]["��Ч����"] = math.fmod(97, 10) + 85
        WAR.Person[id]["��Ч����2"] = "Ǭ����Ų�Ƽ���"   --Ǭ����Ų�Ƽ���
        ng = ng + 850
      else
        WAR.Person[id]["��Ч����"] = math.fmod(106, 10) + 85
        WAR.Person[id]["��Ч����2"] = "�����񹦼���"  --�����񹦼���
        ng = ng + 1200
      end
    end
    
    --������ 
    if pid == 26 then
      WAR.Person[id]["��Ч����"] = 6
      WAR.Person[id]["��Ч����2"] = "ħ�ۡ�����"   --ħ�ۡ�����
      ng = ng + 1500
    end
    
    --ʹ�ý���ʮ����
    if JY.Person[pid]["�书" .. wugongnum] == 26 then  	
    	--�Ƿ�س����⣬������(40%)�����߹�40%+10%��ȭ����40%
      if pid == 50 or (pid == 55 and math.random(10) < 5) or ((pid == 69 or (pid == 0 and GetS(4, 5, 5, 5) == 1 and JY.Person[pid]["�书�ȼ�" .. wugongnum] == 999)) and JLSD(30, 70, pid)) then
        WAR.Person[id]["��Ч����3"] = XL18JY[math.random(8)]
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
        WAR.Person[id]["��Ч����3"] = XL18[math.random(6)]
        ng = ng + 2000
        for i = 1, (1 + (level)) / 2 do
          for j = 1, (1 + (level)) / 2 do
            SetWarMap(WAR.Person[WAR.CurID]["����X"] + i * 2 - 1, WAR.Person[WAR.CurID]["����Y"] + j * 2 - 1, 4, 1)
            SetWarMap(WAR.Person[WAR.CurID]["����X"] - i * 2 + 1, WAR.Person[WAR.CurID]["����Y"] + j * 2 - 1, 4, 1)
            SetWarMap(WAR.Person[WAR.CurID]["����X"] + i * 2 - 1, WAR.Person[WAR.CurID]["����Y"] - j * 2 + 1, 4, 1)
            SetWarMap(WAR.Person[WAR.CurID]["����X"] - i * 2 + 1, WAR.Person[WAR.CurID]["����Y"] - j * 2 + 1, 4, 1)
          end
        end
      end
    end
      
		--ʹ��������
    if JY.Person[pid]["�书" .. wugongnum] == 49 then
    	--ѧ��һ��ָ��60%�Ļ��ʳ��������У�����Ƕ���ѧһ��ָ�س�
     	if PersonKF(pid, 17) and (JLSD(20, 80, pid) or pid == 53) then
        WAR.Person[id]["��Ч����3"] = LMSJ[math.random(6)]
        ng = ng + 2000
       	if pid == 53 then   --����������Ч
          WAR.LMSJwav = 1
          WAR.WS = 1
      	end
      --���ûѧ��һ��ָ
      elseif myrandom(level, pid) or pid == 53 and math.random(10) < 6 then
        WAR.Person[id]["��Ч����3"] = LMSJ[math.random(6)]
        ng = ng + 2000
        if pid == 53 then
        	WAR.LMSJwav = 1
      	end
      end
    end
    
    
      
    --�޺�ȭ���׽����������
    if JY.Person[pid]["�书" .. wugongnum] == 1 and PersonKF(pid, 108) then
    	--�׽����
    	if inteam(pid) and WAR.L_SGJL == 108 then
     	 	WAR.LHQ_BNZ = 1
    	elseif not inteam(pid) then	--�з�100%
    		WAR.LHQ_BNZ = 1
    	end
    end
      
    --��������ƣ��׽������Ħ��
    if JY.Person[pid]["�书" .. wugongnum] == 22 and PersonKF(pid, 108)  then
    	--�׽���� 
    	if inteam(pid) and WAR.L_SGJL == 108 then
      	WAR.JGZ_DMZ = 1
    	elseif not inteam(pid) then   --�з�100%
    		WAR.JGZ_DMZ = 1
    	end
    end
      
    --ͭ����9��ǿ��ͭ��
    if pid > 480 and pid < 490 then
      WAR.Person[id]["��Ч����2"] = "�׾������"
      ng = ng + 1200
      WAR.JGZ_DMZ = 1   --ֱ�Ӵ�����Ħ��
    end
    
    --ʯ���죬̫���񹦣�(75-25)%����Ч
    if pid == 38 and wugong == 102 and JY.Person[pid]["�书�ȼ�" .. wugongnum] == 999 and JLSD(25, 75, pid) then
      WAR.Person[id]["��Ч����3"] = XKXSJ[math.random(4)]
      ng = ng + 1200
    end
    
    --���ƣ����գ�(75-25)%��Ч
    if pid == 37 and wugong == 94 and JY.Person[pid]["�书�ȼ�" .. wugongnum] == 999 and JLSD(25, 75, pid) then
      WAR.Person[id]["��Ч����3"] = "���վ�����Ӱ��ȭ"
      ng = ng + 1000
    end
    
    --��ҽ�����Ϊ������Ϻ��ҵ����� 60%�����ϱ�
    if JY.Person[pid]["�书" .. wugongnum] == 44 and JY.Person[pid]["�书�ȼ�" .. wugongnum] == 999 and math.random(10) < 6 then
      for i = 1, 10 do
        if JY.Person[pid]["�书" .. i] == 67 and JY.Person[pid]["�书�ȼ�" .. i] == 999 then
        	if WAR.Person[id]["��Ч����1"] ~= nil then
        		WAR.Person[id]["��Ч����1"] = WAR.Person[id]["��Ч����1"] .. "+" .."�����罣 �����һ"
        	else
          	WAR.Person[id]["��Ч����1"] = "�����罣 �����һ"
          end
          WAR.Person[id]["��Ч����"] = 6
          WAR.DJGZ = 1
          ng = ng + 2000
        end
      end
    end
    
    --���ҵ�����Ϊ���������ҽ����� 60%�����ϱ�
    if JY.Person[pid]["�书" .. wugongnum] == 67 and JY.Person[pid]["�书�ȼ�" .. wugongnum] == 999 and math.random(10) < 6 then
      for i = 1, 10 do
        if JY.Person[pid]["�书" .. i] == 44 and JY.Person[pid]["�书�ȼ�" .. i] == 999 then
          if WAR.Person[id]["��Ч����1"] ~= nil then
        		WAR.Person[id]["��Ч����1"] = WAR.Person[id]["��Ч����1"] .. "+" .."�����罣 �����һ"
        	else
          	WAR.Person[id]["��Ч����1"] = "�����罣 �����һ"
          end
          WAR.Person[id]["��Ч����"] = 6
          WAR.DJGZ = 1
          ng = ng + 2000
        end
      end
    end
    
    --���� ʹ������������͵��
    if pid == 90 and JY.Person[pid]["�书" .. wugongnum] == 113 then
      WAR.TD = -2
      --�����壺��սս������͵����
	    if WAR.ZDDH == 226 or WAR.ZDDH == 79 then
	    	WAR.TD = -1;
	    end
    end
    
    
    
    --��ҩʦ����һ�ι�����������1000
    if pid == 57 and WAR.ACT == 1 and JLSD(20,85,pid) then
      for j = 0, WAR.PersonNum - 1 do
        if WAR.Person[j]["����"] == false and WAR.Person[j]["�ҷ�"] ~= WAR.Person[WAR.CurID]["�ҷ�"] then
          if JY.Person[WAR.Person[j]["������"]]["����"] > 1000 then
            JY.Person[WAR.Person[j]["������"]]["����"] = JY.Person[WAR.Person[j]["������"]]["����"] - 1000
            WAR.Person[j]["��������"] = (WAR.Person[j]["��������"] or 0) - 1000;
          else
          	WAR.Person[j]["��������"] = (WAR.Person[j]["��������"] or 0) - JY.Person[WAR.Person[j]["������"]]["����"];
          	JY.Person[WAR.Person[j]["������"]]["����"] = 0
          	JY.Person[WAR.Person[j]["������"]]["����"] = JY.Person[WAR.Person[j]["������"]]["����"] - 100
          	WAR.Person[j]["��������"] = (WAR.Person[j]["��������"] or 0) - 100;
        	end
        end
      end
      WAR.Person[id]["��Ч����3"] = "ħ�����̺�������"
      WAR.Person[id]["��Ч����"] = 39
    end
    
    --ŷ����
    if pid == 60 then
      WAR.WS = 1
    end
    
    --��������
    if pid == 27 then
      WAR.WS = 1
    end
    
    --�Ƿ壬���������߹���ʹ�ý���ʮ����
    if (pid == 50 or pid == 55 or pid == 69) and JY.Person[pid]["�书" .. wugongnum] == 26 then
      WAR.WS = 1
    end
    
    --����� �����ʹ�ö��¾Ž�
    if pid == 35 and GetS(10, 1, 1, 0) == 1 and JY.Person[pid]["�书" .. wugongnum] == 47 then
      WAR.WS = 1
    end
    
    --���ַ��� ����ɱ����+2000
    if pid == 62 then
      ng = ng + 2000
    end
    
    --���� ����ɱ����+1000
    if pid == 84 then
      ng = ng + 1000
    end
    
    --÷���磬ʹ�þ����׹�צ���˺��ӱ�
    if pid == 78 and JY.Person[pid]["�书" .. wugongnum] == 11 then
      WAR.MCF = 1
      WAR.Person[id]["��Ч����3"] = "��ʬ֮Թ��"
    end
    
    --�����ɣ�ʹ����ƽǹ����ɱ����+1000
    if pid == 52 and JY.Person[pid]["�书" .. wugongnum] == 70 then
      WAR.Person[id]["��Ч����3"] = "��ƽ��ǹ"
      ng = ng + 1000
    end
    
    --����ˣ������֣������˺����10%
    if pid == 25 or pid == 83 then
      WAR.TFH = 1
    end
    
    --�����࣬ʹ�����𽣷����˺������ߣ����Ϊ3��
    if pid == 91 and JY.Person[pid]["�书" .. wugongnum] == 28 then
      WAR.WQQ = 1
    end
    
    --����ͩ��ʹ�����ֽ�����������15
    if pid == 74 and JY.Person[pid]["�书" .. wugongnum] == 29 then
      WAR.HQT = 1
    end
    
    --��Ӣ��ʹ�����｣����ɱ����300
    if pid == 63 and JY.Person[pid]["�书" .. wugongnum] == 38 then
      WAR.CY = 1
    end
    
    --�����壺ˮ�ϣ�70%���ʷ���ѩ�ȱ�ɽ������ 
    if pid == 589 and JLSD(20,90,pid) then
    	WAR.L_SSBD = 1;
    	WAR.Person[id]["��Ч����3"] = "ѩ�ȱ�ɽ������";
    end
    
    --�����壺��צ�֣�ŭ������ʱ���ṥ������Χ
    if wugong == 20 and JY.Person[pid]["��������"] == 1 and WAR.LQZ[pid] ~= nil and WAR.LQZ[pid] >= 100 then
    	for i = 1, 2 do
        for j = 1, 2 do
          SetWarMap(x + i - 1, y + j - 1, 4, 1)
          SetWarMap(x - i + 1, y + j - 1, 4, 1)
          SetWarMap(x + i - 1, y - j + 1, 4, 1)
          SetWarMap(x - i + 1, y - j + 1, 4, 1)
        end
      end
    end
    
    --�����壺ӥצ����ŭ������ʱ���ṥ������Χ
    if wugong == 4 and JY.Person[pid]["��������"] == 0 and WAR.LQZ[pid] ~= nil and WAR.LQZ[pid] >= 100 then
    	for i = 1, 2 do
        for j = 1, 2 do
          SetWarMap(x + i - 1, y + j - 1, 4, 1)
          SetWarMap(x - i + 1, y + j - 1, 4, 1)
          SetWarMap(x + i - 1, y - j + 1, 4, 1)
          SetWarMap(x - i + 1, y - j + 1, 4, 1)
        end
      end
    end
    
    
    
    
    --��� �������Ǻ� ȫ�弯����100
    if pid == 58 and WAR.XK ~= 2 then
      for j = 0, WAR.PersonNum - 1 do
        if WAR.Person[j]["����"] == false and WAR.Person[j]["�ҷ�"] ~= WAR.Person[WAR.CurID]["�ҷ�"] then
          WAR.Person[j].TimeAdd = WAR.Person[j].TimeAdd - 100
        end
      end
      if WAR.Person[id]["��Ч����"] == nil then
        WAR.Person[id]["��Ч����"] = 89
      end
      if WAR.Person[id]["��Ч����1"] ~= nil then
      	WAR.Person[id]["��Ч����1"] = WAR.Person[id]["��Ч����1"] .. "+" .."����֮ŭХ"
      else
      	WAR.Person[id]["��Ч����1"] = "����֮ŭХ"
      end
    end
      
    --�����
    if WAR.XK == 2 and pid == 58 and WAR.Person[WAR.CurID]["�ҷ�"] == WAR.XK2 then
      for e = 0, WAR.PersonNum - 1 do
        if WAR.Person[e]["����"] == false and WAR.Person[e]["�ҷ�"] ~= WAR.Person[WAR.CurID]["�ҷ�"] then
          WAR.Person[e].TimeAdd = WAR.Person[e].TimeAdd - math.modf(JY.Person[WAR.Person[WAR.CurID]["������"]]["����"] / 5)
          if WAR.Person[e].Time < -450 then
            WAR.Person[e].Time = -450
          end
          JY.Person[WAR.Person[e]["������"]]["����"] = JY.Person[WAR.Person[e]["������"]]["����"] - math.modf(JY.Person[WAR.Person[WAR.CurID]["������"]]["����"] / 5)
          if JY.Person[WAR.Person[e]["������"]]["����"] < 0 then
            JY.Person[WAR.Person[e]["������"]]["����"] = 0
          end
          JY.Person[WAR.Person[e]["������"]]["����"] = JY.Person[WAR.Person[e]["������"]]["����"] - math.modf(JY.Person[WAR.Person[WAR.CurID]["������"]]["����"] / 25)
        end
        if JY.Person[WAR.Person[e]["������"]]["����"] < 0 then
          JY.Person[WAR.Person[e]["������"]]["����"] = 0
        end
      end
        
      --���֮������Ϊ0���������ֵ-100��������������������
      if inteam(pid) then
        JY.Person[pid]["����"] = 0
        JY.Person[pid]["�������ֵ"] = JY.Person[pid]["�������ֵ"] - 100
        JY.Person[300]["����"] = JY.Person[300]["����"] + 1
      else
        AddPersonAttrib(pid, "����", -1000)  --���з�����ֻ��1000����
      end
      
      if JY.Person[pid]["�������ֵ"] < 500 then
        JY.Person[pid]["�������ֵ"] = 500
      end
      if WAR.Person[id]["��Ч����1"] ~= nil then
      	WAR.Person[id]["��Ч����1"] = WAR.Person[id]["��Ч����1"] .. "+" .."����֮��ŭ��������Х"   --����֮��ŭ��������Х
      else
      	WAR.Person[id]["��Ч����1"] = "����֮��ŭ��������Х"   --����֮��ŭ��������Х
      end
      WAR.Person[id]["��Ч����"] = 6
      WAR.XK = 3
		end    
      
    --��ӯӯ��ʹ�ó�����
    if pid == 73 and JY.Person[pid]["�书" .. wugongnum] == 73 then
      if math.random(10) < 7 then
        WAR.Person[id]["��Ч����3"] = "�������ٽ���"
        WAR.Person[id]["��Ч����"] = 89
        for j = 0, WAR.PersonNum - 1 do
          if WAR.Person[j]["����"] == false and WAR.Person[j]["�ҷ�"] ~= WAR.Person[WAR.CurID]["�ҷ�"] then
            JY.Person[WAR.Person[j]["������"]]["����"] = JY.Person[WAR.Person[j]["������"]]["����"] - 70
          end
        end
	    else
	    	--����ʱ���������ظ�����100�����ظ�����
	      if math.random(10) < 7 then
	        for j = 0, WAR.PersonNum - 1 do
	          if WAR.Person[j]["������"] == 35 and WAR.Person[j]["����"] == false and WAR.Person[j]["�ҷ�"] == WAR.Person[WAR.CurID]["�ҷ�"] then
	            JY.Person[WAR.Person[j]["������"]]["����"] = 100
	            JY.Person[WAR.Person[WAR.CurID]["������"]]["����"] = 100
	            JY.Person[WAR.Person[j]["������"]]["���˳̶�"] = 0
	            JY.Person[WAR.Person[WAR.CurID]["������"]]["���˳̶�"] = 0
	            WAR.Person[id]["��Ч����3"] = "�������� Ц������"
	            WAR.Person[id]["��Ч����"] = 89
	          end
	        end
	      end
	    end
	  end
	  
	  
      
    --������ ����Ȼ��������500��ʼ
    if pid == 5 and math.random(10) < 8 then
      WAR.ZSF = 1
      WAR.Person[id]["��Ч����1"] ="����Ȼ"
    end
    
    --����  ����ӻ���������200��ʼ
    if pid == 49 and math.random(10) < 7 then
      WAR.XZZ = 1
      if WAR.Person[id]["��Ч����1"] ~= nil then
      	WAR.Person[id]["��Ч����1"] = WAR.Person[id]["��Ч����1"] .."+".."����ӻ�"
      else
      	WAR.Person[id]["��Ч����1"] = "����ӻ�"
      end
    end
    
    --��������  ������Ѩ�֣�ɱ����+1200
    if pid == 27 and math.random(10) < 7 then
      WAR.Person[id]["��Ч����3"] = "������Ѩ��"
      ng = ng + 1200
    end
    
    --������ ����ȫ���ж�+20
    if pid == 2 then
      for j = 0, WAR.PersonNum - 1 do
        if WAR.Person[j]["����"] == false and WAR.Person[j]["�ҷ�"] ~= WAR.Person[WAR.CurID]["�ҷ�"] then
          JY.Person[WAR.Person[j]["������"]]["�ж��̶�"] = JY.Person[WAR.Person[j]["������"]]["�ж��̶�"] + 20
        end
        if 100 < JY.Person[WAR.Person[j]["������"]]["�ж��̶�"] then
          JY.Person[WAR.Person[j]["������"]]["�ж��̶�"] = 100
        end
      end
      if WAR.Person[id]["��Ч����1"] ~= nil then
      	WAR.Person[id]["��Ч����1"] = WAR.Person[id]["��Ч����1"] .."+".."���ĺ���"
      else
      	WAR.Person[id]["��Ч����1"] = "���ĺ���"
      end
      WAR.Person[id]["��Ч����"] = 64
    end
      
    --�Ħ��  ʹ�û��浶����������30����ɱ����1000
    --��ͨ��ɫʹ����30%�Ļ���
    if wugong == 66 and JY.Person[pid]["�书�ȼ�" .. wugongnum] == 999 and (pid == 103 or (pid ~= 103 and JLSD(30,60,pid) or pid == 0 and JLSD(10,20,pid)))  then
      for j = 0, WAR.PersonNum - 1 do
        if WAR.Person[j]["����"] == false and WAR.Person[j]["�ҷ�"] ~= WAR.Person[WAR.CurID]["�ҷ�"] then
          JY.Person[WAR.Person[j]["������"]]["���˳̶�"] = JY.Person[WAR.Person[j]["������"]]["���˳̶�"] + 30
        end
        if 100 < JY.Person[WAR.Person[j]["������"]]["���˳̶�"] then
          JY.Person[WAR.Person[j]["������"]]["���˳̶�"] = 100
        end
      end
      if WAR.Person[id]["��Ч����1"] ~= nil then
      	WAR.Person[id]["��Ч����1"] = WAR.Person[id]["��Ч����1"] .."+".."�������ڡ����浶"  --�������ڡ����浶
      else
      	WAR.Person[id]["��Ч����1"] = "�������ڡ����浶"  --�������ڡ����浶
      end
      WAR.Person[id]["��Ч����"] = 58
      ng = ng + 1000
    end
    
    --�ɍ�������ɱ����2000
    if pid == 18 then
      WAR.Person[id]["��Ч����2"] = "��Ԫ����������"  --��Ԫ����������
      WAR.Person[id]["��Ч����"] = 6
      ng = ng + 2000
      WAR.Person[id]["��Ч����3"] = "ħ�ࡤ����"  --ħ�ࡤ����
    end
    
    --ʹ��Ѫ���󷨣����Ѫ����Ѫ������ʹ��ʱ����Ѫ10%
    if JY.Person[pid]["�书" .. wugongnum] == 63 and (JY.Person[pid]["����"] == 44 or pid == 97) then
      WAR.XDDF = 1
    end
    
    --̫��ȭ���ż�ɱ1�㼯������
    if JY.Person[pid]["�书" .. wugongnum] == 16 then
      if WAR.tmp[3000 + pid] == nil then
        WAR.tmp[3000 + pid] = 0
    	elseif 0 < WAR.tmp[3000 + pid] then
        WAR.Person[id]["��Ч����3"] = "̫��ȭ��������"   --̫��ȭ��������
        ng = ng + WAR.tmp[3000 + pid] * 5
      end
    end
      
    --�书��ʽ��ɱ����
    for i,v in pairs(CC.KfName) do
      if v[1] == wugong  then
      	if myrandom(level, pid) or WAR.NGJL == 98 or WAR.LQZ[pid] == 100 or (PersonKF(pid, 98) and JLSD(30, 70, pid)) then
      		if WAR.Person[id]["��Ч����3"] ~= nil then
      			WAR.Person[id]["��Ч����3"] = WAR.Person[id]["��Ч����3"] .. "+"..v[2]
      		else
        		WAR.Person[id]["��Ч����3"] = v[2]
        	end
        	ng = ng + v[3]

        	--�����������ʽ�ӳ�
        	if wugong == 41 then
        		if v[2] == "��" then
        			WAR.L_MJJF = 1;
        		else
        			WAR.L_MJJF = 2;
        		end
        	end
        	break;
        end
      end
    end
    
    --�����壺��ɽ���������ǹ�����ӻ���
    if wugong == 53 and (JLSD(10, 50) or (PersonKF(68, pid) and JLSD(20, 50))) then
    	WAR.L_NSDFCC = 1;
    	if WAR.Person[id]["��Ч����3"] ~= nil then
  			WAR.Person[id]["��Ч����3"] = WAR.Person[id]["��Ч����3"] .. "��������ǹ"
  		else
    		WAR.Person[id]["��Ч����3"] = "������ǹ"
    	end
    	WAR.ACT = 10   --����Ч֮��ȡ������
    end
    
    --�����壺��������������ɱ��
    if WAR.L_WYJFA > 0 then
    	CleanWarMap(4, 0);
    	local n = 6;
    	local tn = 1800;
    	if PersonKF(pid, 89) then		--��ϼ�������ӷ�Χ
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
      if WAR.Person[id]["��Ч����3"] ~= nil then
      	WAR.Person[id]["��Ч����3"] = WAR.Person[id]["��Ч����3"] .. "����������"
      else
      	WAR.Person[id]["��Ч����3"] = "��������"
      end
      WAR.WS = 1
    end

    
    --�����ᣬ(70-30+10)%��������20%���˺���ɱ����+1000
    if pid == 5 and WAR.Person[id]["��Ч����3"] ~= nil and JLSD(30, 70, pid) then
      WAR.Person[id]["��Ч����3"] = "����Ϊ��" .. "��" .. WAR.Person[id]["��Ч����3"]  --����Ϊ��
      ng = ng + 1000
      WAR.ZSF2 = 1
    end
    
    --���ǵ�ϵ�����鵶����60%������������600��ɱ����
    if pid == 0 and GetS(4, 5, 5, 5) == 3 and wugong == 64 and JLSD(20, 80, pid) then
      local d = math.random(math.modf(GetS(14, 3, 1, 4) / 100 + 1) + 2) + 6
      ng = ng + d * 100
      WAR.Person[id]["��Ч����3"] = "��" .. SZB[d]
    end
    
    --����ʹ����ɽ�����ƣ�����������ɱ����+1700
    if JY.Person[pid]["�书" .. wugongnum] == 8 and pid == 49 and PersonKF(pid, 101) and (JLSD(20, 80, pid) or WAR.NGJL == 98) then
      WAR.Person[id]["��Ч����3"] = "���չ���ѧ��������"   --���չ���ѧ��������
      ng = ng + 1700
      WAR.SSFwav = 1   --��Ч
      WAR.TZ_XZ = 1
    end
    
    --�����壺������ʹ����ϵ����60%�Ļ��ʴ����ɱ����
    if pid == 590 and (wugong >= 68 and wugong <= 84 or wugong == 86 or wugong == 112) and JLSD(30, 80, pid) then
    	WAR.Person[id]["��Ч����3"] = "�������塤��������";
    	ng = ng + 1200
      WAR.SSFwav = 1   --��Ч	
    end
    
    
    --�����壺���ƽ������ۼ�ɱ����
    if WAR.L_RYJF[pid] ~= nil then
    	ng = ng + 200*WAR.L_RYJF[pid];
    end
    
    --�����壺�������������˺���װ�����콣Ч���ӱ�
    --��
    if WAR.L_MJJF == 2 then
    	ng = ng + 300;
    	if JY.Person[pid]["����"] == 37 then
    		ng = ng + 300;
    	end
    end
    
    --�򹷰��� ��Ч  
    if JY.Person[pid]["�书" .. wugongnum] == 80 and JY.Person[pid]["�书�ȼ�" .. wugongnum] == 999 and (JLSD(30, 70, pid) or (GetS(4, 5, 5, 5) == 4 and JLSD(30, 75, pid))) then
      WAR.Person[id]["��Ч����3"] = "�򹷰�����ѧ--�����޹�"   --�򹷰�����ѧ--�����޹�
      WAR.Person[id]["��Ч����"] = 89
      if WAR.Person[id]["��Ч����3"] ~= nil then
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
    
    --���ʹ�ú��ҵ�����ɱ����+1200
    
    --�����壺���ҵ���������
    --��ϵ����40%�����50%
    if wugong == 67 and JY.Person[pid]["�书�ȼ�" .. wugongnum] == 999 and ((pid == 0 and GetS(4,5,5,5) == 3 and JLSD(30,70,pid)) or (pid == 1 and JLSD(20,70,pid))) then
      local HDJY = {"���⡤����ʽ","���⡤�ݷ�����","���⡤���ֲص�","���⡤ɳŸ�Ӳ�","���⡤�ΰݱ���","���⡤�������ȵ�","���⡤����ժ�ĵ�","���⡤����������","���⡤�˷��ص�ʽ"};
      WAR.Person[id]["��Ч����3"] = HDJY[math.random(9)];
      WAR.Person[id]["��Ч����"] = 6
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
    
    --���ʹ����������
    if pid == 58 and JY.Person[pid]["�书" .. wugongnum] == 45 and WAR.Person[id]["��Ч����3"] == nil and JY.Person[pid]["�书�ȼ�" .. wugongnum] == 999 and math.random(10) < 7 then
      WAR.Person[id]["��Ч����3"] = "�ؽ��洫������ɽӿ�����"  --�ؽ��洫������ɽӿ�����
      WAR.Person[id]["��Ч����"] = 84
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
    
    --�����������ж�+15���˺�+50
    if pid == 84 and WAR.Person[id]["��Ч����1"] == nil and math.random(10) < 7 then
      WAR.HDWZ = 1
      WAR.Person[id]["��Ч����1"] = "���������ж�"  --���������ж�
      WAR.Person[id]["��Ч����"] = 89
    end
    
    
      
    --�����Ҵ�
    if pid == 553 and 0 < WAR.YZB2 then
      if 2 < WAR.YZB2 then
        WAR.Person[id]["��Ч����3"] = "��ǹ��ǳ������˫����Դ�"   --��ǹ��ǳ������˫����Դ�
      elseif 1 < WAR.YZB2 then
          WAR.Person[id]["��Ч����3"] = "��ǹ��ǳ��������˫����"   --��ǹ��ǳ��������˫����
      elseif 0 < WAR.YZB2 then
          WAR.Person[id]["��Ч����3"] = "��ǹ��ǳ������˫����"   --��ǹ��ǳ������˫����
      end
      WAR.Person[id]["��Ч����"] = 6
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
    
    --������أ���ɱ - -
    if pid == 516 and WAR.KHCM[pid] ~= 1 then
      WAR.Person[id]["��Ч����3"] = "����һ���ذ��塤����һ��"  --����һ���ذ��塤����һ��
      WAR.Person[id]["��Ч����"] = 6
      WAR.GBWZ = 1
      WAR.WS = 1
      ng = ng + 1500
    end
      
      
    if WAR.Data["����"] == 130 then
      for j = 0, WAR.PersonNum - 1 do
        if WAR.Person[j]["������"] == 541 and WAR.Person[j]["����"] == false and WAR.Person[j]["�ҷ�"] == WAR.Person[WAR.CurID]["�ҷ�"] then
          WAR.BSMT = 1
          WAR.WS = 1
          ng = ng + 1500
          WAR.Person[id]["��Ч����1"] = "��ɳ����֮�ӻ�"  --��ɳ����֮�ӻ�
          WAR.Person[id]["��Ч����"] = 6
        end
      end
    end
    
    --�ﲮ����ɫָ�������ʾ
    if pid == 29 then
    	if WAR.L_TBGZL == 1 and JLSD(30, 90, pid) then
    		if WAR.Person[id]["��Ч����1"] ~= nil then
    			WAR.Person[id]["��Ч����1"] = WAR.Person[id]["��Ч����1"] .. "+����������";
    		else
    			WAR.Person[id]["��Ч����1"] = "����������";
    		end
    		ng = ng + 1000;
    	end
    end
    
    
      
    --��а���� ������Ŀ
    --if JY.Person[pid]["�书" .. wugongnum] == 48 and JY.Person[pid]["�书�ȼ�" .. wugongnum] == 999 and WAR.NGJL == 105 and WAR.KHCM[pid] ~= 1 then
     -- WAR.KHBX = 1
      --WAR.Person[id]["��Ч����3"] = "���а������������Ŀ"  --���а������������Ŀ
      --WAR.Person[id]["��Ч����"] = 6
    --end
    
    --�����壺�����񹦼���������ɴ�Ŀ
    if WAR.L_SGJL == 105 then
		if wugong == 48 then
			WAR.KHBX = 2
			WAR.Person[id]["��Ч����3"] = "���а������������Ŀ";
			WAR.Person[id]["��Ч����"] = 6
		else
			WAR.KHBX = 1
			if WAR.Person[id]["��Ч����3"] ~= nil then
				WAR.Person[id]["��Ч����3"] = WAR.Person[id]["��Ч����3"] .. "��������Ŀ";
			else
				WAR.Person[id]["��Ч����3"] = "������Ŀ";
			end
			WAR.Person[id]["��Ч����"] = 6
    	end
    end
    
    --äĿ״̬��������Ч
    if WAR.KHCM[pid] == 1 or WAR.KHCM[pid] == 2 then
      WAR.Person[id]["��Ч����"] = 89
      WAR.Person[id]["��Ч����2"] = "״̬��äĿ����"  --״̬��������Ч
    end
    
    --�����壺������ܹ�����XΪ10ʱ����ȫ��������ͨ��X���ϱ仯������������
    if pid == 592 then

    	local num = WAR.L_DGQB_X;
    	local n = 0;
    	local person = {};
    	--���֮ǰ�ķ�Χ
  		CleanWarMap(4, 0)
  		
  		
      for i = 0, WAR.PersonNum - 1 do
        if WAR.Person[i]["�ҷ�"] ~= WAR.Person[WAR.CurID]["�ҷ�"] and WAR.Person[i]["����"] == false then
          n = n + 1
					person[n] = i;
          
        end
      end
      
      --���ݲ�ͬ��X������ͬ�ĵ���
      if n <= num or WAR.L_DGQB_X >= 10 then
      	for i=1, n do
      		SetWarMap(WAR.Person[person[i]]["����X"], WAR.Person[person[i]]["����Y"], 4, 1)
      	end
      else
      	while num > 0 do
      		local t = math.random(n);
      		if person[t] ~= nil then
      			SetWarMap(WAR.Person[person[t]]["����X"], WAR.Person[person[t]]["����Y"], 4, 1)
      			person[t] = nil;
      			num = num - 1;
      		end
      	end
      end
      
      
	  local str = WAR.L_DGQB_ZS[limitX(WAR.L_DGQB_X,1, 10)]
      WAR.Person[id]["��Ч����3"] = str;
      Cls()
      ShowScreen()
      if WAR.L_DGQB_X >= 10 then		--������ܷ�������󣬻ָ����������������������������˺��ж�����
	      WAR.Person[id]["��������"] = (WAR.Person[id]["��������"] or 0) + AddPersonAttrib(pid, "����", 500);
	      WAR.Person[id]["��������"] = (WAR.Person[id]["��������"] or 0) + AddPersonAttrib(pid, "����", 2000);
	      WAR.Person[id]["�ⶾ����"] = (WAR.Person[id]["�ⶾ����"] or 0) - AddPersonAttrib(pid, "�ж��̶�", -50);
		  	AddPersonAttrib(pid, "���˳̶�", -50);
				WAR.Person[id]["��Ч����"] = 6
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

            
    local xb = JY.Wugong[wugong]["�书����"]
    local pz = math.modf(JY.Person[0]["����"] / 5)
    
    --���ǽ�����У�ȫ������
    if pid == 0 and GetS(4, 5, 5, 5) == 2 and 120 <= JY.Person[pid]["��������"] and 0 < JY.Person[pid]["�书10"] and xb == 2 and wugong ~= 49 and wugong ~= 43 and JLSD(30, 50 + pz, pid) and GetS(53, 0, 4, 5) == 1 then
      CleanWarMap(4, 0)
      for i = 0, WAR.PersonNum - 1 do
        if WAR.Person[i]["�ҷ�"] ~= WAR.Person[WAR.CurID]["�ҷ�"] and WAR.Person[i]["����"] == false then
          SetWarMap(WAR.Person[i]["����X"], WAR.Person[i]["����Y"], 4, 1)
        end
      end
      WAR.Person[id]["��Ч����"] = 6
      if WAR.Person[id]["��Ч����3"] == nil then
        WAR.Person[id]["��Ч����3"] = ZJTF[2]
      else
        WAR.Person[id]["��Ч����3"] = ZJTF[2] .. "��" .. WAR.Person[id]["��Ч����3"]
      end
      ng = ng + 1500
      WAR.WS = 1
      Cls()
      --[[
      if JY.HEADXZ == 1 then    --����ͼ
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
      
    --����ȭϵ����
    if pid == 0 and GetS(4, 5, 5, 5) == 1 and 0 < JY.Person[pid]["�书10"] and 120 <= JY.Person[pid]["ȭ�ƹ���"] and JLSD(30, 50 + pz, pid) and (xb == 1 or wugong == 49) and GetS(53, 0, 4, 5) == 1 then
      WAR.Person[id]["��Ч����"] = 6
      if WAR.Person[id]["��Ч����3"] == nil then
        WAR.Person[id]["��Ч����3"] = ZJTF[1]
      else
        WAR.Person[id]["��Ч����3"] = ZJTF[1] .. "��" .. WAR.Person[id]["��Ч����3"]
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
    
    --������ϵ����
    if pid == 0 and GetS(4, 5, 5, 5) == 4 and 0 < JY.Person[pid]["�书10"] and 120 <= JY.Person[pid]["�������"] and JLSD(25, 55 + pz, pid) and xb == 4 and GetS(53, 0, 4, 5) == 1 then
      WAR.Person[id]["��Ч����"] = 6
      if WAR.Person[id]["��Ч����3"] == nil then
        WAR.Person[id]["��Ч����3"] = ZJTF[4]
      else
        WAR.Person[id]["��Ч����3"] = ZJTF[4] .. "��" .. WAR.Person[id]["��Ч����3"]
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
    
    --���ǵ�ϵ����
    if pid == 0 and GetS(4, 5, 5, 5) == 3 and 0 < JY.Person[pid]["�书10"] and 120 <= JY.Person[pid]["ˣ������"] and JLSD(30, 55 + pz, pid) and xb == 3 and GetS(53, 0, 4, 5) == 1 then
      WAR.Person[id]["��Ч����"] = 6
      if WAR.Person[id]["��Ч����3"] == nil then
        WAR.Person[id]["��Ч����3"] = ZJTF[3]
      else
        WAR.Person[id]["��Ч����3"] = ZJTF[3] .. "��" .. WAR.Person[id]["��Ч����3"]
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
      
    --���������
    if pid == 0 and GetS(4, 5, 5, 5) == 5 and WAR.JSTG < 150 and WAR.DZXY ~= 1 and JLSD(25, 55 + pz, pid) and GetS(53, 0, 4, 5) == 1 then
      local tg = 0
      for i = 1, 10 do
        if (84 < JY.Person[pid]["�书" .. i] and JY.Person[pid]["�书" .. i] < 109 and JY.Person[pid]["�书" .. i] ~= 86) or JY.Person[pid]["�书" .. i] == 43 and JY.Person[pid]["�书�ȼ�" .. i] == 999 then
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
	  
	  --�����壺��� ��Ȼ������Ч����
	  
    if pid == 58 and fightnum == 3 and GetS(86,11,11,5) == 2 then
    	--��ʱ��������
  		local ARSSJY = {"��Ȼ���⡤���񲻰�","��Ȼ���⡤������ʩ","��Ȼ���⡤��ʬ����"}
  		WAR.Person[id]["��Ч����3"] = ARSSJY[WAR.ACT];
  	end
    
    --ŭ������
    if WAR.LQZ[pid] == 100 and WAR.DZXY ~= 1 and WAR.SQFJ ~= 1 then
      WAR.Person[id]["��Ч����"] = 6
      if WAR.Person[id]["��Ч����1"] ~= nil then
        WAR.Person[id]["��Ч����1"] = WAR.Person[id]["��Ч����1"] .. "+����֮һ��"
      else
        WAR.Person[id]["��Ч����1"] = "����֮һ��"   --����֮һ��
      end
      ng = ng + 1500
    end
      
    --��������
    if WAR.Actup[pid] ~= nil then
    	local str = "��������";  --ALungky: �޸���������ǰ����ʱ����������Ӻ�
    	if PersonKF(pid, 103) then    --ѧ����+1200ɱ����
        ng = ng + 1200
        WAR.L_LXXL = 1;			--��ɳٻ�
        str = JY.Wugong[103]["����"].."+��������";
      else
      	ng = ng + 600
      end
      
      if WAR.Person[id]["��Ч����1"] ~= nil then
        WAR.Person[id]["��Ч����1"] = WAR.Person[id]["��Ч����1"] .. "+"..str  --��������
      else
        WAR.Person[id]["��Ч����1"] = "��������"
      end
    end
    
    
    --�����壺ʹ�þ����׹�צ���Ҿ����񹦼���ʱ��������������ɱ��
	 	if WAR.L_SGJL == 107 and wugong == 11 then
	 		ng = ng + 1200;
	 	end
    
    --�����壺װ����������ʹ�õȼ�Ϊ���ĵ������40%�����ʣ��������������50%���ʴ����ɱ���������������Ѫ��ɱ���������书�����й�
  	if WAR.L_TLD == 1 then
			ng = ng + JY.Wugong[wugong]["������10"];
			WAR.Person[WAR.CurID]["��Ч����3"] = JY.Thing[43]["����"].."��".."����"
  	end
  	
    --brolycjw: ʯ���񹥻��ĵط��������ʯ���죬��ô��Ϊ�����˹���
  	if pid == 591 and WAR.Person[id]["�ҷ�"] then
	    for i = 0, CC.WarWidth - 1 do
	      for j = 0, CC.WarHeight - 1 do
	        local effect = GetWarMap(i, j, 4)
	        if 0 < effect then
	          local emeny = GetWarMap(i, j, 2)
	    			if 0 <= emeny and WAR.Person[emeny]["������"] == 38 then
	    				WAR.WS = 1;
	    				if WAR.Person[id]["��Ч����1"] ~= nil then
	        			WAR.Person[id]["��Ч����1"] = WAR.Person[id]["��Ч����1"] .. "+����̫��"
	      			else
	        			WAR.Person[id]["��Ч����1"] = "����̫��"
	      			end
	    				break;
	    			end
	    		end
	    	end
	    end
	  end
	  
	 --brolycjw: ʯ���칥���ĵط��������ʯ������ô��Ϊ�����˹���
  	if pid == 38 and WAR.Person[id]["�ҷ�"] then
	    for i = 0, CC.WarWidth - 1 do
	      for j = 0, CC.WarHeight - 1 do
	        local effect = GetWarMap(i, j, 4)
	        if 0 < effect then
	          local emeny = GetWarMap(i, j, 2)
	    			if 0 <= emeny and WAR.Person[emeny]["������"] == 591 then
	    				WAR.WS = 1;
	    				if WAR.Person[id]["��Ч����1"] ~= nil then
	        			WAR.Person[id]["��Ч����1"] = WAR.Person[id]["��Ч����1"] .. "+����̫��"
	      			else
	        			WAR.Person[id]["��Ч����1"] = "����̫��"
	      			end
	    				break;
	    			end
	    		end
	    	end
	    end
	  end
	  
	  --�����壺������
  	if wugong == 73  then
  		WAR.WS = 1;
	    for i = 0, CC.WarWidth - 1 do
	      for j = 0, CC.WarHeight - 1 do
	        local effect = GetWarMap(i, j, 4)
	        if 0 < effect then
	          local emeny = GetWarMap(i, j, 2)
	    			if 0 <= emeny and WAR.Person[id]["�ҷ�"] == WAR.Person[emeny]["�ҷ�"] and emeny ~= WAR.CurID then
	    				local tp = WAR.Person[emeny]["������"];
	    				WAR.Person[emeny]["��������"] = (WAR.Person[emeny]["��������"] or 0) + AddPersonAttrib(tp, "����", 10);
	    				AddPersonAttrib(tp, "���˳̶�", -10);
	    				SetWarMap(i, j, 4, 2)
	    			end
	    		end
	    	end
	    end
	  end

    --��Ч����1������Ϊ��ɫȦ
    if WAR.Person[id]["��Ч����1"] ~= nil and WAR.Person[id]["��Ч����"] == -1 then
      WAR.Person[id]["��Ч����"] = 88
    end
    
    --��ʦ������������
    if pid == 0 and GetS(53, 0, 2, 5) == 3 then
    	WAR.WS = 1;
    end
      
    --�����˺��ĵ���
    for i = 0, CC.WarWidth - 1 do
      for j = 0, CC.WarHeight - 1 do
        local effect = GetWarMap(i, j, 4)
        if 0 < effect then
          local emeny = GetWarMap(i, j, 2)
	        if 0 <= emeny and emeny ~= WAR.CurID then		--������ˣ����Ҳ��ǵ�ǰ������
	        
						if WAR.Person[WAR.CurID]["�ҷ�"] ~= WAR.Person[emeny]["�ҷ�"] or (WAR.tmp[1000 + pid] ~= nil or (ZHEN_ID < 0 and WAR.WS == 0)) then
		          if JY.Wugong[wugong]["�˺�����"] == 1 and (fightscope == 0 or fightscope == 3) then
		            if level == 11 then
		              level = 10
		            end
		            WAR.Person[emeny]["��������"] = (WAR.Person[emeny]["��������"] or 0) - War_WugongHurtNeili(emeny, wugong, level)
		            SetWarMap(i, j, 4, 3)
		            WAR.Effect = 3
			        else
			          WAR.Person[emeny]["��������"] = (WAR.Person[emeny]["��������"] or 0) - War_WugongHurtLife(emeny, wugong, level, ng, x, y)
			          WAR.Effect = 2
			          SetWarMap(i, j, 4, 2)
			        end
			     	end
		      end
		    end
      end
    end
	    

    local dhxg = JY.Wugong[wugong]["�书����&��Ч"]
    if WAR.LXZQ == 1 then
      dhxg = 71
    elseif WAR.JSYX == 1 then
        dhxg = 84
    elseif WAR.ASKD == 1 then
        dhxg = 65
    elseif WAR.GCTJ == 1 then
        dhxg = 108
    end
    
		
		War_ShowFight(pid, wugong, JY.Wugong[wugong]["�书����"], level, x, y, dhxg, ZHEN_ID)
		War_Show_Count(WAR.CurID);		--��ʾ��ǰ�����˵ĵ���
    
    WAR.Person[WAR.CurID]["����"] = WAR.Person[WAR.CurID]["����"] + 2
    local rz = 0
    if WAR.Person[id]["�ҷ�"] then
    	rz = 4;
    else
    	rz = 40
    end
    
    if JY.WGLVXS == 1 then
      rz = 100
    end
    
    --�书���Ӿ��������
    if inteam(pid) then
      if JY.Person[pid]["�书�ȼ�" .. wugongnum] < 900 then
        JY.Person[pid]["�书�ȼ�" .. wugongnum] = JY.Person[pid]["�书�ȼ�" .. wugongnum] + 2 + Rnd(2)
	    elseif JY.Person[pid]["�书�ȼ�" .. wugongnum] < 999 then
	      --JY.Person[pid]["�书�ȼ�" .. wugongnum] = JY.Person[pid]["�书�ȼ�" .. wugongnum] + math.modf(JY.Person[pid]["����"] / 20 + math.random(2)) + rz
	    	--�ջ�һ�ε���
	    	JY.Person[pid]["�书�ȼ�" .. wugongnum] = JY.Person[pid]["�书�ȼ�" .. wugongnum] + 100;
	    	--�书����Ϊ��
	      if 999 <= JY.Person[pid]["�书�ȼ�" .. wugongnum] then
	        JY.Person[pid]["�书�ȼ�" .. wugongnum] = 999
	        PlayWavAtk(42)
	        DrawStrBoxWaitKey(string.format("%s����%s���Ƿ��켫", JY.Person[pid]["����"], JY.Wugong[JY.Person[pid]["�书" .. wugongnum]]["����"]), C_ORANGE, CC.DefaultFont)

	        
	        --ʯ���� ̫����Ϊ���������Ṧ50
	        if pid == 38 and JY.Person[pid]["�书" .. wugongnum] == 102 then
	          say("�����������һ������������������Խ�����������ˣ�����Ȥ��", 38)
	          DrawStrBoxWaitKey("ʯ�����Ṧ����50��", C_ORANGE, CC.DefaultFont)
	          JY.Person[38]["�Ṧ"] = JY.Person[38]["�Ṧ"] + 50
	        end
	        
	        --���� ���չ�Ϊ���������Ṧ20��
	        if pid == 37 and JY.Person[pid]["�书" .. wugongnum] == 94 then
	          say("���վ����������֫�ٺ��о�������ӯ������磬��һ����������ʧ����~~~", 37)
	          DrawStrBoxWaitKey("�����������վ������裬�Ṧ�Ӷ�ʮ", C_ORANGE, CC.DefaultFont)
	          AddPersonAttrib(37, "�Ṧ", 20)
	          SetS(86, 8, 10, 5, 2);
	        end
	        
	        --��쳣����ҵ�������������10��ˣ������
	        if pid == 1 and wugong == 67 then
	        	say("��������Խ��Խ����", 1);
	        	DrawStrBoxWaitKey("��쳹��������ᡢˣ�����ɸ�����10��", C_ORANGE, CC.DefaultFont)
	          AddPersonAttrib(1, "������", 10)
	          AddPersonAttrib(1, "������", 10)
	          AddPersonAttrib(1, "�Ṧ", 10)
	          AddPersonAttrib(1, "ˣ������", 10)
	        end
	      end
      end
        
      --�书������ͨ�ȼ�
      if level < math.modf(JY.Person[pid]["�书�ȼ�" .. wugongnum] / 100) + 1 then
        level = math.modf(JY.Person[pid]["�书�ȼ�" .. wugongnum] / 100) + 1
        DrawStrBox(-1, -1, string.format("%s ��Ϊ %d ��", JY.Wugong[JY.Person[pid]["�书" .. wugongnum]]["����"], level), C_ORANGE, CC.DefaultFont)
        ShowScreen()
        lib.Delay(500)
        Cls()
        ShowScreen()
      end
    end
      
    --�ҷ������ĵ�����
    if WAR.Person[WAR.CurID]["�ҷ�"] then
      local nl = nil
      if JY.Person[pid]["�书" .. wugongnum] == 43 then    --��ת���� ����
        nl = math.modf((level + 3) / 2) * JY.Wugong[wugong]["������������"]
        if 400 < nl then
          nl = 400
        end
        if pid == 51 then    --Ľ�ݸ����ļ���
          nl = math.modf(nl / 2)
        end
      else
        nl = math.modf((level + 3) / 2) * JY.Wugong[wugong]["������������"]
      end
      
      --�����޼�����������������һ��
      for i = 1, 10 do
        if JY.Person[pid]["�书" .. i] == 99 then
          nl = nl - math.modf(nl * (JY.Person[pid]["�书�ȼ�" .. i] / 100 * 0.05))
          break;
        end
      end
      
      --�����壺лѷ������ֻ����һ������
      if pid == 13 then
      	nl = math.modf(nl/2);
      end
      
      --���Ż�����������������
      if pid == JY.MY and GetS(53, 0, 2, 5) == 2 then
      	nl = nl - math.modf(limitX((2000-JY.Thing[238]["�辭��"])/2000*nl,0, nl/2))
      	
      	--����֮�����ĵ��������
      	if GetS(53, 0, 5, 5) == 1 then
      	  if JLSD(0,15,pid) then
      			nl = math.modf(nl/3);
      		elseif JLSD(0,25,pid) then
      			nl = math.modf(nl/2);
      		end
      	end
      	
      end
      
      --���ڣ�����ʱ��������������
		  if JY.Person[pid]["��������"] == 0 then
		  	nl = math.modf(nl*(1-math.random(2)/10));
		  end
      
      AddPersonAttrib(pid, "����", -(nl))    
    else
      if GetS(0, 0, 0, 0) ~= 1 then
        AddPersonAttrib(pid, "����", -math.modf((level + 1) / 3) * JY.Wugong[wugong]["������������"])           
      else
        AddPersonAttrib(pid, "����", -math.modf((level + 1) / 6) * JY.Wugong[wugong]["������������"])
      end
    end
    
    if JY.Person[pid]["����"] < 0 then
      JY.Person[pid]["����"] = 0
    end
    
    if JY.Person[pid]["����"] <= 0 then
      break;
    end
    
  	DrawTimeBar2()
  	
  	--�����壺�������ÿ�ι���֮��X��1
  	if pid == 592 then
	  	if WAR.L_DGQB_X >= 10 then
	  		WAR.L_DGQB_X = 1;
	  	else
	  		WAR.L_DGQB_X = WAR.L_DGQB_X + 1;
	  	end
  	end
  	
  	--�����壺ʹ�÷����ƽ���ʱ���ͷ��ۼ�ֵ
  	if wugong ~= 36 and WAR.L_RYJF[pid] ~= nil then
  		WAR.L_RYJF[pid] = 36;
  	end
  	
  	--�����壺�������� ��Чȡ��
  	
  	if WAR.L_WYJFA ~= 0 then
  		if JLSD(20, 90, pid) then
  			WAR.L_WYJFA = wugong;
  		else
  			WAR.L_WYJFA = 0;
  		end
  	end
  	
 		WAR.ACT = WAR.ACT + 1   --ͳ�ƹ��������ۼ�1
 		
  	--�����壺������Χ�ڵĵ���ȫ������ʱȡ������
  	local flag = 0;
  	local n = 0;
    for i = 0, CC.WarWidth - 1 do
      for j = 0, CC.WarHeight - 1 do
        local effect = GetWarMap(i, j, 4)
        if 0 < effect then
          local emeny = GetWarMap(i, j, 2)
    			if 0 <= emeny and WAR.Person[id]["�ҷ�"] ~= WAR.Person[emeny]["�ҷ�"] then
    				n = n + 1;
    				if JY.Person[WAR.Person[emeny]["������"]]["����"] > 0 then
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

	--�����壺�������� ��Чȡ��
	WAR.L_WYJFA = 0;
  
  --�������ĵ�����
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
  
  --���Ż���������������
  if pid == JY.MY and GetS(53, 0, 2, 5) == 2 then
     jtl = jtl - math.modf(limitX((1500-JY.Thing[238]["�辭��"])/1500*jtl,0, jtl/3))
     --����֮�����ĵ��������
  	if GetS(53, 0, 5, 5) == 1 then
  	  if JLSD(0,15,pid) then
  			jtl = limitX(jtl-math.random(2),0,jtl);
  		elseif JLSD(0,25,pid) then
  			jtl = limitX(jtl-1,0,jtl);
  		end
  	end
  end
  
  --���ڣ�����ʱ����������
  if JY.Person[pid]["��������"] == 1 then
  	jtl = limitX(jtl-math.random(2),0,jtl);
  end
    
  --�˳���
  if pid == 89 then
   	--�˳��ӹ�������������
  else
  	if WAR.Person[WAR.CurID]["�ҷ�"] then
    	AddPersonAttrib(pid, "����", -(jtl))
    	
    	--��̫���񹦹������������ļӱ�
 			if WAR.L_TXSG[pid] ~= nil then
 				AddPersonAttrib(pid, "����", -(jtl));
 				WAR.L_TXSG[pid] = nil;
 			end
  	else
    	AddPersonAttrib(pid, "����", -math.modf(jtl/2));
    	--��̫���񹦹������������ļӱ�
 			if WAR.L_TXSG[pid] ~= nil then
 				AddPersonAttrib(pid, "����", -(jtl));
 				WAR.L_TXSG[pid] = nil;
 			end
  	end
  end
    
  --��ת���Ƽ���
  local dz = {}
  local dznum = 0
  for i = 0, WAR.PersonNum - 1 do
    if WAR.Person[i]["�����书"] ~= -1 and WAR.Person[i]["�����书"] ~= 9999 then
      dznum = dznum + 1
      dz[dznum] = {i, WAR.Person[i]["�����书"], x - WAR.Person[WAR.CurID]["����X"], y - WAR.Person[WAR.CurID]["����Y"]}
      WAR.Person[i]["�����书"] = 9999
    end
  end
  for i = 1, dznum do
    local tmp = WAR.CurID
    WAR.CurID = dz[i][1]
    WAR.DZXY = 1
    if WAR.DZXYLV[WAR.Person[WAR.CurID]["������"]] == 1 then
      WAR.DZXYLV[WAR.Person[WAR.CurID]["������"]] = 60
    elseif WAR.DZXYLV[WAR.Person[WAR.CurID]["������"]] == 2 then
        WAR.DZXYLV[WAR.Person[WAR.CurID]["������"]] = 85
    elseif WAR.DZXYLV[WAR.Person[WAR.CurID]["������"]] == 3 then
        WAR.DZXYLV[WAR.Person[WAR.CurID]["������"]] = 110
    end
    War_Fight_Sub(dz[i][1], dz[i][2] + 100, dz[i][3], dz[1][4])
    WAR.Person[WAR.CurID]["�����书"] = -1
    WAR.DZXYLV[WAR.Person[WAR.CurID]["������"]] = nil
    WAR.CurID = tmp
    WAR.DZXY = 0
  end
      
  --ˮ�����淢���������
  if WAR.YTFS == -1 then
    for i = 0, WAR.PersonNum - 1 do
      if WAR.Person[i]["������"] == 0 and T2SQ(WAR.Person[i]["������"]) then
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
          NewDrawString(-1, -1, "���������", C_GOLD, 25 + ii)
          ShowScreen()
          if ii == 24 then
            Cls()
            NewDrawString(-1, -1, "���������", C_GOLD, 25 + ii)
            ShowScreen()
            lib.Delay(500)
          else
            lib.Delay(1)
          end
        end
        
        --���������
        War_Fight_Sub(i, 2, WAR.Person[i]["����X"], WAR.Person[i]["����Y"])
        
        WAR.SQFJ = 0
        --ϴ�书
        for w = 1, 10 do
          if JY.Person[0]["�书" .. w] == JY.Person[0]["�书2"] and w ~= 2 then
            JY.Person[0]["�书2"] = WAR.YT1
            JY.Person[0]["�书�ȼ�2"] = WAR.YT2
          end
        end
        
        WAR.CurID = tmp
      end
    end    
  end
  return 1;
end

function War_SelectMove()
  local x0 = WAR.Person[WAR.CurID]["����X"]
  local y0 = WAR.Person[WAR.CurID]["����Y"]
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

--��ȡ�书��С����
function War_GetMinNeiLi(pid)
  local minv = math.huge
  for i = 1, 10 do
    local tmpid = JY.Person[pid]["�书" .. i]
    if tmpid > 0 and JY.Wugong[tmpid]["������������"] < minv then
      minv = JY.Wugong[tmpid]["������������"]
    end
  end
  return minv
end

function War_Manual()
  local r = nil
  local x, y, move, pic = WAR.Person[WAR.CurID]["����X"], WAR.Person[WAR.CurID]["����Y"], WAR.Person[WAR.CurID]["�ƶ�����"], WAR.Person[WAR.CurID]["��ͼ"]
  while true do
	  WAR.ShowHead = 1
	  r = War_Manual_Sub()
	  if r == 1 or r == -1 then
	    WAR.Person[WAR.CurID]["�ƶ�����"] = 0  
	  elseif r == 0 then
	    SetWarMap(WAR.Person[WAR.CurID]["����X"], WAR.Person[WAR.CurID]["����Y"], 2, -1)
	    SetWarMap(WAR.Person[WAR.CurID]["����X"], WAR.Person[WAR.CurID]["����Y"], 5, -1)
	    WAR.Person[WAR.CurID]["����X"], WAR.Person[WAR.CurID]["����Y"], WAR.Person[WAR.CurID]["�ƶ�����"] = x, y, move
	    SetWarMap(WAR.Person[WAR.CurID]["����X"], WAR.Person[WAR.CurID]["����Y"], 2, WAR.CurID)
	    SetWarMap(WAR.Person[WAR.CurID]["����X"], WAR.Person[WAR.CurID]["����Y"], 5, pic)
	  else
	  	break;
	  end
	end
	WAR.ShowHead = 0
	WarDrawMap(0)
	return r
end
	      
--�ֶ�ս���˵�
function War_Manual_Sub()
  local pid = WAR.Person[WAR.CurID]["������"]
  local isEsc = 0
  local warmenu = {
{"�ƶ�", War_MoveMenu, 1}, 
{"����", War_FightMenu, 1}, 
{"�ö�", War_PoisonMenu, 1}, 
{"�ⶾ", War_DecPoisonMenu, 1}, 
{"ҽ��", War_DoctorMenu, 1}, 
{"��Ʒ", War_ThingMenu, 1}, 
{"����", War_ActupMenu, 1}, 
{"����", War_DefupMenu, 1}, 
{"״̬", War_StatusMenu, 1}, 
{"��Ϣ", War_RestMenu, 1}, 
{"��ɫ", War_TgrtsMenu, 1}, 
{"ר��", War_JTMenu, 0}, 
{"�Զ�", War_AutoMenu, 1}
}

	--��ɫָ��
  if GRTS[pid] ~= nil then
    warmenu[11][1] = GRTS[pid]
  else
    warmenu[11][3] = 0
  end
  
  --����
  if pid == 49 then
    local t = 0
    for i = 0, WAR.PersonNum - 1 do
      local wid = WAR.Person[i]["������"]
      if WAR.TZ_XZ_SSH[wid] == 1 and WAR.Person[i]["����"] == false then
        t = 1
      end
    end
    if t == 0 then
      warmenu[11][3] = 0
    end
    if JY.Person[pid]["����"] < 20 then   --����С��20����ʾ��ɫָ��
    	warmenu[11][3] = 0
    end
  end
  
  --��ǧ��
  if pid == 88 then
    local yes = 0
    for i = 0, WAR.PersonNum - 1 do
      if WAR.Person[i]["�ҷ�"] == true and WAR.Person[i]["����"] == false and RealJL(WAR.CurID, i, 5) and i ~= WAR.CurID then
        yes = 1
      end
    end
    if yes == 0 then
      warmenu[11][3] = 0
    end
    if JY.Person[pid]["����"] < 10 then
    	warmenu[11][3] = 0
    end
  end
  
  --�˳���
  if pid == 89 then
    local px, py = WAR.Person[WAR.CurID]["����X"], WAR.Person[WAR.CurID]["����Y"]
    local mxy = {
			{WAR.Person[WAR.CurID]["����X"], WAR.Person[WAR.CurID]["����Y"] + 1}, 
			{WAR.Person[WAR.CurID]["����X"], WAR.Person[WAR.CurID]["����Y"] - 1}, 
			{WAR.Person[WAR.CurID]["����X"] + 1, WAR.Person[WAR.CurID]["����Y"]}, 
			{WAR.Person[WAR.CurID]["����X"] - 1, WAR.Person[WAR.CurID]["����Y"]}}

    local yes = 0
    for i = 1, 4 do
      if GetWarMap(mxy[i][1], mxy[i][2], 2) >= 0 then
        local mid = GetWarMap(mxy[i][1], mxy[i][2], 2)
        if inteam(WAR.Person[mid]["������"]) then
        	yes = 1
    		end
      end  
    end
    if yes == 0 then
      warmenu[11][3] = 0
    end
    if JY.Person[pid]["����"] < 25 then
   		warmenu[11][3] = 0
   	end
  end

	--���޼�
  if pid == 9 then
    local yes = 0
    for i = 0, WAR.PersonNum - 1 do
      if WAR.Person[i]["�ҷ�"] == true and WAR.Person[i]["����"] == false and RealJL(WAR.CurID, i, 8) and i ~= WAR.CurID then
        yes = 1
      end
    end
    if yes == 0 then
      warmenu[11][3] = 0
    end
    if JY.Person[pid]["����"] < 10 then
			warmenu[11][3] = 0
    end
  end
  
  if pid == 9 and JY.Person[pid]["����"] < 20 then
    warmenu[11][3] = 0
  end
  
  --�����壺����ͩͳ��ָ��
  if pid == 74 then
    if JY.Person[pid]["����"] <= 10 then
    	warmenu[11][3] = 0
    end
  end
  
  --�����壺ƽһָ����ָ��
  if pid == 28 then
  	if JY.Person[pid]["����"] < 50 then
    	warmenu[11][3] = 0
    end
  end
  
  --�����壺����������ָ��
  if pid == 590 and WAR.L_LWX == 1 then
  	warmenu[11][3] = 0
  end
  
  --�����壺�����ٻ�����ǰ��
  if pid == 0 then
  	if WAR.L_DGQB_ZL == 1 or JY.Person[pid]["����"] < 50 or JY.Person[pid]["����"] < 500 or JY.Person[592]["����"] > 3 or GetS(86,10,20,5) ~= 1 then
  		warmenu[11][3] = 0
  	end
  end
  
  --�����壺�ﲮ�� ��ɫָ��
  if pid == 29 then
  	if (GetS(86,10,12,5) ~= 1 and GetS(86,10,12,5) ~= 2) or JY.Person[pid]["����"] < 500 or JY.Person[pid]["����"] < 50 then
  		warmenu[11][3] = 0
  	end
  end

  
  --������ʱ��ֻ�й�������Ϣ�ɼ�
  if WAR.ZYHB == 2 then
    for i = 1, 12 do
      if i == 2 or i == 10 then
        i = i + 1
      end
      warmenu[i][3] = 0
    end
  end
  
  --����С��5�����Ѿ��ƶ���ʱ���ƶ����ɼ�
  if JY.Person[pid]["����"] <= 5 or WAR.Person[WAR.CurID]["�ƶ�����"] <= 0 then
    warmenu[1][3] = 0
    isEsc = 1
  end
  
  --�ж���С�������Ƿ����ʾ����
  local minv = War_GetMinNeiLi(pid)
  if JY.Person[pid]["����"] < minv or JY.Person[pid]["����"] < 10 then
    warmenu[2][3] = 0
  end
  
  if JY.Person[pid]["����"] < 10 or JY.Person[pid]["�ö�����"] < 20 then
    warmenu[3][3] = 0
  end
  if JY.Person[pid]["����"] < 10 or JY.Person[pid]["�ⶾ����"] < 20 then
    warmenu[4][3] = 0
  end
  if JY.Person[pid]["����"] < 50 or JY.Person[pid]["ҽ������"] < 20 then
    warmenu[5][3] = 0
  end
  
  --�����߻�״̬
  if WAR.tmp[1000 + pid] == 1 then
    for i = 3, 12 do
      warmenu[i][3] = 0
    end
    warmenu[10][3] = 1
  end
  
  --�»�ɽ�۽�������ʹ����Ʒ
  if WAR.ZDDH == 238 then
    warmenu[6][3] = 0
  end
  
  --��ʦ������ѡ���Ƿ񹥻�����
  if pid == 0 and GetS(53, 0, 2, 5) == 3 then
  	warmenu[12][3] = 1
  end
  
  lib.GetKey()
  Cls()
  DrawTimeBar_sub()
  return ShowMenu(warmenu, #warmenu, 0, CC.MainMenuX, CC.MainMenuY, 0, 0, 1, isEsc, CC.DefaultFont, C_ORANGE, C_WHITE)
end

--�����书
function War_PersonTrainBook(pid)
  local p = JY.Person[pid]
  local thingid = p["������Ʒ"]
  if thingid < 0 then
    return 
  end
  JY.Thing[101]["����������"] = 1
  JY.Thing[123]["��ȭ�ƹ���"] = 1
  local wugongid = JY.Thing[thingid]["�����书"]
  local wg = 0
  if JY.Person[pid]["�书10"] > 0 and wugongid >= 0 then
    for i = 1, 10 do
      if JY.Thing[thingid]["�����书"] == JY.Person[pid]["�书" .. i] then
        wg = 1
      end
    end
  if wg == 0 then		--�޸���һ�汾�����������书��BUG
  	return 
	end
  end
  
  
  local yes1, yes2, kfnum = false, false, nil
  while true do 
	  local needpoint = TrainNeedExp(pid)
	  if needpoint <= p["��������"] then
	    yes1 = true
	    AddPersonAttrib(pid, "�������ֵ", JY.Thing[thingid]["���������ֵ"])
	    if thingid == 139 then
	      AddPersonAttrib(pid, "�������ֵ", -15)
	      AddPersonAttrib(pid, "����", -15)
	      if JY.Person[pid]["�������ֵ"] < 1 then
	        JY.Person[pid]["�������ֵ"] = 1
	      end
	    end
	    if JY.Person[pid]["����"] < 1 then
	      JY.Person[pid]["����"] = 1
	    end
	    if JY.Thing[thingid]["�ı���������"] == 2 then
	      p["��������"] = 2
	    end
	    
	    AddPersonAttrib(pid, "�������ֵ", JY.Thing[thingid]["���������ֵ"])
	    AddPersonAttrib(pid, "������", JY.Thing[thingid]["�ӹ�����"])
	    AddPersonAttrib(pid, "�Ṧ", JY.Thing[thingid]["���Ṧ"])
	    AddPersonAttrib(pid, "������", JY.Thing[thingid]["�ӷ�����"])
	    AddPersonAttrib(pid, "ҽ������", JY.Thing[thingid]["��ҽ������"])
	    AddPersonAttrib(pid, "�ö�����", JY.Thing[thingid]["���ö�����"])
	    AddPersonAttrib(pid, "�ⶾ����", JY.Thing[thingid]["�ӽⶾ����"])
	    AddPersonAttrib(pid, "��������", JY.Thing[thingid]["�ӿ�������"])
	    if pid == 56 then		--���� ˫������ֵ
	      AddPersonAttrib(pid, "ȭ�ƹ���", JY.Thing[thingid]["��ȭ�ƹ���"] * 2)
	      AddPersonAttrib(pid, "��������", JY.Thing[thingid]["����������"] * 2)
	      AddPersonAttrib(pid, "ˣ������", JY.Thing[thingid]["��ˣ������"] * 2)
	      AddPersonAttrib(pid, "�������", JY.Thing[thingid]["���������"] * 2)
	    elseif pid == 590 then		--������ ˫���������ֵ
	    	AddPersonAttrib(pid, "ȭ�ƹ���", JY.Thing[thingid]["��ȭ�ƹ���"])
	      AddPersonAttrib(pid, "��������", JY.Thing[thingid]["����������"])
	      AddPersonAttrib(pid, "ˣ������", JY.Thing[thingid]["��ˣ������"])
	      AddPersonAttrib(pid, "�������", JY.Thing[thingid]["���������"]*2)
	    else
	      AddPersonAttrib(pid, "ȭ�ƹ���", JY.Thing[thingid]["��ȭ�ƹ���"])
	      AddPersonAttrib(pid, "��������", JY.Thing[thingid]["����������"])
	      AddPersonAttrib(pid, "ˣ������", JY.Thing[thingid]["��ˣ������"])
	      AddPersonAttrib(pid, "�������", JY.Thing[thingid]["���������"])
	    end
	    
	    --�����壺StarShine���л۵��츳������������Χ
	    if pid == 77 then		-- ���л��츳
				AddPersonAttrib(pid,"������",JY.Thing[thingid]["��ˣ������"]);
				AddPersonAttrib(pid,"�Ṧ",JY.Thing[thingid]["��ˣ������"]);
				AddPersonAttrib(pid,"������",JY.Thing[thingid]["��ˣ������"]);
			end

	    
	    AddPersonAttrib(pid, "��������", JY.Thing[thingid]["�Ӱ�������"])
	    AddPersonAttrib(pid, "��ѧ��ʶ", JY.Thing[thingid]["����ѧ��ʶ"])
	    AddPersonAttrib(pid, "Ʒ��", JY.Thing[thingid]["��Ʒ��"])
	    AddPersonAttrib(pid, "��������", JY.Thing[thingid]["�ӹ�������"])
	    if JY.Thing[thingid]["�ӹ�������"] == 1 then
	      p["���һ���"] = 1
	    end
	    if thingid > 186 then
	      p["��������"] = p["��������"] - needpoint
	    end
	    if JY.WGLVXS == 0 and thingid < 187 then
	      p["��������"] = p["��������"] - needpoint
	    end
	    
	    if wugongid >= 0 then 
	      yes2 = true
	      local oldwugong = 0
	      for i = 1, 10 do
	        if p["�书" .. i] == wugongid then
	          oldwugong = 1
	          p["�书�ȼ�" .. i] = math.modf((p["�书�ȼ�" .. i] + 100) / 100) * 100
	          kfnum = i
	          break;
	        end
	      end
	      if oldwugong == 0 then
			    for i = 1, 10 do
			      if p["�书" .. i] == 0 then
			        p["�书" .. i] = wugongid
			        p["�书�ȼ�" .. i] = 0;
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
		DrawStrBoxWaitKey(string.format("%s ���� %s �ɹ�", p["����"], JY.Thing[thingid]["����"]), C_WHITE, CC.DefaultFont)
	end
	if yes2 then
		DrawStrBoxWaitKey(string.format("%s ��Ϊ��%s��", JY.Wugong[wugongid]["����"], math.modf(p["�书�ȼ�" .. kfnum] / 100) + 1), C_WHITE, CC.DefaultFont)
	end
end

--��ʦ ��������ѡ��
function War_JTMenu()
	local pid = WAR.Person[WAR.CurID]["������"]
  Cls()
  WAR.ShowHead = 0
  WarDrawMap(0)
  
  local jt = "����"
  if WAR.ZSJT == 1 then
    jt = "ȡ������";
  end
  
  local yn = JYMsgBox("ר������","���˻�ȡ������*���˹������˵��ˣ�ȡ��������̶�* *���Ƶ���*�������ӵ�ǰ���Σ�����10��������500������*������������30��" ,{jt, "���Ƶ���"}, 2, pid,1)
  --����ѡ��
  if yn == 1 then
    if WAR.ZSJT == 1 then
    	WAR.ZSJT = 2;
    else
    	WAR.ZSJT = 1;
    end
 	elseif yn == 2 then		--���»�ȡ����
 		if pid == 0 then
	    if JY.Person[pid]["����"] >= 30 and JY.Person[pid]["����"] > 500 then
	      
	      CleanWarMap(6,-2);
	      WarNewLand();
	      
	      JY.Person[pid]["����"] = JY.Person[pid]["����"] - 10
	      JY.Person[pid]["����"] = JY.Person[pid]["����"]-500
				
				CurIDTXDH(WAR.CurID, 71,0, "���Ƶ���")
				WAR.tmp[8003] = 3     --���Ӽ����ٶ�
	      return 1
	    else
	    	DrawStrBoxWaitKey("δ���㷢������", C_WHITE, CC.DefaultFont)
	    	return 0
	    end
  	end
  end
  
  return 0;
end

--��ɫָ��
function War_TgrtsMenu()
  local pid = WAR.Person[WAR.CurID]["������"]
  Cls()
  WAR.ShowHead = 0
  WarDrawMap(0)
  local yn = JYMsgBox("��ɫָ�" .. GRTS[pid], GRTSSAY[pid], {"ȷ��", "ȡ��"}, 2, pid)
  if yn == 2 then
    return 0
  end
  
  --����  
  if pid == 53 then
    if JY.Person[pid]["����"] > 20 then
      WAR.TZ_DY = 1
      PlayWavE(16)
      CurIDTXDH(WAR.CurID, 71,0, "��Ѹ���� Ʈ������")
      JY.Person[pid]["����"] = JY.Person[pid]["����"] - 10
    else
    	DrawStrBoxWaitKey("δ���㷢������", C_WHITE, CC.DefaultFont)
    	return 0
    end
  end
  
  --����
  if pid == 49 then
    if JY.Person[pid]["����"] > 20 and JY.Person[pid]["����"] > 1000 then
      JY.Person[pid]["����"] = JY.Person[pid]["����"] - 5
      JY.Person[pid]["����"] = JY.Person[pid]["����"] - 500
      local ssh = {}
      local num = 1
      for i = 0, WAR.PersonNum - 1 do
        local wid = WAR.Person[i]["������"]
        if WAR.TZ_XZ_SSH[wid] == 1 and WAR.Person[i]["����"] == false then
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
        name[i][1] = JY.Person[ssh[i][2]]["����"]
        name[i][2] = nil
        name[i][3] = 1
      end
      DrawStrBox(CC.MainMenuX, CC.MainMenuY, "�߷���", C_GOLD, CC.DefaultFont)
      ShowMenu(name, num - 1, 10, CC.MainMenuX, CC.MainMenuY + 45, 0, 0, 1, 0, CC.DefaultFont, C_RED, C_GOLD)
      Cls()
      PlayWavAtk(32)
      CurIDTXDH(WAR.CurID, 72,0, "�������� ����Ⱥ��")
      PlayWavE(8)
      local sssid = lib.SaveSur(0, 0, CC.ScreenW, CC.ScreenH)
      for DH = 114, 129 do
        for i = 1, num - 1 do
          local x0 = WAR.Person[WAR.CurID]["����X"]
          local y0 = WAR.Person[WAR.CurID]["����Y"]
          local dx = WAR.Person[ssh[i][1]]["����X"] - x0
          local dy = WAR.Person[ssh[i][1]]["����Y"] - y0
          local rx = CC.XScale * (dx - dy) + CC.ScreenW / 2
          local ry = CC.YScale * (dx + dy) + CC.ScreenH / 2
          local hb = GetS(JY.SubScene, dx + x0, dy + y0, 4)

          ry = ry - hb
          lib.PicLoadCache(3, DH * 2, rx, ry, 2, 192)
          if DH > 124 then
            DrawString(rx - 10, ry - 15, "��Ѩ", C_GOLD, CC.DefaultFont)
          end
        end
        lib.ShowSurface(0)
        lib.LoadSur(sssid, 0, 0)
        lib.Delay(30)
      end
      lib.FreeSur(sssid)
    else
    	DrawStrBoxWaitKey("δ���㷢������", C_WHITE, CC.DefaultFont)
    	return 0
    end
  end
  
  --�˳���
  if pid == 89 then
    if JY.Person[pid]["����"] > 25 and JY.Person[pid]["����"] > 300 then
      local px, py = WAR.Person[WAR.CurID]["����X"], WAR.Person[WAR.CurID]["����Y"]
      local mxy = {
{WAR.Person[WAR.CurID]["����X"], WAR.Person[WAR.CurID]["����Y"] + 1}, 
{WAR.Person[WAR.CurID]["����X"], WAR.Person[WAR.CurID]["����Y"] - 1}, 
{WAR.Person[WAR.CurID]["����X"] + 1, WAR.Person[WAR.CurID]["����Y"]}, 
{WAR.Person[WAR.CurID]["����X"] - 1, WAR.Person[WAR.CurID]["����Y"]}}
      local zdp = {}
      local num = 1
      for i = 1, 4 do
        if GetWarMap(mxy[i][1], mxy[i][2], 2) >= 0 then
          local mid = GetWarMap(mxy[i][1], mxy[i][2], 2)
          if inteam(WAR.Person[mid]["������"]) then
          	zdp[num] = WAR.Person[mid]["������"]
          	num = num + 1
        	end
        end
        
      end
      local zdp2 = {}
      for i = 1, num - 1 do
        zdp2[i] = {}
        zdp2[i][1] = JY.Person[zdp[i]]["����"] .. "��" .. JY.Person[zdp[i]]["����"]
        zdp2[i][2] = nil
        zdp2[i][3] = 1
      end
      DrawStrBox(CC.MainMenuX, CC.MainMenuY, "������", C_GOLD, CC.DefaultFont)
      local r = ShowMenu(zdp2, num - 1, 10, CC.MainMenuX, CC.MainMenuY + 45, 0, 0, 1, 0, CC.DefaultFont, C_RED, C_GOLD)
      Cls()
      AddPersonAttrib(zdp[r], "����", 50)
      AddPersonAttrib(89, "����", -25)
      AddPersonAttrib(89, "����", -300)
      PlayWavE(28)
      lib.Delay(10)
      CurIDTXDH(WAR.CurID, 86,0, "������Ԫ")
      local Ocur = WAR.CurID
      for i = 0, WAR.PersonNum - 1 do
        if WAR.Person[i]["������"] == zdp[r] then
          WAR.CurID = i
        end
      end
      WarDrawMap(0)
      PlayWavE(36)
      lib.Delay(100)
      CurIDTXDH(WAR.CurID, 86, 0, "�ָ�����50��")
      WAR.CurID = Ocur
      WarDrawMap(0)
    else
    	DrawStrBoxWaitKey("δ���㷢������", C_WHITE, CC.DefaultFont)
    	return 0
    end
  end
  
  --���޼�
  if pid == 9 then
    if JY.Person[pid]["����"] > 10 and JY.Person[pid]["����"] > 500 then
      local nyp = {}
      local num = 1
      for i = 0, WAR.PersonNum - 1 do
        if WAR.Person[i]["�ҷ�"] == true and WAR.Person[i]["����"] == false and RealJL(WAR.CurID, i, 8) and i ~= WAR.CurID then
          nyp[num] = {}
          nyp[num][1] = JY.Person[WAR.Person[i]["������"]]["����"]
          nyp[num][2] = nil
          nyp[num][3] = 1
          nyp[num][4] = i
          num = num + 1
        end
      end
      DrawStrBox(CC.MainMenuX, CC.MainMenuY, "Ų�ƣ�", C_GOLD, CC.DefaultFont)
      local r = ShowMenu(nyp, num - 1, 10, CC.MainMenuX, CC.MainMenuY + 45, 0, 0, 1, 0, CC.DefaultFont, C_RED, C_GOLD)
      Cls()
      local mid = WAR.Person[nyp[r][4]]["������"]
      QZXS("��ѡ��Ҫ��" .. JY.Person[mid]["����"] .. "Ų�Ƶ�ʲôλ�ã�")
      War_CalMoveStep(WAR.CurID, 8, 1)
      local nx, ny = nil, nil
      while true do
	      nx, ny = War_SelectMove()
	      if nx ~= nil then
		      if lib.GetWarMap(nx, ny, 2) > 0 or lib.GetWarMap(nx, ny, 5) > 0 then
		        QZXS("�˴����ˣ�������ѡ��")			--�˴����ˣ�������ѡ��
	      	elseif CC.SceneWater[lib.GetWarMap(nx, ny, 0)] ~= nil then
	        	QZXS("ˮ�棬���ɽ��룡������ѡ��")		--ˮ�棬���ɽ��룡������ѡ��
	       	else
	       		break;
	        end
	      end
	    end
	    PlayWavE(5)
	    CurIDTXDH(WAR.CurID, 88,0, "�������� Ų��Ǭ��")		--�������� Ų��Ǭ��
	    local Ocur = WAR.CurID
	    WAR.CurID = nyp[r][4]
	    WarDrawMap(0)
	    CurIDTXDH(WAR.CurID, 88,0)
	    lib.SetWarMap(WAR.Person[WAR.CurID]["����X"], WAR.Person[WAR.CurID]["����Y"], 5, -1)
	    lib.SetWarMap(WAR.Person[WAR.CurID]["����X"], WAR.Person[WAR.CurID]["����Y"], 2, -1)
	    WarDrawMap(0)
	    CurIDTXDH(WAR.CurID, 88,0)
	    WAR.Person[WAR.CurID]["����X"], WAR.Person[WAR.CurID]["����Y"] = nx, ny
	    WarDrawMap(0)
	    CurIDTXDH(WAR.CurID, 88,0)
	    lib.SetWarMap(WAR.Person[WAR.CurID]["����X"], WAR.Person[WAR.CurID]["����Y"], 5, WAR.Person[WAR.CurID]["��ͼ"])
	    lib.SetWarMap(WAR.Person[WAR.CurID]["����X"], WAR.Person[WAR.CurID]["����Y"], 2, WAR.CurID)
	    WarDrawMap(0)
	    CurIDTXDH(WAR.CurID, 88,0)
	    WAR.CurID = Ocur
	    AddPersonAttrib(9, "����", -10)
	    AddPersonAttrib(9, "����", -500)
	    
	  else
	  	DrawStrBoxWaitKey("δ���㷢������", C_WHITE, CC.DefaultFont)
	  	return 0
	  end
	end
	
	--��ǧ��
	if pid == 88 then
	  if JY.Person[pid]["����"] > 10 and JY.Person[pid]["����"] > 700 then
	    local dxp = {}
	    local num = 1
	    for i = 0, WAR.PersonNum - 1 do
	      if WAR.Person[i]["�ҷ�"] == true and WAR.Person[i]["����"] == false and RealJL(WAR.CurID, i, 5) and i ~= WAR.CurID then
	        dxp[num] = {}
	        dxp[num][1] = JY.Person[WAR.Person[i]["������"]]["����"]
	        dxp[num][2] = nil
	        dxp[num][3] = 1
	        dxp[num][4] = i
	        num = num + 1
	      end
	    end
	    DrawStrBox(CC.MainMenuX, CC.MainMenuY, "������", C_GOLD, 30)
	    local r = ShowMenu(dxp, num - 1, 10, CC.MainMenuX, CC.MainMenuY + 45, 0, 0, 1, 0, CC.DefaultFont, C_RED, C_GOLD)
	    Cls()
	    local mid = WAR.Person[dxp[r][4]]["������"]
	    PlayWavE(28)
	    lib.Delay(10)
	    CurIDTXDH(WAR.CurID,87,0, "����Ϸ�쳾")
	    local Ocur = WAR.CurID
	    WAR.CurID = dxp[r][4]
	    WarDrawMap(0)
	    PlayWavE(36)
	    lib.Delay(100)
	    CurIDTXDH(WAR.CurID, 87, 0, "��������500")
	    WAR.CurID = Ocur
	    WarDrawMap(0)
	    WAR.Person[dxp[r][4]].Time = WAR.Person[dxp[r][4]].Time + 500
	    if WAR.Person[dxp[r][4]].Time > 999 then
	      WAR.Person[dxp[r][4]].Time = 999
	    end
	    AddPersonAttrib(88, "����", -10)
	    AddPersonAttrib(88, "����", -1000)
	  else
	  	DrawStrBoxWaitKey("δ���㷢������", C_WHITE, CC.DefaultFont)
	  	return 0
		end
	end
	
	
	--�����壺����ͩͳ��ָ��ҷ�ȫ�弯��ֵ��200��
	if pid == 74 then
		if JY.Person[pid]["����"] > 10 and JY.Person[pid]["����"] > 150 then
			CurIDTXDH(WAR.CurID, 92,0, GRTS[74]);		--������ʾ
			for i = 0, WAR.PersonNum - 1 do
				if WAR.Person[i]["�ҷ�"] == true and WAR.Person[i]["����"] == false and i ~= WAR.CurID then
					WAR.Person[i].Time = WAR.Person[i].Time + 200;
					if WAR.Person[i].Time > 999 then
						WAR.Person[i].Time = 999;
					end
				end
			end
			AddPersonAttrib(74, "����", -10)
	    AddPersonAttrib(74, "����", -150)
	    lib.Delay(100)
		else
			DrawStrBoxWaitKey("δ���㷢������", C_WHITE, CC.DefaultFont)
	  	return 0
		end
	end
	
	--�����壺ƽһָ����ָ��ҷ�ȫ��ظ�һ������ֵ������
	if pid == 28 then
		if JY.Person[pid]["����"] >= 50 and JY.Person[pid]["����"] > 250 then
			CleanWarMap(4,0);
			AddPersonAttrib(28, "����", -10)
	    AddPersonAttrib(28, "����", -250)
			for i = 0, WAR.PersonNum - 1 do
				if WAR.Person[i]["�ҷ�"] == true and WAR.Person[i]["����"] == false then
					local id = WAR.Person[i]["������"];
					local add = JY.Person[28]["ҽ������"]/4 + JY.Person[28]["ҽ������"]*WAR.PYZ/16 + math.random(30);		--��ɱ�����й�
					if add > JY.Person[28]["ҽ������"]/2 then	--���Ϊҽ��ֵ��һ��
						add = JY.Person[28]["ҽ������"]/2 + math.random(30) + 30;
					end
					
					add = math.modf(add);		
					WAR.Person[i]["���˵���"] = (WAR.Person[i]["���˵���"] or 0) + AddPersonAttrib(id, "���˳̶�", -math.modf((add) / 5));
					WAR.Person[i]["��������"] = (WAR.Person[i]["��������"] or 0) + AddPersonAttrib(id, "����", add);
					
					
					SetWarMap(WAR.Person[i]["����X"], WAR.Person[i]["����Y"], 4, 4)
					
				end
			end
			WAR.Person[WAR.CurID]["��Ч����2"] = GRTS[28];
			
			War_ShowFight(28,0,0,0,WAR.Person[WAR.CurID]["����X"],WAR.Person[WAR.CurID]["����Y"],0);
		else
			DrawStrBoxWaitKey("δ���㷢������", C_WHITE, CC.DefaultFont)
	  	return 0
		end
	end
	
	--Star�����л�--����
	if pid == 77 then
		if JY.Person[pid]["����"] > 500 and JY.Person[pid]["���˳̶�"] < 50 then
			local zjwid = nil
			for i = 0, WAR.PersonNum - 1 do
				if WAR.Person[i]["������"] == 0 and WAR.Person[i]["����"] == false then
					zjwid = i
					break
				end
			end
			if zjwid ~= nil then
				DrawStrBoxWaitKey("���ı��ۡ���Ů����", C_RED, 36)
				say("�����ã���������",0)
				say("�����磬���롣���������������ͣ�",77)
				JY.Person[pid]["����"] = 1
				JY.Person[pid]["���˳̶�"] = 100
				WAR.Person[WAR.CurID].Time = -500
				JY.Person[0]["����"] = JY.Person[0]["�������ֵ"]
				JY.Person[0]["���˳̶�"] = 0
				WAR.Person[zjwid].Time = 999
				WAR.FXDS[0] = nil
				WAR.LQZ[0] = 100
			else
				DrawStrBoxWaitKey("δ���㷢������", C_WHITE, CC.DefaultFont)		-- "δ���㷢������"
				return 0
			end

		else
			DrawStrBoxWaitKey("δ���㷢������", C_WHITE, CC.DefaultFont)		-- "δ���㷢������"
			return 0
		end
	end
	
	--�����壺����������ָ�ȫ����ѻظ������㵱ǰ������������������һ�룬���ظ����ˡ���Ѩ����Ѫ״̬��
	--ʹ�ú�����������������������Ϊ1�����ˡ���Ѩ����ѪΪ��
	if pid == 590 then
		if WAR.L_LWX == 0 then
			CurIDTXDH(WAR.CurID,33,0, GRTS[590]);		--������ʾ
			lib.Delay(100);
			for i = 0, WAR.PersonNum - 1 do
				if WAR.Person[i]["�ҷ�"] == true and WAR.Person[i]["����"] == false and i ~= WAR.CurID then
					local id = WAR.Person[i]["������"];
					
					AddPersonAttrib(id, "����", math.modf(JY.Person[590]["����"]/2));
					AddPersonAttrib(id, "����", math.modf(JY.Person[590]["����"]/2));
					AddPersonAttrib(id, "����", math.modf(JY.Person[590]["����"]/2));
					JY.Person[id]["���˳̶�"] = 0;
					WAR.FXDS[id] = nil;
					WAR.LXZT[id] = nil;

				end
			end
			
			JY.Person[590]["����"] = 1;
			JY.Person[590]["����"] = 1;
			JY.Person[590]["����"] = 1;
			JY.Person[590]["���˳̶�"] = 100;
			WAR.FXDS[590] = 50
			WAR.LXZT[590] = 100
			WAR.L_LWX = 1;
		else
			DrawStrBoxWaitKey("δ���㷢������", C_WHITE, CC.DefaultFont)
	  	return 0
		end
	end
	
	--�����壺���ѹ���ɫָ�� - ʩ��  ��Χ���Χ�ڵĵ���ʱ���ж���ʱ���Ѫ
	if pid == 17 then
		if JY.Person[pid]["����"] >= 30 and JY.Person[pid]["����"] >= 300 then
			CleanWarMap(4,0);
			AddPersonAttrib(17, "����", -15)
	    AddPersonAttrib(17, "����", -300)
			local x1 = WAR.Person[WAR.CurID]["����X"];
			local y1 = WAR.Person[WAR.CurID]["����Y"];
			for ex = x1 - 5, x1 + 5 do
	      for ey = y1 - 5, y1 + 5 do
	        SetWarMap(ex, ey, 4, 1)
	        if GetWarMap(ex, ey, 2) ~= nil and GetWarMap(ex, ey, 2) > -1 then
	          local ep = GetWarMap(ex, ey, 2)
	          if WAR.Person[WAR.CurID]["�ҷ�"] ~= WAR.Person[ep]["�ҷ�"] then
	          
	          	WAR.L_WNGZL[WAR.Person[ep]["������"]] = 50;			--50ʱ���ڳ������ж�+��Ѫ
		          SetWarMap(ex, ey, 4, 4)
		        end
	        end
	      end
	    end
			War_ShowFight(17,0,0,0,x1,y1,30);
		else
			DrawStrBoxWaitKey("δ���㷢������", C_WHITE, CC.DefaultFont)
	  	return 0
	  end
	end
	
		--brolycjw������ţ��ɫָ�� - Ⱥ��  ��Χ�ĸ�Χ�ڵĶ���ʱ������˲���������Ѫ
	if pid == 16 then
		if JY.Person[pid]["����"] >= 30 and JY.Person[pid]["����"] >= 300 then
			CleanWarMap(4,0);
			AddPersonAttrib(16, "����", -15)
	    AddPersonAttrib(16, "����", -300)
			local x1 = WAR.Person[WAR.CurID]["����X"];
			local y1 = WAR.Person[WAR.CurID]["����Y"];
			
			for ex = x1 - 4, x1 + 4 do
	      for ey = y1 - 4, y1 + 4 do
	        SetWarMap(ex, ey, 4, 1)
	        if GetWarMap(ex, ey, 2) ~= nil and GetWarMap(ex, ey, 2) > -1 then
	          local ep = GetWarMap(ex, ey, 2)
	          if WAR.Person[WAR.CurID]["�ҷ�"] == WAR.Person[ep]["�ҷ�"] then
	          
	          	WAR.L_HQNZL[WAR.Person[ep]["������"]] = 20;			--20ʱ���ڳ�����Ѫ+������
		          SetWarMap(ex, ey, 4, 4)
		          
		        end
	        end
	      end
	    end
			War_ShowFight(17,0,0,0,x1,y1,0);

		else
			DrawStrBoxWaitKey("δ���㷢������", C_WHITE, CC.DefaultFont)
	  	return 0
	  end
	end
	
	--�����壺�����ٻ��������
	if pid == 0 then
		if JY.Person[pid]["����"] >= 50 and JY.Person[pid]["����"] >= 500 and WAR.L_DGQB_ZL == 0  then
		
			AddPersonAttrib(0, "����", -15)
	    AddPersonAttrib(0, "����", -500)
		
			local x, y = WE_xy(WAR.Person[WAR.CurID]["����X"], WAR.Person[WAR.CurID]["����Y"] - 1)
			NewWARPersonZJ(592, true, x, y, false, 2);
      local s = nil
      s = WAR.CurID
      WAR.CurID = WAR.PersonNum - 1
      Talk("�ѵ���˴�ս�������μ����ǿ�ϧ��~~~����~~~", 592)  
      WAR.CurID = s
      
      WAR.L_DGQB_ZL = 1;
      JY.Person[592]["����"] = JY.Person[592]["����"] + 1;
		else
			DrawStrBoxWaitKey("δ���㷢������", C_WHITE, CC.DefaultFont)
	  	return 0
	  end
	end
	
	--�����壺�ﲮ��ָ��
	if pid == 29 then
		if JY.Person[pid]["����"] >= 50 and JY.Person[pid]["����"] >= 500 then
			
	    AddPersonAttrib(29, "����", -500)
	    
	    if GetS(86,10,12,5) == 1 then			--�˵�
	    	AddPersonAttrib(29, "����", -12)
				WAR.L_TBGZL = 1;
			elseif GetS(86,10,12,5) == 2 then		--��ɫ
				AddPersonAttrib(29, "����", -10)
				WAR.L_TBGZL = 2;
			end
	    
			War_FightMenu();
			
		else
			DrawStrBoxWaitKey("δ���㷢������", C_WHITE, CC.DefaultFont)
	  	return 0
	  end

	end
	
	return 1
end

--ս������
function War_ActupMenu()
  local p = WAR.CurID
  local id = WAR.Person[p]["������"]
  local x0, y0 = WAR.Person[p]["����X"], WAR.Person[p]["����Y"]
  
  if PersonKF(id, 95) then		--�и�󡹦�������سɹ��������»غϱس�������
  	WAR.Actup[id] = 2;
  	WAR.tmp[200 + id] = 101;		--�����壺�������ֱ����100
  	CurIDTXDH(WAR.CurID, 87, 0, "��������ɹ�");
  	return 1;
  elseif id == 0 and GetS(4, 5, 5, 5) == 1 then		--���ǣ���Ϭ��ȭ�������سɹ����ҽ�����������״̬
  	WAR.Actup[id] = 2	
  elseif PersonKF(id, 103) then			--���������سɹ�
    WAR.Actup[id] = 2
  elseif JLSD(15, 85, id) then
    WAR.Actup[id] = 2
  end
  if WAR.Actup[id] ~= 2 then
    Cls()
    DrawStrBox(-1, -1, "����ʧ��", C_GOLD, CC.DefaultFont)
    ShowScreen()
    lib.Delay(500)
  else
  	CurIDTXDH(WAR.CurID, 85, 0, "�����ɹ�");
    
    lib.Delay(500)
  end
  return 1
end


--ս������
function War_DefupMenu()
  local p = WAR.CurID
  local id = WAR.Person[p]["������"]
  local x0, y0 = WAR.Person[p]["����X"], WAR.Person[p]["����Y"]
  WAR.Defup[id] = 1
  Cls()
  local hb = GetS(JY.SubScene, x0, y0, 4)

  
  if PersonKF(id, 95) then		--�и�󡹦�������ɹ����»غϱس�������
  	WAR.Actup[id] = 2;
  	WAR.tmp[200 + id] = 101;		--�����壺�������ֱ����100
  	CurIDTXDH(WAR.CurID, 85,0, "��������ɹ�");
  	return 1;
  end
  
  CurIDTXDH(WAR.CurID, 86,0, "������ʼ");
  return 1
end

--��������ļ���ֵ������һ���ۺ�ֵ�Ա�ѭ��ˢ�¼�����
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
    if not WAR.Person[i]["����"] then
      local id = WAR.Person[i]["������"]
      local nsyxjq = math.modf(JY.Person[id]["���˳̶�"] / 25)
      WAR.Person[i].TimeAdd = math.modf(getnewmove(WAR.Person[i]["�Ṧ"], inteam(id)) + getnewmove1(JY.Person[id]["����"], JY.Person[id]["�������ֵ"], inteam(id)) - JY.Person[id]["�ж��̶�"] / (15+math.random(5)) - nsyxjq + JY.Person[id]["����"] / 20 + JY.Person[id]["������"]/80 + 5 + math.random(3))
      
      --�����񹦼Ӽ����ٶ�
      if PersonKF(id,105) then
          WAR.Person[i].TimeAdd = math.modf(WAR.Person[i].TimeAdd * 1.2)
      end
      
      --�������ܡ���쳡���ҩʦ��Ѫ�����桢������� �ж���10�㼯���ٶȼӳ�
      if id == 27 or id == 1 or id == 57 or id == 97 or id == 516 then
        WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd + 10
      end
      
      --�ﲮ�� ������� ��Խ�ټ���Խ��
      if id == 29 then
        WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd + 20
        for j = 0, WAR.PersonNum - 1 do
          if WAR.Person[j]["����"] == false and WAR.Person[j]["�ҷ�"] == WAR.Person[i]["�ҷ�"] then
            
            if GetS(86,10,12,5) ~= 0 then		--�ﲮ�������󣬼���ֵ����
            	WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd - 2
            else
            	WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd - 4
            end
          end
        end
        
        if WAR.L_TBGZL == 2 then	--��ɫָ����߼����ٶ�
        	WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd + 5
        end
        
        
      end
      
      --�������ٶȼӳ�
      --�����壺���ǽ�����Ҳ�ӳ�
      if GetS(4, 5, 5, 5) == 2 and id == 0 then
        local jsyx = 0
        for i = 1, 10 do
          if (JY.Person[0]["�书" .. i] == 110 or JY.Person[0]["�书" .. i] == 114 or (JY.Person[0]["�书" .. i] <= 48 and JY.Person[0]["�书" .. i] >= 27 and JY.Person[0]["�书" .. i] ~= 43)) and JY.Person[0]["�书�ȼ�" .. i] == 999 then
            jsyx = jsyx + 1
          end
        end
        WAR.Person[i].TimeAdd = math.modf(WAR.Person[i].TimeAdd * (1 + 0.05 * (jsyx)))
      end
      
      --�������ҷ�ÿ����һ���ˣ������ٶ�+4
      if id == 55 then
        local xz = 0
        for j = 0, WAR.PersonNum - 1 do
          if WAR.Person[j]["����"] == true and WAR.Person[j]["�ҷ�"] == WAR.Person[i]["�ҷ�"] then
            WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd + 4
          end
        end
      end
      
      
      --ʥ����ʹ��ͬʱ�ڳ�ʱ��ÿ�˼����ٶȶ���+20��
      if WAR.ZDDH == 14 and (id == 173 or id == 174 or id == 175) then
        local shz = 0
        for j = 0, WAR.PersonNum - 1 do
          if WAR.Person[j]["����"] == false and WAR.Person[j]["�ҷ�"] == WAR.Person[i]["�ҷ�"] then
            shz = shz + 1
          end
        end
        
        if shz == 3 then
        	WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd + 20
      	end
      end
      
      --�����壺�������
      if WAR.ZDDH == 73 and WAR.Person[i]["�ҷ�"] == false then
				WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd + 6
      end
      
      --4MM�������˼Ӽ����ٶ�
      if id == 92 then
        for j = 0, WAR.PersonNum - 1 do
	        if  WAR.Person[j]["����"] == false and WAR.Person[j]["�ҷ�"] == WAR.Person[i]["�ҷ�"] then
	        	WAR.Person[j].TimeAdd = WAR.Person[j].TimeAdd + 5
	        end
	      end
      end
      
      --�Ƿ壬���⼯���ٶ�+20
      if id == 50 then
        WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd + 20
      end
      
	  --brolycjw: ������ܣ����⼯���ٶ�
      if id == 592 then
        WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd + 10 + WAR.L_DGQB_X*2
      end
      
      --�������ּ����ӳ�
      if WAR.FLHS2 > 20 then
        WAR.FLHS2 = 20
      end
      if id == 0 then
        WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd + WAR.FLHS2
      end
      
      --�ɍ� �����⼯���ٶ�+10
      if id == 18 then
        WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd + 10
      end
      
      --Ѫ������ �����ٶȶ���ӳ�
      if id == 97 then
        WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd + WAR.XDLZ
      end
      
      --��������һ�� ����ǰ���⼯���ٶ�+5
      if id == 129 or id == 65 then
        WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd + WAR.WCY * 5
      end
      
      --
      if id == 553 then
        WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd + WAR.YZB2 * 4
      end
      
      --ƽһָ�������ٶȶ���ӳ�5*ɱ����
      if id == 28 then
        WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd + WAR.PYZ * 5
      end
      
      --�����壺brolycjw�����Ȼ������Ч �����ٶȼӳ�
      --ÿ��10�����˼����ٶ�����5
      if id == 58 and JY.Person[58]["���˳̶�"] > 50 and GetS(86,11,11,5) == 2 then
				--ƽ�����ü����µļӳɣ���������Ϊ55ʱ������2�㼯���ٶ�
      	WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd + math.floor(JY.Person[58]["���˳̶�"]-50)/2;
      end
      
      
		  
		  --�����壺������ �����ٶ�+5��
		  if id == 590 then
		  	WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd + 5;
		  end
		  
		  --�����壺װ������ �����ٶ�+5�㣬������װ���������+5��
		  if inteam(id) and JY.Person[id]["����"] == 230 then
		  	WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd + 5;
		  	if id == 590 then
		  		WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd + 5;
		  	end
		  end
		  
		  --�����壺ˮ���ڳ����з������ٶȼ�5��
		 if id == 589  then
    	for j = 0, WAR.PersonNum - 1 do
    		if WAR.Person[j]["����"] == false and WAR.Person[j]["�ҷ�"] ~= WAR.Person[i]["�ҷ�"] then
    			WAR.Person[j].TimeAdd = WAR.Person[j].TimeAdd - 5;   			
    		end
    	end
    end
		  
      
      --���˸����Ѷȼ����ٶȶ�������
      if not inteam(id) then
        if JY.Thing[202][WZ7] > 1 then
        	WAR.Person[i].TimeAdd = math.modf(WAR.Person[i].TimeAdd * (1 + JY.Thing[202][WZ7]/15)) + math.random(5)
        end  
      end
      
      if WAR.ZDDH == 128 and inteam(id) == false and id ~= 553 and JY.Thing[202][WZ7] > 1 then
        WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd + 10
      end
      
      --���˼�����
      if inteam(id) then
        WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd - math.modf(JY.Person[id]["���˳̶�"] / 20)
      else
      	WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd - math.modf(JY.Person[id]["���˳̶�"] / 30)
      end
      
      
      --�����壺���ٻ�ʱ�������ٶȼ�5��
      if WAR.CHZ[id] ~= nil and WAR.CHZ[id] > 0 then
      	WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd - 8;
      end
      
      
      --�����壺brolycjw �������С��Ů������ͬʱ�ڳ�ʱ�����Ӽ����ٶ�
      if id == 59 and GetS(86,11,11,5) == 1 then
		  	for j = 0, WAR.PersonNum - 1 do
		      if WAR.Person[j]["������"] == 0 and WAR.Person[j]["����"] == false and WAR.Person[j]["�ҷ�"] == WAR.Person[WAR.CurID]["�ҷ�"] then
      			local value = (GetSZ(59) + GetSZ(0) - 4)/2000;			--(С��Ůʵս + ����ʵս) / 2000			
      			WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd + math.floor(value*20);	--С��Ů�����ٶ�����
      			WAR.Person[j].TimeAdd = WAR.Person[j].TimeAdd + math.floor(value*20);	--���Ǽ����ٶ�����
		      	break;
		      end
		    end
		  end
      
      if WAR.Person[i].TimeAdd < 10 then
        WAR.Person[i].TimeAdd = 10
      end
      
      --ľ׮������
      if (id == 445 or id == 446) and WAR.ZDDH == 226 then
        WAR.Person[i].TimeAdd = 0
      end
      
      if WAR.Person[i].TimeAdd > 80 then
        WAR.Person[i].TimeAdd = 80
      end
      
      --��ʦ���������»غ����������ٶ�
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


--�书��Χѡ��
function War_KfMove(movefanwei, atkfanwei,wugong)
  local kind = movefanwei[1] or 0
  local len = movefanwei[2] or 0
  local x0 = WAR.Person[WAR.CurID]["����X"]
  local y0 = WAR.Person[WAR.CurID]["����Y"]
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
    
    --�ж��Ƿ��кϻ���
    if x ~= x0 or y ~= y0 then
	    local ZHEN_ID = -1;
	    for i = 0, WAR.PersonNum - 1 do
		    if WAR.Person[WAR.CurID]["�ҷ�"] == WAR.Person[i]["�ҷ�"] and i ~= WAR.CurID and WAR.Person[i]["����"] == false then
		      local nx = WAR.Person[i]["����X"]
		      local ny = WAR.Person[i]["����Y"]
		      local fid = WAR.Person[i]["������"]
		      for j = 1, 10 do
			      if JY.Person[fid]["�书" .. j] == wugong then         
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
					        
					        DrawString(rx - size, ry-hb-size/2, "�ϻ���", M_Purple, size);
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
    x0 = WAR.Person[WAR.CurID]["����X"]
    y0 = WAR.Person[WAR.CurID]["����Y"]
  else
    x0, y0 = cx, cy
  end
  local kind = fanwei[1]			--������Χ
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
      
	      --�����壺��ʾ���е��˵ĵ�Ϊ��ɫ
	      if GetWarMap(xy[i][1], xy[i][2], 2) ~= nil and GetWarMap(xy[i][1], xy[i][2], 2) >= 0 and GetWarMap(xy[i][1], xy[i][2], 2) ~= WAR.CurID then
					if not inteam(WAR.Person[GetWarMap(xy[i][1], xy[i][2], 2)]["������"]) and WAR.Person[WAR.CurID]["�ҷ�"] then
		      	local x0 = WAR.Person[WAR.CurID]["����X"];
		      	local y0 = WAR.Person[WAR.CurID]["����Y"];
		      	local dx = xy[i][1] - x0
		        local dy = xy[i][2] - y0
		        local size = CC.FontSmall;
		        local rx = CC.XScale * (dx - dy) + CC.ScreenW / 2
		        local ry = CC.YScale * (dx + dy) + CC.ScreenH / 2
		        
		        local hb = GetS(JY.SubScene, dx + x0, dy + y0, 4)

		        ry = ry - hb - CC.ScreenH/6;
		        
		        if ry < 1 then			--�����������ֹ������Ѫ�����
		        	ry = 1;
		        end
		      	
		      	--��ʾѡ�����������ֵ
		      	local color = RGB(245, 251, 5);
		      	local hp = JY.Person[WAR.Person[GetWarMap(xy[i][1], xy[i][2], 2)]["������"]]["����"];
		      	local maxhp = JY.Person[WAR.Person[GetWarMap(xy[i][1], xy[i][2], 2)]["������"]]["�������ֵ"];
		      	
		      	local ns = JY.Person[WAR.Person[GetWarMap(xy[i][1], xy[i][2], 2)]["������"]]["���˳̶�"];
		      	local zd = JY.Person[WAR.Person[GetWarMap(xy[i][1], xy[i][2], 2)]["������"]]["�ж��̶�"];
		      	local len = #(string.format("%d/%d",hp,maxhp));
		      	rx = rx - len*size/4;
		      	
		      	--��ɫ�������ܵ�����ȷ��
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
    local diwo = WAR.Person[WAR.CurID]["�ҷ�"]
    local atknum = 0
    for i = 1, num do
      if xy[i][1] >= 0 and xy[i][1] < CC.WarWidth and xy[i][2] >= 0 and xy[i][2] < CC.WarHeight then
        local id = GetWarMap(xy[i][1], xy[i][2], 2)
      
	      if id ~= -1 and id ~= WAR.CurID then
	        local xa, xb, xc = nil, nil, nil
	        if diwo ~= WAR.Person[id]["�ҷ�"] then
	          xa = 2
	        else
	          if GetS(0, 0, 0, 0) == 1 then
	            xa = -0.5
		        else
		          xa = 0
		        end
	        end
	        local hp = JY.Person[WAR.Person[id]["������"]]["����"]
	        if hp < atk / 6 then
	          xb = 2
	        elseif hp < atk / 3 then
	          xb = 1
	        else
	          xb = 0
	        end
	        local danger = JY.Person[WAR.Person[id]["������"]]["�������ֵ"]
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
  JY.Person[1]["����"] = 750
  JY.Person[1]["�������ֵ"] = 750
  JY.Person[1]["����"] = 2500
  JY.Person[1]["�������ֵ"] = 2500
  JY.Person[1]["������"] = 130
  JY.Person[1]["������"] = 130
  JY.Person[1]["�Ṧ"] = 180
  JY.Person[1]["���˳̶�"] = 0
  JY.Person[1]["�ж��̶�"] = 0
  JY.Person[1]["�书1"] = 67
  JY.Person[1]["�书�ȼ�1"] = 999
end

PNLBD[16] = function()
  JY.Person[37]["����"] = 850
  JY.Person[37]["�������ֵ"] = 850
  JY.Person[37]["����"] = 5000
  JY.Person[37]["�������ֵ"] = 5000
  JY.Person[37]["������"] = 120
  JY.Person[37]["������"] = 170
  JY.Person[37]["�Ṧ"] = 120
  JY.Person[37]["���˳̶�"] = 0
  JY.Person[37]["�ж��̶�"] = 0
  JY.Person[37]["�书�ȼ�1"] = 999
  JY.Person[37]["�书�ȼ�2"] = 999
  JY.Person[37]["�书2"] = 63
end

PNLBD[34] = function()
  JY.Person[36]["����"] = 650
  JY.Person[36]["�������ֵ"] = 650
  JY.Person[36]["����"] = 3000
  JY.Person[36]["�������ֵ"] = 3000
  JY.Person[36]["������"] = 180
  JY.Person[36]["������"] = 130
  JY.Person[36]["�Ṧ"] = 220
  JY.Person[36]["���˳̶�"] = 0
  JY.Person[36]["�ж��̶�"] = 0
  JY.Person[36]["�书�ȼ�1"] = 999
end

PNLBD[75] = function()
  JY.Person[58]["����"] = 850
  JY.Person[58]["�������ֵ"] = 850
  JY.Person[58]["����"] = 5500
  JY.Person[58]["�������ֵ"] = 5500
  JY.Person[58]["������"] = 230
  JY.Person[58]["������"] = 200
  JY.Person[58]["�Ṧ"] = 180
  JY.Person[58]["���˳̶�"] = 0
  JY.Person[58]["�ж��̶�"] = 0
  JY.Person[58]["�书�ȼ�1"] = 999
  JY.Person[58]["�书�ȼ�2"] = 999
  JY.Person[58]["�书�ȼ�3"] = 999
  JY.Person[59]["����"] = 750
  JY.Person[59]["�������ֵ"] = 750
  JY.Person[59]["����"] = 3500
  JY.Person[59]["�������ֵ"] = 3500
  JY.Person[59]["������"] = 190
  JY.Person[59]["������"] = 170
  JY.Person[59]["�Ṧ"] = 220
  JY.Person[59]["���˳̶�"] = 0
  JY.Person[59]["�ж��̶�"] = 0
  JY.Person[59]["�书�ȼ�1"] = 999
  JY.Person[59]["�书2"] = 107
  JY.Person[59]["�书�ȼ�2"] = 999
end

PNLBD[138] = function()
  JY.Person[75]["����"] = 650
  JY.Person[75]["�������ֵ"] = 650
  JY.Person[75]["����"] = 3000
  JY.Person[75]["�������ֵ"] = 3000
  JY.Person[75]["������"] = 140
  JY.Person[75]["������"] = 120
  JY.Person[75]["�Ṧ"] = 130
  JY.Person[75]["���˳̶�"] = 0
  JY.Person[75]["�ж��̶�"] = 0
  JY.Person[75]["�书�ȼ�1"] = 999
end

PNLBD[165] = function()
  JY.Person[54]["����"] = 750
  JY.Person[54]["�������ֵ"] = 750
  JY.Person[54]["����"] = 3500
  JY.Person[54]["�������ֵ"] = 3500
  JY.Person[54]["������"] = 180
  JY.Person[54]["������"] = 180
  JY.Person[54]["�Ṧ"] = 180
  JY.Person[54]["���˳̶�"] = 0
  JY.Person[54]["�ж��̶�"] = 0
  JY.Person[54]["�书�ȼ�1"] = 999
  JY.Person[54]["�书�ȼ�2"] = 999
end

PNLBD[170] = function()
  JY.Person[38]["����"] = 950
  JY.Person[38]["�������ֵ"] = 950
  JY.Person[38]["����"] = 5000
  JY.Person[38]["�������ֵ"] = 5000
  JY.Person[38]["������"] = 200
  JY.Person[38]["������"] = 200
  JY.Person[38]["�Ṧ"] = 160
  JY.Person[38]["���˳̶�"] = 0
  JY.Person[38]["�ж��̶�"] = 0
  JY.Person[38]["�书�ȼ�1"] = 999
  JY.Person[38]["�书�ȼ�2"] = 999
end

PNLBD[197] = function()
  JY.Person[48]["����"] = 850
  JY.Person[48]["�������ֵ"] = 850
  JY.Person[48]["����"] = 3000
  JY.Person[48]["�������ֵ"] = 3000
  JY.Person[48]["������"] = 150
  JY.Person[48]["������"] = 130
  JY.Person[48]["�Ṧ"] = 100
  JY.Person[48]["���˳̶�"] = 0
  JY.Person[48]["�ж��̶�"] = 0
  JY.Person[48]["�书�ȼ�1"] = 999
  JY.Person[48]["�书�ȼ�2"] = 999
  JY.Person[48]["�书2"] = 108
end

PNLBD[198] = function()
  JY.Person[51]["����"] = 750
  JY.Person[51]["�������ֵ"] = 750
  JY.Person[51]["����"] = 3000
  JY.Person[51]["�������ֵ"] = 3000
  JY.Person[51]["������"] = 180
  JY.Person[51]["������"] = 160
  JY.Person[51]["�Ṧ"] = 120
  JY.Person[51]["���˳̶�"] = 0
  JY.Person[51]["�ж��̶�"] = 0
  JY.Person[51]["�书�ȼ�1"] = 999
end

--��ʦ,�����һ���˵���Χ�����׵أ�����
function WarNewLand()

  --1����2�ף�3�󼪣�4����
  if GetS(53, 0, 2, 5) == 3 then
    while true do
    	local p = math.random(WAR.PersonNum)-1;
    	if WAR.Person[p]["����"] == false then 
    		if GetWarMap(0,0,6) == -2  then
	    		local x = WAR.Person[p]["����X"]
	    		local y = WAR.Person[p]["����Y"]
	    		
	    		CleanWarMap(6,-1);
	    		
	    		--����λ��һ����
	    		SetWarMap(x, y, 6, math.random(4));
	    		
	    		local n = 5;
	    		--ʮ������Ѻ����Ӹ���ĵ�
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

--ս��������
function WarMain(warid, isexp)
  WarLoad(warid)			--��ʼ��ս������
  WarSelectTeam()			--ѡ���ҷ�
  WarSelectEnemy()		--ѡ�����
  
  --�����壺ս��ʱ�������Ϊ�з�����ǿʵ��
  for i = 0, WAR.PersonNum - 1 do	
  	local p = WAR.Person[i]["������"];
  	if isteam(p) and WAR.Person[i]["�ҷ�"] == false then
  		WAR.tmp[4000 + i] = {p};
  		
  		--�Ѷ�����
  		if JY.Person[p]["�������ֵ"] <= JY.Thing[202][WZ7] * 80 then
  			WAR.tmp[4000+i][2] = JY.Thing[202][WZ7] * 200 + 100 - JY.Person[p]["�������ֵ"];
	    	JY.Person[p]["�������ֵ"] = JY.Thing[202][WZ7] * 200 + 100
	    else
	    	WAR.tmp[4000+i][2] = JY.Thing[202][WZ7] * JY.Person[p]["�������ֵ"] + 100 - JY.Person[p]["�������ֵ"]
	    	JY.Person[p]["�������ֵ"] = JY.Thing[202][WZ7] * JY.Person[p]["�������ֵ"] + 100
	    end
	    
	    JY.Person[p]["����"] = JY.Person[p]["�������ֵ"]
      
      --�Ѷ�����
      if JY.Person[p]["�������ֵ"] <= JY.Thing[202][WZ7] * 200 + 100 then
      	WAR.tmp[4000+i][3] = JY.Thing[202][WZ7] * 300 + 100 - JY.Person[p]["�������ֵ"];
      	JY.Person[p]["�������ֵ"] = JY.Thing[202][WZ7] * 300 + 100
      	
      elseif JY.Person[p]["�������ֵ"] < CC.PersonAttribMax["�������ֵ"] * 2 then
      	WAR.tmp[4000+i][3] = 600 * JY.Thing[202][WZ7];
      	JY.Person[p]["�������ֵ"] = JY.Person[p]["�������ֵ"] + WAR.tmp[4000+i][3]
    	end
    	
    	JY.Person[p]["����"] = JY.Person[p]["�������ֵ"]
    	
    	--������
    	WAR.tmp[4000+i][4] = JY.Thing[202][WZ7]*50;
    	JY.Person[p]["������"] = JY.Person[p]["������"] + WAR.tmp[4000+i][4]
    	
    	--������
    	WAR.tmp[4000+i][5] = JY.Thing[202][WZ7]*50;
    	JY.Person[p]["������"] = JY.Person[p]["������"] + WAR.tmp[4000+i][5]
    	
    	--�Ṧ
    	WAR.tmp[4000+i][6] = JY.Thing[202][WZ7]*40;
    	JY.Person[p]["�Ṧ"] = JY.Person[p]["�Ṧ"] + WAR.tmp[4000+i][6]
  	end
  end
  
  
  
  CleanMemory()
  lib.PicInit()
  lib.ShowSlow(30, 1)
  WarLoadMap(WAR.Data["��ͼ"])	--����ս����ͼ

for i = 0, CC.WarWidth-1 do
    for j = 0, CC.WarHeight-1 do
      lib.SetWarMap(i, j, 0, lib.GetS(JY.SubScene, i, j, 0))
      lib.SetWarMap(i, j, 1, lib.GetS(JY.SubScene, i, j, 1))
    end
  end
  
  --ѩɽ�仨��ˮս��
  if WAR.ZDDH == 42 then
    SetS(2, 24, 31, 1, 0)
    SetS(2, 30, 34, 1, 0)
    SetS(2, 27, 27, 1, 0)
  end
  
  --�»�ɽ�۽�
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
  
  --ɱ��������
  if WAR.ZDDH == 54 then
    lib.SetWarMap(11, 36, 1, 2)
  end
  
  --�ı���Ϸ״̬
  JY.Status = GAME_WMAP
  
  --������ͼ�ļ�

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
  --PlayMIDI(WAR.Data["����"])
  
  
  local first = 0          --��һ����ʾս�����
  local warStatus = nil		 --ս��״̬
  
  --�������¸�ֵ
  --for i = 0, WAR.PersonNum - 1 do
  --  for s = 1, 80 do
  --    JY.Person[WAR.Person[i]["������"]][PSX[s]] = JY.Person[WAR.Person[i]["������"]][PSX[s]]
  --  end
  --end
  
  WarPersonSort()			--���Ṧ����
  CleanWarMap(2, -1)
  CleanWarMap(6, -2)
  
  --Alungky: ľ׮��λ��Ų����������ֵǰ��
  JY.Person[445]["����"] = "�ٱ�"
  JY.Person[446]["����"] = "�ٱ�"
  if WAR.ZDDH == 226 then
    JY.Person[445]["����"] = "Ϊ��Ϊ��"
    JY.Person[446]["����"] =  "��֮����"
  end

  for i = 0, WAR.PersonNum - 1 do
  	
    if i == 0 then
      WAR.Person[i]["����X"], WAR.Person[i]["����Y"] = WE_xy(WAR.Person[i]["����X"], WAR.Person[i]["����Y"])
    else
      WAR.Person[i]["����X"], WAR.Person[i]["����Y"] = WE_xy(WAR.Person[i]["����X"], WAR.Person[i]["����Y"], i)
    end
    
    SetWarMap(WAR.Person[i]["����X"], WAR.Person[i]["����Y"], 2, i)
    
    local pid = WAR.Person[i]["������"]
    lib.PicLoadFile(string.format(CC.FightPicFile[1], JY.Person[pid]["ͷ�����"]), string.format(CC.FightPicFile[2], JY.Person[pid]["ͷ�����"]), 4 + i)
    
    --Alungky ��500����������ͷ������
    --Alungky ��500������������������
    --���ǵ�����Ҫ���⴦��
    if pid == 0 then
    	WAR.tmp[5000+i] = 280 + GetS(4, 5, 5, 5)
      WAR.tmp[5500+i] = JY.Person[0]["����"]
    else
    	WAR.tmp[5000+i] = JY.Person[pid]["ͷ�����"]
      WAR.tmp[5500+i] = JY.Person[pid]["����"]
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
    WAR.Person[i]["��ͼ"] = WarCalPersonPic(i)
  end
  WarSetPerson()
  WAR.CurID = 0
  WarDrawMap(0)
  lib.ShowSlow(30, 0)
  for i = 0, WAR.PersonNum - 1 do
    WAR.Person[i].Time = 800 - i * 1000 / WAR.PersonNum
    
    --����壬��ʼ������
    if WAR.Person[i]["������"] == 35 then
      WAR.Person[i].Time = 998
    end
    
    --����ɺ ÿ����������+50���ʼ����
    if WAR.Person[i]["������"] == 79 then
      local JF = 0
      for i = 1, 10 do
        if JY.Person[79]["�书" .. i] < 50 and JY.Person[79]["�书" .. i] > 26 and JY.Person[79]["�书�ȼ�" .. i] == 999 then
          JF = JF + 1
        end
      end
      WAR.Person[i].Time = WAR.Person[i].Time + (JF) * 50
    end
    
    if WAR.Person[i].Time > 990 then
      WAR.Person[i].Time = 990
    end
    
	--������ܣ���ʼ������
    if WAR.Person[i]["������"] == 592 then
      WAR.Person[i].Time = 999
    end
	
    --Ѫ������ ��ʼ����900
    if WAR.Person[i]["������"] == 97 then
      WAR.Person[i].Time = 900
    end
    
    --̫���ʼ����-200
    if JY.Person[WAR.Person[i]["������"]]["�Ա�"] == 2 then
		if WAR.Person[i]["������"] == 0 and GetS(86,15,15,5) == 1 then
		else
		WAR.Person[i].Time = -200
		end
    end
    
    --��ƽ֮ ��ʼ����700
    if WAR.Person[i]["������"] == 36 then
      WAR.Person[i].Time = 700
    end
    
    --������ɽ��������ľ׮
    if WAR.Person[i]["������"] == 445 and WAR.ZDDH == 226 then
      WAR.Person[i].Time = 999
    end
    if WAR.Person[i]["������"] == 446 and WAR.ZDDH == 226 then
      WAR.Person[i].Time = 900
    end
    
    --ʥ���� ��ʼ������200��100���
    local id = WAR.Person[i]["������"]
    if PersonKF(id, 93) then
      WAR.Person[i].Time = WAR.Person[i].Time + 200 + math.random(100)
    end
    if WAR.Person[i].Time > 990 then
      WAR.Person[i].Time = 990
    end
    
    
    WAR.Person[i]["�ƶ�����"] = math.modf(getnewmove(WAR.Person[i]["�Ṧ"]) - JY.Person[id]["�ж��̶�"] / 30 - JY.Person[id]["���˳̶�"] / 30 + JY.Person[id]["����"] / 30 - 3)
    if WAR.Person[i]["�ƶ�����"] < 1 then
      WAR.Person[i]["�ƶ�����"] = 1
    end
  end
  
  --�������ܣ�������
  JY.Person[27]["���һ���"] = 0
  
  --ս������ʾ��Ʒ
  for a = 0, WAR.PersonNum - 1 do
    for s = 1, 4 do
      if JY.Person[WAR.Person[a]["������"]]["Я����Ʒ����" .. s] == nil or JY.Person[WAR.Person[a]["������"]]["Я����Ʒ����" .. s] < 1 then
        JY.Person[WAR.Person[a]["������"]]["Я����Ʒ" .. s] = -1
        JY.Person[WAR.Person[a]["������"]]["Я����Ʒ����" .. s] = 0;
      end
    end
  end
  
  if WAR.ZDDH == 14 then
    say("�ǣ����ʹ��", 173, 0)   --���ʹ
    say("�ǣ�����ʹ��", 174, 1)   --����ʹ
    say("�ǣ�����ʹ����ʥ��������", 175, 5)   --����ʹ����ʥ��������
    for i = 1, 10 do
      NewDrawString(-1, -1, "ʥ��������", C_GOLD, CC.DefaultFont+i*2)
      ShowScreen()
      if i == 10 then
        lib.Delay(300)
      else
        lib.Delay(1)
      end
    end
  end
  
  --�ܵ�����ս���ҷ�����ȫ��Ϊ0...
  if WAR.ZDDH == 237 then
    for a = 0, WAR.PersonNum - 1 do
      if WAR.Person[a]["�ҷ�"] == true then
        WAR.Person[a].Time = 0
      end
    end
  end
  
  --�»�ɽ�۽�
  if WAR.ZDDH == 238 then
    for i = 1, 10 do
      NewDrawString(-1, -1, "��ɽ�۽�", C_GOLD, CC.DefaultFont+i*2)
      ShowScreen()
      if i == 10 then
        lib.Delay(300)
      else
        lib.Delay(1)
      end
    end
  end
  
  --ȫ�����ӣ��������
  if WAR.ZDDH == 73 then
    for i = 1, 10 do
      NewDrawString(-1, -1, "�������", C_GOLD, CC.DefaultFont+i*2)
      ShowScreen()
      if i == 10 then
        lib.Delay(300)
      else
        lib.Delay(1)
      end
    end
  end
  
  --�����壺�������߻��˺��������ʡ��������������߷�ʧ��
  for i = 0, WAR.PersonNum - 1 do
  	--���˲��ᣬ�ѷ��Ż��߻�ʧ��
  	if inteam(WAR.Person[i]["������"]) and PersonKF(WAR.Person[i]["������"], 104) and PersonKF(WAR.Person[i]["������"], 107) == false then
  		WAR.L_NYZH[WAR.Person[i]["������"]] = 1;
  	end
  end
  
  if WAR.ZDDH == 83 then     --�İ���֮ս���Ƿ�������
      JY.Person[50]["�书1"] = 13
    end
  	
  warStatus = 0
  buzhen()
  WAR.Delay = GetJiqi()
  local startt, endt = lib.GetTime()
  
  --��ʼ������
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

      if WAR.Person[p]["����"] == false and WAR.Person[p].Time > 1000 then
      	
      	
        WarDrawMap(0)
        ShowScreen()
        local keypress = lib.GetKey()
        if WAR.AutoFight == 1 and (keypress == VK_SPACE or keypress == VK_RETURN) then
          WAR.AutoFight = 0
        end
        reget = true
        local id = WAR.Person[p]["������"]
        
        --��ʦ���ڻ���ж��󣬼Ӽ���Ч��ȡ��
        if id == JY.MY then
        	WAR.tmp[8003] = nil;
        end
        
        --���Ҵ���֮�󣬲����ƶ�
        if WAR.ZYHB == 2 then
          WAR.Person[p]["�ƶ�����"] = 0
        elseif WAR.L_NOT_MOVE[WAR.Person[p]["������"]] ~= nil and WAR.L_NOT_MOVE[WAR.Person[p]["������"]] == 1 then
        	WAR.Person[p]["�ƶ�����"] = 0
        	WAR.L_NOT_MOVE[WAR.Person[p]["������"]] = nil
        else
        
        	--�����ƶ�����
          WAR.Person[p]["�ƶ�����"] = math.modf(getnewmove(WAR.Person[p]["�Ṧ"]) - JY.Person[id]["�ж��̶�"] / 50 - JY.Person[id]["���˳̶�"] / 60 + JY.Person[id]["����"] / 70 - 1)
          
          --�����壺�Ѷ������з����ƶ�����
          if WAR.Person[p]["�ҷ�"] == false then
	          if JY.Thing[202][WZ7] > 1 then			--�Ѷ�2�����1
	          	WAR.Person[p]["�ƶ�����"] = WAR.Person[p]["�ƶ�����"] + 1
	          end
	          if JY.Thing[202][WZ7] > 2 then		--�Ѷ�3�ٶ����1���൱��2��
	          	WAR.Person[p]["�ƶ�����"] = WAR.Person[p]["�ƶ�����"] + 1
	          end
	        end
          
          
          for j = 0, WAR.PersonNum - 1 do
          
          	--С�ѣ������Ʋ���������
            if WAR.Person[j]["������"] == 66 and WAR.Person[j]["����"] == false and WAR.Person[j]["�ҷ�"] ~= WAR.Person[p]["�ҷ�"] then
              WAR.Person[p]["�ƶ�����"] = WAR.Person[p]["�ƶ�����"] - 3
            end
          end
          if WAR.Person[p]["�ƶ�����"] < 1 then
            WAR.Person[p]["�ƶ�����"] = 1
          end
          if id == 35 or id == 6 or id == 97 then
            WAR.Person[p]["�ƶ�����"] = WAR.Person[p]["�ƶ�����"] + 3
          end
          if id == 5 and WAR.Person[p]["�ƶ�����"] < 8 then
            WAR.Person[p]["�ƶ�����"] = 8
          end
        end
        
        --����ƶ�����10
        if WAR.Person[p]["�ƶ�����"] > 10 then
          WAR.Person[p]["�ƶ�����"] = 10
        end
        
        
        WAR.ShowHead = 0
        WarDrawMap(0)
        WAR.Effect = 0
        WAR.CurID = p
        WAR.Person[p].TimeAdd = 0
        local r = nil
        local pid = WAR.Person[WAR.CurID]["������"]
        WAR.Defup[pid] = nil
        if pid == 53 then
          WAR.TZ_DY = 0
        end
        
        --�����壺�ﲮ���ж���ظ�״̬
        if pid == 29 then
        	WAR.L_TBGZL = 0;
        end
        
        --if instruct_16(pid) and WAR.Person[p]["�ҷ�"] and WAR.tmp[1000 + pid] ~= 1 then
        --�����壺�����ˣ��߷ַ����������
        if inteam(pid) and WAR.Person[p]["�ҷ�"] then
        
        	if WAR.L_NYZH[pid] ~= nil and math.random(10) < 8 then		--������
        		r = War_Auto()
          elseif WAR.AutoFight == 0 then
            r = War_Manual()
          else
            r = War_Auto()
          end
        else
          r = War_Auto()
        end
        
        
        
        --����������һ���
        if WAR.ZYHB == 1 then
          for j = 0, WAR.PersonNum - 1 do
            WAR.Person[j].Time = WAR.Person[j].Time - 15
            if WAR.Person[j].Time > 990 then
              WAR.Person[j].Time = 990
            end
          end
          WAR.Person[p].Time = 1005
          WAR.ZYYD = WAR.Person[p]["�ƶ�����"]
          WAR.ZYHBP = p
          if WAR.XDXX > 0 then
            DrawStrBox(-1, -1, "Ѫ��������ȡ����" .. WAR.XDXX, C_ORANGE, CC.DefaultFont)
            ShowScreen()
            lib.Delay(500)
            Cls()
            ShowScreen()
            WAR.XDXX = 0
          end
          WAR.QKNY = 0
          if JY.Person[129]["����"] <= 0 and WAR.WCY < 1 then
            JY.Person[129]["����"] = 1
          end
          if JY.Person[65]["����"] <= 0 and WAR.WCY < 1 then
            JY.Person[65]["����"] = 1
          end
          if WAR.ZDDH == 128 then
            for i = 0, WAR.PersonNum - 1 do
              if WAR.Person[i]["������"] == 553 and JY.Person[553]["����"] <= 0 then
                WAR.YZB = 1
                WAR.FXDS[553] = nil
                WAR.LXZT[553] = nil
              end
            end
	          if WAR.YZB == 1 then
              if WAR.YZB2 < 3 then
                WAR.YZB = 0
                WAR.YZB2 = WAR.YZB2 + 1
                say("���Ҹ��������������������줦���ʤ�Ȥ�����������򤳤Фࡡ����Ϥ֤��Τ������������Ҵ塡�������ޤ���", 553)
                JY.Person[553]["�������ֵ"] = JY.Person[553]["�������ֵ"] + 100
                JY.Person[553]["�������ֵ"] = JY.Person[553]["�������ֵ"] + 1000
                JY.Person[553]["����"] = JY.Person[553]["�������ֵ"]
                JY.Person[553]["����"] = JY.Person[553]["�������ֵ"]
                JY.Person[553]["�ж��̶�"] = 0
                JY.Person[553]["���˳̶�"] = 0
                JY.Person[553]["����"] = 100
                JY.Person[553]["������"] = JY.Person[553]["������"] + 100
                JY.Person[553]["������"] = JY.Person[553]["������"] + 100
                JY.Person[553]["�Ṧ"] = JY.Person[553]["�Ṧ"] + 80
                JY.Person[553]["�书1"] = 66
                JY.Person[553]["�书�ȼ�1"] = 999
                for j = 0, WAR.PersonNum - 1 do
                  if WAR.Person[j]["������"] == 553 then
                    WAR.Person[j].Time = 980
                  end
                end
	            else
	            	if WAR.YZB3 == 0 then
	                say("���Ҥ�Ϥ䡡����ޤǤ�..........", 553)
	                say("���������Ҵ壭�������������������������ʿ����������")
	                say("���������֣�һ��һ���������ٻ�ɣ�����ʱ�ҵ�������......��")
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
        
	        --Ѫ����Ѫ
	        if WAR.XDXX > 0 then
	          WAR.Person[WAR.CurID]["��������"] = WAR.XDXX;
	          War_Show_Count(WAR.CurID, "Ѫ����Ѫ");
	          WAR.XDXX = 0
	        end
        
	        --�޺���ħ�� ÿ�غϻظ�����
	        --for i = 1, 10 do
	          --if JY.Person[pid]["�书" .. i] == 96 and JY.Person[pid]["����"] > 0 then
	           -- local LK = nil
	           -- LK = math.modf((JY.Person[pid]["�������ֵ"] - JY.Person[pid]["����"]) * JY.Person[pid]["�书�ȼ�" .. i] / 100 * 0.015)
	           -- JY.Person[pid]["����"] = JY.Person[pid]["����"] + LK
	           -- DrawStrBox(-1, -1, "�޺���ħ���ָ�����" .. LK, C_ORANGE, CC.DefaultFont)
	           -- ShowScreen()
	          --  lib.Delay(400)
	          --  Cls()
	           -- ShowScreen()
			--end
	       -- end
	        
	        --��ϼ�� ÿ�غϻظ�����
	        --for i = 1, 10 do
	         -- if JY.Person[pid]["�书" .. i] == 89 then
	         --   local NK = nil
	         --   NK = math.modf((JY.Person[pid]["�������ֵ"] - JY.Person[pid]["����"]) * JY.Person[pid]["�书�ȼ�" .. i] / 100 * 0.015)
	        --    JY.Person[pid]["����"] = JY.Person[pid]["����"] + NK
	         --   DrawStrBox(-1, -1, "��ϼ�񹦻ָ�����" .. NK, C_ORANGE, CC.DefaultFont)
	          --  ShowScreen()
	          --  lib.Delay(400)
	         --   Cls()
	         --   ShowScreen()
	        --  end
	        --end
	        
	        --��Ԫ��ÿ�غϻظ�����
          if PersonKF(id, 90) then
            local TK = nil
						local NS = nil
            local ZD = 0
            TK = 6
						NS = 5 + math.modf(JY.Person[pid]["���˳̶�"]/10)
            WAR.Person[WAR.CurID]["��������"] = AddPersonAttrib(pid, "����", TK);
						AddPersonAttrib(pid, "���˳̶�", -NS)
						War_Show_Count(WAR.CurID, "��Ԫ���ظ�����");
          end
	        
	        --���¾Ž�������+200
	        
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
	
	        
	        --����棬����õ�ʳ��
	        if id == 81 and WAR.ZJZ == 0 and math.random(100)>80 then
	          instruct_2(210, 1)
	          WAR.ZJZ = 1
	        end
	        
	        --һ�ƺ������������ⱻ����
	        if JY.Person[129]["����"] <= 0 and WAR.WCY < 1 then
	          JY.Person[129]["����"] = 1
	        end
	        if JY.Person[65]["����"] <= 0 and WAR.WCY < 1 then
	          JY.Person[65]["����"] = 1
	        end
	          
	        --С�ձ�
	        if WAR.ZDDH == 128 then
	          for i = 0, WAR.PersonNum - 1 do
	            if WAR.Person[i]["������"] == 553 and JY.Person[553]["����"] <= 0 then
	              WAR.YZB = 1
	              WAR.FXDS[553] = nil
	              WAR.LXZT[553] = nil
	            end
	          end
	        end
	          
	        --С�ձ�����������
	        if WAR.YZB == 1 then
	          if WAR.YZB2 < 3 then
	            WAR.YZB = 0
	            WAR.YZB2 = WAR.YZB2 + 1
	            say("���Ҹ��������������������줦���ʤ�Ȥ�����������򤳤Фࡡ����Ϥ֤��Τ������������Ҵ塡�������ޤ���", 553)
	            JY.Person[553]["�������ֵ"] = JY.Person[553]["�������ֵ"] + 100
	            JY.Person[553]["�������ֵ"] = JY.Person[553]["�������ֵ"] + 1000
	            JY.Person[553]["����"] = JY.Person[553]["�������ֵ"]
	            JY.Person[553]["����"] = JY.Person[553]["�������ֵ"]
	            JY.Person[553]["�ж��̶�"] = 0
	            JY.Person[553]["���˳̶�"] = 0
	            JY.Person[553]["����"] = 100
	            JY.Person[553]["������"] = JY.Person[553]["������"] + 100
	            JY.Person[553]["������"] = JY.Person[553]["������"] + 100
	            JY.Person[553]["�Ṧ"] = JY.Person[553]["�Ṧ"] + 80
	            JY.Person[553]["�书1"] = 66
	            JY.Person[553]["�书�ȼ�1"] = 999
	            for j = 0, WAR.PersonNum - 1 do
	              if WAR.Person[j]["������"] == 553 then
	                WAR.Person[j].Time = 990
	              end
	            end
	        	elseif WAR.YZB3 == 1 then
	            say("���Ҥ�Ϥ䡡����ޤǤ�..........", 553)
	            say("���������Ҵ壭�������������������������ʿ����������")
	            say("���������֣�һ��һ���������ٻ�ɣ�����ʱ�ҵ�������......��")
	            WAR.YZB3 = 1
	          end
	        end
	          
	        --���ǣ��伲��磬����500
	        if WAR.FLHS1 == 1 then
	          if id == 0 then
	            WAR.Person[p].Time = WAR.Person[p].Time + 500
	          end
	          WAR.FLHS1 = 0
	        end
	        
	        ----�����壺brolycjw�����Ȼ������Ч �ж�������ʼλ�ö�������
	        --�����ٹ�����֮һʱÿ��100�����ж�����λ�ü�100
	        if id == 58 and JY.Person[58]["����"] < JY.Person[58]["�������ֵ"]/2  and GetS(86,11,11,5) == 2 then
	        	--�����ж����ʼ����λ��ÿ100������������100��
	        	WAR.Person[p].Time = WAR.Person[p].Time +math.floor(JY.Person[58]["�������ֵ"]/2 - JY.Person[58]["����"]);
	        end
	          
	          
	        --Ѫ������
	        if id == 97 then
	          WAR.XDLZ = WAR.XDLZ + 5
	        end
	        
					--�ֻ�͵Ǯ
	        if WAR.YJ > 0 then
	          instruct_2(174, WAR.YJ)
	          WAR.YJ = 0
	        end
	        
	        --äĿ״̬�ָ�
	        if WAR.KHCM[pid] == 1 or WAR.KHCM[pid] == 2 then
	          WAR.KHCM[pid] = 0
	          Cls()
	          DrawStrBox(-1, -1, "äĿ״̬�ָ�", C_ORANGE, CC.DefaultFont)
	          ShowScreen()
	          lib.Delay(500)
	        end
	        
	        --�������ж�һ�μ�1
	        if WAR.Actup[id] ~= nil then
	          WAR.Actup[id] = WAR.Actup[id] - 1
	        end
	        
	        if WAR.Actup[id] == 0 then
	          WAR.Actup[id] = nil
	        end
	        
	        --Ԭ��־ ������
	        if id == 54 then
	          JY.Person[id]["���˳̶�"] = 0
	        end
	        
	        JY.Wugong[13]["����"] = "����"
	        
	        --�ܲ�ͨ
	        if id == 64 then
	          WAR.ZBT = WAR.ZBT + 1
	        end
	        
	        
	        if WAR.TGN == 1 then
	          say("�������������������˷���������������ˣ����շ������֮�ޣ�", 72)    --���ũɱ�����˷�
	          JY.Person[72]["������"] = JY.Person[72]["������"] + 20
	          JY.Person[72]["������"] = JY.Person[72]["������"] + 20
	          JY.Person[72]["�Ṧ"] = JY.Person[72]["�Ṧ"] + 20
	          JY.Person[72]["�书1"] = 44
	          JY.Person[72]["�书�ȼ�1"] = 50
	          DrawStrBox(-1, -1, "���ũ����������������20�� ѧ����ҽ���", C_ORANGE, CC.DefaultFont)
	          ShowScreen()
	          lib.Delay(2000)
	          WAR.TGN = 0
	        end
	        
	        WAR.QKNY = 0
	        if WAR.LQZ[id] == 100 then
	          WAR.LQZ[id] = 0
	        end
	        
	        --��� ��  ����~~
	        if WAR.XK == 1 then
	          for j = 0, WAR.PersonNum - 1 do
	            if WAR.Person[j]["������"] == 58 and 0 < JY.Person[WAR.Person[j]["������"]]["����"] and WAR.Person[j]["�ҷ�"] ~= WAR.Person[WAR.CurID]["�ҷ�"] then
	              WAR.Person[j].Time = 980
	              say("�����������������������ȣ�����������������������������������������������������������������", 58)
	              WAR.XK = 2
	            end
	          end
	        end
	        
	        --���� ��֪����
	        if WAR.FLHS5 == 1 then
	          local z = WAR.CurID
	          for j = 0, WAR.PersonNum - 1 do
	            if WAR.Person[j]["������"] == 0 and 0 < JY.Person[0]["����"] then
	              WAR.FLHS5 = 0
	              WAR.CurID = j
	            end
	          end
	          if WAR.FLHS5 == 0 and WAR.AutoFight == 0 and WAR.tmp[1000] ~= 1 then
	            WAR.Person[WAR.CurID]["�ƶ�����"] = 6
	            War_CalMoveStep(WAR.CurID, WAR.Person[WAR.CurID]["�ƶ�����"], 0)
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
	        
	        --ʥ���� ��������ƶ�
	        if (0 < WAR.Person[p]["�ƶ�����"] or 0 < WAR.ZYYD) and WAR.Person[p]["�ҷ�"] == true and inteam(WAR.Person[p]["������"]) and WAR.AutoFight == 0 and WAR.tmp[1000 + id] ~= 1 and PersonKF(WAR.Person[p]["������"], 93) and 0 < JY.Person[WAR.Person[p]["������"]]["����"] then
	          if 0 < WAR.ZYYD then
	            WAR.Person[p]["�ƶ�����"] = WAR.ZYYD
	            War_CalMoveStep(p, WAR.ZYYD, 0)
	            WAR.ZYYD = 0
	          else
	            War_CalMoveStep(p, WAR.Person[p]["�ƶ�����"], 0)
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
	        
	        --ѩɽ��ɱѪ������󣬻ָ��ҷ�����
	        if WAR.ZDDH == 7 then
	          for x = 0, WAR.PersonNum - 1 do
	            if WAR.Person[x]["������"] == 97 and JY.Person[97]["����"] <= 0 then
	              for xx = 0, WAR.PersonNum - 1 do
	                if WAR.Person[xx]["������"] ~= 97 then
	                  WAR.Person[xx]["�ҷ�"] = true
	                end
	              end
	            end
	          end
	        end
	          
	        --
	        if WAR.ZDDH == 176 and 80 < JY.Person[0]["Ʒ��"] and WAR.EVENT1 == 0 and 300 < WAR.SXTJ then
	          for i = 32, 40 do
	            if GetWarMap(i, 32, 2) < 0 then
	              NewWARPersonZJ(69, true, i, 33, false, 1)
	              WAR.EVENT1 = 1
	              local s = nil
	              s = WAR.CurID
	              WAR.CurID = WAR.PersonNum - 1
	              say("���Ͻл�Ҳ���ո����֣�", 69)   --�Ͻл�Ҳ���ո�����
	              WAR.CurID = s
	              break;
	            end
	          end
	        end
	          
	        --ɱ�������ܣ����Ϲֳ���
	        if WAR.ZDDH == 54 and WAR.EVENT1 == 0 then
	          for i = 0, WAR.PersonNum - 1 do
	            if WAR.Person[i]["������"] == 73 and WAR.Person[i]["�ҷ�"] == true and JY.Person[WAR.Person[i]["������"]]["����"] <= 0 then
	              for r = 31, 42 do
	                if GetWarMap(r, 27, 2) < 0 then
	                  NewWARPersonZJ(26, true, r, 27, false, 2)
	                  WAR.Person[WAR.PersonNum - 1].Time = 900
	                  WAR.EVENT1 = 1
	                  local s = nil
	                  s = WAR.CurID
	                  WAR.CurID = WAR.PersonNum - 1
	                  say("��ӯӯ���������£�Ϊ��������㶫�����̣�������----", 26)   --ӯӯ���������£�Ϊ��������㶫�����̣�������----
	                  WAR.CurID = s
	                  break;
	                end
	              end
	            end
		        end
	        end
	          
	          
	        if WAR.ZDDH == 54 and lib.GetWarMap(11, 36, 1) == 2 and inteam(WAR.Person[p]["������"]) and WAR.Person[p]["����X"] == 12 and WAR.Person[p]["����Y"] == 36 then
	          lib.SetWarMap(11, 36, 1, 5420)
	          WarDrawMap(0)
	          say("AA")
	          say("OHMYGO", 27)
	          lib.SetWarMap(11, 36, 1, 0)
	        end
	        
	        if 500 < WAR.Person[p].Time then
	          WAR.Person[p].Time = 500
	        end
	        
	          
	        local pz = math.modf(JY.Person[0]["����"] / 5)
	        --����ҽ�� ����
	        if id == 0 and GetS(4, 5, 5, 5) == 7  then
	        	if 50 < JY.Person[0]["����"] then
	            if WAR.HTSS == 0 and GetS(53, 0, 4, 5) == 1 and JLSD(25, 50 + pz, 0) and 0 < JY.Person[0]["�书10"] then
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
	              JY.Person[0]["����"] = JY.Person[0]["����"] - 10
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
	          
	        --�����ܵ� 100ʱ�����
	        if WAR.ZDDH == 237 and 100 < WAR.SXTJ then
	          for i = 0, WAR.PersonNum - 1 do
	            if WAR.Person[i]["�ҷ�"] == false then
	              WAR.Person[i]["����"] = true
	            end
	          end
	          say("�����ţ�û�������С�Ӿ����ˣ��й�������С�ӣ��������ˣ��Ϸ���Ҫ�´��죬��ξͷ���һ��", 18)  --(�ţ�û�������С�Ӿ����ˣ�
	        end
	          
	      	 --����������ʮ���20ʱ��ʤ��
	        if WAR.ZDDH == 134 and 20 < WAR.SXTJ and GetS(87,31,32,5) == 1 then
	          for i = 0, WAR.PersonNum - 1 do
	            if WAR.Person[i]["�ҷ�"] == false then
	              WAR.Person[i]["����"] = true
	            end
	          end
	          TalkEx("��ϲ����ͦ��20ʱ�򣬳ɹ����ء�",269,0);
	        end
	
					--��������аʮ���20ʱ��ʤ��
	        if WAR.ZDDH == 133 and 20 < WAR.SXTJ and GetS(87,31,31,5) == 1 then
	          for i = 0, WAR.PersonNum - 1 do
	            if WAR.Person[i]["�ҷ�"] == false then
	              WAR.Person[i]["����"] = true
	            end
	          end
	          TalkEx("��ϲ����ͦ��20ʱ�򣬳ɹ����ء�",269,0);
	        end
	        
	        --�����壺������ʮ��ͭ�� 800ʱ��ʤ��
	        if WAR.ZDDH == 217 and GetS(86,1,2,5) == 1 and 800 < WAR.SXTJ then
	        	for i = 0, WAR.PersonNum - 1 do
	            if WAR.Person[i]["�ҷ�"] == false then
	              WAR.Person[i]["����"] = true
	            end
	          end
	          Talk("����~~���ڴ���ȥ��~~~����ʮ��ͭ�����Ȼ�����鴫~~",0);		--����~~���ڴ���ȥ��~~~����ʮ��ͭ�����Ȼ�����鴫~~
	        end
	        
	        --�����壺Ⱥս��ʮ��ͭ�� ����500ʱ��ʧ��
	        if WAR.ZDDH == 217 and GetS(86,1,2,5) == 2 and 500 < WAR.SXTJ then
	        	Talk("����~~�ÿ�ϧ����һ��ͳɹ��ˡ�����ʮ��ͭ�����Ȼ�����鴫",0);		--����~~�ÿ�ϧ����һ��ͳɹ��ˡ�����ʮ��ͭ�����Ȼ�����鴫
	        	for i = 0, WAR.PersonNum - 1 do
	            if WAR.Person[i]["�ҷ�"] then
	              WAR.Person[i]["����"] = true
	            end
	          end
	        end
	        
          
	        --�»�ɽ�۽�
	        if WAR.ZDDH == 238 then
	        	local life = 0
	        	WAR.NO1 = 114;
	          for i = 0, WAR.PersonNum - 1 do
	            if WAR.Person[i]["����"] == false and 0 < JY.Person[WAR.Person[i]["������"]]["����"] then
	              life = life + 1
	              if WAR.NO1 >= WAR.Person[i]["������"] then
	              	WAR.NO1 = WAR.Person[i]["������"]
	              end
	            end
	          end
	          
	          if 1 < life then
	            local m, n = 0, 0
	            while true do			--��ֹȫ��������ѷ�
	            	if m >= 1 and n >= 1 then
	            		break;
	            	else
	            		m = 0;
	            		n = 0;
	            	end
	            	
		            for i = 0, WAR.PersonNum - 1 do
		              if WAR.Person[i]["����"] == false and 0 < JY.Person[WAR.Person[i]["������"]]["����"] then
		                if WAR.Person[i]["������"] == 0 then
		                  WAR.Person[i]["�ҷ�"] = true
		                  	m = m + 1
			              elseif math.random(2) == 1 then
			                  WAR.Person[i]["�ҷ�"] = true
			                  m = m + 1
			              else
		                	WAR.Person[i]["�ҷ�"] = false
		                	n = n + 1
		                end
		              end
		            end
		          end
	          end
	        end
	    	end
	    end
	    
		  warStatus = War_isEnd()   --ս���Ƿ������   0������1Ӯ��2��
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
  
  --�����壺ս���������з�����״̬�ظ�
  for i = 0, WAR.PersonNum - 1 do	
  	if WAR.tmp[4000 + i] ~= nil then
  		local n = WAR.tmp[4000 + i];
  		JY.Person[n[1]]["�������ֵ"] = JY.Person[n[1]]["�������ֵ"] - n[2]
  		JY.Person[n[1]]["�������ֵ"] = JY.Person[n[1]]["�������ֵ"] - n[3]
  		JY.Person[n[1]]["������"] = JY.Person[n[1]]["������"] - n[4]
  		JY.Person[n[1]]["������"] = JY.Person[n[1]]["������"] - n[5]
  		JY.Person[n[1]]["�Ṧ"] = JY.Person[n[1]]["�Ṧ"] - n[6]
  	end
  end
  
  --�ظ�ս����Ҳ����һ��ˢ�ĸ�����
  if WAR.tmp[8002] ~= nil then
  	JY.Thing[238]["�辭��"] = JY.Thing[238]["�辭��"] + limitX(WAR.tmp[8002],0,40)		--һ�����40
  	
  	--���Ʋ����Կ�ʼ��ˢ��
  	if JY.Thing[238]["�辭��"] > JY.Person[0]["����"]*8 then
  		JY.Thing[238]["�辭��"] = JY.Person[0]["����"]*8
  	end
  	
  	if JY.Thing[238]["�辭��"] > 1000 then
  		JY.Thing[238]["�辭��"] = 1000;
  	end
  end
  
  --ս��������Ľ���
  if WAR.ZDDH == 238 then
    PlayMIDI(101)
    PlayWavAtk(41)
    DrawStrBoxWaitKey("�۽�����", C_WHITE, CC.DefaultFont)
    DrawStrBoxWaitKey("�书���µ�һ�ߣ�" .. JY.Person[WAR.NO1]["����"], C_RED, CC.DefaultFont)
    if WAR.NO1 == 0 then
      r = true
    else
      r = false
    end
  elseif warStatus == 1 then   --ս��ʤ��
    PlayMIDI(101)
    PlayWavAtk(41)
    DrawStrBoxWaitKey("ս��ʤ��", C_WHITE, CC.DefaultFont)
    if WAR.ZDDH == 76 then
      DrawStrBoxWaitKey("���⽱����ǧ����֥��ö", C_GOLD, CC.DefaultFont)
      instruct_32(14, 2)
    elseif WAR.ZDDH == 80 then
        DrawStrBoxWaitKey("���⽱����������ϵ����ֵ����ʮ��", C_GOLD, CC.DefaultFont)
        AddPersonAttrib(0, "ȭ�ƹ���", 10)
        AddPersonAttrib(0, "��������", 10)
        AddPersonAttrib(0, "ˣ������", 10)
        AddPersonAttrib(0, "�������", 10)
    elseif WAR.ZDDH == 100 then
        DrawStrBoxWaitKey("���⽱���������������������", C_GOLD, CC.DefaultFont)
        instruct_32(8, 2)
    elseif WAR.ZDDH == 172 then
        DrawStrBoxWaitKey("���⽱������ø�󡹦�ؼ�һ��", C_GOLD, CC.DefaultFont)
        instruct_32(73, 1)
    elseif WAR.ZDDH == 173 then
        DrawStrBoxWaitKey("���⽱���������ɽѩ����ö", C_GOLD, CC.DefaultFont)
        instruct_32(17, 2)
    elseif WAR.ZDDH == 188 then
        DrawStrBoxWaitKey("���⽱��������ȭ�ƹ�������ʮ��", C_GOLD, CC.DefaultFont)
        AddPersonAttrib(0, "ȭ�ƹ���", 10)
    elseif WAR.ZDDH == 211 then
        DrawStrBoxWaitKey("���⽱�������Ƿ��������Ṧ������ʮ��", C_GOLD, CC.DefaultFont)
        AddPersonAttrib(0, "������", 10)
        AddPersonAttrib(0, "�Ṧ", 10)
    elseif WAR.ZDDH == 86 then
        instruct_2(66, 1)
	elseif WAR.ZDDH == 75 or WAR.ZDDH == 4 then
		QZXS(string.format("%s ʵս����%s��",JY.Person[0]["����"],50));
		SetS(5, 1, 6, 5, GetS(5, 1, 6, 5)+50);
	elseif WAR.ZDDH == 77 then
		QZXS(string.format("%s ʵս����%s��",JY.Person[0]["����"],30));
		SetS(5, 1, 6, 5, GetS(5, 1, 6, 5)+30);	
	elseif WAR.ZDDH > 42 and  WAR.ZDDH < 47 then
		QZXS(string.format("%s ʵս����%s��",JY.Person[0]["����"],20));
		SetS(5, 1, 6, 5, GetS(5, 1, 6, 5)+20);
	elseif WAR.ZDDH == 161 then
		QZXS(string.format("%s ʵս����%s��",JY.Person[0]["����"],70));
		SetS(5, 1, 6, 5, GetS(5, 1, 6, 5)+70);		
    end
    
    --�����壺ս��ʤ���������͵ȡ�������ϵ���Ʒ��ֻ͵ȡҩƷ
    local thing = {};
    local tnum = 0;
    for i = 0, WAR.PersonNum - 1 do
    	if WAR.Person[i]["�ҷ�"] == false then
    		local enid = WAR.Person[i]["������"];
    		for j=1, 4 do
	    		if JY.Person[enid]["Я����Ʒ����" .. j] ~= nil and 0 < JY.Person[enid]["Я����Ʒ����" .. j] and -1 < JY.Person[enid]["Я����Ʒ" .. j] and JY.Person[enid]["Я����Ʒ" .. j] < 26 then
						tnum = tnum + 1
						thing[tnum] = {JY.Person[enid]["Я����Ʒ" .. j], enid, j}
			    end
			  end
    	end	
    end
    if tnum > 0 then
    	local n = math.random(tnum+2);		--���͵ȡ
    	if thing[n] ~= nil then
    		local a = thing[n][1];		--��ƷID��
    		local b = thing[n][2];		--����ı��
    		local c = thing[n][3];		--Я������Ʒλ��
    		
    		JY.Person[b]["Я����Ʒ����"..c] = JY.Person[b]["Я����Ʒ����"..c] - 1;
    		if JY.Person[b]["Я����Ʒ����"..c] < 1 then
    			JY.Person[b]["Я����Ʒ"..c] = -1;
    		end
				DrawStrBoxWaitKey(string.format("���ս��Ʒ��%s %d��", JY.Thing[a]["����"], 1), C_GOLD, CC.DefaultFont)
				instruct_32(a, 1);
    	end
    end
    r = true
  elseif warStatus == 2 then   --ս��ʧ��
    DrawStrBoxWaitKey("ս��ʧ��", C_WHITE, CC.DefaultFont)
    r = false
  end
  War_EndPersonData(isexp, warStatus)
  lib.ShowSlow(50, 1)
  if 0 <= JY.Scene[JY.SubScene]["��������"] then
    PlayMIDI(JY.Scene[JY.SubScene]["��������"])
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

--���أ�����
function buzhen()
  if not inteam(56) then
    return 
  end
  if WAR.ZDDH == 238 then
    return 
  end
  say("�Ҫ����������", 56)
  if not DrawStrBoxYesNo(-1, -1, "Ҫ����������", C_WHITE, CC.DefaultFont) then
    return 
  end
  for i = 0, WAR.PersonNum - 1 do
    if WAR.Person[i]["�ҷ�"] then
      WAR.CurID = i
      WAR.ShowHead = 1
      War_CalMoveStep(WAR.CurID, math.modf(JY.Person[56]["�ȼ�"] / 3 - 4), 0)
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
  local x0, y0 = WAR.Person[id]["����X"], WAR.Person[id]["����Y"]
  local hb = GetS(JY.SubScene, x0, y0, 4)

  --����EFT
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


--�����ԭ
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

--���㰵���˺�
function War_AnqiHurt(pid, emenyid, thingid)
  local num = nil
  if JY.Person[emenyid]["���˳̶�"] == 0 then
    num = JY.Thing[thingid]["������"] / 3 - Rnd(5)
  elseif JY.Person[emenyid]["���˳̶�"] <= 33 then
      num = JY.Thing[thingid]["������"] / 2 - Rnd(8)
  elseif JY.Person[emenyid]["���˳̶�"] <= 66 then
      num = math.modf(JY.Thing[thingid]["������"] *2 / 3) - Rnd(12)
  else
    num = JY.Thing[thingid]["������"] - Rnd(16)
  end
  
  num = math.modf((num - JY.Person[pid]["��������"] * 2) / 3)
  AddPersonAttrib(emenyid, "���˳̶�", math.modf(-num / 6))
  local r = AddPersonAttrib(emenyid, "����", math.modf(num / 2))
  if (emenyid == 129 or emenyid == 65) and JY.Person[emenyid]["����"] <= 0 then
    JY.Person[emenyid]["����"] = 1
  end
  if emenyid == 553 and JY.Person[emenyid]["����"] <= 0 then
    WAR.YZB = 1
  end
  if JY.Person[emenyid]["����"] <= 0 then
    WAR.Person[WAR.CurID]["����"] = WAR.Person[WAR.CurID]["����"] + JY.Person[emenyid]["�ȼ�"] * 5
  end
  if JY.Thing[thingid]["���ж��ⶾ"] > 0 then
    num = math.modf((JY.Thing[thingid]["���ж��ⶾ"] + JY.Person[pid]["��������"]) / 4)
    num = num - JY.Person[emenyid]["��������"]
    num = limitX(num, 0, CC.PersonAttribMax["�ö�����"])
    AddPersonAttrib(emenyid, "�ж��̶�", num)
  end
  return r
end
--�����(x,y)��ʼ��������ܹ����м�������
function War_AutoCalMaxEnemy(x, y, wugongid, level)
  local wugongtype = JY.Wugong[wugongid]["������Χ"]
  local movescope = JY.Wugong[wugongid]["�ƶ���Χ" .. level]
  local fightscope = JY.Wugong[wugongid]["ɱ�˷�Χ" .. level]
  local maxnum = 0
  local xmax, ymax = nil, nil
  if wugongtype == 0 or wugongtype == 3 then
    local movestep = War_CalMoveStep(WAR.CurID, movescope, 1)	--�����书�ƶ�����
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
          if n ~= WAR.CurID and WAR.Person[n]["����"] == false and WAR.Person[n]["�ҷ�"] ~= WAR.Person[WAR.CurID]["�ҷ�"] then
            local x = math.abs(WAR.Person[n]["����X"] - xx)
            local y = math.abs(WAR.Person[n]["����Y"] - yy)
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
        if id >= 0 and WAR.Person[WAR.CurID]["�ҷ�"] ~= WAR.Person[id]["�ҷ�"] then
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
        if id >= 0 and WAR.Person[WAR.CurID]["�ҷ�"] ~= WAR.Person[id]["�ҷ�"] then
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


--�õ������ߵ����������˵����λ�á�
--scope���Թ����ķ�Χ
--���� x,y������޷��ߵ�����λ�ã����ؿ�
function War_AutoCalMaxEnemyMap(wugongid, level)
  local wugongtype = JY.Wugong[wugongid]["������Χ"]
  local movescope = JY.Wugong[wugongid]["�ƶ���Χ" .. level]
  local fightscope = JY.Wugong[wugongid]["ɱ�˷�Χ" .. level]
  local x0 = WAR.Person[WAR.CurID]["����X"]
  local y0 = WAR.Person[WAR.CurID]["����Y"]
  CleanWarMap(4, 0)
  if wugongtype == 0 or wugongtype == 3 then
    for n = 0, WAR.PersonNum - 1 do
      if n ~= WAR.CurID and WAR.Person[n]["����"] == false and WAR.Person[n]["�ҷ�"] ~= WAR.Person[WAR.CurID]["�ҷ�"] then
        local xx = WAR.Person[n]["����X"]
        local yy = WAR.Person[n]["����Y"]
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
      if n ~= WAR.CurID and WAR.Person[n]["����"] == false and WAR.Person[n]["�ҷ�"] ~= WAR.Person[WAR.CurID]["�ҷ�"] then
        local xx = WAR.Person[n]["����X"]
        local yy = WAR.Person[n]["����Y"]
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
end--�Զ�ҽ��
function War_AutoDoctor()
  local x1 = WAR.Person[WAR.CurID]["����X"]
  local y1 = WAR.Person[WAR.CurID]["����Y"]
  War_ExecuteMenu_Sub(x1, y1, 3, -1)
end--�Զ���ҩ
--flag=2 ������3������4����  6 �ⶾ
function War_AutoEatDrug(flag)
  local pid = WAR.Person[WAR.CurID]["������"]
  local life = JY.Person[pid]["����"]
  local maxlife = JY.Person[pid]["�������ֵ"]
  local selectid = nil
  local minvalue = math.huge
  local shouldadd, maxattrib, str = nil, nil, nil
  if flag == 2 then
    maxattrib = JY.Person[pid]["�������ֵ"]
    shouldadd = maxattrib - JY.Person[pid]["����"]
    str = "������"
  elseif flag == 3 then
    maxattrib = JY.Person[pid]["�������ֵ"]
    shouldadd = maxattrib - JY.Person[pid]["����"]
    str = "������"
  elseif flag == 4 then
    maxattrib = CC.PersonAttribMax["����"]
    shouldadd = maxattrib - JY.Person[pid]["����"]
    str = "������"
  elseif flag == 6 then
    maxattrib = CC.PersonAttribMax["�ж��̶�"]
    shouldadd = JY.Person[pid]["�ж��̶�"]
    str = "���ж��ⶾ"
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
  
  if inteam(pid) and WAR.Person[WAR.CurID]["�ҷ�"] == true then
    local extra = 0
    for i = 1, CC.MyThingNum do
      local thingid = JY.Base["��Ʒ" .. i]
      if thingid >= 0 then
        local add = Get_Add(thingid)
        if JY.Thing[thingid]["����"] == 3 and add > 0 then
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
        local thingid = JY.Base["��Ʒ" .. i]
        if thingid >= 0 then
          local add = Get_Add(thingid)
          if JY.Thing[thingid]["����"] == 3 and add > 0 then
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
      local thingid = JY.Person[pid]["Я����Ʒ" .. i]
      local tids = JY.Person[pid]["Я����Ʒ����" .. i]
      if thingid >= 0 and tids > 0 then
        local add = Get_Add(thingid)
        if JY.Thing[thingid]["����"] == 3 and add > 0 then
	        local v = shouldadd - add
	        if v < 0 then		--���Լ�������, �����������Һ���ҩƷ
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
        local thingid = JY.Person[pid]["Я����Ʒ" .. i]
        local tids = JY.Person[pid]["Я����Ʒ����" .. i]
        if thingid >= 0 and tids > 0 then
          local add = Get_Add(thingid)
          if JY.Thing[thingid]["����"] == 3 and add > 0 then
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
--�Զ�����
function War_AutoEscape()
  local pid = WAR.Person[WAR.CurID]["������"]
  if JY.Person[pid]["����"] <= 5 then
    return 
  end
  local x, y = nil, nil
  War_CalMoveStep(WAR.CurID, WAR.Person[WAR.CurID]["�ƶ�����"], 0)		 --�����ƶ�����
  WarDrawMap(1)
  ShowScreen()
  local array = {}
  local num = 0
  
  for i = 0, CC.WarWidth - 1 do
    for j = 0, CC.WarHeight - 1 do
      if GetWarMap(i, j, 3) < 128 then
        local minDest = math.huge
        for k = 0, WAR.PersonNum - 1 do
          if WAR.Person[WAR.CurID]["�ҷ�"] ~= WAR.Person[k]["�ҷ�"] and WAR.Person[k]["����"] == false then
            local dx = math.abs(i - WAR.Person[k]["����X"])
            local dy = math.abs(j - WAR.Person[k]["����Y"])
	          if dx + dy < minDest then		--���㵱ǰ������������λ��
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

  War_CalMoveStep(WAR.CurID, WAR.Person[WAR.CurID]["�ƶ�����"], 0)
  War_MovePerson(x, y)	--�ƶ�����Ӧ��λ��
end
--�Զ�ִ��ս������ʱ��λ��һ�����Դ򵽵���
function War_AutoExecuteFight(wugongnum)
  local pid = WAR.Person[WAR.CurID]["������"]
  local x0 = WAR.Person[WAR.CurID]["����X"]
  local y0 = WAR.Person[WAR.CurID]["����Y"]
  local wugongid = JY.Person[pid]["�书" .. wugongnum]
  local level = math.modf(JY.Person[pid]["�书�ȼ�" .. wugongnum] / 100) + 1
  local maxnum, x, y = War_AutoCalMaxEnemy(x0, y0, wugongid, level)
  if x ~= nil then
    War_Fight_Sub(WAR.CurID, wugongnum, x, y)
    WAR.Person[WAR.CurID].Action = {"atk", x - WAR.Person[WAR.CurID]["����X"], y - WAR.Person[WAR.CurID]["����Y"]}
  end
end--�Զ�ս��
function War_AutoMenu()
  WAR.AutoFight = 1
  WAR.ShowHead = 0
  Cls()
  War_Auto()
  return 1
end

--������ƶ�����
--id ս����id��
--stepmax �������
--flag=0  �ƶ�����Ʒ�����ƹ���1 �书���ö�ҽ�Ƶȣ������ǵ�·��
function War_CalMoveStep(id, stepmax, flag)
  CleanWarMap(3, 255)
  local x = WAR.Person[id]["����X"]
  local y = WAR.Person[id]["����Y"]
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
--�ж�x,y�Ƿ�Ϊ���ƶ�λ��
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
end--�ⶾ�˵�
function War_DecPoisonMenu()
  WAR.ShowHead = 0
  local r = War_ExecuteMenu(2)
  WAR.ShowHead = 1
  Cls()
  return r
end

--�жϹ�������Եķ���
function War_Direct(x1, y1, x2, y2)
  local x = x2 - x1
  local y = y2 - y1
  if x == 0 and y == 0 then
    return WAR.Person[WAR.CurID]["�˷���"]
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

--ҽ�Ʋ˵�
function War_DoctorMenu()
  WAR.ShowHead = 0
  local r = War_ExecuteMenu(3)
  WAR.ShowHead = 1
  Cls()
  return r
end---ִ��ҽ�ƣ��ⶾ�ö�
---flag=1 �ö��� 2 �ⶾ��3 ҽ�� 4 ����
---thingid ������Ʒid
function War_ExecuteMenu(flag, thingid)
  local pid = WAR.Person[WAR.CurID]["������"]
  local step = nil
  if flag == 1 then
    step = math.modf(JY.Person[pid]["�ö�����"] / 40)
  elseif flag == 2 then
    step = math.modf(JY.Person[pid]["�ⶾ����"] / 40)
  elseif flag == 3 then
    step = math.modf(JY.Person[pid]["ҽ������"] / 40)
  elseif flag == 4 then
    step = math.modf(JY.Person[pid]["��������"] / 15) + 1
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
  local x0 = WAR.Person[WAR.CurID]["����X"]
  local y0 = WAR.Person[WAR.CurID]["����Y"]
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
    WAR.Person[WAR.CurID]["�˷���"] = WAR.Person[WAR.CurID]["�˷���"]
  else
  	WAR.Person[WAR.CurID]["�˷���"] = War_Direct(x0, y0, x, y)
  end
  SetWarMap(x, y, 4, 1)
  WAR.EffectXY = {}
  return x, y
end

--������һ�����ƶ�������
function War_FindNextStep(steparray, step, flag, id)
  local num = 0
  local step1 = step + 1
  
  local fujinnum = function(tx, ty)
    if flag ~= 0 or id == nil then
      return 0
    end
    local tnum = 0
    local wofang = WAR.Person[id]["�ҷ�"]
    local tv = nil
    tv = GetWarMap(tx + 1, ty, 2)
    if tv ~= -1 and WAR.Person[tv]["�ҷ�"] ~= wofang then
      tnum = 9999
    end
    tv = GetWarMap(tx - 1, ty, 2)
    if tv ~= -1 and WAR.Person[tv]["�ҷ�"] ~= wofang then
      tnum = 999
    end
    tv = GetWarMap(tx, ty + 1, 2)
    if tv ~= -1 and WAR.Person[tv]["�ҷ�"] ~= wofang then
      tnum = 999
    end
    tv = GetWarMap(tx, ty - 1, 2)
    if tv ~= -1 and WAR.Person[tv]["�ҷ�"] ~= wofang then
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
--�ж��Ƿ��ܴ򵽵���
function War_GetCanFightEnemyXY()
  local num, x, y = nil, nil, nil
  num, x, y = War_realjl(WAR.CurID)
  if num == -1 then
    return 
  end
  return x, y
end--�ƶ�
function War_MoveMenu()
  if WAR.Person[WAR.CurID]["������"] ~= -1 then
    WAR.ShowHead = 0
    if WAR.Person[WAR.CurID]["�ƶ�����"] <= 0 then
      return 0
    end
    War_CalMoveStep(WAR.CurID, WAR.Person[WAR.CurID]["�ƶ�����"], 0)
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
      if WAR.Person[i]["�ҷ�"] ~= WAR.Person[WAR.CurID]["�ҷ�"] and WAR.Person[i]["����"] == false then
        ydd[n] = i
        n = n + 1
      end
    end
    local dx = ydd[math.random(n - 1)]
    local DX = WAR.Person[dx]["����X"]
    local DY = WAR.Person[dx]["����Y"]
    local YDX = {DX + 1, DX - 1, DX}
    local YDY = {DY + 1, DY - 1, DY}
    local ZX = YDX[math.random(3)]
    local ZY = YDY[math.random(3)]
    if not SceneCanPass(ZX, ZY) or GetWarMap(ZX, ZY, 2) < 0 then
      SetWarMap(WAR.Person[WAR.CurID]["����X"], WAR.Person[WAR.CurID]["����Y"], 2, -1)
      SetWarMap(WAR.Person[WAR.CurID]["����X"], WAR.Person[WAR.CurID]["����Y"], 5, -1)
      WAR.Person[WAR.CurID]["����X"] = ZX
      WAR.Person[WAR.CurID]["����Y"] = ZY
      SetWarMap(WAR.Person[WAR.CurID]["����X"], WAR.Person[WAR.CurID]["����Y"], 2, WAR.CurID)
      SetWarMap(WAR.Person[WAR.CurID]["����X"], WAR.Person[WAR.CurID]["����Y"], 5, WAR.Person[WAR.CurID]["��ͼ"])
    end
  end
  return 1
end--�����ƶ�
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
  if WAR.Person[WAR.CurID]["�ƶ�����"] < movenum then
    movenum = WAR.Person[WAR.CurID]["�ƶ�����"]
    WAR.Person[WAR.CurID]["�ƶ�����"] = 0
  else
    WAR.Person[WAR.CurID]["�ƶ�����"] = WAR.Person[WAR.CurID]["�ƶ�����"] - movenum
  end
  for i = 1, movenum do
    local t1 = lib.GetTime()
    SetWarMap(WAR.Person[WAR.CurID]["����X"], WAR.Person[WAR.CurID]["����Y"], 2, -1)
    SetWarMap(WAR.Person[WAR.CurID]["����X"], WAR.Person[WAR.CurID]["����Y"], 5, -1)
    WAR.Person[WAR.CurID]["����X"] = movetable[i].x
    WAR.Person[WAR.CurID]["����Y"] = movetable[i].y
    WAR.Person[WAR.CurID]["�˷���"] = movetable[i].direct
    WAR.Person[WAR.CurID]["��ͼ"] = WarCalPersonPic(WAR.CurID)
    SetWarMap(WAR.Person[WAR.CurID]["����X"], WAR.Person[WAR.CurID]["����Y"], 2, WAR.CurID)
    SetWarMap(WAR.Person[WAR.CurID]["����X"], WAR.Person[WAR.CurID]["����Y"], 5, WAR.Person[WAR.CurID]["��ͼ"])
    WarDrawMap(0)
    ShowScreen()
    local t2 = lib.GetTime()
    if i < movenum and t2 - t1 < 2 * CC.Frame then
      lib.Delay(2 * CC.Frame - (t2 - t1))
    end
  end
end
---�ö��˵�
function War_PoisonMenu()
  WAR.ShowHead = 0
  local r = War_ExecuteMenu(1)
  WAR.ShowHead = 1
  Cls()
  return r
end
--ս����Ϣ
function War_RestMenu()
	if WAR.CurID and WAR.CurID >= 0  then
	  local pid = WAR.Person[WAR.CurID]["������"]
	  if WAR.tmp[1000 + pid] == 1 then
	    return 1
	  end
	  local vv = math.modf(JY.Person[pid]["����"] / 100 - JY.Person[pid]["���˳̶�"] / 50 - JY.Person[pid]["�ж��̶�"] / 50) + 2
	  if WAR.Person[WAR.CurID]["�ƶ�����"] > 0 then
	    vv = vv + 2
	  end
	  if inteam(pid) then
	    vv = vv + math.random(3)
	  else
	    vv = vv + 6
	  end
	  vv = (vv) / 120
	  local v = 3 + Rnd(3)
	  AddPersonAttrib(pid, "����", v)
	  if JY.Person[pid]["����"] > 0 then
	    v = 3 + math.modf(JY.Person[pid]["�������ֵ"] * (vv))
	    AddPersonAttrib(pid, "����", v)
	    v = 3 + math.modf(JY.Person[pid]["�������ֵ"] * (vv))
	    AddPersonAttrib(pid, "����", v)
	  end
	  
	  --���Ѷȣ�������Ϣ���Զ�����
	  if JY.Thing[202][WZ7] > 1 and not inteam(pid) then
	    if math.modf(JY.Person[pid]["�������ֵ"] / 2) < JY.Person[pid]["����"] then
	      return War_ActupMenu()
	    else
	      return War_DefupMenu()
	    end
	  else
	    return 1
	  end
	end
end--ս���鿴״̬
function War_StatusMenu()
  WAR.ShowHead = 0
  Menu_Status()
  WAR.ShowHead = 1
  Cls()
end

--ս����Ʒ�˵�
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
    local id = JY.Base["��Ʒ" .. i + 1]
    if id >= 0 and (JY.Thing[id]["����"] == 3 or JY.Thing[id]["����"] == 4) then
      thing[num] = id
      thingnum[num] = JY.Base["��Ʒ����" .. i + 1]
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

--�Զ�ս���ж��Ƿ���ҽ��
function War_ThinkDoctor()
  local pid = WAR.Person[WAR.CurID]["������"]
  if JY.Person[pid]["����"] < 50 or JY.Person[pid]["ҽ������"] < 20 then
    return -1
  end
  if JY.Person[pid]["ҽ������"] + 20 < JY.Person[pid]["���˳̶�"] then
    return -1
  end
  local rate = -1
  local v = JY.Person[pid]["�������ֵ"] - JY.Person[pid]["����"]
  if JY.Person[pid]["ҽ������"] < v / 4 then
    rate = 30
  elseif JY.Person[pid]["ҽ������"] < v / 3 then
      rate = 50
  elseif JY.Person[pid]["ҽ������"] < v / 2 then
      rate = 70
  else
    rate = 90
  end
  if Rnd(100) < rate then
    return 5
  end
  return -1
end--�ܷ��ҩ���Ӳ���
--flag=2 ������3������4����  6 �ⶾ
function War_ThinkDrug(flag)
  local pid = WAR.Person[WAR.CurID]["������"]
  local str = nil
  local r = -1
  if flag == 2 then
    str = "������"
  elseif flag == 3 then
    str = "������"
  elseif flag == 4 then
    str = "������"
  elseif flag == 6 then
    str = "���ж��ⶾ"
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
  
  --�����Ƿ���ҩƷ
  if inteam(pid) and WAR.Person[WAR.CurID]["�ҷ�"] == true then
    for i = 1, CC.MyThingNum do
      local thingid = JY.Base["��Ʒ" .. i]
      if thingid >= 0 and JY.Thing[thingid]["����"] == 3 and Get_Add(thingid) > 0 then
        r = flag
        break;
      end
    end
  else
    for i = 1, 4 do
      local thingid = JY.Person[pid]["Я����Ʒ" .. i]
      if thingid >= 0 and JY.Thing[thingid]["����"] == 3 and Get_Add(thingid) > 0 then
        r = flag
        break;
      end
    end
  end
  return r
end--ʹ�ð���
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
--����ս����ͼ
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
--����������ͼ
function WarSetPerson()
  CleanWarMap(2, -1)
  CleanWarMap(5, -1)
  for i = 0, WAR.PersonNum - 1 do
    if WAR.Person[i]["����"] == false then
      SetWarMap(WAR.Person[i]["����X"], WAR.Person[i]["����Y"], 2, i)
      SetWarMap(WAR.Person[i]["����X"], WAR.Person[i]["����Y"], 5, WAR.Person[i]["��ͼ"])
    end
  end
end


--��ʾ�书�������������˶�������Ч��
function War_ShowFight(pid, wugong, wugongtype, level, x, y, eft, ZHEN_ID)
  if not ZHEN_ID then
    ZHEN_ID = -1
  end
  
  if wugongtype > 4 then
		wugongtype = math.random(4);
	end
  
  local x0 = WAR.Person[WAR.CurID]["����X"]
  local y0 = WAR.Person[WAR.CurID]["����Y"]
  
  --����壬ɨ����ɮ  �������
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
	
	--���Զ���
	--eft = 110;
	
	if pid == 0 and GetS(53, 0, 4, 5) == 1 and JLSD(0,30,pid)  then
		eft = 110;
	end
	
	--ָ��XY����ôֻ��ʾ��һ������ʾ����
	if eft == 110 then
		ex, ey = x, y;
	end
	

	
	--����EFT
	if WAR.EFT[eft] == nil then
		lib.PicLoadFile(string.format(CC.EffectFile[1],eft), string.format(CC.EffectFile[2],eft), 70+WAR.EFTNUM);
		WAR.EFT[eft] = 70+WAR.EFTNUM;
		WAR.EFTNUM = WAR.EFTNUM + 1;
		if WAR.EFTNUM > 20 then
			WAR.EFTNUM = 0;
		end
	end
	
	if WAR.Person[WAR.CurID]["��Ч����"] ~= -1 then
		local txdh = WAR.Person[WAR.CurID]["��Ч����"];
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
  
  --�ϻ�����
  local ZHEN_pid, ZHEN_type, ZHEN_startframe, ZHEN_fightframe = nil, nil, nil, nil
  if ZHEN_ID >= 0 then
    ZHEN_pid = WAR.Person[ZHEN_ID]["������"]
    ZHEN_type = wugongtype
    ZHEN_startframe = 0
    ZHEN_fightframe = 0
  end
  
  local fightdelay, fightframe, sounddelay = nil, nil, nil
  if wugongtype >= 0 then
    fightdelay = JY.Person[pid]["���ж����ӳ�" .. wugongtype + 1]
    fightframe = JY.Person[pid]["���ж���֡��" .. wugongtype + 1]
    sounddelay = JY.Person[pid]["�书��Ч�ӳ�" .. wugongtype + 1]
  else
    fightdelay = 0
    fightframe = -1
    sounddelay = -1
  end
  
  if fightdelay == 0 or fightframe == 0 then
    for i = 1, 5 do
      if JY.Person[pid]["���ж���֡��" .. i] ~= 0 then
        fightdelay = JY.Person[pid]["���ж����ӳ�" .. i]
        fightframe = JY.Person[pid]["���ж���֡��" .. i]
        sounddelay = JY.Person[pid]["�书��Ч�ӳ�" .. i]
        wugongtype = i - 1
      end
    end
  end
  
  if ZHEN_ID >= 0 then
    if JY.Person[ZHEN_pid]["���ж���֡��" .. ZHEN_type + 1] == 0 then
      for i = 1, 5 do
        if JY.Person[ZHEN_pid]["���ж���֡��" .. i] ~= 0 then
          ZHEN_type = i - 1
          ZHEN_fightframe = JY.Person[ZHEN_pid]["���ж���֡��" .. i]
        end
      end
    else
    	ZHEN_fightframe = JY.Person[ZHEN_pid]["���ж���֡��" .. ZHEN_type + 1]
    end
  end
  
  
  local framenum = fightdelay + CC.Effect[eft]
  local startframe = 0
  if wugongtype >= 0 then
    for i = 0, wugongtype - 1 do
      startframe = startframe + 4 * JY.Person[pid]["���ж���֡��" .. i + 1]
    end
  end
  if ZHEN_ID >= 0 and ZHEN_type >= 0 then
    for i = 0, ZHEN_type - 1 do
      ZHEN_startframe = ZHEN_startframe + 4 * JY.Person[ZHEN_pid]["���ж���֡��" .. i + 1]
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

  WAR.Person[WAR.CurID]["��ͼ����"] = 0
  WAR.Person[WAR.CurID]["��ͼ"] = WarCalPersonPic(WAR.CurID)
  if ZHEN_ID >= 0 then
    WAR.Person[ZHEN_ID]["��ͼ����"] = 0
    WAR.Person[ZHEN_ID]["��ͼ"] = WarCalPersonPic(ZHEN_ID)
  end  
  
  
  local oldpic = WAR.Person[WAR.CurID]["��ͼ"] / 2		--��ǰ��ͼ��λ��
  local oldpic_type = 0
  local oldeft = -1
  local kfname = JY.Wugong[wugong]["����"]
  local showsize = CC.FontBig
  local showx = CC.ScreenW / 2 - showsize * string.len(kfname) / 4
  local hb = GetS(JY.SubScene, x0, y0, 4)

  
  --��ʾ�书���ŵ���Ч����0
  if wugong ~= 0 then
    if WAR.LHQ_BNZ == 1 then     --������
      kfname = "������"
    end
    if WAR.JGZ_DMZ == 1 then     --��Ħ��
      kfname = "��Ħ��"
    end
  end
  
  if ZHEN_ID >= 0 then          --�ϻ�
  	kfname = "˫�˺ϻ���"..kfname
  end
  
  --��Ч����0���书������ʾ
	if wugong > 0 then				--ʹ���书ʱ����ʾ
	  for i=5, 10 do
		  if WAR.Person[WAR.CurID]["��Ч����0"] ~= nil then
		  	local n, strs = Split(WAR.Person[WAR.CurID]["��Ч����0"], "��");
		  	local len = string.len(WAR.Person[WAR.CurID]["��Ч����0"]);
		  	local color = RGB(255,40,10);
		  	local off = 0;
		  	for j=1, n do
		  		if strs[j] == "����" then
		  			color = M_DeepSkyBlue;
		  		elseif strs[j] == "���һ���" then
			  		color = M_DarkOrange
		  		else
		  			color = RGB(255,40,10);
		  		end
		  		if j > 1 then
		  			strs[j] = "��"..strs[j];
		  		end
		  		KungfuString(strs[j], CC.ScreenW / 2 - (n-1)*len*(CC.DefaultFont+i/2)/8 + off, CC.ScreenH / 4  - hb     , color, CC.DefaultFont+i/2, CC.FontName, 0)
		  		off = off + string.len(strs[j])*(CC.DefaultFont+i/2)/4 + (CC.DefaultFont+i/2)*3/2;
		  	end
			end
			--�书��ʾ
			KungfuString(kfname, CC.ScreenW / 2 -#kfname/2, CC.ScreenH / 3 - hb  , C_GOLD, CC.FontBig+i, CC.FontName, 0)
		  ShowScreen()
		  
		  lib.Delay(2)
		  if i == 10 then
			  lib.Delay(300)
		  end
		  Cls()
		end
	end
  
  --��ʾ��������
  for i = 0, framenum - 1 do
    local tstart = lib.GetTime()
    local mytype = nil
    if fightframe > 0 then
      WAR.Person[WAR.CurID]["��ͼ����"] = 1
      mytype = 4 + WAR.CurID
      if i < fightframe then
        WAR.Person[WAR.CurID]["��ͼ"] = (startframe + WAR.Person[WAR.CurID]["�˷���"] * fightframe + i) * 2
      end
    else
      WAR.Person[WAR.CurID]["��ͼ����"] = 0
      WAR.Person[WAR.CurID]["��ͼ"] = WarCalPersonPic(WAR.CurID)
      mytype = 0
    end
    
    if ZHEN_ID >= 0 then
      if ZHEN_fightframe > 0 then
        WAR.Person[ZHEN_ID]["��ͼ����"] = 1
        if i < ZHEN_fightframe and i < framenum - 1 then
          WAR.Person[ZHEN_ID]["��ͼ"] = (ZHEN_startframe + WAR.Person[ZHEN_ID]["�˷���"] * ZHEN_fightframe + i) * 2
        else
          WAR.Person[ZHEN_ID]["��ͼ"] = WarCalPersonPic(ZHEN_ID)
        end
      else
        WAR.Person[ZHEN_ID]["��ͼ����"] = 0
        WAR.Person[ZHEN_ID]["��ͼ"] = WarCalPersonPic(ZHEN_ID)
      end
      SetWarMap(WAR.Person[ZHEN_ID]["����X"], WAR.Person[ZHEN_ID]["����Y"], 5, WAR.Person[ZHEN_ID]["��ͼ"])
    end
    
    if i == sounddelay then
      PlayWavAtk(JY.Wugong[wugong]["������Ч"])		--
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
    
    local pic = WAR.Person[WAR.CurID]["��ͼ"] / 2
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
  		
      if i == 1 and WAR.Person[WAR.CurID]["��Ч����"] ~= -1 then
        local theeft = WAR.Person[WAR.CurID]["��Ч����"]
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
          
          if WAR.Person[WAR.CurID]["��Ч����1"] ~= nil then
            KungfuString(WAR.Person[WAR.CurID]["��Ч����1"], CC.ScreenW / 2, CC.ScreenH / 2 - hb, C_RED, CC.Fontsmall, CC.FontName, 3)
          end
          if WAR.Person[WAR.CurID]["��Ч����2"] ~= nil then
            KungfuString(WAR.Person[WAR.CurID]["��Ч����2"], CC.ScreenW / 2, CC.ScreenH / 2 - hb, C_GOLD, CC.Fontsmall, CC.FontName, 2)
          end
          if WAR.Person[WAR.CurID]["��Ч����3"] ~= nil then
            KungfuString(WAR.Person[WAR.CurID]["��Ч����3"], CC.ScreenW / 2, CC.ScreenH / 2 - hb, C_WHITE, CC.Fontsmall, CC.FontName, 1)
          end
          ShowScreen()
          lib.Delay(30)
          lib.LoadSur(ssid, CC.ScreenW/2 - 5 * CC.XScale, CC.ScreenH/2 - hb - 18 * CC.YScale)
		  
        end
        lib.FreeSur(ssid)
        WAR.Person[WAR.CurID]["��Ч����"] = -1
      else
        if WAR.Person[WAR.CurID]["��Ч����1"] ~= nil or WAR.Person[WAR.CurID]["��Ч����2"] ~= nil or WAR.Person[WAR.CurID]["��Ч����3"] ~= nil then
          KungfuString(WAR.Person[WAR.CurID]["��Ч����1"], CC.ScreenW / 2, CC.ScreenH / 2 - hb, C_RED, CC.Fontsmall, CC.FontName, 3)
          KungfuString(WAR.Person[WAR.CurID]["��Ч����2"], CC.ScreenW / 2, CC.ScreenH / 2 - hb, C_GOLD, CC.Fontsmall, CC.FontName, 2)
          KungfuString(WAR.Person[WAR.CurID]["��Ч����3"], CC.ScreenW / 2, CC.ScreenH / 2 - hb, C_WHITE, CC.Fontsmall, CC.FontName, 1)
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
  WAR.Person[WAR.CurID]["��ͼ����"] = 0
  WAR.Person[WAR.CurID]["��ͼ"] = WarCalPersonPic(WAR.CurID)
  
  --��ʦ��������ʾ�ı���ͼλ��
  if pid == 0 and GetS(53, 0, 2, 5) == 3 then
	  for i = 0, WAR.PersonNum - 1 do
	  	if WAR.tmp[6000+i] ~= nil then
	  		local v = GetWarMap(WAR.Person[i]["����X"], WAR.Person[i]["����Y"], 4);
	  		SetWarMap(WAR.Person[i]["����X"], WAR.Person[i]["����Y"], 4, -1)
	  		WAR.Person[i]["����X"] = WAR.tmp[6000+i][1]
	  		WAR.Person[i]["����Y"] = WAR.tmp[6000+i][2]
	  		SetWarMap(WAR.Person[i]["����X"], WAR.Person[i]["����Y"], 4, v)
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
  
  --���㹥��������
  local HitXY = {}
  local HitXYNum = 0
  local hnum = 10;		--HitXY�ĳ��ȸ���
  for i = 0, WAR.PersonNum - 1 do
    local x1 = WAR.Person[i]["����X"]
    local y1 = WAR.Person[i]["����Y"]
    if WAR.Person[i]["����"] == false and GetWarMap(x1, y1, 4) > 1 then
      SetWarMap(x1, y1, 4, 1)
      --local n = WAR.Person[i]["����"]
      local hp = WAR.Person[i]["��������"];
      local mp = WAR.Person[i]["��������"];
      local tl = WAR.Person[i]["��������"];
      local ed = WAR.Person[i]["�ж�����"];
      local dd = WAR.Person[i]["�ⶾ����"];
      local ns = WAR.Person[i]["���˵���"];
      
      HitXY[HitXYNum] = {x1, y1, nil, nil, nil, nil, nil, nil, nil, nil, nil};		--x, y, ����, ����, ����, ��Ѩ, ��Ѫ, �ж�, �ⶾ, ����

			if hp ~= nil then
	      if hp == 0 then			--��ʾ�ܵ�������
	      	HitXY[HitXYNum][3] = "miss";
	      elseif hp > 0 then
	      	HitXY[HitXYNum][3] = "+"..hp;
	      else
	      	HitXY[HitXYNum][3] = ""..hp;
	      end
	    end
      
      
      if mp ~= nil then			--��ʾ�����仯
      	if mp > 0 then
      		HitXY[HitXYNum][4] = "+"..mp;
      	elseif mp ==  0 then
      		HitXY[HitXYNum][4] = nil;			--�仯Ϊ0ʱ����ʾ
      	else
      		HitXY[HitXYNum][4] = ""..mp;
      	end
      end
      
      if tl ~= nil then			--��ʾ�����仯
      	if tl > 0 then
      		HitXY[HitXYNum][5] = "��+"..tl;
      	elseif tl == 0 then
      		HitXY[HitXYNum][5] = nil;
      	else
      		HitXY[HitXYNum][5] = "��"..tl;
      	end
      end
      
      if WAR.FXXS[WAR.Person[i]["������"]] == 1 then			--��ʾ�Ƿ��Ѩ
       	HitXY[HitXYNum][6] = "��Ѩ";
       	WAR.FXXS[WAR.Person[i]["������"]] = 0
      end
      
      if WAR.LXXS[WAR.Person[i]["������"]] == 1 then		--��ʾ�Ƿ���Ѫ
      	HitXY[HitXYNum][7] = "��Ѫ"
        WAR.LXXS[WAR.Person[i]["������"]] = 0
      end
      
      
      if ed ~= nil then				--��ʾ�ж�
      	if ed == 0 then
      		HitXY[HitXYNum][8] = nil;
      	else
      		HitXY[HitXYNum][8] = ""..ed;
      	end
      end
      
      if dd ~= nil then			--��ʾ�ⶾ
      	if dd  == 0 then
      		HitXY[HitXYNum][9] = nil;
      	else
      		HitXY[HitXYNum][9] = ""..dd;
      	end
      end
      
      if ns ~= nil then		--��ʾ����
      	if ns == 0 then
      		HitXY[HitXYNum][10] = nil;
      	elseif ns > 0 then
      		HitXY[HitXYNum][10] = ns;
      	else
      		--HitXY[HitXYNum][10] = "���ˡ� "
      	end
      end
      
      HitXYNum = HitXYNum + 1
    end
    
    --͵��������ת - -
    if WAR.TD > -1 then
      if WAR.TD == 118 then
        say("������������������͵ż�Ķ�ת���ƣ�û�Ŷ���Ҫ��ö�ת�´ξ͹ԹԸ�ż�����ɣ�", 51)
      else
        instruct_2(WAR.TD, 1)
      end
      WAR.TD = -1
    end
  end
  
  
  local TP = 0
  local TPXS = {}
  for i = 0, WAR.PersonNum - 1 do
    if WAR.Person[i]["��Ч����"] ~= -1 then
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
	  	if WAR.Person[i]["����"] == false  then
	  		local dx = WAR.Person[i]["����X"] - x
	      local dy = WAR.Person[i]["����Y"] - y
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
  --��ʾ��Ч����
  for ii = 1, 20 do
    local yanshi = false
    local yanshi2 = false		--�޶���ʱ���ӳ�
    for i = 0, WAR.PersonNum - 1 do
    	if WAR.Person[i]["����"] == false then
	      local theeft = WAR.Person[i]["��Ч����"]
	      if theeft ~= -1 and ii < CC.Effect[theeft] then
			if WAR.EFT[theeft] == nil then
				lib.PicLoadFile(string.format(CC.EffectFile[1],theeft), string.format(CC.EffectFile[2],theeft), 70+WAR.EFTNUM);
				WAR.EFT[theeft] = 70+WAR.EFTNUM;
				WAR.EFTNUM = WAR.EFTNUM + 1;
				if WAR.EFTNUM > 20 then
					WAR.EFTNUM = 0;
				end
			end
			
	        local dx = WAR.Person[i]["����X"] - x0
	        local dy = WAR.Person[i]["����Y"] - y0
	        local rx = CC.XScale * (dx - dy) + CC.ScreenW / 2
	        local ry = CC.YScale * (dx + dy) + CC.ScreenH / 2
	        
	        local hb = GetS(JY.SubScene, dx + x0, dy + y0, 4)

	        ry = ry - hb
			starteft = ii
			if starteft <= CC.Effect[theeft] then
				lib.PicLoadCache(WAR.EFT[theeft], (starteft) * 2, rx, ry, 2, 192)
			end
	        if ii < TPXS[i] * TP and (TPXS[i] - 1) * TP < ii then	
		        KungfuString(WAR.Person[i]["��Ч����1"], rx, ry, C_WHITE, CC.Fontsmall, CC.FontName, 1)
		        KungfuString(WAR.Person[i]["��Ч����2"], rx, ry, C_GOLD, CC.Fontsmall, CC.FontName, 2)
		        KungfuString(WAR.Person[i]["��Ч����3"], rx, ry, C_RED, CC.Fontsmall, CC.FontName, 3)
		        KungfuString(WAR.Person[i]["��Ч����0"], rx, ry, C_WHITE, CC.Fontsmall, CC.FontName, 4)
		        yanshi = true
	      	end
	      else
	      	--�����壺 �����޶���ʱ����ʾ���ֵ�BUG
	      	if i~= WAR.CurID and theeft == -1 and ((WAR.Person[i]["��Ч����1"] ~= nil and WAR.Person[i]["��Ч����1"] ~= "  ") or (WAR.Person[i]["��Ч����2"] ~= nil and WAR.Person[i]["��Ч����2"] ~= "  ")  or (WAR.Person[i]["��Ч����3"] ~= nil and WAR.Person[i]["��Ч����3"] ~= "  ") ) then
	          local dx = WAR.Person[i]["����X"] - x0
	        	local dy = WAR.Person[i]["����Y"] - y0
	        	local rx = CC.XScale * (dx - dy) + CC.ScreenW / 2
	        	local ry = CC.YScale * (dx + dy) + CC.ScreenH / 2
		        local hb = GetS(JY.SubScene, dx + x0, dy + y0, 4)

		        ry = ry - hb
		        
	          KungfuString(WAR.Person[i]["��Ч����1"], rx, ry, C_WHITE, CC.Fontsmall, CC.FontName, 1)
		        KungfuString(WAR.Person[i]["��Ч����2"], rx, ry, C_GOLD, CC.Fontsmall, CC.FontName, 2)
		        KungfuString(WAR.Person[i]["��Ч����3"], rx, ry, C_RED, CC.Fontsmall, CC.FontName, 3)
		        KungfuString(WAR.Person[i]["��Ч����0"], rx, ry, C_WHITE, CC.Fontsmall, CC.FontName, 4)
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
  
  
  --��ʾ���˵���
  if HitXYNum > 0 then
    local clips = {}
    for i = 0, HitXYNum - 1 do
      local dx = HitXY[i][1] - x0
      local dy = HitXY[i][2] - y0
      local hb = GetS(JY.SubScene, HitXY[i][1], HitXY[i][2], 4)		--����Ч������ս���ĵ��Ĳ�����
      

      
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
    
    local area = (clip.x2 - clip.x1) * (clip.y2 - clip.y1)		--�滭�ķ�Χ
    local surid = lib.SaveSur(minx, miny, maxx, maxy)		--�滭���
    
    --��ʾ����
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
  

  --�������
  for i = 0, HitXYNum - 1 do
    local id = GetWarMap(HitXY[i][1], HitXY[i][2], 2);
    WAR.Person[id]["��������"] = nil;
    WAR.Person[id]["��������"] = nil;
    WAR.Person[id]["��������"] = nil;
    WAR.Person[id]["�ж�����"] = nil;
    WAR.Person[id]["�ⶾ����"] = nil;
    WAR.Person[id]["���˵���"] = nil;
  end
  
  --�����Ч����
  for i = 0, WAR.PersonNum - 1 do
    WAR.Person[i]["��Ч����"] = -1
    WAR.Person[i]["��Ч����0"] = nil
    WAR.Person[i]["��Ч����1"] = nil
    WAR.Person[i]["��Ч����2"] = nil
    WAR.Person[i]["��Ч����3"] = nil

  end
  lib.SetClip(0, 0, 0, 0)
  WarDrawMap(0)
  ShowScreen()
end


---ִ��ҽ�ƣ��ⶾ�ö��������Ӻ������Զ�ҽ��Ҳ�ɵ���
function War_ExecuteMenu_Sub(x1, y1, flag, thingid)
  local pid = WAR.Person[WAR.CurID]["������"]
  local x0 = WAR.Person[WAR.CurID]["����X"]
  local y0 = WAR.Person[WAR.CurID]["����Y"]
  CleanWarMap(4, 0)
  WAR.Person[WAR.CurID]["�˷���"] = War_Direct(x0, y0, x1, y1)
  SetWarMap(x1, y1, 4, 1)
  local emeny = GetWarMap(x1, y1, 2)
  if emeny >= 0 then
	  if flag == 1 and WAR.Person[WAR.CurID]["�ҷ�"] ~= WAR.Person[emeny]["�ҷ�"] then
	    WAR.Person[emeny]["�ж�����"] = War_PoisonHurt(pid, WAR.Person[emeny]["������"])
	    SetWarMap(x1, y1, 4, 5)
	    WAR.Effect = 5
	  elseif flag == 2 and WAR.Person[WAR.CurID]["�ҷ�"] == WAR.Person[emeny]["�ҷ�"] then
	    WAR.Person[emeny]["�ⶾ����"] = ExecDecPoison(pid, WAR.Person[emeny]["������"])
	    SetWarMap(x1, y1, 4, 6)
	    WAR.Effect = 6
	  elseif flag == 3 then
	    if WAR.Person[WAR.CurID]["������"] == 0 and GetS(4, 5, 5, 5) == 7 then
	      
	    elseif WAR.Person[WAR.CurID]["�ҷ�"] == WAR.Person[emeny]["�ҷ�"] then
	      WAR.Person[emeny]["��������"] = ExecDoctor(pid, WAR.Person[emeny]["������"])
	      SetWarMap(x1, y1, 4, 4)
	      WAR.Effect = 4
	    end
	  elseif flag == 4 and WAR.Person[WAR.CurID]["�ҷ�"] ~= WAR.Person[emeny]["�ҷ�"] then
	    WAR.Person[emeny]["��������"] = War_AnqiHurt(pid, WAR.Person[emeny]["������"], thingid)
	    SetWarMap(x1, y1, 4, 2)
	    WAR.Effect = 2
	  end
  end
  --����ҽ������ҽ��
  if flag == 3 and WAR.Person[WAR.CurID]["������"] == 0 and GetS(4, 5, 5, 5) == 7 then
    for ex = x1 - 3, x1 + 3 do
      for ey = y1 - 3, y1 + 3 do
        SetWarMap(ex, ey, 4, 1)
        if GetWarMap(ex, ey, 2) ~= nil and GetWarMap(ex, ey, 2) > -1 then
          local ep = GetWarMap(ex, ey, 2)
          if WAR.Person[WAR.CurID]["�ҷ�"] == WAR.Person[ep]["�ҷ�"] then
	          WAR.Person[ep]["��������"] = ExecDoctor(pid, WAR.Person[ep]["������"])
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
    War_ShowFight(pid, 0, -1, 0, x1, y1, JY.Thing[thingid]["�����������"])
  end
  for i = 0, WAR.PersonNum - 1 do
    WAR.Person[i]["����"] = 0
  end
  if flag == 4 then
    if emeny >= 0 then
      instruct_32(thingid, -1)
      return 1
    else
      return 0
    end
  else
    WAR.Person[WAR.CurID]["����"] = WAR.Person[WAR.CurID]["����"] + 1
    AddPersonAttrib(pid, "����", -2)
  end
  
  if inteam(pid) then
    AddPersonAttrib(pid, "����", -4)
  end
  return 1
end

--�滭��̬������
function DrawTimeBar2()
   local x1, x2, y =  CC.ScreenW * 5 / 8, CC.ScreenW * 7 / 8, CC.ScreenH/10
  local draw = false
  --�������ǹ̶��ģ�ֻ��Ҫ����һ�ξͿ�����
  DrawBox_1(x1 - 3, y, x2 + 3, y + 3, C_ORANGE)
  DrawBox_1(x1 - (x2 - x1) / 2, y, x1 - 3, y + 3, C_RED)
  DrawString(x2 + 10, y - 23, "ʱ��", C_WHITE, CC.FontSmall)
   local surid = lib.SaveSur(x1 - (10 + (x2 - x1) / 2), 0, x2 + 10 + 20 + 30, y * 2 + 18 + 25)
  
  while true do
  	draw = false
	  for i = 0, WAR.PersonNum - 1 do
	  	local pid = WAR.Person[i]["������"];
	    if WAR.Person[i]["����"] == false then
	    	if WAR.Person[i].TimeAdd < 0 then
		      draw = true
		      WAR.Person[i].TimeAdd = WAR.Person[i].TimeAdd + 20
		      if WAR.Person[i].TimeAdd > 0 then
		      	WAR.Person[i].TimeAdd = 0;
		      end
		      if WAR.Person[i].Time > -500 then
		        WAR.Person[i].Time = WAR.Person[i].Time - 20
			    else
			      if JY.Person[pid]["���˳̶�"] < 100 then
			        if inteam(pid) then
			        	AddPersonAttrib(pid, "���˳̶�", Rnd(4) + 2)		--�ҷ���������ʱ�ܵ�������
			        else
			        	AddPersonAttrib(pid, "���˳̶�", Rnd(3) + 1)		--�з�����
			        end     
			      end
			    end	
				  if WAR.Person[i].Time < -200 and PersonKF(pid, 100) then	--�������칦�󣬵�������ɱ��-200������ֱ����0
				     JY.Person[pid]["���˳̶�"] = 0;	
				  end
			  --�����壺���ӱ����з��Ӽ����滭
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

--���Ƽ�����
function DrawTimeBar()
	
  local x1,x2,y = CC.ScreenW * 5 / 8, CC.ScreenW * 7 / 8, CC.ScreenH/10
  local xunhuan = true
  
  --�������ǹ̶��ģ�ֻ��Ҫ����һ�ξͿ�����
  DrawBox_1(x1 - 3, y, x2 + 3, y + 3, C_ORANGE)
  DrawBox_1(x1 - (x2 - x1) / 2, y, x1 - 3, y + 3, C_RED)
  DrawString(x2 + 10, y - 23, "ʱ��", C_WHITE, CC.FontSmall)
  
	lib.SetClip(x1 - (x2-x1)/2, 0, CC.ScreenW, CC.ScreenH/4)
	local surid = lib.SaveSur( x1 - (x2-x1)/2, 0, CC.ScreenW, CC.ScreenH/4)
  while xunhuan do
    for i = 0, WAR.PersonNum - 1 do
      if WAR.Person[i]["����"] == false then
      	local jqid = WAR.Person[i]["������"]
        if WAR.FXDS[WAR.Person[i]["������"]] == nil then
        	--���ûѧ���ˣ���������
          if PersonKF(jqid, 104) == false then
            WAR.Person[i].Time = WAR.Person[i].Time + WAR.Person[i].TimeAdd
            if WAR.LQZ[jqid] == 100 then
              WAR.Person[i].Time = WAR.Person[i].Time + WAR.Person[i].TimeAdd
            end
          else
          	--���ûѧ��������������
            if PersonKF(jqid, 107) == false then
            
            	local jq = 0;
            	--�����壺���˼����ٶȱ仯
            	if WAR.L_NYZH[WAR.Person[i]["������"]] == nil then
	            	jq = math.random(WAR.Person[i].TimeAdd) + 1
	            	
	            	WAR.Person[i].Time = WAR.Person[i].Time + jq
	          
	            	
	            elseif WAR.L_NYZH[WAR.Person[i]["������"]] == 1 then		--�������߻����仯
	            	jq = math.random(math.floor(WAR.Person[i].TimeAdd/3),WAR.Person[i].TimeAdd*2)
	            	WAR.Person[i].Time = WAR.Person[i].Time + jq
	            end
	            
	            --����״̬�¶���ļ����ӳɣ������ж�
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
		         
            
	            if JY.Person[WAR.Person[i]["������"]]["����"] < 20 then
	              WAR.tmp[1000 + jqid] = nil
	            end
	          else		--���ѧ�˾�������������
	          	
	            WAR.Person[i].Time = WAR.Person[i].Time + WAR.Person[i].TimeAdd  
	            if WAR.LQZ[jqid] == 100 then
	              WAR.Person[i].Time = WAR.Person[i].Time + WAR.Person[i].TimeAdd
	            end
	          end
	        end
        else
          WAR.FXDS[WAR.Person[i]["������"]] = WAR.FXDS[WAR.Person[i]["������"]] - 1
          
          --�׽ ��Ѩ�ظ��ӱ�
          if PersonKF(jqid, 108) then
            WAR.FXDS[jqid] = WAR.FXDS[jqid] - 1
          end
          
          --brolycjw: ����5ʱ������Ѩ
					if PersonKF(jqid, 106) and (JY.Person[jqid]["��������"] == 1 or (jqid == JY.MY and GetS(4, 5, 5, 5) == 5)) then
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
          if WAR.FXDS[WAR.Person[i]["������"]] < 1 then
          	WAR.FXDS[WAR.Person[i]["������"]] = nil
					end
        end  
        
        --�����񹦻���
        if PersonKF(jqid, 106) and (JY.Person[jqid]["��������"] == 1 or (jqid == 0 and GetS(4, 5, 5, 5) == 5)) then
          JY.Person[jqid]["����"] = JY.Person[jqid]["����"] + 6 + math.random(2)
        end
        
        --�����񹦻�Ѫ
        if PersonKF(jqid, 107) and (JY.Person[jqid]["��������"] == 0 or (jqid == 0 and GetS(4, 5, 5, 5) == 5)) then
          JY.Person[jqid]["����"] = JY.Person[jqid]["����"] + 2
        end
		
				--brolycjw: ���칦��Ѫ����
        if PersonKF(jqid, 100) then
          JY.Person[jqid]["����"] = JY.Person[jqid]["����"] + 2 + math.random(1)
          JY.Person[jqid]["����"] = JY.Person[jqid]["����"] + 1
        end
          
        if WAR.LXZT[jqid] ~= nil then
          if inteam(jqid) then
            JY.Person[jqid]["����"] = JY.Person[jqid]["����"] - math.random(3) - math.modf(JY.Person[jqid]["���˳̶�"] / 15)
          else
            JY.Person[jqid]["����"] = JY.Person[jqid]["����"] - 1 - math.modf(JY.Person[jqid]["���˳̶�"] / 51)
          end
          if JY.Person[jqid]["����"] < 1 then
            JY.Person[jqid]["����"] = 1
          end
          WAR.LXZT[jqid] = WAR.LXZT[jqid] - 1
          if PersonKF(jqid, 108) then	--brolycjw: �׽����Ѫ
            WAR.LXZT[jqid] = WAR.LXZT[jqid] - 1
          end
          if WAR.LXZT[jqid] < 1 then
          	WAR.LXZT[jqid] = nil
        	end
        end
        
        --brolycjw: �׽,������ �ظ�����
        if (JY.Person[jqid]["���˳̶�"] > 0 and PersonKF(jqid, 108)) or (JY.Person[jqid]["���˳̶�"] > 25 and PersonKF(jqid, 106)) or (JY.Person[jqid]["���˳̶�"] > 50 and PersonKF(jqid, 107)) then
	        if JY.Person[jqid]["���˳̶�"] > 70 and math.random(100)>60 then
						JY.Person[jqid]["���˳̶�"] = JY.Person[jqid]["���˳̶�"] - 1
	        elseif JY.Person[jqid]["���˳̶�"] > 40 and math.random(100)>30 then
						JY.Person[jqid]["���˳̶�"] = JY.Person[jqid]["���˳̶�"] - 1
	        else
						JY.Person[jqid]["���˳̶�"] = JY.Person[jqid]["���˳̶�"] - 1
					end
				end


				--����  �ظ��ж�
        if JY.Person[jqid]["�ж��̶�"] > 0 and PersonKF(jqid, 99)  then
        	if JY.Person[jqid]["�ж��̶�"] > 70 and math.random(100)>60 then
          	JY.Person[jqid]["�ж��̶�"] = JY.Person[jqid]["�ж��̶�"] - 1
          elseif JY.Person[jqid]["�ж��̶�"] > 40 and math.random(100)>60 then
          	JY.Person[jqid]["�ж��̶�"] = JY.Person[jqid]["�ж��̶�"] - 1
          else
          	JY.Person[jqid]["�ж��̶�"] = JY.Person[jqid]["�ж��̶�"] - 1
          end
        end
				
				
				--�����壺���� �������վ����裬ʱ���Ѫ�����ڡ������ˡ����
				if jqid == 37 and GetS(86, 8, 10, 5) == 2 then
					--ʱ���嶾
					if JY.Person[jqid]["�ж��̶�"] > 70 and math.random(100)>60 then
          	JY.Person[jqid]["�ж��̶�"] = JY.Person[jqid]["�ж��̶�"] - 1
          elseif JY.Person[jqid]["�ж��̶�"] > 40 and math.random(100)>30 then
          	JY.Person[jqid]["�ж��̶�"] = JY.Person[jqid]["�ж��̶�"] - 1
          else
          	JY.Person[jqid]["�ж��̶�"] = JY.Person[jqid]["�ж��̶�"] - 1
          end
          
          --ʱ�������
          if JY.Person[jqid]["���˳̶�"] > 70 and math.random(100)>60 then
	          JY.Person[jqid]["���˳̶�"] = JY.Person[jqid]["���˳̶�"] - 1
	        elseif JY.Person[jqid]["���˳̶�"] > 40 and math.random(100)>30 then
	          JY.Person[jqid]["���˳̶�"] = JY.Person[jqid]["���˳̶�"] - 1
	        else
	        	JY.Person[jqid]["���˳̶�"] = JY.Person[jqid]["���˳̶�"] - 1
					end
					
					--ʱ�����
					JY.Person[jqid]["����"] = JY.Person[jqid]["����"] + 3 + math.random(2)
					
					--ʱ���Ѫ
					JY.Person[jqid]["����"] = JY.Person[jqid]["����"] + 1 + math.random(1)
				end
				
				--�����壺�ٻ�ֵ�ظ�
				if WAR.CHZ[jqid] ~= nil then
					WAR.CHZ[jqid] = WAR.CHZ[jqid] - 1;
					if WAR.CHZ[jqid] < 1 then
						WAR.CHZ[jqid] = nil;
					end
				end

        
        --�����壺���ѹ�ָ���ʱ���ж������ٷֱȼ�Ѫ
	      if WAR.L_WNGZL[jqid] ~= nil and WAR.L_WNGZL[jqid] > 0 then
	      	
	      	JY.Person[jqid]["�ж��̶�"] = JY.Person[jqid]["�ж��̶�"] + 1
		    	JY.Person[jqid]["����"] = JY.Person[jqid]["����"] - math.modf(JY.Person[jqid]["����"]/120);
		    	WAR.L_WNGZL[jqid] = WAR.L_WNGZL[jqid] -1;
		    	
		    	if WAR.L_WNGZL[jqid] <= 0 then
		    		WAR.L_WNGZL[jqid] = nil;
		    	end
		    end
		    
		    --brolycjw������ţָ���ʱ���Ѫ�����ˣ����ٷֱȻ�Ѫ
	      if WAR.L_HQNZL[jqid] ~= nil and WAR.L_HQNZL[jqid] > 0 then
	      	JY.Person[jqid]["����"] = JY.Person[jqid]["����"] + 1 + math.modf((JY.Person[jqid]["�������ֵ"]-JY.Person[jqid]["����"])/40);
					if JY.Person[jqid]["���˳̶�"] > 50 then
						JY.Person[jqid]["���˳̶�"] = JY.Person[jqid]["���˳̶�"] - 2;
					else
						JY.Person[jqid]["���˳̶�"] = JY.Person[jqid]["���˳̶�"] - 1;
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
		
	  --���������а�����Ч
	  local keypress = lib.GetKey()
		if (keypress == VK_SPACE or keypress == VK_RETURN) then
			if WAR.AutoFight == 1 then 
				WAR.AutoFight = 0
			end
	  elseif keypress == VK_ESCAPE then
	    if DrawStrBoxYesNo(-1, -1, "�Ƿ��˳���Ϸ", C_WHITE, CC.DefaultFont) == true then
	      JY.Status = x
	    end
	    Cls()
			lib.SetClip(x1 - (x2-x1)/2, 0, CC.ScreenW, CC.ScreenH/4)
	  end
	  
		lib.LoadSur(surid, x1 - ((x2 - x1) / 2), 0)
  end
  for i = 0, WAR.PersonNum - 1 do
    if WAR.Person[i]["����"] == false then
      WAR.Person[i].TimeAdd = 0
    	local jqid=WAR.Person[i]["������"]
			--����ҽ�������������ˣ����ж�
	    if jqid == JY.MY and GetS(4, 5, 5, 5) == 7 then
	      JY.Person[jqid]["����"] = JY.Person[jqid]["����"]+limitX(WAR.SXTJ/100,0,100) + math.random(10);
	      JY.Person[jqid]["�ж��̶�"] = JY.Person[jqid]["�ж��̶�"] - 5 - math.random(5);
	    end
	    
	    --�ж��Ƿ����������ݷ�Χ֮��
	  	if JY.Person[jqid]["�ж��̶�"] < 0 then
				JY.Person[jqid]["�ж��̶�"] = 0;
			end
			if JY.Person[jqid]["���˳̶�"] < 0 then
				JY.Person[jqid]["���˳̶�"] = 0;
			end
			if JY.Person[jqid]["�������ֵ"] < JY.Person[jqid]["����"] then
	      JY.Person[jqid]["����"] = JY.Person[jqid]["�������ֵ"]
	    end
			if JY.Person[jqid]["�������ֵ"] < JY.Person[jqid]["����"] then
	      JY.Person[jqid]["����"] = JY.Person[jqid]["�������ֵ"]
	    end
  	end
  end
  WAR.ZYHBP = -1
  lib.SetClip(0, 0, 0, 0)
  lib.FreeSur(surid)
end
--�滭���弯����
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
  	DrawString(x2 + 10, y - 23, "ʱ��", C_WHITE, CC.FontSmall)
  end
  

  for i = 0, WAR.PersonNum - 1 do
    if not WAR.Person[i]["����"] then
      local cx = x1 + math.modf(WAR.Person[i].Time*(x2 - x1)/1000)
      local headid = WAR.tmp[5000+i];
      if headid == nil then
      	headid = JY.Person[WAR.Person[i]["������"]]["ͷ�����"]
      end
      local w, h = limitX(CC.ScreenW/25,12,35),limitX(CC.ScreenW/25,12,35)
      if WAR.Person[i]["�ҷ�"] then
				lib.LoadPNG(99, headid*2, cx - w / 2, y - h - 4, 1, 0)
     	else
				lib.LoadPNG(99, headid*2, cx - w / 2, y + 6, 1, 0)
	  	end
    end
	end
	DrawString(x2 + 10, y - 3, WAR.SXTJ, C_GOLD, CC.Fontsmall)
end

--�滭�������ϵ�����
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

--�ж�����֮��ľ���
function RealJL(id1, id2, len)
  if not len then
    len = 1
  end
  local x1, y1 = WAR.Person[id1]["����X"], WAR.Person[id1]["����Y"]
  local x2, y2 = WAR.Person[id2]["����X"], WAR.Person[id2]["����Y"]
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

--�����书��Χ
function refw(wugong, level)
  local m1, m2, a1, a2, a3, a4, a5 = nil, nil, nil, nil, nil, nil, nil
  if JY.Wugong[wugong]["������Χ"] == -1 then
    return JY.Wugong[wugong]["������1"], JY.Wugong[wugong]["������2"], JY.Wugong[wugong]["δ֪1"], JY.Wugong[wugong]["δ֪2"], JY.Wugong[wugong]["δ֪3"], JY.Wugong[wugong]["δ֪4"], JY.Wugong[wugong]["δ֪5"]
  end
  local fightscope = JY.Wugong[wugong]["������Χ"]
  local kfkind = JY.Wugong[wugong]["�书����"]
  local pid = WAR.Person[WAR.CurID]["������"]
  if fightscope == 0 then
    if level > 10 then
      m1 = 1
      m2 = JY.Wugong[wugong]["�ƶ���Χ" .. 10]
      a1 = 1
      a2 = 3
      a3 = 3
    else
      m1 = 0
      m2 = JY.Wugong[wugong]["�ƶ���Χ" .. level]
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
        a2 = JY.Wugong[wugong]["�ƶ���Χ" .. 10] - 1
      else
        m1 = 2
        m2 = 1
        a2 = JY.Wugong[wugong]["�ƶ���Χ" .. level] - 1
      end
    elseif kfkind == 2 then
      a1 = 10
      if level > 10 then
        m1 = 3
        m2 = 1
        a2 = JY.Wugong[wugong]["�ƶ���Χ" .. 10]
        a3 = a2 - 1
        a4 = a3 - 1
      else
        m1 = 2
        m2 = 1
        a2 = JY.Wugong[wugong]["�ƶ���Χ" .. level]
      end
      if level > 7 then
        a3 = a2 - 1
      end
    elseif kfkind == 3 then
      a1 = 11
      if level > 10 then
        m1 = 3
        m2 = 1
        a2 = JY.Wugong[wugong]["�ƶ���Χ" .. 10] - 1
      else
        m1 = 2
        m2 = 1
        a2 = JY.Wugong[wugong]["�ƶ���Χ" .. level] - 1
      end
    elseif kfkind == 4 then
      m1 = 2
      if level > 10 then
        m2 = JY.Wugong[wugong]["�ƶ���Χ" .. 10] - 1
        a1 = 7
        a2 = 1 + math.modf(level / 3)
        a3 = a2
	    else
	      m2 = JY.Wugong[wugong]["�ƶ���Χ" .. level] - 1
	      a1 = 1
	      a2 = 1 + math.modf(level / 3)
	    end
	  else
	  	a1 = 11
      if level > 10 then
        m1 = 3
        m2 = 1
        a2 = JY.Wugong[wugong]["�ƶ���Χ" .. 10] - 1
      else
        m1 = 2
        m2 = 1
        a2 = JY.Wugong[wugong]["�ƶ���Χ" .. level] - 1
      end
	  end
  elseif fightscope == 2 then
    m1 = 0
    m2 = 0
    if kfkind == 3 then
      if level > 10 then
        a1 = 6
        a2 = JY.Wugong[wugong]["�ƶ���Χ" .. 10]
      else
        a1 = 8
        a2 = JY.Wugong[wugong]["�ƶ���Χ" .. level]
      end
    elseif level > 10 then
      if kfkind == 1 then
        a1 = 5
        a2 = JY.Wugong[wugong]["�ƶ���Χ" .. 10] - 1
        a3 = a2 - 3
      elseif kfkind == 2 then
        a1 = 1
        a2 = JY.Wugong[wugong]["�ƶ���Χ" .. 10] - 1
        a3 = a2
      else
        a1 = 2
        a2 = 1 + math.modf(JY.Wugong[wugong]["�ƶ���Χ" .. 10] / 2)
      end
    else
      a1 = 1
      a2 = JY.Wugong[wugong]["�ƶ���Χ" .. level]
      a3 = 0
    end
  elseif fightscope == 3 then
    m1 = 0
    a1 = 3
    if level > 10 then
      m2 = JY.Wugong[wugong]["�ƶ���Χ" .. 10] + 1
      a2 = JY.Wugong[wugong]["ɱ�˷�Χ" .. 10]
      a3 = a2
    else
    	m2 = JY.Wugong[wugong]["�ƶ���Χ" .. level]
    	a2 = JY.Wugong[wugong]["ɱ�˷�Χ" .. level]
    end
  
  end
  return m1, m2, a1, a2, a3, a4, a5
end

--�ж������Ƿ�Ϊ���ѣ������ڲ��ڶ�
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

--�ж������Ƿ���ĳ���书
function PersonKF(p, kf)
  for i = 1, 10 do
	if JY.Person[p]["�书" .. i] <= 0 then
		return false;
    elseif JY.Person[p]["�书" .. i] == kf then
      return true
    end
  end
  return false
end

--�ж������Ƿ���ĳ���书�����ҵȼ�Ϊ��
function PersonKFJ(p, kf)
	for i = 1, 10 do
		if JY.Person[p]["�书" .. i] == -1 then
			return false;
		elseif JY.Person[p]["�书" .. i] == kf and JY.Person[p]["�书�ȼ�" .. i] == 999 then
		  return true
		end
  end
  return false
end

--�жϴ�������
function myrandom(p, pp)
  for i = 0, WAR.PersonNum - 1 do
    local pid = WAR.Person[i]["������"]
    if WAR.Person[i]["����"] == false and pid == 76 and inteam(pp) then
      p = p + 5		--������+5��
    end
  end
  for i = 1, 10 do
    if JY.Person[pp]["�书" .. i] == 102 then
      p = p + (math.modf(JY.Person[pp]["�书�ȼ�" .. i] / 100) + 1)     --̫����+10��
    end
  end
  p = math.modf(p + JY.Person[pp]["�������ֵ"] * 4 / (JY.Person[pp]["����"] + 20) + JY.Person[pp]["����"] / 20)		--����ֵԽ�ͣ�����Խ��

  --ʯ����+20��
  if pp == 38 then
    p = p + 20
  end

  --�ɰ������߻�+40��
  if WAR.tmp[1000 + pp] == 1 then
    p = p + 40
  end

  --��ʵս+20��
  
  local jp = math.modf(GetSZ(pp) / 25 + 1)
  if jp > 20 then
    jp = 20
  end
  p = p + jp
      
  
  --����ֵ���+20��
  p = p + limitX(math.modf(JY.Person[pp]["����"] / 500), 0, 20)


  local times = 1
  if inteam(pp) then
    if JY.Person[pp]["����"] < math.random(120) - 10 then
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


--�Զ�ѡ�����
function War_AutoSelectEnemy()
  local enemyid = War_AutoSelectEnemy_near()
  WAR.Person[WAR.CurID]["�Զ�ѡ�����"] = enemyid
  return enemyid
end

--ѡ���������
function War_AutoSelectEnemy_near()
  War_CalMoveStep(WAR.CurID, 100, 1)			--���ÿ��λ�õĲ���
  local maxDest = math.huge
  local nearid = -1
  for i = 0, WAR.PersonNum - 1 do		--������������ĵ���
    if WAR.Person[WAR.CurID]["�ҷ�"] ~= WAR.Person[i]["�ҷ�"] and WAR.Person[i]["����"] == false then
      local step = GetWarMap(WAR.Person[i]["����X"], WAR.Person[i]["����Y"], 3)
      if step < maxDest then
	      nearid = i
	      maxDest = step
    	end
    end
  end
  return nearid
end

--ս���м���������
function NewWARPersonZJ(id, dw, x, y, life, fx)
  WAR.Person[WAR.PersonNum]["������"] = id
  WAR.Person[WAR.PersonNum]["�ҷ�"] = dw
  WAR.Person[WAR.PersonNum]["����X"] = x
  WAR.Person[WAR.PersonNum]["����Y"] = y
  WAR.Person[WAR.PersonNum]["����"] = life
  WAR.Person[WAR.PersonNum]["�˷���"] = fx
  WAR.Person[WAR.PersonNum]["��ͼ"] = WarCalPersonPic(WAR.PersonNum)
  lib.PicLoadFile(string.format(CC.FightPicFile[1], JY.Person[id]["ͷ�����"]), string.format(CC.FightPicFile[2], JY.Person[id]["ͷ�����"]), 4 + WAR.PersonNum)
  SetWarMap(x, y, 2, WAR.PersonNum)
  SetWarMap(x, y, 5, WAR.Person[WAR.PersonNum]["��ͼ"])
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