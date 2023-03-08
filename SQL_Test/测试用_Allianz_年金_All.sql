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

-- 检查Allianz 产品是否都在产品表中 （用于检测 万一有提交的新产品并不在）
SELECT Allianz_Annuity.`Product`
FROM Allianz_Annuity
where true

  and Allianz_Annuity.`Product` not in (select Product_Type.Product_Name from Product_Type)

  and true;


-- 正式插入
INSERT INTO FullTable_Combine (Submit_Date, Company_Name, Insured_Name, Policy_Onwer, Product_Type, Policy_ID,
                               Face_Amount, Policy_Status,
                               Product_Name, Writing_Agent)

-- 解决当没有重复保单号无法运行
SELECT Allianz_Annuity.`Received Date`                    as SubmitDate,
       Company_Name.CommonName                            as Company_Name,
       Allianz_Annuity.`Insured Annuitant Name`           as Insured_Name,
       Allianz_Annuity.`Owner Name`                       as Policy_Onwer,
       Product_Type.Type                                  as Product_Type,
       Allianz_Annuity.`Policy Number`                    as Policy_ID,
       Allianz_Annuity.`Accumulation Annuitization Value` as Face_Amount,
       Allianz_Annuity.`Policy Status`                    as Policy_Status,
       Allianz_Annuity.`Product`                          as Product_Name,
       Allianz_Annuity.`Writing Agent Name`               as Writing_Agent

FROM Allianz_Annuity
         left join Company_Name
              on Company_Name.FullName = 'Allianz Life Insurance Company of North America'
         left join Product_Type
              on Product_Type.Product_Name = Allianz_Annuity.`Product`
on duplicate key update FullTable_Combine.Face_Amount   = Allianz_Annuity.`Accumulation Annuitization Value`,
                        FullTable_Combine.Policy_Status = Allianz_Annuity.`Policy Status`
;


-- 查询是否有预先填入的分单人
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
                                         having count(Allianz_Annuity.`Policy Number`) > 1)




