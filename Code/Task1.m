clear all;close all;clc;
%% 1. Read mp3 file
[original_data,Fs] = audioread('music_fur_elise.mp3');
data1 = original_data(1:20.25*44100,1);
data2 = original_data(1:20.25*44100,2);

%% 2. Draw waveform and amplitude spectrum
length = size(data1,1);
T= 1/Fs;
time = 0:T:T*(length-1);

Fx1 = fft(data1);
Fx1 = fftshift(Fx1);
f = Fs*((-(length-1)/2):((length-1)/2))/length;

subplot(1,2,1)
plot(time, data1)
title('Waveform in time Domain')
xlabel('Time (s)')
ylabel('Amplitude')
% axis square;
subplot(1,2,2)
plot(f, abs(Fx1))
xlim([-5000,5000])
title('Amplitude Spectrum in frequency domain')
xlabel('Frequency (Hz)')
ylabel('Amplitude')
%% 

% extra code if draw two channels at the same time

% Fx2 = fft(data2);
% Fx2 = fftshift(Fx2);
% 
% subplot(2,2,1)
% plot(time, data1)
% title('Waveform')
% % axis square;
% subplot(2,2,2)
% plot(f, abs(Fx1))
% ylim([0, 6000])
% title('Amplitude Spectrum')
% subplot(2,2,3)
% plot(time, data2)
% title('Waveform')
% % axis square;
% subplot(2,2,4)
% plot(f, abs(Fx2))
% ylim([0, 6000])
% title('Amplitude Spectrum')