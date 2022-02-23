%% Brief: Matlab code, convert pdm signal to pcm signal using cic
%% Author: myuzhao@163.com
clear
close all
N = 5; %CIC Cascade order
f = 16000;
fs = 48000;
R = 64;
fs_clock = R * fs;
t_all = 3;%/1000;
t = 1/fs:1/fs:t_all;
data = sin(2*pi*f*t);
data = data(:);
over_coeff = R;
data_oversample = resample(data,over_coeff,1);
fs_oversample = fs * over_coeff;
t_oversample = 1/fs_oversample:1/fs_oversample:t_all;
fs_pcm = fs;
t_pcm = 1/fs_pcm:1/fs_pcm:t_all;

%% 1.generate pdm signal from data oversample
len = length(data_oversample);
th = 0;
for i = 1:len
    if(data_oversample(i)> th)
        data_pdm(i) = 1;
    else
        data_pdm(i) = -1;
    end
    th = data_pdm(i) - data_oversample(i) + th;
end

% figure
% plot(t,data,'b');
% hold on
% plot(t_oversample,data_pdm,'r')

% legend('raw\_data','pdm\_data')

%% 2. recovery raw data form pdm_data using resample 
% data_pcm = resample(data_pdm,1,over_coeff);
% figure
% plot(t,data,'b')
% hold on
% plot(t_pcm,data_pcm,'--r');

%% 3. cic 
data_cic = cic(data_pdm,R,N);
% sound(data_cic,fs)
% audiowrite('cic_out.wav',data_cic,fs);

% figure
% plot(data_cic,'r');
% hold on
% plot(data,'b');
%% 4. cic compensator
fc = 23000;
filter_len = 50;
h = cic_compensator(R,N,fs,fc,filter_len,0);
data_cic_comp = filter(h,1,data_cic);
%% 5. plot
figure
plot(t,data,'b')
hold on
plot(t,data_cic,'--r')
plot(t,data_cic_comp,'-*g')
% ylim([-2 2])
legend("data-raw","data-cic-nocomp","data-cic-comp");