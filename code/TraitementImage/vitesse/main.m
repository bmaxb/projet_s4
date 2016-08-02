% Projet S4
% Equipe P5
clc;
close all;

Fe = 30;
ordre = 6;
positions = [0, 0;
             0, 0.0011;
             0, 0.0044;
             0, 0.01;
             0, 0.0178;
             0, 0.028;
             0, 0.04;
             0, 0.05444;
             0, 0.071;
             0, 0.09;
             0, 0.111;];
vitesse(Fe, positions, ordre);