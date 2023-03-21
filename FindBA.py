import pymysql

db = pymysql.connect(host='localhost',
                     user='Test_User',
                     password='1234567890@',
                     database='TOP')
cursor = db.cursor()

# 使用 execute()  方法执行 SQL 查询
# cursor.execute("SELECT VERSION()")

cursor.execute("""


""")
# 使用 fetchone() 方法获取单条数据.


for data in cursor.fetchall():
    print(data[0], data[1], data[2], data[3], data[4], data[5], data[6], data[7], data[8])
# data = cursor.fetchone()
# print("Database version : %s " % data)

cursor.close()

# 关闭数据库连接
db.close()
