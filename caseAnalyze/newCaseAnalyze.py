from datetime import datetime, timedelta
import prettytable as pt
import connectDB as cdb


# 生成日期列表 接受开始日期和结束日期 返回日期列表 日期格式为字符串 EX: 2020-01-01
def generate_dates(start_date: str, end_date: str):
    start = datetime.strptime(start_date, '%Y-%m-%d')
    end = datetime.strptime(end_date, '%Y-%m-%d')
    delta = timedelta(days=1)
    current = start
    dates = []
    while current <= end:
        dates.append(current.strftime('%Y-%m-%d'))
        current += delta
    return dates


cdb.execute_sql("Select * from TOP.FullTable_Combine")

# dates = generate_dates('2022-01-01', '2023-03-28')


date = cdb.double_submit_date('2023-01-01', '2023-02-01')
# 用 prettytable 打印出来
table = pt.PrettyTable()
table.field_names = cdb.Column
for i in range(len(date)):
    table.add_row(date[i])
print(table)


# 输入2个日期 首先判断距离起始日期最近的周一  然后判断距离结束日期最近的周日 然后生成这2个日期之间的所有周一和周日
# 用于判断日期是否为周一
def is_monday(date):
    """
    判断给定的日期是否为周一。
    :param date: 一个 datetime 对象。
    :return: 如果给定的日期是周一，则返回 True；否则返回 False。
    """
    return date.weekday() == 0


def generate_weeks(start_date, end_date):
    """
    输入2个日期 首先判断距离起始日期最近的周一 然后判断距离结束日期最近的周日 然后生成这2个日期之间的所有周一和周日
    :param start_date: 起始日期，格式为 'YYYY-MM-DD' 的字符串。
    :param end_date: 结束日期，格式为 'YYYY-MM-DD' 的字符串。
    :return: 一个包含所有在给定时间范围内的 周一 和 周日 的列表。
             每个元素都是一个格式为 'YYYY-MM-DD' 的字符串。
    """
    start = datetime.strptime(start_date, '%Y-%m-%d')
    end = datetime.strptime(end_date, '%Y-%m-%d')

    delta = timedelta(days=1)

    current = start
    weeks = []

    while current <= end:
        if is_monday(current):
            weeks.append(current.strftime('%Y-%m-%d'))
            current += timedelta(days=6)
            weeks.append(current.strftime('%Y-%m-%d'))
        else:
            current += delta

    return weeks


print(generate_weeks('2023-01-01', '2023-03-28'))
