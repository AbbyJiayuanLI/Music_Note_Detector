% note can be calculated following Twelve-tone equal temperament

function note = index_to_note(index, Fs)
    f = Fs/index;
    note = round(12*log2(f/440));
end

