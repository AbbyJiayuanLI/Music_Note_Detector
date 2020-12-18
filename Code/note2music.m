% noteTrack is the array of all notes
% fs is the sampling frequency
% N is the length of the input music

function music_reconstruct = note2music(noteTrack, fs, N)
    music_reconstruct = [];
    currentNote = noteTrack(1);
    duration = 1;
    for i=2:1:length(noteTrack)
        if (noteTrack(i) ~= currentNote)
            n = 0:1/fs:duration*N/fs/length(noteTrack);
            m = reshape(cos(2*pi*440*2^(currentNote/12)*n), [length(n) 1]);
            music_reconstruct = [music_reconstruct;m];
            duration = 1;
            currentNote = noteTrack(i);
        else
            duration = duration + 1;
        end
    end
    if (noteTrack(i) == noteTrack(i))
        n = 0:1/fs:duration*N/fs/length(noteTrack);
        m = reshape(cos(2*pi*440*2^(currentNote/12)*n), [length(n) 1]);
        music_reconstruct = [music_reconstruct;m];
    else
        n = 0:1/fs:N/fs/length(noteTrack);
        m = reshape(cos(2*pi*440*2^(currentNote/12)*n), [length(n) 1]);
        music_reconstruct = [music_reconstruct;m];
    end
end