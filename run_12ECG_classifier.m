function [score, label] = run_12ECG_classifier(data,header_data,classes, model,k)

    num_classes = length(classes);

    label = zeros([1,num_classes]);
    score = ones([1,num_classes]);
    
    copia = data(2,:);
    %% Fourier Analysis 
    % 
    % Fourier_Analysis(data);
    %% Wavelets Analysis  
    %Wavelet_Analysis(data);
    %%
    % Use your classifier here to obtain a label and score for each class.
    features = get_12ECG_features(data,header_data);
    
    
     subplot(5,2,k);
     for i = 1:12
          plot(data(i,:)), hold on, grid on, xlabel('Frequency (Hz)'),
          title(['Recording ',num2str(k)])
     end
    score = mnrval(model,features);		
    [~,idx] = max (score);
    label(idx)=1;
end
