% ECG: Señales ECG con 12 derivaciones.
% Input:
% fs: Frecuencias de muestreo (500Hz)
% f1: Frecuencia de corte pasa altas (0.5Hz);
% f2: Frecuencias de corte pasa bajas (5Hz)
% Features=[QRSInterval(escalar) RRInterval (escalar) RR_Region (vector)]
function Features = ECG_Analysis(ECG,fs)
[a b] = size(ECG);
    for i = 1 : a
%          ECGF = Preprocessing(ECG(i,:),fs,f1,f2); %neglect filtering
        [QRSSignal,QPeak,QLoc,RPeak,RLoc,SPeak,SLoc] = findQRS(ECG(i,:),fs);
        [QRSInterval0,RRInterval0,RR_Region0] = findMeanRRQRS(QLoc,RLoc,SLoc,fs);
        aux1(i,1)=QRSInterval0;
        aux1(i,2)=RRInterval0;
        aux2(i,:)=AF_features(RR_Region0,fs);
    end
    Features=[aux1 aux2];
end

% function ECGF = Preprocessing(ECG,fs,f1,f2)
%     Number_of_order = 100;
% 
%     %Number of filters
%     N = 3;
%     total_zeros = (Number_of_order)*N;
% 
%     %Appending zeros to cancel out group delay
%     ECG = [ECG zeros(1,total_zeros)];
%     ECGF=0;
% 
%     %High pass filter-fc=f1
%     b=fir1(Number_of_order,f1/(2*fs),'high');
%     ECGF = ECGF + 25*filter(b,1,5*ECG);
%     %Low pass - cut-off f2 Hz
%     b=fir1(Number_of_order,f2/(2*fs));
%     ECGF = ECGF + filter(b,1,ECG);
% 
%     %To remove power-line noise - 
%     %100 coefficient FIR stopband filter 59.95 Hz-60.05 Hz 
%     bandstop_100 = [0.000261250076794666,-0.000261900362214270,-0.000525076606165565,-0.000263163851507842,0.000263776960520398,0.000528755168156876,0.000264965677070068,-0.000265541195318743,-0.000532208191171410,-0.000266654335574226,0.000267191873933590,0.000535433340523649,0.000268228685109245,-0.000268727879982831,-0.000538428434695909,-0.000269687660632511,0.000270148174230353,0.000541191447005755,0.000271030274783530,-0.000271451795379894,-0.000543720507153249,-0.000272255618637699,0.000272637860809924,0.000546013902649643,0.000273362862401081,-0.000273705567247171,-0.000548070080127131,-0.000274351256044557,0.000274654191381137,0.000549887646524771,0.000275220129877241,-0.000275483090417148,-0.000551465370154558,-0.000275968895058024,0.000276191702567049,0.000552802181641874,0.000276597044045659,-0.000276779547479204,-0.000553897174743603,-0.000277104150987441,0.000277246226605518,0.000554749607041532,0.000277489872044696,-0.000277591423506837,-0.000555358900509558,-0.000277753945654961,0.000277814904093941,0.000555724641955639,0.000277896192733116,-0.000277916516807400,0.999968003425341,-0.000277916516807400,0.000277896192733116,0.000555724641955639,0.000277814904093941,-0.000277753945654961,-0.000555358900509558,-0.000277591423506837,0.000277489872044696,0.000554749607041532,0.000277246226605518,-0.000277104150987441,-0.000553897174743603,-0.000276779547479204,0.000276597044045659,0.000552802181641874,0.000276191702567049,-0.000275968895058024,-0.000551465370154558,-0.000275483090417148,0.000275220129877241,0.000549887646524771,0.000274654191381137,-0.000274351256044557,-0.000548070080127131,-0.000273705567247171,0.000273362862401081,0.000546013902649643,0.000272637860809924,-0.000272255618637699,-0.000543720507153249,-0.000271451795379894,0.000271030274783530,0.000541191447005755,0.000270148174230353,-0.000269687660632511,-0.000538428434695909,-0.000268727879982831,0.000268228685109245,0.000535433340523649,0.000267191873933590,-0.000266654335574226,-0.000532208191171410,-0.000265541195318743,0.000264965677070068,0.000528755168156876,0.000263776960520398,-0.000263163851507842,-0.000525076606165565,-0.000261900362214270,0.000261250076794666];
%     %Removing zeros to cancel out group delay
%     ECGF = ECGF + filter(bandstop_100,1,ECG);
%     start_remove = Number_of_order/2;
%     end_remove = total_zeros-start_remove;
%     ECGF = ECGF(start_remove+1:end-end_remove);
% end

