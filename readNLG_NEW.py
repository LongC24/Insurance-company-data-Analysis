# 然后删除最后至仍有数据的行

# 文件预先处理后数据正确后 导出至CSV  然后导入数据库
import pandas as pd
import numpy as np
import os
import re


def get_file_name(path):  # 获取文件夹下的文件名
    files_names = os.listdir(path)
    return files_names


def process_NLG_NEW(data_frame):  # excel 进行处理

    # 先删除前5行至标题行
    data_frame = data_frame.drop(data_frame.index[0:4])
    # 设置第一行为标题行
    data_frame.columns = data_frame.iloc[0]
    # 删除倒数5行
    data_frame = data_frame.drop(data_frame.index[-5:])
    # 删除第一行 第一行设置成标题后 会有重复 （再次删除第一行）
    data_frame = data_frame.drop(data_frame.index[0])
    return data_frame


# 获取文件夹下的文件名
files = get_file_name('importFile')
print(files)
# 文件名为NLG 开头的文件名
for file in files:
    if re.match(r'NLG_All', file):
        fileName = file

# 文件名
# fileName = 'NLG_AllNewBusinessReport_03072023'


# 设置文件名
inputFile = 'importFile/' + fileName
outputFile = 'exportFile/' + fileName + '.csv'
# Read the Excel file
df = pd.read_excel(inputFile)


# excel 进行处理
def process_nlg_new(dataFram):
    # 先删除前5行至标题行
    dataFram = dataFram.drop(dataFram.index[0:4])
    # 设置第一行为标题行
    dataFram.columns = dataFram.iloc[0]
    # 删除倒数5行
    dataFram = dataFram.drop(dataFram.index[-5:])
    # 删除第一行 第一行设置成标题后 会有重复
    dataFram = dataFram.drop(dataFram.index[0])
    return dataFram


# df = df.reindex(df.drop(df.index[0:0]))


# set the row Submitted data type to date
df['Submitted'] = pd.to_datetime(df['Submitted'])

# Save the Excel file to  CSV

df.to_csv(outputFile, index=False)
