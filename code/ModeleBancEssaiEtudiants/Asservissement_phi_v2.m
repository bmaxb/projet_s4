Decouplage
clc;
close all;
figure,
rlocus(Gp_phi)
[numphi, denphi]=tfdata(Gp_phi,'v');


%% FTBO
Gs = Gp_phi;

%% Déclaration des spec
Mp_des = 0.05;
tr_des = 0.02;
tp_des = 0.025;
ts_des = 0.03;

%% a) Traduction des spec
phi_des = atan(-pi/log(Mp_des));
z_des = cos(phi_des);
wn_des(1) = (1+1.1*z_des+1.4*z_des^2)/tr_des;
wn_des(2) = pi/tp_des/sqrt(1-z_des^2);
wn_des(3) = 4/ts_des/z_des;
wn_des = max(wn_des);
wa_des = wn_des*sqrt(1-z_des^2);

% Pôles désirés
s_des(1) = -wn_des*z_des + wa_des*1i;
s_des(2) = -wn_des*z_des - wa_des*1i;

%% AvPh
% Lieu des racines de la FT originale
figure
rlocus(Gs)
hold on
plot(s_des,'p')
axis('auto')
title('Lieu des racines de la FT originale avec les pôles désirés')
legend('FT originale','Pôles désirés')

% Calcul pour l'AvPh
phase_des = angle(evalfr(Gs,s_des(1)))*180/pi - 360;

delta_phi = (-180 - phase_des) +12;
delta_phi1=delta_phi/2;
delta_phi2=delta_phi-delta_phi1;

alpha=180-acosd(z_des);

phiz1=(alpha+delta_phi1)/2;
phip1=(alpha-delta_phi1)/2;

phiz2=(alpha+delta_phi2)/2;
phip2=(alpha-delta_phi2)/2;

z_a1=real(s_des(1))-imag(s_des(1))/tand(phiz1);
p_a1=real(s_des(1))-imag(s_des(1))/tand(phip1);

z_a2=real(s_des(1))-imag(s_des(1))/tand(phiz2);
p_a2=real(s_des(1))-imag(s_des(1))/tand(phip2);

num_a1 = [1 -z_a1];
den_a1 = [1 -p_a1];
G_a1 = tf(num_a1, den_a1);

num_a2 = [1 -z_a2];
den_a2 = [1 -p_a2];
G_a2 = tf(num_a2, den_a2);

G_a = G_a1*G_a2;

Ka = 1/abs(evalfr(G_a,s_des(1))*evalfr(Gs,s_des(1)));

G_a = Ka*G_a;

% Lieu des racines de la FT avec AvPh
r = rlocus(Gs*G_a,1);
figure 
rlocus(Gs*G_a)
hold on 
plot(s_des,'s')
plot(r,'r.')
axis('auto')

% Réponse à un échelon unitaire
figure
step(feedback(Gs*G_a,1))
s = stepinfo(feedback(Gs*G_a,1))

figure
margin(Gs*G_a)

%% PI
% Calcul pour PI
z_PI = real(s_des(1))/10;

num_PI = [1 -z_PI];
den_PI = [1 0];
G_PI = tf(num_PI, den_PI);

KP = 1/abs(evalfr(G_PI*Gs*G_a,s_des(1)));

num_PI = KP*num_PI;
G_PI = KP*G_PI;

K = 1;

% Ajout du retard de phase dans le lieu des racines
r = rlocus(K*Gs*G_a*G_PI,1);
figure
rlocus(K*Gs*G_a*G_PI)
hold on
plot(r,'r.')
plot(s_des,'s')
title('Lieu des racines de la FT avec a et avec PI')
legend('FT avec a','Pôles désirés','Pôles avec retour unitaire','FT avec a et PI')

% Réponse à un échelon unitaire
figure
step(feedback(K*Gs*G_a*G_PI,1))

s = stepinfo(feedback(K*Gs*G_a*G_PI,1))

figure
margin(K*Gs*G_a*G_PI)

p_a1
p_a2
max(abs(real(r)))

testdiscret(K*G_a*G_PI)

