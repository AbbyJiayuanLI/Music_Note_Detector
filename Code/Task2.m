clc
clear

[music, fs] = audioread('music_fur_elise.mp3');
music = music(:,1);   % one channel

N = length(music);    % length of the song
n = 0:N-1;
t = n/fs;

% fs=4410;
% N=44100;
% n=0:N-1;
% t=n/fs;
% music = 0.5*sinc(2*pi*20*t);
% figure(1);
% 
% subplot(211);
% plot(t,music); 
% title('Time Domain');
% xlabel('Time [sec]');ylabel('Amplitude');
% Y=fftshift(fft(music,N));
% subplot(212);
% f=n*fs/N-fs/2;
% Yf=abs(Y);
% plot(f,Yf);
% % axis([0,fs/5,0,10000]);
% title('Magnitude Spectrum ');

data = (fftshift(fft(music,N)));
f = n*fs/N-fs/2;
[data1, fs1, f1] = returnReSampled(music, fs, 1, 4);
[data2, fs2, f2] = returnReSampled(music, fs, 1, 10);
[data3, fs3, f3] = returnReSampled(music, fs, 1, 25);

[re_data1, re_fs1, re_f1] = returnReSampled(ifft(ifftshift(data1)), fs1, 4, 1);
[re_data2, re_fs2, re_f2] = returnReSampled(ifft(ifftshift(data2)), fs2, 10, 1);
[re_data3, re_fs3, re_f3] = returnReSampled(ifft(ifftshift(data3)), fs3, 25, 1);

% sound(ifft(ifftshift(data)), fs);
limit = 4e3;
figure(2);
subplot(411);
plot(f, abs(data));set(gca, 'fontsize', 10);grid on
xlim([-limit, limit]);
title('Original');
subplot(412);
plot(f1, abs(data1));set(gca, 'fontsize', 10);grid on
xlim([-limit, limit]);
title('With Sampling Frequency of f_s/4');
subplot(413);
plot(f2, abs(data2));set(gca, 'fontsize', 10);grid on
xlim([-limit, limit]);
title('With Sampling Frequency of f_s/10');
subplot(414);
plot(f3, abs(data3));set(gca, 'fontsize', 10);grid on
xlim([-limit, limit]);
title('With Sampling Frequency of f_s/25');

% limit = 1e4;
figure(3);
subplot(411);
plot(f, abs(data));set(gca, 'fontsize', 10);grid on
xlim([-limit, limit]);
title('Original');
subplot(412);
plot(re_f1, abs(re_data1));set(gca, 'fontsize', 10);grid on
xlim([-limit, limit]);
title('Reconstruction with Sampling Frequency of f_s/4');
subplot(413);
plot(re_f2, abs(re_data2));set(gca, 'fontsize', 10);grid on
xlim([-limit, limit]);
title('Reconstruction with Sampling Frequency of f_s/10');
subplot(414);
plot(re_f3, abs(re_data3));set(gca, 'fontsize', 10);grid on
xlim([-limit, limit]);
title('Reconstruction with Sampling Frequency of f_s/25');

function[reSampledData, fs_, f_] = returnReSampled(data, fs, ups, dns)
% anti-aliasing
if (ups/dns < 1)
    lpf = fir1(34,1/(dns/ups),'low');
    data = filter(lpf,1,data);
%     data = lowpass(data,fs/(dns/ups)/2,fs);
end
reSample = resample(data,ups,dns);
N=length(reSample);
fs_ = fs*ups/dns;
n=0:N-1;
f_=n*fs_/N-fs_/2;
reSampledData = (fftshift(fft(reSample,N)));
end