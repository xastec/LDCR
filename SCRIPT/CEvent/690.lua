--OEVENTLUA[690] = function()
  local r = JYMsgBox("���ؼҿ���", "���ӣ����������*�����汼����ô�ã�һ���������*��������ʲô��",  { "��Ϣ", "����","���"}, 3, 261)
  if r == 1 then
    instruct_14()
    instruct_12()
    instruct_13()
    instruct_1(2830, 261, 0)
    instruct_0()
  elseif r == 2 then
    LianGong()
  end
--end