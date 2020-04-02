function SaveToExcel(k,features)

%A = {'age','sex','GEH_feature3','GEH_feature4','GEH_feature5','GEH_feature6','GEH_feature7','GEH_feature8','GEH_feature9','GEH_feature10','GEH_feature11','GEH_feature12','GEH_feature13','GEH_feature14','GEH_feature15','GEH_feature16','GEH_feature17','GEH_feature18','GEH_feature19','GEH_feature20','GEH_feature21','GEH_feature22','GEH_feature23','GEH_feature24','ECG_features_ALL)'};
filename = 'trainingdata.xlsx';
Position = 'A';
labelPosition = int2str(k);
Final_Position = strcat(Position,labelPosition);
xlswrite(filename, features(:)', 1, Final_Position);