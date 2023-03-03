-- 测试用 BA

-- 按照日期选中 Allianz  中 重要数据
select `Received Date`, `Policy Number`, `Writing Agent Name`, `Estimated Premium`
FROM Allianz_Annuity
where 1 = 1

  and `Received Date`
    > '2023-02-10'
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


-- 正式插入
# INSERT INTO FullTable_Combine(Submit_Date, Company_Name, Insured_Name, Product_Type, Policy_ID, Face_Amount, Status,
#                               Product_Name, Writing_Agent)

-- 解决当没有重复保单号无法运行
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
  -- 判断是否有重复保单号  没有的话 就直接True  有的话 先选出的时候 不添加至表单内  之后 需要写一个 另外重复保单号的查询
  -- if(条件，条件成立的值，条件不成立的值)
  and if((select Allianz_Annuity.`Policy Number`
          from Allianz_Annuity
          group by Allianz_Annuity.`Policy Number`
          having count(Allianz_Annuity.`Policy Number`) > 1),
         Allianz_Annuity.`Policy Number` = (select Allianz_Annuity.`Policy Number`
                                            from Allianz_Annuity
                                            group by Allianz_Annuity.`Policy Number`
                                            having count(Allianz_Annuity.`Policy Number`) > 1), 1 = 1)


  and 1 = 1
;



