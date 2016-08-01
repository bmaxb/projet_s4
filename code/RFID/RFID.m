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
load('signaux.mat')

M = 2; % Nombre d'emetteurs sur le Bw
signal = signal_2a; % signal etudier
baud = baud_2a; % réponse baud à titre de comparaison

showgraph = 1;

F0 = 436327400; % 436.3274 MHz
F1 = 10700000; % 10.7 MHz 
Bw = 330000; % 330 kHz
Br = 66000; % Baudrate... nb de symboles

Ts = time(2) - time(1);
Fs = 1/Ts;

if showgraph == 1
    figure(1)
    plot(abs(fft(signal)))
    title('FFT du signal après A/D')
end

% Oscillateur local L_O2 --------------------------------------------------
L_O2 = 10700000 - Bw/2; % Prend en compte la bande effective
L_O2 = L_O2 - mod(L_O2,50000); % Transforme en multiple de 50kHz
disp(['Valeur de L_O2: ' num2str(L_O2) 'Hz'])
disp(['Multiple 50k pour L_O2: ' num2str(L_O2/50000)])

N = length(signal_1a);
oscill = @(x) sin(2*pi*L_O2*x);

% application de la sinusoide au signal
signal = signal.*oscill(time);

if showgraph == 1
    hold on
    plot(abs(fft(signal)))
    title('FFT du signal')
    legend('FFT du signal après A/D', 'FFT du signal après L_O_2')    
    axis tight
end

% Rejet de bande ----------------------------------------------------------
% Trouver la position du peak du signal recentré
%[max,ind] = max(abs(fft(signal)));
Fcentrer = F1 - L_O2;
Fpass = Fcentrer + Bw;
Fn = Fs/2;

[b,a] = butter_lowpass(4, Fpass/Fn);

% Rejet d'image sur le signal
signal = filter(b,a,signal);

if showgraph == 1
    hold on
    [h,w] = freqz(b,a,N/2);
    m = max(abs(fft(signal)));
    plot(abs(h)*m,'LineWidth',1.5)
    stem(Fcentrer*N/Fs,m)
    
    figure(2)
    plot((abs(fft(signal))))
    title('FFT du signal après rejet d''image')
    axis tight
end

% Decimation de 64 --------------------------------------------------------
signal = decimate(signal,64);

% Calcul de F_H et F_L en fonction de M -----------------------------------
% +/- 2.2 kHz
F_H = [];
for i = 1:M
    F_H(i) = Fcentrer + Bw*((1 + 2*(i-1))/(4*M));
end
F_L = F_H - Bw/2;

nbSamples = 12;
nbBauds = length(signal)/nbSamples;
Fs2 = Br*nbSamples;

if showgraph == 1
    figure(3)
    y = (abs(fft(signal)));
    y_max = max(y);
    plot(y)
    title('FFT du signal après décimation de 64')
    hold on
    stem(F_L.*(length(signal)/Fs2),ones(M,1)*y_max,'LineWidth',1.5)
    stem(F_H.*(length(signal)/Fs2),ones(M,1)*y_max,'LineWidth',1.5)
end


% Banc de filtres FII------------------------------------------------------
N = length(signal);
Fc_offset = (F_H(1) - F_L(end))/2;
messages = [];
for i = 1:M
    % F_L
    [b,a] = butter_bandpass(10, F_L(i), Fc_offset, Fs2);
    [h,w] = freqz(b,a,N/2);
    plot(abs(h*y_max),'LineWidth',1.5)
    messages(:,i) = filtfilt(b,a,signal);
    
    % F_H
    [b,a] = butter_bandpass(10, F_H(i), Fc_offset, Fs2);
    [h,w] = freqz(b,a,N/2);
    plot(abs(h*y_max),'LineWidth',1.5)
    messages(:,i+M) = filtfilt(b,a,signal);
end


if showgraph == 1
    figure(5)
    plot(abs(fft(messages)))
    title('Fréquences filtrées individuellement')
end

% Demodulateur AM ---------------------------------------------------------
% Redresseur
messages = abs(messages);

% Application d'une fenètre
fenetre = triang(nbSamples);
for n = 1:nbSamples:N
    for m = 1:M*2
        messages(n:n+nbSamples-1,m) = fenetre.*messages(n:n+nbSamples-1,m);
    end
end

% Moyenne mobile lente
window_size = 50;
seuil = [];
for m = 1:M*2
    moyenne_lente = smooth(messages(:,m), window_size);
    
    % Détermination du seuil
    constante_de_correction = 1.40;
    seuil(:,m) = mean(moyenne_lente)*constante_de_correction;
    
    if showgraph == 1
        figure(5+m)
        hold on
        stem(messages(:,m))
        plot(moyenne_lente,'LineWidth',1.5)
        plot(ones(length(messages(:,m)),1)*seuil(:,m),'LineWidth',1.5)
        title(['Extrait du signal de la fréquence ' message_name(m,M)])
        axis([2800 3200 0 max(messages(:,m))])
    end
end

% Démodulateur FSK --------------------------------------------------------
messages_moyennes = zeros(size(messages));
baud_output = [];
for n = 1:nbSamples:N
    bits = [];
    for m = 1:M
        lapse = n:n+nbSamples-1;
        
        moyenne_H = mean(messages(lapse,m+M));
        moyenne_L = mean(messages(lapse,m));
        
        messages_moyennes(lapse,m+M) = ones(nbSamples,1)*moyenne_H;
        messages_moyennes(lapse,m) = ones(nbSamples,1)*moyenne_L;
        
        H = moyenne_H > seuil(m+M);
        L = moyenne_L > seuil(m);
        
        out = bi2de([L,H]);
        out = (out~=0 && m~=1)*m + out;
        bits = [bits, out];
    end
    baud_output = [baud_output; bits];
end

if showgraph == 1
    for m = 1:M*2
        figure(5+m)
        hold on
        plot(messages_moyennes(:,m),'LineWidth',1.5)
        legend([message_name(m,M) ' dans le temporel'], ['Moyenne lente (' num2str(window_size) ')'], 'Seuil (moyenne-lente*1.4)', 'Moyenne rapide')
        
        figure(5+M*2+1)
        if m <= M
            subplot(M,2,2*m-1)
        else
            subplot(M,2,(m-M)*2)
        end
        hold on
        stem(messages_moyennes(1:nbSamples:end,m))
        plot(ones(length(messages_moyennes(:,m))/nbSamples,1)*seuil(:,m))
        title(['Démodulateur FSK sur ' message_name(m,M) ', seuil = ' num2str(seuil(:,m))])
        axis tight
    end
end

% Analyse des erreurs
disp(' ')
err_quad = mean((baud_output-baud).^2);
disp(['Erreur quadratique: ' num2str(err_quad)])
err_diff = sum(baud_output~=baud);
disp(['Nombre de baud de différence: ' num2str(err_diff)])
