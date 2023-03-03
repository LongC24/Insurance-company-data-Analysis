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