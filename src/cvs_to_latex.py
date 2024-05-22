import csv

path_table = "/mnt/d/Work/Diplom/Dataset_EuRoC/wnoise_imu_acc/V1_01_easy/results/table.cvs"

pre_table="\
\\begin{table}[!ht] \n \
    \centering \n \
    \\begin{tabular}{|c||c|c|c|c|c|c|} \n \
    \hline \n \
        ~ & rmse & mean & median & std & min & max \\\\[3ex] \hline"

end_table="\
    \end{tabular}\n\
\end{table}"

with open(path_table) as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')
    line_count = 0

    print(pre_table)
    for row in csv_reader:
        if line_count != 0:
            val = [ round(float(e), 2) for e in row[1:] ] 
            row_name = ".".join(row[0].split(".")[:-1])
            print(f'        {row_name} & {val[0]} & {val[1]} & {val[2]} & {val[3]} & {val[4]} & {val[5]} \\\\[0.7ex] \hline')
        
        line_count += 1
    
    print(end_table)