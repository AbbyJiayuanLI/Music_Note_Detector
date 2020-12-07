clear all;close all;clc;

%% 1. Read mp3 file
[original_data,Fs] = audioread('sample_single_note.mp3');
% [original_data,Fs] = audioread('sample_double_note.mp3');
data1 = original_data(:,1);
data2 = original_data(:,2);
length = size(original_data,1);

%% 2. Auto Correlation Function (ACF)
frame_size = 4900;
step_size = 1000;
step = round((length-frame_size)/step_size);
cut_off = 50;

for i = 0:step
%     if i == step
%         for tau = 1:frame_size-2
%             acf_x(tau) = sum(data1(1+i*step_size:length-tau,:).*data1(1+tau+i*step_size:length,:));
%         end
%     else
%         for tau = 1:frame_size-2
%             acf_x(tau) = sum(data1(1+i*step_size:frame_size-tau+i*step_size,:).*data1(1+tau+i*step_size:frame_size+i*step_size,:));
%         end
%     end
    
    if i == step
        [acf_x, lags] = autocorr(data1(1+i*step_size:length,:),'NumLags',frame_size-2);
    else
        [acf_x, lags] = autocorr(data1(1+i*step_size:frame_size+i*step_size,:),'NumLags',frame_size-2); 
    end
    
    i

    acf_x(1:cut_off) = acf_x(cut_off);
% %     peak_range = (max(acf_x)-min(acf_x))/1.5;
%     [~,locs] = findpeaks(acf_x, 'MinPeakHeight', 0.3);   
%     index = locs(1);
    [~,index] = max(acf_x);

    
    note = index_to_note(index, Fs);
    detected_note(i+1) = note;
end

% glitch??????
detected_note_final = detected_note;
% detected_note_final = smoothdata(detected_note, 'movmedian', 3);
%% 3. Plot
time = (0:step)*step_size/Fs;
plot(detected_note_final);


%% Short-time Fourier Transformation (STFT)

% stft(data1, Fs, 'Window', kaiser(4900,5), 'OverlapLength', 3000, 'FFTLength', 9000);
% 
% ylim([-1,1])
% view(-45,65)
% colormap jet

