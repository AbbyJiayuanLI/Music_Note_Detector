clear all;close all;clc;
%% 1. Read mp3 file
% [original_data,Fs] = audioread('sample_single_note.mp3');
[original_data,Fs] = audioread('sample_double_note.mp3');
data1 = original_data(:,1);
data2 = original_data(:,2);
length = size(original_data,1);

%% 2. Autocorrelation Function (ACF)
frame_size = 4900;
step_size = 1000;
step = round((length-frame_size)/step_size);
cut_off = 50;

for i = 0:step
    if i == step
        for tau = 1:frame_size-2
            acf_x(tau) = sum(data1(1+i*step_size:length-tau,:).*data1(1+tau+i*step_size:length,:));
        end
    else
        for tau = 1:frame_size-2
            acf_x(tau) = sum(data1(1+i*step_size:frame_size-tau+i*step_size,:).*data1(1+tau+i*step_size:frame_size+i*step_size,:));
        end
    end
    
    for j = 1:cut_off
        acf_x(j) = 0;
    end
    [~,index] = max(acf_x);
    note = index_to_note(index, Fs);
    detected_note(i+1) = note;
end

% glitch??????
detected_note_final = smoothdata(detected_note, 'movmedian', 3);
%% 3. Plot
% tau = 1:frame_size-2;
% plot(tau,acf_x)

plot(detected_note_final);

%% test by autocorr function

% [normalizedACF, lags] = autocorr(data1(1:400,:),'NumLags',300);
% plot(lags,normalizedACF)
