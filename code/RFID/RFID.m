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
M = 2;
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

% Demodulateur AM ---------------------------------------------------------
dem = abs(signal_1a);
plot(time, signal_1a)
% baud_a1 = liste des symboles transmis de signal_1a

