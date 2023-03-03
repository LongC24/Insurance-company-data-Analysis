-- 测试用 BA

-- 按照日期选中 BA 重要主句
select `Submitted Date`,
       `Applicant Name`,
       `Face Amount`,
       `Base Premium`,
       `Policy Number`,
       Carrier,
       `Product Subcategory`,
       `Agent Name`
FROM BA_policy_list
where 1 = 1

  and `Submitted Date`
    > '2023-02-10'
  and `Submitted Date`
    < '2023-02-18'

  and 1 = 1

order by `Submitted Date`
;


-- 按照日期统计
SELECT `Submitted Date`, COUNT(`Carrier`)
FROM BA_policy_list
where 1 = 1

  and `Submitted Date`
    > '2023-02-10'
  and `Submitted Date`
    < '2023-02-18'

  and 1 = 1
group by `Submitted Date`
;


-- 按照公司进行数量统计
SELECT COUNT(`Applicant Name`), Carrier
FROM BA_policy_list
where 1 = 1

  and `Submitted Date`
    > '2023-02-10'
  and `Submitted Date`
    < '2023-02-18'

  and 1 = 1
group by Carrier
;


-- 查询预先分单的 （即保单号有重复的）
select `Policy Number`, `Agent Name`, Carrier, `Submitted Date`
FROM BA_policy_list
where 1 = 1
  and `Submitted Date`
    > '2022-01-01'
  and `Submitted Date`
    < '2023-02-28'
  and `Policy Number` = (select `Policy Number`
                         from BA_policy_list
                         group by `Policy Number`
                         having count(`Policy Number`) > 1)
  and 1 = 1
;

SELECT Allianz_Annuity.`Received Date`      as SubmitDate,
       Company_Name.CommonName              as Company_Name,
       Allianz_Annuity.`Annuitant Name`     as Insured_Name,
       Product_Type.Type                    as Product_Type,
       Allianz_Annuity.`Policy Number`      as Policy_ID,
       Allianz_Annuity.`Estimated Premium`  as Face_Amount,
       Policy_Status.Status                 as Status,
       Allianz_Annuity.`Product`            as Product_Name,
       Allianz_Annuity.`Writing Agent Name` as Writing_Agent

FROM Allianz_Annuity
         join Company_Name
              on Company_Name.FullName = 'Allianz Life Insurance Company of North America'
         join Product_Type
              on Product_Type.Product_Name = Allianz_Annuity.`Product`
         join Policy_Status
              on Policy_Status.Status = 'Unknown'
where 1 = 1

  and Allianz_Annuity.`Received Date`
    > '2000-01-10'
  and Allianz_Annuity.`Received Date`
    < '2023-03-20'
  and Allianz_Annuity.`Policy Number` = (select Allianz_Annuity.`Policy Number`
                                         from Allianz_Annuity
                                         group by Allianz_Annuity.`Policy Number`
                                         having count(Allianz_Annuity.`Policy Number`) > 1);

-- BA_policy_list.`Product Subcategory`
-- 查询BA的表
select BA_policy_list.`Submitted Date`  as Submit_Date,
       Company_Name.CommonName          as Company_Name,
       BA_policy_list.`Applicant Name`  as Insured_Name,
       Product_Type.Type                as Product_Type,
       -- 如果是年金那么 FaceAmount 是 0 需要用另外一个
       If(Product_Type.Type = 'Annuity',
          BA_policy_list.`Modal Premium`,
          BA_policy_list.`Face Amount`) as Face_Amount,
       BA_policy_list.Status            as Status,
       BA_policy_list.Plan              as Product_Name,
       BA_policy_list.`Agent Name`      as Agent_Name


FROM BA_policy_list
         join Product_Type
              on Product_Type.Product_Name = BA_policy_list.Plan
         join Company_Name
              on Company_Name.FullName = BA_policy_list.Carrier
where 1 = 1
  -- 日期筛选

#   and BA_policy_list.`Submitted Date`
#     > '2000-01-10'
#   and BA_policy_list.`Submitted Date`
#     < '2023-03-20'
  and not BA_policy_list.`Policy Number` = (select BA_policy_list.`Policy Number`
                                            from BA_policy_list
                                            group by BA_policy_list.`Policy Number`
                                            having count(BA_policy_list.`Policy Number`) > 1)
  and 1 = 1
;


-- 查询BA的表 全部加入
select BA_policy_list.`Submitted Date`  as Submit_Date,
       Company_Name.CommonName          as Company_Name,
       BA_policy_list.`Applicant Name`  as Insured_Name,
       Product_Type.Type                as Product_Type,
       -- 如果是年金那么 FaceAmount 是 0 需要用另外一个
       If(Product_Type.Type = 'Annuity',
          BA_policy_list.`Modal Premium`,
          BA_policy_list.`Face Amount`) as Face_Amount,
       BA_policy_list.Status            as Status,
       BA_policy_list.Plan              as Product_Name,
       BA_policy_list.`Agent Name`      as Agent_Name
FROM BA_policy_list
         left join Product_Type
                   on BA_policy_list.Plan = Product_Type.Product_Name
         left join Company_Name
                   on BA_policy_list.Carrier = Company_Name.FullName

where true
  -- 检查是否有Policy Number 重复的
#   and BA_policy_list.`Policy Number` != (select BA_policy_list.`Policy Number`
#                                          from BA_policy_list
#                                          group by BA_policy_list.`Policy Number`
#                                          having count(BA_policy_list.`Policy Number`) > 1)
;


-- 检查是否有新的公司名字没有被加入 Company_Name 表中
select BA_policy_list.Carrier as Company_Name
from BA_policy_list
where BA_policy_list.Carrier not in (select Company_Name.FullName from Company_Name);

-- 检查是否有Policy Number 重复的
select BA_policy_list.`Policy Number` as Policy_Number
from BA_policy_list
group by BA_policy_list.`Policy Number`
having count(BA_policy_list.`Policy Number`) > 1;


select BA_policy_list.`Policy Number`
from BA_policy_list
group by BA_policy_list.`Policy Number`
having count(BA_policy_list.`Policy Number`) > 1