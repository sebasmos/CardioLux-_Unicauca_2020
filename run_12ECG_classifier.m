function [score, label] = run_12ECG_classifier(data,header_data,classes, model)

    num_classes = length(classes);

    label = zeros([1,num_classes]);
    score = ones([1,num_classes]);
    
    copia = data(2,:);
    %% Pre-Processing stage
    % step 1: 
%     FilteredData = filtering(data,0.005,55,500,1);
%     FilteredData = FilteredData';

    %% Fourier Analysis 
    % Fourier_Analysis(data);
%      for i=1:12
%          error(i,:) = data(i,:)-Constructed_Signal(i,:);
%      end     
%      Fourier_Analysis(error); %- Verificar cambiando valores
    %% Wavelets Analysis  
%     Wavelet_Analysis(data,k);
    %% Features extraction
%     [ P_index, Q_index, R_index, S_index, T_index] = ecg_points( Constructed_Signal, 500 );
    % Use your classifier here to obtain a label and score for each class.
    features = get_12ECG_features(data,header_data);
    
    %% Signal plot
%      subplot(5,2,k);
%      for i = 1:12
%           plot(data(i,:)), hold on, grid on, xlabel('Frequency (Hz)'),
%           title(['Recording ',num2str(k)])
%      end
    %% end signal plot
    
    score = mnrval(model,features);		
    [~,idx] = max (score);
    label(idx)=1;
end
