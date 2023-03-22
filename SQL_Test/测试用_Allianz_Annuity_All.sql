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

  and Allianz_Annuity.`Product` not in (select Product_Detail.Product_Name from Product_Detail)

  and true;


-- 正式插入
INSERT INTO FullTable_Combine (Submit_Date, Effective_Date, Company_Name, Insured_Name, Policy_Onwer, Product_Type,
                               Policy_ID,
                               Face_Amount, Policy_Status,
                               Product_Name, Writing_Agent)

-- 解决当没有重复保单号无法运行
SELECT Allianz_Annuity.`Received Date`                    as SubmitDate,     -- 提交日期
       Allianz_Annuity.`Policy Effective Date`            as Effective_Date, -- 生效日期
       Company_Name.CommonName                            as Company_Name,   -- 公司名称
       Allianz_Annuity.`Insured Annuitant Name`           as Insured_Name,   -- 被保人
       Allianz_Annuity.`Owner Name`                       as Policy_Onwer,   -- 保单人
       Product_Detail.Type                                as Product_Type,   -- 产品类型
       Allianz_Annuity.`Policy Number`                    as Policy_ID,      -- 保单号
       Allianz_Annuity.`Accumulation Annuitization Value` as Face_Amount,    -- 保额
       Allianz_Annuity.`Policy Status`                    as Policy_Status,  -- 保单状态
       Allianz_Annuity.`Product`                          as Product_Name,   -- 产品名称
       Allianz_Annuity.`Writing Agent Name`               as Writing_Agent   -- 分单人

FROM Allianz_Annuity
         left join Company_Name
                   on Company_Name.FullName = 'Allianz Life Insurance Company of North America'
         left join Product_Detail
                   on Product_Detail.Product_Name = Allianz_Annuity.`Product`
on duplicate key update FullTable_Combine.Face_Amount   = Allianz_Annuity.`Accumulation Annuitization Value`,
                        FullTable_Combine.Effective_Date = Allianz_Annuity.`Policy Effective Date`,
                        FullTable_Combine.Policy_Status = Allianz_Annuity.`Policy Status`
;




