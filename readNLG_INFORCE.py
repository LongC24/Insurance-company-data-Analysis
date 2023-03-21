# 文件预先处理后数据正确后 导出至CSV  然后导入数据库
import pandas as pd
import os
import re


def get_file_name(path):  # 获取文件夹下的文件名
    files_names = os.listdir(path)
    return files_names


def process_nlg_new(data_frame):  # excel 进行处理
    # Read the Excel file
    data_frame = pd.read_excel(inputFile)
    print(data_frame[0:5])

    # 先删除前5行至标题行
    data_frame = data_frame.drop(data_frame.index[0:4])
    print(data_frame[0:5])
    data_frame.columns = data_frame.iloc[0]
    print(data_frame[0:5])

    # 删除倒数三行
    data_frame = data_frame.drop(data_frame.index[-3:])
    # 删除第一行
    data_frame = data_frame.drop(data_frame.index[0])

    return data_frame


# 获取文件夹下的文件名
files_name = get_file_name('importFile')
# 文件名为NLG 开头的文件名
for file in files_name:
    if re.match(r'NLG_In', file):
        fileName = file

# 设置文件名
inputFile = 'importFile/' + fileName
outputFile = 'exportFile/' + fileName + '.csv'

# Read the Excel file
df = pd.read_excel(inputFile)

# excel 进行处理
df = process_nlg_new(df)

# set the row Submitted data type to date
# 转换日期格式 方便插入数据库
df['Issue Date'] = pd.to_datetime(df['Issue Date'])

# Save the Excel file to  CSV
df.to_csv(outputFile, index=False)
