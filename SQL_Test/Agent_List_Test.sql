UPDATE Agent_List
    join bx_users on Agent_List.wow_id = bx_users.id
set Agent_List.wow_sid = bx_users.pid
where bx_users.id = Agent_List.wow_id;



UPDATE Agent_List
SET email = LOWER(email);


UPDATE Agent_List al
    join bx_users bu on al.email = bu.email
SET Wow_id = bu.id
WHERE al.Wow_id IS NULL
  AND al.email = bu.email;


UPDATE Agent_List
SET phone = REGEXP_REPLACE(phone, '[^0-9]', '');


select *
from Agent_List
where Wow_id is null
  and wow_sid is null;
