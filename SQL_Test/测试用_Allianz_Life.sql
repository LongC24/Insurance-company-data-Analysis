-- 测试用 BA

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


-- 插入数据库
INSERT INTO FullTable_Combine(Submit_Date, Company_Name, Insured_Name, Product_Type, Policy_ID, Face_Amount, Status,
                              Product_Name, Writing_Agent)
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

  and 1 = 1
;