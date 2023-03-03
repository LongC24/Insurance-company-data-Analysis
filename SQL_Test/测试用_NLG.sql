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


-- 单独查询其中有哪些保单是重复的
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
-- 查找保单号重复的
select `Policy #`
from NLG_Policy_List_NewBusiness
group by `Policy #`
having count(`Policy #`) > 1;

-- 检查NLG 产品是否都在产品表中
select NLG_Policy_List_NewBusiness.Product as Product_Name
from NLG_Policy_List_NewBusiness
where true

  and NLG_Policy_List_NewBusiness.Product not in (select Product_Type.Product_Name from Product_Type)

  and true;


-- 正式插入 汇总表 FullTable_Combine
INSERT INTO FullTable_Combine (Submit_Date, Company_Name, Insured_Name, Product_Type, Policy_ID, Face_Amount, Status,
                               Product_Name, Writing_Agent)
SELECT NLG_Policy_List_NewBusiness.submitted_date        as SubmitDate,
       Company_Name.CommonName                           as Company_Name,
       NLG_Policy_List_NewBusiness.`Insured / Annuitant` as Insured_Name,
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
;





