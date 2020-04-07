function SelectedFeat = get_12ECG_features_v2(data, header_data,k)

       % addfunction path needed
        addpath(genpath('Tools/'))
        addpath('ECG Feature Extractor [Shantanu V. Deshmukh]')
        load('HRVparams_12ECG','HRVparams')

	% read number of leads, sample frequency and gain from the header.	

	[recording,Total_time,num_leads,Fs,gain,age,sex,dx]=extract_data_from_header(header_data);

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
%                 Constructed_Signal(i,:) = Preprocessing(Lead12wGain(i,:),500,0.5,5);
                                  
%                       Constructed_Signal(i,:) = sgolayfilt(Lead12wGain(i,:)',3,25);
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
                features(301)=dx;
                %% Feature Selection
                SelectedFeat(1:2)= features(1:2);
                SelectedFeat(3) = features(4);
                SelectedFeat(4) = features(5);
                SelectedFeat(5) = features(6);
                SelectedFeat(6) = features(7);
                SelectedFeat(7) = features(8);
                SelectedFeat(8) = features(10);
                SelectedFeat(9) = features(12);
                SelectedFeat(10) = features(13);
                
                SelectedFeat(11) = features(14);
                SelectedFeat(12) = features(17);
                SelectedFeat(13) = features(18);
                SelectedFeat(14) = features(19);
                SelectedFeat(15) = features(20);
                SelectedFeat(16) = features(22);
                SelectedFeat(17) = features(23);
                SelectedFeat(18) = features(24);
                SelectedFeat(19) = features(25);
                SelectedFeat(20) = features(30);
                
                SelectedFeat(21) = features(35);
                SelectedFeat(22) = features(37);
                SelectedFeat(23) = features(39);
                SelectedFeat(24) = features(44);
                SelectedFeat(25) = features(49);
                SelectedFeat(26) = features(51);
                SelectedFeat(27) = features(58);
                SelectedFeat(28) = features(65);
                SelectedFeat(29) = features(70);
                SelectedFeat(30) = features(72);
                
                
                SelectedFeat(31) = features(77);
                SelectedFeat(32) = features(79);
                SelectedFeat(33) = features(84);
                SelectedFeat(34) = features(86);
                SelectedFeat(35) = features(91);
                SelectedFeat(36) = features(93);
                SelectedFeat(37) = features(98);
                SelectedFeat(38) = features(100);
                SelectedFeat(39) = features(105);
                SelectedFeat(30) = features(107);
                
                
                SelectedFeat(41) = features(131);
                SelectedFeat(42) = features(157);
                SelectedFeat(43) = features(196);
                SelectedFeat(44) = features(205);
                SelectedFeat(45) = features(207);
                SelectedFeat(46) = features(211);
                SelectedFeat(47) = features(212);
                SelectedFeat(48) = features(218);
                SelectedFeat(49) = features(223);
                SelectedFeat(40) = features(227);
                
                
                SelectedFeat(51) = features(228);
                SelectedFeat(52) = features(233);
                SelectedFeat(53) = features(237);
                SelectedFeat(54) = features(243);
                SelectedFeat(55) = features(244);
                SelectedFeat(56) = features(249);
                SelectedFeat(57) = features(253);
                SelectedFeat(58) = features(265);
                
                % Class for 
                SelectedFeat(59) = features(301);

	catch
		features = NaN(1,301);
	end

end

function ECGF = Preprocessing(ECG,fs,f1,f2)
    Number_of_order = 100;

    %Number of filters
    N = 3;
    total_zeros = (Number_of_order)*N;

    %Appending zeros to cancel out group delay
    ECG = [ECG zeros(1,total_zeros)];
    ECGF=0;

    %High pass filter-fc=f1
    b=fir1(Number_of_order,f1/(2*fs),'high');
    ECGF = ECGF + 25*filter(b,1,5*ECG);
    %Low pass - cut-off f2 Hz
    b=fir1(Number_of_order,f2/(2*fs));
    ECGF = ECGF + filter(b,1,ECG);

    %To remove power-line noise - 
    %100 coefficient FIR stopband filter 59.95 Hz-60.05 Hz 
    bandstop_100 = [0.000261250076794666,-0.000261900362214270,-0.000525076606165565,-0.000263163851507842,0.000263776960520398,0.000528755168156876,0.000264965677070068,-0.000265541195318743,-0.000532208191171410,-0.000266654335574226,0.000267191873933590,0.000535433340523649,0.000268228685109245,-0.000268727879982831,-0.000538428434695909,-0.000269687660632511,0.000270148174230353,0.000541191447005755,0.000271030274783530,-0.000271451795379894,-0.000543720507153249,-0.000272255618637699,0.000272637860809924,0.000546013902649643,0.000273362862401081,-0.000273705567247171,-0.000548070080127131,-0.000274351256044557,0.000274654191381137,0.000549887646524771,0.000275220129877241,-0.000275483090417148,-0.000551465370154558,-0.000275968895058024,0.000276191702567049,0.000552802181641874,0.000276597044045659,-0.000276779547479204,-0.000553897174743603,-0.000277104150987441,0.000277246226605518,0.000554749607041532,0.000277489872044696,-0.000277591423506837,-0.000555358900509558,-0.000277753945654961,0.000277814904093941,0.000555724641955639,0.000277896192733116,-0.000277916516807400,0.999968003425341,-0.000277916516807400,0.000277896192733116,0.000555724641955639,0.000277814904093941,-0.000277753945654961,-0.000555358900509558,-0.000277591423506837,0.000277489872044696,0.000554749607041532,0.000277246226605518,-0.000277104150987441,-0.000553897174743603,-0.000276779547479204,0.000276597044045659,0.000552802181641874,0.000276191702567049,-0.000275968895058024,-0.000551465370154558,-0.000275483090417148,0.000275220129877241,0.000549887646524771,0.000274654191381137,-0.000274351256044557,-0.000548070080127131,-0.000273705567247171,0.000273362862401081,0.000546013902649643,0.000272637860809924,-0.000272255618637699,-0.000543720507153249,-0.000271451795379894,0.000271030274783530,0.000541191447005755,0.000270148174230353,-0.000269687660632511,-0.000538428434695909,-0.000268727879982831,0.000268228685109245,0.000535433340523649,0.000267191873933590,-0.000266654335574226,-0.000532208191171410,-0.000265541195318743,0.000264965677070068,0.000528755168156876,0.000263776960520398,-0.000263163851507842,-0.000525076606165565,-0.000261900362214270,0.000261250076794666];
    %Removing zeros to cancel out group delay
    ECGF = ECGF + filter(bandstop_100,1,ECG);
    start_remove = Number_of_order/2;
    end_remove = total_zeros-start_remove;
    ECGF = ECGF(start_remove+1:end-end_remove);
end
% 