-- 把被保人 姓名  保单所有者 代理人  的名字中的逗号去掉 并转换为大写
UPDATE
    NLG_Policy_List_NewBusiness
SET NLG_Policy_List_NewBusiness.`Insured / Annuitant` = upper(replace(NLG_Policy_List_NewBusiness.`Insured / Annuitant`, ',', '')),
    NLG_Policy_List_NewBusiness.Owner                 = upper(replace(NLG_Policy_List_NewBusiness.Owner, ',', '')),
    NLG_Policy_List_NewBusiness.Agent                 = upper(replace(NLG_Policy_List_NewBusiness.Agent, ',', ''));

-- 首先更新 Allianz 年金表单 中 写单人 的 名字和目标表中一致
UPDATE
    Allianz_Annuity
SET Allianz_Annuity.`Writing Agent Name`     = upper(replace(Allianz_Annuity.`Writing Agent Name`, ',', '')),
    Allianz_Annuity.`Insured Annuitant Name` = upper(replace(Allianz_Annuity.`Insured Annuitant Name`, ',', '')),
    Allianz_Annuity.`Owner Name`             = upper(replace(Allianz_Annuity.`Owner Name`, ',', ''));

-- 更新 Allianz 表中的写单人 和 目标表中的写单人一致
UPDATE
    Allianz_Life
SET Allianz_Life.`Writing Agent Name`     = upper(replace(Allianz_Life.`Writing Agent Name`, ',', '')),
    Allianz_Life.`Insured Annuitant Name` = upper(replace(Allianz_Life.`Insured Annuitant Name`, ',', '')),
    Allianz_Life.`Owner Name`             = upper(replace(Allianz_Life.`Owner Name`, ',', ''));


-- 更新 BA 表中的写单人 和 目标表中的写单人一致
UPDATE
    BA_policy_list
SET BA_policy_list.`Agent Name`     = upper(replace(BA_policy_list.`Agent Name`, ',', '')),
    BA_policy_list.`Applicant Name` = upper(replace(BA_policy_list.`Applicant Name`, ',', ''));



