clear all;close all;clc;

%% 1. Read mp3 file
[original_data,Fs] = audioread('sample_single_note.mp3');
% [original_data,Fs] = audioread('sample_double_note.mp3');
data1 = original_data(:,1);
data2 = original_data(:,2);
length = size(original_data,1);

%% 2. Average Magnitude Difference Function (AMDF)
frame_size = 4900;
step_size = 1000;
step = round((length-frame_size)/step_size);
cut_off = 50;

for i = 0:step
    if i == step
        for tau = 1:round(frame_size*2/3)
            amdf_x(tau) = sum(abs(data1(1+i*step_size:length-tau,:)-data1(1+tau+i*step_size:length,:)))/(length-1+tau+i*step_size);
        end
    else
        for tau = 1:round(frame_size*2/3)
            amdf_x(tau) = sum(abs(data1(1+i*step_size:frame_size-tau+i*step_size,:)-data1(1+tau+i*step_size:frame_size+i*step_size,:)))/(frame_size-tau);
        end
    end
     
    amdf_x(1:cut_off) = 999;
    [~,index] = min(amdf_x);
    note = index_to_note(index, Fs);
    detected_note(i+1) = note;
end

% glitch??????
detected_note_final = smoothdata(detected_note, 'movmedian', 40);

%% 3. Play
time = (0:step)*step_size/Fs;
plot(detected_note_final);




