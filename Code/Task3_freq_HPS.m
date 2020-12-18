%% Load Music
clc
clear
tic
[music, fs] = audioread('music_fur_elise.mp3');
music = music(1:20.25*fs,1,1);   % one channel


% music = music(1*fs:length(music));
% music = music(10*fs:11*fs);

%% HPS

threshold = 0.00001;
decay = 0;

plotHPSProcess = 0;
filterON = 1;
downSampleFactor = 1;


if (downSampleFactor >= 2)
    lpf = fir1(64,1/downSampleFactor,'low');
    music = filter(lpf,1,music);
    music = resample(music,1,downSampleFactor);
    fs = fs/downSampleFactor;
end

fftSize = round(fs/2);
blockSize = round(6000/downSampleFactor);
stepSize = round(400/downSampleFactor);
N = length(music);
numRound = round((N-blockSize)/stepSize);
noteTrack = zeros(numRound, 1);
position = 1; 
i = 1;

freqSet = zeros(numRound, 1);

while (position+blockSize < N)
%     win = hanning(blockSize);
%     frame = music(position:position+blockSize-1).*win;
    frame = music(position:position+blockSize-1);
    
    if (sum(frame.^2)/blockSize<threshold) 
        noteTrack(i) = freq2note(nan);
    else
        frameZeroPadding = [frame;zeros(fftSize-blockSize, 1)];
        FFT_raw = abs(fft(frameZeroPadding, fftSize));    
        if (i~=1 && ~isnan(noteTrack(i-1)))

%             figure(10);
%             lim = 800;
%             subplot(3,1,1);
%             plot(FFT_raw);grid on
%             xlim([0, lim]);
%             subplot(3,1,2);
%             plot(FFT_old);grid on
%             xlim([0, lim]);
%             subplot(3,1,3);
%             plot(abs(FFT_raw- decay*FFT_old));grid on
%             xlim([0, lim]);

            lenTake = fftSize;
            FFT = FFT_raw - decay*[FFT_old(1:lenTake);zeros(fftSize-lenTake,1)];
            FFT = abs(FFT);
        else
            FFT = FFT_raw;
        end
        FFT_old = FFT_raw;
        hps1 = FFT;
        hps2 = downsample(FFT,2);
        hps3 = downsample(FFT,3);
        len = length(hps3);
        totalHPS = hps1(1:len).*hps2(1:len).*hps3;
        
%         hps4 = downsample(FFT,4);
%         len = length(hps4);
%         totalHPS = hps1(1:len).*hps2(1:len).*hps3(1:len).*hps4;
        
        if (plotHPSProcess == 1)
            figure(2);
            lim = len/4;
            subplot(4,1,1);plot(hps1);xlim([0, lim]);title("|X(\omega_0)|");grid on
            subplot(4,1,2);plot(hps2);xlim([0, lim]);title("|X(\omega_1)|");grid on
            subplot(4,1,3);plot(hps3);xlim([0, lim]);title("|X(\omega_2)|");grid on
            subplot(4,1,4);plot(totalHPS);xlim([0, lim]);title("HPS");grid on

%             subplot(5,1,1);plot(hps1);xlim([0, lim]);title("|X(\omega_0)|");grid on
%             subplot(5,1,2);plot(hps2);xlim([0, lim]);title("|X(\omega_1)|");grid on
%             subplot(5,1,3);plot(hps3);xlim([0, lim]);title("|X(\omega_2)|");grid on
%             subplot(5,1,4);plot(hps4);xlim([0, lim]);title("|X(\omega_3)|");grid on
%             subplot(5,1,5);plot(totalHPS);xlim([0, lim]);title("HPS");grid on
        end

        fmin = 50;
        fmax = 700;
        minRange=floor(fftSize*fmin/fs); 
        maxRange=floor(fftSize*fmax/fs);
    %     [~,idx]=max(abs(totalHPS(minRange:maxRange)));
    %     idx = idx + minRange;

    %     [peaks,idx]=findpeaks(totalHPS, 'SORTSTR', 'descend');
        [~,idx]=findpeaks(totalHPS(minRange:maxRange), 'SORTSTR', 'descend');
        idx = idx + minRange;

    %     [~,idx] = max(totalHPS);

        if (isempty(idx))
            noteTrack(i) = freq2note(nan);
    %         noteTrack(i) = (freq);
        else
    %         anti octave error
    %         anti = 0;
    %         if (idx(2) < 0.55*idx(1) && idx(2) > 0.45*idx(1) && peaks(2) >= 0.5*peaks(1) && anti == 1)
    %             idx(1) = idx(2);
    %         end
    %         freq = (idx(1)-1)*fs/fftSize;
            freq = (idx(1)-1)*fs/fftSize;
            freqSet(i) = freq;
            noteTrack(i) = freq2note(freq);
        end
    end
    
    position = position + stepSize;
    i = i + 1;
    
end
if (filterON == 1)  
    % noteTrack = movmax(noteTrack, 5);
    % noteTrack = movmin(noteTrack, 10);
    noteTrack = medfilt1(noteTrack, 5);
    noteTrack = movmax(noteTrack, 5);
    noteTrack = movmax(noteTrack, 5);
    % noteTrack = medfilt1(noteTrack, 10);
end

toc
%% Plot

% figure;
% t = 0:N/fs/(length(noteTrack)-1):N/fs;
% plot(t, noteTrack,'linewidth',1.5)
% legend('HPS');
% grid on
% xlabel('Time [sec]')
% ylabel('Note')
% set(gca, 'fontsize', 14);

%% Error Rate
errorRate = errorRate(noteTrack,'HPS',N/fs);
str = ['The Error Rate is: ' num2str(errorRate)];
disp(str)

t = 0:N/fs/(length(noteTrack)-1):N/fs;
hps_t = t;
hps_noteTrack = noteTrack;

%% Play Sound
% music_reconstruct = note2music(noteTrack, fs, N);
% sound(music_reconstruct, fs);

