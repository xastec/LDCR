--OEVENTLUA[8302] = function()	--中线石中玉雪山派离队事件
    if instruct_16(591,2,0) ==false then    --  16(10):队伍是否有[石中玉]是则跳转到:Label0
        instruct_0();   --  0(0)::空语句(清屏)
        do return; end
    end    --:Label0
    instruct_13();   --  13(D):重新显示场景
    Talk("你要带我去送死吗？",591);
    instruct_0();   --  0(0)::空语句(清屏)
    instruct_21(591);   --  21(15):[石中玉]离队
	instruct_14();   --  14(E):场景变黑
    instruct_3(70,47,1,0,8301,0,0,9234,9234,9234,-2,-2,-2);   --  3(3):修改事件定义:场景[小村]:场景事件编号 [47]
	instruct_13();   --  13(D):重新显示场景
--end