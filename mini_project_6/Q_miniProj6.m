% Part One: Reading and segmenting the audio file
% Read the audio file
[audioData, fs] = audioread('AuntRhody.wav');

% Define segment duration in seconds and calculate the segment length in samples
segmentDuration = 0.05; % 50 ms (can be adjusted between 0.05 to 0.1 seconds)
segmentLength = round(segmentDuration * fs);

% Reshape the audio into segments (ensure the total length is divisible by segment length)
totalSamples = floor(length(audioData) / segmentLength) * segmentLength;
audioData = audioData(1:totalSamples); % Truncate to make it divisible
segments = reshape(audioData, segmentLength, []);

% Define silence threshold
threshold = 0.01; % Adjust as needed for your data

% Initialize output variables
noteNumbers = [];
timestamps = [];

% Loop through segments to detect notes
for ii = 1:size(segments, 2)
    segment = segments(:, ii);
    [noteNum, maxVal] = noteDetect(segment, fs, threshold);

    if noteNum ~= -1 % Exclude silence
        noteNumbers = [noteNumbers, noteNum];
        timestamps = [timestamps, (ii-1) * segmentDuration];
    end

    % Display information for debugging purposes
    %fprintf('%d is note %d, max = %.2f\n', ii, noteNum, maxVal);
end

% Display compact output
fprintf('Notes:\n');
disp(noteNumbers);
disp('Timestamps (s):');
disp(timestamps);

% Generate the double tempo audio file using notes and timestamps
maxTime = timestamps(end) * 2 + segmentDuration / 2; % Calculate total time for doubled tempo
outputAudio = zeros(round(maxTime * fs), 1); % Initialize output audio with sufficient size

for i = 1:length(noteNumbers)
    if noteNumbers(i) ~= -1 % Skip silence
        t = 0:1/fs:segmentDuration/2 - 1/fs; % Time vector for half segment duration
        freq = noteNumbers(i); % Use note frequency as the tone
        tone = 0.5 * sin(2 * pi * freq * t); % Generate a sine wave
        startIdx = round(timestamps(i) * 2 * fs) + 1;
        endIdx = startIdx + length(tone) - 1;
        
        % Ensure indices are within bounds of outputAudio
        if endIdx > length(outputAudio)
            endIdx = length(outputAudio);
            tone = tone(1:(endIdx - startIdx + 1)); % Truncate tone if needed
        end
        
        outputAudio(startIdx:endIdx) = outputAudio(startIdx:endIdx) + tone'; % Add tone to output
    end
end

% Normalize the audio to prevent clipping
outputAudio = outputAudio / max(abs(outputAudio));

% Save the new audio file
outputFolder = '/Users/toddnielsen/Desktop/School/Semesters/Fall/Fall_2024/ECE_6530/Final_Project/Final_Project_Group_11/assets/audio/';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% Combine the folder path and file name
outputFilename = fullfile(outputFolder, 'DoubleTempo.wav');

%outputFilename = 'DoubleTempo.wav';
audiowrite(outputFilename, outputAudio, fs);

% Save notes and timestamps to a text file
notesFile = 'Notes_Timestamps.txt';
fileID = fopen(notesFile, 'w');
for i = 1:length(noteNumbers)
    fprintf(fileID, 'Note: %d, Timestamp: %.2f s\n', noteNumbers(i), timestamps(i));
end
fclose(fileID);

% Step 1: Read the .wav File
[wav_signal, wav_fs] = audioread('DoubleTempo.wav'); % Replace 'AuntRhody_DoubleTempo_FromNotes.wav' with your actual file name

% Step 2: Define Sampling Frequencies
org_fs=30;
fs1 = 80; % Sampling frequency 1
fs2 = 60; % Sampling frequency 2
fs3 = 30; % Sampling frequency 3

start_time = -0.5;
end_time = 0.5;

% Resample the .wav File
wav_resampled = resample(wav_signal, fs1, wav_fs);

