-- 测试用 BA
# NLG_INFORCE



-- 单独查询其中有哪些保单是重复的（预先分单）
select `Policy #`
from NLG_INFORCE
group by `Policy #`
having count(`Policy #`) > 1;

-- 检查NLG 产品是否都在产品表中 （用于检测 万一有提交的新产品并不在）
select NLG_INFORCE.Product as Product_Name
from NLG_INFORCE
where true

  and NLG_INFORCE.Product not in (select Product_Detail.Product_Name from Product_Detail)

  and true
group by NLG_INFORCE.Product;


--  正式读取需要的数据 NLG
SELECT NLG_INFORCE.`Issue Date`          as SubmitDate,
       Company_Name.CommonName           as Company_Name,
       NLG_INFORCE.`Insured / Annuitant` as Client,
       Product_Detail.Type               as Product_Type,
       NLG_INFORCE.`Policy #`            as Policy_ID,
       null                              as Face_Amount,
       NLG_INFORCE.Status                as Status,
       NLG_INFORCE.Product               as Product_Name,
       NLG_AGENT_LIST.AGENT_NAME         as Writing_Agent
FROM NLG_INFORCE
         left join NLG_AGENT_LIST
                   on NLG_AGENT_LIST.AGENT_ID = NLG_INFORCE.`Agent #`
         left join Product_Detail
                   on Product_Detail.Product_Name = NLG_INFORCE.Product
         left join Company_Name
                   on Company_Name.FullName = 'National Life Group'


where true

#   and submitted_date
#     > '2023-02-01'
#   and submitted_date
#     < '2023-02-28'


  and true
;


-- 正式插入 汇总表 FullTable_Combine
INSERT INTO FullTable_Combine (Effective_Date, Company_Name, Insured_Name, Policy_Onwer, Product_Type, Policy_ID,
                               Face_Amount, Policy_Status,
                               Product_Name, Writing_Agent)

SELECT NLG_INFORCE.`Issue Date`          as Effective_Date, -- 生效日期 (暂时没有提交日期)
       Company_Name.CommonName           as Company_Name,-- 公司名称
       NLG_INFORCE.`Insured / Annuitant` as Client, -- 客户名称
       NLG_INFORCE.Owner                 as Policy_Onwer, -- 保单所有人
       Product_Detail.Type               as Product_Type, -- 产品类型
       NLG_INFORCE.`Policy #`            as Policy_ID, -- 保单号
       null                              as Face_Amount, -- 保额
       NLG_INFORCE.Status                as Status, -- 保单状态
       NLG_INFORCE.Product               as Product_Name, -- 产品名称
       NLG_AGENT_LIST.AGENT_NAME         as Writing_Agent   -- Agent
FROM NLG_INFORCE
         left join NLG_AGENT_LIST -- Agent 匹配
                   on NLG_AGENT_LIST.AGENT_ID = NLG_INFORCE.`Agent #`
         left join Product_Detail
                   on Product_Detail.Product_Name = NLG_INFORCE.Product
         left join Company_Name
                   on Company_Name.FullName = 'National Life Group'
ON DUPLICATE KEY UPDATE FullTable_Combine.Effective_Date   = NLG_INFORCE.`Issue Date` ,
                        FullTable_Combine.Product_Type  = Product_Detail.Type,
                        FullTable_Combine.Policy_Status = NLG_INFORCE.Status,
                        FullTable_Combine.Product_Name  = NLG_INFORCE.Product;





