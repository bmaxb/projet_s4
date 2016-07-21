clc; clear all; close all;

%% fonction de transfert de la plaque en z

num = 47.78;
den = [1 31.3 -2056 -64350];
FT = tf(num,den);

%% spécifications 

PM_des = 25;
wg_des = 185;

%% paramètres

zeta_des = 0.5 * sqrt(tand(PM_des) * sind(PM_des));
wn_des = (wg_des * tand(PM_des))/ (2*zeta_des);
BW_des = wn_des * sqrt((1-2*zeta_des^2) + sqrt(4*zeta_des^4 - 4*zeta_des^2 +2));

%% conception d'avance de phase

magFT = abs(polyval(num,1j*wg_des)/polyval(den,1j*wg_des));

kdes = 1/magFT ;
[GMa,PMa,wga,wpa] = margin(kdes*FT);

for marge = 0:21
    
    found = 0;
    dphi = (PM_des - PMa + marge)/2;
    alpha = (1-sind(dphi))/(1+sind(dphi));
    T = 1/(wg_des * sqrt(alpha));
    za = -1/T;
    pa = -1/(T*alpha);
    
    for kp = 0:20
        numAv = conv([1 -za],[1 -za]);
        denAv = conv([1 -pa],[1 -pa]);
        ka = kdes/sqrt(alpha);
        FTa = tf(numAv*ka,denAv);
        FTFTa = series(FT,FTa);

        FTFTa = FTFTa * kp;
        [numFTa,denFTa] = tfdata(FTFTa,'v');
        
        kpos = abs(numFTa(end)/denFTa(end));

        beta = abs(polyval(kpos*numFTa,1j*wg_des)/polyval(denFTa,1j*wg_des));
        
            pouce = 20;
            Tr = pouce/wg_des;
            zr = -1/Tr;
            pr = -1/(Tr*beta);
            kr = kpos/beta;

            numr = [1 -zr];
            denr = [1 -pr];
            FTr = tf(numr*kr,denr);
            FTFTar = series(FTFTa,FTr);
            [numFTar,denFTar] = tfdata(FTFTar,'v');

            [GM,PM,wg,wp] = margin(FTFTar);
            GM = mag2db(GM);

            kpos = numFTar(end)/denFTar(end);
            erpr = 1/(1+kpos);

            disp(['Avec marge = ',num2str(marge),' et kp = ',num2str(kp)])

            disp([])
            disp(['GM = ',num2str(GM)])
            disp(['PM = ',num2str(PM)])
            disp(['wg = ',num2str(wp)])
            disp(['erp = ',num2str(erpr)])
            disp(' ')
            if  (10 < GM) && (GM < 30) && (25 < PM) && (PM < 50) && (170 < wp) && (wp < 190) && (-0.0004 < erpr) && (erpr < 0)
                found = 1;
                disp('Match found !')
                break
            end
      end
    if found == 1;
        break
    end
end
% figure(1)
% margin(FT)
% hold on
% margin(FT*kdes)
% margin(FTFTa)
% legend('FT','FT avec gain','FT compensé')

% figure(2)
% margin(FTFTa)

% figure(3)
% step(feedback(FTFTa,1))
% title('echelon apres l''avance de phase')


figure(4)
margin(FTFTar)

figure(5)
step(feedback(FTFTar,1))
% axis([0 1000 -4 4])
title('echelon apres l''avance et le retard de phase')













