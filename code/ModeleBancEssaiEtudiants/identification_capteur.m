% Projet S4
% Equipe P5
clc
clear all
close all

% Load des données
load('capteur.mat')

N = length(distance);

% Graphique des données
figure
plot(voltage,distance)

%% Approximation 1
% voltage = voltage(1:end-1);
% distance = distance(1:end-1);

K31 = 0.033;

% Forme linéaire
Y1 = distance - K31;
X1 = (K31 - distance).*voltage;

% Moindres carrés
A1 = [N sum(X1) ; sum(X1) sum(X1.^2)];
B1 = [sum(Y1) ; sum(X1.*Y1)];

coef1 = inv(A1)*B1;

% Valeurs de b et m
b1 = coef1(1);
m1 = coef1(2);

% Valeur de alpha et beta
K11 = 1/m1;
K21 = b1/m1;

% Calcul de R^2 et RMS du linéaire
Y21 = m1*X1 + b1;

R1 = sum((Y21 - mean(Y1)).^2)/sum((Y1 - mean(Y1)).^2);
RMS1 = rms(Y21-Y1);

% Calcul de R^2 et RMS de l'approximation 
distance21 = K31 + K21./(K11 + voltage);

RMS_abs1 = rms(distance - distance21)
RMS_rel1 = rms((distance - distance21)./distance);

% Graphique de l'approximation
figure
plot(voltage, distance, '.')
hold on
plot(voltage, distance21, 'r')

%% Approximation 2
% voltage = voltage(1:end-1);
% distance = distance(1:end-1);

K32 = 2.6;

% Forme linéaire
Y2 = distance;
X2 = exp(K32*voltage);

% Moindres carrés
A2 = [N sum(X2) ; sum(X2) sum(X2.^2)];
B2 = [sum(Y2) ; sum(X2.*Y2)];

coef2 = inv(A2)*B2;

% Valeurs de b et m
b2 = coef2(1);
m2 = coef2(2);

% Valeur de alpha et beta
K22 = m2;
K12 = b2;

% Calcul de R^2 et RMS du linéaire
Y22 = m2*X2 + b2;

R2 = sum((Y22 - mean(Y2)).^2)/sum((Y2 - mean(Y2)).^2);
RMS2 = rms(Y22-Y2);

% Calcul de R^2 et RMS de l'approximation 
distance22 = K12 + K22*exp(K32*voltage);

RMS_abs2 = rms(distance - distance22)
RMS_rel2 = rms((distance - distance22)./distance);

% Graphique de l'approximation
figure
plot(voltage, distance, '.')
hold on
plot(voltage, distance22, 'r')

%% Approximation 3
% voltage = voltage(1:end-1);
% distance = distance(1:end-1);

K33 = 5.5;

% Forme linéaire
Y3 = distance;
X3 = voltage.^K33;

% Moindres carrés
A3 = [N sum(X3) ; sum(X3) sum(X3.^2)];
B3 = [sum(Y3) ; sum(X3.*Y3)];

coef3 = inv(A3)*B3;

% Valeurs de b et m
b3 = coef3(1);
m3 = coef3(2);

% Valeur de alpha et beta
K23 = m3;
K13 = b3;

% Calcul de R^2 et RMS du linéaire
Y23 = m3*X3 + b3;

R3 = sum((Y23 - mean(Y3)).^3)/sum((Y3 - mean(Y3)).^2);
RMS3 = rms(Y23-Y3);

% Calcul de R^2 et RMS de l'approximation 
distance23 = K13 + K23*voltage.^K33;

RMS_abs3 = rms(distance - distance23)
RMS_rel3 = rms((distance - distance23)./distance);

% Graphique de l'approximation
figure
plot(voltage, distance, '.')
hold on
plot(voltage, distance23, 'r')