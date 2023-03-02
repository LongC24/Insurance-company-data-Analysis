# 文件预先处理后数据正确后 导出至CSV  然后导入数据库
import pandas as pd
import numpy as np

# 文件名

fileName = 'BA_6857374'

inputFile = 'importFile/' + fileName + '.xlsx'
outputFile = 'exportFile/' + fileName+ '.csv'


# Read the Excel file
df = pd.read_excel(inputFile, sheet_name='Hierarchy Submitted Application')

#Print the first 5 rows of the data
print(df.head())

# Save the Excel file to  CSV
df.to_csv(outputFile, index=False)
