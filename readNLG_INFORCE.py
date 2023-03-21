# 然后删除最后至仍有数据的行

# 文件预先处理后数据正确后 导出至CSV  然后导入数据库
import pandas as pd
import numpy as np
import os
import glob
import re


#  查找importFile文件夹下的文件 并获取文件名为NLG 开头的文件名


# 获取文件夹下的文件名
def getFileName(path):
    files = os.listdir(path)
    return files


# 获取文件夹下的文件名
files = getFileName('importFile')
print(files)
# 文件名为NLG 开头的文件名
for file in files:
    if re.match(r'NLG_In', file):
        fileName = file

# 文件名
# fileName = 'NLG_AllNewBusinessReport_03072023'

inputFile = 'importFile/' + fileName
outputFile = 'exportFile/' + fileName + '.csv'

# Read the Excel file
df = pd.read_excel(inputFile)
print(df[0:5])

# 先删除前5行至标题行
df = df.drop(df.index[0:4])
print(df[0:5])
df.columns = df.iloc[0]
print(df[0:5])

# 删除倒数三行
df = df.drop(df.index[-3:])
# 删除第一行
df = df.drop(df.index[0])

# df = df.reindex(df.drop(df.index[0:0]))

# 设置第一行为标题行


# 重新排序


print(df)

# for i in df:
#     print(df[i])

# set the row Submitted data type to date
df['Issue Date'] = pd.to_datetime(df['Issue Date'])

# Save the Excel file to  CSV

df.to_csv(outputFile, index=False)
