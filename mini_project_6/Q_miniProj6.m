% Read the audio file
%[audioData, fs] = audioread('AuntRhody.wav');
[audioData, fs] = audioread('/Users/toddnielsen/Desktop/School/Semesters/Fall/Fall_2024/ECE_6530/Final_Project/Final_Project_Group_11/assets/audio/AuntRhody.wav');

% Read the audio file
%[audioData, fs] = audioread('AuntRhody.wav');

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

% Loop through each segment
for ii = 1:numSegments
    currentSegment = reshapedAudio(:, ii);
    [noteNum, maxVal] = noteDetect(currentSegment, fs, threshold);
    
    if noteNum ~= -1  % Ignore silence
        % Append note number and corresponding time
        notes = [notes, noteNum];
        times = [times, (ii - 1) * (segmentDurationMs / 1000)]; % Time in seconds
    end
            fprintf('Segment %d: Note = %d, Max Power = %.2f\n', ii, noteNum, maxVal);

end

% Display the detected notes and times
disp('Detected Notes and Timestamps:');
disp('Notes:');
disp(notes);
disp('Times (in seconds):');
disp(times);

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
outputFolder = '/Users/toddnielsen/Desktop/School/Semesters/Fall/Fall_2024/ECE_6530/Final_Project/Final_Project_Group_11/assets/audio/';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% Combine the folder path and file name
outputFilename = fullfile(outputFolder, 'DetectedNotes.wav');
audiowrite(outputFilename, outputSignal, fs);

%disp(['Synthesized audio file saved as: ', outputFilename]);

% Read the newly created .wav file
%[newAudioData, newFs] = audioread(outputFileName);
[newAudioData, newFs] = audioread('/Users/toddnielsen/Desktop/School/Semesters/Fall/Fall_2024/ECE_6530/Final_Project/Final_Project_Group_11/assets/audio/DetectedNotes.wav');


% Double the tempo by halving the duration (speed up playback)
doubledTempoData = newAudioData(1:2:end);  % Keep every second sample

% Save the new audio file
outputFolder = '/Users/toddnielsen/Desktop/School/Semesters/Fall/Fall_2024/ECE_6530/Final_Project/Final_Project_Group_11/assets/audio/';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% Save the tempo-adjusted audio file
tempoAdjustedFileName = fullfile(outputFolder,'DetectedNotes_DoubleTempo.wav');
%tempoAdjustedFileName = 'DetectedNotes_DoubleTempo.wav';
audiowrite(tempoAdjustedFileName, doubledTempoData, fs);

%disp(['Tempo-adjusted audio file saved as: ', tempoAdjustedFileName]);








% Load the 'DetectedNotes_DoubleTempo.wav' file
%[inputAudio, fs] = audioread('DetectedNotes_DoubleTempo.wav');
[inputAudio, wav_fs] = audioread('/Users/toddnielsen/Desktop/School/Semesters/Fall/Fall_2024/ECE_6530/Final_Project/Final_Project_Group_11/assets/audio/DetectedNotes_DoubleTempo.wav');

%disp(['Sampling rate of input file: ', num2str(wav_fs), ' Hz']);



% Define cosine signal parameters
f = 30;  % Frequency of the cosine wave (Hz)
t = -0.5:1/wav_fs:0.5;  % Time vector for the continuous signal
cosSignal = cos(2 * pi * f * t);  % Continuous cosine signal

% Sampling frequencies
fs1 = 80;  % Sampling frequency 1
fs2 = 60;  % Sampling frequency 2
fs3 = 30;  % Sampling frequency 3

% Sample the signal at each sampling frequency
t_fs1 = -0.5:1/fs1:0.5;
cos_fs1 = cos(2 * pi * f * t_fs1);

t_fs2 = -0.5:1/fs2:0.5;
cos_fs2 = cos(2 * pi * f * t_fs2);

t_fs3 = -0.5:1/fs3:0.5;
cos_fs3 = cos(2 * pi * f * t_fs3);

% Plot the signals
figure(1);

