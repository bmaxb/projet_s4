% Projet S4
% Equipe P5
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
signal = signal_2a; % signal etudier
baud = baud_2a; % r�ponse baud � titre de comparaison

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
    title('FFT du signal apr�s A/D')
end

% Oscillateur local L_O2 --------------------------------------------------
L_O2 = 10700000 - Bw/2; % Prend en compte la bande effective
L_O2 = L_O2 - mod(L_O2,50000); % Transforme en multiple de 50kHz

N = length(signal_1a);
oscill = @(x) sin(2*pi*L_O2*x);

% application de la sinusoide au signal
signal = signal.*oscill(time);

if showgraph == 1
    hold on
    plot(abs(fft(signal)))
    title('FFT du signal')
    legend('FFT du signal apr�s A/D', 'FFT du signal apr�s L_O_2')    
    axis tight
end

% Rejet de bande ----------------------------------------------------------
% Trouver la position du peak du signal recentr�
%[max,ind] = max(abs(fft(signal)));
Fcentrer = F1 - L_O2;
Fpass = Fcentrer + Bw;
Fn = Fs/2;

[b,a] = butter_lowpass(4, Fpass/Fn);
rejet_image = tf2sos(b,a);

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
    title('FFT du signal apr�s rejet d''image')
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
    title('FFT du signal apr�s d�cimation de 64')
    hold on
    stem(F_L.*(length(signal)/Fs2),ones(M,1)*y_max,'LineWidth',1.5)
    stem(F_H.*(length(signal)/Fs2),ones(M,1)*y_max,'LineWidth',1.5)
end


% Banc de filtres FII------------------------------------------------------
N = length(signal);
Fc_offset = (F_H(1) - F_L(end))/2;
messages = [];
filtres_RII = [];
m = 1;
for i = 1:M
    % F_L
    [b,a] = butter_bandpass(2, F_L(i), Fc_offset, Fs2);
    [h,w] = freqz(b,a,N/2);
    plot(abs(h*y_max),'LineWidth',1.5)
    messages(:,i) = filtfilt(b,a,signal);
    filtres_RII(m:m+1,:) = tf2sos(b,a);
    
    % F_H
    [b,a] = butter_bandpass(2, F_H(i), Fc_offset, Fs2);
    [h,w] = freqz(b,a,N/2);
    plot(abs(h*y_max),'LineWidth',1.5)
    messages(:,i+M) = filtfilt(b,a,signal);
    filtres_RII(m+M*2:m+M*2+1,:) = tf2sos(b,a);
    m = m+2;
end


if showgraph == 1
    figure(5)
    plot(abs(fft(messages)))
    title('Fr�quences filtr�es individuellement')
end

% Demodulateur AM ---------------------------------------------------------
% Redresseur
messages = abs(messages);

% Application d'une fen�tre
fenetre = triang(nbSamples);
for n = 1:nbSamples:N
    for m = 1:M*2
        messages(n:n+nbSamples-1,m) = fenetre.*messages(n:n+nbSamples-1,m);
    end
end

% Moyenne mobile lente
window_size = nbSamples*150;
moyennes_lente = [];
for m = 1:M*2
    % Creation de la moyenne lente
    y = [mean(messages(1:window_size,m))*ones(window_size,1); messages(:,m); mean(messages(end-window_size:end,m))*ones(window_size,1)];
    moyenne_lente = smooth(y, window_size);
    moyenne_lente = moyenne_lente(window_size:end-window_size); % Correction des bordures
    
    % D�termination du seuil
    constante_de_correction = 2;
    moyennes_lente(:,m) = moyenne_lente;
end

