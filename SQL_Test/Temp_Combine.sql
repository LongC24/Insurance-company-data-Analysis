-- 更新NLG_NEW 和 NLG_INFORCE 的 保单号码 如果右边2个是00，就去掉00
UPDATE TOP.NLG_NEW
SET `Policy #` = IF(RIGHT(`Policy #`, 2) = '00', LEFT(`Policy #`, LENGTH(`Policy #`) - 2), `Policy #`)
WHERE `Policy #` LIKE '%00'
  and length(`Policy #`) > 9;

UPDATE TOP.NLG_INFORCE
SET `Policy #` = IF(RIGHT(`Policy #`, 2) = '00', LEFT(`Policy #`, LENGTH(`Policy #`) - 2), `Policy #`)
WHERE `Policy #` LIKE '%00'
  and length(`Policy #`) > 9;
;

-- 把L开始的单子改成LS
UPDATE baoxian_sys_db.bx_newinforcetp
SET number = CONCAT('LS', SUBSTR(number, 2))
WHERE LEFT(number, 1) = 'L'
  AND SUBSTR(number, 2, 1) != 'S';

-- 更新 baoxian_sys_db.bx_newinforcetp 的 保单号码 如果右边2个是00，并且开头为LS 或者 NL 就去掉00
UPDATE baoxian_sys_db.bx_newinforcetp
SET number = IF(RIGHT(number, 2) = '00' AND (LEFT(number, 2) = 'LS' or LEFT(number, 2) = 'NL'),
                LEFT(number, LENGTH(number) - 2), number)
WHERE number LIKE '%00'
  and length(number) > 9;;


-- 确定有多少个Alex的单子
select number
from baoxian_sys_db.bx_newinforcetp
where user_id = 300078;

-- 从Allianz 年金 TP数据库中 选取出 Alex单子
insert into TOP.Alex_Policy(date, app_name, owner_name, product, policy_number, status)
SELECT `Policy Effective Date`, `Insured Annuitant Name`, `Owner Name`, Product, `Policy Number`, `Policy Status`
from TOP.Allianz_Annuity
where `Policy Number` in (select number
                          from baoxian_sys_db.bx_newinforcetp
                          where user_id = 300078);

-- 从 Allianz Life TP数据库中 选取出 Alex单子
insert into TOP.Alex_Policy(date, app_name, owner_name, product, policy_number, status)
SELECT `Policy Effective Date`, `Insured Annuitant Name`, `Owner Name`, Product, `Policy Number`, `Policy Status`
from TOP.Allianz_Life
where `Policy Number` in (select number
                          from baoxian_sys_db.bx_newinforcetp
                          where user_id = 300078);

-- 从NLG 数据库中选取 Alex单子 （通过和 数据库对比） INFORCE
insert into TOP.Alex_Policy
SELECT any_value(`Issue Date`),
       any_value(`Insured / Annuitant`),
       any_value(`Owner`),
       any_value(`Product`),
       `Policy #`,
       any_value(NLG_INFORCE.Status),
       any_value(`Owner Phone`),
       any_value(`Owner Email`)
from TOP.NLG_INFORCE
where `Policy #` in
      (SELECT IF(RIGHT(`number`, 2) = '00', LEFT(`number`, LENGTH(`number`) - 2), `number`)
       from (select `number`
             from baoxian_sys_db.bx_newinforcetp
             where user_id = 300078) nu)
group by `Policy #`;


-- 从NLG 数据库中选取 Alex单子 （通过和 数据库对比） New Business 有原本对比 的
insert into TOP.Alex_Policy (date, app_name, owner_name, product, policy_number, status)
SELECT any_value(submitted_date),
       any_value(`Insured / Annuitant`),
       any_value(`Owner`),
       any_value(`Product`),
       `Policy #`,
       any_value(NLG_New.Status)
       -- any_value(`Owner Phone`),
       -- any_value(`Owner Email`)
from TOP.NLG_New

where `Policy #` in
      (SELECT number
       from (select `number`
             from baoxian_sys_db.bx_newinforcetp
             where user_id = 300078) nu)
group by `Policy #`;

-- 从NLG 数据库中选取 Alex单子 （通过和 数据库对比） New Business 去掉00
insert into TOP.Alex_Policy (date, app_name, owner_name, product, policy_number, status)
SELECT any_value(submitted_date),
       any_value(`Insured / Annuitant`),
       any_value(`Owner`),
       any_value(`Product`),
       `Policy #`,
       any_value(NLG_New.Status)
       -- any_value(`Owner Phone`),
       -- any_value(`Owner Email`)
from TOP.NLG_New
where `Policy #` in
      (SELECT IF(RIGHT(`number`, 2) = '00', LEFT(`number`, LENGTH(`number`) - 2), `number`)
       from (select `number`
             from baoxian_sys_db.bx_newinforcetp
             where user_id = 300078) nu)
group by `Policy #`;


-- 从BA的表中插入Alex的单子 不插入Allianz 的
insert into TOP.Alex_Policy
SELECT `Submitted Date`,
       `Applicant Name`,
       `Applicant Name`,
       Plan,
       `Policy Number`,
       Status,
       `Applicant Home Phone`,
       `App Email`
from TOp.BA_policy_list
where `Policy Number` in
      (SELECT CASE
                  WHEN RIGHT(number, 2) = '00' THEN LEFT(number, LENGTH(number) - 2)
                  ELSE number
                  END
       from (select number
             from baoxian_sys_db.bx_newinforcetp
             where user_id = 300078) nu)
  and `Carrier` != 'Allianz Life';

-- 查找哪些没有插入
select *
from baoxian_sys_db.bx_newinforcetp
where user_id = 300078
  and not number in
          (select policy_number from TOP.Alex_Policy);


-- 查找哪些保单号是重复的 有重复的 保单号
select policy_number, count(policy_number)
from TOP.Alex_Policy
group by policy_number
having count(policy_number) > 1;


-- 查找哪些保单号是重复的
select count(id), number
from baoxian_sys_db.bx_newinforcetp
where user_id = 300078
group by number;


-- 查找Shuxun 的 单子
Select *
from FullTable_Combine
where Writing_Agent = 'Li, Shuxun';

select *
from NLG_INFORCE
where `Agent #` = '5500268098';


select *
from NLG_INFORCE
where `Agent #` = '2205S';


select *
from NLG_NEW
where `Agent #` = '5500268098';


select *
from NLG_NEW
where `Agent #` = '2205S';






