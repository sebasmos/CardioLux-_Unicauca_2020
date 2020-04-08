function model = load_12ECG_model()

        %% To generate training model, uncomment:
%         class_ = xlsread('dx.xlsx');
%         data_ = xlsread('trainingdata_59.xlsx');
%         data_ = data_(:,1:58);
%         [B,dev,stats] = mnrfit(data_,class_)
        filename = 'Linear_Regression_Model_58_feat.mat';
        A=load(filename);
        model=A.B;
end


