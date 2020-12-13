%% 
clc
clear

% [music, fs] = audioread('sample_single_note.mp3');
% [music, fs] = audioread('sample_double_note.mp3');
% [music, fs] = audioread('Elise.mp3');
[music, fs] = audioread('fur_elise_single_40.mp3');
music = music(:,1);   % one channel
% music = music(9.5*fs:11*fs);
N = length(music);
cwt(music, 'bump', fs);

% [wavelet, f] = cwt(music, 'bump', fs);
% save('cwt_sample_single_note','wavelet','f');
load('cwt_sample_single_note','wavelet','f');
%% 

blockSize = 10;
stepSize = 10;
noteTrack = [];
position = 1; i = 1;
while (position+blockSize < N)
%     win = hanning(blockSize);
%     frame = music(position:position+blockSize-1).*win;
%     frame = movmean(frame,10);
    frame = wavelet(:,position:position+blockSize-1);

% 
% %     [peaks,idx]=findpeaks(totalHPS, 'SORTSTR', 'descend');
    [~,idx] = max(frame(:));
    [I_row, I_col] = ind2sub(size(frame),idx);
    freq = f(I_row);
%     
% %     if (isempty(idx))
% %         freq = 0;
% %         noteTrack(i) = freq2note(freq);
% % %         noteTrack(i) = (freq);
% %     else
% %         freq = (idx(1)-1)*fs/blockSize;
% %         noteTrack(i) = freq2note(freq);
% %     end
%     
    if (freq < 50)
        freq = 0;
    end
    [row, ~] = find(f>0.45*freq & f<0.55*freq);
%     row = row(1);
    if (~isempty(row) && frame(row(1),I_col) > 0.4*frame(I_row,I_col))
        freq = f(row(1));
    end
    noteTrack(i) = freq2note(freq);
    position = position + stepSize;
    i = i + 1;
    i
    
end

figure(4);
% noteTrack = medfilt1(noteTrack, 100);
t = 0:N/fs/(length(noteTrack)-1):N/fs;
plot(t, noteTrack)
% xlabel('Time [sec]')
