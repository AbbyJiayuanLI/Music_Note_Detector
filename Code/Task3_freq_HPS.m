%% Load Music
clc
clear


[music, fs] = audioread('fur_elise_single_70.mp3');
% [music, fs] = audioread('fur_elise_single_40.mp3');
% [music, fs] = audioread('octave_c3_c4.mp3');
% [music, fs] = audioread('sample_single_note.mp3');
% [music, fs] = audioread('sample_single_note_octave_70.mp3');
% [music, fs] = audioread('sample_double_note.mp3');
% [music, fs] = audioread('sample_not_align_double_note.mp3');
% [music, fs] = audioread('Elise.mp3');
music = music(:,1);   % one channel
% music = music(1*fs:length(music));
% music = music(1*fs:3*fs);

%% HPS

blockSize = 6000;
fftSize = fs/2;
stepSize = 400;
threshold = 0.0001;
decay = 0.9;

plotHPSProcess = 0;

N = length(music);
numRound = round((N-blockSize)/stepSize);
noteTrack = zeros(numRound, 1);
position = 1; 
i = 1;

freqSet = zeros(numRound, 1);
% energy = [];
tic
while (position+blockSize < N)
    win = hanning(blockSize);
    frame = music(position:position+blockSize-1).*win;
%     frame = music(position:position+blockSize-1);

%     frame = movmean(frame,10);
    
%     energy(i) = sum(frame.^2)/blockSize;
    if (sum(frame.^2)/blockSize<threshold)
        freq = 0;
        freqSet(i) = freq;
        
        noteTrack(i) = freq2note(freq);
%         noteTrack(i) = noteTrack(i-1);
    else
        frameZeroPadding = [frame;zeros(fftSize-blockSize, 1)];
        FFT_raw = abs(fft(frameZeroPadding, fftSize));    
        if (~isempty(freqSet) && freqSet(i-1)~=0)
%         n = 0:1:blockSize-1;
%         frame = frame - 0.01*reshape(cos(2*pi*freqSet(i-1)*n),[blockSize 1]);
%             figure(10);
%             lim = 400;
%             subplot(3,1,1);
%             plot(FFT);
%             xlim([0, lim]);
%             subplot(3,1,2);
%             plot(FFT_old);
%             xlim([0, lim]);
%             subplot(3,1,3);
%             plot(FFT- decay*FFT_old);
%             xlim([0, lim]);
%             lenTake = fs/fftSize*8*freqSet(i-1);
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
            figure(2);lim = 1000;
            subplot(5,1,1);plot(hps1);xlim([0, lim]);
            subplot(5,1,2);plot(hps2);xlim([0, lim]);
            subplot(5,1,3);plot(hps3);xlim([0, lim]);
            subplot(5,1,4);plot(hps4);xlim([0, lim]);
            subplot(5,1,5);plot(totalHPS);xlim([0, lim]);
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
            freq = 0;
            freqSet(i) = freq;
            noteTrack(i) = freq2note(freq);
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
% noteTrack = movmax(noteTrack, 5);
% noteTrack = movmin(noteTrack, 10);

noteTrack = medfilt1(noteTrack, 5);
noteTrack = movmax(noteTrack, 5);
noteTrack = movmax(noteTrack, 5);

% noteTrack = medfilt1(noteTrack, 10);

toc
%% Plot

figure(3);
t = 0:N/fs/(length(noteTrack)-1):N/fs;
plot(t, noteTrack)
xlabel('Time [sec]')

%% Play Sound
% music_reconstruct = note2music(noteTrack, fs, N);
% sound(music_reconstruct, fs);

