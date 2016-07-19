clc; clear all; close all;

%% fonction de transfert de la plaque en z
num = 30.87;
den = [1 31.3 -1274 -39870];

FT = tf(num,den);

%% spécifications 

Mp = 5/100;
ts = 0.030;
tp = 0.025;
tr = 0.020;

%% paramètres

zeta = sqrt(log(Mp)^2 / (pi^2 + log(Mp)^2));
wn_ts = 4 / (ts * zeta);
wn_tp = pi / (sqrt(1-zeta^2)*tp);
wn_tr = (1 + 1.1*zeta+1.4*zeta^2)/tr;

wn = wn_ts;

pdes = [1 wn*zeta*2 wn^2];
pdes = roots(pdes);

figure(1)
rlocus(FT)
hold on
plot(pdes,'p')

phaFT = angle(polyval(num,pdes(1))/polyval(den,pdes(1))) * 180/pi-360;


dphi = (-180 - phaFT);
phi = acosd(zeta);
alpha = 180 - phi;
z = -134;
phiz = atand(imag(pdes(1))/(real(pdes(1))-z));
phiP = phiz - dphi;
p = real(pdes(1)) - imag(pdes(1))/tand(phiP);

numAv = [1 -z];
denAv = [1 -p];

FTa = tf(numAv,denAv);
FTFTa = series(FTa,FT);
[numka,denka] = tfdata(FTFTa,'v');

ka = abs(polyval(denka,pdes(1))/polyval(numka,pdes(1)));

FTFTa = FTFTa * ka;
poles = pzmap(FTFTa);

figure(2)
rlocus(FTFTa)
hold on
plot(pdes,'p')
plot(poles,'s')

figure(3)
step(feedback(FTFTa,1))
stepinfo(feedback(FTFTa,1))








