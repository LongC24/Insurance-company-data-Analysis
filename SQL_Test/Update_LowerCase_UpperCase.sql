
-- 首先更新 Allianz 写单人 的 名字和目标表中一致
UPDATE
    Allianz_Annuity
SET Allianz_Annuity.`Writing Agent Name` = upper(replace(Allianz_Annuity.`Writing Agent Name`, ',', ''));


-- 然后更新 Allianz 被保人 的 名字和目标表中一致
UPDATE
    Allianz_Annuity
SET Allianz_Annuity.`Owner Name` = upper(replace(Allianz_Annuity.`Owner Name`, ',', ''));


-- 然后更新 Allianz 被保人 的 名字和目标表中一致
UPDATE
    Allianz_Annuity
SET Allianz_Annuity.`Owner Name` = upper(replace(Allianz_Annuity.`Owner Name`, ' ', ''));