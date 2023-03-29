UPDATE Alex_Policy
SET phone = REGEXP_REPLACE(phone, '[^0-9]', '');


UPDATE Alex_Policy
SET phone = CONCAT('(', SUBSTR(phone, 1, 3), ') ', SUBSTR(phone, 4, 3), '-', SUBSTR(phone, 7));

ALTER TABLE Alex_Policy  ADD COLUMN ID INT PRIMARY KEY AUTO_INCREMENT;
