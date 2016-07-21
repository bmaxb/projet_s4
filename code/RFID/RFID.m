clc; clear; close all
% Le nombre de colonnes correspond au nombre d'émetteurs.
% Chaque ligne donne pour chaque émetteur le symbole transmis.
% 0 Rien de transmis
% 1 FL1
% 2 FH1
% 3 FL2
% 4 FH2
% 5 FL3
% 6 FH3
M = 3;
F0 = 436327400; % 436.3274 MHz
Bw = 330000; % 330 kHz
load('signaux.mat')


% Calcul de F_H et F_L en fonction de M -----------------------------------
% +/- 2.2 kHz
F_H = [];
for i = 1:M
    F_H(i) = F0 + Bw*((1 + 2*(i-1))/(4*M));
end
F_L = F_H - Bw/2;

% Oscillateur local L_O2 --------------------------------------------------
L_O2 = 10600000; % Hz
N = length(signal_1a);
dx = 0:0.001:2;
oscill = @(x) sin(2*pi*L_O2*x);
plot(dx, oscill(dx))
figure

% Demodulateur AM ---------------------------------------------------------
dem = abs(signal_1a);
plot(signal_1a)
figure

plot(abs(fft(signal_1a(1400:3200))))
% baud_a1 = liste des symboles transmis de signal_1a

