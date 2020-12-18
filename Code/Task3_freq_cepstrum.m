%% Load music
clc
clear
tic
[music, fs] = audioread('music_fur_elise.mp3');
music = music(1:20.25*fs,1,1);   % one channel

% music = music(3*fs:5*fs);

%% Cepstrum

threshold = 0.00001;
fmin = 50;
fmax = 700;

filterON = 1;
downSampleFactor = 1;

if (downSampleFactor >= 2)
    lpf = fir1(64,1/downSampleFactor,'low');
    music = filter(lpf,1,music);
    music = resample(music,1,downSampleFactor);
    fs = fs/downSampleFactor;
end

blockSize = round(8000/downSampleFactor);
stepSize = round(400/downSampleFactor);
N = length(music);
numRound = round((N-blockSize)/stepSize);
noteTrack = zeros(numRound, 1);
position = 1; 
i = 1;

while (position+blockSize < N)
    win = hamming(blockSize);
    frame = music(position:position+blockSize-1).*win;

%     frame = music(position:position+blockSize-1);

    if (sum(frame.^2)/blockSize<threshold)     
        noteTrack(i) = freq2note(nan);

    else
        FFT = abs(fft(frame, blockSize));    
        cepstrum = (ifft(log(FFT)));
        
%         figure(2);
%         lim = 800;
%         subplot(3,1,1);plot(FFT);xlim([0, lim]);title("|FFT|");grid on
%         subplot(3,1,2);plot(log(FFT));xlim([0, lim]);title("log|FFT|");grid on
% %         set(gca, 'YScale', 'log');
%         subplot(3,1,3);plot(cepstrum);xlim([50, 800]);title("cepstrum");grid on       

        minRange = floor(fs/fmax); 
        maxRange = floor(fs/fmin);

        [~,idx]=findpeaks(cepstrum(minRange:maxRange), 'SORTSTR', 'descend');
        
        if (isempty(idx))
            freq = nan;
        else
            time = idx(1);
            freq = fs/(minRange+time-1);
        end
        noteTrack(i) = freq2note(freq);
        
%         figure(9);
%         plot(abs(cepstrum(minRange:maxRange)));
    end
    
    position = position + stepSize;
    i = i + 1;
    
end

if (filterON == 1)  
    % noteTrack = movmax(noteTrack, 5);
    
    noteTrack = medfilt1(noteTrack, 15);
%     noteTrack = movmin(noteTrack, 10);
    noteTrack = movmax(noteTrack, 5);
    noteTrack = movmax(noteTrack, 5);
    % noteTrack = medfilt1(noteTrack, 10);
end
toc

%% Plot

% figure;
% t = 0:N/fs/(length(noteTrack)-1):N/fs;
% plot(t, noteTrack,'linewidth',1.5)
% legend('Cepstrum');
% % ylim([-30, 10]);
% 
% grid on
% xlabel('Time [sec]')
% ylabel('Note')
% set(gca, 'fontsize', 14);

%% Error Rate
errorRate = errorRate(noteTrack,'Cepstrum',N/fs);
str = ['The Error Rate is: ' num2str(errorRate)];
disp(str)

% t = 0:N/fs/(length(noteTrack)-1):N/fs;
% cep_t = t;
% cep_noteTrack = noteTrack;

%% Play Sound
% music_reconstruct = note2music(noteTrack, fs, N);
% sound(music_reconstruct, fs);
