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


SELECT ANY_VALUE(Carrier), BA_policy_list.Plan
FROM BA_policy_list
where 1 = 1
group by Plan;



select Company_Name.CommonName   as Company_Name,
       Company_Name.CommonName   as CommonName,
       Product_Type.Company_Name as Company_NameProduct_Type,
       Product_Type.Product_Name as Product_Name
from Product_Type
         join Company_Name
              on Company_Name.FullName = Product_Type.Company_Name
where 1 = 1
;

-- 插入新产品后  把 公司名更新为 公司名简称
UPDATE Product_Type
set Product_Type.Company_Name = (select Company_Name.CommonName
                                 from Company_Name
                                 where Company_Name.FullName = Product_Type.Company_Name)
where Product_Type.Company_Name != (select Company_Name.CommonName
                                    from Company_Name
                                    where Company_Name.FullName = Product_Type.Company_Name);