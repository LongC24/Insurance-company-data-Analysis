Select *
from NLG_NEW
where `Policy #` in (select `Policy #` from NLG_INFORCE);

select Policy_ID, count(Company_Name) as count1
from FullTable_Combine
group by Policy_ID;

select count(Owner), `Policy #`
from NLG_NEW
group by `Policy #`;

# 查询那个产品名字是重复的
select count(Type),Product_Name
from Product_Detail
group by Product_Name
having count(Type)>1;



