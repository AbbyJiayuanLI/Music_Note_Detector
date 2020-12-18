clear;close all;clc;
tic
%% 1. Read mp3 file
[original_data,Fs] = audioread('music_fur_elise.mp3');

data1 = original_data(1:20.25*44100,1);
data2 = original_data(1:20.25*44100,2);

downSampleFactor = 5;
if downSampleFactor > 1
    lpf = fir1(64, 1/downSampleFactor, 'low');
    data1 = filter(lpf, 1, data1);
    data1 = resample(data1, 1, downSampleFactor);
    Fs = Fs/downSampleFactor;
end
data_length = size(data1,1);
%% 2. Average Magnitude Difference Function (AMDF)
frame_size = round(3000/downSampleFactor);
step_size = round(500/downSampleFactor);
step = round((data_length-frame_size)/step_size);
cut_off = round(50/downSampleFactor);
energy_threshold = 0.0001;

for i = 0:step
    % framing
    if i == step
        data = data1(1+i*step_size:data_length,:);
        window = hamming(data_length-i*step_size);
        data = data.*window;
    else
        data = data1(1+i*step_size:frame_size+i*step_size,:); 
        window = hamming(frame_size);
        data = data.*window;
    end
    
    % check if noise
    if sum(data.^2)/size(data,1) < energy_threshold
        detected_note(i+1) = NaN;
    else
%         for tau = 1:round(frame_size*1/3)
%             amdf_x(tau) = sum(abs(...
%                             data1(1:frame_size-tau,:)-data1(1+tau:frame_size,:)...
%                           ))/(frame_size-tau);
%         end
    %     i
        if i == step
            for tau = 1:round(frame_size*1/3)
                amdf_x(tau) = sum(abs(data1(1+i*step_size:data_length-tau,:)-data1(1+tau+i*step_size:data_length,:)))/(data_length-1+tau+i*step_size);
            end
        else
            for tau = 1:round(frame_size*1/3)
                amdf_x(tau) = sum(abs(data1(1+i*step_size:frame_size-tau+i*step_size,:)-data1(1+tau+i*step_size:frame_size+i*step_size,:)))/(frame_size-tau);
            end
        end
    
        amdf_x(1:cut_off) = 999;

        amdf_x = 1./amdf_x;
        peak_range = (max(amdf_x))/2;
        [peaks,locs] = findpeaks(amdf_x, 'MinPeakHeight', peak_range);  
        index = locs(1);
        

    %     [~,index] = min(amdf_x);
        note = freq2note(Fs/index); % note that here delay start from 1, so no need to minus 1
        detected_note(i+1) = note;
    end
end

% smoothing
% detected_note_final = detected_note;
detected_note_final = smoothdata(detected_note, 'movmedian', 20);
detected_note_final = reshape(detected_note_final,[length(detected_note_final) 1]);

toc
%% 3. Plot
% time = (0:step)*step_size/Fs;
% % plot(standard_x, standard, '*');hold on;
% % plot(size(standard,2)/44100, standard, '*');hold on;
% plot(time, detected_note_final, 'linewidth', 1.5);
% grid on;
% xlabel('Time [sec]')
% ylabel('Note')

% legend('Standard', 'AMDF')

error = errorRate(detected_note_final, 'AMDF', 20.25);

time = (0:step)*step_size/Fs;
amdf_detected_note_final = detected_note_final;
amdf_t = time;