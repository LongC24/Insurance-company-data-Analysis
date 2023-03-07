-- 测试用 BA

-- 按照日期选中 NLG 重要数据
select submitted_date, `Policy #`, `Insured / Annuitant`, `Modal Premium`, Product, Agent
FROM NLG_Policy_List_NewBusiness
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
from NLG_Policy_List_NewBusiness
group by `Policy #`
having count(`Policy #`) > 1;


-- 按照日期统计
SELECT submitted_date, COUNT(Agent)
FROM NLG_Policy_List_NewBusiness
where 1 = 1

  and submitted_date
    > '2023-02-01'
  and submitted_date
    < '2023-02-28'

  and 1 = 1
group by submitted_date
;


--  正式读取需要的数据 NLG
SELECT NLG_Policy_List_NewBusiness.submitted_date        as SubmitDate,
       Company_Name.CommonName                           as Company_Name,
       NLG_Policy_List_NewBusiness.`Insured / Annuitant` as Client,
       Product_Type.Type                                 as Product_Type,
       NLG_Policy_List_NewBusiness.`Policy #`            as Policy_ID,
       NLG_Policy_List_NewBusiness.`Modal Premium`       as Face_Amount,
       NLG_Policy_List_NewBusiness.Status                as Status,
       NLG_Policy_List_NewBusiness.Product               as Product_Name,
       NLG_Policy_List_NewBusiness.Agent                 as Writing_Agent
FROM NLG_Policy_List_NewBusiness
         left join Product_Type
                   on Product_Type.Product_Name = NLG_Policy_List_NewBusiness.Product
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
from NLG_Policy_List_NewBusiness
group by `Policy #`
having count(`Policy #`) > 1;

-- 检查NLG 产品是否都在产品表中 （用于检测 万一有提交的新产品并不在）
select NLG_Policy_List_NewBusiness.Product as Product_Name
from NLG_Policy_List_NewBusiness
where true

  and NLG_Policy_List_NewBusiness.Product not in (select Product_Type.Product_Name from Product_Type)

  and true;


-- 正式插入 汇总表 FullTable_Combine
INSERT INTO FullTable_Combine (Submit_Date, Company_Name, Insured_Name, Policy_Onwer, Product_Type, Policy_ID,
                               Face_Amount, Policy_Status,
                               Product_Name, Writing_Agent)

SELECT NLG_Policy_List_NewBusiness.submitted_date        as Submit_Date,   -- 递交日期
       Company_Name.CommonName                           as Company_Name,  -- 公司名称
       NLG_Policy_List_NewBusiness.`Insured / Annuitant` as Insured_Name,  -- 被保人姓名
       NLG_Policy_List_NewBusiness.Owner                 as Policy_Onwer,  -- 持有人姓名
       Product_Type.Type                                 as Product_Type,  -- 产品类型
       NLG_Policy_List_NewBusiness.`Policy #`            as Policy_ID,     -- 保单号
       NLG_Policy_List_NewBusiness.`Modal Premium`       as Face_Amount,   -- 面额
       NLG_Policy_List_NewBusiness.Status                as Policy_Status, -- 状态
       NLG_Policy_List_NewBusiness.Product               as Product_Name,  -- 产品名称
       NLG_Policy_List_NewBusiness.Agent                 as Writing_Agent  -- 代理人（写单人）
FROM NLG_Policy_List_NewBusiness
         left join Product_Type
                   on Product_Type.Product_Name = NLG_Policy_List_NewBusiness.Product -- 选定产品类型 （NLG表单没有预先填写产品类型 所以使用产品名字进行匹配）
         left join Company_Name
                   on Company_Name.FullName = 'National Life Group'-- 用于添加公司的新姓名缩写
ON DUPLICATE KEY UPDATE Submit_Date   = NLG_Policy_List_NewBusiness.submitted_date,
                        Product_Type  = Product_Type.Type,
                        Face_Amount   = NLG_Policy_List_NewBusiness.`Modal Premium`,
                        Policy_Status = NLG_Policy_List_NewBusiness.Status,
                        Product_Name  = NLG_Policy_List_NewBusiness.Product
;






