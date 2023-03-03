# 先删除前5行至标题行
# 然后删除最后至仍有数据的行

# 文件预先处理后数据正确后 导出至CSV  然后导入数据库
import pandas as pd
import numpy as np

# 文件名
fileName = 'Allianz_Annuity_Report'

inputFile = 'importFile/' + fileName + '.xlsx'
outputFile = 'exportFile/' + fileName + '.csv'

# Read the Excel file
df = pd.read_excel(inputFile)

print(df.head())

# for i in df:
#     print(df[i])
print(df.info())
# set the row Received Date   type to date
df['Received Date'] = pd.to_datetime(df['Received Date'])
df['Premium Received'] = df['Premium Received'].str.replace('$', '').str.replace(',', '')
df['Premium Received'] = pd.to_numeric(df['Premium Received'])

df['Estimated Premium'] = df['Estimated Premium'].str.replace('$', '').str.replace(',', '')
df['Estimated Premium'] = pd.to_numeric(df['Estimated Premium'])

print(df.info())
# Save the Excel file to  CSV
df.to_csv(outputFile, index=False)
