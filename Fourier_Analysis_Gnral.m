function [P1,f1,f2,dP] = Fourier_Analysis_Gnral(data,i)
    Fs = 500;
    %FORMA 1
    signal = fft(data(i,:));
    L = length(data);
    P2 = abs(signal/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f1 = Fs*(0:(L/2))/L;   
    % FORMA 3
    [~,~,f2,dP] = centerfreq(Fs,data(i,:)); %SEÑAL NORMAL
    [PS,NN] = PowSpecs(data(i,:));
end