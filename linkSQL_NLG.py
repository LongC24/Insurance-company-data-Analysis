import pymysql

db = pymysql.connect(host='localhost',
                     user='Test_User',
                     password='1234567890@',
                     database='TOP')
cursor = db.cursor()

# 使用 execute()  方法执行 SQL 查询
# cursor.execute("SELECT VERSION()")

cursor.execute("Use TOP;")

cursor.execute("""
SELECT NLG_Policy_List_NewBusiness.submitted_date        as SubmitDate,
       Company_Name.CommonName                           as Company_Name,
       NLG_Policy_List_NewBusiness.`Insured / Annuitant` as Client,
       Product_Detail.Type                                 as Product_Type,
       NLG_Policy_List_NewBusiness.`Policy #`            as Policy_ID,
       NLG_Policy_List_NewBusiness.`Modal Premium`       as Face_Amount,
       NLG_Policy_List_NewBusiness.Status                as Status,
       NLG_Policy_List_NewBusiness.Product               as Product_Name,
    NLG_Policy_List_NewBusiness.Agent                 as Writing_Agent
FROM NLG_Policy_List_NewBusiness
         join Product_Detail
              on Product_Detail.Product_Name = NLG_Policy_List_NewBusiness.Product
         join Company_Name
              on Company_Name.FullName = 'National Life Group'

where 1 = 1

#   and submitted_date
#     > '2023-02-01'
#   and submitted_date
#     < '2023-02-28'

  and not `Policy #` = (select `Policy #`
                        from NLG_Policy_List_NewBusiness
                        group by `Policy #`
                        having count(`Policy #`) > 1)

  and 1 = 1
;

""")
# 使用 fetchone() 方法获取单条数据.


for data in cursor.fetchall():
    print(data[0], data[1], data[2], data[3], data[4], data[5], data[6], data[7], data[8])
# data = cursor.fetchone()
# print("Database version : %s " % data)


cursor.close()

# 关闭数据库连接
db.close()