function [QRSSignal,QPeak,QLoc,RPeak,RLoc,SPeak,SLoc] = findQRS(ECGF,fs)
QRS_Interval=0.09;
%Look_samples -> how many samples do we look on each side of R peak
Look_samples = floor((fs*QRS_Interval)/2);
QRSSignal=mean(ECGF)*ones(1,length(ECGF));

%Finding R peaks
[RPeak,RLoc] = findpeaks(ECGF,'MinPeakHeight',.5,'MinPeakDistance',200);
y=5;
%Adding zeros at the start and end of signal to maintain dimesnions right
%for detection of Q and S peaks
ECGF = [zeros(1,Look_samples) ECGF zeros(1,Look_samples)];

%All R-peaks location will be shifted as well
RLoc = RLoc + Look_samples;

%Loop for finding Q and S peaks
for i=1:length(RLoc)
   [QPeak(i), Qi] = min(ECGF(RLoc(i)-Look_samples:RLoc(i)));
   [SPeak(i), Si] = min(ECGF(RLoc(i):RLoc(i)+Look_samples));
   QLoc(i) = RLoc(i)-Look_samples+Qi-1;
   SLoc(i) = RLoc(i)+Si-1;
   QRSSignal(QLoc(i):SLoc(i)) = ECGF(QLoc(i):SLoc(i));
end

%Shift back all Q R S peaks' locations
RLoc = RLoc - Look_samples;
QLoc = QLoc - Look_samples;
SLoc = SLoc - Look_samples;
    
end

function [QRSInterval,RRInterval,RR_Region] = findMeanRRQRS(QLoc,RLoc,SLoc,fs)
    for k=1:length(RLoc)-1
      RR_Region(k) = RLoc(k+1)-RLoc(k);
    end
    QRS_Region = SLoc - QLoc;
    QRSInterval = mean((QRS_Region/fs));
    RRInterval = mean((RR_Region/fs));
end

function features = AF_features(RR,fs)
%******************************************************
% $ This function is for calculating the common AF features
%
% $ Reference: Q. Li, C. Y. Liu, J. Oster and G. D. Clifford. Chapter:
% Signal processing and feature selection preprocessing for classification
% in noisy healthcare data. In book: Machine Learning for Healthcare
% Technologies, Edition: 1st, Publisher: IET, Editors: David A. Clifton,
% 2016.
%
% $ Variable declaration: 
%   Input:
%   RR:     RR interval time series (RR interval uses the unit of sample
%           points), RR time series are expected with the number of heart
%           beats range between 12 and 60. 
%   fs:     ECG sample rate 
%   Output:
%   features: AF features
%
% $ Author:  Chengyu Liu (chengyu.liu@emory.edu)
%           Department of Biomedical Informatics, Emory University, US
% $Last updated:  2016.10.28
% 
% %   LICENSE:    
%       This software is offered freely and without warranty under 
%       the GNU (v3 or later) public license. See license file for
%       more information
%%
[nr,nc]=size(RR);
if nr<nc
    RR=RR';
end

M=floor(length(RR)/3);
RR=RR(1:3*M);
N=3*M;
if N<12 || N>60
    fprintf('Please input a RR interval time series with beat number between 12 and 60 \n');
end
m=1;
r=0.1;
%% time-domain features
mRR=mean(RR/fs);
minRR=min(RR/fs);
maxRR=max(RR/fs);
medHR=median(fs*60./RR);
SDNN=std(RR/fs);
dRR=diff(RR)/fs;
k=0;
sm=0;
for t=1:length(dRR)
    sm=sm+dRR(t).^2;
    if abs(dRR(t))>0.05
        k=k+1;
    end
end
PNN50=k/length(dRR)*100;
RMSSD=sqrt(sm/length(dRR));

%% frequency-domain features
p=6; % pole setting,
mhrf=1/mRR;
[P,f]=pburg(RR,p,[ ],[mhrf]); % using burg method
P(1)=P(2);
space=f(2)-f(1);
LF = sum(P(find( (0.04 <= f) & (f <= 0.15) )))*space;
HF = sum(P(find( (0.15  < f) & (f <= 0.40) )))*space;
Ratio_LH = LF/HF;
LFn = LF/(LF+HF);
HFn = HF/(LF+HF);

%% non-linear features
COSEn2 = COSEn(RR*1000/fs,m,30,fs);
COFMEn2 = COFMEn(RR*1000/fs,m,30,fs);
MAD= comput_MAD(RR*1000/fs);
AFEv = comput_AFEv2(RR/fs);

%% output features
features=[mRR minRR maxRR medHR SDNN PNN50 RMSSD LFn HFn Ratio_LH COSEn2 COFMEn2 MAD AFEv];
end