function h = cic_compensator(R,N,Fs,Fc,L,plot_flag)
    %% input params
    M = 1;
    if nargin < 5
        R = 64;
        N = 5;
        Fs = 48000;
        Fc = 20000;
        L = 100;
    end
    if nargin < 6
        plot_flag = false;
    end
    %% desigen filter
    Fo = Fc/Fs; 
    p = 2e3; 
    s = 0.25/p; 
    fp = [0:s:Fo]; 
    fs = (Fo+s):s:0.5; 
    f = [fp fs]*2;
    Mp = ones(1,length(fp)); 
    Mp(2:end) = abs(M*R*sin(pi*fp(2:end)/R)./sin(pi*M*fp(2:end))).^N; %
    Mf = [Mp zeros(1,length(fs))];
    f(end) = 1;
    h = fir2(L,f,Mf); %% Filter length L+1
    %% plot 
    if(plot_flag)
        [hh,ff] = freqz(h,1,length(f),Fs);
        mag = abs(hh);
        figure
        hold on
        plot(f,20*log10(Mf + eps),'-b')
        hold on
        plot(ff./Fs * 2,20 *log10(mag),'-k')
    end
end

