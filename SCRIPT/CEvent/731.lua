if instruct_29(0,50,999) == false then  --�жϹ������Ƿ��ڷ�Χ֮��
	TalkEx("�����������д��书��", 209, 0)  --�Ի�
	Cls()  --����
	if instruct_5() == false then  --�Ƿ���֮����
		Cls()  --����
		do return end  --�����������¼�

	end
	if WarMain(219, 1) == false then  --ս����ʼ
		Cls()  --����

	end
	Cls()  --����
	instruct_13()  --��������
	do return end  --�����������¼�

end
TalkEx("�����书��ǿ�����²��Ƕ�*�֡�", 200, 0)  --�Ի�
Cls()  --����
do return end  --�����������¼�
TalkEx("�����������д��书��", 209, 0)  --�Ի�
Cls()  --����
if instruct_5() == false then  --�Ƿ���֮����
	Cls()  --����
	do return end  --�����������¼�

end
if WarMain(219, 1) == false then  --ս����ʼ
	Cls()  --����

end
Cls()  --����
instruct_13()  --��������
do return end