% Original cosine signal
subplot(4, 1, 1);
plot(t, cosSignal, 'b', 'LineWidth',2);
title('Original Cosine Signal (Continuous, 30 Hz)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;
set(gca, 'fontname', 'Times New Roman');  % Set font name
set(gca, 'fontsize', 14);                % Set font size
set(gca, 'fontweight', 'bold');          % Set font weight

% Sampled signal at fs1
subplot(4, 1, 2);
stem(t_fs1, cos_fs1, 'r', 'LineWidth', 2);
title('Sampled Cosine Signal at 80 Hz');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;
set(gca, 'fontname', 'Times New Roman');  % Set font name
set(gca, 'fontsize', 14);                % Set font size
set(gca, 'fontweight', 'bold');          % Set font weight

% Sampled signal at fs2
subplot(4, 1, 3);
stem(t_fs2, cos_fs2, 'g', 'LineWidth', 2);
title('Sampled Cosine Signal at 60 Hz');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;
set(gca, 'fontname', 'Times New Roman');  % Set font name
set(gca, 'fontsize', 14);                % Set font size
set(gca, 'fontweight', 'bold');          % Set font weight

% Sampled signal at fs3
subplot(4, 1, 4);
stem(t_fs3, cos_fs3, 'k', 'LineWidth', 2);
title('Sampled Cosine Signal at 30 Hz');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;
set(gca, 'fontname', 'Times New Roman');  % Set font name
set(gca, 'fontsize', 14);                % Set font size
set(gca, 'fontweight', 'bold');          % Set font weight

% Display complete figure layout
sgtitle('Cosine Signal Sampling at Different Frequencies');

% Plot the signals
figure(2);

% Original cosine signal
subplot(4, 1, 1);
plot(t, cosSignal, 'b', 'LineWidth', 2);  % Blue for the original signal
title('Original Cosine Signal (Continuous, 30 Hz)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;
set(gca, 'fontname', 'Times New Roman');  % Set font name
set(gca, 'fontsize', 14);                % Set font size
set(gca, 'fontweight', 'bold');          % Set font weight

% Sampled signal at fs1
subplot(4, 1, 2);
plot(t_fs1, cos_fs1, 'r', 'LineWidth', 2);  % Red for fs1
title('Sampled Cosine Signal at 80 Hz');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;
set(gca, 'fontname', 'Times New Roman');  % Set font name
set(gca, 'fontsize', 14);                % Set font size
set(gca, 'fontweight', 'bold');          % Set font weight

% Sampled signal at fs2
subplot(4, 1, 3);
plot(t_fs2, cos_fs2, 'g', 'LineWidth', 2);  % Green for fs2
title('Sampled Cosine Signal at 60 Hz');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;
set(gca, 'fontname', 'Times New Roman');  % Set font name
set(gca, 'fontsize', 14);                % Set font size
set(gca, 'fontweight', 'bold');          % Set font weight

% Sampled signal at fs3
subplot(4, 1, 4);
plot(t_fs3, cos_fs3, 'm', 'LineWidth', 2);  % Magenta for fs3
title('Sampled Cosine Signal at 30 Hz');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;
set(gca, 'fontname', 'Times New Roman');  % Set font name
set(gca, 'fontsize', 14);                % Set font size
set(gca, 'fontweight', 'bold');          % Set font weight

% Display complete figure layout
sgtitle('Cosine Signal Sampling at Different Frequencies');


[inputAudio, wav_fs] = audioread('/Users/toddnielsen/Desktop/School/Semesters/Fall/Fall_2024/ECE_6530/Final_Project/Final_Project_Group_11/assets/audio/DetectedNotes_DoubleTempo.wav');

%disp(['Sampling rate of input file: ', num2str(wav_fs), ' Hz']);

% Define cosine signal parameters
f = 30;  % Frequency of the cosine wave (Hz)
t = -0.5:1/wav_fs:0.5;  % Time vector for the continuous signal
cosSignal = cos(2 * pi * f * t);  % Continuous cosine signal

% Sampling frequencies
fs1 = 80;  % Sampling frequency 1
fs2 = 60;  % Sampling frequency 2
fs3 = 30;  % Sampling frequency 3

% Sample the signal at each sampling frequency
t_fs1 = -0.5:1/fs1:0.5;
cos_fs1 = cos(2 * pi * f * t_fs1);

t_fs2 = -0.5:1/fs2:0.5;
cos_fs2 = cos(2 * pi * f * t_fs2);

t_fs3 = -0.5:1/fs3:0.5;
cos_fs3 = cos(2 * pi * f * t_fs3);

% Plot the signals
figure(3);

% Original cosine signal
subplot(4, 1, 1);
plot(t, cosSignal, 'b', 'LineWidth', 2);
title('Original Cosine Signal (Continuous, 30 Hz)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;
set(gca, 'fontname', 'Times New Roman');  % Set font name
set(gca, 'fontsize', 14);                % Set font size
set(gca, 'fontweight', 'bold');          % Set font weight

% Sampled signal at fs1
subplot(4, 1, 2);
plot(t_fs1, cos_fs1, 'r-o', 'LineWidth', 2);  % Use plot with markers
title('Sampled Cosine Signal at 80 Hz');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;
set(gca, 'fontname', 'Times New Roman');  % Set font name
set(gca, 'fontsize', 14);                % Set font size
set(gca, 'fontweight', 'bold');          % Set font weight

% Sampled signal at fs2
subplot(4, 1, 3);
plot(t_fs2, cos_fs2, 'g-s', 'LineWidth', 2);  % Use plot with square markers
title('Sampled Cosine Signal at 60 Hz');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;
set(gca, 'fontname', 'Times New Roman');  % Set font name
set(gca, 'fontsize', 14);                % Set font size
set(gca, 'fontweight', 'bold');          % Set font weight

% Sampled signal at fs3
subplot(4, 1, 4);
plot(t_fs3, cos_fs3, 'k-d', 'LineWidth', 2);  % Use plot with diamond markers
title('Sampled Cosine Signal at 30 Hz');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;
set(gca, 'fontname', 'Times New Roman');  % Set font name
set(gca, 'fontsize', 14);                % Set font size
set(gca, 'fontweight', 'bold');          % Set font weight

% Display complete figure layout
sgtitle('Cosine Signal Sampling at Different Frequencies');



% Load the input audio file
[inputAudio, wav_fs] = audioread('/Users/toddnielsen/Desktop/School/Semesters/Fall/Fall_2024/ECE_6530/Final_Project/Final_Project_Group_11/assets/audio/DetectedNotes_DoubleTempo.wav');
%disp(['Sampling rate of input file: ', num2str(wav_fs), ' Hz']);

% Extract the x component of the input audio
if size(inputAudio, 2) > 1
    x = inputAudio(:, 1);  % Take the first channel if stereo
else
    x = inputAudio;  % Use the mono signal directly
end

% Define cosine signal parameters
f = 30;  % Frequency of the cosine wave (Hz)
fs = 32;  % Sampling frequency for the cosine signal
t = -0.5:1/fs:0.5;  % Time vector for the cosine signal

c = cos(2 * pi * f * t);  % Cosine signal
%c = cos(2 * pi * f * new_t);  % Cosine signal

% Match the length of x to the length of the cosine signal
x_resampled = resample(x, length(c), length(x));  % Resample x to match c's length

% Combine the cosine signal with the x component
x_c = x_resampled + c';  % Combine signals (transpose c to match dimensions)

% Plot the signals
figure(4);
plot(t, x_resampled, 'r', 'LineWidth', 2);  % Plot x component in red
hold on;
plot(t, x_c, 'b', 'LineWidth', 2);  % Plot x + c component in blue
title('Comparison of $x$ and $x_c = x + c$', 'Interpreter', 'latex');
xlabel('Time (s)');
ylabel('Amplitude');
legend('x (Audio Component)', 'x_c = x + c (Combined Signal)', 'Location', 'best');
grid on;
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
