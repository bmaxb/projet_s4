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
F0 = 436327400; % 436.3274 MHz
Bw = 330000; % 330 kHz
load('signaux.mat')


M = 1;
signal = signal_1a; % signal etudier
showgraph = [1 2 3];

% Calcul de F_H et F_L en fonction de M -----------------------------------
% +/- 2.2 kHz
F_H = [];
for i = 1:M
    F_H(i) = F0 + Bw*((1 + 2*(i-1))/(4*M));
end
F_L = F_H - Bw/2;

if ismember(1,showgraph)
    figure
    plot(abs(fft(signal)))
    title('FFT du signal après A/D')
end

% Oscillateur local L_O2 --------------------------------------------------
L_O2 = 10700000 - Bw; % Prend en compte la bande effective
L_O2 = L_O2 - mod(L_O2,50000); % Transforme en multiple de 50kHz
disp(['Valeur de L_O2: ' num2str(L_O2) 'Hz'])
disp(['Multiple 50k pour L_O2: ' num2str(L_O2/50000)])

N = length(signal_1a);
oscill = @(x) sin(2*pi*L_O2*x);

% application de la sinusoide au signal
signal = signal.*oscill(time);

if ismember(2,showgraph)
    hold on
    plot(abs(fft(signal)))
    title('FFT du signal')
    legend('FFT du signal après A/D', 'FFT du signal après L_O_2')
end

% Rejet de bande ----------------------------------------------------------
% Trouver la position du peak du signal recentré
[max,ind] = max(abs(fft(signal)));
F1 = 10700000 - L_O2;
Fs = F1*N/ind;
Fpass = F1 + Bw/2;
Fstop = Fpass + Bw/2;

filtre = butter_filter(Fs, Fpass, Fstop);

% Rejet d'image sur le signal
signal = filter(filtre,signal);

    hold on
    stem(ind,2e4)
    
if ismember(3,showgraph)
    figure
    plot(abs(fft(signal)))
    title('FFT du signal après rejet d''image')
end

% Demodulateur AM ---------------------------------------------------------
dem = abs(signal_1a);
% plot(signal_1a)
% figure
% 
% plot(abs(fft(signal_1a(1400:3200))))
% baud_a1 = liste des symboles transmis de signal_1a

