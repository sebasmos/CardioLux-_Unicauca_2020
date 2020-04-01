function SaveToExcel(k,features)

filename = 'trainingdata.xlsx';
Position = 'A';
labelPosition = int2str(k);
Final_Position = strcat(Position,labelPosition);
xlswrite(filename, features(:)', 1, Final_Position);