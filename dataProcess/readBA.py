# 文件预先处理后数据正确后 导出至CSV  然后导入数据库
import pandas as pd
import os
import re


def get_file_name(path):  # 获取文件夹下的文件名
    files_names = os.listdir(path)
    return files_names


importFile = '../importFile'  # 导入文件夹名字
files_name = get_file_name(importFile)
print(files_name)

for file in files_name:
    # 匹配文件名为开头四位是数字的文件名

    if re.match(r'^\d{4}', file):
        file_name_BA = file

inputFile = '../importFile/' + file_name_BA
outputFile = '../exportFile/' + file_name_BA + '.csv'

# Read the Excel file
df = pd.read_excel(inputFile, sheet_name='Hierarchy Submitted Application')

# # Print the first 5 rows of the data
# print(df.head())

# Save the Excel file to  CSV
df.to_csv(outputFile, index=False)
