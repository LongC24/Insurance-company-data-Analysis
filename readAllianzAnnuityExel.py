# 先删除前5行至标题行
# 然后删除最后至仍有数据的行

# 文件预先处理后数据正确后 导出至CSV  然后导入数据库
import pandas as pd
import numpy as np

# 文件名
fileName = 'Allianz_Annuity'

inputFile = 'importFile/' + fileName + '.xlsx'
outputFile = 'exportFile/' + fileName + '.csv'

# Read the Excel file
try:
    df = pd.read_excel(inputFile)
except Exception as e:
    print(e)

# print(df.info())
# set the row Received Date   type to date
try:
    df['Received Date'] = pd.to_datetime(df['Received Date'])
    df['Premium Received'] = df['Premium Received'].str.replace('$', '').str.replace(',', '')
    df['Premium Received'] = pd.to_numeric(df['Premium Received'])

    df['Estimated Premium'] = df['Estimated Premium'].str.replace('$', '').str.replace(',', '')
    df['Estimated Premium'] = pd.to_numeric(df['Estimated Premium'])
except Exception as e:
    print(e)

    df['Accumulation Annuitization Value'] = df['Accumulation Annuitization Value'].str.replace('$', '').str.replace(
        ',', '')
    df['Accumulation Annuitization Value'] = pd.to_numeric(df['Accumulation Annuitization Value'])

# print(df.info())
# print(df.head())
# Save the Excel file to  CSV

df.to_csv(outputFile, index=False)
