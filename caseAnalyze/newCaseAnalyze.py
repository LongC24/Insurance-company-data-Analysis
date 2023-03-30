import generateReport as gr

if __name__ == '__main__':
    # pt_single_date_print('2023-02-09')
    # pt_range_date_print('2022-01-01', '2023-03-28')
    gr.write_excel_weeks_with_data('2023-03-01', '2023-04-01', file_name='WeekReport', file_path='../exportFile/',
                                   debug=False)
