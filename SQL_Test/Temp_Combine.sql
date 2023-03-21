SELECT `Received Date`, `Insured Annuitant Name`, `Owner Name`, Product, `Policy Number`, `Policy Status`
from TOP.Allianz_Annuity
where `Policy Number` in (select number
                          from baoxian_sys_db.bx_newinforcetp
                          where user_id = 300078);

SELECT `Received Date`, `Insured Annuitant Name`, `Owner Name`, Product, `Policy Number`, `Policy Status`
from TOP.Allianz_Life
where `Policy Number` in (select number
                          from baoxian_sys_db.bx_newinforcetp
                          where user_id = 300078);
insert into TOP.Alex_Policy
SELECT any_value(`Issue Date`),
       any_value(`Insured / Annuitant`),
       any_value(`Owner`),
       any_value(`Product`),
       `Policy #`,
       any_value(NLG_All.Status),
       any_value(`Owner Phone`),
       any_value(`Owner Email`)
from TOP.NLG_All
where `Policy #` in
      (SELECT IF(RIGHT(`number`, 2) = '00', LEFT(`number`, LENGTH(`number`) - 2), `number`)
       from (select `number`
             from baoxian_sys_db.bx_newinforcetp
             where user_id = 300078) nu)
group by `Policy #`;
;

# select number,money
# from baoxian_sys_db.bx_order
# where share_rate like '%300078%'
# ;


SELECT CASE
           WHEN RIGHT(number, 2) = '00' THEN LEFT(number, LENGTH(number) - 2)
           ELSE number
           END
from (select number
      from baoxian_sys_db.bx_newinforcetp
      where user_id = 300078
      GROUP BY number) nu
;


SELECT *
from TOP.NLG_All
where `Policy #` in
      (SELECT CASE
                  WHEN RIGHT(number, 2) = '00' THEN LEFT(number, LENGTH(number) - 2)
                  ELSE number
                  END
       from (select number
             from baoxian_sys_db.bx_newinforcetp
             where user_id = 300078) nu);
# group by `Policy #`;


-- SELECT `Issue Date`, `Insured / Annuitant`, Owner, Product, `Policy #`, Status, `Owner Phone`
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
             where user_id = 300078) nu);

select any_value(app_name), policy_number, any_value(status), any_value(phone), any_value(email)
from TOP.Alex_Policy
group by policy_number;


select count(app_name), policy_number, any_value(status), any_value(phone), any_value(email)
from TOP.Alex_Policy
group by policy_number;


SELECT IF(RIGHT(`number`, 2) = '00', LEFT(`number`, LENGTH(`number`) - 2), `number`)
from (select `number`
      from baoxian_sys_db.bx_newinforcetp
      where user_id = 300078) nu;


# 查找那些是没有进入的
select *
from baoxian_sys_db.bx_newinforcetp
where user_id = 300078
  and IF(RIGHT(`number`, 2) = '00', LEFT(`number`, LENGTH(`number`) - 2), `number`) not in
      (select policy_number from TOP.Alex_Policy);


select count(id), number
from baoxian_sys_db.bx_newinforcetp
where user_id = 300078
group by number;