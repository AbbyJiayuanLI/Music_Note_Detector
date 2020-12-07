clear all;close all;clc;

%% 1. Read mp3 file
[original_data,Fs] = audioread('sample_single_note.mp3');
% [original_data,Fs] = audioread('sample_double_note.mp3');
data1 = original_data(:,1);
data2 = original_data(:,2);
length = size(original_data,1);

%% 2. Discrete Wavelet Transform (DWT)
[c,l] = wavedec(data1(1:1000),5,'db2');
approx = appcoef(c,l,'db2');
[cd1,cd2,cd3,cd4,cd5] = detcoef(c,l,[1 2 3 4 5]);

subplot(6,1,1)
plot(approx)
title('Approximation Coefficients')
subplot(6,1,2)
plot(cd5)
title('Level 5 Detail Coefficients')
subplot(6,1,3)
plot(cd4)
title('Level 4 Detail Coefficients')
subplot(6,1,4)
plot(cd3)
title('Level 3 Detail Coefficients')
subplot(6,1,5)
plot(cd2)
title('Level 2 Detail Coefficients')
subplot(6,1,6)
plot(cd1)
title('Level 1 Detail Coefficients')