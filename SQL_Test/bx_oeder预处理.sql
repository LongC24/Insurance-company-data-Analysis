-- 删除 bx.bx_order number中的所有空格
update bx.bx_order
set number = replace(number, ' ', '');
-- 删除 bx.bx_order number中的所有tab
update bx.bx_order
set number = replace(number, '	', '');


-- 删除结尾的00 在 bx.bx_order number中的所有开头为LS 或者 NL 并且大于10位的 删除结尾的00 （）
UPDATE bx.bx_order
SET number = LEFT(number, LENGTH(number) - 2)
WHERE (number LIKE 'LS%' OR number LIKE 'NL%')
  AND LENGTH(number) > 9
  AND RIGHT(number, 2) = '00';

-- number 以L开头 第二位是数字的 把L 跟换为LS



UPDATE bx.bx_order
SET number = CONCAT('LS', SUBSTRING(number, 2))
WHERE number REGEXP '^L[0-9]+$'
  and LENGTH(number) > 7;