
function note = freq2note(freq)
    if (isnan(freq))
        note = nan;
    else
        stdPitch = 440;
        note = round(12*log2(freq/stdPitch));
    end

end