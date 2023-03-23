# 生成日期列表 接受开始日期和结束日期 返回日期列表 日期格式为字符串 EX: 2020-01-01
from datetime import datetime, timedelta


def is_weekend(date):
    """
    判断给定的日期是否为周末。
    :param date: 一个 datetime 对象。
    :return: 如果给定的日期是周末，则返回 True；否则返回 False。
    """
    return date.weekday() in [5, 6]


def is_weekday(date):
    """
    判断给定的日期是否为工作日。
    :param date: 一个 datetime 对象。
    :return: 如果给定的日期是工作日，则返回 True；否则返回 False。
    """
    return date.weekday() in [0, 1, 2, 3, 4]


def is_monday(date):
    """
    判断给定的日期是否为周一。
    :param date: 一个 datetime 对象。
    :return: 如果给定的日期是周一，则返回 True；否则返回 False。
    """
    return date.weekday() == 0


def is_tuesday(date):
    """
    判断给定的日期是否为周二。
    :param date: 一个 datetime 对象。
    :return: 如果给定的日期是周二，则返回 True；否则返回 False。
    """
    return date.weekday() == 1


def is_wednesday(date):
    """
    判断给定的日期是否为周三。
    :param date: 一个 datetime 对象。
    :return: 如果给定的日期是周三，则返回 True；否则返回 False。
    """
    return date.weekday() == 2


def is_thursday(date):
    """
    判断给定的日期是否为周四。
    :param date: 一个 datetime 对象。
    :return: 如果给定的日期是周四，则返回 True；否则返回 False。
    """
    return date.weekday() == 3


def is_friday(date):
    """
    判断给定的日期是否为周五。
    :param date: 一个 datetime 对象。
    :return: 如果给定的日期是周五，则返回 True；否则返回 False。
    """
    return date.weekday() == 4


def is_saturday(date):
    """
    判断给定的日期是否为周六。
    :param date: 一个 datetime 对象。
    :return: 如果给定的日期是周六，则返回 True；否则返回 False。
    """
    return date.weekday() == 5


def is_sunday(date):
    """
    判断给定的日期是否为周日。
    :param date: 一个 datetime 对象。
    :return: 如果给定的日期是周日，则返回 True；否则返回 False。
    """
    return date.weekday() == 6


def generate_dates(start_date: str, end_date: str):
    """
        生成并返回一个包含指定日期范围内所有日期的列表。

        :param start_date: 日期范围的开始日期，格式为 'YYYY-MM-DD'。
        :type start_date: str
        :param end_date: 日期范围的结束日期，格式为 'YYYY-MM-DD'。
        :type end_date: str
        :return: 包含指定日期范围内所有日期的列表。
        :rtype: list
        """
    start = datetime.strptime(start_date, '%Y-%m-%d')
    end = datetime.strptime(end_date, '%Y-%m-%d')
    delta = timedelta(days=1)
    current = start
    dates = []
    while current <= end:
        dates.append(current.strftime('%Y-%m-%d'))
        current += delta
    return dates


# 输入2个日期 首先判断距离起始日期最近的周一  然后判断距离结束日期最近的周日 然后生成这2个日期之间的所有周一和周日
def get_mondays_and_sundays(start_date: str, end_date: str):
    """
        输入2个日期 首先判断距离起始日期最近的周一 然后判断距离结束日期最近的周日 然后生成这2个日期之间的所有周一和周日

        如果给定的开始日期不是周一，返回距离开始日期最近的周一。
        如果给定的结束日期不是周日，返回距离结束日期最近的周日。
        如果给定的日期范围内没有周一或周日，则返回空列表。
        如果给定的结束日期早于开始日期，则返回空列表。
        :param start_date: 起始日期，格式为 'YYYY-MM-DD' 的字符串。
        :param end_date: 结束日期，格式为 'YYYY-MM-DD' 的字符串。
        :return:分开返回2个个包含所有在给定时间范围内的 周一 和 周日 的2个列表。每个元素都是一个格式为 'YYYY-MM-DD' 的字符串。

        """

    start = datetime.strptime(start_date, '%Y-%m-%d')
    end = datetime.strptime(end_date, '%Y-%m-%d')

    if end < start:
        return [], []

    # Find the closest Monday to the start date
    while start.weekday() != 0:
        start += timedelta(days=1)

    # Find the closest Sunday to the end date
    while end.weekday() != 6:
        end -= timedelta(days=1)

    mondays = []
    sundays = []

    current_date = start
    while current_date <= end:
        if current_date.weekday() == 0:
            mondays.append(current_date.strftime('%Y-%m-%d'))
        elif current_date.weekday() == 6:
            sundays.append(current_date.strftime('%Y-%m-%d'))

        current_date += timedelta(days=1)

    return mondays, sundays
