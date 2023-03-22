import pymysql

host = 'localhost'
user = 'Test_User'
password = '1234567890@'
database = 'TOP'
# 定义一个列表，包含需要查询的列名
Column = ['Submit_Date', 'Company_Name', 'Insured_Name', 'Product_Type', 'Product_Name', 'Policy_ID', 'Face_Amount',
          'Policy_Status', 'Writing_Agent']


# 连接数据库 接受SQL语句 返回查询结果
def execute_sql(sql: str):
    """
        执行 SQL 语句并返回结果。
        :param sql: str 格式传入 要执行的 SQL 语句
        :return: tuple: 包含查询结果的元组。
        """
    # 打开数据库连接
    db = pymysql.connect(host=host, user=user, password=password, database=database)

    # 使用 cursor() 方法创建一个游标对象 cursor
    cursor = db.cursor()

    # SQL 查询语句

    try:
        # 执行 SQL 语句
        cursor.execute(sql)
        # 获取所有记录列表
        results = cursor.fetchall()
    except:
        print("Error: unable to fetch data")

    # 关闭数据库连接
    db.close()
    return results


# 只选中这一天的数据
def single_submit_date(date: str):
    """
    只选中这一天的数据
    :param date: 日期 str 2021-01-01 格式
    :return: tuple 包含查询结果的元组
    """
    # 构建一个sql语句 只选中 Column 中的列
    sql = "Select "
    for i in range(len(Column)):
        sql += Column[i]
        if i != len(Column) - 1:
            sql += ", "
        else:
            sql += " "
    sql += "from TOP.FullTable_Combine where Submit_Date = '" + date + "'"
    return execute_sql(sql)


# 选中这2个日期中间的数据
def range_submit_date(start_date: str, end_date: str):
    """
    选中这2个日期中间的数据
    :param start_date: 开始日期 str 2021-01-01 格式
    :param end_date:  结束日期 str 2021-01-01 格式
    :return:  返回查询结果 为一个列表
    """
    if start_date > end_date:
        start_date, end_date = end_date, start_date

    # 构建一个sql语句 只选中 Column 中的列
    sql = "Select "
    for i in range(len(Column)):
        sql += Column[i]
        if i != len(Column) - 1:
            sql += ", "
        else:
            sql += " "
    sql += "from TOP.FullTable_Combine where Submit_Date between '" + start_date + "' and '" + end_date + "'"
    return execute_sql(sql)