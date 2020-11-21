clear all;close all;clc;
%% 1. Read mp3 file
[original_data,Fs] = audioread('sample_single_note.mp3');
% [original_data,Fs] = audioread('sample_single_note.mp3', [10000,11000]);
data1 = original_data(:,1);
data2 = original_data(:,2);

%% 2. Draw waveform and amplitude spectrum
% length = size(original_data,1);
% T= 1/Fs;
% time = 0:T:T*(length-1);
% 
% Fx1 = fft(data1);
% Fx1 = fftshift(Fx1);
% f = Fs*((-(length-1)/2):((length-1)/2))/length;
% 
% subplot(1,2,1)
% plot(time, data1)
% title('Waveform')
% % axis square;
% subplot(1,2,2)
% plot(f, abs(Fx1))
% title('Amplitude Spectrum')

length = size(original_data,1);
T= 1/Fs;
time = 0:T:T*(length-1);

Fx1 = fft(data1);
Fx1 = fftshift(Fx1);
Fx2 = fft(data2);
Fx2 = fftshift(Fx2);
f = Fs*((-(length-1)/2):((length-1)/2))/length;

subplot(2,2,1)
plot(time, data1)
title('Waveform')
% axis square;
subplot(2,2,2)
plot(f, abs(Fx1))
ylim([0, 6000])
title('Amplitude Spectrum')
subplot(2,2,3)
plot(time, data2)
title('Waveform')
% axis square;
subplot(2,2,4)
plot(f, abs(Fx2))
ylim([0, 6000])
title('Amplitude Spectrum')