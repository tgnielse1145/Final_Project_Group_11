function maxNote = toneDetect(xx, fs, DEBUG)
%toneDetect Returns a number indicating what note was played.
% toneDetect(xx, fs) xx in the input sound, fs is the sample rate.
%
% toneDetect(xx, fs, 1) Like above, but turns DEBUGing on.
%
% Copyright 2003 Mark A. Yoder, Rose-Hulman
%
if (nargin < 3) % Turn off debugging if last argument not present.
 DEBUG = 0;
end
f0 = 440; % Hz
all = xx';
max = 0;
maxNote = -1;
for note = 0:12
    freq = f0 * 2.^(note/12);
    what = freq/fs*2; %Insert code to computeωˆ (what) based on freq and the sampling rate.
    aa = poly(0.99*[exp(-1i*what*pi),exp(1i*what*pi)]); % Insert code to make a bandpass filter with center at ωˆ (what).
    bb = 1;
    yy = filter(bb, aa, xx);
    pow = sum(yy.^2)/length(yy); % Insert code to find the total power in the signal yy
    if pow > max % Is this the loudest note?
        max = pow; % Yes, remember it.
        maxNote = note;
    end
    all = [all yy']; % Save output for debugging.
end
if(DEBUG) % If debuging in on, play outputs of all the filters.
 soundsc(all, fs)
end 