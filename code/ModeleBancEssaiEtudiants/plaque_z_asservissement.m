% Projet S4
% Equipe P5
clc; clear all; close all;

%% fonction de transfert de la plaque en z
num = 30.87;
den = [1 31.3 -1274 -39870];

FT = tf(num,den);

%% spécifications 
PMdes = 25;
wgdes = 185;


%% paramètres


figure
margin(FT)

[mag,pha] = bode(FT,wgdes);
kdes = 1/mag;
[Gm,PM,wp,wg] = margin(FT*kdes);
dphi = (PMdes - PM +18.2)/2;
alpha = (1-sind(dphi))/(1+sind(dphi));
T = 1/(wgdes/2*sqrt(alpha));
z = -1/T;
p = -1/(alpha*T);
ka = kdes/sqrt(alpha);
numAV = conv([1 -z],[1 -z]);                    %conv(conv(conv([1 -z],[1 -z]),[1 -z]),[1 -z]);
denAV = conv([1 -p],[1 -p]);                    %conv(conv(conv([1 -p],[1 -p]),[1 -z]),[1 -z]);
FTa = tf(numAV,denAV)*ka;

FTFTa = 1.23*FT*FTa;

figure(2)
margin(FTFTa)

%% Retard de phase
[numkpos denkpos] = tfdata(FTFTa,'v');
erp = 0.0004;
kposdes = 1/erp -1;
kpos = numkpos(end)/denkpos(end);
kdes = kposdes/kpos;   % gain negatif pas normal!!!
Tre = 10/wgdes;
zre = -1/Tre;
pre = -1/(kdes*Tre);
numRE = [1 -zre];
denRE = [1 -pre];
FTe = tf(numRE,denRE);









