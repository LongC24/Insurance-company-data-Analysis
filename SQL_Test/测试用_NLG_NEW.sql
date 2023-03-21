-- 测试用 BA
# NLG_NEW
-- 按照日期选中 NLG 重要数据
select submitted_date, `Policy #`, `Insured / Annuitant`, `Modal Premium`, Product, Agent
FROM NLG_NEW
where 1 = 1

  and submitted_date
    > '2023-02-01'
  and submitted_date
    < '2023-02-28'

  and 1 = 1
order by submitted_date
;


-- 单独查询其中有哪些保单是重复的（预先分单）
select `Policy #`
from NLG_NEW
group by `Policy #`
having count(`Policy #`) > 1;


-- 按照日期统计
SELECT submitted_date, COUNT(Agent)
FROM NLG_NEW
where 1 = 1

  and submitted_date
    > '2023-02-01'
  and submitted_date
    < '2023-02-28'

  and 1 = 1
group by submitted_date
;


--  正式读取需要的数据 NLG
SELECT NLG_NEW.submitted_date        as SubmitDate,
       Company_Name.CommonName       as Company_Name,
       NLG_NEW.`Insured / Annuitant` as Client,
       Product_Detail.Type           as Product_Type,
       NLG_NEW.`Policy #`            as Policy_ID,
       NLG_NEW.`Modal Premium`       as Face_Amount,
       NLG_NEW.Status                as Status,
       NLG_NEW.Product               as Product_Name,
       NLG_NEW.Agent                 as Writing_Agent
FROM NLG_NEW
         left join Product_Detail
                   on Product_Detail.Product_Name = NLG_NEW.Product
         left join Company_Name
                   on Company_Name.FullName = 'National Life Group'

where 1 = 1

#   and submitted_date
#     > '2023-02-01'
#   and submitted_date
#     < '2023-02-28'


  and 1 = 1
;
-- 单独查询其中有哪些保单是重复的（预先分单）
select `Policy #`
from NLG_NEW
group by `Policy #`
having count(`Policy #`) > 1;

-- 检查NLG 产品是否都在产品表中 （用于检测 万一有提交的新产品并不在）
select NLG_NEW.Product as Product_Name
from NLG_NEW
where true

  and NLG_NEW.Product not in (select Product_Detail.Product_Name from Product_Detail)

  and true;


-- 正式插入 汇总表 FullTable_Combine  （注意：这里的NLG_NEW.submitted_date 提交日期 不是生效日期）
INSERT INTO FullTable_Combine (Submit_Date, Company_Name, Insured_Name, Policy_Onwer, Product_Type, Policy_ID,
                               Face_Amount, Policy_Status,
                               Product_Name, Writing_Agent)

SELECT NLG_NEW.submitted_date        as Submit_Date,   -- 生效日期
       Company_Name.CommonName       as Company_Name,  -- 公司名称
       NLG_NEW.`Insured / Annuitant` as Insured_Name,  -- 被保人姓名
       NLG_NEW.Owner                 as Policy_Onwer,  -- 持有人姓名
       Product_Detail.Type           as Product_Type,  -- 产品类型
       NLG_NEW.`Policy #`            as Policy_ID,     -- 保单号
       NLG_NEW.`Modal Premium`       as Face_Amount,   -- 面额
       NLG_NEW.Status                as Policy_Status, -- 状态
       NLG_NEW.Product               as Product_Name,  -- 产品名称
       NLG_NEW.Agent                 as Writing_Agent  -- 代理人（写单人）
FROM NLG_NEW
         left join Product_Detail
                   on Product_Detail.Product_Name = NLG_NEW.Product -- 选定产品类型 （NLG表单没有预先填写产品类型 所以使用产品名字进行匹配）
         left join Company_Name
                   on Company_Name.FullName = 'National Life Group'-- 用于添加公司的新姓名缩写
ON DUPLICATE KEY UPDATE Submit_Date   = NLG_NEW.submitted_date,
                        Product_Type  = Product_Detail.Type,
                        Face_Amount   = NLG_NEW.`Modal Premium`,
                        Policy_Status = NLG_NEW.Status,
                        Product_Name  = NLG_NEW.Product
;





