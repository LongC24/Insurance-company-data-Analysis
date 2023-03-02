# 先删除前5行至标题行
# 然后删除最后至仍有数据的行

# 文件预先处理后数据正确后 导出至CSV  然后导入数据库
import pandas as pd
import numpy as np

# 文件名
fileName = 'NLG_AllNewBusinessReport_03012023'

inputFile = 'importFile/' + fileName + '.xlsx'
outputFile = 'exportFile/' + fileName + '.csv'

# Read the Excel file
df = pd.read_excel(inputFile)

print(df)

# for i in df:
#     print(df[i])

# set the row Submitted data type to date
df['Submitted'] = pd.to_datetime(df['Submitted'])


# Save the Excel file to  CSV
df.to_csv(outputFile, index=False)
