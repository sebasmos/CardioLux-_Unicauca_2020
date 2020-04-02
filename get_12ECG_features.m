function features = get_12ECG_features(data, header_data,k)

       % addfunction path needed
        addpath(genpath('Tools/'))
        addpath('ECG Feature Extractor [Shantanu V. Deshmukh]')
        load('HRVparams_12ECG','HRVparams')

	% read number of leads, sample frequency and gain from the header.	

	[recording,Total_time,num_leads,Fs,gain,age,sex]=extract_data_from_header(header_data);

	HRVparams.Fs=Fs;
        HRVparams.PeakDetect.windows = floor(Total_time-1);
        HRVparams.windowlength = floor(Total_time);

	try

                for i =1:num_leads
                        Lead12wGain(i,:) = data(i,:)* gain(i);
                end


                % median filter to remove bw
                for i=1:num_leads
                  
                    Constructed_Signal(i,:) = medianfilter(Lead12wGain(i,:)', Fs);
                  % ECG_Analysis(Lead12wGain(i,:)',500,0.5,5)
                  
                  
                      % ECG12filt(i,:) = sgolayfilt(Lead12wGain(i,:)',3,25);
                %ECG12filt(i,:) = medianfilter(Lead12wGain(i,:)', Fs);
%                 % wavelets without thresholding
%                 [C,L] = wavedec(Lead12wGain(i,:)',2,'db4');  
%                 % approx = appcoef(L,C,'sym4');
%                 % [cd1,cd2,cd3] = detcoef(C,L,[1 2 3]);
%                Constructed_Signal(i,:) = wrcoef('a',C,L,'db4',2);
%                 %% Denoising wavelet using thresholding and N decom/construnction levels
%                  [C,L] = wavedec(Lead12wGain(i,:)',2,'db8'); 
%                  [thr,sorh,keepapp]=ddencmp('den','wv',Lead12wGain(i,:)');
%                  Constructed_Signal(i,:)=wdencmp('gbl',C,L,'db8',2,thr,sorh,keepapp);
%                  disp('wait')
                % Constructed_Signal(i,:) = detrend(A3);
                %% Denoising stage using Empirical Decomposition Method (EMD)
%               cleanedSignal = emd_dfadenoising (data);
%               Constructed_Signal(i,:) = cleanedSignal(i,:)';
                %% Smoothing using Savitzky	
                %Constructed_Signal(i,:) = sgolayfilt(data(i,:),3,25);
                % Denoising stage using moving median smoothing filter
%                 A3  = movmedian(Araw,11);
%                 cleanedSignal = detrend(A3);%consider using detrending?
                    
                end

                % convert 12Leads to XYZ leads using Kors transformation
                XYZLeads = Kors_git(Constructed_Signal);

                VecMag = vecnorm(XYZLeads');


                % Convert ECG waveform in rr intervals
                [t, rr, jqrs_ann, SQIvalue , tSQI] = ConvertRawDataToRRIntervals(VecMag, HRVparams, recording);
                sqi = [tSQI', SQIvalue'];

                % Find fiducial points using ECGKit
                ECG_header.nsig = 1; ECG_header.freq = Fs; ECG_header.nsamp = length(VecMag);
                wavedet_config.setup.wavedet.QRS_detection_only = 0;
                [Fid_pts,~,~] = wavedet_3D_ECGKit(VecMag', jqrs_ann', ECG_header, wavedet_config);

                [XYZ_Median,Fid_pts_Median] = Time_coherent_code_github(XYZLeads,Fid_pts,Fs);

                GEH_features = GEH_analysis_git(XYZ_Median,Fid_pts_Median,Fs);
                % Additional ECG-Features
                features1 = [];
                for i=1:12
                    [meanRR,rmssd,nn50,pNN50,sd_RR,pse,average_hrv]= getECGFeatures(Constructed_Signal(i,:));
                    a = [meanRR rmssd nn50 pNN50 sd_RR pse average_hrv];
                    features1  = [features1 a ];
                end
                % Atrial Fibrillation Features
%                 b = ECG_Analysis(data,500)
                features2 = [];
                AF_Features = ECG_Analysis(Constructed_Signal,500);
                for i=1:12
                    b = [AF_Features(i,1) AF_Features(i,2) AF_Features(i,3:end)];
                    features2  = [features2 b ];
                end
                
                features(1)=age;
                features(2)=sex;
                features(3:24)=GEH_features;
                %12-leads/features per row
                features(25:108)= features1;
                %12-leads/AF features
                features(109:300) = features2;
               

	catch
		features = NaN(1,24);
	end

end




%% Filtering
% function Features = ECG_Analysis(ECG,fs,f1,f2)
% [a b] = size(ECG);
%     for i = 1 : a
%         ECGF = Preprocessing(ECG(i,:),fs,f1,f2);
%         [QRSSignal,QPeak,QLoc,RPeak,RLoc,SPeak,SLoc] = findQRS(ECGF,fs);
%         [QRSInterval0,RRInterval0,RR_Region0] = findMeanRRQRS(QLoc,RLoc,SLoc,fs);
%         aux1(i,1)=QRSInterval0;
%         aux1(i,2)=RRInterval0;
%         aux2(i,:)=AF_features(RR_Region0,fs);
%     end
%     Features=[aux1 aux2];
% end


