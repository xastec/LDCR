--OEVENTLUA[690] = function()
  local name = "����"
  local picid = 238
  local notVirgin = GetS(112,41,41,5);  --�����ظ�����
  local myName = JY.Person[0]["����"];
  local herName = JY.Person[92]["����"];
  local herPicId = 303;

  local condifini = GetD(60,19,2);
  if condifini > 0 then
    return
  end
  if notVirgin == 10 or CC.Alungky_WXNName ~= herName then
    return
  end

  say(name .. "�����Ըа�������õ�����",0,1,myName);
  say("�˼Ҷ��Ѿ���Զ�ˣ�����׷��ѽ��", herPicId, 0, herName);
  say("�Ҿ�����һ����������˽��СѨ���������",0,1,myName);
  say("���������ܲ����ˣ������ð���Ұɣ�",0,1,myName);
  say("��ô���㰡������װ���⣩", herPicId, 0, herName);
  say("��֪�����еģ���ٰ�����������һ�������졣",0,1,myName);
  say("�����ᣬ���˼ҵ��������", herPicId, 0, herName);
  instruct_30(42,21,42,14);  
  say("��ȷ�������", herPicId, 0, herName);
  say("���ţ��������ˣ����ѿ��ӡ�",0,1,myName);
  say("�����¿��ӣ�����ǽ�ߣ�˫�����ҽ��棬�ջ��ޱȣ�", herPicId, 0, herName);
  say(name .. "�����ˣ���Ҫ���ͣ��ܿ죬�ܿ�ռ���㣨�ܲ�����!��",0,1,myName);
  instruct_14()
  instruct_13()
  SetS(60,42,16,2,6376);
  say("�������ǡ��������ǰ��һ�о����ˣ�", picid, 0, name);
  say("�Բ�����ֻ��������һ����������æת�������������Ǽ�����", picid, 0, name);
  say("�㲻���˷����𣿽���Ҳ�����ţ���װ�ջ�ŭ��", herPicId, 0, herName);
  say("(˲������Աߵ�Ь�ӣ�����" .. name ..")", herPicId, 0, herName);
  say("�飡(�������ţ��ε��ڵ�)", picid, 0, name);
  AddPersonAttrib(92,"������",20);
  AddPersonAttrib(92,"��������",30);
  DrawString(CC.ScreenW/2 - 9*CC.DefaultFont,CC.ScreenH/2,herName .. "���������������������ɣ�����",C_GOLD,CC.DefaultFont);
  instruct_14()
  instruct_13()
  say("���㿴�����ε���Ү��", herPicId, 0, herName);
  say("��˵�����ҿ����ˣ�����У�",0,1,myName);
  say(name .. "���ε������Աߣ�", herPicId, 0, herName);
  instruct_30(42,14,42,15);
  say("�����ҵ�" .. name .. "���������Ȼ����",0,1,myName);
  say("���У�Ҫ���ˣ�ֱ�������ҵ�" .. name .. "����",0,1,myName);
  say("��˵���䣬�ѿ��ٽ�"..name .. "�����·��ǹ⣩", herPicId, 0, herName);
  local fuckid = "v2"
  AlungkySaywithPic("���Ըе�С���˾�Ȼ������ร�������Ҫ�����ˣ�˵��ץ��" .. name .. "�����ȣ�", 0, 1, myName, fuckid)
  AlungkySaywithPic("����ͷ���壬һ����һ�߲壬���ž�����..", 0, 1, myName, fuckid)
  AlungkySaywithPic("�ҵ�С������С" .. name .. "�������ڵõ����������������룬"..name.."��ҹ��죩", 0, 1, myName, fuckid)
  for i=1, 10 do
            Alungky_show_pic(fuckid .. "-1")
            Alungky_show_pic(fuckid .. "-2")
  end
  AlungkySaywithPic("�ý�����ʪ����ˬ����Ҫȫ���������棬ȫ��������", 0, 1, myName, fuckid .. "-1");
  AlungkySaywithPic("�����ţ�������ʹ�����ѻ��ԣ������涯���ܴ����Ժ�����", picid, 0, name,fuckid .. "-2");
  AlungkySaywithPic("������С"..name.."�����Һð��㡣��������������Ѩ�������̳�����", 0, 1, myName, fuckid .. "-3");
  AlungkySaywithPic("�š����������������˹�ȥ��", picid, 0, name, fuckid .. "-3");
  instruct_14()
  instruct_13()
  say("�����˾��������ˣ�", herPicId, 0, herName);
  say("�԰������Ҫ����һ��",0,1,myName);
  say("�㿴���㣬�˼ҵ�һ�ξ���ô�����������ɣ�����ʮ���ӡ�", herPicId, 0, herName);
  instruct_14()
  SetS(60,42,16,2,0);
  instruct_13()
  say("�߰ɡ������ú�˯һ��", herPicId, 0, herName);
  instruct_30(42,15,42,22);
  instruct_30(42,22,34,22);
  instruct_30(34,22,34,16);
  instruct_30(34,16,30,16);
  instruct_30(30,16,30,15);
  say("�ƹ�ģ��Ҷ��ŷ����Ǹ���������ס����ʱ��������Ǯ��", herPicId, 0, herName);
  instruct_30(30,16,30,20);
  SetS(60,38,14,2,6376);
  instruct_25(30,20,38,14);
  say("ͷ��ʹ������ô����˯����������ʲô�����벻�����ˣ�����Ҳ��ʹ���ѵ����������ˣ���", picid, 0, name);
  say("�����������������ˡ���ϣ���Ƕ���Ůȥ������ˣ���Ҳ�ö����ˡ�", picid, 0, name);
  instruct_14()
  SetS(60,38,14,2,0);
  instruct_13()
  instruct_25(38,14,30,20);
  SetS(112,41,41,5,10);
  instruct_3(60,31,0,0,0,0,0,0,0,0,0,-2,-2);
--end