clc;
clear all;
close all;
load('trajectoire.mat')
format long g
Ni = [0 5; 2 8; 3 10; 4 13; 5 17];
v_ab = 5;


[Pi Ltr E Vr Traj tt Tab_banc_essai] = trajectoire(NBA, vBA, Ts);

[Pi Ltr E Vr Traj tt Tab_banc_essai] = trajectoire(NAB, vAB, Ts);

csvwrite('Coordinates.csv', Traj);
