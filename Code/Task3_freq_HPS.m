clc
clear

tic
[music, fs] = audioread('sample_single_note.mp3');
% [music, fs] = audioread('sample_double_note.mp3');
% [music, fs] = audioread('sample_not_align_double_note.mp3');
music = music(:,1);   % one channel
% music = music(1*fs:length(music));
% music = music(9.5*fs:11*fs);
blockSize = 2000;
fftSize = 6000;
step = 1000;
N = length(music);
noteTrack = [];
position = 1; i = 1;
while (position+blockSize < N)
    win = hanning(blockSize);
    frame = [music(position:position+blockSize-1).*win;zeros(fftSize-blockSize, 1)];
%     frame = movmean(frame,10);
%     frame = [music(position:position+blockSize-1);zeros(fftSize-blockSize, 1)];

    FFT = abs(fft(frame, fftSize));
    hps1 = FFT;
    hps2 = downsample(FFT,2);
    hps3 = downsample(FFT,3);
%     len = length(hps3);
%     totalHPS = hps1(1:len)+hps2(1:len)+hps3;
    
    hps4 = downsample(FFT,4);
    len = length(hps4);
%     totalHPS = hps1(1:len)+hps2(1:len)+hps3(1:len)+hps4;
    totalHPS = hps1(1:len).*hps2(1:len).*hps3(1:len).*hps4;
    
    plotProcess = 0;
    if (plotProcess == 1)
        figure(3);
        lim = 400;
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
        if (idx(2) < 0.6*idx(1) && idx(2) > 0.4*idx(1) && peaks(2) >= 0.3*peaks(1))
            idx(1) = idx(2);
        end

        freq = (idx(1)-1)*fs/fftSize;
        noteTrack(i) = freq2note(freq);
    end
    
    position = position + step;
    i = i + 1;
    
end
toc
figure(2);
% noteTrack = medfilt1(noteTrack, 100);
t = 0:N/fs/(length(noteTrack)-1):N/fs;
plot(t, noteTrack)
xlabel('Time [sec]')
