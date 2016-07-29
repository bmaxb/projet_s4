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

M = 1; % Nombre d'emetteurs sur le Bw
F0 = 436327400; % 436.3274 MHz
Bw = 330000; % 330 kHz
Br = 66000; %Baudrate... nb de symboles
load('signaux.mat')



signal = signal_1a; % signal etudier
showgraph = [1 2 3 4];

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
L_O2 = 10700000 - Bw/2; % Prend en compte la bande effective
L_O2 = L_O2 + mod(L_O2,50000); % Transforme en multiple de 50kHz
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
%[max,ind] = max(abs(fft(signal)));
F1 = 10700000 - L_O2;
Fs = F1*N/ind;
Fpass = F1 + Bw/2;
Fstop = Fpass + Bw/2;

filtre = butter_filter(Fs, Fpass, Fstop);

% Rejet d'image sur le signal
signal = filter(filtre,signal);
    
if ismember(3,showgraph)
    figure
    plot(abs(fft(signal)))
    title('FFT du signal après rejet d''image')
    hold on
    stem(Bw*N/Fs,10000)
end

% Decimation de 64 --------------------------------------------------------
signal = decimate(signal,40);

if ismember(4,showgraph)
    figure
    plot(abs(fft(signal)))
    title('FFT du signal après décimation de 64')
end

% Banc de filtres FII------------------------------------------------------
Fs2 = Br * 14000; % Avoir au moins une Fs de 2 * 436,4924 MHz
b_FII_FH = {}; a_FII_FH = {}; k_FH = {};
b_FII_FL = {}; a_FII_FL = {}; k_FL = {};
for i = 1:M
    largeur_FL_FH = Bw/(2*M);
    fc1_FH = F_H(i) - (largeur_FL_FH /2);
    fc2_FH = F_H(i) + (largeur_FL_FH /2);
    fc1_FL = F_L(i) - (largeur_FL_FH /2);
    fc2_FL = F_L(i) + (largeur_FL_FH /2);
    
   [b_FII_FH{i}, a_FII_FH{i}, k_FH{i}] = butter(10, [fc1_FH, fc2_FH]/(Fs2/2), 'bandpass');
   [b_FII_FL{i}, a_FII_FL{i}, k_FL{i}] = butter(10, [fc1_FL, fc2_FL]/(Fs2/2), 'bandpass');
end

for i = 1:M
    figure 
    zplane(b_FII_FH{i},a_FII_FH{i})
    figure
    zplane(b_FII_FL{i},a_FII_FL{i})
end

% Demodulateur AM ---------------------------------------------------------
% On pourrait demoduler avec fskdemod()
dem = abs(signal_1a);

%figure
%plot(signal_1a)
%title('Signal de 1a')

%figure
%plot(abs(fft(signal_1a(1400:3200))))
%title('Spectre de frequence du signal 1a')
% baud_a1 = liste des symboles transmis de signal_1a

