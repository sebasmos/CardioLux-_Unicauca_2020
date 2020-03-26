function [score, label] = run_12ECG_classifier(data,header_data,classes, model,k)

    num_classes = length(classes);

    label = zeros([1,num_classes]);
    score = ones([1,num_classes]);
    
    copia = data(2,:);
    %% Pre-Processing stage
    % step 1: 
%     FilteredData = filtering(data,0.005,55,500,1);
%     FilteredData = FilteredData';
        for i =1:12
                %% wavelets without thresholding
%                [C,L] = wavedec(data(i,:),2,'sym4');  
                 % approx = appcoef(L,C,'sym4');
                 % [cd1,cd2,cd3] = detcoef(C,L,[1 2 3]);
%               Constructed_Signal(i,:) = wrcoef('a',C,L,'sym6',3);
                %% Denoising wavelet using thresholding and N decom/construnction levels
                % [C,L] = wavedec(data(i,:),4,'db10'); 
                % [thr,sorh,keepapp]=ddencmp('den','wv',data(i,:));
                % A3=wdencmp('gbl',C,L,'db10',4,thr,sorh,keepapp);
                % Constructed_Signal(i,:) = detrend(A3);
                %% Denoising stage using Empirical Decomposition Method (EMD)
%               cleanedSignal = emd_dfadenoising (data);
%               Constructed_Signal(i,:) = cleanedSignal(i,:)';
                %% Smoothing using Savitzky
                Constructed_Signal(i,:) = sgolayfilt(data(i,:),3,25);
                % Denoising stage using moving median smoothing filter
%                 A3  = movmedian(Araw,11);
%                 cleanedSignal = detrend(A3);%consider using detrending?
                
        end
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
    features = get_12ECG_features(Constructed_Signal,header_data);
    
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
