UPDATE bx_users
SET mobile = REGEXP_REPLACE(mobile, '[^0-9]', '');




UPDATE Agent_List as al
join bx_users bu on al.phone = bu.mobile
SET al.wow_id = bu.id
WHERE bu.mobile = al.phone;




select * from Agent_List where Wow_id is null;



UPDATE bx_users
SET email = LOWER(email);

