# 先删除前5行至标题行
# 然后删除最后至仍有数据的行

# 文件预先处理后数据正确后 导出至CSV  然后导入数据库
import pandas as pd
import numpy as np

# 文件名
fileName = 'Allianz_Life_All'

inputFile = 'importFile/' + fileName + '.xlsx'
outputFile = 'exportFile/' + fileName + '.csv'

# Read the Excel file
# try:
#     df = pd.read_excel(inputFile)
# except Exception as e:
#     print(e)
df = pd.read_excel(inputFile)
print(df[0:5])
# print(df.head())

# for i in df:
#     print(df[i])

# print(df.info())
# 先删除前5行至标题行
# df = df.drop(df.index[0:8])
# df.columns = df.iloc[0]
# print(df[0:5])
# # 删除第一行
# df = df.drop(df.index[0])

# set the row Received Date   type to date
df['Received Date'] = pd.to_datetime(df['Received Date'])
df['Accumulation Annuitization Value'] = df['Accumulation Annuitization Value'].str.replace('$', '').str.replace(',',
                                                                                                                 '')
df['Accumulation Annuitization Value'] = pd.to_numeric(df['Accumulation Annuitization Value'])
print(df.info())

# Save the Excel file to  CSV
df.to_csv(outputFile, index=False)
