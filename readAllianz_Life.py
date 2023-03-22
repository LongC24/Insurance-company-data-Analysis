import os
import re
import pandas as pd


def get_file_name(path):  # 获取文件夹下的文件名
    files_names = os.listdir(path)
    return files_names


def process_allianz_life(data_frame):  # excel 进行处理
    # 先删除前5行至标题行
    data_frame = data_frame.drop(data_frame.index[0:8])
    # 设置第一行为标题行
    data_frame.columns = data_frame.iloc[0]
    # 删除第一行 第一行设置成标题后 会有重复 （再次删除第一行）
    data_frame = data_frame.drop(data_frame.index[0])
    return data_frame


# 获取文件夹下的文件名
files_name = get_file_name('importFile')
# 文件名为Allianz_Annuity 开头的文件名
for file in files_name:
    if re.match(r'Allianz_Li', file):
        fileName = file

inputFile = 'importFile/' + fileName
outputFile = 'exportFile/' + fileName + '.csv'

# Read the Excel file
try:
    df = pd.read_excel(inputFile)
    df = process_allianz_life(df)
except Exception as e:
    print(e)

# set the row Received Date   type to date
df['Received Date'] = pd.to_datetime(df['Received Date'])
df['Policy Effective Date'] = pd.to_datetime(df['Policy Effective Date'])
df['Accumulation Annuitization Value'] = df['Accumulation Annuitization Value'].str.replace('$', '').str.replace(',',
                                                                                                                 '')
df['Accumulation Annuitization Value'] = pd.to_numeric(df['Accumulation Annuitization Value'])

# Save the Excel file to  CSV
df.to_csv(outputFile, index=False)
