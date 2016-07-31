clc; clear; close all
% Le nombre de colonnes correspond au nombre d'�metteurs.
% Chaque ligne donne pour chaque �metteur le symbole transmis.
% 0 Rien de transmis
% 1 FL1
% 2 FH1
% 3 FL2
% 4 FH2
% 5 FL3
% 6 FH3
load('signaux.mat')

M = 2; % Nombre d'emetteurs sur le Bw
signal = signal_2b; % signal etudier
baud = baud_2b; % r�ponse baud � titre de comparaison

showgraph = 1;

F0 = 436327400; % 436.3274 MHz
F1 = 10700000; % 10.7 MHz 
Bw = 330000; % 330 kHz
Br = 66000; %Baudrate... nb de symboles

Ts = time(2) - time(1);
Fs = 1/Ts;

if showgraph == 1
    figure(1)
    plot(abs(fft(signal)))
    title('FFT du signal apr�s A/D')
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
    legend('FFT du signal apr�s A/D', 'FFT du signal apr�s L_O_2')    
end

% Rejet de bande ----------------------------------------------------------
% Trouver la position du peak du signal recentr�
%[max,ind] = max(abs(fft(signal)));
Fcentrer = F1 - L_O2;
Fpass = Fcentrer + Bw/2;
Fn = Fs/2;

filtre = butter_lowpass(4, Fpass/Fn);

% Rejet d'image sur le signal
signal = filter(filtre,signal);
    
if showgraph == 1
    hold on
    [h,w] = freqz(filtre,N/2);
    m = max(abs(fft(signal)));
    plot(abs(h)*m)
    stem(Fcentrer*N/Fs,m)
    
    figure(2)
    plot((abs(fft(signal))))
    title('FFT du signal apr�s rejet d''image')
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
    title('FFT du signal apr�s d�cimation de 64')
    hold on
    stem(F_L.*(length(signal)/Fs2), ones(M,1)*y_max)
    stem(F_H.*(length(signal)/Fs2), ones(M,1)*y_max)
end


% Banc de filtres FII------------------------------------------------------
N = length(signal);
Fc_offset = (F_H(1) - F_L(end))/2;
messages = [];
for i = 1:M
    % F_L
    [b,a] = butter_bandpass(10, F_L(i), Fc_offset, Fs2);
    [h,w] = freqz(b,a,N/2);
    plot(abs(h*y_max))
    messages(:,i) = filtfilt(b,a,signal);
    
    % F_H
    [b,a] = butter_bandpass(10, F_H(i), Fc_offset, Fs2);
    [h,w] = freqz(b,a,N/2);
    plot(abs(h*y_max))
    messages(:,i+M) = filtfilt(b,a,signal);
end


if showgraph == 1
    figure(4)
    plot(abs(fft(messages)))
    title('Messages filtr�s individuellement')
end

% Demodulateur AM ---------------------------------------------------------
% Redresseur
messages = abs(messages);
% Moyenne mobile lente
window_size = 50;
seuil = [];
for m = 1:M*2
    moyenne_lente = smooth(messages(:,m), window_size);
    
    % Moyenne des moyennes
    seuil(:,m) = mean(moyenne_lente)*1.40;
    
    
    if showgraph == 1
        figure(4+m)
        hold on
        stem(messages(:,m))
        plot(moyenne_lente)
        plot(seuil(:,m),'LineWidth',2)
        plot(ones(length(messages(:,m)),1)*seuil(:,m))
        title(['Moyenne mobile lente du message ' num2str(m)])
        axis([2800 3200 0 max(messages(:,m))])
    end
end

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
        figure(4+m)
        hold on
        plot(messages_moyennes(:,m))
        
        figure(4+M*2+1)
        subplot(M,2,m)
        hold on
        stem(messages_moyennes(1:nbSamples:end,m))
        plot(ones(length(messages_moyennes(:,m))/nbSamples,1)*seuil(:,m))
        title(['Moyennes du message ' num2str(m) ', seuil = ' num2str(seuil(:,m))])
        axis tight
    end
end

% figure
% stem(messages_moyennes(1:nbSamples:end,:))

disp(' ')
err_quad = mean((baud_output-baud).^2);
disp(['Erreur quadratique: ' num2str(err_quad)])
err_diff = sum(baud_output~=baud);
disp(['Nombre de baud de diff�rence: ' num2str(err_diff)])
