import pymysql

db = pymysql.connect(host='localhost',
                     user='Test_User',
                     password='1234567890@',
                     database='TOP')
cursor = db.cursor()

# 使用 execute()  方法执行 SQL 查询
# cursor.execute("SELECT VERSION()")

cursor.execute("""
SELECT Allianz_Life.`Received Date`      as SubmitDate,
       Company_Name.CommonName           as Company_Name,
       Allianz_Life.`Insured Name`       as Insured_Name,
       Product_Type.Type                 as Product_Type,
       Allianz_Life.`Policy Number`      as Policy_ID,
       Allianz_Life.`FaceAmount`         as Face_Amount,
       Policy_Status.Status              as Status,
       Allianz_Life.`Product`            as Product_Name,
       Allianz_Life.`Writing Agent Name` as Writing_Agent

FROM Allianz_Life
         join Company_Name
              on Company_Name.FullName = 'Allianz Life Insurance Company of North America'
         join Product_Type
              on Product_Type.Product_Name = Allianz_Life.`Product`
         join Policy_Status
              on Policy_Status.Status = 'Unknown'
where 1 = 1

  and Allianz_Life.`Received Date`
    > '2000-01-10'
  and Allianz_Life.`Received Date`
    < '2023-03-20'

  and 1 = 1
;

""")
# 使用 fetchone() 方法获取单条数据.


for data in cursor.fetchall():
    print(data[0], data[1], data[2], data[3], data[4], data[5], data[6], data[7], data[8])
# data = cursor.fetchone()
# print("Database version : %s " % data)
#
# data = {
#     'id': '20180606',
#     'name': 'Lily',
#     'age': 20
# }
# table = 'FullTable_Combine'
# sql = 'INSERT INTO {table}({keys}) VALUES ({values})'.format(table=table, keys=keys, values=values)
# try:
#     cursor.execute(sql, tuple(data.values()))
#     print('Successful')
#     db.commit()
# except:
#     print('Failed')
#     db.rollback()
# cursor.close()

# 关闭数据库连接
db.close()
