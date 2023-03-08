-- 按照日期选中 Allianz  中 重要数据
select `Received Date`, `Policy Number`, FaceAmount, `Writing Agent Name`, Product
FROM Allianz_Life
where 1 = 1

  and `Received Date`
    > '2023-01-10'
  and `Received Date`
    < '2023-02-18'

  and 1 = 1

order by `Received Date`
;


-- 按照日期统计
SELECT `Received Date`, COUNT(`Writing Agent Number`)
FROM Allianz_Annuity
where 1 = 1

  and `Received Date`
    > '2023-02-10'
  and `Received Date`
    < '2023-02-18'

  and 1 = 1

group by `Received Date`
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

-- 正式选择使用
SELECT Allianz_Life.`Received Date`      as SubmitDate,
       Company_Name.CommonName           as Company_Name,
       Allianz_Life.`Insured Name`       as Insured_Name,
       Product_Type.Type                 as Product_Type,
       Allianz_Life.`Policy Number`      as Policy_ID,
       Allianz_Life.`FaceAmount`         as Face_Amount,
       Policy_Status.Status              as Status,
       Allianz_Life.`Product`            as Product_Name,
       Allianz_Life.`Writing Agent Name` as Writing_Agent

FROM Allianz_Life
         join Company_Name
              on Company_Name.FullName = 'Allianz Life Insurance Company of North America'
         join Product_Type
              on Product_Type.Product_Name = Allianz_Life.`Product`
         join Policy_Status
              on Policy_Status.Status = 'Unknown'
where 1 = 1

  and Allianz_Life.`Received Date`
    > '2000-01-10'
  and Allianz_Life.`Received Date`
    < '2023-03-20'

  and 1 = 1;

-- 检查Allianz 产品是否都在产品表中 （用于检测 万一有提交的新产品并不在） 但是Allianz  Life 只有一个产品 已经添加 应该返回值为 空
SELECT Allianz_Life.`Product`
FROM Allianz_Life
where true

  and Allianz_Life.`Product` not in (select Product_Type.Product_Name from Product_Type)

  and true;


-- 插入数据库
INSERT INTO FullTable_Combine(Submit_Date, Company_Name, Insured_Name, Product_Type, Policy_ID, Policy_Status,
                              Product_Name, Writing_Agent)
SELECT Allianz_Life.`Received Date`          as SubmitDate,
       Company_Name.CommonName               as Company_Name,
       Allianz_Life.`Insured Annuitant Name` as Insured_Name,
       Product_Type.Type                     as Product_Type,
       Allianz_Life.`Policy Number`          as Policy_ID,
       Allianz_Life.`Policy Status`          as Policy_Status,
       Allianz_Life.`Product`                as Product_Name,
       Allianz_Life.`Writing Agent Name`     as Writing_Agent

FROM Allianz_Life
         left join Company_Name
                   on Company_Name.FullName = 'Allianz Life Insurance Company of North America'
         left join Product_Type
                   on Product_Type.Product_Name = Allianz_Life.`Product`

on duplicate key update Submit_Date = Allianz_Life.`Received Date`,
                        Policy_Status = Allianz_Life.`Policy Status`
;