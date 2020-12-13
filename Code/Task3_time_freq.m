%% Load Music
clc
clear

% [music, fs] = audioread('sample_single_note.mp3');
% [music, fs] = audioread('sample_double_note.mp3');
% [music, fs] = audioread('Elise.mp3');
[music, fs] = audioread('fur_elise_single_40.mp3');
music = music(:,1);   % one channel
% music = music(9.5*fs:11*fs);
music = resample(music,1,10);
fs = fs/10;
% sound(music, fs/10);
N = length(music);
% cwt(music, 'bump', fs);

%% Wavelet

blockSize = 10;
stepSize = 10;
noteTrack = zeros(N, 1);
position = 1; 
% i = 1;
fmin = 50;
fmax = 700;
[wavelet, f] = cwt(music, 'bump', fs);

tic
parfor i=1:1:N
    frame = abs(wavelet(:,i));
    [~,idx]=findpeaks(frame, 'SORTSTR', 'descend');
    freq = f(idx(1));
    freq(freq < fmin || freq > fmax) = 0;
    noteTrack(i) = freq2note(freq);
end

noteTrack = medfilt1(noteTrack, 100);
% noteTrack = movmean(noteTrack,100);
% noteTrack = medfilt1(noteTrack, 80);
noteTrack = movmax(noteTrack, 300);
% noteTrack = movmean(noteTrack,200);
% noteTrack = movmax(noteTrack, 5);

toc

%% Plot
figure(4);
% noteTrack = medfilt1(noteTrack, 100);
% t = 0:N/fs/(length(noteTrack)-1):N/fs;
% plot(t, noteTrack)
plot(noteTrack)
% xlabel('Time [sec]')
%% Play Sound
music_reconstruct = note2music(noteTrack, fs, N);
sound(music_reconstruct, fs);

