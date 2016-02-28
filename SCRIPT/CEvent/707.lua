--OEVENTLUA[707] = function()
  instruct_1(2879, 210, 0)
  local lhq = 0
  if JY.Scene[1]["进入条件"] == 0 then
    for i = 1, 200 do
      if JY.Base["物品" .. i] == 112 then
        lhq = 1
      end
    end
  end
  if lhq == 0 then
    instruct_32(112, 1)
    SetD(28, 11, 2, 0)
  end
--end