% Define the Time Vector and Trim/Pad the Signal
t = -0.5:1/fs1:0.5; % Time vector for the cosine signal
 % Trim or pad the signal to match the length of the time vector
 for i = 1:length(fs1)
    if length(wav_resampled) < length(t)
        wav_padded = [wav_resampled; zeros(length(t) - length(wav_resampled), 1)];
    else
        wav_padded = wav_resampled(1:length(t));
    end
end

% Generate the Cosine Signal
f = 30; % Frequency of the cosine signal
cosine_signal = cos(2 * pi * f * t); % Generate the cosine wave

% Combine the Signals
combined_signal = wav_padded' + cosine_signal; % Ensure wav_padded is a row vector

% Normalize before writing
combined_signal = combined_signal / max(abs(combined_signal));

outputFolder = '/Users/toddnielsen/Desktop/School/Semesters/Fall/Fall_2024/ECE_6530/Final_Project/Final_Project_Group_11/assets/audio/';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% Combine the folder path and file name
outputFilename = fullfile(outputFolder, 'fs80_output.wav');

%outputFilename = 'DoubleTempo.wav';
audiowrite(outputFilename, combined_signal, fs1);


% Save the Combined Signal (Optional)
%audiowrite(['output_fs', num2str(fs1), '.wav'], combined_signal, fs1); % Save the combined signal to a new .wav file

% Resample the .wav File
wav_resampled2 = resample(wav_signal, fs2, wav_fs);

% Define the Time Vector and Trim/Pad the Signal
t2 = -0.5:1/fs2:0.5; % Time vector for the cosine signal
 % Trim or pad the signal to match the length of the time vector
  for i = 1:length(fs2)
    if length(wav_resampled2) < length(t2)
        wav_padded2 = [wav_resampled2; zeros(length(t2) - length(wav_resampled2), 1)];
    else
        wav_padded2 = wav_resampled2(1:length(t2));
    end
  end
% Generate the Cosine Signal
f = 30; % Frequency of the cosine signal
cosine_signal2 = cos(2 * pi * f * t2); % Generate the cosine wave


% Combine the Signals
combined_signal2 = wav_padded2' + cosine_signal2; % Ensure wav_padded2 is a row vector
% Normalize before writing
combined_signal2 = combined_signal2 / max(abs(combined_signal2));
outputFolder = '/Users/toddnielsen/Desktop/School/Semesters/Fall/Fall_2024/ECE_6530/Final_Project/Final_Project_Group_11/assets/audio/';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% Combine the folder path and file name
outputFilename = fullfile(outputFolder, 'fs60_output.wav');

%outputFilename = 'DoubleTempo.wav';
audiowrite(outputFilename, combined_signal2, fs2);

% Save the Combined Signal (Optional)
%audiowrite(['output_fs', num2str(fs2), '.wav'], combined_signal2, fs2); % Save the combined signal to a new .wav file

% Resample the .wav File
wav_resampled3 = resample(wav_signal, fs3, wav_fs);

% Define the Time Vector and Trim/Pad the Signal
t3 = -0.5:1/fs3:0.5; % Time vector for the cosine signal
 % Trim or pad the signal to match the length of the time vector
  for i = 1:length(fs3)
    if length(wav_resampled3) < length(t3)
        wav_padded3 = [wav_resampled3; zeros(length(t3) - length(wav_resampled3), 1)];
    else
        wav_padded3 = wav_resampled3(1:length(t3));
    end
  end
% Generate the Cosine Signal
f = 30; % Frequency of the cosine signal
cosine_signal3 = cos(2 * pi * f * t3); % Generate the cosine wave



% Combine the Signals
combined_signal3 = wav_padded3' + cosine_signal3; % Ensure wav_padded3 is a row vector
% Normalize before writing
combined_signal3 = combined_signal3 / max(abs(combined_signal3));

outputFolder = '/Users/toddnielsen/Desktop/School/Semesters/Fall/Fall_2024/ECE_6530/Final_Project/Final_Project_Group_11/assets/audio/';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% Combine the folder path and file name
outputFilename = fullfile(outputFolder, 'fs30_output.wav');

%outputFilename = 'DoubleTempo.wav';
audiowrite(outputFilename, combined_signal3, fs3);


