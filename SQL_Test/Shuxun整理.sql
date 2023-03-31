-- 从NLG_INFORCE 中选出 Agent # 为 2205S 或 5500268098 的记录 (Shuxun Li)
SELECT *
from NLG_INFORCE
where `Agent #` = '2205S'
   or `Agent #` = '5500268098';

-- 从 Allianz_Life 中选出 Writing Agent Number 为 358152741 的记录 (Shuxun Li)
SELECT *
from Allianz_Life
where `Writing Agent Number` like '%358152741%';

-- 从 Allianz_Annuity 中选出 Writing Agent Number 为 722152741 的记录 (Shuxun Li)
SELECT *
from Allianz_Annuity
where `Writing Agent Number` like '%722152741%';

-- 从 BA_policy_list 中选出 Agent Name 为 Shuxun Li 的记录 (Shuxun Li) 去掉 Allianz Life
SELECT *
from BA_policy_list
where `Agent Name` like '%Shuxun%'
  and Carrier != 'Allianz Life';


create view Shuxun_All as
select BA_policy_list.`Submitted Date`       as 'Submitted_Date',
       BA_policy_list.`Status Date`          as 'Effective_Date',
       BA_policy_list.`Applicant Name`       as Applicant_Name,
       BA_policy_list.`Applicant Name`       as 'Owner_Name',
       BA_policy_list.Carrier                as 'Insurance_Company',
       BA_policy_list.Plan                   as 'Plan',
       BA_policy_list.`Policy Number`        as 'Policy_Number',
       BA_policy_list.`Status`               as 'Status',
       BA_policy_list.`Applicant Home Phone` as 'Home_Phone',
       BA_policy_list.`App Email`            as 'Email'
from BA_policy_list
where `Agent Name` like '%Shuxun%'
  and Carrier != 'Allianz Life'
union
select null                                  as 'Submitted_Date',
       NLG_INFORCE.`Issue Date`              as 'Effective_Date', -- issue date 就是 effective date
       NLG_INFORCE.`Insured / Annuitant`     as Applicant_Name,
       NLG_INFORCE.Owner                     as 'Owner_Name',
       'NLG'                                 as 'Insurance_Company',
       NLG_INFORCE.`Product`                 as 'Plan',
       NLG_INFORCE.`Policy #`                as 'Policy_Number',
       NLG_INFORCE.`Status`                  as 'Status',
       NLG_INFORCE.`Insured/Annuitant Phone` as 'Home_Phone',
       NLG_INFORCE.`Insured/Annuitant Email` as 'Email'
from NLG_INFORCE
where `Agent #` = '2205S'
   or `Agent #` = '5500268098'

union
select Allianz_Annuity.`Received Date`          as 'Submitted_Date',
       Allianz_Annuity.`Policy Effective Date`  as 'Effective_Date',
       Allianz_Annuity.`Insured Annuitant Name` as Applicant_Name,
       Allianz_Annuity.`Owner Name`             as 'Owner_Name',
       'Allianz'                                as 'Insurance_Company',
       Allianz_Annuity.`Product`                as 'Plan',
       Allianz_Annuity.`Policy Number`          as 'Policy_Number',
       Allianz_Annuity.`Policy Status`          as 'Status',
       null                                     as 'Home_Phone',
       null                                     as 'Email'
from Allianz_Annuity
where `Writing Agent Number` like '%722152741%'
union
select Allianz_Life.`Received Date`          as 'Submitted_Date',
       Allianz_Life.`Policy Effective Date`  as 'Effective_Date',
       Allianz_Life.`Insured Annuitant Name` as Applicant_Name,
       Allianz_Life.`Owner Name`             as 'Owner_Name',
       'Allianz'                             as 'Insurance_Company',
       Allianz_Life.`Product`                as 'Plan',
       Allianz_Life.`Policy Number`          as 'Policy_Number',
       Allianz_Life.`Policy Status`          as 'Status',
       null                                  as 'Home_Phone',
       null                                  as 'Email'
from Allianz_Life
where `Writing Agent Number` like '%358152741%'

order by `Submitted_Date` desc
;


-- 查询shuxun_all中的保单号有没有重复的
select `Policy_Number`, count(*) as 'count'
from Shuxun_All
group by `Policy_Number`
having count(*) > 1;

-- 查询shuxun_all中的保单号是不在bx_order.number中的
select *
from Shuxun_All
where `Policy_Number` not in (select number from bx_order);

Select Shuxun_All.* , bx_order.share_rate
from bx_order
         join Shuxun_All on Shuxun_All.Policy_Number = bx_order.number
where number in (select `Policy_Number` from Shuxun_All);




