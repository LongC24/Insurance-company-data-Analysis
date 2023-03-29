-- 检查所有的产品名字是否已经添加到 Product_Detail 表中 （用于检测 万一有提交的新产品并不在） 返回值应该都为空

-- 检查Allianz 年金产品是否都在产品表中 （用于检测 万一有提交的新产品并不在）
SELECT Allianz_Annuity.`Product`
FROM Allianz_Annuity
where true

  and Allianz_Annuity.`Product` not in (select Product_Detail.Product_Name from Product_Detail)

  and true;

-- 检查Allianz Life 产品是否都在产品表中 （用于检测 万一有提交的新产品并不在） 但是Allianz  Life 只有一个产品 已经添加 应该返回值为 空
SELECT Allianz_Life.`Product`
FROM Allianz_Life
where true

  and Allianz_Life.`Product` not in (select Product_Detail.Product_Name from Product_Detail)

  and true;

-- 检查NLG Inforce  产品是否都在产品表中 （用于检测 万一有提交的新产品并不在）
select NLG_INFORCE.Product as Product_Name
from NLG_INFORCE
where true

  and NLG_INFORCE.Product not in (select Product_Detail.Product_Name from Product_Detail)

  and true
group by NLG_INFORCE.Product;


-- 检查NLG NEW Businessmen 产品是否都在产品表中 （用于检测 万一有提交的新产品并不在）
select NLG_NEW.Product as Product_Name
from NLG_NEW
where true

  and NLG_NEW.Product not in (select Product_Detail.Product_Name from Product_Detail)

  and true
group by NLG_NEW.Product;


-- 检查是否有新的公司名字没有被加入 Company_Name 表中 BA
select BA_policy_list.Carrier as Company_Name
from BA_policy_list
where BA_policy_list.Carrier not in (select Company_Name.FullName from Company_Name);

-- 检查是否有新的产品名字没有被加入 Product_Type 表中 BA
select BA_policy_list.Plan as Product_Name, BA_policy_list.Carrier as Company_Name
from BA_policy_list
where BA_policy_list.Plan not in (select Product_Detail.Product_Name from Product_Detail);

-- 校验是否重复添加过

-- 查询 Product_Detail 表中的产品名字是否有重复的
select Product_Name, count(*) as count
from Product_Detail
group by Product_Name
having count(*) > 1;
-- 查询 Company_Name 表中的公司名字是否有重复的
select FullName, count(*) as count
from Company_Name
group by FullName
having count(*) > 1;
