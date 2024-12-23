% Read the audio file
[audioData, fs] = audioread('AuntRhody.wav');% Replace with your file's path

% Set the segment duration (in milliseconds) and calculate samples per segment
segmentDurationMs = 100;  % Duration of each segment in milliseconds
samplesPerSegment = round((segmentDurationMs / 1000) * fs);

% Reshape the audio data into segments
numSegments = floor(length(audioData) / samplesPerSegment);
reshapedAudio = reshape(audioData(1:numSegments * samplesPerSegment), samplesPerSegment, numSegments);

% Placeholder threshold for note detection
threshold = 0.1;  % Adjust this value based on the signal amplitude

% Initialize arrays to store detected notes and times
notes = [];
times = [];
noteNames = [];  % To store the musical note names

% Loop through each segment
for ii = 1:numSegments
    currentSegment = reshapedAudio(:, ii);
    [noteNum, maxVal] = noteDetect(currentSegment, fs, threshold);
    
    if noteNum ~= -1  % Ignore silence
        % Append note number and corresponding time
        notes = [notes, noteNum];
        times = [times, (ii - 1) * (segmentDurationMs / 1000)]; % Time in seconds
        noteName = midiToNoteName(noteNum);  % Convert MIDI note to name
      %  noteNames = [noteNames; {noteName}]; % Append note name to cell array
         noteNames = [noteNames; {sprintf('%d-%s', noteNum, noteName)}];  % Combine MIDI note and na
    end
           % fprintf('Segment %d: Note = %d, Max Power = %.2f\n', ii, noteNum, maxVal);

end

% Create a table for output
noteTable = table(times(:), noteNames(:), ...
    'VariableNames', {'Time (s)', 'Note (MIDI-Name)'});

% Display the detected notes and times
disp('Detected Notes and Timestamps:');
disp('Notes:');
disp(notes);
disp('Note Names:');
disp(noteTable);
%disp(noteNames);
%disp('Times (in seconds):');
%disp(times);

% Generate the synthesized audio signal
outputSignal = [];
for i = 1:length(notes)
    % Generate a sine wave for the detected note
    midiNote = notes(i);
    frequency = 440 * 2^((midiNote - 69) / 12);  % MIDI note to frequency
    duration = segmentDurationMs / 1000;  % Duration in seconds
    t = 0:1/fs:duration - 1/fs;  % Time vector
    
    % Generate the sine wave
    sineWave = 0.5 * sin(2 * pi * frequency * t);  % Amplitude scaled to 0.5
    
    % Append the sine wave to the output signal
    outputSignal = [outputSignal, sineWave];
end

% Normalize the output signal to prevent clipping
outputSignal = outputSignal / max(abs(outputSignal));
% Save the new audio file
outputFolder = 'audio/';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% Combine the folder path and file name
outputFilename = fullfile(outputFolder, 'Detected_Notes.wav');
audiowrite(outputFilename, outputSignal, fs); % Replace with your file's path

disp(['Synthesized audio file saved as: ', outputFilename]);

% Read the newly created .wav file
[newAudioData, newFs] = audioread(outputFileName); % Replace with your file's path

% Double the tempo by halving the duration (speed up playback)
doubledTempoData = newAudioData(1:2:end);  % Keep every second sample

% Save the new audio file
outputFolder = 'audio/';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% Save the tempo-adjusted audio file
tempoAdjustedFileName = fullfile(outputFolder,'Detected_Notes_DoubleTempo.wav');
audiowrite(tempoAdjustedFileName, doubledTempoData, fs);% Replace with your file's path

disp(['Tempo-adjusted audio file saved as: ', tempoAdjustedFileName]);

% Step 1: Load the .wav file
[data, fs] = audioread('Detected_Notes_DoubleTempo.wav'); % Replace with your file's path

% Step 2: Extract one channel of the audio data (if stereo)
if size(data, 2) > 1
    x = data(:, 1); % Use the first channel
else
    x = data; % Single channel data
end

% Normalize the audio data for consistency
x = x / max(abs(x));

% Problem 4: Generate a cosine signal and sample at different frequencies
t = -0.5:1/fs:0.5; % Time interval for the signal
f = 30; % Frequency of the cosine signal
c = cos(2 * pi * f * t); % Generate the cosine signal

% Sample the signal at specified rates
fs1 = 80; fs2 = 60; fs3 = 30; % Sampling frequencies
t1 = 0:1/fs1:max(t);
t2 = 0:1/fs2:max(t);
t3 = 0:1/fs3:max(t);

c1 = cos(2 * pi * f * t1); % Sampled at fs1
c2 = cos(2 * pi * f * t2); % Sampled at fs2
c3 = cos(2 * pi * f * t3); % Sampled at fs3

