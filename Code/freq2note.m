
function note = freq2note(freq)
    stdPitch = 440;
    note = round(12*log2(freq/stdPitch));

end