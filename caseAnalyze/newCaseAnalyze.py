from datetime import datetime, timedelta
import prettytable as pt
import connectDB as cdb
import datesGenerate

# dates = generate_dates('2022-01-01', '2023-03-28')


# date = cdb.double_submit_date('2023-01-01', '2023-03-01')
# # 用 prettytable 打印出来
# table = pt.PrettyTable()
# table.field_names = cdb.Column
# for i in range(len(date)):
#     table.add_row(date[i])
# print(table)


monday, sunday = datesGenerate.get_mondays_and_sundays('2023-03-01', '2023-04-09')
print(monday)
print(sunday)