% Plot the sampled signals
figure(1);
subplot(3, 1, 1);
stem(t1, c1, 'b','LineWidth',2); 
title('Sampled Signal at fs1 = 80Hz'); 
xlabel('Time (s)'); 
ylabel('Amplitude');
set(gca, 'fontname', 'Times New Roman');  % Set font name
set(gca, 'fontsize', 14);                % Set font size
set(gca, 'fontweight', 'bold');          % Set font weight
subplot(3, 1, 2);
stem(t2, c2,'r','LineWidth',2); 
title('Sampled Signal at fs2 = 60Hz');
xlabel('Time (s)'); 
ylabel('Amplitude');
set(gca, 'fontname', 'Times New Roman');  % Set font name
set(gca, 'fontsize', 14);                % Set font size
set(gca, 'fontweight', 'bold');          % Set font weight
subplot(3, 1, 3);
stem(t3, c3,'g','LineWidth',2); 
title('Sampled Signal at fs3 = 30Hz'); 
xlabel('Time (s)'); 
ylabel('Amplitude');
set(gca, 'fontname', 'Times New Roman');  % Set font name
set(gca, 'fontsize', 14);                % Set font size
set(gca, 'fontweight', 'bold');          % Set font weight

% Plot the sampled signals
figure(2);
subplot(3, 1, 1);
plot(t1, c1,  'b','LineWidth',2); 
grid on;
title('Sampled Signal at fs1 = 80Hz'); 
xlabel('Time (s)');
ylabel('Amplitude');
set(gca, 'fontname', 'Times New Roman');  % Set font name
set(gca, 'fontsize', 14);                % Set font size
set(gca, 'fontweight', 'bold');

subplot(3, 1, 2);
plot(t2, c2,  'r','LineWidth',2);
grid on;
title('Sampled Signal at fs2 = 60Hz'); 
xlabel('Time (s)'); 
ylabel('Amplitude');
set(gca, 'fontname', 'Times New Roman');  % Set font name
set(gca, 'fontsize', 14);                % Set font size
set(gca, 'fontweight', 'bold');

subplot(3, 1, 3);
plot(t3, c3,  'g','LineWidth',2); 
grid on;
title('Sampled Signal at fs3 = 30Hz'); 
xlabel('Time (s)'); 
ylabel('Amplitude');
set(gca, 'fontname', 'Times New Roman');  % Set font name
set(gca, 'fontsize', 14);                % Set font size
set(gca, 'fontweight', 'bold');

% Problem 5: Combine the cosine signal with the .wav file data
fs4 = 32; % New sampling frequency
t4 = 0:1/fs4:max(t);
c4 = cos(2 * pi * f * t4); % Generate the cosine signal at fs4

% Combine the signals
xc = interp1(linspace(0, length(x) / fs, length(x)), x, t4, 'linear', 0) + c4;

% Plot the combined signal
figure(3);
plot(t4, xc, 'r', 'LineWidth', 2);
hold on
plot(t4, c4, 'b', 'LineWidth',2 );
title('Comparison of $x$ and $x_c = x + c$', 'Interpreter', 'latex');
%title('Combined Signal (x + c)');
xlabel('Time (s)');
ylabel('Amplitude');
legend('x (Audio Component)', 'x_c = x + c (Combined Signal)', 'Location', 'best');
set(gca, 'fontname', 'Times New Roman');  % Set font name
set(gca, 'fontsize', 14);                % Set font size
set(gca, 'fontweight', 'bold');          % Set font weight
hold off;

function [noteNum, maxVal] = noteDetect(segment, fs, threshold)
    % noteDetect: Identifies the dominant note in a given audio segment.
    %
    % Inputs:
    % - segment: Audio segment (vector of samples).
    % - fs: Sampling frequency of the audio (Hz).
    % - threshold: Silence threshold for the power of the loudest note.
    %
    % Outputs:
    % - noteNum: Detected note number (based on MIDI note numbers). Returns -1 for silence.
    % - maxVal: Maximum magnitude of the dominant frequency in the segment. Returns 0 for silence.

    % Compute the FFT of the segment
    N = length(segment);  % Number of samples in the segment
    fftResult = fft(segment);
    mag = abs(fftResult(1:floor(N/2)));  % Take positive frequencies
    freqs = (0:(N/2)-1) * (fs / N);  % Frequency axis
    
    % Find the dominant frequency
    [maxVal, idx] = max(mag);  % Maximum magnitude and its index
    
    % Check if the dominant frequency's power is below the silence threshold
    if maxVal < threshold
        % Return silence if the maximum amplitude is below the threshold
        noteNum = -1;  % Indicate silence with -1
        maxVal = 0;    % No dominant frequency
        return;
    end
    
    % Calculate the dominant frequency
    dominantFreq = freqs(idx);
    
    % Map the frequency to a musical note using the MIDI note scale
    % MIDI note 69 corresponds to A4 (440 Hz)
    noteNum = round(69 + 12 * log2(dominantFreq / 440));
end
% Function to map MIDI note numbers to note names
function noteName = midiToNoteName(midiNote)
    % MIDI note names
    noteNames = {'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'};
    octave = floor(midiNote / 12) - 1;  % Calculate octave (C4 starts at 60)
    noteIndex = mod(midiNote, 12) + 1; % Get the note index (1-based)
    noteName = sprintf('%s%d', noteNames{noteIndex}, octave); % Combine note and octave
end