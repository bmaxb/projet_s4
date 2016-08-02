% Projet S4
% Equipe P5
clc;
clear all;
close all;

Ni = [0 5; 2 8; 3 10; 4 13; 5 17];
v_ab = 5;
Ts = 0.01;

[Pi Ltr E Vr Traj tt Tab_banc_essai] = trajectoireCorrigé(Ni, v_ab, Ts);