% D�modulateur FSK --------------------------------------------------------
messages_moyennes = zeros(size(messages));
bits_output = [];
baud_output = [];
for n = 1:nbSamples:N
    dec = [];
    bits = [];
    for m = 1:M
        lapse = n:n+nbSamples-1;
        
        moyenne_H = mean(messages(lapse,m+M));
        moyenne_L = mean(messages(lapse,m));
        
        seuil_H = mean(moyennes_lente(lapse,m+M));
        seuil_L = mean(moyennes_lente(lapse,m));
        
        messages_moyennes(lapse,m+M) = ones(nbSamples,1)*moyenne_H;
        messages_moyennes(lapse,m) = ones(nbSamples,1)*moyenne_L;
        
        H = moyenne_H > seuil_H;
        L = moyenne_L > seuil_L;
        
        out = bi2de([L,H]);
        out = (out~=0 && m~=1)*m + out;
        dec = [dec, out];
        
        bits(m+M) = H;
        bits(m) = L;
    end
    baud_output = [baud_output; dec];
    bits_output = [bits_output; bits];
end

if showgraph == 1
    for m = 1:M*2
        figure(5+m)
        hold on
        stem(messages(:,m))
        plot(moyenne_lente,'LineWidth',1.5)
        plot(messages_moyennes(:,m),'LineWidth',1.5)
        title(['Extrait du signal de la fr�quence ' message_name(m,M)])
        axis([2800 3200 0 max(messages(:,m))])
        legend([message_name(m,M) ' dans le temporel'], ['Moyenne lente (' num2str(window_size) ')'], 'Moyenne rapide')
        
        figure(5+M*2+1)
        if m <= M
            subplot(M,2,2*m-1)
        else
            subplot(M,2,(m-M)*2)
        end
        hold on
        stem(messages_moyennes(1:nbSamples:end,m))
        plot(moyennes_lente(1:nbSamples:end,m))
        title(['D�modulateur FSK sur ' message_name(m,M)]);
        axis tight
    end
end
% LO2
% N emetteur
% Structure filtre : -a1 -a2 b0 b1 b2
% Filtre rejet dimage Q31
% banc de filtres rii
% baud error

% Affichage des informations ----------------------------------------------
disp(' ')
disp(['Valeur de L_O2: ' num2str(L_O2) 'Hz'])
disp(['Multiple 50k pour L_O2: ' num2str(L_O2/50000)])
disp(['Nombre d''�metteurs: ' num2str(M)])
disp(' ')

disp('Structure des filtres: SOS (-a1 -a2 b0 b1 b2)')
gain_rejet = 2;
disp(['Gain pour le rejet d''image: ' num2str(gain_rejet)])
disp('SOS pour rejet d''image: ')
rejet_image = [-rejet_image(:,5:6) rejet_image(:,1:3)];
disp(dec2Qformat(rejet_image./gain_rejet,[0,31]))

gain_RII = 4;
disp(['Gain pour le banc de filtre: ' num2str(gain_RII)])
disp('SOS du Banc de filtres RII:')
m = 1;
for i = 1:2:length(filtres_RII(:,1))
   disp([message_name(m,M) ':'])
   sos = filtres_RII(i:i+1,:);
   sos = [-sos(:,5:6) sos(:,1:3)];
   
   disp(dec2Qformat(sos./gain_RII,[0,15]))
   m = m + 1;
end

% Baud Error Rate ---------------------------------------------------------
err_diff = sum(baud_output~=baud);
disp(['Baud Error Rate: ' num2str(err_diff/length(bits_output(:,1)))])
disp(['Nombre de baud de diff�rence: ' num2str(err_diff)])

% Autres
if 1 == 0
    err_quad = mean((baud_output-baud).^2);
    disp(['Erreur quadratique: ' num2str(err_quad)])
    % Bit Error Rate
    bit_err = [];
    for m = 1:M
        ref = baud(:,m);
        ref(ref~=0) = ref(ref~=0) - (m~=1)*m;
        ref = de2bi(ref);
        out = [bits_output(:,m), bits_output(:,m+M)];
        bit_err = [bit_err, biterr(ref, out)];
    end
    bit_err = bit_err/length(bits_output(:,1));
    disp(['Bit Error Rate: ' num2str(bit_err)])
end