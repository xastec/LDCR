--OEVENTLUA[315] = function()
  if instruct_16(9, 2, 0) == false then
    return 
  end
  instruct_0()
  instruct_37(1)
  instruct_1(1111, 9, 1)
  instruct_0()
  instruct_1(1112, 5, 0)
  instruct_0()
  instruct_1(1113, 9, 1)
  instruct_0()
  instruct_1(1114, 5, 0)
  instruct_0()
  instruct_1(1115, 9, 1)
  instruct_0()
  instruct_1(1124, 5, 0)
  instruct_0()
  instruct_2(169, 1)
  instruct_0()
  say("无忌，太师父再传你一套Ｒ太极拳剑Ｗ！看好了！", 5)
  instruct_14()
  instruct_13()
  local tjq = 0
  for a = 1, 10 do
    if JY.Person[9]["武功" .. a] == 16 then
      tjq = 1
    end
  end
  if tjq == 0 then
    JY.Person[9]["武功2"] = 16
    JY.Person[9]["武功等级2"] = 50
  end
  
  for a = 1, 10 do
    if JY.Person[9]["武功" .. a] == 0 then
      JY.Person[9]["武功" .. a] = 46
      JY.Person[9]["武功等级" .. a] = 50
      break;
    end
  end
  instruct_1(1125, 9, 0)
  instruct_0()
  instruct_1(1116, 5, 0)
  instruct_0()
  instruct_3(-2, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
  instruct_3(-2, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
  instruct_3(-2, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
  instruct_3(-2, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
  instruct_3(-2, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
  instruct_3(-2, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
  instruct_0()
--end