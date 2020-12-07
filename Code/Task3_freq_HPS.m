clc
clear
[music, fs] = audioread('sample_single_note.mp3');
% [music, fs] = audioread('sample_double_note.mp3');
music = music(:,1);   % one channel
blockSize = 4000;
fftSize = 8000;
step = 500;
N = length(music);

noteTrack = [];
position = 1; i = 1;
while (position+blockSize < N)
    win = hanning(blockSize);
    frame = music(position:position+blockSize-1).*win;
    frame = movmean(frame,10);
    padding = zeros(fftSize-length(frame), 1);
    frame = [frame;padding];
    % add a zero padding here for frame, remember to adjust the xf
%     frame = music(position:position+blockSize-1);
    FFT = fft(frame, fftSize);
    FFT = abs(FFT);
    hps1 = downsample(FFT,1);
    hps2 = downsample(FFT,2);
    padding = zeros((length(hps1)-length(hps2)), 1);
    hps2 = [hps2;padding];
    hps3 = downsample(FFT,3);
    padding = zeros((length(hps2)-length(hps3)), 1);
    hps3 = [hps3;padding];
    totalHPS = hps1.*hps2.*hps3;

%     hps4 = downsample(FFT,4);
%     padding = zeros((length(hps3)-length(hps4)), 1);
%     hps4 = [hps4;padding];
%     totalHPS = hps1.*hps2.*hps3.*hps4;
    
    plotProcess = 0;
    if (plotProcess == 1)
        figure(3);
        lim = 4000;
        subplot(4,1,1);
        plot(hps1);
        xlim([0, lim]);
        subplot(4,1,2);
        plot(hps2);
        xlim([0, lim]);
        subplot(4,1,3);
        plot(hps3);
        xlim([0, lim]);
        subplot(4,1,4);
        plot(totalHPS);
        xlim([0, lim]);
    end

    [peaks,idx]=findpeaks(totalHPS, 'SORTSTR', 'descend');
%     [~,idx] = max(totalHPS);
    
    if (isempty(idx))
        freq = 0;
        noteTrack(i) = freq2note(freq);
%         noteTrack(i) = (freq);
    else
%         anti octave error
%         if (idx(2) < idx(1) && peaks(2) >= 0.45*peaks(1))
%             idx(1) = idx(2);
%         end

        freq = (idx(1)-1)*fs/fftSize;
        noteTrack(i) = freq2note(freq);
    end
    
    position = position + step;
    i = i + 1;
    
end

figure(2);
noteTrack = medfilt1(noteTrack, 100);
t = 0:N/fs/(length(noteTrack)-1):N/fs;
plot(t, noteTrack)
xlabel('Time [sec]')