% Save the Combined Signal (Optional)
%audiowrite(['output_fs', num2str(fs3), '.wav'], combined_signal3, fs3); % Save the combined signal to a new .wav file

figure(1);
subplot(3, 1, 1);
plot(t, combined_signal,'LineWidth',2);
xlabel('Time (s)');
ylabel('Amplitude');
title(['fs = ', num2str(fs1), ' Hz']);
set(gca, 'fontname', 'Times New Roman');
set(gca,'fontsize',14);
set(gca,'fontweight', 'bold');

subplot(3, 1, 2);
plot(t2, combined_signal2,'LineWidth',2);
xlabel('Time (s)');
ylabel('Amplitude');
title(['fs = ', num2str(fs2), ' Hz']);
set(gca, 'fontname', 'Times New Roman');
set(gca,'fontsize',14);
set(gca,'fontweight', 'bold');

subplot(3, 1, 3);
plot(t3, combined_signal3,'LineWidth',2);
xlabel('Time (s)');
ylabel('Amplitude');
title(['fs = ', num2str(fs3), ' Hz']);
set(gca, 'fontname', 'Times New Roman');
set(gca,'fontsize',14);
set(gca,'fontweight', 'bold');

% Step 1: Read the .wav File
%[wav_signal, wav_fs] = audioread('DoubleTempo.wav'); % Replace 'AuntRhody_DoubleTempo_FromNotes.wav' with your actual file name

% Step 2: Resample the .wav File if Necessary
new_fs = 32; % Desired sampling frequency (matching the cosine signal)
new_wav_resampled = resample(wav_signal, new_fs, wav_fs);

% Step 3: Define the Time Vector and Trim/Pad the Signal
new_t = -0.5:1/new_fs:0.5; % Time vector for the cosine signal

% Trim or pad the signal to match the length of the time vector
if length(new_wav_resampled) < length(new_t)
    new_wav_padded = [new_wav_resampled; zeros(length(new_t) - length(new_wav_resampled), 1)];
else
    new_wav_padded = new_wav_resampled(1:length(new_t));
end

% Step 4: Generate the Cosine Signal
f = 30; % Frequency of the cosine signal
new_cosine_signal = cos(2 * pi * f * new_t); % Generate the cosine wave

% Step 5: Combine the Signals
new_combined_signal = new_wav_padded' + new_cosine_signal; % Ensure new_wav_padded is a row vector
% Normalize before writing
new_combined_signal = new_combined_signal / max(abs(new_combined_signal));

% Step 7: Save the Combined Signal (Optional)
audiowrite('output.wav', new_combined_signal, new_fs); % Save the combined signal to a new .wav file

sample_times4 = 0:1/32:(length(new_t)-1)/32;
c4 = cos(2*pi*f*sample_times4);
c5 = c4 + new_t;

% Step 6: Plot the Combined Signal
figure(2);
plot(new_t, new_combined_signal, 'LineWidth', 2);
hold on;
plot(new_t, c5, 'LineWidth', 2);
hold off;
xlabel('Time (s)');
ylabel('Amplitude');
%title('Combined Signal');
title(['Combined Signal (fs = ', num2str(new_fs), ' Hz)']);
legend('Combined Signal (Resampled + Cosine)', 'Modified Cosine Signal (Cosine + Time Vector)', 'Location', 'best');
set(gca, 'fontname', 'Times New Roman');
set(gca,'fontsize',14);
set(gca,'fontweight', 'bold');

% NoteDetect Function Placeholder
function [noteNum, maxVal] = noteDetect(segment, fs, threshold)
    % Perform FFT
    N = length(segment);
    Y = abs(fft(segment));
    Y = Y(1:floor(N/2)); % Take positive frequencies only
    freqs = (0:floor(N/2)-1) * (fs / N);

    % Find the peak frequency
    [maxVal, idx] = max(Y);
    if maxVal > threshold
        noteNum = round(freqs(idx)); % Simplified note number mapping
    else
        noteNum = -1; % Silence
        maxVal = 0;
    end
end
