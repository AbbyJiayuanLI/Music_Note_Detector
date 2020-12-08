clc
clear
[music, fs] = audioread('sample_single_note.mp3');
% [music, fs] = audioread('sample_double_note.mp3');
% [music, fs] = audioread('Elise.mp3');
music = music(:,1);   % one channel
blockSize = 2000;
stepSize = 100;
N = length(music);

noteTrack = [];
position = 1; i = 1;
while (position+blockSize < N)
    win = hamming(blockSize);
    frame = music(position:position+blockSize-1).*win;
    frame = movmean(frame,10);
%     frame = music(position:position+blockSize-1);
    spectrum = log(abs(fft(frame)));
    cepstrum = (ifft(log(abs(fft(frame)))));
    
    fmin = 50;
    fmax = 500;
    minRange=floor(fs/fmax); % 2ms 500Hz
    maxRange=floor(fs/fmin); % 20ms 50Hz
    [maxIndex,maxTime]=max(abs(cepstrum(minRange:maxRange)));
    freq = fs/(minRange+maxTime-1);
    noteTrack(i) = freq2note(freq);
    
    position = position + stepSize;
    i = i + 1;
    
end

figure(3);
% noteTrack = medfilt1(noteTrack, 100);
t = 0:N/fs/(length(noteTrack)-1):N/fs;
plot(t, noteTrack)
xlabel('Time [sec]')
