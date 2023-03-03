-- 检测总表中是否有保单号重复的 如果重复检测 是否split agent 为 1 （即已经标记过为有有重复的人） 如果没有标记过 则标记为 1
-- 需要使用嵌套 因为直接进行选择并不能直接选中
UPDATE
    FullTable_Combine
SET FullTable_Combine.Have_Split_Agent = 1
WHERE FullTable_Combine.Policy_ID = (select *
                                     from (select FullTable_Combine.Policy_ID -- 选中重复的保单号
                                           from FullTable_Combine
                                           group by FullTable_Combine.Policy_ID
                                           having count(FullTable_Combine.Policy_ID) > 1) as temp)
  and FullTable_Combine.Have_Split_Agent IS NULL
;


-- 计算重复保单号的数量
select Policy_ID, count(Policy_ID) as count
from FullTable_Combine
group by Policy_ID
having count(Policy_ID) > 1;

-- 设置重复保单号的数量
UPDATE
    FullTable_Combine
SET FullTable_Combine.Number_Split_Agent = (select *
                                            from (select count(Policy_ID) as count
                                                  from FullTable_Combine
                                                  group by Policy_ID
                                                  having count(Policy_ID) > 1) as temp)
WHERE FullTable_Combine.Policy_ID = (select *
                                     from (select FullTable_Combine.Policy_ID -- 选中重复的保单号
                                           from FullTable_Combine
                                           group by FullTable_Combine.Policy_ID
                                           having count(FullTable_Combine.Policy_ID)
                                                      > 1) as temp)
  and FullTable_Combine.Have_Split_Agent = 1;


-- 选中重复的保单号 并 任意只展示一个Agent  测试 用不上
select ANY_VALUE(FullTable_Combine.Writing_Agent) as Agent, FullTable_Combine.Policy_ID
from FullTable_Combine
group by FullTable_Combine.Policy_ID
having count(FullTable_Combine.Policy_ID) > 1;





