--����������¼�
--OEVENTLUA[8651] = function()
		
    MyTalk("����Ҫ�Ұ�æ�ĵط���", 590);
    instruct_0();   --  0(0)::�����(����)

    if instruct_9() then    --  9(9):�Ƿ�Ҫ�����?������ת��:Label0

        if instruct_20(20,0) ==false then    --  20(14):�����Ƿ�����������ת��:Label1
            instruct_10(590);   --  10(A):��������������
            instruct_14();   --  14(E):�������
            instruct_3(-2,-2,0,0,0,0,0,0,0,0,-2,-2,-2);   --  3(3):�޸��¼�����:��ǰ����:��ǰ�����¼����
            instruct_0();   --  0(0)::�����(����)
            instruct_13();   --  13(D):������ʾ����
            do return; end
        end    --:Label1

				MyTalk("��Ķ������������޷����롣", 590);
        instruct_0();   --  0(0)::�����(����)
        do return; end
    end    --:Label0

--end