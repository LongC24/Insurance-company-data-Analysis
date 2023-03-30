-- 完整的插入脚本

-- 正式插入 Allianz Annuity
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
on duplicate key update FullTable_Combine.Face_Amount    = Allianz_Annuity.`Accumulation Annuitization Value`,
                        FullTable_Combine.Effective_Date = Allianz_Annuity.`Policy Effective Date`,
                        FullTable_Combine.Policy_Status  = Allianz_Annuity.`Policy Status`
;

-- 插入数据库 Allianz Life
INSERT INTO FullTable_Combine(Submit_Date, Effective_Date, Company_Name, Insured_Name, Policy_Onwer, Product_Type,
                              Policy_ID,
                              Policy_Status,
                              Product_Name, Writing_Agent)
SELECT Allianz_Life.`Received Date`          as SubmitDate,     -- 提交日期
       Allianz_Life.`Policy Effective Date`  as Effective_Date, -- 日期
       Company_Name.CommonName               as Company_Name,   -- 公司名
       Allianz_Life.`Insured Annuitant Name` as Insured_Name,   -- 被保人
       Allianz_Life.`Owner Name`             as Policy_Onwer,   -- 保单所有人
       Product_Detail.Type                   as Product_Type,   -- 产品类型
       Allianz_Life.`Policy Number`          as Policy_ID,      -- 保单号
       Allianz_Life.`Policy Status`          as Policy_Status,  -- 保单状态
       Allianz_Life.`Product`                as Product_Name,   -- 产品名
       Allianz_Life.`Writing Agent Name`     as Writing_Agent   -- 代理人

FROM Allianz_Life
         left join Company_Name
                   on Company_Name.FullName = 'Allianz Life Insurance Company of North America'
         left join Product_Detail
                   on Product_Detail.Product_Name = Allianz_Life.`Product`

on duplicate key update Submit_Date    = Allianz_Life.`Received Date`,
                        Effective_Date = Allianz_Life.`Policy Effective Date`,
                        Policy_Status  = Allianz_Life.`Policy Status`
;


-- 正式插入 NLG Inforce
INSERT INTO FullTable_Combine (Effective_Date, Company_Name, Insured_Name, Policy_Onwer, Product_Type, Policy_ID,
                               Face_Amount, Policy_Status,
                               Product_Name, Writing_Agent)

SELECT NLG_INFORCE.`Issue Date`          as Effective_Date, -- 生效日期 (暂时没有提交日期)
       Company_Name.CommonName           as Company_Name,-- 公司名称
       NLG_INFORCE.`Insured / Annuitant` as Client,         -- 客户名称
       NLG_INFORCE.Owner                 as Policy_Onwer,   -- 保单所有人
       Product_Detail.Type               as Product_Type,   -- 产品类型
       NLG_INFORCE.`Policy #`            as Policy_ID,      -- 保单号
       null                              as Face_Amount,    -- 保额
       NLG_INFORCE.Status                as Status,         -- 保单状态
       NLG_INFORCE.Product               as Product_Name,   -- 产品名称
       NLG_AGENT_LIST.AGENT_NAME         as Writing_Agent   -- Agent
FROM NLG_INFORCE
         left join NLG_AGENT_LIST -- Agent 匹配
                   on NLG_AGENT_LIST.AGENT_ID = NLG_INFORCE.`Agent #`
         left join Product_Detail
                   on Product_Detail.Product_Name = NLG_INFORCE.Product
         left join Company_Name
                   on Company_Name.FullName = 'National Life Group'
ON DUPLICATE KEY UPDATE FullTable_Combine.Effective_Date = NLG_INFORCE.`Issue Date`,
                        FullTable_Combine.Product_Type   = Product_Detail.Type,
                        FullTable_Combine.Policy_Status  = NLG_INFORCE.Status,
                        FullTable_Combine.Product_Name   = NLG_INFORCE.Product
;


-- 正式插入 NLG New Business  （注意：这里的NLG_NEW.submitted_date 提交日期 不是生效日期）
INSERT INTO FullTable_Combine (Submit_Date, Company_Name, Insured_Name, Policy_Onwer, Product_Type, Policy_ID,
                               Face_Amount, Policy_Status,
                               Product_Name, Writing_Agent)

SELECT NLG_NEW.submitted_date        as Submit_Date,   -- 生效日期
       Company_Name.CommonName       as Company_Name,  -- 公司名称
       NLG_NEW.`Insured / Annuitant` as Insured_Name,  -- 被保人姓名
       NLG_NEW.Owner                 as Policy_Onwer,  -- 持有人姓名
       Product_Detail.Type           as Product_Type,  -- 产品类型
       NLG_NEW.`Policy #`            as Policy_ID,     -- 保单号
       NLG_NEW.`Modal Premium`       as Face_Amount,   -- 面额
       NLG_NEW.Status                as Policy_Status, -- 状态
       NLG_NEW.Product               as Product_Name,  -- 产品名称
       NLG_NEW.Agent                 as Writing_Agent  -- 代理人（写单人）
FROM NLG_NEW
         join Product_Detail
              on Product_Detail.Product_Name = NLG_NEW.Product -- 选定产品类型 （NLG表单没有预先填写产品类型 所以使用产品名字进行匹配）
         join Company_Name
              on Company_Name.FullName = 'National Life Group'
-- 用于添加公司的新姓名缩写
ON DUPLICATE KEY UPDATE Submit_Date   = NLG_NEW.submitted_date,
                        Product_Type  = Product_Detail.Type,
                        Face_Amount   = NLG_NEW.`Modal Premium`,
                        Policy_Status = NLG_NEW.Status,
                        Product_Name  = NLG_NEW.Product
;

-- 正式插入 BA_policy_list 需要排除Allianz 产品
INSERT INTO FullTable_Combine (Submit_Date, Effective_Date, Company_Name, Insured_Name, Product_Type, Policy_ID,
                               Face_Amount,
                               Policy_Status,
                               Product_Name, Writing_Agent)
select BA_policy_list.`Submitted Date`  as Submit_Date,
       BA_policy_list.`Policy Eff Date` as Effective_Date,
       Company_Name                     as Company_Name,
       BA_policy_list.`Applicant Name`  as Insured_Name,
       Product_Detail.Type              as Product_Type,
       BA_policy_list.`Policy Number`   as Policy_ID,
       -- 如果是年金那么 FaceAmount 是 0 需要用另外一个
       If(Product_Detail.Type = 'Annuity',
          BA_policy_list.`Modal Premium`,
          BA_policy_list.`Face Amount`) as Face_Amount,
       BA_policy_list.Status            as Policy_Status,
       BA_policy_list.Plan              as Product_Name,
       BA_policy_list.`Agent Name`      as Writing_Agent
FROM BA_policy_list
         left join Product_Detail
                   on BA_policy_list.Plan = Product_Detail.Product_Name
         left join Company_Name
                   on BA_policy_list.Carrier = Company_Name.FullName
where Company_Name != 'Allianz'
on duplicate key update FullTable_Combine.Submit_Date    = BA_policy_list.`Submitted Date`,
                        FullTable_Combine.Effective_Date = BA_policy_list.`Policy Eff Date`,
                        FullTable_Combine.Policy_Status  = BA_policy_list.Status
;

Update TOP.shuxun_temp set split_agent  = 'Min Fei Zheng:100%' where Policy_Number = 'LS1319846';