%% Load Music
clc
clear
tic
[music, fs] = audioread('music_fur_elise.mp3');
music = music(1:20.25*fs,1,1);   % one channel

% cwt(music, 'bump', fs);

%% Wavelet

fmin = 50;
fmax = 700;
downSampleFactor = 10;

if (downSampleFactor >= 2)
    lpf = fir1(64,1/downSampleFactor,'low');
    music = filter(lpf,1,music);
    music = resample(music,1,downSampleFactor);
    fs = fs/downSampleFactor;
end

N = length(music);
noteTrack = zeros(N, 1);
[wavelet, f] = cwt(music, 'bump', fs);
% toc
% 
% tic
parfor i=1:N
    frame = abs(wavelet(:,i));
    [~,idx]=findpeaks(frame, 'SORTSTR', 'descend');
    index = idx(1);
    freq = f(index);
    freq(freq < fmin || freq > fmax) = 0;
    noteTrack(i) = freq2note(freq);
end

noteTrack = medfilt1(noteTrack, 2000/downSampleFactor);
noteTrack = movmax(noteTrack, 3000/downSampleFactor);
toc

%% Plot

% figure(5);
% t = 0:N/fs/(length(noteTrack)-1):N/fs;
% plot(t, noteTrack,'linewidth',1.5)
% legend('Wavelet');
% % ylim([-30, 10]);
% 
% grid on
% xlabel('Time [sec]')
% ylabel('Note')
% set(gca, 'fontsize', 14);

%% Error Rate
errorRate = errorRate(noteTrack,'Wavelet',N/fs);
str = ['The Error Rate is: ' num2str(errorRate)];
disp(str)

t = 0:N/fs/(length(noteTrack)-1):N/fs;
wave_t = t;
wave_noteTrack = noteTrack;

%% Play Sound
% music_reconstruct = note2music(noteTrack, fs, N);
% sound(music_reconstruct, fs);

