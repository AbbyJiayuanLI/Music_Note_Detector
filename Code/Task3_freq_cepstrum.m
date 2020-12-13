clc
clear
% [music, fs] = audioread('fur_elise_single_40.mp3');
[music, fs] = audioread('fur_elise_single_70.mp3');
% [music, fs] = audioread('sample_single_note.mp3');
% [music, fs] = audioread('sample_double_note.mp3');
% [music, fs] = audioread('sample_not_align_double_note.mp3');
% [music, fs] = audioread('Elise.mp3');
music = music(:,1);   % one channel
% music = music(1*fs:3*fs);

blockSize = 12000;
stepSize = 400;
fftSize = blockSize;
% fftSize = fs/2;
N = length(music);
numRound = round((N-blockSize)/stepSize);
noteTrack = zeros(numRound, 1);
position = 1; 
i = 1;
threshold = 0.0001;

tic
while (position+blockSize < N)
    win = hamming(blockSize);
    frame = music(position:position+blockSize-1).*win;
%     frame = movmean(frame,10);
%     frame = music(position:position+blockSize-1);

    if (sum(frame.^2)/blockSize<threshold)
        freq = 0;
%         freqSet(i) = freq;
        
        noteTrack(i) = freq2note(freq);
%         noteTrack(i) = noteTrack(i-1);
    else
        frameZeroPadding = [frame;zeros(fftSize-blockSize, 1)];
        FFT = abs(fft(frameZeroPadding, fftSize));    
        
%         spectrum = log(abs(fft(frame)))
%         cepstrum = (ifft(log(FFT.^2)));
        cepstrum = (ifft(log(FFT)));

        fmin = 50;
        fmax = 700;
        minRange=floor(fs/fmax*fftSize/blockSize); 
        maxRange=floor(fs/fmin*fftSize/blockSize);
%         [maxIndex,maxTime]=max(abs(cepstrum(minRange:maxRange)));
        [~,idx]=findpeaks(cepstrum(minRange:maxRange), 'SORTSTR', 'descend');
        
        if (isempty(idx))
            freq = 0;
        else
            maxTime = idx(1);
            freq = fs/(minRange+maxTime-1)*fftSize/blockSize;
        end
        noteTrack(i) = freq2note(freq);
        
%         figure(9);
%         plot(abs(cepstrum(minRange:maxRange)));
        
    end
    
    position = position + stepSize;
    i = i + 1;
    
end

% noteTrack = medfilt1(noteTrack, 5);
% noteTrack = movmax(noteTrack, 5);
% noteTrack = movmax(noteTrack, 5);
toc
figure(4);
% noteTrack = medfilt1(noteTrack, 50);
t = 0:N/fs/(length(noteTrack)-1):N/fs;
plot(t, noteTrack)
xlabel('Time [sec]')
