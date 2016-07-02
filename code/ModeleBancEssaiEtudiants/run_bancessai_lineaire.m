clc; clear; close all; 
% Initialisation des matrices --------------------------------------------- 
equilibre 

% Simulink ----------------------------------------------------------------
U = double([Va, Vb, Vc]);
xi = zeros(1,13); 
open_system('simul_lineaire')
sim('simul_lineaire') 
