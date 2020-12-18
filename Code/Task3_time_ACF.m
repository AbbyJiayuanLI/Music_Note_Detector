clear;close all;clc;
tic
%% 1. Read mp3 file
[original_data,Fs] = audioread('music_fur_elise.mp3');
data1 = original_data(1:20.25*44100,1);
data2 = original_data(1:20.25*44100,2);

downSampleFactor = 1;
if downSampleFactor >1
    lpf = fir1(64, 1/downSampleFactor, 'low');
    data1 = filter(lpf, 1, data1);
    data1 = resample(data1, 1, downSampleFactor);
    Fs = Fs/downSampleFactor;
end
data_length = size(data1,1);
%% 2. Auto Correlation Function (ACF)
frame_size = round(3000/downSampleFactor);
step_size = round(500/downSampleFactor);
step = round((data_length-frame_size)/step_size);
cut_off = round(50/downSampleFactor);
energy_threshold = 0.0001;
delay = round(2300/downSampleFactor);

for i = 0:step   
    % framing
    if i == step
        data = data1(1+i*step_size:data_length,:);
        window = hamming(data_length-i*step_size);
    else
        data = data1(1+i*step_size:frame_size+i*step_size,:); 
        window = hamming(frame_size);
    end
    
    % check if noise
    if sum(data.^2)/size(data,1) < energy_threshold
        detected_note(i+1) = NaN;
    else
        data = data.*window;
        [acf_x, lags] = autocorr(data,'NumLags',delay);

        acf_x(1:cut_off) = acf_x(cut_off);
        [~,index] = max(acf_x);

        note = freq2note(Fs/(index-1)); % note that here delay start from 0, so need to minus 1
        detected_note(i+1) = note;
    end
end

% smoothing
% detected_note_final = detected_note;
detected_note_final = smoothdata(detected_note, 'movmedian', 15);
detected_note_final = reshape(detected_note_final,[length(detected_note_final) 1]);

toc
%% 3. Plot
error = errorRate(detected_note_final, 'ACF', 20.25);

% time = (0:step)*step_size/Fs;
% acf_detected_note_final = detected_note_final;
% acf_t = time;

%% 4. Sound

% music = note2music(detected_note_final, Fs, length);
% sound(music, Fs); 

% sound(original_data, fs);

%% Short-time Fourier Transformation (STFT)

% stft(data1, Fs, 'Window', kaiser(4900,5), 'OverlapLength', 3000, 'FFTLength', 9000);
% 
% ylim([-1,1])
% view(-45,65)
% colormap jet

