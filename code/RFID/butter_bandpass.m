% Projet S4
% Equipe P5
function [b, a] = butter_bandpass(N, Fpass, Fc_offset, Fs)
%BUTTER_BANDPASS Returns a discrete-time filter object.

% Butterworth Bandpass filter designed using FDESIGN.BANDPASS.

% All frequency values are normalized to 1.

% N = 10;   % Order
Fc1 = Fpass - Fc_offset;  % First Cutoff Frequency
Fc2 = Fpass + Fc_offset;  % Second Cutoff Frequency

[b,a] = butter(N, [Fc1, Fc2] ./ (Fs/2), 'bandpass');
% [EOF]
