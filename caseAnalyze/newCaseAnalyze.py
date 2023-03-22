from datetime import datetime, timedelta
import prettytable as pt
import connectDB as cdb
import datesGenerate
import openpyxl


# dates = generate_dates('2022-01-01', '2023-03-28')

def pt_single_date_print(date):
    date = cdb.single_submit_date('2023-02-09')
    # 用 prettytable 打印出来
    table = pt.PrettyTable()
    table.field_names = cdb.Column
    for i in range(len(date)):
        table.add_row(date[i])
    print(table)


def pt_range_date_print(start_date, end_date, debug=False):
    monday, sunday = datesGenerate.get_mondays_and_sundays(start_date, end_date)
    if debug:
        print(monday)
        print(sunday)

    # 便利日期列表中的日期 从数据库中获取这一周的日期 并打印出来
    for i in range(len(monday)):
        print()
        print(monday[i] + '  ********************************  ' + sunday[i])
        date = cdb.range_submit_date(monday[i], sunday[i])
        table = pt.PrettyTable()
        table.field_names = cdb.Column
        for i in range(len(date)):
            table.add_row(date[i])
        print(table)


def write_excel_weeks(start_date, end_date, file_name, debug=False):

    monday, sunday = datesGenerate.get_mondays_and_sundays(start_date, end_date)
    if debug:
        print(monday)
        print(sunday)

    # 便利日期列表中的日期 从数据库中获取这一周的日期 并打印出来
    for i in range(len(monday)):

        print(monday[i] + '  ********************************  ' + sunday[i])
        date = cdb.range_submit_date(monday[i], sunday[i])
        print(date)



if __name__ == '__main__':
    #pt_single_date_print('2023-02-09')
    # pt_range_date_print('2022-01-01', '2023-03-28')
    write_excel_weeks('2023-03-01', '2023-03-28', 'test.xlsx', debug=True)
