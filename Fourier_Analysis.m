function  P1 = Fourier_Analysis(data)

    Fs = 500;
    %FORMA 1
for i = 1 : 12
    %FORMA 1
    signal = fft(data(i,:));
    L = length(data);
    P2 = abs(signal/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = Fs*(0:(L/2))/L;
    figure
    plot(f,P1), grid on, title('Method 1:FOURIER ANALYSIS');
    legend('Signal Spectrum')
    grid on, axis([0 50 -1 50 ]) 

    % FORMA 2
    figure
    Res = 10; 
    Npuntos = 2^nextpow2(Fs/2/Res);
    w = hanning(Npuntos);
    [Pf,Ff]=pwelch(data(i,:),w,Npuntos/2,Npuntos,Fs); 
    pwelch(data(i,:),w,Npuntos/2,Npuntos,Fs),
    legend('Signal')
    title('FORMA 2: pwelch')
    axis([0 500 -40 35])
    
    % FORMA 3
    [~,~,f,dP] = centerfreq(Fs,data(i,:)); %SEÑAL NORMAL
    [PS,NN] = PowSpecs(data(i,:));
    figure
    plot(f,dP), xlabel('Frequency(Hz)')
    legend('Signal')
    title('FORMA 3: PowSpect');
    grid on, axis([0 50 -10 150 ])
end