function Wavelet_Analysis(data)

    for i=1:12
        % % Denoising wavelet using db 8 at 3 levels of decomposition/reconstruction
            [C,L] = wavedec(data(i,:),3,'sym6');  
            Constructed_Signal = wrcoef('a',C,L,'sym6',3);
            % Whether smoothing filter use instead:
            %Constructed_Signal = sgolayfilt(sNorm,3,41); %changing params 
            plot(Constructed_Signal),hold on
            
            % Error - Noise
            error = data(i,:) - Constructed_Signal;
            plot(error),grid on, title("Signals vs noise")
            
            figure
            %Plot Noise spectrum
            [P1,f1,f2,dP]= Fourier_Analysis_Gnral(error,i);
            %Method 1
            figure
            plot(f1,P1), grid on, title('Method 1:FOURIER ANALYSIS');
            legend('Signal Spectrum'),grid on
            %Method 3
            figure 
            plot(f2,dP), xlabel('Frequency(Hz)')
            legend('Signal')
            title('FORMA 3: PowSpect');
            grid on, axis([0 50 -10 150 ])
          
    end
    disp("listo")
end