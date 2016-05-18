%% Variables d'états de la plaque (position) 
clc;
clear all;
close all;
% Variables d'états
syms zd real       % pour forcer le symbolique en nombre réel
syms ze real
syms zf real

r=0.0952;

Tabc = [0,(r*cos(30)),(-r*cos(30));
        -r,(r*sin(30)),(r*sin(30));
        1,1,1]
Y = Tabc';
X = [zd,ze,zf]';
Z = inv(Y)*X
Z1 = vpa(Z)
              % simplification en un terme simple pour chaque variable


